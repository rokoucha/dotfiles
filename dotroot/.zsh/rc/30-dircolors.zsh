#Set dircolors
eval $(dircolors ~/.zsh/color/dircolors-solarized/dircolors.ansi-universal)

#Set dircolors for zsh-comp
if [ -n "$LS_COLORS" ]; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
