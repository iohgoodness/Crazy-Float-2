local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Event("UpdateValues", function(coins, gems, xp, level)
	return coins, gems, xp, level
end)