#!/bin/bash
#       __      __  _____ __         
#  ____/ /___  / /_/ __(_) /__  _____
# / __  / __ \/ __/ /_/ / / _ \/ ___/
#/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
#\__,_/\____/\__/_/ /_/_/\___/____/  
# atnanasi/dotfiles - Yet another dotfiles

# 初期化
function init( ) {
	configure	
	banner
	check_commands
}

# 設定
function configure( ) {
	# インストール先のパス
	install_path=$HOME/test

	# dotfilesを安置するパス
	dotfiles_path=$HOME/test/dotfiles

	# 古いdotfilesを安置するパス
	old_dotfiles_path=$HOME/test/old-dotfiles/$(date +"%Y-%m-%d-%H-%M-%S")

	# Gitのスキーム [git,https]
	git_scheme="git"

	# Gitのサーバー
	git_server_url="github.com"

	# Gitのユーザー名
	git_username="atnanasi"

	# Gitのリポジトリ名
	git_repository="dotfiles"
}

# clone用URLの生成
# scheme,server,username,repository
function make_cloneurl( ) {
	case "$1" in
		"git" ) echo "git@$2:$3/$4.git" ;;
		"https" ) echo "https://$2/$3/$4.git" ;;
		* ) echo "illegal scheme: $1"; exit 1 ;;
	esac
}

# 必要なコマンドがあるかどうか
function check_commands( ) {
	if [ ! `which git` ]; then
		echo "command not found: git"
		exit 1
	fi
}

# メチャメチャかっこよくてイケてるバナーを表示する
function banner( ) {
	cat << EOT
       __      __  _____ __         
  ____/ /___  / /_/ __(_) /__  _____
 / __  / __ \/ __/ /_/ / / _ \/ ___/
/ /_/ / /_/ / /_/ __/ / /  __(__  ) 
\__,_/\____/\__/_/ /_/_/\___/____/  
EOT
	echo "atnanasi/dotfiles - Yet another dotfiles"
}

# GitHubからpullする
function clone( ) {
	if [ -d $dotfiles_path ] ;then 
		git pull --rebase origin master
	else
		git clone `make_cloneurl $git_scheme $git_server_url $git_username $git_repository` $dotfiles_path
	fi
}

# 初期化
init

clone

source $dotfiles_path/install/pre.sh

for file in `\find $dotfiles_path/dotroot -type f`; do
	dotfile=${file#$dotfiles_path/dotroot/}
	dotpath=$(dirname "$dotfile")

	echo "Install $dotfile to $install_path/$dotfile"
	mkdir -p "$install_path/$dotpath"

	if [ -L $install_path/$dotfile ] ;then
		# もし、dotfileがシンボリックリンクなら消す
		rm "$install_path/$dotfile"
	elif [ -f $install_path/$dotfile ] ;then
		# もし、dotfileが既に存在するならバックアップ送り
		mkdir -p $old_dotfiles_path
		mv "$install_path/$dotfile" "$old_dotfiles_path/$dotfile"
	fi

	# 実際にリンクを張る
	ln -s "$file" "$install_path/$dotfile"
done

source $dotfiles_path/install/post.sh

# Welcome to the New World!!!!
source $dotfiles_path/install/newshell.sh

