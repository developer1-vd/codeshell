#\!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running install dry-run test..."
TMPDIR="$(mktemp -d)"
INSTALL_DIR="$TMPDIR/bin"
mkdir -p "$INSTALL_DIR"

# Run installer with custom INSTALL_DIR to avoid touching system paths
bash install.sh >/dev/null 2>&1 || { echo "install.sh failed"; rm -rf "$TMPDIR"; exit 1; }

# Now run installer in dry mode to our temp install dir
INSTALL_DIR="$INSTALL_DIR" bash install.sh >/dev/null 2>&1 || { echo "install.sh dry-run failed"; rm -rf "$TMPDIR"; exit 1; }

# Check launcher exists
if [ -f "$INSTALL_DIR/codeshell" ] || [ -f "$INSTALL_DIR/codeshell.cmd" ]; then
  echo "Launcher created in $INSTALL_DIR"
else
  echo "Launcher not found in $INSTALL_DIR"
  rm -rf "$TMPDIR"
  exit 2
fi

# Check venv presence
if [ -d "venv" ]; then
  echo "venv exists"
else
  echo "venv missing"
  rm -rf "$TMPDIR"
  exit 3
fi

# Cleanup
rm -rf "$TMPDIR"

echo "install dry-run test passed"
