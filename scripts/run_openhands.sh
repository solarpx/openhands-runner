#!/usr/bin/env bash
set -eo pipefail

# Default versions
OPENHANDS_VERSION="0.27"
RUNTIME_VERSION="0.27-nikolaik"

# Default configuration
DEFAULT_PORT=3000
PORT=${PORT:-$DEFAULT_PORT}

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Run OpenHands AI development environment.

Options:
    -h, --help              Show this help message
    -v, --version VERSION   Use specific OpenHands version (default: ${OPENHANDS_VERSION})
    -p, --port PORT        Set web UI port (default: ${DEFAULT_PORT})
    -w, --workspace DIR    Set workspace directory (default: current directory)
    --no-pull             Skip pulling latest Docker images
    --debug               Enable debug mode

Environment variables:
    OPENHANDS_LLM_MODEL     LLM model to use (required)
    OPENHANDS_LLM_API_KEY   API key for LLM service (required)
    OPENHANDS_LLM_BASE_URL  Base URL for LLM API
    WORKSPACE_BASE          Workspace directory (can also use -w option)
    LLM_NUM_RETRIES        Number of API retry attempts (default: 4)
    LLM_RETRY_MIN_WAIT     Minimum wait between retries in seconds (default: 5)
    LLM_RETRY_MAX_WAIT     Maximum wait between retries in seconds (default: 30)
    LLM_RETRY_MULTIPLIER   Backoff multiplier for retries (default: 2)

Examples:
    # Run with default settings
    $(basename "$0")

    # Run with specific workspace
    $(basename "$0") -w /path/to/project

    # Run with specific version
    $(basename "$0") -v 0.26
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            OPENHANDS_VERSION="$2"
            RUNTIME_VERSION="${2}-nikolaik"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -w|--workspace)
            WORKSPACE_BASE="$2"
            shift 2
            ;;
        --no-pull)
            NO_PULL=1
            shift
            ;;
        --debug)
            set -x
            shift
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check Docker is available
if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

# Set workspace to current directory if not specified
if [ -z "$WORKSPACE_BASE" ]; then
    WORKSPACE_BASE=$(pwd)
    echo "📂 Using current directory as workspace: $WORKSPACE_BASE"
fi

# Validate workspace directory
if [ ! -d "$WORKSPACE_BASE" ]; then
    echo "❌ Workspace directory does not exist: $WORKSPACE_BASE"
    exit 1
fi

# Check required environment variables
if [ -z "$OPENHANDS_LLM_API_KEY" ]; then
    echo "❌ OPENHANDS_LLM_API_KEY is required"
    exit 1
fi

# Set default model if not specified
if [ -z "$OPENHANDS_LLM_MODEL" ]; then
    OPENHANDS_LLM_MODEL="claude-3-5-sonnet-20241022"
    echo "ℹ️  Using default model: $OPENHANDS_LLM_MODEL"
fi

# Set default base URL if not specified
if [ -z "$OPENHANDS_LLM_BASE_URL" ]; then
    OPENHANDS_LLM_BASE_URL="https://api.anthropic.com/v1"
    echo "ℹ️  Using default API URL: $OPENHANDS_LLM_BASE_URL"
fi

# Pull latest images unless --no-pull specified
if [ -z "$NO_PULL" ]; then
    echo "🔄 Pulling latest Docker images..."
    docker pull docker.all-hands.dev/all-hands-ai/runtime:${RUNTIME_VERSION}
    docker pull docker.all-hands.dev/all-hands-ai/openhands:${OPENHANDS_VERSION}
fi

# Check if port is already in use
if lsof -i ":${PORT}" >/dev/null 2>&1; then
    echo "❌ Port ${PORT} is already in use"
    echo "💡 Try using a different port with: openhands -p <port>"
    exit 1
fi

echo "🚀 Starting OpenHands v${OPENHANDS_VERSION}..."
echo "📂 Workspace: $WORKSPACE_BASE"
echo "🌐 Web UI: http://localhost:${PORT}"

# Run OpenHands
docker run -it --rm \
    ${NO_PULL:+--pull=never} \
    -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:${RUNTIME_VERSION} \
    -e LOG_ALL_EVENTS=true \
    -e SANDBOX_USER_ID=$(id -u) \
    -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -e OPENHANDS_LLM_MODEL \
    -e OPENHANDS_LLM_API_KEY \
    -e OPENHANDS_LLM_BASE_URL \
    -e LLM_NUM_RETRIES \
    -e LLM_RETRY_MIN_WAIT \
    -e LLM_RETRY_MAX_WAIT \
    -e LLM_RETRY_MULTIPLIER \
    -v "$WORKSPACE_BASE:/opt/workspace_base" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.openhands-state:/.openhands-state \
    -p "${PORT}:3000" \
    --add-host host.docker.internal:host-gateway \
    --name "openhands-app-${PORT}" \
    docker.all-hands.dev/all-hands-ai/openhands:${OPENHANDS_VERSION}

# Handle exit
cleanup() {
    echo -e "\n👋 Shutting down OpenHands on port ${PORT}..."
    docker stop "openhands-app-${PORT}" >/dev/null 2>&1 || true
}
trap cleanup EXIT
