DebugInfo = Object:extend()

function DebugInfo:init()
	self.debugEnabled = globals.config.debugEnabled
	self.pos = {x = globals.trackers.mousePos.x-120, y = globals.trackers.mousePos.y-30}
	self.line = {last = 0, current = 0}
	self.width = {last = 0, current = 0}
	self.padding = globals.config.debugWindowPadding
	self.color = globals.config.debugWindowColor
end

function DebugInfo:update(dt)
	self.pos = {x = globals.trackers.mousePos.x-120, y = globals.trackers.mousePos.y-30}
end

function DebugInfo:draw()
	if not self.debugEnabled then return false end

	self.line.last = self.line.current
	self.width.last = self.width.current
	self.line.current = 0
	self.width.current = 0

	self:drawBackground()
	self:drawInfo()
	self:drawNode()
end

function DebugInfo:drawBackground()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
	local x = self.pos.x-self.padding.w
	local y = self.pos.y-(self.line.last*30)+30-self.padding.h
	local w = self.width.last+(self.padding.w*2)
	local h = self.line.last*30+(self.padding.h*2)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(1,1,1)
end

function DebugInfo:drawInfo()
	self:print("("..globals.trackers.mousePos.x..", "..globals.trackers.mousePos.y..")")
	self:print(love.timer.getFPS().." fps")
	local nodes_clicked_text = "clicked: "
	local nodes_hovered_text = "hovered: "
	for n = 1, #input.nodes_clicked do nodes_clicked_text = nodes_clicked_text..input.nodes_clicked[n].handle.." " end
	for n = 1, #input.nodes_hovered do nodes_hovered_text = nodes_hovered_text..input.nodes_hovered[n].handle.." " end
	self:print(nodes_clicked_text)
	self:print(nodes_hovered_text)
end

function DebugInfo:drawNode()
	for n = 1, #nodeManager.loadedNodes do
		local node = nodeManager.loadedNodes[n]
		local color = globals.config.debugNodeColor
		love.graphics.setColor(color.r, color.g, color.b, color.a)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle("line", node.transform.x, node.transform.y, node.transform.w, node.transform.h)
		love.graphics.setLineWidth(1)
	end
end

function DebugInfo:print(text)

	love.graphics.setColor(0,0,0)
	love.graphics.print(text, helper:getFont(globals.config.debugFont), self.pos.x, self.pos.y-(self.line.current*30))
	love.graphics.setColor(1,1,1)

	if helper:getFont(globals.config.debugFont):getWidth(text) > self.width.current then self.width.current = helper:getFont(globals.config.debugFont):getWidth(text) end
	self.line.current = self.line.current + 1
end