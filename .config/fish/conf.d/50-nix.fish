if [ -d /nix/var/nix/profiles/default/bin ]
    fish_add_path --global --move /nix/var/nix/profiles/default/bin $PATH
end
