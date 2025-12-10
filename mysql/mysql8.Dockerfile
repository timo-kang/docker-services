FROM mysql:8.0

# Create log directory
RUN mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql

# Copy custom configuration
ADD mysql/my.cnf /etc/mysql/conf.d/my.cnf

# Dynamically set InnoDB buffer pool size based on available memory (1/16 of total)
RUN printf "\n\
# Auto-configured based on host memory\n\
innodb_buffer_pool_size=$(($(grep MemTotal /proc/meminfo | awk '{print $2}')*64))\n\
" >> /etc/mysql/conf.d/my.cnf

# Display final configuration
RUN cat /etc/mysql/conf.d/my.cnf

EXPOSE 3306
