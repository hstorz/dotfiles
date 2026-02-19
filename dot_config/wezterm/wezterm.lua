local wezterm = require 'wezterm'
local keybind = require 'keybind'

local config = wezterm.config_builder()

local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- Setup mode detection (editor/lazygit key table switching)
keybind.setup_mode_detection(is_mac)

config = {
    automatically_reload_config = true,
    hide_tab_bar_if_only_one_tab = true,
    window_close_confirmation = 'NeverPrompt',
    window_decorations = is_mac and "RESIZE | TITLE" or "RESIZE | TITLE | INTEGRATED_BUTTONS",
    default_cursor_style = "BlinkingBar",
    enable_scroll_bar = true,
    enable_wayland = true,
    
    -- Swap Alt key behavior: left produces composed chars, right acts as plain Alt
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,

    font = wezterm.font('JetBrains Mono', { weight = 'Bold' }),
    font_size = 14,
    line_height = 1.2,

    color_scheme = 'Darcula (base16)',
    color_schemes = {
        ['Darcula (base16)'] = {
            background = 'black',
            cursor_bg = 'white',
            cursor_fg = 'white',
            cursor_border = 'white'
        }
    },

    keys = keybind.get_keys(),
    key_tables = keybind.get_key_tables(is_mac),
}

-- Load tiled workspace configurations
local develop_workspace = require 'workspaces.develop'
develop_workspace.setup(config)
local git_workspace = require 'workspaces.git'
git_workspace.setup(config)

return config
