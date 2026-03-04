require("DatabaseTesting")
Fetch = nil
function Request(input, filename)
    Fetch = input
    if filename == "DatabaseTesting" or filename == "DT" then
        return require("DatabaseTesting")
    elseif filename == "NewNewMapGen" or filename == "NNMG" then
        return require("NewNewMapGen")
    else print("Failure to find!")
    end
end
--print(Request("player").status.hppercent) -- LETS GOOOO IT WORKS!!
