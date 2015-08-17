local component = require("component")
local printer = component.printer3d

package.loaded.blocklib = nil
package.loaded.textures = nil
local blocklib = require("blocklib")
local textures = require("textures")

function waitForPrinter()
  while printer.status() == "busy" do os.sleep(5) end  
end

local enderInfusedTyrian = blocklib.patterns.inset_block_3(textures.tyrian_dent, textures.ender_flow)
enderInfusedTyrian.label = "Ender Infused Tyrian"

local redstoneInfusedTyrian = blocklib.patterns.inset_block_3(textures.tyrian_dent, textures.redstone_flow)
redstoneInfusedTyrian.label = "Redstone Infused Tyrian"

local hollowTyrianTiles = blocklib.patterns.hollow_block_4(textures.tyrian_tile)
local obsidianEnderPipe = blocklib.patterns.inner_pipe_h("obsidian",textures.ender_flow)
local reinforcedEnderPipe = blocklib.compose(hollowTyrianTiles, obsidianEnderPipe)
reinforcedEnderPipe.label = "Reinforced Ender Pipe"

local enderInfusedTyrianTiles = blocklib.patterns.inset3d_block_4(textures.tyrian_tile, textures.ender_flow)
enderInfusedTyrianTiles.label = "Ender Tyrian"

local tyrianDragonTiles = blocklib.patterns.inset_block_4(textures.tyrian_tile, "dragon_egg")
tyrianDragonTiles.label = "Tyrian Dragon Tiles"

local labTyrianInsetTiles = blocklib.patterns.inset_block_4(textures.laboratory_largetile, textures.tyrian_tile)
labTyrianInsetTiles.label = "Laboratory Tile with Tyrian"

local labTyrianCheckerTiles = blocklib.patterns.inset_block_4(textures.laboratory_checker, textures.tyrian_tile)
labTyrianCheckerTiles.label = "Laboratory Tyrian Checker"

blocklib.print(tyrianDragonTiles, 19)
waitForPrinter()

blocklib.print(labTyrianCheckerTiles, 32)
waitForPrinter()

