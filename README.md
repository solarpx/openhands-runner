# OpenHands Runner

A simple installer for the OpenHands CLI runner.

## Requirements

- macOS (or Unix-like system)
- Docker
- Make

## Installation

To install the OpenHands runner globally, run:

```bash
sudo make install
```

This will install the `openhands` command in `/usr/local/bin`.

## Uninstallation

To uninstall the OpenHands runner:

```bash
sudo make uninstall
```

## Usage

Once installed, you can run OpenHands using the `openhands` command in any directory. OpenHands will automatically use your current directory as the workspace.

### Configuration

It's recommended to set your default environment variables in your shell's configuration file (e.g. `~/.zshrc` or `~/.bashrc`):

```bash
# OpenHands configuration
export OPENHANDS_LLM_API_KEY="your-api-key"
export OPENHANDS_LLM_MODEL="claude-3-5-sonnet-20241022"  # optional, this is the default
export OPENHANDS_LLM_BASE_URL="https://api.anthropic.com/v1"  # optional, for custom endpoints
```

These defaults can be overridden temporarily when needed:
```bash
# Override model for a specific run
OPENHANDS_LLM_MODEL="gpt-4" openhands

# Use a different API key
OPENHANDS_LLM_API_KEY="alternate-key" openhands
```

### Running Multiple Instances

You can run multiple OpenHands instances simultaneously by specifying different ports:

```bash
# Start first instance (default)
openhands

# Start second instance on alternate port
openhands -p 3001
```

## Available LLM Models

The default model is `claude-3-5-sonnet-20241022`. You can specify a different model using the `OPENHANDS_LLM_MODEL` environment variable.

Supported providers:
- Anthropic Claude models
- OpenAI GPT models
- Azure OpenAI (requires Azure configuration)
- Local models (through Ollama configuration)

Check the [OpenHands documentation](https://docs.all-hands.dev) for the most up-to-date list of supported models.