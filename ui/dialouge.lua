Dialouge = Object:extend()

function Dialouge:init(node, data)
	self.node = node

	self.dialougeHandle = ""
	self.dialougePath = globals.config.dialougePath
	self.dialouge = {}
	self.step = 1
end

function Dialouge:update(dt)
end

function Dialouge:draw()
	love.graphics.print(self.dialouge[self.step], self.transform.x, self.transform.y)
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
	end
end