#!/bin/bash
# Source environment variables and service list
# Usage: source ./setenv.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create files if they don't exist
touch "$SCRIPT_DIR/.env"
touch "$SCRIPT_DIR/.services"

# Export environment variables from .env (skip comments and empty lines)
set -a
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$key" ]] && continue
    # Remove leading/trailing whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    [ -n "$key" ] && export "$key=$value"
done < "$SCRIPT_DIR/.env"
set +a

# Export service list
export SERVICE_LIST=$(cat "$SCRIPT_DIR/.services" | tr '\n' ' ' | xargs)
