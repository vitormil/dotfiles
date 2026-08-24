-- Offline tests for the pure decision core of hyprecise.
--
-- Run with the same interpreter Hyprland embeds (Lua 5.5):
--   lua tests/hyprecise_spec.lua
--
-- This file deliberately lives outside the Stow packages so it never lands in
-- $HOME. It touches no Hyprland API: only M.columns, M.decomposable,
-- M.base_ladder, M.build_ladder, M.step and M.plan.

local here = arg[0]:match("(.*)/") or "."
local M = dofile(here .. "/../linux/.config/hyprecise/hyprecise.lua")

local MW = 3440 -- the ultrawide this config targets
local passed, failed = 0, 0

local function fmt(v)
  if type(v) ~= "table" then
    return tostring(v)
  end
  local parts = {}
  for _, x in ipairs(v) do
    parts[#parts + 1] = tostring(x)
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function same(a, b)
  if type(a) ~= "table" or type(b) ~= "table" then
    return a == b
  end
  if #a ~= #b then
    return false
  end
  for i = 1, #a do
    if a[i] ~= b[i] then
      return false
    end
  end
  return true
end

local function check(name, got, want)
  if same(got, want) then
    passed = passed + 1
    print(string.format("ok    %-46s %s", name, fmt(got)))
  else
    failed = failed + 1
    print(string.format("FAIL  %-46s got %s want %s", name, fmt(got), fmt(want)))
  end
end

local function plan(widths, focused, direction, opts)
  return M.plan({
    widths = widths,
    focused = focused,
    direction = direction,
    monitor_width = MW,
    opts = opts,
  })
end

local function targets(widths, focused, direction, opts)
  local p = plan(widths, focused, direction, opts)
  return p and p.targets or nil
end

-- ---------------------------------------------------------------------------
-- Ladder construction
-- ---------------------------------------------------------------------------

check("base_ladder auto @3440 -> wide", M.base_ladder(MW, "auto"), { 573, 1146, 1719, 2292, 2865 })
check("base_ladder auto @1920 -> compact", M.base_ladder(1920, "auto"), { 480, 960, 1440 })
check("base_ladder forced compact @3440", M.base_ladder(MW, "compact"), { 860, 1720, 2580 })

-- Real geometry: two windows on this monitor sum to 3398, not 3440 (gaps and
-- borders eat 42px). Fair share is therefore 1699, which is within snap of the
-- 1719 stop and replaces it.
local l2 = M.build_ladder(MW, 3398, 2)
check("N=2 ladder (fair 1699 replaces 1719)", l2, { 573, 1146, 1699, 2292, 2865 })

local l3 = M.build_ladder(MW, 3382, 3)
check("N=3 ladder (fair 1127 replaces 1146)", l3, { 573, 1127, 1719, 2292 })

local l4 = M.build_ladder(MW, 3380, 4)
check("N=4 ladder (fair 845 spliced in)", l4, { 573, 845, 1146, 1719, 2292 })

local l6 = M.build_ladder(MW, 3360, 6)
check("N=6 ladder (top stops trimmed by floor)", l6, { 560, 1146, 1719 })

-- ---------------------------------------------------------------------------
-- N=2 -- must keep behaving the way it always has, from either focus position
-- ---------------------------------------------------------------------------

local two = { 1719, 1679 }

check("N=2 focus0 right  -> left col grows", targets(two, 1, "right"), { 2292, 1106 })
check("N=2 focus1 right  -> left col grows (inverts)", targets(two, 2, "right"), { 2252, 1146 })
check("N=2 focus0 left   -> left col shrinks", targets(two, 1, "left"), { 1146, 2252 })
check("N=2 focus1 left   -> right col grows", targets(two, 2, "left"), { 1106, 2292 })

-- The key property the whole direction rule exists to preserve: `right` moves
-- the boundary rightward no matter which of the two windows is focused.
local r0 = targets(two, 1, "right")
local r1 = targets(two, 2, "right")
check("N=2 right grows col0 from BOTH focuses", { r0[1] > two[1], r1[1] > two[1] }, { true, true })
local x0 = targets(two, 1, "left")
local x1 = targets(two, 2, "left")
check("N=2 left shrinks col0 from BOTH focuses", { x0[1] < two[1], x1[1] < two[1] }, { true, true })

check("N=2 focus0 up     -> maximize", targets(two, 1, "up"), { 2865, 533 })
check("N=2 maxed  up     -> back to equal", targets({ 2865, 533 }, 1, "up"), { 1699, 1699 })
check("N=2 focus0 down   -> already equal, minimize", targets(two, 1, "down"), { 573, 2825 })
check("N=2 wide   down   -> equalize", targets({ 2865, 533 }, 1, "down"), { 1699, 1699 })

-- ---------------------------------------------------------------------------
-- N=3 -- the case that motivated the rewrite
-- ---------------------------------------------------------------------------

local three = { 1719, 829, 834 } -- live geometry from workspace 2

check("N=3 focus0 right  -> others shrink equally", targets(three, 1, "right"), { 2292, 545, 545 })
check("N=3 focus1 right  -> middle grows", targets(three, 2, "right"), { 1128, 1127, 1127 })
check("N=3 focus2 right  -> LAST col shrinks", targets(three, 3, "right"), { 1405, 1404, 573 })
check("N=3 focus2 left   -> LAST col grows", targets(three, 3, "left"), { 1128, 1127, 1127 })
check("N=3 focus0 down   -> equalize", targets(three, 1, "down"), { 1127, 1128, 1127 })
check("N=3 focus0 up     -> maximize", targets(three, 1, "up"), { 2292, 545, 545 })

-- ---------------------------------------------------------------------------
-- N=4 / N=5
-- ---------------------------------------------------------------------------

local four = { 845, 845, 845, 845 }
check("N=4 focus0 right", targets(four, 1, "right"), { 1146, 745, 745, 744 })
check("N=4 focus3 right  -> LAST col shrinks", targets(four, 4, "right"), { 936, 936, 935, 573 })

local five = { 676, 676, 676, 676, 676 }
-- usable is 3380, so the 2234 left over splits 559/559/558/558.
check("N=5 focus2 right", targets(five, 3, "right"), { 559, 559, 1146, 558, 558 })

-- ---------------------------------------------------------------------------
-- No-ops and edges
-- ---------------------------------------------------------------------------

check("N=1 -> no-op", plan({ 3414 }, 1, "right"), nil)
check("bad direction -> no-op", plan(two, 1, "sideways"), nil)
check("focus out of range -> no-op", plan(two, 3, "right"), nil)

check("loop=true wraps past the top", targets({ 2865, 533 }, 1, "right", { loop = true }), { 573, 2825 })
check("loop=false clamps (no-op at the top)", plan({ 2865, 533 }, 1, "right", { loop = false }), nil)
check("loop=true wraps past the bottom", targets({ 573, 2825 }, 1, "left", { loop = true }), { 2865, 533 })

-- Too many columns for the floor to allow any stop at all.
local many = {}
for i = 1, 12 do
  many[i] = 283
end
check("N=12 -> ladder empty, no-op", plan(many, 1, "right"), nil)

-- ---------------------------------------------------------------------------
-- Invariants that must hold for every plan
-- ---------------------------------------------------------------------------

local layouts = { two, three, four, five, { 1000, 1200, 1198 }, { 2865, 266, 267 } }
local dirs = { "left", "right", "up", "down" }
local sum_ok, floor_ok, height_ok = true, true, true

for _, widths in ipairs(layouts) do
  local usable = 0
  for _, w in ipairs(widths) do
    usable = usable + w
  end
  for focused = 1, #widths do
    for _, dir in ipairs(dirs) do
      local p = plan(widths, focused, dir)
      if p then
        local total = 0
        for _, t in ipairs(p.targets) do
          total = total + t
          if t < 1 then
            floor_ok = false
          end
        end
        if total ~= usable then
          sum_ok = false
        end
        -- The plan describes widths only; nothing in it can move a height.
        for k in pairs(p) do
          if k == "heights" or k == "y" then
            height_ok = false
          end
        end
      end
    end
  end
end

check("every plan conserves total width", sum_ok, true)
check("no plan produces a non-positive column", floor_ok, true)
check("no plan carries any height component", height_ok, true)

-- Non-focused columns are always equal to within one pixel.
local equal_ok = true
for _, widths in ipairs(layouts) do
  for focused = 1, #widths do
    for _, dir in ipairs(dirs) do
      local p = plan(widths, focused, dir)
      if p and #widths > 2 then
        local lo, hi
        for i, t in ipairs(p.targets) do
          if i ~= focused then
            lo = (lo == nil or t < lo) and t or lo
            hi = (hi == nil or t > hi) and t or hi
          end
        end
        if hi - lo > 1 then
          equal_ok = false
        end
      end
    end
  end
end
check("non-focused columns equal within 1px", equal_ok, true)

-- ---------------------------------------------------------------------------
-- Column detection
-- ---------------------------------------------------------------------------

local function boxes(list)
  local out = {}
  for i, b in ipairs(list) do
    out[i] = { x = b[1], y = b[2], w = b[3], id = i }
  end
  return out
end

local flat = M.columns(boxes({ { 13, 39, 1719 }, { 1748, 39, 829 }, { 2593, 39, 834 } }))
check("3 side-by-side windows -> 3 columns", #flat, 3)
check("3 columns are decomposable", M.decomposable(flat), true)

-- A column holding a vertical stack is still one column.
local stacked = M.columns(boxes({ { 13, 39, 1719 }, { 13, 750, 1719 }, { 1748, 39, 1679 } }))
check("vertical stack collapses to 1 column", #stacked, 2)
check("stacked layout is decomposable", M.decomposable(stacked), true)
check("stacked column keeps both windows", #stacked[1].ids, 2)
check("stacked column represented by topmost", stacked[1].rep, 1)

-- [A][B] over a full-width C: C straddles the A|B boundary.
local ragged = M.columns(boxes({ { 13, 39, 1719 }, { 1748, 39, 1679 }, { 13, 760, 3414 } }))
check("ragged layout is NOT decomposable", M.decomposable(ragged), false)

-- A single full-screen window, and a pure vertical stack, are both one column.
check("lone window -> 1 column", #M.columns(boxes({ { 13, 39, 3414 } })), 1)
check("pure vertical stack -> 1 column", #M.columns(boxes({ { 13, 39, 3414 }, { 13, 750, 3414 } })), 1)

print(string.format("\n%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
