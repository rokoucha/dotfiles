# For homebrew
if [ (uname) = "Darwin" ]
    switch (uname -m)
    case x86_64
        eval (/usr/local/bin/brew shellenv)

        fish_add_path \
            /usr/local/opt/coreutils/libexec/gnubin \
            /usr/local/opt/ed/libexec/gnubin \
            /usr/local/opt/findutils/libexec/gnubin \
            /usr/local/opt/gnu-sed/libexec/gnubin \
            /usr/local/opt/gnu-tar/libexec/gnubin \
            /usr/local/opt/grep/libexec/gnubin \
            /usr/local/opt/ruby/bin \
            /usr/local/opt/openjdk@11/bin \
            /usr/local/Cellar/node/17.4.0/bin \
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
    case arm64
        eval (/opt/homebrew/bin/brew shellenv)

        fish_add_path \
            /opt/homebrew/opt/coreutils/libexec/gnubin

        source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"  > /dev/null 2> /dev/null
    end
end
