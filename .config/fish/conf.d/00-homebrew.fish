# For homebrew
if [ (uname) = "Darwin" ]
    eval (/opt/homebrew/bin/brew shellenv)

    fish_add_path \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/mysql-client/bin \
        /opt/homebrew/opt/openjdk/bin \
        /opt/homebrew/opt/python3/libexec/bin
end
