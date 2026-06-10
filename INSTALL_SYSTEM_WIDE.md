# System-Wide Installation Guide

Install the Developer Shell as a system-wide command accessible from anywhere.

---

## Quick Install

```bash
cd /home/viraj/.gitclonefolders/codeshell
bash install.sh
```

After installation, you can run:
```bash
codeshell
```

From any directory!

---

## Installation Details

### What Gets Installed

The `install.sh` script:

1. **Creates a virtual environment** with system package access
2. **Creates an executable wrapper** at `/usr/local/bin/codeshell`
3. **Links to your project** so updates are automatic

### Installation Locations

- **Binary:** `/usr/local/bin/codeshell` (or custom `$INSTALL_DIR`)
- **Virtual Env:** `./venv/` (in project directory)
- **Project Files:** Stay in `/home/viraj/.gitclonefolders/codeshell`

### Permissions

- If you don't have write access to `/usr/local/bin`, the script uses `sudo`
- No system-wide Python packages are installed
- Everything stays in your project directory

---

## Usage After Installation

### Run from Anywhere
```bash
# From any directory
codeshell

# With options
codeshell --model qwen:7b
codeshell --host http://localhost:11434
```

### Finding the Installation
```bash
which codeshell          # Show path
codeshell --help         # Show help
```

---

## Custom Installation Directory

Install to a custom location:

```bash
cd /home/viraj/.gitclonefolders/codeshell
INSTALL_DIR=~/.local/bin bash install.sh
```

Make sure the directory is in your PATH:
```bash
echo $PATH
# If not present, add to ~/.bashrc or ~/.zshrc:
export PATH="~/.local/bin:$PATH"
```

---

## Uninstall

Remove the system-wide command:

```bash
cd /home/viraj/.gitclonefolders/codeshell
bash uninstall.sh
```

Or manually:
```bash
rm /usr/local/bin/codeshell
```

The project files remain in place.

---

## Troubleshooting

### "codeshell: command not found"

Check if it's installed:
```bash
ls -la /usr/local/bin/codeshell
```

If not, run install again:
```bash
cd /home/viraj/.gitclonefolders/codeshell
bash install.sh
```

### PATH Issues

After installation, if `codeshell` still isn't found:

```bash
# Add to your shell profile
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
# or for zsh:
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc

# Then reload:
source ~/.bashrc  # or source ~/.zshrc
```

### Permission Denied

If you get permission errors during installation:

```bash
# Try with explicit sudo
sudo bash install.sh

# Or install to user directory
INSTALL_DIR=~/.local/bin bash install.sh
```

### Still not working?

Run the project directly:
```bash
cd /home/viraj/.gitclonefolders/codeshell
./run.sh
```

---

## Development & Updates

After installation, any changes to the project files are immediately available:

```bash
# Edit files
vim /home/viraj/.gitclonefolders/codeshell/shell.py

# Changes take effect immediately
codeshell
```

---

## Integration Examples

### Alias in Shell Profile
```bash
# ~/.bashrc or ~/.zshrc
alias cs='codeshell'
alias cs-dev='codeshell --host http://localhost:11434'
```

### Shell Function
```bash
# ~/.bashrc or ~/.zshrc
developer-shell() {
    ollama serve &
    sleep 2
    codeshell "$@"
}
```

### Systemd Service (Advanced)

Create `/etc/systemd/user/codeshell.service`:
```ini
[Unit]
Description=Ollama Developer Shell
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/codeshell
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

---

## Workflow After Installation

### Standard Workflow
```bash
# Terminal 1: Start Ollama
ollama serve

# Terminal 2: Run shell from anywhere
codeshell

# Terminal 3: Run other commands
python3 myproject/main.py
```

### With Alias
```bash
# ~/.zshrc
alias dshell='codeshell'
```

Then:
```bash
dshell
```

---

## Notes

- **Virtual Environment** - The wrapper automatically activates it
- **Python Version** - Uses the Python 3 from your system
- **System Packages** - Has access to system-installed Python packages like `requests`
- **Isolation** - Project dependencies don't affect system Python
- **Portability** - The project can be moved; the symlink still works
- **Uninstall** - Just run `bash uninstall.sh`; project stays intact

---

## System Requirements

- Python 3.8+
- Bash/Zsh shell
- Write access to `/usr/local/bin` (or alternative directory)
- Ollama (run in separate terminal)

---

For more help, see:
- [README.md](README.md) - Full documentation
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [SETUP_WITHOUT_PIP.md](SETUP_WITHOUT_PIP.md) - Detailed environment setup
