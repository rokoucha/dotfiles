function __load_dotenv --on-variable PWD
    if test -r .env
        for line in (cat .env)
            set -l kv (string split -m 1 = -- $line)
            set -gx $kv
        end
    end
end
