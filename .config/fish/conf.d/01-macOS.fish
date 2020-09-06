# For homebrew
if [ (uname) = "Darwin" ]
    set -U fish_user_paths \
        /usr/local/opt/coreutils/libexec/gnubin(N-/) \
        /usr/local/opt/ed/libexec/gnubin(N-/) \
        /usr/local/opt/findutils/libexec/gnubin(N-/) \
        /usr/local/opt/gnu-sed/libexec/gnubin(N-/) \
        /usr/local/opt/gnu-tar/libexec/gnubin(N-/) \
        /usr/local/opt/grep/libexec/gnubin(N-/) \
        /usr/local/opt/ruby/bin \
        /usr/local/bin(N-/) \
        /usr/local/sbin(N-/) \
        $fish_user_paths

    set -x MANPATH \
        /usr/local/opt/coreutils/libexec/gnuman(N-/) \
        /usr/local/opt/ed/libexec/gnuman(N-/) \
        /usr/local/opt/findutils/libexec/gnuman(N-/) \
        /usr/local/opt/gnu-sed/libexec/gnuman(N-/) \
        /usr/local/opt/gnu-tar/libexec/gnuman(N-/) \
        /usr/local/opt/grep/libexec/gnuman(N-/) \
        /usr/local/share/man(N-/) \
        $MANPATH


    set -x LDFLAGS "-L/usr/local/opt/ruby/lib"
    set -x CPPFLAGS "-I/usr/local/opt/ruby/include"
end
