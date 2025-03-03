DialougeNode = Node:extend()

function DialougeNode:init(handle, transform)
	Node.init(self, handle, transform)
	self.dialougeHandle = ""
	self.dialouge = {}
	self.step = 1
end

function DialougeNode:update(dt)
	Node.update(self)
end

function DialougeNode:draw()
	Node.draw(self)
	love.graphics.print(self.dialouge[self.step], self.transform.x, self.transform.y)
end

function DialougeNode:loadDialouge()
	local data = data:readKeyInFile(globals.config.dialougePath, self.dialougeHandle)
	for k, v in pairs(data) do
		self.dialouge[#self.dialouge+1] = v
	end
end

function DialougeNode:mousepressed()
	self.step = self.step + 1
	if self.step > #self.dialouge then
		input.dialougeMode = false
		nodeManager:unloadNode(self.handle)
	end
end