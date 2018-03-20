# zplug Loader
source ~/.zplug/init.zsh

# Plugins
zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "sorin-ionescu/prezto"
zplug "stedolan/jq", as:command, from:gh-r, rename-to:jq
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# Checking plugins
if ! zplug check --verbose; then
	printf 'Install? [y/N]: '
	if read -q; then
		echo; zplug install
	fi
fi

# Load plugins
zplug load --verbose
