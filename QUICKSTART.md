# 🚀 Quick Start Guide

## One-Minute Setup

### 1. Install Ollama (if not already installed)

```bash
# macOS
brew install ollama

# Linux  
curl https://ollama.ai/install.sh | sh

# Or download from https://ollama.ai
```

### 2. Create Virtual Environment & Setup

```bash
cd /path/to/codeshell
bash setup.sh
```

This will create a virtual environment with system packages access.

### 3. Activate Virtual Environment

```bash
source venv/bin/activate
```

### 4. Start Ollama Server (in Terminal 1)

```bash
ollama serve
```

### 5. Run the Developer Shell (in Terminal 2)

```bash
source venv/bin/activate
python shell.py
```

That's it! 🎉

---

## Complete Setup with Script

```bash
# Run quickstart (handles virtual env + Ollama check)
./quickstart.sh

# Or setup manually then run
bash setup.sh
source venv/bin/activate
python shell.py

# Or use Makefile
make setup
source venv/bin/activate
make run
```

---

## First Steps in the Shell

### 1. Check Available Models
```
You: /models
```

### 2. Ask for Help
```
You: /help
```

### 3. Get AI Assistance
```
You: How do I write a binary search in Python?
Assistant: [Detailed explanation with code examples]
```

### 4. Execute System Commands
```
You: /run python3 --version
```

### 5. Clear History
```
You: /clear
```

---

## Common Commands Cheat Sheet

| Command | Purpose |
|---------|---------|
| `/help` | Show available commands |
| `/run ls` | Execute shell command |
| `/history` | View chat history |
| `/clear` | Clear conversation |
| `/models` | List available models |
| `/pull qwen:7b` | Download a model |
| `/model qwen:7b` | Switch models |
| `/exit` | Exit the shell |

---

## Troubleshooting

### "Cannot connect to Ollama"
```bash
# Make sure Ollama is running in another terminal
ollama serve
```

### "Model not found"
```bash
# Pull the model first
ollama pull qwen:latest
```

### Slow responses
- Try a smaller model: `ollama pull phi:latest`
- Use GPU acceleration if available
- Check your internet (for model download)

---

## Next Steps

- 📖 Read [README.md](README.md) for detailed documentation
- 🔧 Edit [config.py](config.py) for customization
- 🎯 Check [examples.md](examples.md) for more use cases
- 🛠️ Review [Makefile](Makefile) for available automation

---

## System Requirements

- ✅ Python 3.8+
- ✅ Ollama (latest version)
- ✅ 4GB+ RAM (8GB recommended)
- ✅ 10GB+ disk space (for models)

---

**Ready to code?** Start with:
```bash
source venv/bin/activate
python shell.py
```

Ask the Qwen model anything about programming, debugging, or development!
