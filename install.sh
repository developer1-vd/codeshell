#!/bin/bash
# Install Developer Shell as a system-wide command

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
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

# Create the executable wrapper script
echo "Creating executable wrapper..."

mkdir -p "$INSTALL_DIR" 2>/dev/null || true
cat > "$INSTALL_DIR/codeshell" << WRAPPER
#!/usr/bin/env bash
# Developer Shell launcher installed from $PROJECT_ROOT

PROJECT_ROOT="$PROJECT_ROOT"
VENV_DIR="$PROJECT_ROOT/venv"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR" --system-site-packages
fi

source "$VENV_DIR/bin/activate"
exec "$VENV_DIR/bin/python" "$PROJECT_ROOT/shell.py" "\$@"
WRAPPER
chmod +x "$INSTALL_DIR/codeshell"

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
