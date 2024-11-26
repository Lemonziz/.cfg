#!/bin/bash

OS=$(uname -s)
NVIM_PATH="/usr/local/bin/nvim"

# Set appropriate shebang based on OS
if [[ "$OS" == "Linux" ]]; then
    BASH_PATH="/usr/bin/bash"
elif [[ "$OS" == "Darwin" ]]; then
    BASH_PATH="/bin/bash"
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# install submodule first

git submodule update --init --remote --recursive

OS=$(uname -s)

# Set appropriate shebang based on OS
if [[ "$OS" == "Linux" ]]; then
    sudo apt update
    sudo apt install ninja-build gettext cmake unzip curl build-essential -y
elif [[ "$OS" == "Darwin" ]]; then
    brew update
    brew install ninja gettext cmake unzip
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

if [[ -x "$NVIM_PATH" ]]; then
    echo "Neovim is already installed at $NVIM_PATH. Skipping installation."
else
    echo "Neovim is not installed. Proceeding with installation."
    # install neovim
    cd $HOME/.cfg/cfgfiles/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd $HOME/.cfg/cfgfiles/neovim && sudo make install
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
    ln -s $file $link
  fi
}
# git submodule update --recursive this is the command for update
# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in zsh_custom_commands.sh vim vimrc gitconfig tmux.conf zshrc fzf tmux; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/cfgfiles/$name $target
  fi
done


$HOME/.cfg/cfgfiles/fzf/install
# install nvm
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
