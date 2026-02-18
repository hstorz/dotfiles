local wezterm = require 'wezterm'

local function setup(config)
	
    -- Open workspace with shortcut
    table.insert(config.keys, {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action_callback(function(window, pane)
			
            -- Pane 1: fresh editor
            pane:send_text("fresh\n")
            
            -- Pane 2: opencode to the right
            window:perform_action(wezterm.action.SplitPane({
                direction = "Right",
                size = { Percent = 50 }
            }), pane)
            
            local opencode_pane = window:active_pane()
            opencode_pane:send_text("opencode\n")
            
            -- Pane 3: terminal below opencode
            window:perform_action(wezterm.action.SplitPane({
                direction = "Down",
                size = { Percent = 50 }
            }), opencode_pane)
        end)
    })
end

return {
    setup = setup
}
