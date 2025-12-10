#!/bin/bash
# Start docker services specified in .services file
# Usage: ./start.sh [services...]
#   Without arguments: starts services listed in .services file
#   With arguments: starts specified services (ignores .services file)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found."
    echo "Please run ./init_env.sh first to initialize the environment."
    exit 1
fi

# Source environment
source ./setenv.sh

# Determine which services to start
if [ $# -gt 0 ]; then
    # Use command line arguments
    SERVICES="$*"
else
    # Use .services file
    SERVICES="$SERVICE_LIST"
fi

if [ -z "$SERVICES" ]; then
    echo "No services specified."
    echo ""
    echo "Usage: $0 [services...]"
    echo "  Or add services to .services file (space or newline separated)"
    echo ""
    echo "Available services: mysql postgres mongodb redis ubuntu22 ubuntu24"
    exit 1
fi

echo "Starting services: $SERVICES"
echo ""

# Detect docker compose command
COMPOSE="docker compose"
if ! docker compose version &>/dev/null; then
    echo "Docker Compose plugin not found, trying docker-compose..."
    if command -v docker-compose &>/dev/null; then
        COMPOSE="docker-compose"
    else
        echo "Error: Neither 'docker compose' nor 'docker-compose' found."
        exit 1
    fi
fi

# Build and start services
$COMPOSE build $SERVICES
$COMPOSE up -d $SERVICES

echo ""
echo "Services started successfully!"
echo ""
$COMPOSE ps
