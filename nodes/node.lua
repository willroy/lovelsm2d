Node = Object:extend()

function Node:init()
	self.handle = ""
	self.groupHandle = ""
	self.transform = { x = 0, y = 0, w = 0, h = 0 }
	self.zIndex = 0
	self.interactable = false

	self.ui = nil
	self.drawable = nil
	self.hoverDrawable = nil
end

function Node:setImage(imagePath, scale, hover)
	if hover then self.hoverDrawable = Image(self, imagePath, scale)
	else self.drawable = Image(self, imagePath, scale) end
end

function Node:setAnimation(imagePath, scale, data, hover)
	if hover then self.hoverDrawable = Animation(self, imagePath, data, scale)
	else self.drawable = Animation(self, imagePath, data, scale) end
end

function Node:setSpritesheet(imagePath, scale, ssX, ssY, ssW, ssH, hover)
	if hover then self.hoverDrawable = Spritesheet(self, imagePath, scale, ssX, ssY, ssW, ssH)
	else self.drawable = Spritesheet(self, imagePath, scale, ssX, ssY, ssW, ssH) end
end

function Node:setShape(type, mode, transform, color, hover)
	if hover then self.hoverDrawable = Shape(self, type, mode, transform, color)
	else self.drawable = Shape(self, type, mode, transform, color) end
end

function Node:update(dt)
	if self.ui ~= nil then self.ui:update(dt) end
	if self.drawable ~= nil then self.drawable:update(dt) end
	if self.hoverDrawable ~= nil and helper:contains(input.nodes_hovered, self) then self.hoverDrawable:update(dt) end
end

function Node:draw()
	if self.ui ~= nil then self.ui:draw() end
	if self.drawable ~= nil then self.drawable:draw() end
	if self.hoverDrawable ~= nil and helper:contains(input.nodes_hovered, self)  then self.hoverDrawable:draw() end
end