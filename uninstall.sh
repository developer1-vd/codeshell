#!/bin/bash
# Uninstall Developer Shell from system

set -e

INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

echo "=========================================="
echo "Developer Shell - Uninstall"
echo "=========================================="
echo ""

# Check if installed
if [ ! -f "$INSTALL_DIR/codeshell" ]; then
    echo "❌ 'codeshell' not found in $INSTALL_DIR"
    echo "Nothing to uninstall"
    exit 0
fi

# Check write permission
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Removing with sudo..."
    SUDO="sudo"
else
    SUDO=""
fi

echo "Removing $INSTALL_DIR/codeshell..."
$SUDO rm -f "$INSTALL_DIR/codeshell"

if [ ! -f "$INSTALL_DIR/codeshell" ]; then
    echo "✅ Successfully uninstalled"
    echo ""
    echo "The project files remain in:"
    echo "   $(pwd)"
else
    echo "❌ Failed to remove 'codeshell'"
fi

echo ""
