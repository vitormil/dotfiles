#!/bin/bash

function tt
  set -l session_name
  if test (uname) = Linux
    set session_name vitor
  else
    set session_name trustly
  end
  set -l uid (id -u)
  set -l socket /tmp/tmux-$uid/$session_name
  mkdir -p /tmp/tmux-$uid
  set -l selection (cat ~/private/.tmux-sessions | fzf)
  if test -n "$selection"
    if tmux -S $socket has-session -t "$selection" 2>/dev/null
      tmux -S $socket attach-session -t "$selection"
    else
      tmux -S $socket new-session -s "$selection"
    end
  else
    echo "tt aborted."
  end
end

function normalize-log-dates -d "Replace timestamps and @<hash> refs in a log file with fixed placeholders, backing up to <file>.bak"
  if test (count $argv) -ne 1
    echo "Usage: normalize-log-dates <file>" >&2
    return 1
  end

  set -l file $argv[1]

  if not test -f "$file"
    echo "File not found: $file" >&2
    return 1
  end

  perl -i.bak -pe '
    # 2026/07/17 20:01:10.538 => 9999/99/99 99:99:99.999
    s/\b\d{4}\/\d{1,2}\/\d{1,2}[ T]\d{1,2}:\d{1,2}:\d{1,2}\.\d+\b/9999\/99\/99 99:99:99.999/g;

    # Jul 17, 2026 8:01:12 PM => MON 99, 9999 99:99:99 XX
    s/\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2},\s+\d{4}\s+\d{1,2}:\d{1,2}:\d{1,2}\s*(?:AM|PM)\b/MON 99, 9999 99:99:99 XX/gi;

    # 20:01:01,367 => 99:99:99,999
    s/\b\d{1,2}:\d{1,2}:\d{1,2},\d+\b/99:99:99,999/g;

    # @5e583af4 => @XXXXXXXX
    s/@([0-9a-fA-F]{4,40})\b/"@" . ("X" x length($1))/ge;
  ' "$file"
end
