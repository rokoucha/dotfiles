# For homebrew
if [ (uname) = "Darwin" ]
    fish_add_path \
        /usr/local/opt/coreutils/libexec/gnubin \
        /usr/local/opt/ed/libexec/gnubin \
        /usr/local/opt/findutils/libexec/gnubin \
        /usr/local/opt/gnu-sed/libexec/gnubin \
        /usr/local/opt/gnu-tar/libexec/gnubin \
        /usr/local/opt/grep/libexec/gnubin \
        /usr/local/opt/ruby/bin \
        /usr/local/sbin

    set -g MANPATH \
        /usr/local/opt/coreutils/libexec/gnuman \
        /usr/local/opt/ed/libexec/gnuman \
        /usr/local/opt/findutils/libexec/gnuman \
        /usr/local/opt/gnu-sed/libexec/gnuman \
        /usr/local/opt/gnu-tar/libexec/gnuman \
        /usr/local/opt/grep/libexec/gnuman \
        /usr/local/share/man \
        $MANPATH

    set -x LDFLAGS "-L/usr/local/opt/ruby/lib"
    set -x CPPFLAGS "-I/usr/local/opt/ruby/include"
end

fish_add_path \
    ~/.local/bin \
    ~/.yarn/bin

set -x EDITOR /usr/bin/vim

set -x GOPATH ~/.go
