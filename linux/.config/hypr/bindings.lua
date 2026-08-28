-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

local terminal = "uwsm app -- alacritty"
local browser = "omarchy-launch-browser"
local ghostty = "uwsm app -- ghostty --gtk-single-instance=true"

-- Unbind default SUPER+RETURN (was: Terminal, alacritty) to avoid double-launch
hl.unbind("SUPER + RETURN")
o.bind("SUPER + Return", "Terminal", ghostty)
o.bind("SUPER + G", "Ghostty", ghostty)
o.bind("SUPER + F", "File manager", "uwsm app -- nautilus --new-window")
o.bind("SUPER + B", "Browser", browser)
o.bind("SUPER + ALT + CONTROL + M", "Activity", terminal .. " -e btop")
o.bind("SUPER + Slash", "Passwords", "uwsm app -- 1password")
o.bind("SUPER + SHIFT + Q", "Flameshot", "uwsm app -- flameshot gui")

o.bind("SUPER + A", "ChatGPT", 'omarchy-launch-webapp "https://chatgpt.com"')
o.bind("SUPER + M", "YouTube Music", 'omarchy-launch-webapp "https://music.youtube.com/"')
o.bind("SUPER + SHIFT + W", "WhatsApp", 'omarchy-launch-webapp "https://web.whatsapp.com/"')
o.bind("SUPER + X", "X", 'omarchy-launch-webapp "https://x.com/i/lists/101391290"')

-- Hyprecise: Easy window resizing for Hyprland
-- https://github.com/vitormil/hyprecise
dofile(os.getenv("HOME") .. "/.config/hyprecise/hyprecise.lua").setup()

-- vicinae
o.bind("SHIFT + ALT + Space", nil, "vicinae vicinae://toggle")
o.bind("SUPER + ALT + V", nil, "vicinae vicinae://extensions/vicinae/clipboard/history")
o.bind("SUPER + ALT + E", nil, "vicinae vicinae://extensions/vicinae/vicinae/search-emojis")
o.bind("ALT + Tab", nil, "vicinae vicinae://extensions/vicinae/wm/switch-windows")

-- o.bind("SUPER + N", "Neovim", terminal .. " -e nvim")
-- o.bind("SUPER + G", "Signal", "uwsm app -- signal-desktop")
-- o.bind("SUPER + SHIFT + A", "Grok", 'omarchy-launch-webapp "https://grok.com"')
-- o.bind("SUPER + C", "Calendar", 'omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"')
-- o.bind("SUPER + E", "Email", 'omarchy-launch-webapp "https://app.hey.com"')
-- o.bind("SUPER + Y", "YouTube", 'omarchy-launch-webapp "https://youtube.com/"')
-- o.bind("SUPER + ALT + G", "Google Messages", 'omarchy-launch-webapp "https://messages.google.com/web/conversations"')
-- o.bind("SUPER + SHIFT + X", "X Post", 'omarchy-launch-webapp "https://x.com/compose/post"')

-- Overwrite existing bindings, like putting Omarchy Menu on Super + Space:
-- hl.unbind("SUPER + Space")
-- o.bind("SUPER + Space", "Omarchy menu", "omarchy-menu")

-- PIP => Super + Y
o.bind("SUPER + Y", nil, os.getenv("HOME") .. "/.config/hypr/scripts/pip.sh")
