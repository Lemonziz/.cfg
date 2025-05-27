FROM --platform=linux/amd64 ubuntu:24.04

# Use faster mirror for better download speeds
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu/|https://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list

# Install git and sudo which are needed for the script
RUN apt-get update && \
    apt-get install -y git sudo curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user to better simulate a real environment
RUN useradd -m user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

# Switch to the user
USER user
WORKDIR /home/user

# Run the installation script when container starts
CMD ["/bin/bash", "-c", "git clone https://github.com/Lemonziz/.cfg.git /home/user/.cfg && cd /home/user/.cfg && ./install.sh && echo 'Installation complete. Checking symlinks:' && ls -la /home/user && exec /bin/bash"]
