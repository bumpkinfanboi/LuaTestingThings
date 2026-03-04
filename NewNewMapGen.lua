require("DatabaseTesting") -- already sphagetti
Fetch = "roomtypes" 
local roomtypes = dofile("DatabaseTesting.lua")
Fetch = "AllMaps"
local AllMaps = dofile("DatabaseTesting.lua")
function makenewmap(mapnumber,numberofdoors,numberofitems,typeofroom)
    if AllMaps[mapnumber] == nil then
        AllMaps[mapnumber] = {
            sizex = math.random(roomtypes[typeofroom].X[1],roomtypes[typeofroom].X[2]);
            sizey = math.random(roomtypes[typeofroom].Y[1],roomtypes[typeofroom].Y[2]);
            roomlayer = {};
            itemlayer = {};
            entitylayer = {};
        }
        print(AllMaps[mapnumber].sizex)
        print(AllMaps[mapnumber].sizey)
        for i=1,AllMaps[mapnumber].sizex do
            AllMaps[mapnumber].roomlayer[i] = {}
            AllMaps[mapnumber].itemlayer[i] = {}
            AllMaps[mapnumber].entitylayer[i] = {}
            for j=1,AllMaps[mapnumber].sizey do
            AllMaps[mapnumber].roomlayer[i][j] = "."
            AllMaps[mapnumber].itemlayer[i][j] = "."
            AllMaps[mapnumber].entitylayer[i][j] = "."
            end
        end
    end
    wallsanddoors(mapnumber, numberofdoors)
    --AllMaps[mapnumber].roomlayer[1][1] = "A"
    AllMaps[mapnumber].roomlayer[3][2] = "P"
    --AllMaps[mapnumber].roomlayer[1][AllMaps[mapnumber].sizey] = "L"
end
local displaystring = ""
local doors = {}
function wallsanddoors(mapnumber, numberofdoors)
    for i=1, AllMaps[mapnumber].sizex do
        AllMaps[mapnumber].roomlayer[i][1] = "#"
        AllMaps[mapnumber].roomlayer[i][AllMaps[mapnumber].sizey] = "#"
    end
    for j=1, AllMaps[mapnumber].sizey do
        AllMaps[mapnumber].roomlayer[1][j] = "#"
        AllMaps[mapnumber].roomlayer[AllMaps[mapnumber].sizex][j] = "#"
    end
    for k=1, numberofdoors do -- finish later, make it stored somewhere in database
        doors[k] = {
            attachedwall = math.random(1,4)
        }
    end
end
function display(mapnumber)
    for i=1,AllMaps[mapnumber].sizey do
        for j=1,AllMaps[mapnumber].sizex do
            displaystring = displaystring .. AllMaps[mapnumber].roomlayer[j][i]
        end
        print(displaystring)
        displaystring = ""
    end
end
makenewmap(1,1,1,"normalroom")
display(1)