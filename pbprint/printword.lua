local component = require("component")
local shell = require("shell")

package.loaded.blocklib = nil
package.loaded.textures = nil
local blocklib = require("blocklib")
local textures = require("textures")

local printer = component.printer3d
local args = shell.parse(...)
if #args < 1 then
  io.write("Usage: printword WORD TINT\n")
  os.exit(0)
end

local word = tostring(args[1])
local tint = textures.tryResolve(args[2])

for c in string.gmatch(word, ".") do
  local pattern = blocklib.patterns["alphabet_" .. c]
  if pattern then
    blocklib.print(pattern(textures.blank, tint), 1)      
  else
    io.write("Unknown pattern: " .. c .. "\n")
  end
  while printer.status() == "busy" do os.sleep(1) end  
end  
