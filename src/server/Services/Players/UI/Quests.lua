local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LoadQuests = require(ReplicatedStorage.Events.Quests.LoadQuests)
local UpdateQuest = require(ReplicatedStorage.Events.Quests.UpdateQuest):Server()

local Data = ReplicatedStorage:WaitForChild("Data"):FindFirstChild("Quests") and require(ReplicatedStorage.Data.Quests) or {}

local Quests = Knit.CreateService {
    Name = "Quests";
}

function Quests:Reload(player, questType, amount)
    local questData = {}
    local indexes = {}
    while #indexes < amount do
        local index = math.random(1, #Data[questType])
        if not table.find(indexes, index) then
            table.insert(indexes, index)
        end
    end
    for i=1, #indexes do
        local index = indexes[i]
        local dataset = Data[questType][index]
        dataset.Value = 0
        dataset.Goal = math.random(dataset.Amount[1], dataset.Amount[2])
        table.insert(questData, dataset)
    end
    Knit.pd(player).Quests[questType] = questData
    return questData
end

function Quests:KnitStart()
    LoadQuests:SetCallback(function(player, questType)
        if not table.find({"Day", "Week", "Month"}, questType) then
            -- user requested invalid quest type
            return
        end
        local data = Knit.pd(player)
        if data.Quests[questType] then
            -- return saved quests
            return data.Quests[questType]
        else
            -- generate new quests
            return self:Reload(player, questType, 5)
        end
    end)
end

return Quests