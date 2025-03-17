Globals = Object:extend()

function Globals:init(canvas)
	local pathGlobals = helper:readKeyInFile("lovelsm2d/defaultConfig.json", "pathConfig")
	if helper:fileExists(pathGlobals) == false then pathGlobals = "lovelsm2d/defaultConfig.json" end
	self.config = helper:readFile(pathGlobals)

	local pathKeybinds = self.config.pathKeybinds
	if helper:fileExists(pathKeybinds) == false then pathKeybinds = "lovelsm2d/defaultKeybinds.json" end
	self.keybinds = helper:readFile(pathKeybinds)

	local pathData = self.config.pathData
	if helper:fileExists(pathData) == false then pathData = "lovelsm2d/defaultData.json" end
	self.data = helper:readFile(pathData)

	self.trackers = {
		lastMousePos = { x = 0, y = 0 },
		mousePos = { x = 0, y = 0 },
		currentWindowSize = self.config.windowSize
	}

	self.canvas_settings = {}

	self.canvas = canvas or love.graphics.newCanvas(self.config.windowSize.w, self.config.windowSize.h, self.canvas_settings)
end

function Globals:getFromString(str)
	local strSplit = helper:mysplit(str, ".")
	local value = nil

	if strSplit[2] == "trackers" then value = globals.trackers[strSplit[3]] end
	if strSplit[2] == "config" then value = globals.config[strSplit[3]] end
	if strSplit[2] == "data" then value = globals.data[strSplit[3]] end

	if type(value) == "table" then value = value[strSplit[4]] end

	return value
end

function Globals:checkKeyBinds(key, key_pressed)
	if self.keybinds[key] == nil then
		return false
	else
		for k = 1, #self.keybinds[key] do
			if self.keybinds[key][k] == key_pressed then return true end
		end
	end
	return false
end

function Globals:save()
	-- loop through globals and save to game_saveData/config.json
end

function Globals:load()
	-- read game_saveData/config.json / and save to globals
end