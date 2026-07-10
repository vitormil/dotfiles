#!/bin/bash

# _fzf_comprun() {
#   local command=$1
#   shift

#   case "$command" in
#     cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
#     *)            fzf "$@" ;;
#   esac
# }

# open_todo() {
#   sh ~/dotfiles/custom/open_todo.sh
# }

# todo() {
#   if [ $# -eq 0 ]; then
#       open_todo
#       return
#   fi

#   local result=""
#   for param in "$@"; do
#       result+="$param "
#   done

#   sh ~/dotfiles/custom/add_todo.sh "$result"
#   open_todo
# }

function s
  sesh connect $(sesh list | fzf)
end
