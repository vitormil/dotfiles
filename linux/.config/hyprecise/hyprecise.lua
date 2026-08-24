-- -----------------------------------------------------------------------------
-- Project: Hyprecise - Precise window resizing for Hyprland
-- Author: Vitor Oliveira
-- License: MIT
--
-- Copyright (c) 2025 Vitor Oliveira
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-- -----------------------------------------------------------------------------
--
-- Hyprecise controls the WIDTH of tiled columns, and only the width. No
-- dispatch it issues ever changes a window's height.
--
-- The workspace is read as a row of columns (windows sharing an x-interval).
-- Resizing moves the focused column onto the next stop of a "ladder" of widths,
-- and the remaining columns split what is left over EQUALLY.
--
-- Direction is expressed in screen space, not in grow/shrink terms: `right`
-- moves the focused column's RIGHT boundary rightward. For every column but the
-- last that boundary is movable, so the column grows. For the last column the
-- right boundary is the screen edge, so `right` falls back to moving its LEFT
-- boundary rightward and the column shrinks. That rule is what makes a
-- two-window layout behave the way it always has, from either focus position.
--
-- The pure decision logic (`columns`, `decomposable`, `plan`) has no Hyprland
-- dependency and is exercised by tests/hyprecise_spec.lua under plain `lua`.

local M = {}

-- --------------------------------------------------------------------------
-- Helpers
-- --------------------------------------------------------------------------

local function idiv(a, b)
  return math.floor(a / b)
end

local function round(x)
  return math.floor(x + 0.5)
end

local DEFAULTS = {
  mode = "auto", -- auto | wide | compact
  loop = true, -- wrap around the ends of the ladder
  min_width = nil, -- floor for a non-focused column; nil = monitor/12
  snap = nil, -- "same stop" tolerance; nil = max(16, monitor/100)
  column_tolerance = 8, -- px slack when bucketing windows into columns
  converge_tolerance = 4, -- px; below this a column is considered on target
  max_passes = 4, -- sweep attempts before giving up
}

local function with_defaults(user)
  local opts = {}
  for k, v in pairs(DEFAULTS) do
    opts[k] = v
  end
  for k, v in pairs(user or {}) do
    if v ~= nil then
      opts[k] = v
    end
  end
  return opts
end

-- The "same stop" tolerance. Every other epsilon is derived from it, so a
-- keypress can never produce a move smaller than the ambiguity that made two
-- ladder stops indistinguishable in the first place.
local function snap_of(monitor_width, opts)
  return opts.snap or math.max(16, idiv(monitor_width, 100))
end

-- --------------------------------------------------------------------------
-- Columns (pure)
-- --------------------------------------------------------------------------

