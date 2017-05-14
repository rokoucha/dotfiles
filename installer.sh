#!/bin/bash
# installer.sh - The smart Dotfiles installer

# Settings
# Shell
new_shell="zsh"

# Install path
install_path=$HOME

# Repository path
dotfiles_path=$install_path/dotfiles

# Old files path
old_dotfiles_path=$install_path/old-dotfiles/$(date +"%Y-%m-%d-%H-%M-%S")

# Git scheme [git,https]
git_scheme="https"

# Git server
git_server_url="github.com"

# Git username
git_username="atnanasi"

# Git repository name
git_repository="dotfiles"

# Make clone-url great again
# Usage: make_cloneurl [scheme] [server] [username] [repository]
function make_cloneurl( ) {
	case "$1" in
		"git" ) echo "git@$2:$3/$4.git" ;;
		"https" ) echo "https://$2/$3/$4.git" ;;
		* ) echo "illegal scheme: $1"; exit 1 ;;
	esac
}

# Check exist command
# Usage: check_command [command]
function check_command( ) {
	if [ ! `which $1` ]; then
		echo "command not found: $1"
		exit 1
	fi
}

# Print beautiful banner
# Usage: banner [username] [repository] [description]
function banner( ) {
	cat << EOT
       __      __  _____ __         
  ____/ /___  / /_/ __(_) /__  _____
 / __  / __ \/ __/ /_/ / / _ \/ ___/
/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
\__,_/\____/\__/_/ /_/_/\___/____/  
EOT
	echo "$1/$2 - $3"
}

# Main
function main ( ) {
	# Print banner
	banner $git_username $git_repository "Yet another dotfiles installer"

	# Check exist commands
	check_command "git"

	# Run pre hook
	source $dotfiles_path/hooks/pre.sh

	# Pull from Git
	if [ -d $dotfiles_path ] ;then 
		git pull --rebase origin master
	else
		git clone `make_cloneurl $git_scheme $git_server_url $git_username $git_repository` $dotfiles_path
	fi

	for file in `find $dotfiles_path/dotroot -type f`; do
		dotfile=${file#$dotfiles_path/dotroot/}
		dotpath=$(dirname "$dotfile")

		echo "Install $dotfile to $install_path/$dotfile"
		mkdir -p "$install_path/$dotpath"

		if [ -L $install_path/$dotfile ] ;then
			# もし、dotfileがシンボリックリンクなら消す
			rm "$install_path/$dotfile"
		elif [ -f $install_path/$dotfile ] ;then
			# もし、dotfileが既に存在するならバックアップ送り
			mkdir -p "$old_dotfiles_path/$dotpath"
			mv "$install_path/$dotfile" "$old_dotfiles_path/$dotfile"
		fi

		# 実際にリンクを張る
		ln -s "$file" "$install_path/$dotfile"
	done

	# Run post hook
	source $dotfiles_path/hooks/post.sh

	# Run new shell
	exec $new_shell $dotfiles_path/hooks/newshell.sh
}

# Load main
main