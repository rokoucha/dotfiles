# https://github.com/jethrokuan/fzf/blob/master/functions/__fzf_complete.fish
function __fzf_complete -d 'fzf completion and print selection back to commandline'
    set -l cmd (commandline -co) (commandline -ct)

    switch $cmd[1]
        case env sudo
            for i in (seq 2 (count $cmd))
                switch $cmd[$i]
                    case '-*'
                    case '*=*'
                    case '*'
                        set cmd $cmd[$i..-1]
                        break
                end
            end
    end

    set -l cmd_lastw $cmd[-1]
    set cmd (string join -- ' ' $cmd)

    set -l initial_query ''
    test -n "$cmd_lastw"; and set initial_query --query="$cmd_lastw"

    set -l complist (complete -C$cmd)
    set -l result

    test -z "$complist"; and return

    set -l compwc (echo $complist | wc -w)
    if test $compwc -eq 1
        set result "$complist"
    else

        set -l query
        string join -- \n $complist \
            | eval (__fzfcmd) (string escape --no-quoted -- $initial_query) --print-query (__fzf_complete_opts) \
            | cut -f1 \
            | while read -l r
            if test -z "$query"
                set query $r
            else
                set result $result $r
            end
        end

        if test -z "$query"; and test -z "$result"
            commandline -f repaint
            return
        end

        if test -z "$result"
            set result $query
        end
    end

    set prefix (string sub -s 1 -l 1 -- (commandline -t))
    for i in (seq (count $result))
        set -l r $result[$i]
        switch $prefix
            case "'"
                commandline -t -- (string escape -- $r)
            case '"'
                if string match '*"*' -- $r >/dev/null
                    commandline -t -- (string escape -- $r)
                else
                    commandline -t -- '"'$r'"'
                end
            case '~'
                commandline -t -- (string sub -s 2 (string escape -n -- $r))
            case '*'
                commandline -t -- $r
        end
        [ $i -lt (count $result) ]; and commandline -i ' '
    end

    commandline -f repaint
end

test "$argv[1]" = "__fzf_complete_preview"; and __fzf_complete_preview $argv[2..3]

function __fzf_complete_opts -d 'fzf options for fish tab completion'
    if set -q FZF_DEFAULT_OPTS
        echo $FZF_DEFAULT_OPTS
    end

    echo --bind tab:accept,btab:cancel --cycle --inline-info --no-multi --reverse

    if set -q FZF_COMPLETE_OPTS
        echo $FZF_COMPLETE_OPTS
    end
end