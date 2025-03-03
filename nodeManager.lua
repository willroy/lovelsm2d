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
	indexes = {}
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].groupHandle ~= nil and self.loadedNodes[n].groupHandle == groupHandle then
			indexes[#indexes+1] = n
		end
	end

	-- sort and reverse so that removing nodes from back to front
	indexes = Helper:selectionSort(indexes, true)

	for k, index in pairs(indexes) do
		self.loadedNodes[index] = nil
		table.remove(self.loadedNodes, index)
	end
end

function NodeManager:loadNode(handle)
	for n = 1, #self.nodes do
		if self.nodes[n].handle ~= nil and self.nodes[n].handle == handle then
			table.insert(self.loadedNodes, self.nodes[n])
			return
		end
	end
end

function NodeManager:unloadNode(handle)
	local index = nil
	for n = 1, #self.loadedNodes do
		if self.loadedNodes[n].handle ~= nil and self.loadedNodes[n].handle == handle then
			index = n
		end
	end
	if index ~= nil then
		self.loadedNodes[index] = nil
		table.remove(self.loadedNodes, index)
	end
end

function NodeManager:loadNodes(path)
	local nodeDataPath = path

	local isDir = false
	if string.find(nodeDataPath, "%.") then
		self:loadNodesFromJSONFile(nodeDataPath)
	else
		for k, item in pairs(data:findFileRecursivelyByExt(nodeDataPath, ".json")) do
			self:loadNodesFromJSONFile(item)
		end
	end
end

function NodeManager:loadNodesFromJSONFile(path)
	local data = data:readFile(path)
	for k, v in pairs(data) do
		local handle = path
		handle = string.sub(handle, 1, #handle-5)
		handle = handle.."/"..v.handle:gsub("%/", "-")
		if v.type ~= nil and v.type == "dialouge" then
			self.nodes[#self.nodes+1] = DialougeNode(handle,{x=v.x,y=v.y,w=v.w,h=v.h})
		else
			self.nodes[#self.nodes+1] = Node(handle,{x=v.x,y=v.y,w=v.w,h=v.h})
		end
		local node = self.nodes[#self.nodes]
		node.interactable = v.interactable
		node.zIndex = v.zIndex
		node.groupHandle = v.groupHandle
		if v.preload ~= nil then node.preload = v.preload end
		if v.dialouge ~= nil then node.dialougeHandle = v.dialouge end
		if v.type ~= nil then node.type = v.type end
		if v.type == nil then node.type = "node" end

		if v.image ~= nil then
			node:setImage(
				v.image.path, 
				{
					x = v.image.scaleX,
					y = v.image.scaleY
				}
			)
		end
		if v.animation ~= nil then
			node:setAnimation(
				v.animation.path, 
				{
					x = v.animation.scaleX,
					y = v.animation.scaleY
				},
				{
					frames = v.animation.data.frames,
					cols = v.animation.data.cols,
					rows = v.animation.data.rows,
					speed = v.animation.data.speed
				}
			)
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