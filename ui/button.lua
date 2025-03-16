Button = Object:extend()

function Button:init(node, data)
	self.node = node

	if data.drawable.type == "image" then self.drawable = Image(self.node, data.drawable.data) end
	if data.drawable.type == "animation" then self.drawable = Animation(self.node, data.drawable.data) end
	if data.drawable.type == "spritesheet" then self.drawable = Spritesheet(self.node, data.drawable.data) end
	if data.drawable.type == "shape" then self.drawable = Shape(self.node, data.drawable.data) end

	if data.hoverdrawable.type == "image" then self.hoverdrawable = Image(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "animation" then self.hoverdrawable = Animation(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "spritesheet" then self.hoverdrawable = Spritesheet(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "shape" then self.hoverdrawable = Shape(self.node, data.hoverdrawable.data) end
end

function Button:update(dt)
	if self.hoverdrawable ~= nil and helper:contains(input.nodes_hovered, self.node) then self.hoverdrawable:update(dt)
	elseif self.drawable ~= nil then self.drawable:update(dt) end
end

function Button:draw()
	if self.hoverdrawable ~= nil and helper:contains(input.nodes_hovered, self.node) then self.hoverdrawable:draw()
	elseif self.drawable ~= nil then self.drawable:draw() end
end

function Button:mousepressed(x, y, button, istouch)
end