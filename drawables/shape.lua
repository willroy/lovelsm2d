-- An object that exists in the game

Shape = Object:extend()

function Shape:init(node, data)
	self.node = node
	self.type = data.type
	self.mode = data.mode
	self.transform = data.transform or { x = 0, y = 0, w = 0, h = 0 }
	self.color = data.color or { r = 1, g = 0, b = 0, a = 1 }
end

function Shape:update(dt) end

function Shape:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

	local x = ( self.transform.x + self.node.transform.x )
	local y = ( self.transform.y + self.node.transform.y )

	local widthSet = self.transform.w ~= nil and self.transform.w == 0
	local heightSet = self.transform.h ~= nil and self.transform.h == 0

	local w = self.transform.w or self.node.transform.w
	local h = self.transform.h or self.node.transform.h

	if widthSet then w = self.node.transform.w end
	if heightSet then h = self.node.transform.h end

	if self.type == "rectangle" then love.graphics.rectangle(self.mode, x, y, w, h) end

	love.graphics.setColor(1,1,1,1)
end