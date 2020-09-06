function __tmux_refresh_client --on-event fish_postexec
    if [ ! -z $TMUX ]
        tmux refresh-client -S
    end
end
