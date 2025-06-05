local constants = require("constants")

local calendar = sbar.add("item", constants.items.CALENDAR, {
	position = "right",
	update_freq = 1,
	icon = { padding_left = 0, padding_right = 0 },
	background = {
		color = 0xd322212c,
	},
})

calendar:subscribe({ "forced", "routine", "system_woke" }, function(env)
	calendar:set({
		label = os.date("%a %d %b, %H:%M"),
	})
end)

calendar:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Calendar'")
end)
