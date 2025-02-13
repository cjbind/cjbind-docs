#!/bin/bash
set -eo pipefail

if [ -t 1 ]; then
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  CYAN=$(printf '\033[36m')
  RESET=$(printf '\033[0m')
else
  RED=""
  GREEN=""
  YELLOW=""
  CYAN=""
  RESET=""
fi

error() { echo "${RED}错误: $1${RESET}" >&2; exit 1; }
success() { echo "${GREEN}√ $1${RESET}"; }
info() { echo "${CYAN}▶ $1${RESET}"; }
step() { echo "${YELLOW}[$1/4] $2${RESET}"; }

trap 'printf "\e[0m"' EXIT

step 1 "获取最新版本"

LATEST_TAG=$(curl -fsS ${GITHUB_TOKEN:+-H "Authorization: token $GITHUB_TOKEN"} \
  https://api.github.com/repos/cjbind/cjbind/releases/latest \
  | grep '"tag_name":' \
  | sed -E 's/.*"([^"]+)".*/\1/') || error "无法获取最新版本"

success "检测到最新版本: $LATEST_TAG"

step 2 "检测系统环境"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)  ARCH="x64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) error "不支持的架构: $ARCH" ;;
esac

case "$OS" in
  linux)
    FILENAME="cjbind-linux-$ARCH"
    info "检测到 Linux ($ARCH) 系统" ;;
  darwin)
    [ "$ARCH" = "arm64" ] || error "macOS 仅支持 Apple Silicon (arm64)"
    FILENAME="cjbind-darwin-arm64"
    info "检测到 macOS (Apple Silicon)" ;;
  *) error "不支持的操作系统: $OS" ;;
esac

step 3 "创建安装目录"
TARGET_DIR="${HOME}/.cjpm/bin"
mkdir -p "$TARGET_DIR" || error "无法创建目录: $TARGET_DIR"
success "目录已创建: ${TARGET_DIR/#$HOME/~}"

step 4 "下载程序文件"
DOWNLOAD_URL="https://github.com/cjbind/cjbind/releases/download/$LATEST_TAG/$FILENAME"
echo "    源地址: ${CYAN}${DOWNLOAD_URL}${RESET}"
echo "    目标路径: ${CYAN}${TARGET_DIR/#$HOME/~}/cjbind${RESET}"

if command -v wget &> /dev/null; then
  DOWNLOAD_CMD="wget --progress=bar -O"
elif command -v curl &> /dev/null; then
  DOWNLOAD_CMD="curl -# -L -o"
else
  error "需要 curl 或 wget 来下载文件"
fi

$DOWNLOAD_CMD "$TARGET_DIR/cjbind" "$DOWNLOAD_URL" || error "下载失败"

chmod +x "$TARGET_DIR/cjbind"
success "文件验证通过 ($(file -b "$TARGET_DIR/cjbind" | cut -d ',' -f1))"

echo "\n${GREEN}=== 安装成功 ===${RESET}"
echo "程序已安装到: ${CYAN}${TARGET_DIR/#$HOME/~}/cjbind${RESET}"
echo "${YELLOW}提示: 如需全局使用，请将以下路径添加到环境变量:${RESET}"
echo "export PATH=\"\$PATH:$TARGET_DIR\"\n"