function ghq-fzf() {
	local selected_dir=$(ghq list --full-path | fzf --query="$LBUFFER")
	cd $selected_dir
}

zle -N ghq-fzf
bindkey '^G' ghq-fzf

function history-fzf() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N history-fzf
bindkey '^r' history-fzf

