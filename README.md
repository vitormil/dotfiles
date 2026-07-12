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

# Linux
./init-linux.sh

# macOS
./init-mac.sh
```

Installs packages (`pacman`/`yay` or `brew bundle`), sets `fish` as the default shell, clones `tpm`, copies Omarchy backgrounds (Linux only), then runs `./symlinks.sh` to stow the dotfiles. Both scripts fail loudly if their main package manager (`pacman`/`yay` or `brew`) isn't installed yet, with a link to install it.

Add `-f`/`--force` to adopt pre-existing files instead of failing on conflicts (forwarded to `symlinks.sh`):

```shell
./init-mac.sh -f
```

### tmux plugins

After the init script finishes, open tmux and press `prefix + I` to install tmux plugins — this step is interactive and can't be automated.

## License

MIT.
