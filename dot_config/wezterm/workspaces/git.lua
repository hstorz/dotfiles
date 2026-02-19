local wezterm = require 'wezterm'

local function setup(config)
    -- Open workspace with shortcut
    table.insert(config.keys, {
        key = "g",
        mods = "CMD|SHIFT",
        action = wezterm.action_callback(function(window, pane)
            -- Pane 1: fresh editor
            pane:send_text("lazygit\n")
            local code_pane = pane
            
            -- Pane 2: lazygit to the right
            window:perform_action(wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 40 },
                top_level = true
            }), code_pane)

            local opencode_pane = window:active_pane()
            opencode_pane:send_text("opencode\n")
        end)
    })
end

return {
    setup = setup
}
