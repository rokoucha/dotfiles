if string match --quiet '*Microsoft' (uname -r)
    set -x LANG en_GB.UTF-8
    set -x DOCKER_CONTEXT docker-desktop
end
