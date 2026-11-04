-- osd-fullpath.lua
mp.add_key_binding("Ctrl+p", "show-fullpath", function()
    local fullpath = mp.get_property("path")
    if fullpath then
        mp.osd_message("File: " .. fullpath, 5)  -- display for 5 seconds
    else
        mp.osd_message("No file loaded", 5)
    end
end)
