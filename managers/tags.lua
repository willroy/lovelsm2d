Tags = Object:extend()

function Tags:init()
	self.tags = {}
end

function Tags:check(input, nodeTarget)
	if type(input) ~= "string" then return input end
	if string.find(input, "££") == nil then return input end

	return self:createTag(input, nodeTarget)
end

function Tags:createTag(input, nodeTarget)
	local tag = nil
	local staticTag = ( input:match("££(.*)%$%$") ~= nil )
	local dynamicTag = ( input:match("££(.*)^^") ~= nil )

	if staticTag then tag = input:match("££(.*)%$%$") end
	if dynamicTag then tag = input:match("££(.*)^^") end
	if tag == nil then return input end

	local result, targets = self:interpreter(tag)

	for k, v in pairs(targets) do
		v["target"] = nodeTarget
	end

	if #targets > 0 and dynamicTag then self.tags[#self.tags+1] = Tag(tag, targets) end

	return result
end

function Tags:interpreter(tag)
	tokens = helper:mysplit(tag, " ")

	local result = nil
	local targets = {}
	local values = {}
	local adding = false
	local subtracting = false

	for k, v in pairs(tokens) do
		if v == "+" then
			adding = true
		elseif v == "-" then
			subtracting = true
		elseif string.sub(v, 1, 7) == "globals" then
			local target = helper:mysplit(v, ".")
			local value = globals:getFromString(v)

			targets[#targets+1] = {["globalstarget"] = v, ["value"] = value}

			if #values == 0 then values[1] = value
			elseif #values == 1 then values[2] = value end
		else
			if #values == 0 then values[1] = v
			elseif #values == 1 then values[2] = v end
		end
	end

	if #values == 1 then result = values[1] end
	if #values == 2 and adding then result = values[1] + values[2] end
	if #values == 2 and subtracting then result = values[1] - values[2] end

	return result, targets
end