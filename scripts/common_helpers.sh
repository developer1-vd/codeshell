#!/bin/bash
# Common shell helpers for DevShell scripts
# Export OS, DEFAULT_DIR, DEFAULT_CONFIG_DIR for use in other scripts

set -euo pipefail

# Detect OS
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

# Set install directory defaults
case "$OS" in
  macOS|BSD) DEFAULT_DIR="/usr/local/bin" ;;
  Windows) DEFAULT_DIR="$HOME/bin" ;;
  WSL|Linux) DEFAULT_DIR="$HOME/.local/bin" ;;
  *) DEFAULT_DIR="$HOME/.local/bin" ;;
esac

# Set config directory defaults
case "$OS" in
  macOS)
    if [ -n "${XDG_CONFIG_HOME:-}" ]; then
      DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/devshell"
    else
      DEFAULT_CONFIG_DIR="$HOME/Library/Application Support/devshell"
    fi
    ;;
  BSD)
    DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
    ;;
  Windows)
    DEFAULT_CONFIG_DIR="${APPDATA:-$HOME/AppData/Roaming}\\devshell"
    ;;
  WSL|Linux)
    DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
    ;;
  *)
    DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
    ;;
esac

export OS DEFAULT_DIR DEFAULT_CONFIG_DIR
