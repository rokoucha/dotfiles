# direnv
if type -q direnv
    direnv hook fish | source
end

# key bindings
bind \cg '__fzf_ghq_repository_search'
bind \cr '__fzf_history_search'
bind \t '__fzf_complete'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__fzf_ghq_repository_search'
    bind -M insert \cr '__fzf_history_search'
    bind -M insert \t '__fzf_complete'
end

# Added by Antigravity
fish_add_path /Users/rokoucha/.antigravity/antigravity/bin
