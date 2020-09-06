function __fzf_history_search
    history merge
    history -z | eval $fzf --read0 --print0 --tiebreak=index --toggle-sort=ctrl-r -q '(commandline)' | read -lz result
    and commandline -- $result
    commandline -f repaint
end
