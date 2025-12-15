local input = ""
local number
input = io.read()
number = tonumber(string.match(input, "%d+"))
print(number) 