Nodes = Object:extend()

function Nodes:init()
	self.nodes = {}
	self.loadedNodes = {}
end

function Nodes:addNode(node)
end

function Nodes:removeNode(handle)
end

function Nodes:loadNodeGroup(groupHandle)
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

function Nodes:unloadNodeGroup(groupHandle)
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

function Nodes:loadNode(handle)
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

function Nodes:unloadNode(handle)
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

function Nodes:loadNodes()
	local nodeDataPath = globals.config.pathNodes

	if string.find(nodeDataPath, "%.") then
		self:loadNodesFromJSONFile(nodeDataPath)
	else
		for k, item in pairs(helper:findFileRecursivelyByExt(nodeDataPath, ".json")) do
			self:loadNodesFromJSONFile(item)
		end
	end
end

function Nodes:isNodeLoaded(nodeHandle)
	for k, node in pairs(self.loadedNodes) do
		if node.handle == nodeHandle then
			return true
		end
	end
	return false
end

function Nodes:isNodeGroupLoaded(nodeHandle)
	for k, node in pairs(self.loadedNodes) do
		if node.groupHandle == nodeHandle then
			return true
		end
	end
	return false
end

function Nodes:loadNodesFromJSONFile(path)
	local nodeDataPath = globals.config.pathNodes
	local data = helper:readFile(path)

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

		if v.image ~= nil then node:setImage(v.image.path, {x = v.image.scaleX, y = v.image.scaleY}) end
		if v.hover_image ~= nil then node:setHoverImage(v.hover_image.path, {x = v.hover_image.scaleX, y = v.hover_image.scaleY}) end
		if v.animation ~= nil then node:setAnimation(v.animation.path, {x = v.animation.scaleX, y = v.animation.scaleY}, {frames = v.animation.data.frames, cols = v.animation.data.cols, rows = v.animation.data.rows, speed = v.animation.data.speed}) end
		if v.hover_animation ~= nil then node:setHoverAnimation(v.hover_animation.path, {x = v.hover_animation.scaleX, y = v.hover_animation.scaleY}, {frames = v.hover_animation.data.frames, cols = v.hover_animation.data.cols, rows = v.hover_animation.data.rows, speed = v.hover_animation.data.speed}) end
		if v.spritesheet ~= nil then node:setSpritesheet(v.spritesheet.path, {x = v.spritesheet.scaleX, y = v.spritesheet.scaleY}, v.spritesheet.ssX, v.spritesheet.ssY, v.spritesheet.ssW, v.spritesheet.ssH) end
		if v.hover_spritesheet ~= nil then node:setHoverSpritesheet(v.hover_spritesheet.path, {x = v.hover_spritesheet.scaleX, y = v.hover_spritesheet.scaleY}, v.hover_spritesheet.ssX, v.hover_spritesheet.ssY, v.hover_spritesheet.ssW, v.hover_spritesheet.ssH) end
		if v.shape ~= nil then node:setShape(v.shape.type, v.shape.mode, {x = v.shape.x, y = v.shape.y, w = v.shape.w, h = v.shape.h}, {r = v.shape.r, g = v.shape.g, b = v.shape.b, a = v.shape.a}) end
		if v.hover_shape ~= nil then node:setHoverShape(v.hover_shape.type, v.hover_shape.mode, {x = v.hover_shape.x, y = v.hover_shape.y, w = v.hover_shape.w, h = v.hover_shape.h}, {r = v.hover_shape.r, g = v.hover_shape.g, b = v.hover_shape.b, a = v.hover_shape.a}) end
	end

	table.sort(self.nodes, function(a,b) return a.zIndex < b.zIndex end)

	self:preLoadNodes()
end

function Nodes:preLoadNodes()
	for n = 1, #self.nodes do
		if self.nodes[n].preload ~= nil and self.nodes[n].preload then
			table.insert(self.loadedNodes, self.nodes[n])
		end
	end
end