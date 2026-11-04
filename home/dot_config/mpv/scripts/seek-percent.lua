-- seek-percent.lua
-- Make the arrow keys seek by a fraction of the clip's length instead of a
-- fixed time. Short clips get small steps, long clips get big steps, so the
-- same number of presses traverses any clip.
--
-- Left/Right: fine seek (small fraction).
-- Up/Down:    coarse seek (larger fraction), the "long jump".

local PCT = 0.025   -- fine step as a fraction of duration (2.5% -> ~40 presses)
local MIN = 1       -- never seek less than this many seconds
local MAX = 5       -- never seek more than this many seconds

local PCT_BIG = 0.10  -- coarse step as a fraction of duration (10% -> ~10 presses)
local MIN_BIG = 10    -- never jump less than this many seconds
local MAX_BIG = 60    -- never jump more than this many seconds

-- Compute the seek step (seconds) for the current clip.
local function step_for(pct, min, max, fallback)
    local dur = mp.get_property_number("duration")
    if not dur or dur <= 0 then
        return fallback   -- fallback for streams with no known duration
    end
    return math.max(min, math.min(max, dur * pct))
end

local function seek_by(sign, pct, min, max, fallback)
    mp.commandv("seek", sign * step_for(pct, min, max, fallback), "relative")
end

-- Left/Right stop at the ends of the clip rather than running into the previous
-- or next one. A relative seek past the end would hit EOF and advance the
-- playlist, so forward seeks stop END_GUARD seconds short of it.
local END_GUARD = 0.5

mp.add_forced_key_binding("RIGHT", "seek-percent-fwd", function()
    local pos  = mp.get_property_number("time-pos", 0)
    local dur  = mp.get_property_number("duration")
    local step = step_for(PCT, MIN, MAX, 5)
    if not dur or dur <= 0 or pos + step < dur - END_GUARD then
        mp.commandv("seek", step, "relative")                    -- normal in-clip seek
    elseif pos < dur - END_GUARD then
        mp.commandv("seek", dur - END_GUARD, "absolute")         -- stop short of the end
    end
end, { repeatable = true })
mp.add_forced_key_binding("LEFT", "seek-percent-back", function()
    local pos  = mp.get_property_number("time-pos", 0)
    local step = step_for(PCT, MIN, MAX, 5)
    if pos - step >= 0 then
        mp.commandv("seek", -step, "relative")                   -- normal in-clip back seek
    else
        mp.commandv("seek", 0, "absolute")                       -- stop at the start
    end
end, { repeatable = true })

mp.add_forced_key_binding("UP",   "seek-percent-fwd-big",  function() seek_by(1,  PCT_BIG, MIN_BIG, MAX_BIG, 60) end, { repeatable = true })
mp.add_forced_key_binding("DOWN", "seek-percent-back-big", function() seek_by(-1, PCT_BIG, MIN_BIG, MAX_BIG, 60) end, { repeatable = true })
