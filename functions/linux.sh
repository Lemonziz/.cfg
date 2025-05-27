install_dependency_linux() {
    sudo apt update
    sudo apt install curl ninja-build gettext cmake unzip curl build-essential zsh ripgrep luarocks python3-venv tmux -y
}

install_neovim_linux() {
    echo "Downloading latest Neovim for Linux x86_64..."

    # Create temporary directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1

    # Download and extract
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzf nvim-linux-x86_64.tar.gz

    # Install to system location
    echo "Installing Neovim to /usr/local..."
    sudo cp -r nvim-linux-x86_64/* /usr/local/

    # Clean up
    cd - >/dev/null || exit 1 # Return to previous directory silently
    rm -rf "$temp_dir"

    echo "✅ Neovim installed successfully!"
    echo "You can now use 'nvim' command directly"
    nvim --version
}

install_firacode_linux() {
    # get latest download link for FiraCode from GitHub
    # download and install FiraCode
    mkdir -p ~/.local/share/fonts
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" -o /tmp/FiraCode.zip
    unzip -j /tmp/FiraCode.zip "*.ttf" -d ~/.local/share/fonts/
    rm -f /tmp/FiraCode.zip
}

install_fzf_linux() {
    temp_dir=$(mktemp -d)
    download_url=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" |
        grep '"browser_download_url":.*linux_amd64.tar.gz' |
        cut -d'"' -f4)
    echo "downloading from $download_url..."
    cd "$temp_dir" || exit 1
    curl -L "$download_url" -o "fzf-linux_amd64.tar.gz"
    tar xzf fzf-linux_amd64.tar.gz
    sudo mv fzf /usr/local/bin/
    sudo chmod +x /usr/local/bin/fzf
    cd - >/dev/null || exit 1
    rm -rf "$temp_dir"
    echo "✅ fzf installed successfully!"
    fzf --version
}
