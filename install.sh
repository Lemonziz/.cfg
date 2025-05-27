#!/bin/bash

set -e

# install submodule first
git submodule update --init --remote --recursive
source ./functions/gen_func.sh

# general install previous

install_kitty
if [[ $(uname -s) == "Darwin" ]]; then
    if [[ $(uname -m) != "arm64" ]]; then
        echo "This script is intended for macOS ARM64 architecture only."
        echo "Please run the script on an ARM64 Mac."
        exit 1
    fi
    source ./functions/func_macos.sh
    install_dependency_macos
    install_neovim_macos_arm64
    install_fzf_macos_arm64
elif [[ $(uname -s) == "Linux" ]]; then
    source ./functions/func_linux.sh
    install_dependency_linux
    install_firacode_linux
    install_neovim_linux
    install_fzf_linux
    install_kitty_desktop_linux
else
    echo "Unsupported OS: $(uname -s). This script supports macOS and Linux only."
    echo "Please install dependencies manually"
    exit 1
fi

# general install after
install_npm

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink

# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
#
if [ ! -d "$HOME/.config" ]; then
    echo "Creating .config directory"
    mkdir -p "$HOME/.config"
fi

# create symlink for configurations
for name in vim vimrc gitconfig tmux.conf zshrc fzf tmux; do
    if [ ! -d "$name" ]; then
        target="$HOME/.$name"
        backup "$target"
        symlink "$HOME/.cfg/cfgfiles/$name" "$target"
    fi
done

for name in nvim kitty; do
    if [ ! -d "$name" ]; then
        target="$HOME/.config/$name"
        backup "$target"
        symlink "$HOME/.cfg/cfgfiles/$name" "$target"
    fi
done
