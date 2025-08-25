# Dotfiles

This repository contains the dotfiles for my Arch Linux, based on [Omarchy](https://omarchy.org), with [GNU Stow](https://www.gnu.org/software/stow) managing the symbolic links.

## Packages

- Export: `pacman -Qq > pacman-packages.txt`
- Import: `pacman -S --needed - < pacman-packages.txt`

## Installation

1; Clone the dotfiles repo in the `$HOME` directory:

```shell
› cd
› git clone git@github.com/vitormil/dotfiles.git
› cd dotfiles
```

2; Use GNU stow to create symlinks:

```shell
› sh symlinks.sh
```

## License

The code is available under the MIT license.
