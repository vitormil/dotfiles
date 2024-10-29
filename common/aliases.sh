alias l="eza --header --long --all --group-directories-first --ignore-glob=\"*DS_Store*\""
alias lt="eza --tree --level=2 --long --icons --git --ignore-glob=\"*DS_Store*\""
alias ll="lt --all"
alias lc="l --sort=created"

alias g="jump"
alias cd="z" # zoxide
alias h="history | fzf"
alias t="tig"
alias edf="code ~/dotfiles"
alias r="bin/rails"
alias bi="bundle install"
alias o="open ."
alias c="code ."
alias n="nvim"
alias vim="nvim"
alias co="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs code"
alias ef="env | fzf | pbcopy"
alias ld="lazydocker"
alias rm="trash"
alias htop="zenith"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias j="find . -type d -name 'node_modules' -prune -o -type f -name '*.json' -print | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' | xargs fx"

alias ni="npm install"
alias ns="npm run start"

alias cat="bat"

alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"

# brew update and upgrade (verbose)
alias bup="echo 'brew update...' && brew update -v && echo '\nbrew upgrade...' && brew upgrade -v && echo '\nbrew upgrade --cask...' && brew upgrade --cask --verbose"
