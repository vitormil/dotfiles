#!/bin/bash

function tt
  set -l socket /tmp/tmux-(id -u)/trustly
  set -l selection (cat ~/private/.tmux-sessions | fzf)
  if test -n "$selection"
    tmux -S $socket new-session -A -s "$selection"
  else
    echo "tt aborted."
  end
end
