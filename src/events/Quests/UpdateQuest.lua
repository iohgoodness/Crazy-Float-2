local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Event("UpdateQuest", function(questType, index, progress)
	return questType, index, progress
end)