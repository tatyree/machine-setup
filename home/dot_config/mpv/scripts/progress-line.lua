-- progress-line.lua
-- A hairline playback progress bar pinned to the bottom edge of the window.
-- Always on, deliberately unobtrusive: a few pixels tall, no text, no chrome.
--
-- Ctrl+Shift+p toggles it off/on for the session.

local opts = {
    height_frac = 0.004,  -- bar thickness as a fraction of window height
    min_height  = 2,      -- ...but never thinner than this many pixels
    fill_colour = "HFFFFFF",  -- ASS colour (BGR), played portion
    fill_alpha  = "H40",       -- 00 = opaque, FF = invisible
    track_alpha = "HC0",       -- unplayed portion, mostly transparent
}

local overlay = mp.create_osd_overlay("ass-events")
local enabled = true

local function hide()
    overlay.data = ""
    overlay:update()
end

-- Draw a filled rectangle as an ASS vector path.
local function rect(x0, y0, x1, y1, alpha)
    return string.format(
        "{\\an7\\pos(0,0)\\bord0\\shad0\\1c&%s&\\1a&%s&}{\\p1}m %d %d l %d %d l %d %d l %d %d{\\p0}",
        opts.fill_colour, alpha,
        x0, y0, x1, y0, x1, y1, x0, y1)
end

local function draw()
    if not enabled then return end

    local dim = mp.get_property_native("osd-dimensions")
    local pct = mp.get_property_number("percent-pos")
    if not dim or not pct or dim.w == 0 or dim.h == 0 then
        hide()
        return
    end

    local w, h = dim.w, dim.h
    local bar_h = math.max(opts.min_height, math.floor(h * opts.height_frac))
    local y0, y1 = h - bar_h, h
    local played = math.floor(w * pct / 100)

    -- Match the overlay's coordinate space to real pixels so nothing scales oddly.
    overlay.res_x, overlay.res_y = w, h
    overlay.data = rect(0, y0, w, y1, opts.track_alpha) .. "\n"
                .. rect(0, y0, played, y1, opts.fill_alpha)
    overlay:update()
end

mp.observe_property("percent-pos", "number", draw)
mp.observe_property("osd-dimensions", "native", draw)   -- redraw on resize/fullscreen

mp.add_key_binding("Ctrl+Shift+p", "toggle-progress-line", function()
    enabled = not enabled
    if enabled then draw() else hide() end
end)
