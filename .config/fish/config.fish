# load dircolours
eval (dircolors -c ~/.dircolors)

# binding
bind \cg '__fzf_ghq_repository_search'
bind \cr '__fzf_history_search'
bind \t '__fzf_complete'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__fzf_ghq_repository_search'
    bind -M insert \cr '__fzf_history_search'
    bind -M insert \t '__fzf_complete'
end

# load dotenv
dotenv

# start sway
if which sway > /dev/null && test -z $DISPLAY && test "$(tty)" = "/dev/tty1"
    set -x MOZ_ENABLE_WAYLAND 1 
    set -x GTK_IM_MODULE fcitx
    set -x QT_IM_MODULE fcitx
    set -x XMODIFIERS @im=fcitx
    set -x QT_QPA_PLATFORM wayland
    set -x QT_QPA_PLATFORMTHEME qt5ct
    set -x CLUTTER_BACKEND wayland
    set -x XDG_CURRENT_DESKTOP sway
    set -x XDG_SESSION_DESKTOP sway

    exec sway
end