--- Bucket boxes into columns by x-interval.
--- @param boxes table array of { x, y, w, id }
--- @param tol number px slack
--- @return table array of columns, sorted left to right
function M.columns(boxes, tol)
  tol = tol or DEFAULTS.column_tolerance
  local cols = {}
  for _, b in ipairs(boxes) do
    local found
    for _, c in ipairs(cols) do
      if math.abs(c.x - b.x) <= tol and math.abs(c.w - b.w) <= tol then
        found = c
        break
      end
    end
    if found then
      found.ids[#found.ids + 1] = b.id
      if b.y < found.top then
        found.top = b.y
        found.rep = b.id
      end
    else
      cols[#cols + 1] = { x = b.x, w = b.w, top = b.y, rep = b.id, ids = { b.id } }
    end
  end
  table.sort(cols, function(a, b)
    if a.x ~= b.x then
      return a.x < b.x
    end
    return a.w < b.w
  end)
  return cols
end

--- True when the columns tile the row without overlapping.
--- A window spanning two columns (e.g. [A][B] over a full-width C) produces
--- overlapping buckets and is rejected here as a "ragged" layout.
function M.decomposable(cols, tol)
  tol = tol or DEFAULTS.column_tolerance
  for i = 1, #cols - 1 do
    if cols[i].x + cols[i].w > cols[i + 1].x + tol then
      return false
    end
  end
  return true
end

-- --------------------------------------------------------------------------
-- Ladder (pure)
-- --------------------------------------------------------------------------

--- The mode-derived stops, as fractions of the monitor width.
function M.base_ladder(monitor_width, mode)
  if mode ~= "wide" and mode ~= "compact" then
    mode = monitor_width >= 3440 and "wide" or "compact"
  end
  if mode == "wide" then
    local base = idiv(monitor_width, 6)
    return { base, base * 2, base * 3, base * 4, base * 5 }
  end
  local q = idiv(monitor_width, 4)
  return { q, q * 2, q * 3 }
end

--- Splice the equal-split width into the ladder and drop stops that would
--- starve another column below the floor.
--- @return table ladder, number fair
function M.build_ladder(monitor_width, usable, n, opts)
  opts = with_defaults(opts)
  local stops = M.base_ladder(monitor_width, opts.mode)
  local fair = idiv(usable, n)
  local snap = snap_of(monitor_width, opts)

  -- Insert `fair`, replacing any stop it is indistinguishable from. Keeping
  -- both would leave two stops a few px apart and make one keypress a
  -- near-no-op.
  local spliced, placed = {}, false
  for _, s in ipairs(stops) do
    if not placed and math.abs(s - fair) <= snap then
      spliced[#spliced + 1] = fair
      placed = true
    elseif not placed and s > fair then
      spliced[#spliced + 1] = fair
      spliced[#spliced + 1] = s
      placed = true
    else
      spliced[#spliced + 1] = s
    end
  end
  if not placed then
    spliced[#spliced + 1] = fair
  end

  local floor_w = opts.min_width or idiv(monitor_width, 12)
  local max_focused = usable - (n - 1) * floor_w
  local ladder = {}
  for _, s in ipairs(spliced) do
    if s >= floor_w and s <= max_focused then
      ladder[#ladder + 1] = s
    end
  end
  return ladder, fair
end

-- --------------------------------------------------------------------------
-- Target selection (pure)
-- --------------------------------------------------------------------------

--- Spread `usable - target` equally over the non-focused columns, handing the
--- remainder pixels out one at a time so repeated presses cannot drift.
local function distribute(usable, target, n, focused)
  local targets = {}
  local rest = usable - target
  local each = idiv(rest, n - 1)
  local extra = rest - each * (n - 1)
  local k = 0
  for i = 1, n do
    if i == focused then
      targets[i] = target
    else
      k = k + 1
      targets[i] = each + (k <= extra and 1 or 0)
    end
  end
  return targets
end

local DIRECTIONS = { left = true, right = true, up = true, down = true }

--- Decide the target width of every column.
--- @param input table { widths, focused, direction, monitor_width, opts }
--- @return table|nil { targets, ladder, fair, target, usable } or nil for no-op
function M.plan(input)
  if not DIRECTIONS[input.direction] then
    return nil
  end
  local widths = input.widths
  local n = #widths
  local focused = input.focused
  if n < 2 or not focused or focused < 1 or focused > n then
    return nil
  end

  local opts = with_defaults(input.opts)
  local monitor_width = input.monitor_width
  local snap = snap_of(monitor_width, opts)

  local usable = 0
  for _, w in ipairs(widths) do
    usable = usable + w
  end

  local ladder, fair = M.build_ladder(monitor_width, usable, n, opts)
  if #ladder == 0 then
    return nil
  end
  -- The floor may have trimmed `fair` off the ladder; keep it in range so
  -- up/down always land on a reachable width.
  local fair_stop = math.max(ladder[1], math.min(ladder[#ladder], fair))

  local current = widths[focused]
  local target = M.step(ladder, current, fair_stop, input.direction, focused == n, snap, opts.loop)
  if not target or math.abs(target - current) <= opts.converge_tolerance then
    return nil
  end

  return {
    targets = distribute(usable, target, n, focused),
    ladder = ladder,
    fair = fair_stop,
    target = target,
    usable = usable,
  }
end

--- Move one stop along the ladder, past `current` in the requested direction.
function M.step(ladder, current, fair, direction, is_last, snap, loop)
  local lo, hi = ladder[1], ladder[#ladder]

  if direction == "up" then
    if math.abs(current - hi) <= snap then
      return fair
    end
    return hi
  elseif direction == "down" then
    if math.abs(current - fair) <= snap then
      return lo
    end
    return fair
  end

  local grow
  if direction == "right" then
    grow = not is_last
  else
    grow = is_last
  end

  if grow then
    for _, s in ipairs(ladder) do
      if s > current + snap then
        return s
      end
    end
    return loop and lo or hi
  end
  for i = #ladder, 1, -1 do
    if ladder[i] < current - snap then
      return ladder[i]
    end
  end
  return loop and hi or lo
end

-- --------------------------------------------------------------------------
-- Hyprland shell (impure)
-- --------------------------------------------------------------------------

--- Logical width of a monitor, accounting for rotation and scale. Window
--- coordinates are logical, so the raw `width` is wrong on a scaled output.
local function monitor_width(m)
  local w, h = m.width, m.height
  local transform = m.transform or 0
  if transform % 2 == 1 then
    w, h = h, w
  end
  local scale = m.scale or 1
  if scale and scale > 0 then
    w = w / scale
  end
  return round(w)
end

local function tiled_windows(ws)
  local out = {}
  for _, w in ipairs(hl.get_workspace_windows(ws) or {}) do
    if w.mapped and not w.hidden and not w.floating and (w.fullscreen or 0) == 0 then
      out[#out + 1] = w
    end
  end
  return out
end

local function resize(win, delta)
  hl.dispatch(hl.dsp.window.resize({
    x = delta,
    y = 0,
    relative = true,
    window = "address:" .. win.address,
  }))
end

--- Walk the columns left to right, nudging each onto its target and re-reading
--- geometry as we go. A dwindle resize is tree-relative, so one sweep only
--- converges for right-nested trees; repeat until everything is on target.
local function apply(cols, targets, opts)
  for _ = 1, opts.max_passes do
    for i = 1, #cols - 1 do
      local delta = targets[i] - cols[i].win.size.x
      if math.abs(delta) > opts.converge_tolerance then
        resize(cols[i].win, delta)
      end
    end
    local worst = 0
    for i = 1, #cols do
      local err = math.abs(targets[i] - cols[i].win.size.x)
      if err > worst then
        worst = err
      end
    end
    if worst <= opts.converge_tolerance then
      return true
    end
  end
  return false
end

--- Ragged layouts have no column decomposition, so there is nothing to
--- distribute equally. Step the focused window itself and let dwindle spread
--- the difference however its tree says.
local function ragged(win, monitor, direction, opts)
  local mw = monitor_width(monitor)
  local ladder = M.base_ladder(mw, opts.mode)
  if #ladder == 0 then
    return
  end
  local snap = snap_of(mw, opts)
  local current = win.size.x
  local reserved = monitor.reserved or {}
  local monitor_right = (monitor.x or 0) + mw - (reserved.right or 0)
  local is_last = (win.at.x + current) >= (monitor_right - 3 * opts.column_tolerance)
  local fair = ladder[idiv(#ladder + 1, 2)]

  local target = M.step(ladder, current, fair, direction, is_last, snap, opts.loop)
  if not target or math.abs(target - current) <= opts.converge_tolerance then
    return
  end
  resize(win, target - current)
end

--- Entry point. Silent on every no-op path: this runs on a keybind, so there
--- is nowhere for a message to go.
local function run(direction, user_opts)
  if not DIRECTIONS[direction] then
    return
  end
  local opts = with_defaults(user_opts)

  local win = hl.get_active_window()
  if not win or win.floating or (win.fullscreen or 0) ~= 0 then
    return
  end
  local ws = win.workspace
  if not ws then
    return
  end

  local wins = tiled_windows(ws)
  if #wins < 2 then
    return
  end

  local boxes = {}
  for i, w in ipairs(wins) do
    boxes[i] = { x = w.at.x, y = w.at.y, w = w.size.x, id = i }
  end

  local cols = M.columns(boxes, opts.column_tolerance)
  if #cols < 2 then
    -- One column: a lone window or a pure vertical stack. There is no vertical
    -- boundary to move and heights are out of scope, so there is nothing to do.
    return
  end

  local monitor = win.monitor
  if not M.decomposable(cols, opts.column_tolerance) then
    return ragged(win, monitor, direction, opts)
  end

  local widths, focused = {}, nil
  for i, c in ipairs(cols) do
    widths[i] = c.w
    c.win = wins[c.rep]
    for _, id in ipairs(c.ids) do
      if wins[id].address == win.address then
        focused = i
      end
    end
  end
  if not focused then
    return
  end

  local plan = M.plan({
    widths = widths,
    focused = focused,
    direction = direction,
    monitor_width = monitor_width(monitor),
    opts = opts,
  })
  if not plan then
    return
  end

  apply(cols, plan.targets, opts)
end

M.run = run

return setmetatable(M, {
  __call = function(_, direction, opts)
    return run(direction, opts)
  end,
})
