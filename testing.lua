local counter = 1
local input = nil
local invsize = 20 -- gonna make a backpack but ill do that later
local inventory = {}
local sword = {"sword",1,1} -- name,dmg,weight
local shield = {"shield",2,2} --name,dmgstop,weight
local bandage = {"bandage",1,1} --name,hprestore,weight
local items = {"items",sword,shield,bandage} --local item database, too lazy for an actual database
-- sidenote: if lua's lists didnt start on 1 instead of 0, I wouldn't have to make every call be >= 2. >:(

local goblin = {"goblin",10,10,sword} -- name, hp, ap, and items
local demon = {"demon",20,5,sword} -- name, hp, ap, and items
local gelblob = {"gellatinous blob", 100, 1,} -- name, hp, and ap
local enemies = {goblin, demon, gelblob}

local CurrentRoomDimensions = {0,0}
local CurrentRoomMap = {}

local Head = {"Head",35}
local Torso = {"Torso",85}
local Stomach = {"Stomach",70}
local Rarm = {"Right Arm",60}
local Larm = {"Left Arm",60}
local Rleg = {"Right Leg",65}
local Lleg = {"Left Leg",65}
local PlayerFood = 100
local PlayerWater = 100
local HPpercent = 100
local OverallHP = {"OverallHP",HPpercent,PlayerFood,PlayerWater,Head,Torso,Stomach,Rarm,Larm,Rleg,Lleg}
local player = {"player","UnnamedPlayer",OverallHP[2],10,inventory,invsize} -- list name, player chosen name, %value of total hp, and AP
function HPupdate() -- technically player is at 100% until this calc, but whatevz
    HPpercent = ((OverallHP[5][2] + OverallHP[6][2] + OverallHP[7][2] + OverallHP[8][2] + OverallHP[9][2] + OverallHP[10][2] + OverallHP[11][2])/440)*100
    HPpercent = math.floor(HPpercent) --rounding down to nearest whole number, I dont need 8figs of precision
end
HPupdate()

inventory[1] = sword --inv stuff, mainly for testing
inventory[2] = shield
inventory[3] = bandage

-- tangent for those reading this: I put 'input = io.read()' everywhere because if I don't, the next check for input would be the previous line's input.
-- every time I use io.read() it queries the terminal and the program hangs until a reply is given. this is why I didn't make a function for it, because it makes an unnecessary query and its lame >:(
function checkinv()
    print("Do you want to check inventory?")
    input = io.read()
    if input == "check inventory" or input == "check" or input == "y" or input == "yes" then
        for i=1,invsize do
            if inventory[i] == nil then
                inventory[i] = "empty"
            end
            if inventory[i] == "empty" then
                print("slot "..counter.." empty") else
                print("slot "..counter.." contains "..inventory[i][1]) -- inv -> 1st of items list, which is always name!!
            end
            counter = counter + 1
        end
    end
    input = nil
    counter = 1
end
function playerstatus()
    print("Do you want to check status?")
    input = io.read()
        if input == "check status" or input == "check" or input == "y" or input == "yes" then
            print("Status report: "..PlayerFood.."/100 nutrition, "..PlayerWater.."/100 hydration, "..HPpercent.."% health remaining. Would you like a full injury diagnostic?")
            input = nil
            input = io.read()
            if input == "diagnostic" or input == "y" or input == "yes" then
            print("Diagnostic results: \n Head is at "..Head[2].."/35. \n Torso is at "..Torso[2].."/85. \n Stomach is at "..Stomach[2].."/70. \n Right arm is at "..Rarm[2].."/60. \n Left arm is at "..Larm[2].."/60. \n Right leg is at "..Rleg[2].."/65. \n Left leg is at "..Lleg[2].."/65. \n Current status effects: N/A")
            end
        end
    input = nil
end

function makegrid()
    width = math.random(5,40) -- starting parameters to generate
    height = math.random(5,20)
    CurrentRoomDimensions = {width,height}
    roomsizeXbyY = table.concat(CurrentRoomDimensions," ") -- turning width and height tables to a string
    print(roomsizeXbyY)
    counter = 1
    for i=1,height do -- creating map, empty space is a period, its height x width
        CurrentRoomMap[i] = {}
        for j=1,width do
        CurrentRoomMap[i][j] = "." -- /CurrentRoomMap/Height/Width
        end
    end
    for i=1,width do -- walls
        CurrentRoomMap[1][i] = "#" -- first row = #
        CurrentRoomMap[height][i] = "#" -- last row = #
    end
    for j=1,height do
    CurrentRoomMap[j][1] = "#" -- first column = #
    CurrentRoomMap[j][width] = "#" -- last column = #
    end
    for i=1,height do
        widthstring = table.concat(CurrentRoomMap[i],"") -- all characters in a row are printed at once
        print(widthstring)
    end
    if CurrentRoomMap[1][1] ~= nil then
        print(CurrentRoomMap[1][1])
    end
end
-- Tangent #2: God I hate lua and the fact that maxtrixes just... don't exist. It's all tables within tables.
-- lua has no: dictionaries, matrixes, classes, and more! Why do I do this to myself?
--checkinv()
--playerstatus()
makegrid()