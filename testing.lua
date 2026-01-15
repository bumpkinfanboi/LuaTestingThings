local array = {"a","b","c"}
array["last"] = "end"
for key,value in pairs(array) do print(key,value) end -- ipairs = pairs but integers only i think
-- "Hey, for array[key] = value, can you get them in pairs(array) for me? And can you then run this print command the same amount of times as all the stuff in this array? oh and stop at the first nil, i think."
local function stuff(...) -- tripledot means variable number of arguements, think something like (1,2,3,banjo,kazooie,11,4,) or something like that.
    local arg = {...} -- making a table for all the shit, i have to do this manually now because it was removed from being automagic in lua 5.1. Lame!
    for i,v in ipairs(arg) do -- so for every key in the arg table (which, remember, is all the function inputs), do this.
        print("stuff" .. " indexnumber is: " .. i .. " and value is: " .. v) -- i=key, v= value 
    end
end
stuff("iamisnane",2,3,"gub",5) -- any inputs work! except nil, shut up.