# Ubuntu 24.04 Development Environment
FROM ubuntu:24.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# Install base packages
RUN apt-get update && apt-get install -y \
    # Build tools
    build-essential \
    cmake \
    ninja-build \
    clang \
    clang-format \
    clang-tidy \
    lldb \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Version control
    git \
    # Libraries
    libssl-dev \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    # Utilities
    wget \
    curl \
    sudo \
    vim \
    htop \
    tree \
    unzip \
    zip \
    jq \
    # System info
    tzdata \
    lsb-release \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages (--break-system-packages required for Ubuntu 24.04)
RUN pip3 install --no-cache-dir --break-system-packages \
    PyYAML \
    packaging \
    requests \
    click \
    pytest \
    black \
    flake8 \
    mypy

# Set working directory
WORKDIR /workspace

# Create dev user (handle case where UID 1000 already exists in Ubuntu 24.04)
RUN if id -u 1000 >/dev/null 2>&1; then \
        EXISTING_USER=$(id -nu 1000); \
        echo "Removing existing user with UID 1000: $EXISTING_USER"; \
        userdel -r $EXISTING_USER 2>/dev/null || true; \
    fi && \
    useradd -m -u 1000 -s /bin/bash dev && \
    chown -R dev:dev /workspace && \
    usermod -aG sudo dev && \
    echo "dev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Display versions
RUN echo "=== Build Environment ===" && \
    python3 --version && \
    cmake --version && \
    ninja --version && \
    clang --version | head -1 && \
    clang-format --version

# Default to dev user
USER dev

# Keep container running
CMD ["/bin/bash"]
