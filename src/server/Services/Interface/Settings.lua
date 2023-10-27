-- Timestamp // 10/24/2023 23:20:46 MNT
-- Author // @iohgoodness
-- Description // Settings UI

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = Knit.CreateService {
    Name = "Settings",
    Client = {
        Pull = Knit.CreateSignal();
    },
}

function Settings.Client:Push(player, key, value)
    if Knit.pd(player).Settings[key]==nil then return end
    if typeof(value) ~= typeof(Knit.pd(player).Settings[key]) then return end
    Knit.pd(player).Settings[key] = value
end

function Settings:PlayerAdded(player)
    self.Client.Pull:Fire(player, Knit.pd(player).Settings)
end

return Settings
