# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
source ~/dotfiles/common/exports.sh

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load OMZP plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
zinit snippet OMZP::git
zinit snippet OMZP::aliases
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::jump
zinit snippet OMZP::mise

# Load completions
autoload -Uz compinit && compinit

# Keybindings
bindkey -e
bindkey "^[[B" history-beginning-search-forward
bindkey "^[[A" history-beginning-search-backward
bindkey '^[w' kill-region

LS_COLORS=$LS_COLORS:'ow=01;34:' ; export LS_COLORS

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

source ~/dotfiles/common/directories.zsh
source ~/dotfiles/common/aliases.sh
source ~/dotfiles/common/functions.sh
source ~/dotfiles/common/take.sh
source ~/dotfiles/common/extras.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/vitor.oliveira/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Trustly environment
source ~/paywithmybank/dotfiles/environment.sh
