-- Set File Name
local ownerId = game:GetService("Workspace").Islands:GetChildren()[1].Owners:GetChildren()[1].value
local ownerName = game:GetService("Players"):GetNameFromUserIdAsync(ownerId)
ownerName = "VendingMachines/" .. ownerName .. ".csv"

-- Verify if Vending Machines folder exist
if not isfolder("VendingMachines") then
    makefolder("VendingMachines")
end

-- Functions
function defMode(descendant)
    local temp = 'Unknown'
    if descendant.Mode.Value == 0 then
        temp = 'Buy'
    elseif descendant.Mode.Value == 1 then
        temp = 'Sell'
    elseif descendant.Mode.Value == 2 then
        temp = 'Offline'
    end
    return temp
end

function defPrice(descendant)
    local temp = 'Unknown'
    if descendant.TransactionPrice ~= nil then
        temp = tostring(descendant.TransactionPrice.value)
    end
    return temp
end

function defName(descendant)
    local name = descendant.SellingContents:GetChildren()[1].DisplayName.value
    if name == "" then
        name = "None"
    end
    return name
end

-- Put all vendingMachines information into a table
local descendants = game:GetService("Workspace"):GetDescendants()
local vendingMachines = {}
for _, descendant in ipairs(descendants) do
    if descendant.Name == "vendingMachine1" or descendant.Name == "vendingMachine" then
        local item = {}
        local success, result = pcall(defMode, descendant)
        if success then
            item.mode = result
        else
            item.mode = 'None'
        end
        local success, result = pcall(defPrice, descendant)
        if success then
            item.price = result
        else
            item.price = 'None'
        end
        local succes, result = pcall(defName, descendant)
        if succes then
            item.name = result
        else
            item.name = 'None'
        end
        table.insert(vendingMachines, item)
    end
end

-- Sort the table
table.sort(vendingMachines, function(a, b)
    if a.name == "None" and b.name ~= "None" then
        return false
    elseif a.name ~= "None" and b.name == "None" then
        return true
    end

    if a.name ~= b.name then
        return a.name < b.name
    end

    if a.mode ~= b.mode then
        return a.mode < b.mode
    end

    if a.price ~= b.price then
        return a.price < b.price
    end
end)

-- Write the final csv File
writefile(ownerName, "Item Name, Selling Mode, Item Price\n")
for _, item in ipairs(vendingMachines) do
    appendfile(ownerName, string.format("%s, %s, %s\n", item.name, item.mode, item.price))
end
