Tag = Object:extend()

function Tag:init(tag, targets)
	self.tag = tag or ""
	self.targets = targets or {} 
end

function Tag:update(dt)
end

function Tag:draw()
end

function Tag:mousepressed(x, y, button, istouch)
end