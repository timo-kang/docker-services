#!/bin/bash
# Initialize environment for docker-services
# This script generates secure passwords and creates .env file

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if .env already exists
if [ -f .env ]; then
    echo "Error: .env file already exists."
    echo "If you want to reinitialize, please remove .env first."
    exit 1
fi

# Function to generate random password
generate_password() {
    cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 20
}

# Get local IP address
get_local_ip() {
    # Try to get the default route interface
    local route_info
    route_info=$(ip route get 8.8.8.8 2>/dev/null || echo "")

    if [ -n "$route_info" ]; then
        echo "$route_info" | grep -oP 'src \K\S+'
    else
        # Fallback to hostname -I
        hostname -I 2>/dev/null | awk '{print $1}' || echo "127.0.0.1"
    fi
}

echo "Initializing docker-services environment..."

# Generate passwords
MYSQL_ROOT_PASSWORD=$(generate_password)
POSTGRES_PASSWORD=$(generate_password)
MONGO_ROOT_PASSWORD=$(generate_password)
REDIS_PASSWORD=$(generate_password)

# Get local IP
LOCAL_IP=$(get_local_ip)

# Create .env file
cat > .env << EOF
# Docker Services Environment Configuration
# Generated on $(date)

# Service binding host (127.0.0.1 for local only, your IP for network access)
SERVICE_HOST=${LOCAL_IP}

# MySQL Configuration
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=dev

# PostgreSQL Configuration
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_USER=postgres
POSTGRES_DB=dev

# MongoDB Configuration
MONGO_ROOT_USERNAME=admin
MONGO_ROOT_PASSWORD=${MONGO_ROOT_PASSWORD}

# Redis Configuration
REDIS_PASSWORD=${REDIS_PASSWORD}

# Workspace path for Ubuntu containers
WORKSPACE_PATH=./workspace
EOF

# Create .services file with default services
if [ ! -f .services ]; then
    cat > .services << EOF
mysql redis
EOF
fi

# Create workspace directory
mkdir -p workspace

# Update redis.conf with generated password
if [ -f redis/redis.conf ]; then
    sed -i "s/^requirepass .*/requirepass ${REDIS_PASSWORD}/" redis/redis.conf
fi

echo ""
echo "Environment initialized successfully!"
echo ""
echo "=== Generated Credentials ==="
echo "MySQL Root Password:    ${MYSQL_ROOT_PASSWORD}"
echo "PostgreSQL Password:    ${POSTGRES_PASSWORD}"
echo "MongoDB Root Password:  ${MONGO_ROOT_PASSWORD}"
echo "Redis Password:         ${REDIS_PASSWORD}"
echo ""
echo "Service Host: ${LOCAL_IP}"
echo ""
echo "These credentials are saved in .env file."
echo ""
echo "To start services, edit .services file and run: ./start.sh"
echo ""
echo "Available services: mysql postgres mongodb redis ubuntu22 ubuntu24"
