Globals = Object:extend()

function Globals:init()
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
		mousePos = { x = 0, y = 0 }
	}

	self.canvas_settings = {}

	self.canvas = love.graphics.newCanvas(self.config.windowSize.w, self.config.windowSize.h, self.canvas_settings)
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