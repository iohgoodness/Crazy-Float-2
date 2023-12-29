local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

Knit.openui = {}

Knit.spawn = function(uiName)
    if not Knit.openui[uiName] then
        Knit.openui[uiName] = (require(Players.LocalPlayer.PlayerScripts.Client.UI:WaitForChild(uiName))).new(uiName)
    end
end

Knit.toggle = function(uiName, data)
    if not Knit.openui[uiName] then
        Knit.openui[uiName] = (require(Players.LocalPlayer.PlayerScripts.Client.UI:WaitForChild(uiName))).new(uiName, data)
    else
        Knit.openui[uiName]:Destroy()
        Knit.openui[uiName] = nil
    end
end

for _,module in pairs(ReplicatedStorage:WaitForChild("Shared"):GetDescendants()) do
    (require(module)).Init()
end
Knit.AddControllersDeep(script.Parent.Controllers)

Knit.Start():catch(warn)

ReplicatedStorage:WaitForChild("RedEvent"):FireServer()