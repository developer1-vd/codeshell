#!/bin/bash
# Quick start script for the Developer Shell

set -e

echo "🚀 Developer Shell - Quick Start"
echo "================================"
echo ""

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama not found. Install from https://ollama.ai"
    exit 1
fi

echo "✅ Ollama found"

# Check if Ollama is running
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo ""
    echo "⚠️  Ollama is not running"
    echo "Start it in another terminal with: ollama serve"
    echo ""
    read -p "Start Ollama now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ollama serve &
        sleep 5
    fi
fi

# Create and activate virtual environment if needed
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv --system-site-packages
    echo "✅ Virtual environment created"
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
echo "✅ Setup complete! Starting Developer Shell..."
echo ""

# Start the shell
python shell.py "$@"
