#!/bin/bash

# Setup script for Developer Shell
# This script prepares the development environment

set -e

echo "================================"
echo "Developer Shell Setup"
echo "================================"
echo ""

# Check Python version
echo "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    echo "Please install Python 3.8 or higher"
    exit 1
fi

python_version=$(python3 --version | awk '{print $2}')
echo "✅ Python $python_version found"
echo ""

# Check if requests is available
echo "Checking for Python requests library..."
if python3 -c "import requests" 2>/dev/null; then
    echo "✅ requests library found"
else
    echo "⚠️  requests library not found - creating virtual environment with system packages"
    python3 -m venv venv --system-site-packages
    echo "✅ Virtual environment created"
fi
echo ""

# Check Ollama
echo "Checking Ollama installation..."
if ! command -v ollama &> /dev/null; then
    echo "⚠️  Ollama is not installed or not in PATH"
    echo "Please install Ollama from https://ollama.ai"
    echo "Or run: brew install ollama (macOS) or use official installer"
    read -p "Continue without Ollama check? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Ollama is installed"
    ollama_version=$(ollama version 2>/dev/null || echo "unknown")
    echo "   Version: $ollama_version"
fi
echo ""

# Create shell executable
echo "Making shell executable..."
chmod +x shell.py
echo "✅ shell.py is now executable"
echo ""

# Create config directory
echo "Creating configuration directory..."
mkdir -p ~/.config/devshell
echo "✅ Config directory created at ~/.config/devshell"
echo ""

# Check if running Ollama
if command -v ollama &> /dev/null; then
    echo "Checking if Ollama is running..."
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama is running"
    else
        echo "⚠️  Ollama is not currently running"
        echo "Start it with: ollama serve"
    fi
    echo ""
fi

# Setup complete
echo "================================"
echo "✅ Setup Complete!"
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
