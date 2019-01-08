#Set dircolors
eval $(dircolors ~/.dircolors.ansi)

#Set dircolors for zsh-comp
if [ -n "$LS_COLORS" ]; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
