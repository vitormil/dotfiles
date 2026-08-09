#!/usr/bin/env bash
set -euo pipefail

# Native Chrome/Chromium Picture-in-Picture, cycling through two sizes:
#
#   closed  ->  base size  ->  30% larger  ->  closed
#
# Chrome exposes no native keyboard shortcut for PiP, so the actual trigger is
# the `pip-toggle` extension (linux/.local/share/chromium-extensions/), which
# registers the action on Alt+Shift+Y. This script injects that key into the
# right window via `hyprctl dispatch sendshortcut`.
#
# The INITIAL size and position come from the window rules on the `pip` tag, in
# ~/.config/hypr/looknfeel.conf. The second size is computed here from the
# window's live geometry -- deliberately, so the looknfeel.conf constants are
# not duplicated in two places that can drift apart over time.

SHORTCUT="ALT SHIFT, Y"
BROWSERS='^([cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable)$'

# Second size, as a percentage of the first. It is linear (each side grows by
# 30%), not by area -- 130 here means 810x456 -> 1053x593.
GROW_PCT=130

# Remembers which window opened the PiP and where we are in the cycle
# ("<addr> <n>"). Deliberately in the runtime dir: this is ephemeral state, and
# it disappears on reboot along with the window addresses it holds.
STATE="${XDG_RUNTIME_DIR:-/tmp}/hypr-pip-owner"

# Most recently used browser window (lowest focusHistoryID) rather than
# `activewindow`, so the shortcut works from anywhere, including with the
# editor in the foreground.
addr=$(hyprctl -j clients | jq -r --arg re "$BROWSERS" '
  [ .[] | select((.class // "") | test($re)) ]
  | sort_by(.focusHistoryID)
  | .[0].address // empty
')

if [ -z "$addr" ]; then
  notify-send -a PiP "PiP" "No Chrome/Chromium window open" 2>/dev/null || true
  exit 1
fi

# Geometry of the PiP window. Empty means PiP is closed.
#
# Omarchy applies the tag dynamically, and hyprctl prints those with a `*`
# suffix ("pip*") -- hence the rtrimstr instead of comparing to "pip" directly.
pip=$(hyprctl -j clients | jq -r '
  [ .[] | select((.tags // []) | any(rtrimstr("*") == "pip")) ][0]
  | if . == null then empty
    else "\(.address) \(.size[0]) \(.size[1]) \(.at[0]) \(.at[1]) \(.monitor)"
    end
')

owner=""
step=""
if [ -r "$STATE" ]; then
  read -r owner step <"$STATE" || true
fi

# --- PiP closed: open it at the base size ---
if [ -z "$pip" ]; then
  hyprctl dispatch sendshortcut "$SHORTCUT, address:$addr"
  printf '%s 1\n' "$addr" >"$STATE"
  exit 0
fi

read -r pip_addr pw ph px py pmon <<<"$pip"

# To resize or close, the key must go to the window that opened the PiP -- not
# to the most recent browser. Without this, glancing at another Chromium window
# (WhatsApp, say) makes Super+Y aim at it: the PiP does not close and focus
# returns to the wrong window.
#
# Verified empirically: what decides which tab runs the action is the
# `sendshortcut` target, not the window Chrome itself considers focused. That
# is why recording the address at open time works.
if [ -n "$owner" ] &&
  hyprctl -j clients | jq -e --arg a "$owner" 'any(.[]; .address == $a)' >/dev/null; then
  addr=$owner
fi

# --- step 1: grow, preserving the right and bottom margins ---
if [ "${step:-2}" = 1 ]; then
  # Window rules use LOGICAL pixels, but the monitor's .width/.height are the
  # PHYSICAL resolution -- dividing by .scale keeps the math right on monitors
  # with scale != 1. It looks redundant at scale 1.0; it is not.
  read -r mx my mw mh < <(
    hyprctl -j monitors | jq -r --argjson id "$pmon" '
      .[] | select(.id == $id)
      | "\(.x) \(.y) \((.width / .scale) | floor) \((.height / .scale) | floor)"
    '
  )

  # Margins are DERIVED from the current position rather than re-read from
  # looknfeel.conf: the second size then honours whatever margin is configured
  # there without having to know it.
  gap_r=$((mx + mw - px - pw))
  gap_b=$((my + mh - py - ph))

  nw=$(((pw * GROW_PCT + 50) / 100))
  nh=$(((ph * GROW_PCT + 50) / 100))
  nx=$((mx + mw - gap_r - nw))
  ny=$((my + mh - gap_b - nh))

  hyprctl --batch "\
    dispatch resizewindowpixel exact $nw $nh,address:$pip_addr ; \
    dispatch movewindowpixel exact $nx $ny,address:$pip_addr"

  printf '%s 2\n' "$addr" >"$STATE"
  exit 0
fi

# --- step 2 (or a PiP opened outside the cycle, e.g. via the extension button,
# leaving no recorded state): close it and hand focus back ---
hyprctl dispatch sendshortcut "$SHORTCUT, address:$addr"

# `focuswindow` already switches workspaces when the window lives on another
# one, which covers "jump to the right desktop and focus Chrome".
hyprctl dispatch focuswindow "address:$addr"
rm -f "$STATE"
