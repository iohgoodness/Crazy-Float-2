local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage.Packages.Red)

return Red.Function("LoadQuests", function(questType : string)
	return questType
end, function(questData)
	return questData
end)