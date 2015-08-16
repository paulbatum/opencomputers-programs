local textures = {}

textures = {  
  tyrian_dent = "chisel:tyrian/dent",  
  tyrian_tiles = "chisel:tyrian/platetiles",
  tyrian_plate = "chisel:tyrian/plate",
  laboratory_largetile = "chisel:laboratory/largetile",
  laboratory_checker = "chisel:laboratory/checkertile",
  laboratory_fuzzy = "chisel:laboratory/fuzzyscreen",
  diamond_obsidian = "chisel:diamond/terrain-diamond-space-side",  
  ender_flow = "thermalfoundation:fluid/Fluid_Ender_Flow",
  redstone_flow = "thermalfoundation:fluid/Fluid_Redstone_Flow",
  redstone_still = "thermalfoundation:fluid/Fluid_Redstone_Still",
}

textures.tryResolve = function (texture)
  return textures[texture] or texture
end

return textures