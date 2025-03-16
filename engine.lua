require("lovelsm2d/nodes/object")
require("lovelsm2d/nodes/node")

require("lovelsm2d/drawables/image")
require("lovelsm2d/drawables/animation")
require("lovelsm2d/drawables/spritesheet")
require("lovelsm2d/drawables/shape")

require("lovelsm2d/ui/dialouge")

require("lovelsm2d/input/events")
require("lovelsm2d/input/input")

require("lovelsm2d/util/debugInfo")
require("lovelsm2d/util/test")
require("lovelsm2d/util/helper")

require("lovelsm2d/nodes")
require("lovelsm2d/globals")


Engine = Object:extend()

data = nil
helper = nil
input = nil
globals = nil
events = nil
debugInfo = nil
nodes = nil

function Engine:init()
	helper = Helper()
	globals = Globals()
	input = Input()
	events = Events()
	debugInfo = DebugInfo()
	nodes = Nodes()

	love.window.setTitle("template-love2d")
	love.window.setMode(globals.config.windowSize.w, globals.config.windowSize.h, {vsync=globals.config.windowVsync, resizable=globals.config.windowResizable})

	love.graphics.setBackgroundColor(globals.config.windowBackColour.r, globals.config.windowBackColour.g, globals.config.windowBackColour.b)
	love.graphics.setFont(helper:getFont(globals.config.windowFont))
	love.graphics.setDefaultFilter("linear", "linear", 1)
	love.mouse.setCursor(helper:getCursor(globals.config.cursorArrow))

	nodes:init()

	nodes:loadNodes()
end

function Engine:update(dt)
	for n = 1, #nodes.loadedNodes do nodes.loadedNodes[n]:update(dt) end

	local mouseX, mouseY = love.mouse.getPosition()
	globals.trackers.lastMousePos.x, globals.trackers.lastMousePos.y = globals.trackers.mousePos.x, globals.trackers.mousePos.y
	globals.trackers.mousePos.x, globals.trackers.mousePos.y = mouseX, mouseY
	input:update(dt)
	if events.running then events:taskHandler() end
	
	debugInfo:update(dt)
end

function Engine:draw()
	love.graphics.setCanvas(globals.canvas)
	love.graphics.clear(0,0,0,0)
	love.graphics.setColor(1,1,1,1)
	love.graphics.push()

	for n = 1, #nodes.loadedNodes do nodes.loadedNodes[n]:draw() end
	
	debugInfo:draw()
end

function Engine:mousepressed(x, y, button, istouch)
	input:mousepressed(x, y, button, istouch)
end

function Engine:mousereleased(x, y, button, istouch)
	input:mousereleased(x, y, button, istouch)
end

function Engine:keypressed(key, code)
	input:keypressed(key, code)
end

function Engine:keyreleased(key)
	input:keyreleased(key)
end

function Engine:wheelmoved(x, y)
end

function Engine:quit()
end

function Engine:postDraw()
	love.graphics.pop()
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(globals.canvas)
end