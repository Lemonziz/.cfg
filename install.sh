#!/bin/bash

# install submodule first
git submodule update --init --remote --recursive
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew update
    brew install ninja gettext cmake unzip
else
    sudo apt update
    sudo apt install ninja-build gettext cmake unzip curl build-essential -y
fi

if ! command -v nvim >/dev/null 2>&1; then
    echo "Installing Neovim"
    cd "$HOME/.cfg/cfgfiles/neovim" || exit
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
else
    echo "Neovim already installed"
fi

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
for name in zsh_custom_commands.sh vim vimrc gitconfig tmux.conf zshrc fzf tmux; do
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

# install nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
