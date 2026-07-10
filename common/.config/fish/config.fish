set -g fish_greeting

fastfetch

starship init fish | source
zoxide init fish | source
mise activate fish | source

source ~/dotfiles/common/add_path.fish
source ~/dotfiles/common/aliases.fish
source ~/dotfiles/common/take.fish
source ~/dotfiles/common/functions.fish
source ~/dotfiles/common/exports.fish
source ~/dotfiles/common/try.fish
source ~/dotfiles/common/tmux.fish
source ~/dotfiles/common/safe_rm.fish

source ~/dotfiles/common/default_dir.fish
source ~/dotfiles/common/directories.fish
# source ~/dotfiles/common/lastdir.fish

source ~/private.fish

set -g font "Fira Code Nerd Font"
