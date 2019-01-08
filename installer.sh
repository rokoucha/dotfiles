#!/bin/sh
set -eu

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/atnanasi/dotfiles/master/common/dotctl/.local/bin/dotctl.sh | sh -s install

