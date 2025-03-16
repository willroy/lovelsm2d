FileList = Object:extend()

function FileList:init(node, data)
	self.node = node

	local path = data.path
	local showPreview = data.showPreview or false
end

function FileList:update(dt)
end

function FileList:draw()
end

function FileList:mousepressed(x, y, button, istouch)
end