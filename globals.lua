Globals = Object:extend()

function Globals:init(dataPath)
	local globalsPath = dataPath.."/config.json"
	local keybindsPath = dataPath.."/keybinds.json"

	if helper:fileExists(globalsPath) == false then globalsPath = "lovelsm2d/defaultConfig.json" end
	if helper:fileExists(keybindsPath) == false then keybindsPath = "lovelsm2d/defaultKeybinds.json" end

	self.config = helper:readFile(globalsPath)
	self.keybinds = helper:readFile(keybindsPath)

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