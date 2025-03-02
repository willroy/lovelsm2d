require("lovelsm2d/engine/nodes/object")
require("lovelsm2d/engine/nodes/node")
require("lovelsm2d/engine/nodes/image")
require("lovelsm2d/engine/nodes/animation")

require("lovelsm2d/engine/data/data")
require("lovelsm2d/engine/data/globals")

require("lovelsm2d/engine/input/events")
require("lovelsm2d/engine/input/input")

require("lovelsm2d/engine/test/debugInfo")
require("lovelsm2d/engine/test/test")

require("lovelsm2d/engine/util/helper")

Engine = Object:extend()

data = nil
helper = nil
input = nil
globals = nil
events = nil
debugInfo = nil

function Engine:init(dataPath)
	data = Data()
	helper = Helper()
	globals = Globals(dataPath)
	input = Input()
	events = Events()
	debugInfo = DebugInfo()

	love.window.setTitle("template-love2d")
	love.window.setMode(globals.config.windowSize.w, globals.config.windowSize.h, {vsync=1})

	love.graphics.setBackgroundColor(globals.config.windowBackColour.r, globals.config.windowBackColour.g, globals.config.windowBackColour.b)
	love.graphics.setFont(helper:getFont(globals.config.fontMain))
	love.graphics.setDefaultFilter("linear", "linear", 1)
	love.mouse.setCursor(helper:getCursor(globals.config.cursorArrow))

	self:loadNodesFromJSONFile()
end

function Engine:update(dt)
	for n = 1, #self.loadedNodes do self.loadedNodes[n]:update(dt) end

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

	for n = 1, #self.loadedNodes do self.loadedNodes[n]:draw() end
	
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

function Engine:addNode(node)
end

function Engine:removeNode(handle)
end

function Engine:loadNode(handle)
	for n = 1, #self.nodes do
		if self.nodes[n].handle ~= nil and self.nodes[n].handle == handle then
			table.insert(self.loadedNodes, self.nodes[n])
			return
		end
	end
end

function Engine:unloadNode(handle)
	index = nil
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].handle ~= nil and self.loadedNodes[n].handle == handle then
			index = n
		end
	end
	if index ~= nil then
		self.loadedNodes[index] = nil
		table.remove(self.loadedNodes, index)
	end
end

function Engine:loadNodesFromJSONFile()
	self.nodes = {}
	self.loadedNodes = {}

	local nodeDataPath = globals.config.dataPath.."/nodes.json"

	local data = data:readFile(nodeDataPath)
	for k, v in pairs(data) do
		self.nodes[#self.nodes+1] = Node(v.handle,{x=v.x,y=v.y,w=v.w,h=v.h})
		local node = self.nodes[#self.nodes]
		node.interactable = v.interactable
		node.zIndex = v.zIndex

		if v.image ~= nil then
			node:setImage(
				v.image.path, 
				{
					x = v.image.scaleX,
					y = v.image.scaleY
				}
			)
		end
		if v.animation ~= nil then
			node:setAnimation(
				v.animation.path, 
				{
					x = v.animation.scaleX,
					y = v.animation.scaleY
				},
				{
					frames = v.animation.data.frames,
					cols = v.animation.data.cols,
					rows = v.animation.data.rows,
					speed = v.animation.data.speed
				}
			)
		end
	end

	table.sort(self.nodes, function(a,b) return a.zIndex < b.zIndex end)
end