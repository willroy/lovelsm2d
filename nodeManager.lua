NodeManager = Object:extend()

function NodeManager:init()
	self.nodes = {}
	self.loadedNodes = {}
end

function NodeManager:addNode(node)
end

function NodeManager:removeNode(handle)
end

function NodeManager:loadNodeGroup(groupHandle)
	for n = 1, #self.nodes do
		if self.nodes[n].groupHandle ~= nil and self.nodes[n].groupHandle == groupHandle then
			table.insert(self.loadedNodes, self.nodes[n])
			if self.nodes[n].type == "dialouge" then
				input.dialougeMode = true
				self.nodes[n]:loadDialouge()
			end
		end
	end
end

function NodeManager:unloadNodeGroup(groupHandle)
	local newLoadedNodes = {}
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].groupHandle ~= nil and self.loadedNodes[n].groupHandle == groupHandle then
			if self.loadedNodes[n].type == "dialouge" then input.dialougeMode = false end
		else
			if self.loadedNodes[n].type == "dialouge" then input.dialougeMode = true end
			newLoadedNodes[#newLoadedNodes+1] = self.loadedNodes[n]
		end
	end

	self.loadedNodes = newLoadedNodes
end

function NodeManager:loadNode(handle)
	for n = 1, #self.nodes do
		if self.nodes[n].handle ~= nil and self.nodes[n].handle == handle then
			table.insert(self.loadedNodes, self.nodes[n])
			if self.nodes[n].type == "dialouge" then
				input.dialougeMode = true
				self.nodes[n]:loadDialouge()
			end
			return
		end
	end
end

function NodeManager:unloadNode(handle)
	local newLoadedNodes = {}
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].handle ~= nil and self.loadedNodes[n].handle == handle then
			if self.loadedNodes[n].type == "dialouge" then input.dialougeMode = false end
		else
			if self.loadedNodes[n].type == "dialouge" then input.dialougeMode = true end
			newLoadedNodes[#newLoadedNodes+1] = self.loadedNodes[n]
		end
	end
	self.loadedNodes = newLoadedNodes
end

function NodeManager:loadNodes()
	local nodeDataPath = globals.config.nodesPath

	if string.find(nodeDataPath, "%.") then
		self:loadNodesFromJSONFile(nodeDataPath)
	else
		for k, item in pairs(data:findFileRecursivelyByExt(nodeDataPath, ".json")) do
			self:loadNodesFromJSONFile(item)
		end
	end
end

function NodeManager:loadNodesFromJSONFile(path)
	local nodeDataPath = globals.config.nodesPath
	local data = data:readFile(path)

	for k, v in pairs(data) do
		if v.type ~= nil and v.type == "dialouge" then
			self.nodes[#self.nodes+1] = DialougeNode()
		else
			self.nodes[#self.nodes+1] = Node()
		end

		local node = self.nodes[#self.nodes]
		local handle = string.sub(path, #nodeDataPath+2, #path-5).."/"..v.handle:gsub("%/", "-")
		local groupHandle = string.sub(path, #nodeDataPath+2, #path-5).."/"..v.groupHandle:gsub("%/", "-")

		node.interactable = v.interactable
		node.zIndex = v.zIndex
		node.groupHandle = groupHandle
		node.handle = handle
		node.transform = {x=v.x,y=v.y,w=v.w,h=v.h}
		node.preload = v.preload
		node.dialougeHandle = v.dialouge

		if v.type ~= nil then node.type = v.type end

		if v.image ~= nil then
			node:setImage(v.image.path, {x = v.image.scaleX, y = v.image.scaleY})
		end
		
		if v.animation ~= nil then
			node:setAnimation(v.animation.path, {x = v.animation.scaleX, y = v.animation.scaleY}, {frames = v.animation.data.frames, cols = v.animation.data.cols, rows = v.animation.data.rows, speed = v.animation.data.speed})
		end

		if v.spritesheet ~= nil then
			node:setSpritesheet(v.spritesheet.path, {x = v.spritesheet.scaleX, y = v.spritesheet.scaleY}, v.spritesheet.ssX, v.spritesheet.ssY, v.spritesheet.ssW, v.spritesheet.ssH)
		end
	end

	table.sort(self.nodes, function(a,b) return a.zIndex < b.zIndex end)

	self:preLoadNodes()
end

function NodeManager:preLoadNodes()
	for n = 1, #self.nodes do
		if self.nodes[n].preload ~= nil and self.nodes[n].preload then
			table.insert(self.loadedNodes, self.nodes[n])
		end
	end
end