local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    hide_tab_bar_if_only_one_tab = true,
    window_close_confirmation = 'NeverPrompt',
    window_decorations = "RESIZE | TITLE | INTEGRATED_BUTTONS",
    default_cursor_style = "BlinkingBar",
    enable_scroll_bar = true,
    enable_wayland = true,

    -- Swap Alt key behavior: left produces composed chars, right acts as plain Alt
    send_composed_key_when_left_alt_is_pressed = true,
    send_composed_key_when_right_alt_is_pressed = false,

    font = wezterm.font('JetBrains Mono', {
        weight = 'Bold'
    }),
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

    keys = {{
        -- close current pane when opeed, else close tab --
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane({
            confirm = false
        })
    }, {
        -- direct "~" character input with option + N shortcut 
        key = "n",
        mods = "OPT",
        action = wezterm.action.SendString("~")
    }}
}

return config
