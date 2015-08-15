local textures = {}

textures = {
	gold_block = "gold_block",
	tyrian_dent = "chisel:tyrian/dent",
	ender_flow = "thermalfoundation:fluid/Fluid_Ender_Flow",
	redstone_flow = "thermalfoundation:fluid/Fluid_Redstone_Flow",
	redstone_still = "thermalfoundation:fluid/Fluid_Redstone_Still",
}

textures.tryResolve = function (texture)
	return textures[texture] or texture
end

return textures