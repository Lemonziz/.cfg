#!/bin/bash

set -e

# install submodule first
git submodule update --init --remote --recursive
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew update
    brew install ninja gettext cmake unzip ripgrep
else
    sudo apt update
    sudo apt install ninja-build gettext cmake unzip curl build-essential -y
fi

source install_func.sh

# =============================================
# NEOVIM INSTALLATION
# =============================================
echo "🔍 Checking Neovim installation..."
if command -v nvim >/dev/null 2>&1; then
    current=$(get_current_nvim_version)
    latest=$(get_latest_nvim_version)
    
    echo "Current: $current"
    echo "Latest:  $latest"
    
    if [ "$current" = "$latest" ]; then
        echo "✅ You have the latest version!"
    else
        echo "📦 Update available: $current → $latest"
        read -p "Do you want to update? (y/N): " response
        case $response in
            [yY]|[yY][eE][sS])
                echo "🔄 Updating Neovim..."
                install_neovim
                ;;
            *)
                echo "⏭️  Update skipped."
                ;;
        esac
    fi
else
    echo "❌ Neovim not found."
    echo "📥 Installing Neovim..."
    install_neovim
    ;;
fi

# ========================================

if ! command -v fzf >/dev/null 2>&1; then
    echo "Installing fzf"
    $HOME/.cfg/cfgfiles/fzf/install
else
    echo "fzf already installed"
fi
# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
    target=$1
    if [ -e "$target" ]; then
        if [ ! -L "$target" ]; then
            mv "$target" "$target.bak"
            echo "-----> Moved your old $target config file to $target.bak"
        fi
    fi
}

symlink() {
    file=$1
    link=$2
    if [ ! -e "$link" ]; then
        echo "-----> Symlinking your new $link"
        ln -s "$file" "$link"
    fi
}

# git submodule update --recursive this is the command for update
# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in vim vimrc gitconfig tmux.conf zshrc fzf tmux; do
    if [ ! -d "$name" ]; then
        target="$HOME/.$name"
        backup $target
        symlink $HOME/.cfg/cfgfiles/$name $target
    fi
done

if [ ! -d "$HOME/.config" ]; then
    echo "Creating .config directory"
    mkdir -p $HOME/.config
fi

for name in nvim kitty; do
    if [ ! -d "$name" ]; then
        target="$HOME/.config/$name"
        backup $target
        symlink $HOME/.cfg/cfgfiles/$name $target
    fi
done

./install_npm.sh
