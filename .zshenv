#!/bin/sh
# For homebrew
if [ "$(uname)" = "Darwin" ]; then
    eval "$(SHELL=/bin/zsh /opt/homebrew/bin/brew shellenv)"

    export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
fi

# For Git signing
if [ -e /usr/lib/ssh-keychain.dylib ]; then
    export SSH_SK_PROVIDER=/usr/lib/ssh-keychain.dylib
fi

export GOPATH=~/.go

