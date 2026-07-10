set -g fish_greeting

fastfetch

starship init fish | source
zoxide init fish | source
mise activate fish | source

if test -f ~/private.fish
    source ~/private.fish
end

set -g font "Fira Code Nerd Font"
