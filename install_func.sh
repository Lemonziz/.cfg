install_neovim_macos_arm64() {
    echo "Downloading latest Neovim for macOS Apple Silicon..."
    
    # Create temporary directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download and extract
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
    xattr -c ./nvim-macos-arm64.tar.gz  # Remove quarantine attribute
    tar xzf nvim-macos-arm64.tar.gz
    
    # Install to system location
    echo "Installing Neovim to /usr/local..."
    sudo cp -r nvim-macos-arm64/* /usr/local/
    
    # Clean up
    cd "$HOME/.cfg"
    rm -rf "$temp_dir"
    
    echo "✅ Neovim installed successfully!"
    echo "You can now use 'nvim' command directly"
    nvim --version
}

install_neovim_linux() {
    echo "Downloading latest Neovim for Linux x86_64..."
    
    # Create temporary directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download and extract
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzf nvim-linux-x86_64.tar.gz
    
    # Install to system location
    echo "Installing Neovim to /usr/local..."
    sudo cp -r nvim-linux-x86_64/* /usr/local/
    
    # Clean up
    cd - > /dev/null  # Return to previous directory silently
    rm -rf "$temp_dir"
    
    echo "✅ Neovim installed successfully!"
    echo "You can now use 'nvim' command directly"
    nvim --version
}

get_latest_nvim_version() {
    # Get latest version from GitHub API
    curl -s https://api.github.com/repos/neovim/neovim/releases/latest | awk -F'"' '/"tag_name":/ {print $4}'
}

get_current_nvim_version() {
    # Get current installed version
    nvim --version 2>/dev/null | head -n1 | awk '{print $2}'
}
