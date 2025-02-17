-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Quick reference to the wezterm action
local act = wezterm.action

-- Show the active workspace name right side of the status bar.
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

-- ### PlugIns #####
-- Resurrect: Save and restore wezterm sessions
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- config.enable_tab_bar = false

-- config.window_decorations = "RESIZE"

-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10


config.color_scheme = 'Smyck'

config.tab_bar_at_bottom = true

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#1b1b1b'
    local background = '#333333'
    local foreground = '#d0d0d0'

    if tab.is_active then
      background = '#555555'
      foreground = '#f0f0f0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

-- -- Set up a unix socket for "session" handling. Connect to it with LEADER+a,
-- -- disconnect with LEADER+d - see below
-- config.unix_domains = {
--   {
--     name = 'unix',
--   },
-- }

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- -- Split horizontal (left/right) when pressing LEADER then '|'
  -- {
  --   key = '|',
  --   mods = 'LEADER|SHIFT',
  --   action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  -- },
  -- -- Split vertical (top/bottom) when pressing LEADER then '_'
  -- {
  --   key = '_',
  --   mods = 'LEADER|SHIFT',
  --   action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  -- },
  -- -- Toggle pane zoom when pressing LEADER then 'z'
  -- {
  --   key = 'z',
  --   mods = 'LEADER',
  --   action = act.TogglePaneZoomState,
  -- },
  -- -- Switch to the left pane with LEADER LeftArrow
  -- {
  --   key = 'LeftArrow',
  --   mods = 'LEADER',
  --   action = act.ActivatePaneDirection "Left",
  -- },
  -- -- Switch to the right pane with LEADER RightArrow
  -- {
  --   key = 'RightArrow',
  --   mods = 'LEADER',
  --   action = act.ActivatePaneDirection "Right",
  -- },
  -- -- Switch to the top pane with LEADER UpArrow
  -- {
  --   key = 'UpArrow',
  --   mods = 'LEADER',
  --   action = act.ActivatePaneDirection "Up",
  -- },
  -- -- Switch to the bottom pane with LEADER DownArrow
  -- {
  --   key = 'DownArrow',
  --   mods = 'LEADER',
  --   action = act.ActivatePaneDirection "Down",
  -- },
  -- -- Show all workspaces and allow creating a new one or selecting one to
  -- -- switch to using fuzzy matching
  -- {
  --   key = 'w',
  --   mods = 'LEADER',
  --   action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES', },
  -- },
  -- Show a tab navigator
  {
    key = 't',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  -- -- Start copy mode like tmux with LEADER '['
  -- {
  --   key = '[',
  --   mods = 'LEADER',
  --   action = act.ActivateCopyMode,
  -- },
  -- Rename current tab with LEADER+, - like tmux
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end
      ),
    },
  },
  -- -- Rename current workspace (like tmux session) with LEADER+$
  -- {
  --   key = '$',
  --   mods = 'LEADER|SHIFT',
  --   action = act.PromptInputLine {
  --     description = 'Enter new name for workspace',
  --     action = wezterm.action_callback(
  --       function(window, pane, line)
  --         if line then
  --           wezterm.mux.rename_workspace(
  --             window:mux_window():get_workspace(),
  --             line
  --           )
  --         end
  --       end
  --     ),
  --   },
  -- },
  -- -- Attach to muxer
  -- {
  --   key = 'a',
  --   mods = 'LEADER',
  --   action = act.AttachDomain 'unix',
  -- },
  -- -- Detach from muxer
  -- {
  --   key = 'd',
  --   mods = 'LEADER',
  --   action = act.DetachDomain { DomainName = 'unix' },
  -- },
  -- -- Visualy swap panes using LEADER+{
  -- {
  --   key = '{',
  --   mods = 'LEADER|SHIFT',
  --   action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
  -- },
  -- -- Send "CTRL-W" to the terminal when pressing CTRL-W, CTRL-W
  -- {
  --   key = 'w',
  --   mods = 'LEADER|CTRL',
  --   action = act.SendKey { key = 'w', mods = 'CTRL' },
  -- },
  -- ############ Non LEADER keys ###############
  -- Show Launcher
  {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ShowLauncher,
  },
  -- -- Show current key assignments when pressing CTRL-SHIFT-?
  -- -- Not too useful 
  -- {
  --   key = '?',
  --   mods = 'CTRL|SHIFT',
  --   action = act.ShowLauncherArgs { flags = 'FUZZY|KEY_ASSIGNMENTS', },
  -- },
  -- -- Show some default commnans when pressing CTRL-SHIFT-?
  -- -- Not too useful 
  -- {
  --   key = '?',
  --   mods = 'CTRL|SHIFT',
  --   action = act.ShowLauncherArgs { flags = 'FUZZY|COMMANDS', },
  -- },
  --
  -- ###### Plugin Config #########
  -- -- Resurrect:  NOTE: CONFIGURATION AND SETUP TO BE COMPLETED!
  -- -- Save state
  -- {
  --   key = "s",
  --   mods = "LEADER|CTRL",
  --   action = wezterm.action_callback(function(win, pane)
  --       resurrect.save_state(resurrect.workspace_state.get_workspace_state())
  --     end),
  -- },
  -- {
  --   key = "r",
  --   mods = "LEADER|CTRL",
  --   action = wezterm.action_callback(function(win, pane)
  --     resurrect.fuzzy_load(win, pane, function(id, label)
  --       local type = string.match(id, "^([^/]+)") -- match before '/'
  --       id = string.match(id, "([^/]+)$") -- match after '/'
  --       id = string.match(id, "(.+)%..+$") -- remove file extention
  --       local opts = {
  --         relative = true,
  --         restore_text = true,
  --         on_pane_restore = resurrect.tab_state.default_on_pane_restore,
  --       }
  --       if type == "workspace" then
  --         local state = resurrect.load_state(id, "workspace")
  --         resurrect.workspace_state.restore_workspace(state, opts)
  --       elseif type == "window" then
  --         local state = resurrect.load_state(id, "window")
  --         resurrect.window_state.restore_window(pane:window(), state, opts)
  --       elseif type == "tab" then
  --         local state = resurrect.load_state(id, "tab")
  --         resurrect.tab_state.restore_tab(pane:tab(), state, opts)
  --       end
  --     end)
  --   end),
  -- },
}


-- and finally, return the configuration to wezterm
return config
