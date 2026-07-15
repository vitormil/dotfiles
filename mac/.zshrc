export PATH="/opt/homebrew/bin:$PATH"

if [[ $- == *i* ]] && [[ -z "$FISH_VERSION" ]] && [[ -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then
    exec fish
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/vitor.oliveira/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export GPG_TTY=$(tty)
