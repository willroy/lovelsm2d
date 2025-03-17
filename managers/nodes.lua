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
		end
	end
end

function Nodes:unloadNodeGroup(groupHandle)
	local newLoadedNodes = {}
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].groupHandle == nil or self.loadedNodes[n].groupHandle ~= groupHandle then
			newLoadedNodes[#newLoadedNodes+1] = self.loadedNodes[n]
		end
	end

	self.loadedNodes = newLoadedNodes
end

function Nodes:loadNode(handle)
	for n = 1, #self.nodes do
		if self.nodes[n].handle ~= nil and self.nodes[n].handle == handle then
			table.insert(self.loadedNodes, self.nodes[n])
			return
		end
	end
end

function Nodes:unloadNode(handle)
	local newLoadedNodes = {}
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].handle == nil and self.loadedNodes[n].handle ~= handle then
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
	local tags = Tags()

	for k, v in pairs(data) do
		self.nodes[#self.nodes+1] = Node()

		local node = self.nodes[#self.nodes]
		local handle = string.sub(path, #nodeDataPath+2, #path-5).."/"..v.handle:gsub("%/", "-")
		local groupHandle = string.sub(path, #nodeDataPath+2, #path-5).."/"..v.groupHandle:gsub("%/", "-")

		node.interactable = tags:check(v.interactable, "interactable")
		node.zIndex = tags:check(v.zIndex, "zIndex")
		node.groupHandle = tags:check(groupHandle, "groupHandle")
		node.handle = tags:check(handle, "handle")
		node.transform = {x=tags:check(v.x, "transform.x"),y=tags:check(v.y, "transform.y"),w=tags:check(v.w, "transform.w"),h=tags:check(v.h, "transform.h")}
		node.preload = tags:check(v.preload, "preload")

		if #tags.tags > 0 then node.tags = tags.tags end

		if v.drawable ~= nil then node:setDrawable(v.drawable.type, v.drawable.data) end
		if v.ui ~= nil then node:setUI(v.ui.type, v.ui.data) end
		if v.text ~= nil then node:setText(v.text) end
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