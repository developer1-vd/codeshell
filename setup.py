#!/usr/bin/env python3
"""
Installation script for Developer Shell
"""

import subprocess
import sys
import os
from pathlib import Path


def run_command(cmd, description=""):
    """Run a shell command"""
    if description:
        print(f"\n📦 {description}...")
    try:
        result = subprocess.run(cmd, shell=True, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {e}")
        return False


def main():
    print("""
╔════════════════════════════════════════════════════════════════╗
║        Developer Shell Setup - Qwen 3.6 Ollama Model          ║
╚════════════════════════════════════════════════════════════════╝
""")

    # Get script directory
    script_dir = Path(__file__).parent

    # Step 1: Install Python dependencies
    print("\n1️⃣  Installing Python dependencies...")
    req_file = script_dir / "requirements.txt"
    if req_file.exists():
        run_command(f"{sys.executable} -m pip install -q -r {req_file}",
                   "Installing packages from requirements.txt")
    else:
        run_command(f"{sys.executable} -m pip install -q requests",
                   "Installing requests library")

    # Step 2: Make shell script executable
    shell_script = script_dir / "shell.sh"
    if shell_script.exists():
        print("\n2️⃣  Making shell script executable...")
        os.chmod(shell_script, 0o755)
        print("✅ shell.sh is now executable")

    # Step 3: Check Ollama installation
    print("\n3️⃣  Checking Ollama installation...")
    if run_command("which ollama > /dev/null 2>&1"):
        print("✅ Ollama is installed")
    else:
        print("⚠️  Ollama not found. Please install it from https://ollama.ai")

    # Step 4: Create convenience script
    print("\n4️⃣  Setting up convenience scripts...")
    
    dev_shell_content = """#!/bin/bash
# Quick launcher for the developer shell
cd "$(dirname "$0")" || exit
python3 shell.py "$@"
"""
    
    dev_shell_file = script_dir / "dev-shell"
    with open(dev_shell_file, "w") as f:
        f.write(dev_shell_content)
    os.chmod(dev_shell_file, 0o755)
    print("✅ Created dev-shell launcher")

    # Summary
    print(f"""
╔════════════════════════════════════════════════════════════════╗
║                    ✅ Setup Complete!                         ║
╚════════════════════════════════════════════════════════════════╝

📚 Quick Start:

1. Start Ollama server (in a new terminal):
   $ ollama serve

2. Start the developer shell:
   $ ./shell.sh
   or
   $ python3 shell.py

3. Type '/help' in the shell for available commands

📖 For more information, see README.md

Happy coding! 🚀
""")


if __name__ == "__main__":
    main()
