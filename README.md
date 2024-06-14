# My dotfiles

This repo holds the dotfiles for configuring my macOS environment, with `GNU Stow` used to manage the symbolic links. 🎉

## Stow
https://www.gnu.org/software/stow/

```
brew install stow
```

## Screenshot

![Terminal](https://raw.githubusercontent.com/vitormil/dotfiles/master/screenshots/alacritty-01e20f1af5fb365d4aeea7e4a0cf8045.png)

## Installation

1. Clone the dotfiles repo in the `$HOME` directory:

```
› cd
› git clone git@github.com/vitormil/dotfiles.git
› cd dotfiles
```

2. Use GNU stow to create symlinks:

```
› chmod +x symlinks.sh
› sh symlinks.sh
```

or just run `stow` directly:

```
› stow -vv .
```

## Inspired by

* [@marcelohmdias](https://github.com/marcelohmdias/dotfiles)

## License

The code is available under the MIT license.
