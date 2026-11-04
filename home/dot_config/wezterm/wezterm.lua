local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 24.0
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.tab_bar_at_bottom = true
config.window_frame = {
  font_size = 24.0,
}

wezterm.on("format-tab-title", function(tab)
  local index = tab.tab_index
  local title = tab.active_pane.title
  return " " .. index .. ": " .. title .. " "
end)

config.unix_domains = {
  { name = "unix" },
  { name = "work" },
}

config.default_gui_startup_args = { "connect", "unix" }

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('ClipboardAndPrimarySelection'),
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

config.leader = { key = "Space", mods = "CTRL" }

config.tab_and_split_indices_are_zero_based = true
require("plugins.wez-tmux.plugin").apply_to_config(config, {})

-- Optional machine-specific additions: ~/.config/wezterm/extra.lua returning
-- function(config) ... end
local ok, extra = pcall(require, "extra")
if ok and type(extra) == "function" then
  extra(config)
end

return config
