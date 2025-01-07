-- Object implementation from SNKRX (MIT license) originally, found in the Balatro engine
-- A simple object that anything can extend from

Object = {}
Object.__index = Object
function Object:init()
end

function Object:extend()
  local cols = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cols[k] = v
    end
  end
  cols.__index = cols
  cols.super = self
  setmetatable(cols, self)
  return cols
end

function Object:is(T)
  local metaTable = getmetatable(self)
  while metaTable do
    if metaTable == T then
      return true
    end
    metaTable = getmetatable(metaTable)
  end
  return false
end

function Object:__call(...)
  local object = setmetatable({}, self)
  object:init(...)
  return object
end
