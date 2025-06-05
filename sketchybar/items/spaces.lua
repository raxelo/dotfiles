local constants = require("constants")
local settings = require("config.settings")

local spaces = {}

local swapWatcher = sbar.add("item", {
	drawing = false,
	updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Modify this file with Visual Studio Code - at least vim does have problems with the icons
-- copy "Icons" from the nerd fonts cheat sheet and replace icon and name accordingly below
-- https://www.nerdfonts.com/cheat-sheet
local spaceConfigs <const> = {
	["1"] = { icon = "󰖟", name = "Browser", color = 0xfff59e0b },
	["2"] = { icon = "", name = "Terminal", color = 0xff1e40af },
	["3"] = { icon = "󱞁", name = "Notes", color = 0xffa855f7 },
	["4"] = { icon = "", name = "Database", color = 0xff16a34a },
	["5"] = { font = settings.fonts.icons(), icon = ":openai:", name = "LLM", color = 0xffbe185d },
	["C"] = { font = settings.fonts.icons(), icon = ":mail:", color = 0xffbe185d },
}

local function selectCurrentWorkspace(focusedWorkspaceName)
	for sid, item in pairs(spaces) do
		if item ~= nil then
			local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
			local spaceConfig = spaceConfigs[focusedWorkspaceName]
			item:set({
				icon = { color = settings.colors.white },
				label = { color = settings.colors.white },
				background = { color = isSelected and spaceConfig.color or settings.colors.bg1 },
			})
		end
	end

	sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentWorkspace()
	sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedWorkspaceOutput)
		local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
		selectCurrentWorkspace(focusedWorkspaceName)
	end)
end

local function addWorkspaceItem(workspaceName)
	local spaceName = constants.items.SPACES .. "." .. workspaceName
	local spaceConfig = spaceConfigs[workspaceName]

	spaces[spaceName] = sbar.add("item", spaceName, {
		label = {
			width = 0,
			padding_left = 0,
			string = spaceConfig.name,
		},
		icon = {
			string = spaceConfig.icon or settings.icons.apps["default"],
			color = settings.colors.white,
			font = spaceConfig.font,
		},
		click_script = "aerospace workspace " .. workspaceName,
	})

	sbar.add("item", spaceName .. ".padding", {
		width = settings.dimens.padding.label,
	})
end

local function createWorkspaces()
	addWorkspaceItem("1")
	addWorkspaceItem("2")
	addWorkspaceItem("3")
	addWorkspaceItem("4")
	addWorkspaceItem("5")
	addWorkspaceItem("C")
	findAndSelectCurrentWorkspace()
end

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
	local isShowingSpaces = env.isShowingMenu == "off" and true or false
	sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
	selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
	sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

createWorkspaces()
