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

-- Herdr => Super+Return, singleton: focus the existing window instead of
-- opening a second one. The plain `omarchy = "terminal-herdr"` launch always
-- spawns a fresh terminal, even when Herdr's persistent session is already
-- showing in one -- so this checks for it first.
--
-- Ghostty's Wayland app-id is the marker: `--class` gives this launch a
-- value no other ghostty window has, so a match on it can only be the Herdr
-- window (title is useless here -- config.toml pins it to a fixed emoji).
local HERDR_CLASS = "com.mitchellh.ghostty.herdr"

o.bind("SUPER + RETURN", "Herdr", function()
  for _, win in ipairs(hl.get_windows()) do
    if win.class == HERDR_CLASS then
      hl.dispatch(hl.dsp.focus({ window = "address:" .. win.address }))
      return
    end
  end
  hl.exec_cmd(
    "setsid uwsm-app -- ghostty --class=" .. HERDR_CLASS ..
    ' --working-directory="$(omarchy-cmd-terminal-cwd)" -e herdr'
  )
end)
