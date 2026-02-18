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

            -- Pane 2: terminal below
            window:perform_action(wezterm.action.SplitPane({
                direction = "Down",
                size = { Percent = 25 }
            }), fresh_pane)

            -- Pane 3: opencode to the right
            window:perform_action(wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 35 },
                top_level = true
            }), fresh_pane)

            local opencode_pane = window:active_pane()
            opencode_pane:send_text("opencode\n")
        end)
    })
end

return {
    setup = setup
}
