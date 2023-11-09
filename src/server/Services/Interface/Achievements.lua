-- Timestamp // 11/08/2023 19:57:53 MNT
-- Author // @iohgoodness
-- Description // Achievements service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Achievements = Knit.CreateService {
    Name = "Achievements",
    Client = {
        PushValues = Knit.CreateSignal();
    },
}

local cfg = Knit.cfg.Achievements

function Achievements.Client:Claim(player)

end

function Achievements:Earn(player, valueType, valueAmount)
    Knit.pd(player).Achievements[valueType] = Knit.pd(player).Achievements[valueType] and Knit.pd(player).Achievements[valueType] + valueAmount or valueAmount
    self.Client.PushValues:Fire(player, Knit.pd(player).Achievements)
end

function Achievements:PlayerAdded(player)
    self.Client.PushValues:Fire(player, Knit.pd(player).Achievements)
end

return Achievements
