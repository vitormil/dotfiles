set -g fish_greeting

starship init fish | source
zoxide init fish | source
mise activate fish | source

if test -f ~/private/init.fish
    source_bash_env ~/private/init.fish
end

set -g font "Fira Code Nerd Font"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/vitor.oliveira/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
set -gx PNPM_HOME "$HOME/.pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
