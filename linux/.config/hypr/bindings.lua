-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Hyprecise: Easy window resizing for Hyprland
-- https://github.com/vitormil/hyprecise
dofile(os.getenv("HOME") .. "/.config/hyprecise/hyprecise.lua").setup()

-- PIP => Super + Y
o.bind("SUPER + Y", nil, os.getenv("HOME") .. "/.config/hypr/scripts/pip.sh")

-- Unbind default SUPER+RETURN (was: plain Terminal)
hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Herdr", { omarchy = "terminal-herdr" })
