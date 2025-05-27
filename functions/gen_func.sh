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
