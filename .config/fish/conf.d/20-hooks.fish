# Hooks
function dotenv --on-variable PWD
    if test -r .env
        for line in (cat .env)
            set -l matches (string match -r "^\s*(?:export\s+)?([\w\d_]+)=['\"]?(.*?)['\"]?(?:\s+#.+)?\$" "$line")

            if test (count $matches) -ne 3
                continue
            end

            set -gx $matches[2] $matches[3]
        end
    end
end
