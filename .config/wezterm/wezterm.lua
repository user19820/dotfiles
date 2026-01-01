local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- window
config.initial_cols = 220
config.initial_rows = 60
-- config.color_scheme = 'Apple System Colors'
config.enable_tab_bar = false
config.window_frame = {
	active_titlebar_bg = 'none',
	inactive_titlebar_bg = 'none',
}
config.window_background_opacity = 0.7 -- A value between 0.0 (fully transparent) and 1.0 (fully opaque)
config.window_decorations = 'RESIZE'

-- font
config.font_size = 24
config.font = wezterm.font('GohuFont 14 Nerd Font')
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.default_cursor_style = 'SteadyBlock'

-- color
config.colors = {
	-- background = 'transparent',
}

return config
