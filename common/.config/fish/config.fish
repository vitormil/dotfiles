set -g fish_greeting

starship init fish | source
zoxide init fish | source
mise activate fish | source

if test -f ~/private.sh
    source_bash_env ~/private.sh
end

set -g font "Fira Code Nerd Font"
