Button = Object:extend()

function Button:init(node, data)
	if node == nil or data == nil then return end
	self.node = node

	if data.drawable.type == "image" then self.drawable = Image(self.node, data.drawable.data) end
	if data.drawable.type == "animation" then self.drawable = Animation(self.node, data.drawable.data) end
	if data.drawable.type == "spritesheet" then self.drawable = Spritesheet(self.node, data.drawable.data) end
	if data.drawable.type == "shape" then self.drawable = Shape(self.node, data.drawable.data) end

	if data.hoverdrawable.type == "image" then self.hoverdrawable = Image(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "animation" then self.hoverdrawable = Animation(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "spritesheet" then self.hoverdrawable = Spritesheet(self.node, data.hoverdrawable.data) end
	if data.hoverdrawable.type == "shape" then self.hoverdrawable = Shape(self.node, data.hoverdrawable.data) end

	self.event = data.event

	if data.text ~= nil then
		data.text.transform = self.node.transform
		self.text = Text(self.node, data.text)
	end

	self.overrideHoverCheck = data.overrideHoverCheck or false
	self.hovered = false
end

function Button:update(dt)
	if self.hovered ~= true and not self.overrideHoverCheck then self.hovered = helper:contains(input.nodes_hovered, self.node) end
	if self.hoverdrawable ~= nil and self.hovered then self.hoverdrawable:update(dt)
	elseif self.drawable ~= nil then self.drawable:update(dt) end
	self.hovered = false
end

function Button:draw()
	if self.hovered ~= true and not self.overrideHoverCheck then self.hovered = helper:contains(input.nodes_hovered, self.node) end
	if self.text ~= nil then self.text:draw() end
	if self.hoverdrawable ~= nil and self.hovered then self.hoverdrawable:draw()
	elseif self.drawable ~= nil then self.drawable:draw() end
	self.hovered = false
end

function Button:mousepressed(x, y, button, istouch)
end

function Button:wheelmoved(x, y)
end