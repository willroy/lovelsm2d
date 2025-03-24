require("lovelsm2d/nodes/object")
require("lovelsm2d/nodes/node")
require("lovelsm2d/nodes/tag")

require("lovelsm2d/drawables/image")
require("lovelsm2d/drawables/animation")
require("lovelsm2d/drawables/spritesheet")
require("lovelsm2d/drawables/shape")
require("lovelsm2d/drawables/text")

require("lovelsm2d/ui/dialouge")
require("lovelsm2d/ui/button")
require("lovelsm2d/ui/fileList")
require("lovelsm2d/ui/menu")

require("lovelsm2d/util/debugInfo")
require("lovelsm2d/util/helper")
require("lovelsm2d/util/tags")

require("lovelsm2d/managers/events")
require("lovelsm2d/managers/input")
require("lovelsm2d/managers/nodes")
require("lovelsm2d/managers/globals")


Engine = Object:extend()

helper = nil
globals = nil
input = nil
events = nil
debugInfo = nil
nodes = nil

customUIs = {}

function Engine:init()
	helper = Helper()
	globals = Globals()
	input = Input()
	events = Events()
	debugInfo = DebugInfo()
	nodes = Nodes()

	-- run unit tests - `find . -name "*.lua" | entr lua lovelsm2d/util/test.lua -v`

	love.window.setTitle("template-love2d")
	love.window.setMode(globals.config.windowSize.w, globals.config.windowSize.h, {vsync=globals.config.windowVsync, resizable=globals.config.windowResizable})

	love.graphics.setBackgroundColor(globals.config.windowBackColour.r, globals.config.windowBackColour.g, globals.config.windowBackColour.b)
	love.graphics.setFont(helper:getFont(globals.config.windowFont))
	love.graphics.setDefaultFilter("linear", "linear")
	love.mouse.setCursor(helper:getCursor(globals.config.cursorArrow))

	nodes:init()
end

function Engine:loadNodes()
	nodes:loadNodes()
end

function Engine:update(dt)
	for n = 1, #nodes.loadedNodes do nodes.loadedNodes[n]:update(dt) end

	local mouseX, mouseY = love.mouse.getPosition()
	globals.trackers.lastMousePos.x, globals.trackers.lastMousePos.y = globals.trackers.mousePos.x, globals.trackers.mousePos.y
	globals.trackers.mousePos.x, globals.trackers.mousePos.y = mouseX, mouseY
	globals.trackers.windowSize.w = love.graphics.getWidth()
	globals.trackers.windowSize.h = love.graphics.getHeight()

	input:update(dt)
	if events.running then events:taskHandler() end
	
	debugInfo:update(dt)
end

function Engine:draw()
	love.graphics.setCanvas({globals.canvas, stencil=true})
	love.graphics.clear(0,0,0,0)
	love.graphics.setColor(1,1,1,1)
	love.graphics.push()

	for n = 1, #nodes.loadedNodes do nodes.loadedNodes[n]:draw() end
	
	debugInfo:draw()
end

function Engine:mousepressed(x, y, button, istouch)
	input:mousepressed(x, y, button, istouch)
	for n = 1, #nodes.loadedNodes do if nodes.loadedNodes[n]:mousepressed(x, y, button, istouch) == "abort" then break end end
end

function Engine:mousereleased(x, y, button, istouch)
	input:mousereleased(x, y, button, istouch)
	for n = 1, #nodes.loadedNodes do if nodes.loadedNodes[n]:mousereleased(x, y, button, istouch) == "abort" then break end end
end

function Engine:keypressed(key, code)
	input:keypressed(key, code)
end

function Engine:keyreleased(key)
	input:keyreleased(key)
end

function Engine:wheelmoved(x, y)
	for n = 1, #nodes.loadedNodes do nodes.loadedNodes[n]:wheelmoved(x, y) end
end

function Engine:resize(w, h)
  globals.canvas = love.graphics.newCanvas(w, h, globals.canvas_settings)
end

function Engine:quit()
end

function Engine:postDraw()
	love.graphics.pop()
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(globals.canvas)
end