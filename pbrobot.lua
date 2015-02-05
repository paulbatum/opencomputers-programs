local os = require("os")
local component = require("component")
local sides = require("sides")
local computer = require("computer")
local robot = require("robot")
--local _ = require('moses')

-------------------------------------
local lastRobotSlot = 16
local rangeThreshold = 0.9
local minY = 18
local homeY = 50
local lowEnergy = 5000
local robotSide = sides.back
local enderChestName = "EnderStorage:enderChest"

local inv = component.inventory_controller
local gen = component.generator
local nav = component.navigation

if not inv then
    error("no inventory controller found")
end

if not gen then
    error("no generator found")
end

if not nav then
    error("no navigation controller found")    
end

local pbrobot = {}
local workQueue = {}
local commands = {
    mine = robot.swing,
    mineForward = function()
        robot.swing()
        return robot.forward()
    end,
    mineDown = function()
        robot.swingDown()
        return robot.down()
    end,
    turnLeft = robot.turnLeft,
    turnRight = robot.turnRight,
}

function pbrobot.queueLayers(layerSize, count)
    for i=1,count do
        pbrobot.queueMineLayerWork(layerSize)
        pbrobot.queueWork("mineDown", 3)        
    end    
end
    

function pbrobot.queueMineLayerWork(layerSize)    

    iterationRight = function()
        pbrobot.queueWork("mineForward", layerSize-1)
        pbrobot.queueWork("turnRight")
        pbrobot.queueWork("mineForward", 3)
        pbrobot.queueWork("turnRight")
    end

    iterationLeft = function()
        pbrobot.queueWork("mineForward", layerSize-1)
        pbrobot.queueWork("turnLeft")
        pbrobot.queueWork("mineForward", 3)
        pbrobot.queueWork("turnLeft")
    end

    for i=1,math.floor(layerSize/8) + 1 do
        iterationRight()
        iterationLeft()    
    end    
    
    pbrobot.queueWork("turnLeft")
    pbrobot.queueWork("mineForward", layerSize+2)
    pbrobot.queueWork("turnRight")
end

function pbrobot.queueWork(command, iterations)
    local work = {
        command = command,
        iterations = iterations or 1,   
        retry = 3 
    }
    work.execute = function()
        if commands[work.command]() then
            work.iterations = work.iterations - 1
        else
            work.retry = work.retry - 1
            if work.retry == 0 then
                work.iterations = 0
            end
        end
    end
    table.insert(workQueue, work)
end

function pbrobot.getWork()
    return function()
        local work = workQueue[1]
        while work do
            if work.iterations > 0 then    
                return work.execute
            else
                table.remove(workQueue, 1)    
                work = workQueue[1]
            end
        end
        return nil
    end
end

function pbrobot.doWork()
    local cycle = 0
    for work in pbrobot.getWork() do        
        work()
        cycle = cycle + 1
        if cycle == 10 then
            print('maintenance check..')
            cycle = 0
            if pbrobot.isFull() or pbrobot.isGeneratorEmpty() then                
                pbrobot.unloadAndRefuel()
            end
            if pbrobot.isEnergyLow() or pbrobot.tooFarFromHome() then
                pbrobot.goHome()
                break
            end
        end        
        os.sleep(0.1)
    end
end

function pbrobot.goHome()
    print("going home")    
    local x,y,z = nav.getPosition()
    while y < homeY do
    x,y,z = nav.getPosition()
        robot.swingUp()
        robot.up()
    end
end

function pbrobot.tooFarFromHome()
    local range = nav.getRange()
    local x,y,z = nav.getPosition()
    local max = math.max(math.abs(x), math.abs(z))
    return (max > range * rangeThreshold) or (y < minY)
end

function pbrobot.isEnergyLow()
    return computer.energy() < lowEnergy
end

function pbrobot.isGeneratorEmpty()
    return gen.count() < 1
end

function pbrobot.isFull()
    return pbrobot.findEmptySlot(robotSide) == -1
end

function pbrobot.findEnder()
    for slot in pbrobot.ownSlots() do
        if slot.name == enderChestName then
            return slot.index
        end
    end
end

function pbrobot.placeEnder()
    local enderSlot = pbrobot.findEnder()
    if enderSlot then
        print("found ender chest in slot "..enderSlot)
        robot.select(enderSlot)
        return robot.place()
    else
        error("no ender chest found")
    end
end

function pbrobot.unloadAndRefuel()
    robot.swing()
    if pbrobot.placeEnder() then        
        pbrobot.fillInventory(sides.front)    
        pbrobot.refuel(sides.front)
        robot.select(1)    
        robot.swing()
    end    
    os.sleep(1)
end

function pbrobot.refuel(side)    
    local emptySlot = pbrobot.findEmptySlot(robotSide)
    robot.select(emptySlot)

    local coalIndex = pbrobot.findItem(side, "minecraft:coal")
    if coalIndex >= 1 then
        inv.suckFromSlot(side, coalIndex)
        gen.insert()
    else
        print("no coal found")
    end
end

function pbrobot.fillInventory(side)    
    for robotSlot in pbrobot.ownSlots() do
        if not robotSlot.empty then            
            local targetSlot = pbrobot.findEmptySlot(side)
            if targetSlot >= 1 then
                robot.select(robotSlot.index)
                inv.dropIntoSlot(side, targetSlot)
            end
        end
    end
end

function pbrobot.findItem(side, name)
    for slot in pbrobot.slots(side) do
        if slot.name == name then
            return slot.index
        end
    end
    return -1
end

function pbrobot.findEmptySlot(side)
    for slot in pbrobot.slots(side) do
        if slot.empty then
            return slot.index
        end
    end
    return -1
end

function pbrobot.ownSlots()
    return pbrobot.slots(robotSide)
end

function pbrobot.slots(side)
    local currentSlot = 0
    local lastSlot = 0
    
    if side == robotSide then
        lastSlot = lastRobotSlot
    else 
        lastSlot = inv.getInventorySize(side)
    end

    return function()
        currentSlot = currentSlot + 1
        if currentSlot > lastSlot then
            return nil
        end

        local result = {
            index = currentSlot,
            contents = inv.getStackInSlot(side, currentSlot)
        }        
        result.empty = result.contents == nil 
        
        if result.contents then
            result.name = result.contents.name
        end
        
        return result
    end
end


--pbrobot.queueLayers(2)
--pbrobot.doWork()

return pbrobot
-- pastebin run XNAQz7Ee
-- pastebin get -f XNAQz7Ee pbrobot.lua