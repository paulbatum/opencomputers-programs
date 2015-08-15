local component = require("component")

local blocklib = {}

blocklib.print = function(data, count)
  local printer = component.printer3d
  io.write("Configuring...\n")

  printer.reset()
  if data.label then
    printer.setLabel(data.label)
  end
  if data.tooltip then
    printer.setTooltip(data.tooltip)
  else
    printer.setTooltip("Paul Blocks (TM)")
  end
  if data.lightLevel and printer.setLightLevel then -- as of OC 1.5.7
    printer.setLightLevel(data.lightLevel)
  end
  if data.emitRedstone then
    printer.setRedstoneEmitter(data.emitRedstone)
  end
  if data.buttonMode then
    printer.setButtonMode(data.buttonMode)
  end
  if data.collidable and printer.setCollidable then
    printer.setCollidable(not not data.collidable[1], not not data.collidable[2])
  end
  for i, shape in ipairs(data.shapes or {}) do
    local result, reason = printer.addShape(shape[1], shape[2], shape[3], shape[4], shape[5], shape[6], shape.texture, shape.state, shape.tint)
    if not result then
      io.write("Failed adding shape: " .. tostring(reason) .. "\n")
    end
  end

  io.write("Label: '" .. (printer.getLabel() or "not set") .. "'\n")
  io.write("Tooltip: '" .. (printer.getTooltip() or "not set") .. "'\n")
  if printer.getLightLevel then -- as of OC 1.5.7
    io.write("Light level: " .. printer.getLightLevel() .. "\n")
  end
  io.write("Redstone level: " .. select(2, printer.isRedstoneEmitter()) .. "\n")
  io.write("Button mode: " .. tostring(printer.isButtonMode()) .. "\n")
  if printer.isCollidable then -- as of OC 1.5.something
    io.write("Collidable: " .. tostring(select(1, printer.isCollidable())) .. "/" .. tostring(select(2, printer.isCollidable())) .. "\n")
  end
  io.write("Shapes: " .. printer.getShapeCount() .. " inactive, " .. select(2, printer.getShapeCount()) .. " active\n")

  local result, reason = printer.commit(count)
  if result then
    io.write("Job successfully committed!\n")
  else
    io.stderr:write("Failed committing job: " .. tostring(reason) .. "\n")
  end
end

blocklib.patterns = {}

blocklib.patterns.block = function(texture)
  return {    
    shapes = {{0,0,0,16,16,16, texture=texture}}
  }
end

blocklib.patterns.dualBlock10 = function(texture_outer, texture_inner)
  return {    
    shapes = {
      { 0,0,0,3,3,16,texture = texture_outer },
      { 3,0,0,16,3,3,texture = texture_outer },
      { 3,0,3,13,1,13,texture = texture_inner },
      { 3,0,13,16,16,15,texture = texture_outer },
      { 3,0,15,16,3,16,texture = texture_outer },
      { 13,0,3,15,16,16,texture = texture_outer },
      { 15,0,3,16,3,16,texture = texture_outer },
      { 3,1,3,15,15,15,texture = texture_outer },
      { 0,3,0,3,16,3,texture = texture_outer },
      { 0,3,3,1,13,13,texture = texture_inner },
      { 0,3,13,16,16,15,texture = texture_outer },
      { 0,3,15,3,16,16,texture = texture_outer },
      { 1,3,3,15,15,15,texture = texture_outer },
      { 3,3,0,13,13,1,texture = texture_inner },
      { 3,3,1,15,15,15,texture = texture_outer },
      { 3,3,15,13,13,16,texture = texture_inner },
      { 13,3,0,15,16,16,texture = texture_outer },
      { 15,3,0,16,16,3,texture = texture_outer },
      { 15,3,3,16,13,13,texture = texture_inner },
      { 15,3,15,16,16,16,texture = texture_outer },
      { 0,13,3,16,15,16,texture = texture_outer },
      { 3,13,0,16,15,16,texture = texture_outer },
      { 0,15,3,3,16,16,texture = texture_outer },
      { 3,15,0,16,16,3,texture = texture_outer },
      { 3,15,3,13,16,13,texture = texture_inner },
      { 3,15,15,16,16,16,texture = texture_outer },
      { 15,15,3,16,16,16,texture = texture_outer },
    }
  }
end

return blocklib