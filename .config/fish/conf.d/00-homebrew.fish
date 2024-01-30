# For homebrew
if [ (uname) = "Darwin" ]
    eval (/opt/homebrew/bin/brew shellenv)

    fish_add_path \
        /opt/homebrew/Cellar/perl/5.38.2_1/bin \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/mysql-client/bin \
        /opt/homebrew/opt/openjdk/bin \
        /opt/homebrew/opt/python3/libexec/bin

    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc" &> /dev/null
end
