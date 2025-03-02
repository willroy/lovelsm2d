local json = require('cjson')

Data = Object:extend()

function Data:fileExists(path)
   local file = io.open(path, "r")
   if file ~= nil then io.close(f) return true else return false end
	return data
end

function Data:readFile(path)
	local readPath = ""
	if path:find("^/") then readPath = love.filesystem.getWorkingDirectory()..path
	else readPath = love.filesystem.getWorkingDirectory().."/"..path end
	local data = {}
	local f = assert(io.open(readPath, "rb"))
  	local content = f:read("*all")
	data = json.decode(content)
	return data
end

function Data:readKeyInFile(path, key)
	local readPath = ""
	if path:find("^/") then readPath = love.filesystem.getWorkingDirectory()..path
	else readPath = love.filesystem.getWorkingDirectory().."/"..path end
	local data = {}
	local f = assert(io.open(readPath, "rb"))
  local content = f:read("*all")
	data = json.decode(content)
	return data[key]
end