#!/bin/bash
set -e

if ! command -v pacman &>/dev/null; then
  echo "pacman not found — init-linux.sh only supports Arch Linux / Omarchy." >&2
  exit 1
fi

if ! command -v yay &>/dev/null; then
  echo "yay not found — install it first: https://wiki.archlinux.org/title/AUR_helpers" >&2
  exit 1
fi

sudo pacman -S --needed - <pacman-packages.txt
yay -S --needed - <aur-packages.txt

gh extension install dlvhdr/gh-dash

if [ ! -d ~/.config/tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi
./bin/pin-tmux-plugins.sh

if [ "$SHELL" != "$(which fish)" ]; then
  chsh -s "$(which fish)"
fi

rm -f ~/.config/omarchy/current/theme/backgrounds/*
cp backgrounds/* ~/.config/omarchy/current/theme/backgrounds

./symlinks.sh "$@"

echo
echo "Open tmux and press prefix + I to install tmux plugins,"
echo "then run ./bin/pin-tmux-plugins.sh to pin them to the recorded commits."
