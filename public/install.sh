#!/bin/bash
set -e

LATEST_TAG=$(curl -s https://api.github.com/repos/cjbind/cjbind/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="x64" ;;
  aarch64 | arm64) ARCH="arm64" ;;
  *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

case "$OS" in
  linux) FILENAME="cjbind-linux-$ARCH" ;;
  darwin)
    [ "$ARCH" = "arm64" ] || { echo "macOS only supports arm64"; exit 1 }
    FILENAME="cjbind-darwin-arm64" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

TARGET_DIR="${HOME}/.cjpm/bin"
mkdir -p "$TARGET_DIR" || { echo "Failed to create directory"; exit 1; }

echo "Downloading $FILENAME..."
curl -# -L "https://github.com/cjbind/cjbind/releases/download/$LATEST_TAG/$FILENAME" -o "$TARGET_DIR/cjbind" || { echo "Download failed"; exit 1; }

chmod +x "$TARGET_DIR/cjbind"
echo "Installed to $TARGET_DIR/cjbind"