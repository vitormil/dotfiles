#!/bin/bash
set -e

force=false
stow_args=(-vv -t ~)

for arg in "$@"; do
  case "$arg" in
    -f|--force)
      force=true
      stow_args+=(--adopt)
      ;;
  esac
done

link_vscode_user_files() {
  local target_dir="$HOME/Library/Application Support/Code/User"
  local source_dir="$HOME/.config/Code/User"

  mkdir -p "$target_dir"

  for file in settings.json keybindings.json; do
    local target="$target_dir/$file"

    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ -L "$target" ] && [ "$(readlink "$target")" = "$source_dir/$file" ]; then
        continue
      fi
      if [ "$force" = true ]; then
        rm -rf "$target"
      else
        echo "SKIP: $target already exists (use -f/--force to replace it)" >&2
        continue
      fi
    fi

    ln -s "$source_dir/$file" "$target"
    echo "LINK: $target => $source_dir/$file"
  done
}

case "$(uname -s)" in
  Linux)
    stow "${stow_args[@]}" common linux
    ;;
  Darwin)
    stow "${stow_args[@]}" common mac
    link_vscode_user_files
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac
