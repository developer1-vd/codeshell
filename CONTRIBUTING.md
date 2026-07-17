# Contributing to CodeShell

Thank you for your interest in contributing to CodeShell! We welcome contributions from the community. Please follow these guidelines to ensure a smooth contribution process.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature or fix

```bash
git clone https://github.com/your-username/codeshell.git
cd codeshell
git checkout -b feature/your-feature-name
```

## Development Setup

1. Ensure you have the required dependencies installed
2. Install the project in development mode
3. Run tests to verify setup

```bash
pip install -r requirements.txt
pip install -e .
pytest
```

## Making Changes

- Follow the existing code style and conventions
- Write clear, descriptive commit messages
- Keep changes focused and atomic
- Add tests for new features or bug fixes
- Update documentation as needed

## Testing

Before submitting a pull request, ensure all tests pass:

```bash
pytest
```

Also run any linting tools:

```bash
flake8 .
black --check .
```

## Submitting a Pull Request

1. Push your changes to your fork
2. Create a pull request against the main branch
3. Provide a clear description of the changes
4. Reference any related issues
5. Ensure all CI checks pass

## Code of Conduct

Be respectful and inclusive. We are committed to providing a welcoming and inspiring community.

## Questions?

Feel free to open an issue for questions or suggestions. Thank you for contributing!
