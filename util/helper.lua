Helper = Object:extend()

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