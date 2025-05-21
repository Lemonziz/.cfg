#!/bin/bash

# install submodule first
git submodule update --init --remote --recursive
sudo apt update
sudo apt install ninja-build gettext cmake unzip curl build-essential zsh ripgrep luarocks -y

# install neovim
if ! command -v nvim >/dev/null 2>&1; then
    echo "Installing Neovim"
    cd "$HOME/.cfg/cfgfiles/neovim" || exit
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
else
    echo "Neovim already installed"
fi

# install fzf
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

# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
#
if [ ! -d "$HOME/.config" ]; then
    echo "Creating .config directory"
    mkdir -p $HOME/.config
fi

for name in vim vimrc gitconfig tmux.conf zshrc fzf tmux; do
    if [ ! -d "$name" ]; then
        target="$HOME/.$name"
        backup $target
        symlink $HOME/.cfg/cfgfiles/$name $target
    fi
done

for name in nvim kitty; do
    if [ ! -d "$name" ]; then
        target="$HOME/.config/$name"
        backup $target
        symlink $HOME/.cfg/cfgfiles/$name $target
    fi
done

# Ask user if they want to install npm
read -p "Do you want to install npm packages? (y/n): " answer
case ${answer:0:1} in
y | Y)
    echo "Installing npm packages..."
    $HOME/.cfg/install_npm.sh
    ;;
*)
    echo "Skipping npm installation."
    ;;
esac
