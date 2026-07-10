# Dotfiles

Shared between Arch Linux (Omarchy) and macOS. Symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow).

## Structure

- `common/` — config shared identically across Linux and macOS
- `linux/` — Linux-only config (Hyprland, tofi, vicinae, ...)
- `mac/` — macOS-only config (Homebrew `$PATH`, ...)
- repo root — everything else: package manifests, `backgrounds/`, docs

See [`CONTEXT.md`](./CONTEXT.md) for the reasoning behind this layout.

## Setup

```shell
cd
git clone git@github.com:vitormil/dotfiles.git
cd dotfiles
./symlinks.sh
```

Detects the OS and stows `common` + `linux` or `common` + `mac`. Add `-f`/`--force` to adopt pre-existing files instead of failing on conflicts:

```shell
./symlinks.sh -f
```

### Packages

```shell
# Linux
sudo pacman -S --needed - < pacman-packages.txt
yay -S --needed - < aur-packages.txt

# macOS
brew bundle --file=Brewfile
```

### Fish as default shell

```shell
chsh -s $(which fish)
```

### tmux plugins

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux   # then prefix + I to install plugins
```

### Omarchy backgrounds (Linux only)

```shell
rm ~/.config/omarchy/current/theme/backgrounds/*
cp ~/dotfiles/backgrounds/* ~/.config/omarchy/current/theme/backgrounds
```

## License

MIT.
