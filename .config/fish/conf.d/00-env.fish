set USER_PATH \
    $HOME/.local/bin \
    $HOME/.deno/bin \

# For homebrew
if [ (uname) = "Darwin" ]
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

set -g PATH \
    $USER_PATH \
    $PATH

set -x EDITOR /usr/bin/vim
