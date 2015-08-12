local os = require("os")
local component = require("component")
local sides = require("sides")
local computer = require("computer")
local robot = require("robot")
local math = require("math")

local sideLength = 37

function circuit()	
	for i=1,4 do			
		for i=1,sideLength do			
			while not robot.forward() do
				os.sleep(3)
			end			
			checkDrop()	
			os.sleep(0.1)							
		end
		robot.turnRight()
	end		
end

function checkDrop()
	if math.random(1,4) == 1 then
		robot.select(math.random(1,16))
		robot.drop(1)
	end
end

while true do
	circuit()
	os.sleep(10)
end

