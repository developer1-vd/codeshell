#!/usr/bin/env bash
# Install Developer Shell as a system-wide command

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Try to source the project's OS helper if present, otherwise fallback to uname
if [ -f "$PROJECT_ROOT/scripts/os_detect.sh" ]; then
  # shellcheck source=/dev/null
  . "$PROJECT_ROOT/scripts/os_detect.sh"
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
  DEFAULT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
  PKG_HINT="use your system package manager to install required packages"
  export OS DEFAULT_DIR DEFAULT_CONFIG_DIR PKG_HINT
fi

INSTALL_DIR="${INSTALL_DIR:-${DEFAULT_DIR:-$HOME/.local/bin}}"
VENV_DIR="$PROJECT_ROOT/venv"

echo "=========================================="
echo "Developer Shell - Installation"
echo "=========================================="

echo "Project Location: $PROJECT_ROOT"
echo "Install Location: $INSTALL_DIR/codeshell"
echo "Detected OS: ${OS:-Unknown}"
echo ""

# Create virtual environment if not exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    if command -v python3 >/dev/null 2>&1; then
      python3 -m venv "$VENV_DIR" --system-site-packages
    else
      python -m venv "$VENV_DIR" --system-site-packages
    fi
    echo "Virtual environment created"
fi

# Create the executable wrapper script (minimal cross-platform)
echo "Creating executable wrapper for OS: ${OS:-Unknown}..."

mkdir -p "$INSTALL_DIR" 2>/dev/null || true

if [[ "${OS:-}" == "Windows" ]]; then
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
  echo "Created: $INSTALL_DIR/codeshell.cmd and $INSTALL_DIR/codeshell.ps1"
else
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
  echo "Created: $INSTALL_DIR/codeshell"
fi

# macOS-specific extras (installer-level)
if [[ "${OS:-}" == "macOS" ]]; then
  # Optional Homebrew install of Ollama
  if [[ "${DO_BREW:-false}" == "true" ]]; then
    if command -v brew >/dev/null 2>&1; then
      if ! command -v ollama >/dev/null 2>&1; then
        echo "Installing Ollama via Homebrew..."
        brew install ollama || echo "brew install failed; please install Ollama manually"
      else
        echo "Ollama already installed"
      fi
    else
      echo "Homebrew not found; skipping brew install"
    fi
  fi

  if [[ "${INSTALL_LAUNCHAGENT:-false}" == "true" ]]; then
    LAUNCH_DIR="$HOME/Library/LaunchAgents"
    mkdir -p "$LAUNCH_DIR"

    SCRIPTS_DIR="$PROJECT_ROOT/scripts"
    mkdir -p "$SCRIPTS_DIR"
    LAUNCH_WRAPPER="$SCRIPTS_DIR/ollama_launch_wrapper.sh"
    cat > "$LAUNCH_WRAPPER" <<'WR'
#!/usr/bin/env bash
set -e
if command -v ollama >/dev/null 2>&1; then
  exec ollama serve
else
  echo "ollama not found; please install ollama before enabling LaunchAgent" >&2
  exit 1
fi
WR
    chmod +x "$LAUNCH_WRAPPER"

    PLIST_PATH="$LAUNCH_DIR/org.codeshell.ollama.plist"
    cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.codeshell.ollama</string>
  <key>ProgramArguments</key>
  <array>
    <string>$LAUNCH_WRAPPER</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$HOME/Library/Logs/ollama-serve.log</string>
  <key>StandardErrorPath</key>
  <string>$HOME/Library/Logs/ollama-serve.err</string>
</dict>
</plist>
PLIST
    chmod 644 "$PLIST_PATH" 2>/dev/null || true
    echo "Created LaunchAgent at: $PLIST_PATH"
    echo "Load it with: launchctl load ~/Library/LaunchAgents/$(basename \"$PLIST_PATH\")"
  fi
fi

echo "Installation complete!"
echo ""
cat <<USAGE
Usage:

Option 1 - Run from project directory:
  cd $PROJECT_ROOT
  ./codeshell

Option 2 - Run with full path:
  $INSTALL_DIR/codeshell

Option 3 - Add to PATH (in ~/.bashrc or ~/.zshrc):
  export PATH=\"$INSTALL_DIR:\$PATH\"
  Then: codeshell

Next steps:
1. Start Ollama: ollama serve
2. Run: $INSTALL_DIR/codeshell
USAGE

