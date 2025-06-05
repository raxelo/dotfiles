local constants = require("constants")
local settings = require("config.settings")

local frontApps = {}

sbar.add("bracket", constants.items.FRONT_APPS, {}, { position = "left" })

local frontAppWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local function updateWindows(windows)
  sbar.remove("/" .. constants.items.FRONT_APPS .. "\\.*/")

  local foundWindows = string.gmatch(windows, "[^\n]+")
  for window in foundWindows do
    local parsedWindow = {}
    for key, value in string.gmatch(window, "(%w+)=([%w%s]+)") do
      parsedWindow[key] = value
    end

    local windowId = parsedWindow["id"]
    local windowName = parsedWindow["name"]
    local icon = settings.icons.apps[windowName] or settings.icons.apps["default"]

    sbar.add("item", constants.items.FRONT_APPS .. "." .. windowName, {
      label = {
        padding_left = 0,
        string = windowName,
      },
      icon = {
        string = icon,
        font = settings.fonts.icons(),
      },
      click_script = "aerospace focus --window-id " .. windowId,
    })

  end

end

local function getWindows()
  sbar.exec(constants.aerospace.LIST_WINDOWS, updateWindows)
end

frontAppWatcher:subscribe(constants.events.UPDATE_WINDOWS, function()
  getWindows()
end)

getWindows()
