local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

Knit.spawnui = function(uiName)
    local newUI = (require(Players.LocalPlayer.PlayerScripts.Client.UI:WaitForChild(uiName))).new()
    return newUI
end

for _,module in pairs(ReplicatedStorage:WaitForChild("Shared"):GetDescendants()) do
    (require(module)).Init()
end
Knit.AddControllersDeep(script.Parent.Controllers)

Knit.Start():catch(warn)

ReplicatedStorage:WaitForChild("RedEvent"):FireServer()