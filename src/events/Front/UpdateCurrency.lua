local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Event("UpdateValues", function(coins : number, gems : number, xp : number, level : number)
	return coins, gems, xp, level
end)