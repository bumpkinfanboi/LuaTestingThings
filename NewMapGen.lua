--I'm going to throw some forewords here: This code sucks. I hate it, and I'm the damned fool that wrote it. I moved all the important bits from the old file to this one, because it was easier to integrate. This is the defacto main file now I guess. It's interesting to see as you go down, just how my code changes over time. This was a LOT more work than it looks. I'm definetely not proud of substituting X and Y for 1 and 2, and having the inputs for functions be single-letter variables, but I've got bigger fish to fry than fix that. It works, and that's what matters. 
local tempstorage = {} -- Fun Fact: Tables are just infinite registers :)

local AllMaps = {}
local RoomMaps = {}
local EntityMaps = {}
local ItemMaps = {}
local MapDimensions = {}
local DoorPositions = {}
local ItemsInPlay = {}
local firstmap_ = true
local mapsgenerated_ = 0
local firstturn_ = true
local maptodisplay_

local sword = {"sword",1,2} -- name, dmg, AP cost
local shield = {"shield",2,4} -- name, dmgresist, AP cost
local bandage = {"bandage",5,1} -- name, HPrestore, AP cost
local items = {sword,shield,bandage}
local inventory = {}
local invsize = 20

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
local PlayerPosition = {}
local OverallHP = {"OverallHP",HPpercent,PlayerFood,PlayerWater,Head,Torso,Stomach,Rarm,Larm,Rleg,Lleg}
local player = {"UnnamedPlayer",PlayerPosition,OverallHP[2],10,inventory,invsize} -- list name, player chosen name, %value of total hp, and AP
function HPupdate() -- technically player is at 100% until this calc, but whatevz
    HPpercent = ((OverallHP[5][2] + OverallHP[6][2] + OverallHP[7][2] + OverallHP[8][2] + OverallHP[9][2] + OverallHP[10][2] + OverallHP[11][2])/440)*100
    HPpercent = math.floor(HPpercent) --rounding down to nearest whole number, I dont need 8figs of precision
end
function CheckInv()
    print("Do you want to check inventory?")
    input = io.read()
    if input == "check inventory" or input == "check" or input == "y" or input == "yes" then
        for i=1,invsize do
            if inventory[i] == nil then
                inventory[i] = "empty"
            end
            if inventory[i] == "empty" then
                print("slot "..i.." empty") else
                print("slot "..i.." contains "..inventory[i][1]) -- inv -> 1st of items list, which is always name!!
            end
        end
    end
    input = nil
end
function CheckPlayerStatus()
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

local counter = 1
local displaystring = ""
local displaystring2 = ""
function MakeMapDimensions(x)
    for i=x,x+0 do -- This used to add more maps sequentially, but then it just asks directly what map slot you want, so this shouldn't be a for loop but I am lazy and don't want to rewrite this. Hence the x=x+0.
        MapDimensions[i] = {}
        RoomMaps[i] = {}
        EntityMaps[i] = {}
        ItemMaps[i] = {}
        AllMaps[i] = {i,MapDimensions[i],RoomMaps[i],EntityMaps[i],ItemMaps[i],DoorPositions[i],ItemsInPlay[i]}
        MapDimensions[i][1] = math.random(3, 40) -- x by y or width by height
        MapDimensions[i][2] = math.random(3, 20)
        for j=1,MapDimensions[i][1] do -- all of this is just matrix bullshit :)
            RoomMaps[i][j] = {}
            EntityMaps[i][j] = {}
            ItemMaps[i][j] = {}
            for k=1,MapDimensions[i][2] do -- the period is an empty space
                RoomMaps[i][j][k] = "."
                EntityMaps[i][j][k] = "."
                ItemMaps[i][j][k] = "."
            end
        end
    end
    counter = 1
