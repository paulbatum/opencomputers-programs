local component = require("component")
local shell = require("shell")
local blocklib = require("blocklib")
local textures = require("textures")

local printer = component.printer3d
local args = shell.parse(...)
if #args < 1 then
  io.write("Usage: printblock TEXTURE [count]\n")
  os.exit(0)
end
local count = 1
if #args > 1 then
  count = assert(tonumber(args[2]), tostring(args[2]) .. " is not a valid count")
end

local b = blocklib.makeBlock(textures.tryResolve(args[1]), "3D Print")
blocklib.print(b, count)
