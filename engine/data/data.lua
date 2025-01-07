local json = require('cjson')

Data = Object:extend()

function Data:readFile(path)
	local data = {}
	local f = assert(io.open(path, "rb"))
  local content = f:read("*all")
	data = json.decode(content)
	return data
end

function Data:readKeyInFile(path, key)
	local data = {}
	local f = assert(io.open(path, "rb"))
  local content = f:read("*all")
	data = json.decode(content)
	return data[key]
end