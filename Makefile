.PHONY: help setup install run clean test lint format test-shell test-all

help:
	@echo "Developer Shell - Available Commands"
	@echo "===================================="
	@echo "make setup        - Complete setup (install deps + config)"
	@echo "make install      - Install Python dependencies"
	@echo "make run          - Run the developer shell"
	@echo "make clean        - Clean cache and temporary files"
	@echo "make lint         - Run code quality checks"
	@echo "make format       - Format code with black"
	@echo "make test         - Run Python tests"
	@echo "make test-shell   - Run shell script tests (OS detection, install, uninstall)"
	@echo "make test-all     - Run all tests"

setup:
	@bash setup.sh

install:
	pip3 install -r requirements.txt

run:
	python3 shell.py

run-debug:
	python3 shell.py --debug

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name ".DS_Store" -delete
	rm -rf build/ dist/ *.egg-info/

lint:
	@command -v pylint >/dev/null 2>&1 || pip3 install pylint
	pylint shell.py config.py

format:
	@command -v black >/dev/null 2>&1 || pip3 install black
	black shell.py config.py

test:
	python3 -m pytest tests/ -v

test-shell:
	@echo "Running shell script tests..."
	@bash tests/test_os_detection.sh
	@bash tests/test_install_dryrun.sh
	@bash tests/test_uninstall.sh

test-all: test test-shell
	@echo "All tests passed!"

.SILENT: help
