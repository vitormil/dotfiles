-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    numlock_by_default = true,
    follow_mouse = 0,
    mouse_refocus = false,

    kb_layout = "us",
    kb_variant = "intl",
    kb_model = "pc10555",

    -- Change speed of keyboard repeat.
    repeat_rate = 80,
    repeat_delay = 250,

    scroll_factor = 0.4,

    touchpad = {
      scroll_factor = 0.4,
    },
  },
})

-- App-specific touchpad scroll speeds.
o.window("(Alacritty|kitty|ghostty)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
