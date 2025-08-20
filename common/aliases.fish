alias l="eza --header --long --all --group-directories-first --ignore-glob=\"*DS_Store*\""
alias lt="eza --tree --level=2 --long --icons --git --ignore-glob=\"*DS_Store*\""
alias ll="lt --all"
alias lc="l --sort=created"

alias g="jump"
alias cd="z"
alias t="tig"

alias edf="code ~/dotfiles"
alias r="bin/rails"
alias bi="bundle install"
alias o="open ."
alias c="code ."
alias n="nvim"
alias vim="nvim"
# alias rm="trash"
alias htop="zenith"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias ni="npm install"
alias ns="npm run start"

alias cat="bat"

alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"

# system upgrade (verbose)
alias sup="echo 'Updating system packages...' && sudo pacman -Syu --noconfirm --verbose"
