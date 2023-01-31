# For homebrew
if [ (uname) = "Darwin" ]
    eval (/opt/homebrew/bin/brew shellenv)

    fish_add_path \
        /opt/homebrew/opt/coreutils/libexec/gnubin \
        /opt/homebrew/opt/python3/libexec/bin

    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc" &> /dev/null
end
