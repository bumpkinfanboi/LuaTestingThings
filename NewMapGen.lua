local AllMaps = {}
local RoomMaps = {}
local EntityMaps = {}
local ItemMaps = {}
local MapDimensions = {}
local counter = 1
function MakeMapDimensions(x)
    while true do -- checking the next free spot in the AllMaps table and setting that slot as counter value
        if AllMaps[counter] ~= nil then
            counter = counter + 1
        else break
        end
    end
    for i=counter,counter+x do -- if x>1 then this just adds more sequentially, like 2,3,4 instead of 1,2,3 if 1 is alr taken
        AllMaps[i] = {i,MapDimensions[i],RoomMaps[i],EntityMaps[i],ItemMaps[i]}
        MapDimensions[i][1] = math.random(1,40) -- x by y or width by height
        MapDimensions[i][2] = math.random(1,20)
        for j=1,MapDimensions[i][1] do -- all of this is just matrix bullshit :)
            RoomMaps[i][j] = {}
            EntityMaps[i][j] = {}
            ItemMaps[i][j] = {}
            for k=1,MapDimensions[i][2] do
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
        RoomMaps[x][MapDimensions[x][1]][1] = "#"
    end
end
MakeMapDimensions(1)
MakeWallsAndDoors(1,0)