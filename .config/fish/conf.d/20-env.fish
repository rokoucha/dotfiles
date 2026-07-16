set -x EDITOR which vim

set -x GOPATH ~/.go

fish_add_path --global --move \
    ~/.cargo/bin \
    ~/.go/bin \
    ~/.local/bin
