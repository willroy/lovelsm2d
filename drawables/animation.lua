-- An object that exists in the game

Animation = Object:extend()

function Animation:init(node, path, data, scale)
	self.node = node
	self.path = path
	local assetsFolder = globals.config.assetsPath
	self.image = love.graphics.newImage(assetsFolder.."/"..self.path)
	self.scale = scale or {x = 1, y = 1}
	self.color = {r=1,g=1,b=1,a=1}

	self.frameSize = {w=(self.image:getWidth()/data.cols), h=self.image:getHeight()/data.rows}
	self.quads = {}

	local count = 0
	for r = 0, data.rows-1 do
		for c = 0, data.cols-1 do
			count = count + 1
			if count > data.frames then break end
			local x = (c*self.frameSize.w)
			local y = (r*self.frameSize.h)
			self.quads[#self.quads+1] = love.graphics.newQuad(x, y, self.frameSize.w, self.frameSize.h, self.image:getWidth(), self.image:getHeight())
		end
	end

	self.timer = {t=0, tmax=data.speed or 4, f=1, fmax=#self.quads}
end

function Animation:update(dt)
	self.timer.t = self.timer.t + dt
	if self.timer.t > self.timer.tmax then
		self.timer.t = 0
		self.timer.f = self.timer.f + 1
		if self.timer.f > self.timer.fmax then
			self.timer.f = 1
		end
	end
end

function Animation:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	love.graphics.draw(self.image, self.quads[self.timer.f], self.node.transform.x, self.node.transform.y, 0, self.scale.x, self.scale.y)
	love.graphics.setColor(1,1,1,1)
end