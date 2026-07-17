#!/bin/bash
# Uninstall Developer Shell from system

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Try to source helpers, fallback to inline detection
if [ -f "$PROJECT_ROOT/scripts/common_helpers.sh" ]; then
  # shellcheck source=/dev/null
  . "$PROJECT_ROOT/scripts/common_helpers.sh"
else
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
fi

INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"

echo "=========================================="
echo "Developer Shell - Uninstall"
echo "=========================================="
echo "Detected OS: ${OS:-Unknown}"
echo "Install Location: $INSTALL_DIR"
echo ""

removed=0

# Remove launchers
for f in "$INSTALL_DIR/codeshell" "$INSTALL_DIR/codeshell.cmd" "$INSTALL_DIR/codeshell.ps1"; do
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

# macOS-specific cleanup: remove LaunchAgent and wrapper
if [ "$OS" = "macOS" ]; then
  PLIST_PATH="$HOME/Library/LaunchAgents/org.codeshell.ollama.plist"
  if [ -f "$PLIST_PATH" ]; then
    echo "Removing LaunchAgent: $PLIST_PATH"
    rm -f "$PLIST_PATH" && removed=$((removed+1)) || true
  fi

  WRAPPER_SCRIPT="$PROJECT_ROOT/scripts/ollama_launch_wrapper.sh"
  if [ -f "$WRAPPER_SCRIPT" ]; then
    echo "Removing wrapper script: $WRAPPER_SCRIPT"
    rm -f "$WRAPPER_SCRIPT" && removed=$((removed+1)) || true
  fi
fi

if [ $removed -gt 0 ]; then
  echo ""
  echo "Successfully removed $removed file(s)"
  echo ""
  echo "The project files remain in:"
  echo "   $PROJECT_ROOT"
else
  echo ""
  echo "No installed files found in $INSTALL_DIR"
fi

echo ""
