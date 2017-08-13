function ghq-fzf() {
	local selected_dir=$(ghq list --full-path | fzf --query="$LBUFFER")

	cd $selected_dir
}

zle -N ghq-fzf
bindkey '^G' ghq-fzf
