-- An object that exists in the game

Shape = Object:extend()

function Shape:init(node, type, mode, transform, color)
	self.node = node
	self.type = type
	self.mode = mode
	self.transform = transform or { x = 0, y = 0, w = 0, h = 0 }
	self.color = { r = 1, g = 0, b = 0, a = 1 }
end

function Shape:update(dt) end

function Shape:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

	local x = ( self.transform.x + self.node.transform.x )
	local y = ( self.transform.y + self.node.transform.y )
	local w = self.transform.w or self.node.transform.w
	local h = self.transform.h or self.node.transform.h

	if self.type == "rectangle" then love.graphics.rectangle(self.mode, x, y, w, h) end

	love.graphics.setColor(1,1,1,1)
end