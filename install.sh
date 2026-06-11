#!/bin/bash
# Install Developer Shell as a system-wide command

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Auto-detect OS (Linux, macOS, BSD, Windows, WSL)
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

# Set sensible default INSTALL_DIR per OS (preserve user override)
case "$OS" in
    macOS|BSD) DEFAULT_DIR="/usr/local/bin" ;; 
    Windows) DEFAULT_DIR="$HOME/bin" ;;
    WSL|Linux) DEFAULT_DIR="$HOME/.local/bin" ;;
    *) DEFAULT_DIR="$HOME/.local/bin" ;;
esac
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"
VENV_DIR="$PROJECT_ROOT/venv"

echo "=========================================="
echo "Developer Shell - Installation"
echo "=========================================="
echo ""
echo "Project Location: $PROJECT_ROOT"
echo "Install Location: $INSTALL_DIR/codeshell"
echo ""

# Create virtual environment if not exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR" --system-site-packages
    echo "✅ Virtual environment created"
fi

# Create the executable wrapper script (minimal cross-platform)
echo "Creating executable wrapper for OS: $OS..."

# Detect OS and set sensible default if INSTALL_DIR not provided
case "$(uname -s)" in
    Darwin*) DEFAULT_DIR="/usr/local/bin" ;;
    CYGWIN*|MINGW*|MSYS*) DEFAULT_DIR="$HOME/bin" ;;
    *) DEFAULT_DIR="$HOME/.local/bin" ;;
esac
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"

mkdir -p "$INSTALL_DIR" 2>/dev/null || true

# Windows-like: create CMD and PowerShell launchers
if [[ "$OS" == "Windows" ]]; then
    cat > "$INSTALL_DIR/codeshell.cmd" <<'CMD'
@echo off
set PROJECT_ROOT=%~dp0\..
set VENV_DIR=%PROJECT_ROOT%\venv
if not exist "%VENV_DIR%" (
    python -m venv "%VENV_DIR%" --system-site-packages
)
"%VENV_DIR%\Scripts\python.exe" "%PROJECT_ROOT%\shell.py" %*
CMD

        cat > "$INSTALL_DIR/codeshell.ps1" <<'PS1'
$project = Split-Path -Parent $MyInvocation.MyCommand.Definition
$PROJECT_ROOT = Join-Path $project '..'
$VENV = Join-Path $PROJECT_ROOT 'venv'
if (-not (Test-Path $VENV)) {
    python -m venv $VENV --system-site-packages
}
& (Join-Path $VENV 'Scripts\\python.exe') (Join-Path $PROJECT_ROOT 'shell.py') $args
PS1

    chmod +x "$INSTALL_DIR/codeshell.cmd" 2>/dev/null || true
    chmod +x "$INSTALL_DIR/codeshell.ps1" 2>/dev/null || true
    echo "✅ Created: $INSTALL_DIR/codeshell.cmd and $INSTALL_DIR/codeshell.ps1"
else
    # Unix-like launcher (Linux/macOS)
    cat > "$INSTALL_DIR/codeshell" <<'SH'
#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$PROJECT_ROOT/venv"
if [ ! -d "$VENV_DIR" ]; then
    (command -v python3 >/dev/null 2>&1 && python3 -m venv "$VENV_DIR" --system-site-packages) || python -m venv "$VENV_DIR" --system-site-packages
fi
"$VENV_DIR/bin/python" "$PROJECT_ROOT/shell.py" "$@"
SH
    chmod +x "$INSTALL_DIR/codeshell"
    echo "✅ Created: $INSTALL_DIR/codeshell"
fi

echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo ""
echo "Option 1 - Run from project directory:"
echo "  cd $PROJECT_ROOT"
echo "  ./codeshell"
echo ""
echo "Option 2 - Run with full path:"
echo "  $INSTALL_DIR/codeshell"
echo ""
echo "Option 3 - Add to PATH (in ~/.bashrc or ~/.zshrc):"
echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
echo "  Then: codeshell"
echo ""
echo "Next steps:"
echo "1. Start Ollama: ollama serve"
echo "2. Run: $INSTALL_DIR/codeshell"
echo ""
