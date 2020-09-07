# For homebrew
if [ (uname) = "Darwin" ]
    set -U fish_user_paths \
        (brew --prefix coreutils)/libexec/gnubin \
        (brew --prefix ed)/libexec/gnubin \
        (brew --prefix findutils)/libexec/gnubin \
        (brew --prefix gnu-sed)/libexec/gnubin \
        (brew --prefix gnu-tar)/libexec/gnubin \
        (brew --prefix grep)/libexec/gnubin \
        (brew --prefix ruby)/bin \
        /usr/local/bin \
        /usr/local/sbin \
        $fish_user_paths

    set -x MANPATH \
        (brew --prefix coreutils)/libexec/gnuman \
        (brew --prefix ed)/libexec/gnuman \
        (brew --prefix findutils)/libexec/gnuman \
        (brew --prefix gnu-sed)/libexec/gnuman \
        (brew --prefix gnu-tar)/libexec/gnuman \
        (brew --prefix grep)/libexec/gnuman \
        /usr/local/share/man \
        $MANPATH


    set -x LDFLAGS "-L/usr/local/opt/ruby/lib"
    set -x CPPFLAGS "-I/usr/local/opt/ruby/include"
end
