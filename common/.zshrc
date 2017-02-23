###########################
#.zshrc - settings for zsh#
# atnanasi/dotfiles       #
###########################

# set zfunction path
fpath=($fpath ~/.zfunc)

# load compinit
autoload -U compinit
compinit

# load prompt
autoload -U promptinit
promptinit

# load colors
autoload -U colors
colors

# set HOME,END,DELETE keys
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char

# fix duplicate command history
setopt HIST_IGNORE_DUPS

# prompt text
PROMPT='[%F{magenta}%B%n%b%f@%F{blue}%U%m%u%f]%F{green}%d%f%#'

###HOSTCONF###
