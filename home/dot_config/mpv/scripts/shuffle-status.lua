-- shuffle-status.lua
local shuffled = false

mp.register_event("file-loaded", function()
    -- detect if playlist was shuffled by checking playlist order
end)

mp.add_key_binding("Ctrl+s", "show-shuffle-status", function()
    if shuffled then
        mp.osd_message("Shuffle: ON", 3)
    else
        mp.osd_message("Shuffle: OFF", 3)
    end
end)

-- Hook into shuffle/unshuffle to track state
mp.add_key_binding("z", "shuffle-track-on", function()
    mp.command("playlist-shuffle")
    shuffled = true
    mp.osd_message("Shuffle on", 3)
end)

mp.add_key_binding("Z", "shuffle-track-off", function()
    mp.command("playlist-unshuffle")
    shuffled = false
    mp.osd_message("Shuffle off", 3)
end)
