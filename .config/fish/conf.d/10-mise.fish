if type -q mise
    mise activate fish | source
    fish_add_path --global --move ~/.local/share/mise/shims
end
