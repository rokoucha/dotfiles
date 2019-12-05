source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin light "zsh-users/zsh-autosuggestions"
zplugin light "zdharma/fast-syntax-highlighting"
zplugin light "zsh-users/zsh-completions"
zplugin light "zsh-users/zsh-history-substring-search"
zplugin load "sorin-ionescu/prezto"
zplugin snippet OMZ::plugins/dotenv/dotenv.plugin.zsh
zplugin ice atload"zpcdreplay" atclone'./zplug.zsh'
zplugin light g-plane/zsh-yarn-autocompletions
