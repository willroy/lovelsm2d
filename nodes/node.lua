Node = Object:extend()

function Node:init()
	self.handle = ""
	self.groupHandle = ""
	self.transform = { x = 0, y = 0, w = 0, h = 0 }
	self.zIndex = 0
	self.interactable = false

	self.ui = nil
	self.drawable = nil
	self.text = nil
end

function Node:setDrawable(type, data)
	if type == "image" then self.drawable = Image(self, data) end
	if type == "animation" then self.drawable = Animation(self, data) end
	if type == "spritesheet" then self.drawable = Spritesheet(self, data) end
	if type == "shape" then self.drawable = Shape(self, data) end
end

function Node:setUI(type, data)
	if type == "button" then self.ui = Button(self, data) end
	if type == "dialouge" then self.ui = Dialouge(self, data) end
	if type == "fileList" then self.ui = FileList(self, data) end
	if type == "menu" then self.ui = Menu(self, data) end
end

function Node:setText(data)
	data.containerTransform = self.transform
	self.text = Text(self, data)
end

function Node:update(dt)
	if self.ui ~= nil then self.ui:update(dt) end
	if self.drawable ~= nil then self.drawable:update(dt) end
end

function Node:draw()
	if self.text ~= nil then self.text:draw() end
	if self.ui ~= nil then self.ui:draw() end
	if self.drawable ~= nil then self.drawable:draw() end
end

function Node:mousepressed(x, y, button, istouch)
	if self.ui ~= nil then self.ui:mousepressed(x, y, button, istouch) end
end