local blocklib = require("./blocklib")
local textures = require("./textures")

local enderInfusedTyrian = blocklib.makeDualBlock10(textures.tyrian_dent, textures.ender_flow, "Ender Infused Tyrian")
local redstoneInfusedTyrian = blocklib.makeDualBlock10(textures.tyrian_dent, textures.redstone_flow, "Redstone Infused Tyrian")
blocklib.print(enderInfusedTyrian, 1)
blocklib.print(redstoneInfusedTyrian, 1)