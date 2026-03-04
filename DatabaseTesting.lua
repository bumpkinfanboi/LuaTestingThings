local roomtypes = {
    normalroom = {
        X = {5,20};
        Y = {5,20};
    };
    hallwayroom = {
        X = {5,10};
        Y = {10,30};
    }
}
local player = {
    status = {
        saturation = 100;
        hydration = 100;
        effects = {};
        bodyparts = {
            lleg = 65;
            rleg = 65;
            thorax = 85;
            stomach = 70;
            larm = 60;
            rarm = 60;
            head = 35;
        };
    };
    inventory = {
        size = 20;
        equipped = {};
    };
    position = {
        map = nil;
        playerx = 2;
        playery = 2;
    };
}
for i=1,player.inventory.size do
    player.inventory[i] = {}
end
function playerupdate()
    player.status.hppercent = math.floor((player.status.bodyparts.lleg + player.status.bodyparts.rleg + player.status.bodyparts.thorax + player.status.bodyparts.stomach + player.status.bodyparts.head + player.status.bodyparts.larm + player.status.bodyparts.rarm)/440*100)
    print("functionrunning")
end
playerupdate()
if Fetch == "roomtypes" then
    return roomtypes -- these return(s) is for whatever calls this file 
elseif Fetch == "player" then
    return player
end
local database = {
    player = player;
    roomtypes = roomtypes;
    AllMaps = {}

}