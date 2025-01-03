-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
local net_widget = require("net_widgets")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

------------------------------------------------------
-- Error handling

-- Fall back to default config in case of an error
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical, title = "Startup error", text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true
		naughty.notify({preset = naughty.config.presets.critical, title = "Error", text = tostring(err)})
		in_error = false
	end)
end

------------------------------------------------------
-- Variable definitions

-- Theme
beautiful.init("/home/tristan/.config/awesome/theme.lua")
-- Default programs
terminal = "xterm"
editor = "emacs"
browser = "firefox"
-- Modkeys
modkey = "Mod4"
alt = "Mod1"

------------------------------------------------------
-- Window layouts

awful.layout.layouts = {
	awful.layout.suit.fair,
	awful.layout.suit.tile,
	awful.layout.suit.max,
	awful.layout.suit.floating,
	awful.layout.suit.spiral.dwindle
}

------------------------------------------------------
-- Menu + widgets

-- Main Menu
awesomemenu = {
	{"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
	{"edit config", editor .. " " .. awesome.conffile},
	{"restart", awesome.restart}
}
powermenu = {
	{"poweroff", "poweroff"},
	{"reboot", "reboot"},
	{"quit", function() awesome.quit() end}
}
mainmenu = awful.menu({items = {
	{"awesome", awesomemenu, beautiful.awesome_icon},
	{"power", powermenu},
	{"terminal", terminal},
	{"text editor", editor},
	{"browser", browser}
}})
mylauncher = awful.widget.launcher({image = beautiful.awesome_icon, menu = mainmenu})

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Separator widget
separator = wibox.widget.separator({orientation = "vertical", border_width = 0, forced_width = 10})

-- Battery widget
mybattery_widget = battery_widget({
	show_current_level = true,
	display_notification = true,
	warning_msg_title = "Low Battery",
	warning_msg_text = "",
	warning_msg_icon = ""
})

-- Brightness widget
mybrightness_widget = brightness_widget({
	program = "xbacklight",
	type = "icon_and_text",
	tooltip = true,
	timeout = 5,
	base = 25,
	percentage = true,
	rmb_set_max = true
})

-- Volume widget
myvolume_widget = volume_widget({
	  widget_type = "icon_and_text",
	  card = 0
})

-- Music widget
myspotify_widget = spotify_widget({
	  sp_bin = "/home/tristan/.config/awesome/scripts/sp",
	  timeout = 5
})

-- Network widget
mynet_widget = net_widget.wireless({interface="wlan0"})

-- Clock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", {raise = true})
		end
	end),
	awful.button({ }, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({ }, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

-- Wallpaper
local function set_wallpaper(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
	-- Set Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table
	awful.tag({ "1", "2", "3", "4" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons
	}

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			s.mytaglist
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			spacing = 5,
			wibox.widget.systray(),
			mynet_widget,
			separator,
			myspotify_widget,
			myvolume_widget,
			separator,
			mybrightness_widget,
			mybattery_widget,
			separator,
			mytextclock,
			s.mylayoutbox
		},
	}
end)
-- }}}

------------------------------------------------------
-- Key bindings

-- Global mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 3, function () mainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))

-- Global key bindings
globalkeys = gears.table.join(

	-- Help popup
	awful.key({modkey}, "s", hotkeys_popup.show_help,								{description="show help", group="awesome"}),

	-- Tag switching
	awful.key({"Control", alt}, "Left", awful.tag.viewprev,						{description = "view previous", group = "tag"}),
	awful.key({"Control", alt}, "Right", awful.tag.viewnext,						{description = "view next", group = "tag"}),

	-- Window switching
	awful.key({alt}, "Tab", function() awful.client.focus.byidx( 1) end,			{description = "focus next by index", group = "client"}),
	awful.key({alt, "Shift"}, "Tab", function() awful.client.focus.byidx(-1) end,	{description = "focus previous by index", group = "client"}),

	-- Layout manipulation
	awful.key({modkey}, "Right", function() awful.client.swap.byidx(  1) end,		{description = "swap with next client by index", group = "client"}),
	awful.key({modkey}, "Left", function() awful.client.swap.byidx( -1) end,		{description = "swap with previous client by index", group = "client"}),

	awful.key({modkey}, "u", awful.client.urgent.jumpto,							{description = "jump to urgent client", group = "client"}),

	-- Standard program
	awful.key({"Control", alt}, "t", function() awful.spawn(terminal) end,			{description = "open a terminal", group = "launcher"}),
	awful.key({modkey, "Control"}, "r", awesome.restart,							{description = "reload awesome", group = "awesome"}),
	awful.key({modkey, "Shift"}, "q", awesome.quit,								{description = "quit awesome", group = "awesome"}),
	awful.key({modkey}, "space", function() awful.layout.inc( 1) end,				{description = "select next", group = "layout"}),
	awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end,		{description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "Next", function() local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

	-- Prompt
	awful.key({alt}, "space", function() awful.util.spawn("rofi -show combi") end,	{description = "run prompt", group = "launcher"}),

	-- Volume Keys
	awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("pa-volume-control voldown") end),
	awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("pa-volume-control volup") end),
	awful.key({}, "XF86AudioMute", function() awful.util.spawn("pa-volume-control mutetoggle") end),

	-- Media Keys
	awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause", false) end),
	awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end),
	awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end)
)

-- Per window key bindings
clientkeys = gears.table.join(
	awful.key({alt}, "Return", function(c) c.fullscreen = not c.fullscreen c:raise() end,		{description = "toggle fullscreen", group = "client"}),
	awful.key({alt}, "F4", function(c) c:kill() end,											{description = "close", group = "client"}),
	awful.key({modkey, "Control"}, "space", awful.client.floating.toggle,						{description = "toggle floating", group = "client"}),
	awful.key({modkey, "Control"}, "Return", function(c) c:swap(awful.client.getmaster()) end,	{description = "move to master", group = "client"}),
	awful.key({modkey}, "o", function(c) c:move_to_screen() end,								{description = "move to screen", group = "client"}),
	awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end,								{description = "toggle keep on top", group = "client"}),
	awful.key({modkey}, "Next", function(c) c.minimized = true end,								{description = "minimize", group = "client"}),
	awful.key({modkey}, "Prior", function(c) c.maximized = not c.maximized c:raise() end,		{description = "maximize(toggle)", group = "client"})
)

-- Per window mouse bindings
clientbuttons = gears.table.join(
	awful.button({}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
	awful.button({modkey}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.move(c) end),
	awful.button({modkey}, 3, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) awful.mouse.client.resize(c) end)
)

-- Set keys
root.keys(globalkeys)

------------------------------------------------------
-- Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA",  -- Firefox addon DownThemAll.
				"copyq",  -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer"
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester",  -- xev.
			},
			role = {
				"AlarmWindow",  -- Thunderbird's calendar.
				"ConfigManager",  -- Thunderbird's about:config.
				"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = {
			floating = true
		}
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = {
			 "normal",
			 "dialog"
			}
		},
		properties = {
			titlebars_enabled = true
		}
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	if awesome.startup
	and not c.size_hints.user_position
	and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({ }, 1, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			c:emit_signal("request::activate", "titlebar", {raise = true})
			awful.mouse.client.resize(c)
		end)
	)

	-- Titlebar layout
	awful.titlebar(c) : setup {
		{		-- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		}, {	-- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		}, {	-- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart applications
awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell("nm-applet")
