function ghq-fzf() {
    local selected
    selected=$(ghq list --full-path | fzf --query="$LBUFFER" --prompt="Repository > ")
    [ -n "$selected" ] &&
        cd "$selected" &&
        zle accept-line

    zle reset-prompt
}

zle -N ghq-fzf
bindkey '^G' ghq-fzf

function history-fzf() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
}
zle -N history-fzf
bindkey '^R' history-fzf

