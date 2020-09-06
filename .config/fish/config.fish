# Setup asdf
source ~/.asdf/asdf.fish

# Attach to tmux session
if test -z $TMUX && status --is-login
    __tmux_attach_session
end

# Load dircolours
eval (dircolors -c ~/.dircolors)

# binding
bind \cg '__fzf_ghq_repository_search'
bind \cr '__fzf_history_search'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__fzf_ghq_repository_search'
    bind -M insert \cr '__fzf_history_search'
end
