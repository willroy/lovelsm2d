require("lovelsm2d/nodes/object")
require("lovelsm2d/nodes/node")
require("lovelsm2d/nodes/dialougeNode")
require("lovelsm2d/nodes/image")
require("lovelsm2d/nodes/animation")

require("lovelsm2d/nodeManager")

require("lovelsm2d/data/data")
require("lovelsm2d/data/globals")

require("lovelsm2d/input/events")
require("lovelsm2d/input/input")

require("lovelsm2d/test/debugInfo")
require("lovelsm2d/test/test")

require("lovelsm2d/util/helper")

Engine = Object:extend()

data = nil
helper = nil
input = nil
globals = nil
events = nil
debugInfo = nil
nodeManager = nil

function Engine:init(dataPath)
	data = Data()
	helper = Helper()
	globals = Globals(dataPath)
	input = Input()
	events = Events()
	debugInfo = DebugInfo()
	nodeManager = NodeManager()

	love.window.setTitle("template-love2d")
	love.window.setMode(globals.config.windowSize.w, globals.config.windowSize.h, {vsync=1})

	love.graphics.setBackgroundColor(globals.config.windowBackColour.r, globals.config.windowBackColour.g, globals.config.windowBackColour.b)
	love.graphics.setFont(helper:getFont(globals.config.fontMain))
	love.graphics.setDefaultFilter("linear", "linear", 1)
	love.mouse.setCursor(helper:getCursor(globals.config.cursorArrow))

	nodeManager:init()

	nodeManager:loadNodes()
end

function Engine:update(dt)
	for n = 1, #nodeManager.loadedNodes do nodeManager.loadedNodes[n]:update(dt) end

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

	for n = 1, #nodeManager.loadedNodes do nodeManager.loadedNodes[n]:draw() end
	
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