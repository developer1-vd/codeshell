#!/bin/bash
# Developer Shell Launcher for Qwen Ollama Model

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_CMD=${PYTHON_CMD:-python3}

# Check if Python is installed
if ! command -v $PYTHON_CMD &> /dev/null; then
    echo "Error: Python 3 is not installed"
    exit 1
fi

# Check if requests library is installed
$PYTHON_CMD -c "import requests" 2>/dev/null || {
    echo "Installing required dependencies..."
    $PYTHON_CMD -m pip install requests -q
}

# Run the shell
$PYTHON_CMD "$SCRIPT_DIR/shell.py" "$@"
