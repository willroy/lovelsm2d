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
	local tagIndexes = {}

	if staticTag then
		tag = input:match("££(.-)%$%$")
		tagIndexes.start, tagIndexes.finish = string.find(input, input:match("££.-%$%$"), 1, true)
	end
	if dynamicTag then
		tag = input:match("££(.-)^^")
		tagIndexes.start, tagIndexes.finish = string.find(input, input:match("££.*^^"), 1, true)
	end
	if tag == nil then return input end

	local result, targets = self:interpreter(tag)

	local start = string.sub(input, 1, tagIndexes.start-1)
	local middle = result
	local finish = string.sub(input, tagIndexes.finish+1, #input)

	result = start..middle..finish

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
	local dividing = false
	local multiplying = false

	for k, v in pairs(tokens) do
		if v == "+"     then adding = true
		elseif v == "-" then subtracting = true
		elseif v == "/" then dividing = true
		elseif v == "*" then multiplying = true
		elseif string.sub(v, 1, 7) == "globals" then
			local target = helper:mysplit(v, ".")
			local value = globals:getFromString(v)
			targets[#targets+1] = {["globalstarget"] = v, ["value"] = value}
			values[#values+1] = value
		else
			values[#values+1] = v
		end

		local calculation = nil
		if #values > 1 and adding then calculation = values[#values-1] + values[#values] end
		if #values > 1 and subtracting then calculation = values[#values-1] - values[#values] end
		if #values > 1 and dividing then calculation = values[#values-1] / values[#values] end
		if #values > 1 and multiplying then calculation = values[#values-1] * values[#values] end

		if calculation ~= nil then
			values[#values-1] = calculation
			table.remove(values, #values)
			adding = false
			subtracting = false
			dividing = false
			multiplying = false
		end
	end
	
	for k, v in pairs(values) do
		if result == nil then result = "" end
		result = result .. " " .. v
	end

	result = helper:trim(result)

	result = tonumber(result) or result
	if result == "true" then result = true end
	if result == "false" then result = false end

	return result, targets
end