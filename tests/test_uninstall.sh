#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running uninstall test..."
TMPDIR="$(mktemp -d)"
INSTALL_DIR="$TMPDIR/bin"
mkdir -p "$INSTALL_DIR"

# Install to temp directory
INSTALL_DIR="$INSTALL_DIR" bash install.sh >/dev/null 2>&1 || { echo "install.sh failed"; rm -rf "$TMPDIR"; exit 1; }

# Check launcher was created
if [ ! -f "$INSTALL_DIR/codeshell" ] && [ ! -f "$INSTALL_DIR/codeshell.cmd" ]; then
  echo "Launcher not created before uninstall test"
  rm -rf "$TMPDIR"
  exit 2
fi

# Run uninstall
INSTALL_DIR="$INSTALL_DIR" bash uninstall.sh >/dev/null 2>&1 || { echo "uninstall.sh failed"; rm -rf "$TMPDIR"; exit 3; }

# Check launcher was removed
if [ -f "$INSTALL_DIR/codeshell" ] || [ -f "$INSTALL_DIR/codeshell.cmd" ]; then
  echo "Launcher still exists after uninstall"
  rm -rf "$TMPDIR"
  exit 4
fi

# Cleanup
rm -rf "$TMPDIR"

echo "uninstall test passed"
