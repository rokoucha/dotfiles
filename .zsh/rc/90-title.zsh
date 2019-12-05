### Title (user@hostname) ###
case "${TERM}" in
kterm*|xterm*|)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}\007"
    }
    ;;
esac

