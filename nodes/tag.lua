Tag = Object:extend()

function Tag:init(tag, targets)
	self.tag = tag or ""
	self.targets = targets or {} 
end