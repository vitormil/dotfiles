-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  general = {
    -- Thicker borders, easier to grab.
    border_size = 3,
    resize_on_border = true,
  },
  decoration = {
    active_opacity = 1,
    rounding = 4,
  },
})

-- Picture-in-Picture (native Chrome/Chromium window)
--
-- Omarchy already does the heavy lifting in default/hypr/apps/pip.lua: it tags
-- anything titled "Picture in picture" with `pip` and applies float + pin.
-- Its defaults are loaded BEFORE this file, so we only override what we want
-- different here (it uses 600x338 in the top-right corner).
--
-- Tune the PiP by touching only these three variables:
local pip_w, pip_h, pip_gap = 810, 456, 40

-- CAREFUL: do not swap these constants for window_w/window_h. When `move` is
-- evaluated the window still has Chrome's original size (512x288) -- the
-- `size` set by Omarchy's default has not taken effect yet at that point.
o.window({ tag = "pip" }, {
  size = { pip_w, pip_h },
  move = { "(monitor_w-" .. pip_w .. "-" .. pip_gap .. ")", "(monitor_h-" .. pip_h .. "-" .. pip_gap .. ")" },

  -- Never steals keyboard focus (mouse clicks still work).
  -- Drop this line if you would rather use keyboard shortcuts on the PiP.
  no_focus = true,
})
