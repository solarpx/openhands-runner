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

This will install the `openhands` command in `/usr/local/sbin`.

## Uninstallation

To uninstall the OpenHands runner:

```bash
sudo make uninstall
```

## Usage

Once installed, you can run OpenHands using the `openhands` command. The following environment variables can be configured:

- `OPENHANDS_LLM_MODEL` - The LLM model to use (defaults to claude-3-7-sonnet-20250219)
- `OPENHANDS_LLM_API_KEY` - Your API key for the LLM service
- `OPENHANDS_LLM_BASE_URL` - The base URL for the LLM API
- `WORKSPACE_BASE` - Path to your local workspace (optional)

### Example Usage

Run with GitHub integration (UI mode):
```bash
openhands
```

Run with local workspace:
```bash
WORKSPACE_BASE=/path/to/your/workspace openhands
```

## Available LLM Models

The default model is `claude-3-7-sonnet-20250219`. You can specify a different model using the `OPENHANDS_LLM_MODEL` environment variable.

Supported providers:
- Anthropic Claude models
- OpenAI GPT models
- Azure OpenAI (requires Azure configuration)
- Local models (through Ollama configuration)

Check the [OpenHands documentation](https://docs.all-hands.dev) for the most up-to-date list of supported models.