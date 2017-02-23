#my zsh config

fpath=($fpath ~/.zfunc)
autoload -U compinit
autoload -U promptinit
autoload -U zed
autoload -U colors

colors
compinit
promptinit

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char

setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#])}"}

setopt HIST_IGNORE_DUPS

PROMPT='[%F{magenta}%B%n%b%f@%F{blue}%U%m%u%f]%F{green}%d%f%#'
