# Developer Shell - Qwen 3.6 Ollama Integration

A powerful interactive shell for developers powered by the Qwen 3.6 model via Ollama. Write code, debug issues, and get instant development advice in your terminal.

## Features

- AI-Powered Assistance: Leverage Qwen 3.6 for coding help, debugging, and architecture discussions
- Conversational Interface: Maintain context across multiple queries
- System Integration: Execute shell commands directly within the shell
- Multiple Modes: Developer, Code Review, and DevOps modes
- Chat History: Track conversation history
- Fast Setup: Simple installation and configuration

**OS Detection and Defaults**

- The project includes a small helper at `scripts/os_detect.sh` which detects the host OS and exports `OS` and `DEFAULT_INSTALL_DIR`.
- Detection covers: `macOS`, `BSD` (Free/Open/NetBSD), `Linux`, `WSL` and `Windows`.
- Default install locations (can be overridden by `INSTALL_DIR` environment variable):
  - macOS / BSD: `/usr/local/bin`
  - Linux / WSL: `$HOME/.local/bin`
  - Windows: `$HOME/bin`
- Scripts such as `install.sh`, `uninstall.sh`, `run.sh`, `setup.sh`, and `quickstart.sh` source this helper when available and expose the `OS` variable for conditional behavior.
 - Default config locations (can be overridden by setting `XDG_CONFIG_HOME` or using environment variables):
   - macOS: `$HOME/Library/Application Support/devshell` (or `$XDG_CONFIG_HOME/devshell` if set)
   - BSD: `$HOME/.config/devshell` (or `$XDG_CONFIG_HOME/devshell`)
   - Linux / WSL: `$XDG_CONFIG_HOME/devshell` or `$HOME/.config/devshell`
   - Windows: `%APPDATA%\devshell`
 - The helper also exports a `PKG_HINT` string with a suggested package-manager command for the detected OS (useful for messages and hints displayed by scripts).

To run the test that validates detection:

```bash
bash tests/test_os_detection.sh
```

CI: A GitHub Actions workflow is included at `.github/workflows/ci.yml` which runs the OS detection test on push and pull requests across Linux, macOS, and Windows.

macOS-specific options:
- To let the installer attempt to install Ollama via Homebrew, run:

```bash
DO_BREW=true bash install.sh
```

- To create a LaunchAgent that starts `ollama serve` at login, run:

```bash
INSTALL_LAUNCHAGENT=true bash install.sh
```

The LaunchAgent will be written to `~/Library/LaunchAgents/org.codeshell.ollama.plist` and can be loaded with:

```bash
launchctl load ~/Library/LaunchAgents/org.codeshell.ollama.plist
```

## Requirements

- Python 3.8+
- Ollama (installed and running)
- 4GB+ RAM (8GB+ recommended)
- 10GB+ disk space for models

## Installation

### Step 1: Install Ollama

