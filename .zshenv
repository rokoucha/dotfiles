#!/bin/sh
# For homebrew
if [ "$(uname)" = "Darwin" ]; then
    case "$(uname -m)" in
        x86_64)
            eval "$(/usr/local/bin/brew shellenv)"
            ;;
        arm64)
            eval "$(/opt/homebrew/bin/brew shellenv)"
            ;;
    esac
fi

# For Git signing
if [ -e /usr/lib/ssh-keychain.dylib ]; then
    export SSH_SK_PROVIDER=/usr/lib/ssh-keychain.dylib
fi

export GOPATH=~/.go

