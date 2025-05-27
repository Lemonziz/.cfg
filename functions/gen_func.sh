install_kitty() {
    if ! command -v kitty >/dev/null 2>&1; then
        echo "Installing Kitty..."
        if curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin; then
            if [[ "$(uname -s)" == "Linux" ]]; then
                ./kitty_desktop.sh
            fi
        else
            echo "Failed to install Kitty"
            exit 1
        fi
    else
        echo "Kitty already installed"
    fi
}

install_npm() {
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"

    # Download and install Node.js:
    nvm install 22

    # Verify the Node.js version:
    node -v     # Should print "v22.16.0".
    nvm current # Should print "v22.16.0".

    # Verify npm version:
    npm -v # Should print "10.9.2".
}

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
