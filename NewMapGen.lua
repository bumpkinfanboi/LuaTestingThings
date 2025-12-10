local AllMaps = {}
local RoomMaps = {}
local EntityMaps = {}
local ItemMaps = {}
local MapDimensions = {}
local DoorPositions = {}
local ItemsInPlay = {}
local sword = {"sword",1,2} -- name, dmg, AP cost
local shield = {"shield",2,4} -- name, dmgresist, AP cost
local bandage = {"bandage",5,1} -- name, HPrestore, AP cost
local items = {sword,shield,bandage}
local counter = 1
local displaystring = ""
local displaystring2 = ""
function MakeMapDimensions(x)
    while true do -- checking the next free spot in the AllMaps table and setting that slot as counter value
        if AllMaps[counter] ~= nil then
            counter = counter + 1
        else break
        end
    end
    for i=counter,counter+x do -- if x>1 then this just adds more sequentially, like 2,3,4 instead of 1,2,3 if 1 is alr taken
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
function MakeWallsAndDoors(x,y) -- x reprisents the map selected, y reprisents the amount of doors requested
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
function Display(x,y) -- x = map, y = layer
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
            else displaystring2 = displaystring2 .. AllMaps[map_select][3][i][j] -- if floor tile (door or map) display that
            end
        end
        print(displaystring2)
        displaystring2 = "" -- so it doesnt stack
    end
end
MakeMapDimensions(2)
MakeWallsAndDoors(1,1)
MakeWallsAndDoors(2,1)
RandomItemGeneration(1,3)
RandomItemGeneration(2,10)
Display(1,1) 
--Display(1,2)
Display(1,3)
DisplayAllLayers(2)