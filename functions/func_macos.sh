install_dependency_macos() {
    brew update
    brew install ninja gettext cmake unzip ripgrep curl zsh luarocks python3-venv tmux
}

install_neovim_macos_arm64() {
    echo "Downloading latest Neovim for macOS Apple Silicon..."

    # Create temporary directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1

    # Download and extract
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
    xattr -c ./nvim-macos-arm64.tar.gz # Remove quarantine attribute
    tar xzf nvim-macos-arm64.tar.gz

    # Install to system location
    echo "Installing Neovim to /usr/local..."
    sudo cp -r nvim-macos-arm64/* /usr/local/

    # Clean up
    cd "$HOME/.cfg" || exit 1 # Return to previous directory
    rm -rf "$temp_dir"

    echo "✅ Neovim installed successfully!"
    echo "You can now use 'nvim' command directly"
    nvim --version
}

install_fzf_macos_arm64() {
    temp_dir=$(mktemp -d)
    download_url=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" |
        grep '"browser_download_url":.*darwin_arm64.tar.gz' |
        cut -d'"' -f4)
    echo "downloading from $download_url..."
    cd "$temp_dir" || exit 1
    curl -L "$download_url" -o "fzf-darwin_arm64.tar.gz"
    tar xzf fzf-darwin_arm64.tar.gz
    sudo mv fzf /usr/local/bin/
    sudo chmod +x /usr/local/bin/fzf
    cd - >/dev/null || exit 1
    rm -rf "$temp_dir"
    echo "✅ fzf installed successfully!"
    fzf --version
}
