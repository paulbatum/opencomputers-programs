local textures = {}

textures = {  
  blank = "opencomputers:White",
  tyrian_dent = "chisel:tyrian/dent",  
  tyrian_tile = "chisel:tyrian/platetiles",
  tyrian_plate = "chisel:tyrian/plate",
  laboratory_largetile = "chisel:laboratory/largetile",
  laboratory_checker = "chisel:laboratory/checkertile",
  laboratory_fuzzy = "chisel:laboratory/fuzzyscreen",
  laboratory_steeltile = "chisel:laboratory/smallsteel-side",
  voidstone_smooth = "chisel:voidstone/smooth",
  diamond_obsidian = "chisel:diamond/terrain-diamond-space-side",  
  ender_flow = "thermalfoundation:fluid/Fluid_Ender_Flow",
  redstone_flow = "thermalfoundation:fluid/Fluid_Redstone_Flow",
  redstone_still = "thermalfoundation:fluid/Fluid_Redstone_Still",
  crafting_unit = "appliedenergistics2:BlockCraftingUnit",
  crafting_unit_fit = "appliedenergistics2:BlockCraftingUnitFit",

  orange = 0xfc6400,
}

textures.tryResolve = function (texture)
  return textures[texture] or texture
end

return textures