"""
Configuration for Developer Shell
"""

import os
from pathlib import Path

# Ollama Configuration
OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen:latest")

# Shell Configuration
SHELL_CONFIG_DIR = Path.home() / ".config" / "devshell"
SHELL_HISTORY_FILE = SHELL_CONFIG_DIR / "history"
SHELL_CONFIG_FILE = SHELL_CONFIG_DIR / "config.json"

# Create config directory if it doesn't exist
SHELL_CONFIG_DIR.mkdir(parents=True, exist_ok=True)

# System Prompts
DEVELOPER_PROMPT = """You are a helpful developer assistant with expertise in:
- Programming and code debugging
- System architecture and design
- DevOps and deployment
- Database design and optimization
- Best practices and code review
- Linux/Unix system administration
- Cloud technologies (AWS, GCP, Azure)
- Containerization (Docker, Kubernetes)
- CI/CD pipelines

Provide clear, concise, and practical responses. Include code examples when relevant.
Keep responses focused and actionable. Format code blocks with appropriate language tags."""

CODE_REVIEW_PROMPT = """You are an expert code reviewer. Analyze code for:
- Security vulnerabilities
- Performance issues
- Code quality and maintainability
- Best practices and patterns
- Potential bugs
- Testing coverage

Provide constructive feedback with specific suggestions for improvement."""

DEVOPS_PROMPT = """You are a DevOps specialist with expertise in:
- Infrastructure as Code
- Container orchestration
- CI/CD automation
- Monitoring and logging
- System administration
- Cloud platforms

Provide practical, battle-tested advice for deployment and operations."""

# Available modes
MODES = {
    "developer": DEVELOPER_PROMPT,
    "review": CODE_REVIEW_PROMPT,
    "devops": DEVOPS_PROMPT,
}

# Response settings
RESPONSE_TIMEOUT = 120
COMMAND_TIMEOUT = 30
REQUEST_TIMEOUT = 5

# UI Configuration
SHOW_WELCOME = True
SHOW_STATS = True
