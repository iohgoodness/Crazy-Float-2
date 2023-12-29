local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LoadQuests = require(ReplicatedStorage.Events.Quests.LoadQuests)
local UpdateQuest = require(ReplicatedStorage.Events.Quests.UpdateQuest):Server()

local Data = ReplicatedStorage:WaitForChild("Data"):FindFirstChild("Quests") and require(ReplicatedStorage.Data.Quests) or {}

local Quests = Knit.CreateService {
    Name = "Quests";
}

function Quests:Reload()

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
            local questData = {}
            for _,dataset in ipairs(Data[questType]) do
                dataset.Value = 0
                dataset.Goal = math.random(dataset.Amount[1], dataset.Amount[2])
                table.insert(questData, dataset)
            end
            Knit.pd(player).Quests[questType] = questData
            return questData
        end
    end) 
end

return Quests