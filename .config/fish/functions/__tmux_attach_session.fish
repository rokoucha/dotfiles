function __tmux_attach_session
    set sessions (tmux list-sessions)
    if test -z "$sessions"
        exec tmux new-session
        return
    end

    set new_session "Create new session"
    set ID (string join \n "Create new session" (string split \n $sessions) | fzf | cut -d: -f1)
    if test "$ID" = "$new_session"
        exec tmux new-session
    else if test -n "$ID"
        exec tmux attach-session -t "$ID"
    end
end
