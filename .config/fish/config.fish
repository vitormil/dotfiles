set -g fish_greeting

fastfetch

starship init fish | source
zoxide init fish | source
mise activate fish | source

source ~/dotfiles/common/aliases.fish
source ~/dotfiles/common/take.fish
source ~/dotfiles/common/functions.fish
source ~/dotfiles/common/exports.fish
source ~/dotfiles/common/directories.fish
source ~/dotfiles/common/try.fish
source ~/dotfiles/common/last_dir.fish

source ~/private.fish

set -g font "Fira Code Nerd Font"
