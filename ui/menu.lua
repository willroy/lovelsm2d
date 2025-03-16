Menu = Object:extend()

function Menu:init(node, data)
	self.node = node

	self.label = data.label 
	self.subMenus = data.subMenus
end

function Menu:update(dt)
end

function Menu:draw()
end

function Menu:mousepressed(x, y, button, istouch)
end