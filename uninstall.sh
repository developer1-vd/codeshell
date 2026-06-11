#!/bin/bash
# Uninstall Developer Shell from system

set -e

UNAME_S="$(uname -s)"
case "$UNAME_S" in
    Darwin*) OS="macOS" ;;
    FreeBSD*|OpenBSD*|NetBSD*) OS="BSD" ;;
    Linux*) 
        if [ -f /proc/version ] && grep -qi microsoft /proc/version 2>/dev/null; then
            OS="WSL"
        else
            OS="Linux"
        fi
        ;;
    CYGWIN*|MINGW*|MSYS*) OS="Windows" ;;
    *) OS="Unknown" ;;
esac

case "$OS" in
    macOS|BSD) DEFAULT_DIR="/usr/local/bin" ;; 
    Windows) DEFAULT_DIR="$HOME/bin" ;;
    WSL|Linux) DEFAULT_DIR="$HOME/.local/bin" ;;
    *) DEFAULT_DIR="$HOME/.local/bin" ;;
esac

INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"

echo "=========================================="
echo "Developer Shell - Uninstall"
echo "=========================================="
echo ""

# Check if installed
removed=0
for f in "$INSTALL_DIR/codeshell" "$INSTALL_DIR/codeshell.cmd"; do
    if [ -f "$f" ]; then
        if [ ! -w "$(dirname "$f")" ]; then
            echo "Removing $f with sudo..."
            sudo rm -f "$f" && removed=$((removed+1)) || true
        else
            echo "Removing $f..."
            rm -f "$f" && removed=$((removed+1)) || true
        fi
    fi
done

if [ $removed -gt 0 ]; then
    echo "✅ Successfully removed $removed launcher(s) from $INSTALL_DIR"
    echo "The project files remain in:"
    echo "   $(pwd)"
else
    echo "❌ No launchers found in $INSTALL_DIR"
fi

echo ""
