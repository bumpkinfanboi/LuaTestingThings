local input = nil
function queryingusertesting()
    while true do
        print("testing query")
        input = io.read()
        if string.match(input, "quit") then
            print("quitting")
            break
        elseif string.match(input, "generatemap") then -- if you find key string (like a command)
            --print(string.find(input, "(%d+) (%d+) (%d+)")) -- check for numbers in this pattern (if more than 3, use first 3, spaces included)
            _, _, tempstorage[1], tempstorage[2], tempstorage[3] = string.find(input, "(%d+) (%d+) (%d+)") -- first two are start and end locations of pattern, just dummy remove first two with _ variable, then save other three as d, m, and y.
            --print(tempstorage[2]) -- print a specific variable saved
        else print("failure!")
        end
    end
end
queryingusertesting()