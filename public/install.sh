#!/bin/bash
set -eo pipefail

# Check if using mirror source
USE_MIRROR=false
for arg in "$@"; do
  if [ "$arg" = "--mirror" ] || [ "$arg" = "-m" ]; then
    USE_MIRROR=true
    break
  fi
done

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

error() { echo "${RED}Error: $1${RESET}" >&2; exit 1; }
success() { echo "${GREEN}$1${RESET}"; }
info() { echo "${CYAN}▶ $1${RESET}"; }
step() { echo "${YELLOW}[$1/4] $2${RESET}"; }

trap 'printf "\e[0m"' EXIT

step 1 "Fetching latest version"

LATEST_TAG=$(curl -fsS ${GITHUB_TOKEN:+-H "Authorization: token $GITHUB_TOKEN"} \
  https://api.github.com/repos/cjbind/cjbind/releases/latest \
  | grep '"tag_name":' \
  | sed -E 's/.*"([^"]+)".*/\1/') || error "Failed to get latest version"

success "Latest version detected: $LATEST_TAG"

step 2 "Detecting system environment"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)  ARCH="x64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) error "Unsupported architecture: $ARCH" ;;
esac

case "$OS" in
  linux)
    FILENAME="cjbind-linux-$ARCH"
    info "Linux ($ARCH) system detected" ;;
  darwin)
    [ "$ARCH" = "arm64" ] || error "macOS only supports Apple Silicon (arm64)"
    FILENAME="cjbind-darwin-arm64"
    info "macOS (Apple Silicon) detected" ;;
  *) error "Unsupported operating system: $OS" ;;
esac

step 3 "Creating installation directory"
TARGET_DIR="${HOME}/.cjpm/bin"
mkdir -p "$TARGET_DIR" || error "Failed to create directory: $TARGET_DIR"
success "Directory created: ${TARGET_DIR/#$HOME/~}"

step 4 "Downloading program file"
if [ "$USE_MIRROR" = true ]; then
  DOWNLOAD_URL="https://gitcode.com/Cangjie-TPC/cjbind/releases/download/$LATEST_TAG/$FILENAME"
  echo "    Using mirror: ${YELLOW}Yes${RESET}"
else
  DOWNLOAD_URL="https://github.com/cjbind/cjbind/releases/download/$LATEST_TAG/$FILENAME"
  echo "    Using mirror: ${YELLOW}No${RESET}"
fi
echo "    Source URL: ${CYAN}${DOWNLOAD_URL}${RESET}"
echo "    Target path: ${CYAN}${TARGET_DIR/#$HOME/~}/cjbind${RESET}"

if command -v wget &> /dev/null; then
  DOWNLOAD_CMD="wget --progress=bar -O"
elif command -v curl &> /dev/null; then
  DOWNLOAD_CMD="curl -# -L -o"
else
  error "curl or wget required to download files"
fi

$DOWNLOAD_CMD "$TARGET_DIR/cjbind" "$DOWNLOAD_URL" || error "Download failed"

chmod +x "$TARGET_DIR/cjbind"
success "File verification passed ($(file -b "$TARGET_DIR/cjbind" | cut -d ',' -f1))"

echo "${GREEN}=== Installation successful ===${RESET}"
echo "Program installed to: ${CYAN}${TARGET_DIR/#$HOME/~}/cjbind${RESET}"
echo "${YELLOW}Tip: To use globally, add the following path to environment variables:${RESET}"
echo "export PATH=\"\$PATH:$TARGET_DIR\""