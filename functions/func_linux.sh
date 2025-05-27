install_dependency_linux() {
    sudo apt update
    sudo apt install ninja-build gettext cmake unzip curl build-essential zsh ripgrep luarocks python3-venv tmux -y
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

install_kitty_desktop_linux() {
    mkdir -p ~/.local/bin
    # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty desktop file(s)
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
    echo 'kitty.desktop' >~/.config/xdg-terminals.list
}
