#!/usr/bin/env python3
"""
Developer Shell using Qwen Latest Ollama Model
An interactive shell for developers powered by the Qwen model
"""

import json
import subprocess
import sys
import os
import readline
from pathlib import Path
from typing import Optional

try:
    import requests
except ImportError:
    print("Error: requests library not found. Install with: pip install requests")
    sys.exit(1)


class QwenShell:
    def __init__(self, model_name: Optional[str] = None, host: str = "http://localhost:11434"):
        self.model_name = model_name or os.getenv("OLLAMA_MODEL", "qwen:latest")
        self.host = host
        self.chat_history = []
        self.system_prompt = """You are a helpful developer assistant with expertise in:
- Programming and code debugging
- System architecture and design
- DevOps and deployment
- Database design and optimization
- Best practices and code review

Provide clear, concise, and practical responses. Include code examples when relevant.
Keep responses focused and actionable."""

    def check_ollama_connection(self) -> bool:
        """Check if Ollama is running and accessible"""
        try:
            response = requests.get(f"{self.host}/api/tags", timeout=2)
            return response.status_code == 200
        except Exception as e:
            return False

    def list_available_models(self) -> list:
        """List available models in Ollama"""
        try:
            response = requests.get(f"{self.host}/api/tags", timeout=5)
            if response.status_code == 200:
                data = response.json()
                return [model["name"] for model in data.get("models", [])]
        except Exception:
            pass
        return []

    def pull_model(self, model_name: str) -> bool:
        """Pull a model from Ollama registry"""
        try:
            print(f"Pulling model: {model_name}...")
            response = requests.post(
                f"{self.host}/api/pull",
                json={"name": model_name},
                stream=True,
                timeout=None
            )
            for line in response.iter_lines():
                if line:
                    data = json.loads(line)
                    if "status" in data:
                        print(f"  {data['status']}")
            return True
        except Exception as e:
            print(f"Error pulling model: {e}")
            return False

    def query_model(self, user_input: str) -> Optional[str]:
        """Send query to Qwen model via Ollama"""
        try:
            # Add to history
            self.chat_history.append({"role": "user", "content": user_input})

            payload = {
                "model": self.model_name,
                "messages": [{"role": "system", "content": self.system_prompt}] + self.chat_history,
                "stream": False
            }

            response = requests.post(
                f"{self.host}/api/chat",
                json=payload,
                timeout=60
            )

            if response.status_code == 200:
                result = response.json()
                assistant_message = result.get("message", {}).get("content", "")
                self.chat_history.append({"role": "assistant", "content": assistant_message})
                return assistant_message
            else:
                return f"Error: Ollama returned status {response.status_code}"

        except requests.exceptions.Timeout:
            return "Error: Request timed out. The model may be too large or the system is busy."
        except requests.exceptions.ConnectionError:
            return f"Error: Cannot connect to Ollama at {self.host}. Is it running?"
        except json.JSONDecodeError:
            return "Error: Invalid response from Ollama"
        except Exception as e:
            return f"Error: {str(e)}"

    def execute_system_command(self, command: str) -> str:
        """Execute a system command and return output"""
        try:
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=10
            )
            output = result.stdout
            if result.stderr:
                output += f"\nError: {result.stderr}"
            return output
        except subprocess.TimeoutExpired:
            return "Error: Command timed out"
        except Exception as e:
            return f"Error executing command: {str(e)}"

    def handle_special_commands(self, input_text: str) -> Optional[str]:
        """Handle special shell commands"""
        if input_text.startswith("/"):
            command = input_text[1:].strip()

            if command == "help":
                return self.get_help()
            elif command == "history":
                return self.show_history()
            elif command == "clear":
                self.chat_history = []
                return "Chat history cleared."
            elif command == "models":
                models = self.list_available_models()
                return f"Available models:\n" + "\n".join(f"  - {m}" for m in models)
            elif command.startswith("pull "):
                model = command[5:].strip()
                if self.pull_model(model):
                    return f"Model {model} pulled successfully"
                else:
                    return f"Failed to pull model {model}"
            elif command.startswith("model "):
                new_model = command[6:].strip()
                self.model_name = new_model
                return f"Switched to model: {new_model}"
            elif command == "exit" or command == "quit":
                return None
            elif command.startswith("run "):
                cmd = command[4:].strip()
                return self.execute_system_command(cmd)
            else:
                return f"Unknown command: /{command}. Type '/help' for available commands."

        return False

    def get_help(self) -> str:
        """Get help text"""
        return """
Developer Shell - Commands:
  /help              - Show this help message
  /models            - List available Ollama models
  /pull <model>      - Download a model from registry
  /model <name>      - Switch to a different model
  /history           - Show chat history
  /clear             - Clear chat history
  /run <command>     - Execute a system command
  /exit, /quit       - Exit the shell

Regular input is sent to the Qwen model for processing.
Type '/help' anytime for assistance.
"""

    def show_history(self) -> str:
        """Display chat history"""
        if not self.chat_history:
            return "No chat history"

        history_text = "\n" + "="*60 + "\n"
        for msg in self.chat_history:
            role = msg["role"].upper()
            content = msg["content"][:200]
            history_text += f"{role}: {content}...\n" if len(msg["content"]) > 200 else f"{role}: {content}\n"
        history_text += "="*60 + "\n"
        return history_text

    def run(self):
        """Main shell loop"""
        print(f"\n{'='*60}")
        print("🚀 Developer Shell with Qwen Latest via Ollama")
        print(f"{'='*60}")

        # Check Ollama connection
        if not self.check_ollama_connection():
            print(f"\n⚠️  Warning: Cannot connect to Ollama at {self.host}")
            print("Make sure Ollama is running. Start it with: ollama serve")
            response = input("\nContinue anyway? (y/n): ").strip().lower()
            if response != "y":
                sys.exit(1)

        # Check if model is available
        available_models = self.list_available_models()
        if self.model_name not in available_models:
            print(f"\n⚠️  Model '{self.model_name}' not found locally")
            if available_models:
                print(f"Available models: {', '.join(available_models)}")
            response = input(f"Pull model '{self.model_name}'? (y/n): ").strip().lower()
            if response == "y":
                if not self.pull_model(self.model_name):
                    print("Failed to pull model. Exiting.")
                    sys.exit(1)
            else:
                print("Model not available. Exiting.")
                sys.exit(1)

        print(f"\n✅ Using model: {self.model_name}")
        print("Type '/help' for available commands or start chatting!")
        print(f"{'='*60}\n")

        while True:
            try:
                user_input = input("You: ").strip()

                if not user_input:
                    continue

                # Check for special commands
                special_result = self.handle_special_commands(user_input)
                if special_result is None:  # Exit command
                    print("\nGoodbye! 👋")
                    break
                elif special_result is not False:  # Special command was handled
                    print(f"\n{special_result}\n")
                    continue

                # Query the model
                print("\nAssistant: ", end="", flush=True)
                response = self.query_model(user_input)
                if response:
                    print(f"{response}\n")

            except KeyboardInterrupt:
                print("\n\nInterrupted. Type '/exit' to quit or continue.\n")
            except EOFError:
                print("\n\nEnd of input. Exiting.")
                break


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Developer Shell using Qwen Latest Ollama Model"
    )
    parser.add_argument(
        "--model",
        default=os.getenv("OLLAMA_MODEL", "qwen:latest"),
        help="Ollama model name (default: OLLAMA_MODEL env var or qwen:latest)"
    )
    parser.add_argument(
        "--host",
        default="http://localhost:11434",
        help="Ollama server address (default: http://localhost:11434)"
    )

    args = parser.parse_args()

    shell = QwenShell(model_name=args.model, host=args.host)
    shell.run()


if __name__ == "__main__":
    main()
