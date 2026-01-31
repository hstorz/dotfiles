local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    hide_tab_bar_if_only_one_tab = true,
    window_close_confirmation = 'NeverPrompt',
    window_decorations = "RESIZE",
    default_cursor_style = "BlinkingBar",
    enable_scroll_bar = true,

    font = wezterm.font('JetBrains Mono', {
        weight = 'Bold'
    }),
    font_size = 15,
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

    keys = {{
        -- close current pane when opeed, else close tab --
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane({
            confirm = false
        })
    }, {
        -- fix @ symbol on Mac keyboard layout -- 
        key = 'l',
        mods = 'ALT',
        action = wezterm.action.SendString '@'
    }}
}

return config
