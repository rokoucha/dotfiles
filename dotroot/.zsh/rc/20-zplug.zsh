# zplug Loader
source ~/.zplug/init.zsh

# Plugins
zplug "sorin-ionescu/prezto"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "mrowa44/emojify", as:command

zplug "b4b4r07/emoji-cli", \
	on:"stedolan/jq"

# Checking plugins
if ! zplug check --verbose; then
	printf 'Install? [y/N]: '
	if read -q; then
		echo; zplug install
	fi
fi

# Load plugins
zplug load --verbose
