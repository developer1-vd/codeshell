#!/bin/bash
# Developer Shell Launcher for Qwen Ollama Model

set -e


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Source OS detection helper if available
if [ -f "$SCRIPT_DIR/scripts/os_detect.sh" ]; then
    # shellcheck source=/dev/null
    . "$SCRIPT_DIR/scripts/os_detect.sh"
fi
PYTHON_CMD=${PYTHON_CMD:-python3}

# Fallback to python if python3 not present
if ! command -v "$PYTHON_CMD" &> /dev/null; then
    if command -v python &> /dev/null; then
        PYTHON_CMD=python
    else
        echo "Error: Python is not installed"
        exit 1
    fi
fi

# Warn if requests not installed (don't auto-install)
if ! "$PYTHON_CMD" -c "import requests" 2>/dev/null; then
    echo "Warning: Python 'requests' package not found. Install with: $PYTHON_CMD -m pip install requests"
    if [ -n "$PKG_HINT" ]; then
        echo "System package hint: $PKG_HINT"
    fi
fi

# Run the shell
"$PYTHON_CMD" "$SCRIPT_DIR/shell.py" "$@"
