#!/bin/sh
# For homebrew
if [ "$(uname)" = "Darwin" ]; then
    case "$(uname -m)"
        x86_64)
            eval "$(/usr/local/bin/brew shellenv)"
            ;;
        arm64)
            eval "$(/opt/homebrew/bin/brew shellenv)"
            ;;
    esac
fi

