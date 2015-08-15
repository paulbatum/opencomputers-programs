local component = require("component")
local shell = require("shell")
local blocklib = require("blocklib")
local textures = require("textures")

function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

local printer = component.printer3d
local args = shell.parse(...)
if #args < 1 then
  io.write("Usage: printblock PATTERN TEXTURE1 [TEXTURE2 ...]\n")
  os.exit(0)
end

local patternName = tostring(table.remove(args,1))
local pattern = blocklib.patterns[patternName]
if pattern then
  io.write("Using pattern:" .. patternName)
else
  io.write("Unrecognized pattern: " .. patternName)
  os.exit(0)
end

local textures = map(textures.tryResolve, args)
local b = pattern(unpack(textures))
blocklib.print(b, count)
