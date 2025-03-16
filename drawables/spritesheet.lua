-- An object that exists in the game

Spritesheet = Object:extend()

function Spritesheet:init(node, path, scale, ssX, ssY, ssW, ssH)
	self.node = node
	self.path = path
	local assetsFolder = globals.config.pathAssets
	self.scale = scale or {x = 1, y = 1}
	self.image = love.graphics.newImage(assetsFolder.."/"..self.path)
	self.quad = love.graphics.newQuad(ssX, ssY, ssW, ssH, self.image)
	self.color = {r=1,g=1,b=1,a=1}
end

function Spritesheet:update(dt) end

function Spritesheet:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	love.graphics.draw(self.image, self.quad, self.node.transform.x, self.node.transform.y, 0, self.scale.x, self.scale.y)
	love.graphics.setColor(1,1,1,1)
end