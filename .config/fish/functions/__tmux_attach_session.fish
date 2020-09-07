function __tmux_attach_session
    set sessions (tmux list-sessions)
    if test -z "$sessions"
        exec tmux new-session
        return
    end

    set new_session "Create new session"
    set kill_sessions "Kill all sessions"
    set ID (string join \n $new_session (string split \n $sessions) $kill_sessions | __fzfcmd | cut -d: -f1)
    if test "$ID" = "$new_session"
        exec tmux new-session
    else if test "$ID" = "$kill_sessions"
        tmux kill-server
        exec tmux new-session
    else if test -n "$ID"
        exec tmux attach-session -t "$ID"
    end
end
