#!/usr/bin/env bash
# Lightweight OS detection helper
# Exports: OS, DEFAULT_INSTALL_DIR, DEFAULT_CONFIG_DIR, PKG_HINT


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
  macOS|BSD) DEFAULT_INSTALL_DIR="/usr/local/bin" ;; 
  Windows) DEFAULT_INSTALL_DIR="$HOME/bin" ;;
  WSL|Linux) DEFAULT_INSTALL_DIR="$HOME/.local/bin" ;;
  *) DEFAULT_INSTALL_DIR="$HOME/.local/bin" ;;
esac

# Default config directory per OS
case "$OS" in
  macOS)
    if [ -n "$XDG_CONFIG_HOME" ]; then
      DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/devshell"
    else
      DEFAULT_CONFIG_DIR="$HOME/Library/Application Support/devshell"
    fi
    PKG_HINT="brew install <pkg>"
    ;;
  BSD)
    if [ -n "$XDG_CONFIG_HOME" ]; then
      DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/devshell"
    else
      DEFAULT_CONFIG_DIR="$HOME/.config/devshell"
    fi
    PKG_HINT="pkg install <pkg> (or pkg_add on older BSDs)"
    ;;
  Windows)
    DEFAULT_CONFIG_DIR="$APPDATA\\devshell"
    PKG_HINT="choco install <pkg> or winget install <pkg>"
    ;;
  WSL|Linux)
    DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
    PKG_HINT="sudo apt install <pkg> or use your distro package manager"
    ;;
  *)
    DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
    PKG_HINT="use your system package manager to install required packages"
    ;;
esac

export OS
export DEFAULT_INSTALL_DIR
export DEFAULT_CONFIG_DIR
export PKG_HINT

return 0
