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

blocklib.compose = function(a, b)
  local result = {
    shapes = {}
  }
  for _,v in pairs(a.shapes) do 
    table.insert(result.shapes, v)
  end  
  for _,v in pairs(b.shapes) do 
    table.insert(result.shapes, v)
  end  
  return result
end

blocklib.patterns = {}

blocklib.patterns.block = function(texture)
  return {    
    shapes = {{0,0,0,16,16,16, texture=texture}}
  }
end

function inset_block(x)
  return function (texture_outer, texture_inner) 
    return {
      shapes = {
        { 0,0,0,x,16,x,texture = texture_outer },
        { 0,0,16-x,x,16,16,texture = texture_outer },
        { 16-x,0,0,16,16,x,texture = texture_outer },
        { 16-x,0,16-x,16,16,16,texture = texture_outer },
        { 0,0,x,x,x,16-x,texture = texture_outer },
        { x,0,0,16-x,x,x,texture = texture_outer },
        { x,0,16-x,16-x,x,16,texture = texture_outer },
        { 16-x,0,x,16,x,16-x,texture = texture_outer },
        { 0,16-x,x,x,16,16-x,texture = texture_outer },
        { x,16-x,0,16-x,16,x,texture = texture_outer },
        { x,16-x,16-x,16-x,16,16,texture = texture_outer },
        { 16-x,16-x,x,16,16,16-x,texture = texture_outer },
        { x,0,x,16-x,x,16-x,texture = texture_inner },
        { 0,x,x,x,16-x,16-x,texture = texture_inner },
        { x,x,0,16-x,16-x,x,texture = texture_inner },
        { x,x,16-x,16-x,16-x,16,texture = texture_inner },
        { 16-x,x,x,16,16-x,16-x,texture = texture_inner },
        { x,16-x,x,16-x,16,16-x,texture = texture_inner },
      }
    }
  end
end

blocklib.patterns.inset_block_2 = inset_block(2)
blocklib.patterns.inset_block_3 = inset_block(3)
blocklib.patterns.inset_block_4 = inset_block(4)
blocklib.patterns.inset_block_5 = inset_block(5)

function inset3d_block(x)
  return function (texture_outer, texture_inner) 
    return {
      shapes = {
        { 0,0,0,x,16,x,texture = texture_outer },
        { 0,0,16-x,x,16,16,texture = texture_outer },
        { 16-x,0,0,16,16,x,texture = texture_outer },
        { 16-x,0,16-x,16,16,16,texture = texture_outer },
        { 0,0,x,x,x,16-x,texture = texture_outer },
        { x,0,0,16-x,x,x,texture = texture_outer },
        { x,0,16-x,16-x,x,16,texture = texture_outer },
        { 16-x,0,x,16,x,16-x,texture = texture_outer },
        { 0,16-x,x,x,16,16-x,texture = texture_outer },
        { x,16-x,0,16-x,16,x,texture = texture_outer },
        { x,16-x,16-x,16-x,16,16,texture = texture_outer },
        { 16-x,16-x,x,16,16,16-x,texture = texture_outer },
        { x,x,x,16-x,16-x,16-x,texture = texture_inner },        
      }
    }
  end
end

blocklib.patterns.inset3d_block_2 = inset3d_block(2)
blocklib.patterns.inset3d_block_3 = inset3d_block(3)
blocklib.patterns.inset3d_block_4 = inset3d_block(4)
blocklib.patterns.inset3d_block_5 = inset3d_block(5)

function hollow_block(x)
  return function (texture_outer) 
    return {
      shapes = {
        { 0,0,0,x,16,x,texture = texture_outer },
        { 0,0,16-x,x,16,16,texture = texture_outer },
        { 16-x,0,0,16,16,x,texture = texture_outer },
        { 16-x,0,16-x,16,16,16,texture = texture_outer },
        { 0,0,x,x,x,16-x,texture = texture_outer },
        { x,0,0,16-x,x,x,texture = texture_outer },
        { x,0,16-x,16-x,x,16,texture = texture_outer },
        { 16-x,0,x,16,x,16-x,texture = texture_outer },
        { 0,16-x,x,x,16,16-x,texture = texture_outer },
        { x,16-x,0,16-x,16,x,texture = texture_outer },
        { x,16-x,16-x,16-x,16,16,texture = texture_outer },
        { 16-x,16-x,x,16,16,16-x,texture = texture_outer }
      }
    }
  end
end

blocklib.patterns.hollow_block_2 = hollow_block(2)
blocklib.patterns.hollow_block_3 = hollow_block(3)
blocklib.patterns.hollow_block_4 = hollow_block(4)
blocklib.patterns.hollow_block_5 = hollow_block(5)

blocklib.patterns.checker_block = function(texture1, texture2)
  return {
    shapes = {
      { 0,0,0,8,8,8,texture = texture1 },
      { 0,0,8,8,8,16,texture = texture2 },
      { 8,0,0,16,8,8,texture = texture2 },
      { 8,0,8,16,8,16,texture = texture1 },
      { 0,8,0,8,16,8,texture = texture2 },
      { 0,8,8,8,16,16,texture = texture1 },
      { 8,8,0,16,16,8,texture = texture1 },
      { 8,8,8,16,16,16,texture = texture2 },
    }
  }
