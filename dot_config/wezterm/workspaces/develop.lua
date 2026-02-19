local wezterm = require 'wezterm'

local function setup(config)
    -- Open workspace with shortcut
    table.insert(config.keys, {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action_callback(function(window, pane)
            -- Pane 1: fresh editor
            pane:send_text("fresh\n")
            local fresh_pane = pane

            -- Pane 2: opencode below
            window:perform_action(wezterm.action.SplitPane({
                direction = "Down",
                size = { Percent = 50 }
            }), fresh_pane)

            local opencode_pane = window:active_pane()
            opencode_pane:send_text("opencode\n")

            -- Pane 3: lazygit to the right
            window:perform_action(wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 30 },
                top_level = true
            }), fresh_pane)

            local opencode_pane = window:active_pane()
            opencode_pane:send_text("lazygit\n")
        end)
    })
end

return {
    setup = setup
}
