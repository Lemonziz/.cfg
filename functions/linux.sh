install_dependency_linux() {
    sudo apt update
    sudo apt install curl ninja-build gettext cmake unzip build-essential zsh ripgrep luarocks python3-venv tmux rustc xclip python3-pip fd-find -y
}

install_neovim_linux() {
    echo "Downloading latest Neovim for Linux x86_64..."

    # Create temporary directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir" || exit 1

    # Download and extract
    if [[ $(uname -m) == "x86_64" ]]; then
        download="nvim-linux-x86_64"
    elif [[ $(uname -m) == "aarch64" || $(uname -m) == "arm64" ]]; then
        download="nvim-linux-arm64"
    else
        echo "Unsupported architecture: $(uname -m)"
        exit 1
    fi
    curl -LO https://github.com/neovim/neovim/releases/latest/download/"$download.tar.gz"
    tar xzvf "$download.tar.gz"
    echo "Installing Neovim to /usr/local..." # Install to system location
    sudo cp -r "$download"/* /usr/local/

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

    if [[ $(uname -m) == "x86_64" ]]; then
        arch="amd64"
    elif [[ $(uname -m) == "aarch64" || $(uname -m) == "arm64" ]]; then
        arch="arm64"
    else
        echo "Unsupported architecture: $(uname -m)"
        exit 1
    fi
    download_url=$(curl -s "https://api.github.com/repos/junegunn/fzf/releases/latest" |
        grep "\"browser_download_url\":.*linux_${arch}.tar.gz" |
        cut -d'"' -f4)
    if [ -z "$download_url" ]; then
        echo "❌ Error: Could not find download URL for fzf darwin_arm64"
        rm -rf "$temp_dir"
        exit 1
    fi
    echo "downloading from $download_url..."
    cd "$temp_dir" || exit 1
    curl -L "$download_url" -o "fzf-linux_${arch}.tar.gz"
    tar xzf fzf-linux_${arch}.tar.gz
    sudo mv fzf /usr/local/bin/
    sudo chmod +x /usr/local/bin/fzf
    cd - >/dev/null || exit 1
    rm -rf "$temp_dir"
    echo "✅ fzf installed successfully!"
    fzf --version
}
