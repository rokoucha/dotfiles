# Setup asdf
source ~/.asdf/asdf.fish

# Attach to tmux session
if test -z $TMUX && status --is-login
    __tmux_attach_session
end

# Load dircolours
eval (dircolors -c ~/.dircolors)

# Hooks
function __load_dotenv --on-variable PWD
    if test -r .env
        for line in (cat .env)
            set -l kv (string split -m 1 = -- $line)
            set -gx $kv
        end
    end
end

# binding
bind \cg '__fzf_ghq_repository_search'
bind \cr '__fzf_history_search'
bind \t '__fzf_complete'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__fzf_ghq_repository_search'
    bind -M insert \cr '__fzf_history_search'
    bind -M insert \t '__fzf_complete'
end
