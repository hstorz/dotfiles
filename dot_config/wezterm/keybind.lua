local wezterm = require 'wezterm'

local M = {}

-- Key table names
local EDITOR_KEY_TABLE = "editor_mode"
local LAZYGIT_KEY_TABLE = "lazygit_mode"

-- Detect if running in editor
local function is_editor(pane)
    local info = pane:get_foreground_process_info()
    if not info or not info.executable then return false end
    local exe = info.executable:lower()
    return exe:match('micro') or exe:match('fresh') or exe:match('yazi')
end

-- Detect if running in lazygit
local function is_lazygit(pane)
    local info = pane:get_foreground_process_info()
    if not info or not info.executable then return false end
    local exe = info.executable:lower()
    return exe:match('lazygit')
end

-- Global keys
function M.get_keys()
    return {
        {
            key = "w",
            mods = "CMD",
            action = wezterm.action.CloseCurrentPane({ confirm = false })
        },
        {
            key = "n",
            mods = "OPT",
            action = wezterm.action.SendString("~")
        },
        {
            key = "UpArrow",
            mods = "CTRL|SHIFT|ALT",
            action = wezterm.action.SplitPane({ direction = "Up" })
        },
        {
            key = "LeftArrow",
            mods = "CTRL|SHIFT|ALT",
            action = wezterm.action.SplitPane({ direction = "Left" })
        },
        {
            key = "DownArrow",
            mods = "CTRL|SHIFT|ALT",
            action = wezterm.action.SplitPane({ direction = "Down" })
        },
        {
            key = "RightArrow",
            mods = "CTRL|SHIFT|ALT",
            action = wezterm.action.SplitPane({ direction = "Right" })
        },
        {
            key = "UpArrow",
            mods = "CMD|SHIFT|ALT",
            action = wezterm.action.AdjustPaneSize { "Up", 1 }
        },
        {
            key = "DownArrow",
            mods = "CMD|SHIFT|ALT",
            action = wezterm.action.AdjustPaneSize { "Down", 1 }
        },
        {
            key = "LeftArrow",
            mods = "CMD|SHIFT|ALT",
            action = wezterm.action.AdjustPaneSize { "Left", 1 }
        },
        {
            key = "RightArrow",
            mods = "CMD|SHIFT|ALT",
            action = wezterm.action.AdjustPaneSize { "Right", 1 }
        }
    }
end

-- Key tables for different modes
function M.get_key_tables(is_mac)
    if not is_mac then
        return {}
    end
    
    return {
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
        },
        [LAZYGIT_KEY_TABLE] = {
            { key = "c", mods = "CMD", action = wezterm.action.SendKey({ key = "o", mods = "CTRL" }) },
        }
    }
end

-- Setup mode detection and key table switching
function M.setup_mode_detection(is_mac)
    if not is_mac then
        return
    end
    
    -- State tracking per window
    local active_mode = {}
    
    -- Monitor pane changes and toggle key table
    wezterm.on('update-status', function(window, pane)
        local window_id = window:window_id()
        
        -- Determine current mode (only one can be active, editor takes precedence)
        local current_mode = nil
        if is_editor(pane) then
            current_mode = EDITOR_KEY_TABLE
        elseif is_lazygit(pane) then
            current_mode = LAZYGIT_KEY_TABLE
        end
        
        local previous_mode = active_mode[window_id]
        
        -- Only act if mode has changed
        if current_mode ~= previous_mode then
            if current_mode then
                -- Entering a special mode: activate its key table
                window:perform_action(wezterm.action.ActivateKeyTable {
                    name = current_mode,
                    replace_current = true,
                    one_shot = false,
                }, pane)
            else
                -- Leaving all special modes: clear key tables
                window:perform_action(wezterm.action.ClearKeyTableStack, pane)
            end
            active_mode[window_id] = current_mode
        end
    end)
end

return M
