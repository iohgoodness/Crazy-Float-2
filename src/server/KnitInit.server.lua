local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Red = require(ReplicatedStorage.Packages.Red)

for _,module in pairs(ReplicatedStorage:WaitForChild("Shared"):GetDescendants()) do
    (require(module)).Init()
end
Knit.AddServicesDeep(script.Parent.Services)

Knit.Start():catch(warn)

workspace:SetAttribute("ServerReady", true)

ReplicatedStorage:WaitForChild("RedEvent").OnServerEvent:Connect(function(player)
    player:SetAttribute("ClientReady", true)
end)
