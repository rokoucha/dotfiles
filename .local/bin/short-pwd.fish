#!env fish

set max $argv[2]
set pwd (string replace "$HOME" '~' $argv[1])

set -l paths (string split '/' "$pwd")

for i in (seq (count $paths))
    if test (string length $pwd) -gt $max
        if test $i -ne (count $paths)
            set paths[$i] (string sub -s 1 -l 1 $paths[$i])
        else
            set paths[$i] (string sub -s 1 -l (math $max - 3) $paths[$i])...
        end
    end
end

echo (string join '/' $paths)
