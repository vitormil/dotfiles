#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  echo "brew not found — install Homebrew first: https://brew.sh" >&2
  exit 1
fi

brew bundle --file=Brewfile

gh extension install dlvhdr/gh-dash

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ "$SHELL" != "$(which fish)" ]; then
  chsh -s "$(which fish)"
fi

# Speed up Dock show/hide animation (default is ~0.5s)
defaults write com.apple.dock autohide-time-modifier -float 0.15
killall Dock

./symlinks.sh "$@"

echo
echo "Open tmux and press prefix + I to install tmux plugins."
