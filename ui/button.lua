Button = Object:extend()

function Button:init(node, data)
	self.node = node

	if data.drawable.type == "image" then self.drawable = Image(self, data) end
	if data.drawable.type == "animation" then self.drawable = Animation(self, data) end
	if data.drawable.type == "spritesheet" then self.drawable = Spritesheet(self, data) end
	if data.drawable.type == "shape" then self.drawable = Shape(self, data) end

	if data.hoverdrawable.type == "image" then self.hoverdrawable = Image(self, data) end
	if data.hoverdrawable.type == "animation" then self.hoverdrawable = Animation(self, data) end
	if data.hoverdrawable.type == "spritesheet" then self.hoverdrawable = Spritesheet(self, data) end
	if data.hoverdrawable.type == "shape" then self.hoverdrawable = Shape(self, data) end
end

function Button:update(dt)
end

function Button:draw()
end

function Button:mousepressed(x, y, button, istouch)
end