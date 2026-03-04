local allmapsstartingdata = {}
local itemstatdatabase = {
    sword = {
        Name = "sword";
        Damage = 5;
        AP = 1;
        Weight = 3;
    };
    item = {
        Name = "item"
    }
}
local function fixmyproblems(combinedoutput) -- only here to clean up the output of Search(), making it from a table of the outputs to
    for i,v in pairs(combinedoutput) do
        -- return combinedoutput[1], combinedoutput[2], etc until returning nil
    end
end
function Search(...)
    local arg = {...}
    local combinedoutput = {}
    for i,v in pairs(arg) do
        for j,k in pairs(itemstatdatabase) do
            if v == itemstatdatabase[j].Name then
                combinedoutput[i] = itemstatdatabase[j]
            end
        end
    end
    return fixmyproblems(combinedoutput[i])
end
print(Search("sword", "item")[1].Name)