end
function MakeWallsAndDoors(x,y) -- x reprisents the map selected, y reprisents the amount of doors requested, no I wont fix this mess, it works.
    for i=1,MapDimensions[x][1] do
        RoomMaps[x][i][1] = "#"
        RoomMaps[x][i][MapDimensions[x][2]] = "#"
    end
    for j=1,MapDimensions[x][2] do
        RoomMaps[x][1][j] = "#"
        RoomMaps[x][MapDimensions[x][1]][j] = "#"
    end
    for k=1,y do -- this is so sphagetti but i think it works
        DoorPositions[x] = {}
        DoorPositions[x][k] = {} -- random door making
        DoorPositions[x][k][1] = math.random(1, 4) -- which side of room door should be on
        if DoorPositions[x][k][1] == 1 then -- 1 = up, 2 = right, 3 = down, 4 = left
            DoorPositions[x][k][2] = math.random(2, MapDimensions[x][1]-1)
            DoorPositions[x][k][3] = 1
        elseif DoorPositions[x][k][1] == 2 then
            DoorPositions[x][k][2] = MapDimensions[x][1]
            DoorPositions[x][k][3] = math.random(2, MapDimensions[x][2]-1)
        elseif DoorPositions[x][k][1] == 3 then
            DoorPositions[x][k][2] = math.random(2, MapDimensions[x][1]-1)
            DoorPositions[x][k][3] = MapDimensions[x][2]
        elseif DoorPositions[x][k][1] == 4 then
            DoorPositions[x][k][2] = 1
            DoorPositions[x][k][3] = math.random(2, MapDimensions[x][2]-1)
        end
        RoomMaps[x][DoorPositions[x][k][2]][DoorPositions[x][k][3]] = "D"
    end
end
function RandomItemGeneration(map_request,num_items)
    counter = 1
    ItemsInPlay[map_request] = {}
    while true do
        if ItemsInPlay[map_request][counter] ~= nil then
            counter = counter + 1
            else break
        end
    end
    for i=1,num_items do
        ItemsInPlay[map_request][counter+i] = {}
        ItemsInPlay[map_request][counter+i][1] = math.random(1,3)
        ItemsInPlay[map_request][counter+i][2] = math.random(2,MapDimensions[map_request][1]-1)
        ItemsInPlay[map_request][counter+i][3] = math.random(2,MapDimensions[map_request][2]-1)
        ItemMaps[map_request][ItemsInPlay[map_request][counter+i][2]][ItemsInPlay[map_request][counter+i][3]] = ItemsInPlay[map_request][counter+i][1]
    end
end
function PlayerUpdate() -- add more stuff as needed
    HPupdate()
    if firstmap_ == true and firstturn_ == true then
    firstturn_ = false
    PlayerPosition[1] = 3 -- X
    PlayerPosition[2] = 4 -- Y
    PlayerPosition[3] = 1 -- Map
    AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "P"
    end
    AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "P"
    if AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] == "P" and AllMaps[PlayerPosition[3]][3][PlayerPosition[1]][PlayerPosition[2]] == "D" then
        print("MAKE A NEW MAP (not added yet, soz)") -- Doors
    end
end
function Display(x,y) -- x = map, y = layer DEPRICIATED
    for i=1,MapDimensions[x][1] do
    displaystring = table.concat(AllMaps[x][y+2][i]) -- dont print map number or size
    print(displaystring)
    end
end
function DisplayAllLayers(map_select)
    for i=1,MapDimensions[map_select][1] do
        for j=1,MapDimensions[map_select][2] do
            if AllMaps[map_select][3][i][j] == "." then --if room map tile empty
                if AllMaps[map_select][4][i][j] == "." then -- if no entities on tile
                displaystring2 = displaystring2 .. AllMaps[map_select][5][i][j] -- display item on tile
                else displaystring2 = displaystring2 ..AllMaps[map_select][4][i][j] -- if entity display entity tile
                end
            elseif AllMaps[map_select][3][i][j] == "D" then
                if AllMaps[map_select][4][i][j] == "." and AllMaps[map_select][5][i][j] == "."  then
                displaystring2 = displaystring2 .. AllMaps[map_select][3][i][j]
                elseif AllMaps[map_select][4][i][j] ~= "." then
                displaystring2 = displaystring2 ..AllMaps[map_select][4][i][j] -- if entity display entity tile
                end
            else displaystring2 = displaystring2 .. AllMaps[map_select][3][i][j] -- backup display or displaying walls
            end
        end
        print(displaystring2)
        displaystring2 = "" -- so it doesnt stack
    end
