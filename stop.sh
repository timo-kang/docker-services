#!/bin/bash
# Stop docker services
# Usage: ./stop.sh [services...]
#   Without arguments: stops all running services
#   With arguments: stops specified services

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Source environment if exists
[ -f ./setenv.sh ] && source ./setenv.sh

# Detect docker compose command
COMPOSE="docker compose"
if ! docker compose version &>/dev/null; then
    if command -v docker-compose &>/dev/null; then
        COMPOSE="docker-compose"
    else
        echo "Error: Neither 'docker compose' nor 'docker-compose' found."
        exit 1
    fi
fi

if [ $# -gt 0 ]; then
    echo "Stopping services: $*"
    $COMPOSE stop "$@"
else
    echo "Stopping all services..."
    $COMPOSE down
fi

echo ""
echo "Done!"
