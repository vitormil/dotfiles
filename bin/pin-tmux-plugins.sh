#!/bin/bash
# Pin tmux plugins to exact commits so both machines run identical code.
#
# TPM installs plugins with `git clone -b <ref>`, which accepts a branch or a
# tag but not a commit SHA. Of the plugins used here only catppuccin has usable
# tags (pinned in tmux.conf); the rest are untagged upstream, or their newest
# tag is years behind master. So TPM installs them at whatever master happens to
# be that day, and two machines provisioned on different dates diverge.
#
# This script re-pins them afterwards. Run it after `prefix + I` (and after
# `prefix + U`, which moves plugins back to master). It is idempotent, and
# skips any plugin that is not installed yet.
#
# To take an upgrade: bump the SHA here deliberately, don't drift into one.
set -e

# Mirrors TPM's own logic (tpm/tpm:set_default_tpm_path): when the config lives
# at the XDG path, TPM keeps plugins beside it rather than in ~/.tmux/plugins.
xdg_tmux_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
if [ -f "$xdg_tmux_dir/tmux.conf" ]; then
  plugins_dir="$xdg_tmux_dir/plugins"
else
  plugins_dir="$HOME/.tmux/plugins"
fi

pins=(
  "tpm            e261deb1b47614eed3400089ce7197dc68acc4eb"
  "tmux-fzf-url   c71d2113b4cb00eb159ad723fc5072ff5ec738b8"
  "tmux-yank      acfd36e4fcba99f8310a7dfb432111c242fe7392"
  "tmux-resurrect cff343cf9e81983d3da0c8562b01616f12e8d548"
  "tmux-continuum 0698e8f4b17d6454c71bf5212895ec055c578da0"
)

for pin in "${pins[@]}"; do
  read -r name sha <<<"$pin"
  dir="$plugins_dir/$name"

  if [ ! -d "$dir/.git" ]; then
    echo "SKIP: $name is not installed"
    continue
  fi

  if [ "$(git -C "$dir" rev-parse HEAD)" = "$sha" ]; then
    echo "OK:   $name already at ${sha:0:8}"
    continue
  fi

  # TPM clones with --single-branch, so the pinned commit is usually absent
  # from the local object store until fetched explicitly.
  git -C "$dir" fetch -q origin "$sha" 2>/dev/null || git -C "$dir" fetch -q origin
  git -C "$dir" checkout -q --detach "$sha"
  echo "PIN:  $name -> ${sha:0:8}"
done
