if [ (uname) = "Darwin" ]
    eval (/opt/homebrew/bin/brew shellenv)

    fish_add_path --global --move \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/openjdk/bin \
        /opt/homebrew/opt/python3/libexec/bin \
        /opt/homebrew/opt/ruby/bin \
        /opt/homebrew/opt/rustup/bin
end
