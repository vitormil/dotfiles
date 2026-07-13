alias l="eza --header --long --all --group-directories-first --ignore-glob=\"*DS_Store*\""
alias lt="eza --tree --level=2 --long --icons --git --ignore-glob=\"*DS_Store*\""
alias ll="lt --all"
alias lc="l --sort=created"

alias cd="z"
alias g="jump"
alias t="tig"

alias bi="bundle install"
alias o="open ."
alias c="code ."
alias n="nvim"
function e
    if test (uname) = Darwin
        env | fzf | pbcopy
    else
        env | fzf | wl-copy
    end
end
alias vim="nvim"

alias r="bin/rails"
alias deploy="bin/deploy"
alias dev="bin/dev"

alias htop="zenith"
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

alias ni="npm install"
alias ns="npm run start"

alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"

# system upgrade (verbose)
alias sup="echo 'Updating system packages...' && sudo pacman -Syu --noconfirm --verbose"
alias bup="echo 'brew update...' && brew update -v && echo '\nbrew upgrade...' && brew upgrade -v && echo '\nbrew upgrade --cask...' && brew upgrade --cask --verbose"
