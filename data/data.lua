local json = require('cjson')

Data = Object:extend()

function Data:fileExists(path)
	local readPath = ""
	if path:find("^/") then readPath = love.filesystem.getWorkingDirectory()..path
	else readPath = love.filesystem.getWorkingDirectory().."/"..path end
   local file = io.open(readPath, "r")
   if file ~= nil then io.close(file) return true else return false end
	return data
end

function Data:getAbsolutePath(path)
	local readPath = ""
	if path:find("^/") then readPath = love.filesystem.getWorkingDirectory()..path
	else readPath = love.filesystem.getWorkingDirectory().."/"..path end
	return readPath
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

function Data:findFileRecursivelyByExt(dir, ext)
	local files = {}
	for k, item in pairs(self:scanDir(dir)) do
		if string.find(item, "%.") and item ~= "." and item ~= ".." then
			if string.sub(item, -#ext) == ext then files[#files+1] = dir.."/"..item end
		elseif item ~= "." and item ~= ".." then
			local dirPath = dir.."/"..item
			for k, itemR in pairs(self:findFileRecursivelyByExt(dirPath, ext)) do
				files[#files+1] = itemR
			end
		end
	end
	return files
end

function Data:scanDir(dir)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..dir..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end