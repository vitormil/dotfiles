# Import env vars and aliases exported by a bash script into fish. Needed
# because fish's own `source` only understands fish syntax — bash assignments
# like `DB_HOST="127.0.0.1"` fail outright. Runs the script in real bash and
# diffs its environment/aliases before/after, so only vars/aliases the script
# actually sets get imported.
#
# Aliases aren't translated to fish syntax (bash alias bodies can use bash-only
# constructs like $(), sed, subshells). Instead each new alias becomes a fish
# function that re-sources the same script in bash and re-invokes the alias by
# name there, forwarding args — correct by construction since bash runs it.
function source_bash_env
    set -l script $argv[1]
    set -l before_env (bash -c 'env -0' | string split0)
    set -l before_aliases (bash -c 'alias' 2>/dev/null | string replace -r '^alias ([^=]+)=.*' '$1')
    set -l after_env (bash -c 'source "$1" && env -0' _ $script | string split0)
    set -l after_aliases (bash -c 'source "$1" && alias' _ $script 2>/dev/null | string replace -r '^alias ([^=]+)=.*' '$1')

    for line in $after_env
        if not contains -- $line $before_env
            set -l parts (string split -m 1 = -- $line)
            set -gx $parts[1] $parts[2]
        end
    end

    for name in $after_aliases
        if not contains -- $name $before_aliases
            eval "function $name
    bash -c '
shopt -s expand_aliases
source \"$script\" >/dev/null 2>&1
$name \"\$@\"
' bash \$argv
end"
        end
    end
end
