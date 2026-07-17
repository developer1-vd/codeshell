#!/bin/bash
# Quick start script for the Developer Shell

set -euo pipefail

# Source OS detection helper if available
if [ -f "$(dirname "$0")/scripts/os_detect.sh" ]; then
    # shellcheck source=/dev/null
    . "$(dirname "$0")/scripts/os_detect.sh"
fi

echo "Developer Shell - Quick Start (OS: ${OS:-Unknown})"
echo "================================"
echo ""

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. ${PKG_HINT:-Install from https://ollama.ai}"
    exit 1
fi

echo "Ollama found"

# Check if Ollama is running; do not prompt interactively
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo ""
    echo "Ollama is not running"
    echo "Start it in another terminal with: ollama serve"
    echo ""
fi

# Create and activate virtual environment if needed
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv --system-site-packages
    echo "Virtual environment created"
fi

# Activate virtual environment
source venv/bin/activate

# Check for qwen model
if ! ollama list 2>/dev/null | grep -q "qwen:latest"; then
    echo ""
    echo "Pulling Qwen latest model (this may take a few minutes)..."
    ollama pull qwen:latest
fi

echo ""
echo "Setup complete! Starting Developer Shell..."
echo ""

# Start the shell
python shell.py "$@"
