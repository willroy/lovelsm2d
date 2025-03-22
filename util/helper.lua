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
  if inputstr == nil then return {} end
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

function Helper:tableDeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
        copy[self:tableDeepCopy(orig_key)] = self:tableDeepCopy(orig_value)
      end
      setmetatable(copy, self:tableDeepCopy(getmetatable(orig)))
    else
      copy = orig
    end
    return copy
end

function Helper:objectCopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[self:objectCopy(k, seen)] = self:objectCopy(v, seen)
    end
    setmetatable(no, self:objectCopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
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

function Helper:readFile(path, isjson)
  local decode = true
  if isjson ~= nil then decode = isjson end
  local readPath = ""
  if path:find("^/") then readPath = self.workingDirectory..path
  else readPath = self.workingDirectory.."/"..path end
  local data = {}
  local f = assert(io.open(readPath, "rb"))
  local content = f:read("*all")
  if decode then data = json.decode(content)
  else data = content end
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
    if filename ~= "." and filename ~= ".." then 
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  return t
end

function Helper:getFilesInDir(path)
  local dir = helper:scanDir(path)
  local files = {}

  for k, file in pairs(dir) do
    files[#files+1] = file
  end

  return files
end