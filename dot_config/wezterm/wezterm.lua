local wezterm = require 'wezterm'

local config = wezterm.config_builder()

local is_mac = wezterm.target_triple:find('darwin') ~= nil

local function is_editor(pane)
    local info = pane:get_foreground_process_info()
    if not info or not info.executable then return false end
    local exe = info.executable:lower()
    return exe:match('micro') or exe:match('fresh') or exe:match('yazi')
end

-- Editor key table: CMD keys send CTRL
local EDITOR_KEY_TABLE = "editor_mode"

local keys = {{
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = false })
}, {
    key = "n",
    mods = "OPT",
    action = wezterm.action.SendString("~")
}, {
    key = "UpArrow",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Up" })
}, {
    key = "LeftArrow",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Left" })
}, {
    key = "DownArrow",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Down" })
}, {
    key = "RightArrow",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({ direction = "Right" })
}, {
    key = "UpArrow",
    mods = "CMD|SHIFT|ALT",
    action = wezterm.action.AdjustPaneSize { "Up", 1 }
}, {
    key = "DownArrow",
    mods = "CMD|SHIFT|ALT",
    action = wezterm.action.AdjustPaneSize { "Down", 1 }
}, {
    key = "LeftArrow",
    mods = "CMD|SHIFT|ALT",
    action = wezterm.action.AdjustPaneSize { "Left", 1 }
}, {
    key = "RightArrow",
    mods = "CMD|SHIFT|ALT",
    action = wezterm.action.AdjustPaneSize { "Right", 1 }
}}

-- State tracking per window
local editor_active = {}

if is_mac then
    -- Monitor pane changes and toggle key table
    wezterm.on('update-status', function(window, pane)
        local window_id = window:window_id()
        local in_editor = is_editor(pane)
        local was_in_editor = editor_active[window_id] or false
        
        if in_editor ~= was_in_editor then
            if in_editor then
                -- Entering editor: activate CMD->CTRL mappings
                window:perform_action(wezterm.action.ActivateKeyTable {
                    name = EDITOR_KEY_TABLE,
                    replace_current = true,
                    one_shot = false,
                }, pane)
            else
                -- Leaving editor: clear all key tables (back to default)
                window:perform_action(wezterm.action.ClearKeyTableStack, pane)
            end
            editor_active[window_id] = in_editor
        end
    end)
end

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

    keys = keys,
    
    -- Key table only active when in editor
    key_tables = is_mac and {
        [EDITOR_KEY_TABLE] = {
            { key = "a", mods = "CMD", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
            { key = "c", mods = "CMD", action = wezterm.action.SendKey({ key = "c", mods = "CTRL" }) },
            { key = "e", mods = "CMD", action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }) },
            { key = "f", mods = "CMD", action = wezterm.action.SendKey({ key = "f", mods = "CTRL" }) },
            { key = "q", mods = "CMD", action = wezterm.action.SendKey({ key = "q", mods = "CTRL" }) },
            { key = "p", mods = "CMD", action = wezterm.action.SendKey({ key = "p", mods = "CTRL" }) },
            { key = "s", mods = "CMD", action = wezterm.action.SendKey({ key = "s", mods = "CTRL" }) },
            { key = "v", mods = "CMD", action = wezterm.action.SendKey({ key = "v", mods = "CTRL" }) },
            { key = "x", mods = "CMD", action = wezterm.action.SendKey({ key = "x", mods = "CTRL" }) },
            { key = "z", mods = "CMD", action = wezterm.action.SendKey({ key = "z", mods = "CTRL" }) },
            { key = "z", mods = "CMD|SHIFT", action = wezterm.action.SendKey({ key = "y", mods = "CTRL" }) },
        }
    } or {}
}

-- Load tiled workspace configurations
local develop_workspace = require 'workspaces.develop'
develop_workspace.setup(config)

return config
