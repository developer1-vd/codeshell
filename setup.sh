#!/bin/bash
# Setup script for Developer Shell
# This script prepares the development environment

set -euo pipefail

# Source OS detection helper if available
if [ -f "$(dirname "$0")/scripts/os_detect.sh" ]; then
    # shellcheck source=/dev/null
    . "$(dirname "$0")/scripts/os_detect.sh"
fi

echo "================================"
echo "Developer Shell Setup"
echo "================================"
echo ""

# Check Python installation
echo "Checking Python installation..."
PYTHON_CMD=python3
if ! command -v "$PYTHON_CMD" &> /dev/null; then
    if command -v python &> /dev/null; then
        PYTHON_CMD=python
    else
        echo "Python is not installed"
        echo "Please install Python 3.8 or higher"
        exit 1
    fi
fi

python_version=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
echo "Python $python_version found"
echo ""

# Check if requests is available
echo "Checking for Python requests library..."
if $PYTHON_CMD -c "import requests" 2>/dev/null; then
    echo "requests library found"
else
    echo "requests library not found - creating virtual environment with system packages"
    $PYTHON_CMD -m venv venv --system-site-packages
    echo "Virtual environment created"
fi
echo ""

# Check Ollama
echo "Checking Ollama installation..."
if ! command -v ollama &> /dev/null; then
    echo "Ollama is not installed or not in PATH"
    if [ "$OS" = "macOS" ]; then
        echo "Install with Homebrew: brew install ollama"
    elif [ "$OS" = "BSD" ]; then
        echo "Install via package manager, e.g. pkg_add or pkg on your BSD system"
    else
        echo "Please install Ollama from https://ollama.ai"
    fi
    echo "Continuing setup without Ollama checks. You can add it to PATH later."
else
    echo "Ollama is installed"
    ollama_version=$(ollama version 2>/dev/null || echo "unknown")
    echo "   Version: $ollama_version"
fi
echo ""

# Create shell executable
echo "Making shell executable..."
chmod +x shell.py
echo "shell.py is now executable"
echo ""

# Create config directory (OS-aware)
echo "Creating configuration directory..."
if [ -n "$DEFAULT_CONFIG_DIR" ]; then
    mkdir -p "$DEFAULT_CONFIG_DIR" 2>/dev/null || true
    echo "Config directory created at: $DEFAULT_CONFIG_DIR"
else
    mkdir -p "$XDG_CONFIG_HOME"/devshell 2>/dev/null || mkdir -p ~/.config/devshell
    echo "Config directory created at: ${XDG_CONFIG_HOME:-$HOME/.config}/devshell"
fi
echo ""

# Check if running Ollama
if command -v ollama &> /dev/null; then
    echo "Checking if Ollama is running..."
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "Ollama is running"
    else
        echo "Ollama is not currently running"
        echo "Start it with: ollama serve"
    fi
    echo ""
fi

# Setup complete
echo "================================"
echo "Setup Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Activate the virtual environment:"
echo "   source venv/bin/activate"
echo ""
echo "2. Start Ollama (if not already running):"
echo "   ollama serve"
echo ""
echo "3. Run the developer shell:"
echo "   python shell.py"
echo ""
echo "4. (Optional) Install a specific model:"
echo "   ollama pull qwen:latest"
echo ""
echo "For help, run:"
echo "   python shell.py --help"
echo ""
