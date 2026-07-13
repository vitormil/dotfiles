# Import env vars exported by a bash script into fish. Needed because fish's
# own `source` only understands fish syntax — bash assignments like
# `DB_HOST="127.0.0.1"` fail outright. Runs the script in real bash and diffs
# its environment before/after, so only vars the script actually sets/changes
# get imported (bash-only constructs like functions/aliases are not; they're
# not translatable to fish).
function source_bash_env
    set -l script $argv[1]
    set -l before (bash -c 'env -0' | string split0)
    set -l after (bash -c 'source "$1" && env -0' _ $script | string split0)
    for line in $after
        if not contains -- $line $before
            set -l parts (string split -m 1 = -- $line)
            set -gx $parts[1] $parts[2]
        end
    end
end
