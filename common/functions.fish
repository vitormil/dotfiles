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

# fzf + cd
function fcd
    set search_path (test (count $argv) -eq 0; and echo .; or echo $argv[1])

    if test (count $argv) -ge 2
        set dir (fd --type d --hidden --exclude '.*' . $search_path | fzf +m --query="$argv[2]")
    else
        set dir (fd --type d --hidden --exclude '.*' . $search_path | fzf +m)
    end

    and cd $dir
end

# Inspired by https://github.com/tobi/try
function try
    if test "$argv[1]" = "new"
        set current_date (date +"%Y-%m-%d")
        set project_name (read -P "Enter project name: $current_date-")
        if test -z "$project_name"
            return 1
        end
        set project_name (string replace " " "-" $project_name)
        set project_dir "$HOME/src/tries/$current_date-$project_name"
        mkdir -p "$project_dir"
        cd "$project_dir"
    else
       fcd ~/src/tries $argv[1]
    end
end
