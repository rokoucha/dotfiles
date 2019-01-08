#!/bin/sh
set -eu

# dotctl.sh - Git based smart Dotfiles manager
_VERSION="1.00"

# Settings

## Install path
_INSTALL="$HOME"

## Repository path
_DOTFILES="$_INSTALL/dotfiles"

## Repository URL
_REPOSITORY="https://github.com/atnanasi/dotfiles.git"


## Repository Branch
_BRANCH="master"

# Environment detector
if expr "$(uname -r)" : ".*Microsoft$" > /dev/null; then
    # WSL
    _ENV="WSL"
elif expr "$(uname -r)" : ".*ARCH$" > /dev/null; then
    # ArchLinux
    _ENV="Arch"
else
    # Some linux
    _ENV=""
fi

# Functions

## Check exist command
## Usage: check_command <command>
check_command( ) {
    if [ ! "$(command -v "$1")" ]; then
        echo "command not found: $1" >&2
        exit 1
    fi
}

## Print beautiful banner
## Usage: banner <repository> <branch> <description>
banner( ) {
    echo "dotctl.sh $_VERSION($_ENV)"
    cat << EOT
       __      __  _____ __         
  ____/ /___  / /_/ __(_) /__  _____
 / __  / __ \/ __/ /_/ / / _ \/ ___/
/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
\__,_/\____/\__/_/ /_/_/\___/____/  
EOT
    echo "$1($2) - $3"
}

## Clone or Pull from Git
## Powerdby -> https://github.com/mohemohe/dotfiles/blob/bf442b1827211e81730d9a8c8e3527b7e5559175/install.sh#L6
## Usage: get_pull_or_clone <branch> <repository> <path>
git_pull_or_clone( ) {
    cd="$(pwd)"
    if [ -d "$3" ]; then
        cd "$3"
        git pull
    else
        git clone -b "$1" "$2" "$3"
    fi
    cd "$3"
    git submodule update --init --recursive -j 9
    cd "$cd"
}

# Commands

## Deploy
deploy ( ) {
    _OLD_DOTFILES=$_INSTALL-old/$(date +"%Y-%m-%d-%H-%M-%S")

    for env in "common" $_ENV; do
        echo "# $env"
        # shellcheck disable=SC2044
        for app in $(find "$_DOTFILES/$env" -maxdepth 1 ! -path "$_DOTFILES/$env" -type d -exec basename {} \;); do
            echo "Deploy $app:"
            # shellcheck disable=SC2044
            for file in $(find "$_DOTFILES/$env/$app" -type f); do
                dotfile="${file#$_DOTFILES/$env/$app}"
                dotpath="$(dirname "$dotfile")"

                echo " - $dotfile to $_INSTALL$dotfile"
                mkdir -p "$_INSTALL/$dotpath"

                if [ -L "$_INSTALL/$dotfile" ] ;then
                    # Delete when target is symbolic link
                    rm "$_INSTALL/$dotfile"
                elif [ -f "$_INSTALL/$dotfile" ] ;then
                    # Move when target is file
                    mkdir -p "$_OLD_DOTFILES"
                    mv "$_INSTALL/$dotfile" "$_OLD_DOTFILES/$dotfile"
                fi

                # Link file
                ln -s "$file" "$_INSTALL/$dotfile"
            done
        done
    done
}

## Install
install ( ) {
    # Check exist commands
    check_command "git"

    # Pull from Git
    git_pull_or_clone "$_BRANCH" "$_REPOSITORY" "$_DOTFILES"

    # Deploy files
    deploy

    # Run install hooks
    for env in "common" $_ENV; do
        # shellcheck disable=SC2044
        for hook in $(find "$_DOTFILES/hooks/$env" -maxdepth 1 -type f -name "*.sh"); do
            # shellcheck disable=1090
            . "$hook"
        done
    done
}

# Print banner↲
banner "$_REPOSITORY" "$_BRANCH" "Yet another dotfiles installer"↲

# Execute functions
if [ $# -lt 1 ]; then
    cat << EODOPT
dotctl.sh - Git based smart Dotfiles manager

Usage:
  dotctl.sh install     Install dotfiles and Setup dotfiles
  dotctl.sh deploy      Deploy dotfiles
EODOPT
    exit 1
else
    case $1 in
        "install" ) install ;;
        "deploy" ) deploy ;;
        * ) echo "$1: function not found"; exit 1 ;;
    esac
    echo "Done $1!"
fi

