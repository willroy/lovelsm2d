Node = Object:extend()

function Node:init()
	self.handle = ""
	self.groupHandle = ""
	self.transform = { x = 0, y = 0, w = 0, h = 0 }
	self.drawable = nil
	self.hoverDrawable = nil
	self.interactable = false
	self.zIndex = 0
	self.preload = false
	self.type = ""
end

function Node:setImage(imagePath, scale)
	self.drawable = Image(self, imagePath, scale)
end

function Node:setHoverImage(imagePath, scale)
	self.hoverDrawable = Image(self, imagePath, scale)
end

function Node:setAnimation(imagePath, scale, data)
	self.drawable = Animation(self, imagePath, data, scale)
end

function Node:setHoverAnimation(imagePath, scale, data)
	self.hoverDrawable = Animation(self, imagePath, data, scale)
end

function Node:setSpritesheet(imagePath, scale, ssX, ssY, ssW, ssH)
	self.drawable = Spritesheet(self, imagePath, scale, ssX, ssY, ssW, ssH)
end

function Node:setHoverSpritesheet(imagePath, scale, ssX, ssY, ssW, ssH)
	self.hoverDrawable = Spritesheet(self, imagePath, scale, ssX, ssY, ssW, ssH)
end

function Node:setShape(type, mode, transform, color)
	self.drawable = Shape(self, type, mode, transform, color)
end

function Node:setHoverShape(type, mode, transform, color)
	self.hoverDrawable = Shape(self, type, mode, transform, color)
end

function Node:update(dt)
	if self.drawable ~= nil then self.drawable:update(dt) end
	if self.hoverDrawable ~= nil and helper:contains(input.nodes_hovered, self) then self.hoverDrawable:update(dt) end
end

function Node:draw()
	if self.drawable ~= nil then self.drawable:draw() end
	if self.hoverDrawable ~= nil and helper:contains(input.nodes_hovered, self)  then self.hoverDrawable:draw() end
end