Download from [ollama.ai](https://ollama.ai) or:

```bash
# macOS
brew install ollama

# Linux
curl https://ollama.ai/install.sh | sh

# Windows
# Download installer from ollama.ai
```

### Step 2: Setup Developer Shell

```bash
# Navigate to the project directory
cd codeshell

# Run the setup script (creates virtual environment)
bash setup.sh

# Activate the virtual environment
source venv/bin/activate
```

### Step 3: Start Ollama Server

```bash
ollama serve
```

Keep this running in a separate terminal.

### Step 4: Install the `codeshell` command

```bash
bash install.sh
```

If you want to install to a custom location:

```bash
INSTALL_DIR=~/.local/bin bash install.sh
```

Make sure the directory is in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then run:

```bash
codeshell
```

## Interactive Commands

### Help & Information
- `/help` - Display help message
- `/models` - List available Ollama models  
- `/history` - Show chat history

### Model Management
- `/pull <model>` - Download a model
- `/model <name>` - Switch to a different model

### Execution & Control
- `/run <command>` - Execute system commands
- `/clear` - Clear chat history
- `/exit` or `/quit` - Exit the shell

## Using Make Commands

```bash
make setup      # Complete setup (install deps + config)
make install    # Install Python dependencies only
make run        # Run the developer shell
make clean      # Clean cache and temporary files
make lint       # Run code quality checks
make format     # Format code with black
make help       # Show all available commands
```

## Use Cases

### 1. Code Debugging
```
You: Why is my React component re-rendering infinitely?
You: [Paste component code]
```

### 2. Architecture Review
```
You: Is this microservices architecture scalable?
You: [Describe your architecture]
```

### 3. DevOps & Deployment
```
You: How do I set up a CI/CD pipeline with GitHub Actions?
```

### 4. Performance Optimization
```
You: /run python3 profile.py
You: Why is this taking so long?
```

### 5. Learning & Documentation
```
You: Explain how SOLID principles apply to this code:
You: [Paste code]
```

## Configuration

### Environment Variables

```bash
# Set default model
export OLLAMA_MODEL="qwen:latest"

# Set Ollama host
export OLLAMA_HOST="http://localhost:11434"

# Then run the shell
python3 shell.py
```

### Configuration File

Edit `config.py` for permanent settings:

```python
OLLAMA_HOST = "http://localhost:11434"
OLLAMA_MODEL = "qwen:latest"
RESPONSE_TIMEOUT = 120
```

## Troubleshooting

### Connection Error

```
⚠️ Warning: Cannot connect to Ollama at http://localhost:11434
```

**Solution**: Make sure Ollama is running in another terminal:
```bash
ollama serve
```

### Model Not Found

```
⚠️ Model 'qwen:latest' not found locally
```

**Solution**: Download the model:
```bash
ollama pull qwen:latest
```

### Slow Responses

- Increase RAM allocation if available
- Use a GPU-enabled Ollama installation
- Try a smaller model: `ollama pull qwen:2`
- Check disk space (models require 10GB+)

### High Memory Usage

```bash
# Clear chat history to free memory
# Type: /clear

# Or use a smaller model
python3 shell.py --model qwen:2
```

## Development

### Project Structure

```
codeshell/
├── shell.py          # Main shell application
├── config.py         # Configuration settings
├── setup.sh          # Setup script
├── Makefile          # Build automation
├── requirements.txt  # Python dependencies
├── README.md         # This file
├── .gitignore        # Git ignore rules
└── examples.md       # Usage examples
```

### Extending the Shell

Add new commands in `shell.py`:

```python
def handle_special_commands(self, input_text: str) -> Optional[str]:
    if input_text.startswith("/mycommand"):
        # Your implementation here
        return "Result"
```

### Custom Modes

Add new assistant modes in `config.py`:

```python
MODES = {
    "developer": DEVELOPER_PROMPT,
    "review": CODE_REVIEW_PROMPT,
    "custom": "Your custom system prompt here..."
}
```

## Supported Ollama Models

- **Qwen Series** (Recommended)
  - `qwen:latest` - Fast, balanced
  - `qwen:7b` - More powerful
  
- **Mistral Series**
  - `mistral:latest` - High quality
  
- **Llama Series**
  - `llama2:latest` - Meta's model
  - `llama2:13b` - Larger variant
  
- **Other Models**
  - `phi:latest` - Very fast, smaller
  - `neural-chat:latest` - Chat optimized

List local models:
```bash
ollama list
```

## Documentation

- [Ollama Docs](https://github.com/ollama/ollama)
- [Qwen Model Card](https://huggingface.co/Qwen)
- [Python Requests](https://requests.readthedocs.io/)

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Contributions welcome! Areas for enhancement:

- Web UI for the shell
- Better output formatting  
- Response caching
- Integration with IDEs
- Syntax highlighting for code blocks
- Support for multimodal inputs

## Support

For issues and questions:

1. Check the troubleshooting section
2. Verify Ollama is running: `ollama serve`
3. Confirm model is available: `ollama list`
4. Check available disk space
5. Review Ollama logs for errors

---

**Happy coding!** Feel free to customize this shell for your specific needs.
