FROM ubuntu:24.04

# Install git and sudo which are needed for the script
RUN apt-get update && apt-get install git sudo -y

# Create a non-root user to better simulate a real environment
RUN useradd -m user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

# Switch to the user
USER user
WORKDIR /home/user

# Clone your actual repo
RUN git clone -b pc-branch https://github.com/Lemonziz/.cfg.git /home/user/.cfg

# Run the installation script
# This will automatically run when the container starts
CMD ["/bin/bash", "-c", "cd /home/user/.cfg && ./install.sh && echo 'Checking symlinks:' && ls -la /home/user"]
