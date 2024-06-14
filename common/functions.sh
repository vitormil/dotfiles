#!/bin/bash

open_todo() {
  sh ~/dotfiles/custom/open_todo.sh
}

todo() {
  if [ $# -eq 0 ]; then
      open_todo
      return
  fi

  local result=""
  for param in "$@"; do
      result+="$param "
  done

  sh ~/dotfiles/custom/add_todo.sh "$result"
  open_todo
}
