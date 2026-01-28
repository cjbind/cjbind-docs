#!/bin/bash
set -eo pipefail

show_help() {
  cat << EOF
Usage: install.sh [OPTIONS]

Options:
  -m, --mirror    Use mirror source (gitcode.com)
  -d, --dynamic   Install dynamic build (requires system LLVM, smaller size)
  -h, --help      Show this help message

By default, the static build is installed (includes LLVM, larger size).

Examples:
  ./install.sh              # Install static build from GitHub
  ./install.sh --dynamic    # Install dynamic build from GitHub
  ./install.sh --mirror     # Install static build from mirror
  ./install.sh -d -m        # Install dynamic build from mirror
EOF
  exit 0
}

# Check command line arguments
USE_MIRROR=false
USE_STATIC=true
for arg in "$@"; do
  if [ "$arg" = "--mirror" ] || [ "$arg" = "-m" ]; then
    USE_MIRROR=true
  elif [ "$arg" = "--dynamic" ] || [ "$arg" = "-d" ]; then
    USE_STATIC=false
  elif [ "$arg" = "--help" ] || [ "$arg" = "-h" ]; then
    show_help
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

LINK_TYPE="dynamic"
if [ "$USE_STATIC" = true ]; then
  LINK_TYPE="static"
fi

case "$OS" in
  linux)
    FILENAME="cjbind-linux-$ARCH-$LINK_TYPE"
    info "Linux ($ARCH) system detected" ;;
  darwin)
    [ "$ARCH" = "arm64" ] || error "macOS only supports Apple Silicon (arm64)"
    FILENAME="cjbind-darwin-arm64-$LINK_TYPE"
    info "macOS (Apple Silicon) detected" ;;
  *) error "Unsupported operating system: $OS" ;;
esac

if [ "$USE_STATIC" = true ]; then
  info "Link type: Static (includes LLVM, larger size)"
else
  info "Link type: Dynamic (requires system LLVM, smaller size)"
fi

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