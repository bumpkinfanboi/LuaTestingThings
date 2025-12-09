local AllMaps = {}
local RoomMaps = {}
local EntityMaps = {}
local ItemMaps = {}
local MapDimensions = {}
local DoorPositions = {}
local counter = 1
function MakeMapDimensions(x)
    while true do -- checking the next free spot in the AllMaps table and setting that slot as counter value
        if AllMaps[counter] ~= nil then
            counter = counter + 1
        else break
        end
    end
    for i=counter,counter+x do -- if x>1 then this just adds more sequentially, like 2,3,4 instead of 1,2,3 if 1 is alr taken
        AllMaps[i] = {i,MapDimensions[i],RoomMaps[i],EntityMaps[i],ItemMaps[i],DoorPositions[i]}
        MapDimensions[i][1] = math.random(1,40) -- x by y or width by height
        MapDimensions[i][2] = math.random(1,20)
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
        DoorPositions[x][k] = {} -- random door making
        DoorPositions[x][k][1] = math.random(1,4) -- which side of room door should be on
        if DoorPositions[x][k][1] == 1 then -- 1 = up, 2 = right, 3 = down, 4 = left
            DoorPositions[x][k][2] = math.random(2,MapDimensions[x][1]-1)
            DoorPositions[x][k][3] = 1
        elseif DoorPositions[x][k][1] == 2 then
            DoorPositions[x][k][2] = MapDimensions[x][1]
            DoorPositions[x][k][3] = math.random(2,MakeMapDimensions[x][2]-1)
        elseif DoorPositions[x][k][1] == 3 then
            DoorPositions[x][k][2] = math.random(2,MapDimensions[x][1]-1)
            DoorPositions[x][k][3] = MapDimensions[x][2]
        elseif DoorPositions[x][k][1] == 4 then
            DoorPositions[x][k][2] = 1
            DoorPositions[x][k][3] = math.random(2,MapDimensions[x][2]-1)
        end
        RoomMaps[x][DoorPositions[x][k][2]][DoorPositions[x][k][3]] = "D"
    end
end
MakeMapDimensions(1)
MakeWallsAndDoors(1,0)