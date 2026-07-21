set -g fish_greeting

starship init fish | source
zoxide init fish | source
mise activate fish | source
atuin init fish --disable-up-arrow | source

if test -f ~/private/init.fish
    source ~/private/init.fish
else if test -f ~/private/init.sh
    source_bash_env ~/private/init.sh
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
