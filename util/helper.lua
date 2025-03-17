local json = require('cjson')

Helper = Object:extend()

function Helper:init(dir)
  self.workingDirectory = dir or love.filesystem.getWorkingDirectory()
end

function Helper:helloWorld()
	print("Hello World!")
end

function Helper:contains(list, value)
	for i = 1, #list do
		if list[i] == value then return true end
	end
	return false
end

function Helper:mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function Helper:slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function Helper:getFont(data)
  return love.graphics.newFont(data.size)
end

function Helper:getCursor(data)
  return love.mouse.newCursor(data.path, data.w, data.h)
end

function Helper:selectionSort(tableToSort, reverse)
  local reverse = reverse or false
  local tableSorted = {}
  for _,v in pairs(tableToSort) do 
    table.insert(tableSorted, v)  
  end
  
  if reverse then
    local function reverseSort(a, b)
      return a > b
    end

    table.sort(tableSorted, reverseSort)
  
    return tableSorted
  end

  table.sort(tableSorted)
  
  return tableSorted
end

-- file helper functions

function Helper:fileExists(path)
  local readPath = ""
  if path:find("^/") then readPath = self.workingDirectory..path
  else readPath = self.workingDirectory.."/"..path end
   local file = io.open(readPath, "r")
   if file ~= nil then io.close(file) return true else return false end
  return data
end

function Helper:getAbsolutePath(path)
  local readPath = ""
  if path:find("^/") then readPath = self.workingDirectory..path
  else readPath = self.workingDirectory.."/"..path end
  return readPath
end

function Helper:readFile(path)
  local readPath = ""
  if path:find("^/") then readPath = self.workingDirectory..path
  else readPath = self.workingDirectory.."/"..path end
  local data = {}
  local f = assert(io.open(readPath, "rb"))
    local content = f:read("*all")
  data = json.decode(content)
  return data
end

function Helper:readKeyInFile(path, key)
  local readPath = ""
  if path:find("^/") then readPath = self.workingDirectory..path
  else readPath = self.workingDirectory.."/"..path end
  local data = {}
  local f = assert(io.open(readPath, "rb"))
    local content = f:read("*all")
  data = json.decode(content)
  return data[key]
end

function Helper:findFileRecursivelyByExt(dir, ext)
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

function Helper:scanDir(dir)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..dir..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end