# Dotfiles

This repository contains the dotfiles for my Arch Linux, based on [Omarchy](https://omarchy.org), with [GNU Stow](https://www.gnu.org/software/stow) managing the symbolic links.

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

## Packages (A-Z)

| Project Name | GitHub Repository | Category | Description |
|--------------|------------------|----------|-------------|
| fish | [fish-shell/fish-shell](https://github.com/fish-shell/fish-shell) | Shell | Smart and user-friendly command line shell |
| ghostty | [ghostty-org/ghostty](https://github.com/ghostty-org/ghostty) | Terminal Emulator | Fast, feature-rich terminal emulator written in Zig |
| git-delta | [dandavison/delta](https://github.com/dandavison/delta) | Development Tools | Syntax-highlighting pager for git, diff, and grep output |
| gum | [charmbracelet/gum](https://github.com/charmbracelet/gum) | Terminal UI | Tool for creating glamorous shell scripts with interactive elements |
| hunspell-pt-br | [hunspell/hunspell](https://github.com/hunspell/hunspell) | Language Tools | Portuguese (Brazil) dictionary for Hunspell spell checker |
| hyprmon | [erans/hyprmon](https://github.com/erans/hyprmon) | Window Manager | Monitor management utility for Hyprland wayland compositor |
| localsend | [localsend/localsend](https://github.com/localsend/localsend) | File Transfer | Cross-platform tool for sharing files to nearby devices |
| powerline-fonts | [powerline/fonts](https://github.com/powerline/fonts) | Fonts | Patched fonts for Powerline status plugin |
| sesh-bin | [joshmedeski/sesh](https://github.com/joshmedeski/sesh) | Terminal Tools | Smart terminal session manager for tmux and zellij |
| starship | [starship/starship](https://github.com/starship/starship) | Shell Enhancement | Fast, customizable prompt for any shell |
| stow | [aspiers/stow](https://github.com/aspiers/stow) | System Management | Symlink farm manager for organizing dotfiles |
| the_silver_searcher | [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher) | Search Tools | Fast code searching tool similar to ack |
| tmux | [tmux/tmux](https://github.com/tmux/tmux) | Terminal Tools | Terminal multiplexer for managing multiple terminal sessions |
| trashy | [oberblastmeister/trashy](https://github.com/oberblastmeister/trashy) | System Utilities | Simple, fast, and featureful alternative to rm with recycle bin |
| trimage-git | [Kilian/Trimage](https://github.com/Kilian/Trimage) | Image Processing | Lossless image optimizer for PNG and JPG files |
| ttf-dejavu | [dejavu-fonts/dejavu-fonts](https://github.com/dejavu-fonts/dejavu-fonts) | Fonts | Family of fonts based on Vera fonts |
| ttf-fira-code | [tonsky/FiraCode](https://github.com/tonsky/FiraCode) | Fonts | Monospaced font with programming ligatures |
| vicinae-bin | [vicinaehq/vicinae](https://github.com/vicinaehq/vicinae) | Development Tools | Contextual file finder and opener for developers |
| visual-studio-code-bin | [microsoft/vscode](https://github.com/microsoft/vscode) | Code Editor | Feature-rich code editor and IDE |
| xclip | [astrand/xclip](https://github.com/astrand/xclip) | System Utilities | Command line interface to X11 clipboard |
| zoxide | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) | Navigation | Smarter cd command that learns your habits |

## License

The code is available under the MIT license.
