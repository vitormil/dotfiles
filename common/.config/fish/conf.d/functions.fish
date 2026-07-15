#!/bin/bash

function s
  set -l sesh_cmd sesh
  if test -f ~/private/sesh-config.toml
    set sesh_cmd sesh --config ~/private/sesh-config.toml
  end

  set -l selection ($sesh_cmd list | fzf)
  if test -n "$selection"
    $sesh_cmd connect "$selection"
  else
    echo "Sesh connect aborted."
  end
end
