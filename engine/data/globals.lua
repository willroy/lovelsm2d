Globals = Object:extend()

function Globals:init(dataPath)
	self.engineGlobals = data:readFile(dataPath.."/engineGlobals.json")
	self.globals = data:readFile(dataPath.."/globals.json")
	self.keybinds = data:readFile(dataPath.."/keybinds.json")
	self.trackers = {
		lastMousePos = { x = 0, y = 0 },
		mousePos = { x = 0, y = 0 }
	}

	self.canvas_settings = {}

	self.canvas = love.graphics.newCanvas(self.engineGlobals.windowSize.w, self.engineGlobals.windowSize.h, self.canvas_settings)
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
	-- loop through globals and save to game_saveData/global.json
end

function Globals:load()
	-- read game_saveData/global.json / and save to globals
end