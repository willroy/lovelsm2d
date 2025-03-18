FileList = Object:extend()

function FileList:init(node, data)
	self.node = node

	self.path = data.path or love.filesystem.getSaveDirectory()
	self.showPreview = data.showPreview or false
	self.padding = data.padding or 0
	self.color = data.color or { r = 0, g = 0, b = 0, a = 1 }

	self.files = helper:scanDir(self.path)
end

function FileList:update(dt)
end

function FileList:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

	for k, file in pairs(self.files) do
		love.graphics.print(file, (self.node.transform.x+self.padding), (self.node.transform.y+self.padding))
	end

	love.graphics.setColor(1,1,1,1)
end

function FileList:mousepressed(x, y, button, istouch)
end