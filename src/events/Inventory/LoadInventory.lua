local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Function("LoadInventory", function(inventoryCategory : string)
	return inventoryCategory
end, function(inventoryData)
	return inventoryData
end)