end
function GenerateMap(input_,door_request_,item_request_)
    MakeMapDimensions(input_)
    MakeWallsAndDoors(input_,door_request_)
    RandomItemGeneration(input_,item_request_)
end
function QueryUser()
    while true do
    print("Querying, use help for more information")
    input = io.read()
        if input == "quit" then
        print("Quitting!")
        break
        elseif input == "generatemap" then
            print("generating map, confirm?")
            input = io.read()
            if input == "yes" or input == "y" then
                if mapsgenerated_ > 0 then
                    firstmap_ = false
                end
                mapsgenerated_ = mapsgenerated_ + 1
                print("What mapnumber do you want? Always start with 1, then display 1 before generating another map.")
                input = io.read()
                tempstorage[1] = tonumber(input)
                print("How many doors do you want? (only one and two are tested)")
                input = io.read()
                tempstorage[2] = tonumber(input)
                print("How many items do you want? (only 1-3 are tested)")
                input = io.read()
                tempstorage[3] = tonumber(input)
                GenerateMap(tempstorage[1],tempstorage[2],tempstorage[3])
                print("Map generated!")
                tempstorage = {}
            end
        elseif input == "checkinv" then
            CheckInv()
        elseif input == "checkstatus" then
            CheckPlayerStatus()
        elseif string.match(input, "display") then
            print("displaying")
            PlayerUpdate()
            maptodisplay_ = tonumber(string.match(input, "%d+")) -- %d+ = first number in a string (?)
            DisplayAllLayers(maptodisplay_)
        elseif input == "help" then
            print("Commands: \n quit - Ends the program. \n checkinv - checks player inventory (NOT IMPLEMENTED YET) \n checkstatus - checks player health, hunger, and you can get a detailed overview \n display - displays the map you generated (e.g. display 1). \n generatemap - you can generate another entire map with a configurable amount of doors and items. Use display and select the map number you generated. \n More to come!")
        elseif string.match(input, "move") then
            print("moving")
            if string.match(input, "up") then
                print("moving up")
                AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "." -- this is fine because entities cant be on the same tile, probably. This edits the map and says "Hey! Delete player map tile. And then change the player coordinate to account for moving. Then add the player symbol to the new map coordinate tile. (last part in PlayerUpdate() function)
                PlayerPosition[1] = PlayerPosition[1] - 1 -- although this does suck and I want to make a dedicated function for moving so I can account for edge cases seperately. (e.g. denying movement because other entity on tile)
            elseif string.match(input, "right") then
                print("moving right")
                AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "."
                PlayerPosition[2] = PlayerPosition[2] + 1
            elseif string.match(input, "down") then
                print("moving down")
                AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "."
                PlayerPosition[1] = PlayerPosition[1] + 1
            elseif string.match(input, "left") then
                print("moving left")
                AllMaps[PlayerPosition[3]][4][PlayerPosition[1]][PlayerPosition[2]] = "."
                PlayerPosition[2] = PlayerPosition[2] - 1
            end
            PlayerUpdate()
        end
    end
end
--MakeMapDimensions(2) -- all these functions can be changed, ill make a config file later
--MakeWallsAndDoors(1,1)
--MakeWallsAndDoors(2,1)
--RandomItemGeneration(1,3)
--RandomItemGeneration(2,10)
--PlayerUpdate()
QueryUser()
--Display(1,1)
--Display(1,2)
--Display(1,3)
--DisplayAllLayers(1)


