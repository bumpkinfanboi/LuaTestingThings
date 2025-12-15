local input = ""
local number
input = io.read()
number = tonumber(string.match(input, "%d+"))
print(number) 
for i=1,mapandnumofdoor_[2] do
    if PlayerPosition[1] == DoorPositions[PlayerPosition[3]][i][2] and PlayerPosition == DoorPositions[PlayerPosition[3]][i][3] then