end

blocklib.patterns.inner_pipe = function(texture_outer, texture_inner) 
  return {    
    shapes = {
      { 6,0,6,10,16,10,texture = texture_inner },
      { 5,0,5,6,16,6,texture = texture_outer },
      { 5,0,6,6,1,7,texture = texture_outer },
      { 5,0,9,6,1,11,texture = texture_outer },
      { 6,0,5,7,1,6,texture = texture_outer },    
      { 6,0,10,7,1,11,texture = texture_outer },
      { 9,0,5,11,1,6,texture = texture_outer },
      { 9,0,10,11,1,11,texture = texture_outer },
      { 10,0,6,11,1,7,texture = texture_outer },
      { 10,0,9,11,1,11,texture = texture_outer },
      { 5,1,10,6,16,11,texture = texture_outer },
      { 10,1,5,11,16,6,texture = texture_outer },
      { 10,1,10,11,16,11,texture = texture_outer },
      { 5,5,6,6,6,7,texture = texture_outer },
      { 5,5,9,6,6,11,texture = texture_outer },
      { 6,5,5,7,6,6,texture = texture_outer },
      { 6,5,10,7,6,11,texture = texture_outer },
      { 9,5,5,11,6,6,texture = texture_outer },
      { 9,5,10,11,6,11,texture = texture_outer },
      { 10,5,6,11,6,7,texture = texture_outer },
      { 10,5,9,11,6,11,texture = texture_outer },
      { 5,10,6,6,11,7,texture = texture_outer },
      { 5,10,9,6,11,11,texture = texture_outer },
      { 6,10,5,7,11,6,texture = texture_outer },
      { 6,10,10,7,11,11,texture = texture_outer },
      { 9,10,5,11,11,6,texture = texture_outer },
      { 9,10,10,11,11,11,texture = texture_outer },
      { 10,10,6,11,11,7,texture = texture_outer },
      { 10,10,9,11,11,11,texture = texture_outer },
      { 5,15,6,6,16,7,texture = texture_outer },
      { 5,15,9,6,16,11,texture = texture_outer },
      { 6,15,5,7,16,6,texture = texture_outer },
      { 6,15,10,7,16,11,texture = texture_outer },
      { 9,15,5,11,16,6,texture = texture_outer },
      { 9,15,10,11,16,11,texture = texture_outer },
      { 10,15,6,11,16,7,texture = texture_outer },
      { 10,15,9,11,16,11,texture = texture_outer },
    }
  }
end

blocklib.patterns.alphabet_a = function(texture, tint)
  return {
    label = "A",
    shapes = {
      { 4,0,12,6,14,16,texture = texture, tint = tint },
      { 10,0,12,12,14,16,texture = texture, tint = tint },
      { 6,6,12,12,8,16,texture = texture, tint = tint },
      { 6,12,12,12,14,16,texture = texture, tint = tint },
    }
  }
end

blocklib.patterns.alphabet_b = function(texture, tint)
  return {
    label = "B",
    shapes = {
      { 4,0,12,6,14,16,texture = texture, tint = tint },
      { 6,0,12,11,2,16,texture = texture, tint = tint },
      { 11,1,12,12,13,16,texture = texture, tint = tint },
      { 10,2,12,12,13,16,texture = texture, tint = tint },
      { 6,6,12,12,8,16,texture = texture, tint = tint },
      { 6,12,12,11,14,16,texture = texture, tint = tint },
    }
  }
end

blocklib.patterns.alphabet_l = function(texture, tint)
  return {
    label = "L",
    shapes = {
      { 4,0,12,6,14,16,texture = texture, tint = tint },
      { 6,0,12,12,2,16,texture = texture, tint = tint },      
    }
  }
end

blocklib.patterns.alphabet_p = function(texture, tint)
  return {
    label = "P",
    shapes = {
      { 4,0,12,6,14,16,texture = texture, tint = tint },
      { 6,6,12,12,8,16,texture = texture, tint = tint },
      { 10,8,12,12,14,16,texture = texture, tint = tint },
      { 6,12,12,12,14,16,texture = texture, tint = tint },
    }
  }
end

blocklib.patterns.alphabet_s = function(texture, tint)
  return {
    label = "S",
    shapes = {      
      { 4,0,12,12,2,16,texture = texture, tint = tint },
      { 10,1,12,12,8,16,texture = texture, tint = tint },
      { 4,6,12,12,8,16,texture = texture, tint = tint },
      { 4,8,12,6,14,16,texture = texture, tint = tint },
      { 6,12,12,12,14,16,texture = texture, tint = tint },
    }
  }
end

blocklib.patterns.alphabet_u = function(texture, tint)
  return {
    label = "U",
    shapes = {      
      { 4,0,12,6,14,16,texture = texture, tint = tint },
      { 6,0,12,12,2,16,texture = texture, tint = tint },
      { 10,2,12,12,14,16,texture = texture, tint = tint },
    }
  }
end

return blocklib