-- An object that exists in the game

Node = Object:extend()

function Node:init(handle, transform)
	self.handle = handle or ""
	self.transform = transform or { x = 0, y = 0, w = 0, h = 0 }
	self.drawable = nil
	self.interactable = false
	self.zIndex = 0
end

function Node:setImage(imagePath, scale)
	self.drawable = Image(self, imagePath, scale)
end

function Node:setAnimation(imagePath, scale, data)
	self.drawable = Animation(self, imagePath, data, scale)
end

function Node:update(dt)
	if self.drawable ~= nil then self.drawable:update(dt) end
end

function Node:draw()
	if self.drawable ~= nil then self.drawable:draw() end
end