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

This will install the `openhands` command in `/usr/local/bin`. You can customize the installation directory by setting the `PREFIX` variable:

```bash
sudo make install PREFIX=/opt/local
```

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

- Anthropic:
  - claude-3-7-sonnet-20250219 (newest)
  - claude-3-5-sonnet-20240620
  - claude-3-opus-20240229
  - claude-3-haiku-20240307
- OpenAI: 
  - gpt-4-turbo-preview
  - gpt-4
  - gpt-3.5-turbo
- Azure OpenAI: Requires Azure configuration
- Local: Available through Ollama configuration