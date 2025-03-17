Tag = Object:extend()

function Tag:check(input)
	if type(input) ~= "string" then return input end
	if string.find(input, "$$") == nil then return input end

	return self:interpreter(input)
end

function Tag:interpreter(input)
	tag = input:match("££(.*)%$%$")
	tokens = helper:mysplit(tag, " ")

	local result = nil
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
			local value = nil

			if target[2] == "trackers" then value = globals.trackers[target[3]] end
			if target[2] == "config" then value = globals.config[target[3]] end
			if target[2] == "data" then value = globals.data[target[3]] end

			if type(value) == "table" then value = value[target[4]] end

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

	return result
end