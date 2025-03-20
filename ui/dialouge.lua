Dialouge = Object:extend()

function Dialouge:init(node, data)
	if node == nil or data == nil then return end
	self.node = node

	self.dialougeHandle = ""
	self.dialougePath = globals.config.dialougePath
	self.dialouge = {}
	self.step = 1

	self.text = Text(self.node, {transform = self.node.transform, text = data.text, positioning="center"})
end

function Dialouge:update(dt)
end

function Dialouge:draw()
	self.text.draw()
end

function Dialouge:loadDialouge()
	local pathSplit = helper:mysplit(self.dialougeHandle, "/")
	local path = ""
	for k, v in pairs(pathSplit) do
		if k == #pathSplit then break end
		path = path.."/"..v
	end
	path = self.dialougePath..path..".json"
	local handle = pathSplit[#pathSplit]
	local data = helper:readKeyInFile(path, handle)
	for k, v in pairs(data) do
		self.dialouge[#self.dialouge+1] = v
	end
end

function Dialouge:mousepressed(x, y, button, istouch)
	self.step = self.step + 1
	if self.step > #self.dialouge then
		input.dialougeMode = false
		nodes:unloadNode(self.handle)
	else
		self.text.text = self.dialouge[self.step]
	end
end

function Dialouge:wheelmoved(x, y)
end