# Setup asdf
source ~/.asdf/asdf.fish

# Load dircolours
eval (dircolors -c ~/.dircolors)

# Hooks
function dotenv --on-variable PWD
  if test -r .env
    for line in (cat .env)
      set -l matches (string match -r "^\s*(?:export\s+)?([\w\d_]+)=['\"]?(.*?)['\"]?(?:\s+#.+)?\$" "$line")

      if test (count $matches) -ne 3
        continue
      end

      set -gx $matches[2] $matches[3]
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
