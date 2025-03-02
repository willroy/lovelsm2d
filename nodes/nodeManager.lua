NodeManager = Object:extend()

function NodeManager:init()
end

function NodeManager:addNode(node)
end

function NodeManager:removeNode(handle)
end

function NodeManager:loadNodeGroup(groupHandle)
	for n = 1, #self.nodes do
		if self.nodes[n].groupHandle ~= nil and self.nodes[n].groupHandle == groupHandle then
			table.insert(self.loadedNodes, self.nodes[n])
		end
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
	index = nil
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

function NodeManager:loadNodesFromJSONFile()
	self.nodes = {}
	self.loadedNodes = {}

	local nodeDataPath = globals.config.dataPath.."/nodes.json"

	local data = data:readFile(nodeDataPath)
	for k, v in pairs(data) do
		self.nodes[#self.nodes+1] = Node(v.handle,{x=v.x,y=v.y,w=v.w,h=v.h})
		local node = self.nodes[#self.nodes]
		node.interactable = v.interactable
		node.zIndex = v.zIndex
		node.groupHandle = v.groupHandle
		if v.preload ~= nil then node.preload = v.preload end

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