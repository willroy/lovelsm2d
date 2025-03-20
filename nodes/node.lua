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

	self.tags = {}
end

function Node:setDrawable(type, data)
	self.drawable = helper:objectCopy(nodes.drawables[type])
	self.drawable:init(self, data)
end

function Node:setUI(type, data)
	self.ui = helper:objectCopy(nodes.uis[type])
	self.ui:init(self, data)
end

function Node:addTag(tag)
	self.tags[#self.tags] = tag
end

function Node:setText(data)
	data.transform = self.transform
	self.text = Text(self, data)
end

function Node:update(dt)
	if self.ui ~= nil then self.ui:update(dt) end
	if self.drawable ~= nil then self.drawable:update(dt) end

	self:checkForTagChanges()
end

function Node:checkForTagChanges()
	for k, tag in pairs(self.tags) do
		for k2, target in pairs(tag.targets) do
			local globalsValue = globals:getFromString(target["globalstarget"])
			if (globalsValue ~= target["value"]) then
				local tags = Tags()
				local result, targets = tags:interpreter(tag.tag)
				self:setFromString(target["target"], result)
				target["value"] = globalsValue
			end
		end
	end
end

function Node:setFromString(str, value)
	if str == "handle" then self.handle = value end
	if str == "groupHandle" then self.groupHandle = value end
	if str == "transform.x" then self.transform.x = value end
	if str == "transform.y" then self.transform.y = value end
	if str == "transform.w" then self.transform.w = value end
	if str == "transform.h" then self.transform.h = value end
	if str == "zIndex" then self.zIndex = value end
	if str == "interactable" then self.interactable = value end
end

function Node:draw()
	if self.text ~= nil then self.text:draw() end
	if self.ui ~= nil then self.ui:draw() end
	if self.drawable ~= nil then self.drawable:draw() end
end

function Node:mousepressed(x, y, button, istouch)
	if self.ui ~= nil then self.ui:mousepressed(x, y, button, istouch) end
end

function Node:wheelmoved(x, y)
	if self.ui ~= nil then self.ui:wheelmoved(x, y) end
end