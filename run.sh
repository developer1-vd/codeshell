#!/bin/bash
# Easy run script - automatically handles virtual environment

set -euo pipefail

# Source OS detection helper if available
if [ -f "$(dirname "$0")/scripts/os_detect.sh" ]; then
    # shellcheck source=/dev/null
    . "$(dirname "$0")/scripts/os_detect.sh"
fi

cd "$(dirname "$0")" || exit 1

# Prefer python3, fallback to python
PYTHON_CMD=python3
if ! command -v "$PYTHON_CMD" &> /dev/null; then
        PYTHON_CMD=python
fi

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    "$PYTHON_CMD" -m venv venv --system-site-packages
fi

# Activate and run
source venv/bin/activate
exec "$PYTHON_CMD" shell.py "$@"
