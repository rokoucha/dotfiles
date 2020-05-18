# For homebrew
if [ "$(uname)" = "Darwin" ]; then
    export PATH
    export MANPATH
    typeset -U PATH path MANPATH manpath

    unsetopt GLOBAL_RCS

    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi

    path=(
        ~/.asdf/shims # asdf
        /usr/local/opt/coreutils/libexec/gnubin(N-/) # coreutils
        /usr/local/opt/ed/libexec/gnubin(N-/) # ed
        /usr/local/opt/findutils/libexec/gnubin(N-/) # findutils
        /usr/local/opt/gnu-sed/libexec/gnubin(N-/) # sed
        /usr/local/opt/gnu-tar/libexec/gnubin(N-/) # tar
        /usr/local/opt/grep/libexec/gnubin(N-/) # grep
        /usr/local/opt/ruby/bin # ruby
        /usr/local/bin(N-/) # homebrew
        /usr/local/sbin(N-/) # homebrew
        ${path}
    )
    manpath=(
        /usr/local/opt/coreutils/libexec/gnuman(N-/) # coreutils
        /usr/local/opt/ed/libexec/gnuman(N-/) # ed
        /usr/local/opt/findutils/libexec/gnuman(N-/) # findutils
        /usr/local/opt/gnu-sed/libexec/gnuman(N-/) # sed
        /usr/local/opt/gnu-tar/libexec/gnuman(N-/) # tar
        /usr/local/opt/grep/libexec/gnuman(N-/) # grep
        /usr/local/share/man(N-/) # homebrew
        ${manpath}
    )

    export LDFLAGS="-L/usr/local/opt/ruby/lib"
    export CPPFLAGS="-I/usr/local/opt/ruby/include"
fi