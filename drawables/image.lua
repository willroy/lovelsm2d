-- An object that exists in the game

Image = Object:extend()

function Image:init(node, data)
	self.node = node
	self.path = data.path
	local assetsFolder = globals.config.pathAssets
	self.image = love.graphics.newImage(assetsFolder.."/"..self.path)
	self.scale = data.scale or {x = 1, y = 1}
	self.color = {r=1,g=1,b=1,a=1}
end

function Image:update(dt) end

function Image:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	love.graphics.draw(self.image, self.node.transform.x, self.node.transform.y, 0, self.scale.x, self.scale.y)
	love.graphics.setColor(1,1,1,1)
end