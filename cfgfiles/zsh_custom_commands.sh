#!/bin/bash

# Function to clone the C++ template and rename the directory
function clonecpp() {
    if [[ -z "$1" ]]; then
        echo "Usage: cloancpp <new_project_name>"
        return 1  # Exit with a status of 1 on error
    fi

    # Clone the repository
    git clone git@github.com:Lemonziz/cpp_template_small.git "$1"
    rm -rf ./$1/.git
    
    # Check if the clone was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to clone repository."
        return 1
    fi
    echo "C++ project template cloned and renamed to $1."
}

# Function to clone the Python template and rename the directory
function clonepython() {
    if [[ -z "$1" ]]; then
        echo "Usage: cloanpython <new_project_name>"
        return 1  # Exit with a status of 1 on error
    fi

    # Clone the repository
    git clone git@github.com:Lemonziz/python_project_template.git "$1"
    rm -rf ./$1/.git
    
    # Check if the clone was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to clone repository."
        return 1
    fi
    echo "Python project template cloned and renamed to $1."
}

function pyenv() {
    if [[ -z "$1" ]]; then
        echo "Usage: pyenv <environment_name>"
        return 1  # Exit with a status of 1 on error
    fi

    # Expand the tilde manually to the home directory
    local env_path="${HOME}/.virtualenvs/$1/bin/activate"

    # Check if the activation script exists
    if [[ -f $env_path ]]; then
        # Use `source` to activate the specified environment
        source $env_path
    else
        echo "Environment '$1' does not exist."
        return 1  # Exit with a status of 1 on error
    fi
}

function renamemit() {
    # Usage: rename_files filetype
    # filetype: the type of the files you want to rename (e.g., pdf, txt)

    # Check if the rename utility is installed
    if ! command -v rename &> /dev/null
    then
        echo "rename utility is not installed. Please install it first."
        return 1
    fi

    # Check if the user provided a file type
    if [ -z "$1" ]
    then
        echo "Please provide a file type as an argument."
        return 1
    fi

    # Perform the renaming operation
    rename 's/^[^_]*_//' *.$1

    echo "Files renamed successfully."
}

# To use this function, type rename_files followed by the file type.
# Example: rename_files pdf

