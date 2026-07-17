# Setup Guide for Systems Without pip3

## Problem
Your system uses Void Linux (or similar) which restricts direct pip package installation for system Python.

## Solution
Use Python's built-in `venv` module with `--system-site-packages` flag. This creates an isolated virtual environment that can also access system-installed packages like `requests`.

## Step-by-Step Setup

### 1. Install Ollama
```bash
xbps-install ollama
# or
curl https://ollama.ai/install.sh | sh
```

### 2. Create Virtual Environment
```bash
cd /path/to/codeshell

# Create virtual environment with system packages access
python3 -m venv venv --system-site-packages
```

### 3. Activate Virtual Environment
```bash
source venv/bin/activate

# You should see (venv) in your prompt
# Now you have access to:
# - python (bin/python)
# - pip (bin/pip) - for installing new packages if needed
# - System packages like requests
```

### 4. Verify Setup
```bash
python -c "import requests; print('requests available')"
python shell.py --help
```

### 5. Run the Shell

**Terminal 1** - Start Ollama:
```bash
ollama serve
```

**Terminal 2** - Run the shell:
```bash
cd /path/to/codeshell
source venv/bin/activate
python shell.py
```

## One-Command Setup

If you want the setup script to handle everything:

```bash
bash setup.sh
source venv/bin/activate
```

## Or Use the Run Script

The easiest way - just run:
```bash
./run.sh
```

This automatically creates the venv and activates it every time!

## Project Structure

```
codeshell/
├── run.sh           ← Easy run script (handles venv automatically)
├── shell.py         ← Main shell application
├── config.py        ← Configuration
├── venv/            ← Virtual environment (created by setup)
│   ├── bin/
│   │   ├── python
│   │   ├── pip
│   │   └── ...
│   └── lib/
├── README.md        ← Full documentation
├── QUICKSTART.md    ← Quick start guide
└── Makefile         ← Make commands
```

## Available Commands

```bash
# Easy - automatic venv setup
./run.sh

# Or manual activation then run
source venv/bin/activate
python shell.py

# With options
python shell.py --model qwen:7b
python shell.py --host http://localhost:11434

# Using Makefile
make setup
make run
make clean
make help
```

## Troubleshooting

### "No module named requests"
```bash
# Make sure virtual environment is activated
source venv/bin/activate

# If still missing, try:
pip install requests --break-system-packages
```

### "ollama: command not found"
```bash
# Install Ollama
xbps-install ollama
# or
curl https://ollama.ai/install.sh | sh
```

### "Cannot connect to Ollama"
```bash
# Make sure Ollama is running in another terminal
ollama serve
```

## Notes

- Virtual environment with `--system-site-packages` inherits system Python packages
- This is ideal for Linux distributions with strict package management
- You can still install new packages in the venv if needed: `pip install <package>`
- Use `deactivate` to exit the virtual environment

## Why This Approach?

1. **Respects system package management** - Doesn't bypass Void Linux package manager
2. **Isolated environment** - Keeps project dependencies separate
3. **System package access** - Can use pre-installed packages like requests
4. **Portable** - Works on any Linux system with Python 3.8+
5. **Easy to manage** - Simple `source venv/bin/activate` to use

---

For full documentation, see [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md)
