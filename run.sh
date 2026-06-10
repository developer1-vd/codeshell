#!/bin/bash
# Easy run script - automatically handles virtual environment

cd "$(dirname "$0")" || exit 1

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv --system-site-packages
fi

# Activate and run
source venv/bin/activate
exec python shell.py "$@"
