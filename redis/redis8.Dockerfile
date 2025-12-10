FROM redis:8.0-bookworm

# Create necessary directories
RUN mkdir -p /data /var/run/redis && \
    chown -R redis:redis /data /var/run/redis

# Copy custom configuration
COPY redis/redis.conf /usr/local/etc/redis/redis.conf

# Expose Redis port
EXPOSE 6379

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD redis-cli ping || exit 1

# Run Redis with custom config
ENTRYPOINT ["redis-server", "/usr/local/etc/redis/redis.conf"]
