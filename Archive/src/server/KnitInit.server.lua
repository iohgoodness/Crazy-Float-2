-- Timestamp // 05/28/2023 19:05:07 MNT
-- Author // @iohgoodness
-- Description // Knit services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

Knit.GroupID = 9291891

if workspace:FindFirstChild('Studio') then
    workspace.Studio:Destroy()
end

local modules = {}; for _,module in pairs(ReplicatedStorage.Shared:GetDescendants()) do if module:IsA('ModuleScript') then modules[tostring(module)]=require(module) end end; Knit.shared = modules;
modules = {}; for _,module in pairs(ReplicatedStorage.Configurations:GetDescendants()) do if module:IsA('ModuleScript') then modules[tostring(module)]=require(module) end end; Knit.cfg = modules;
modules = {}; for _,module in pairs(ServerScriptService.Server.Modules:GetDescendants()) do if module:IsA('ModuleScript') then modules[tostring(module)]=require(module) end end; Knit.modules = modules;
Knit.AddServicesDeep(script.Parent.Services)

Knit.Start():catch(warn)

local players = {}

local readyRemote = Instance.new('RemoteEvent') ; readyRemote.Name = 'Ready' ; readyRemote.Parent = ReplicatedStorage
readyRemote.OnServerEvent:Connect(function(player) players[player] = true end)

local function PlayerAdded(player)
    repeat
        task.wait(.1)
    until
        Knit.Profiles and (Knit.Profiles[player] and players[player]) or player:IsDescendantOf(game.Players) == false
    if player:IsDescendantOf(game.Players) == false then return end
    for _,moduleScript in pairs(game.ServerScriptService.Server.Services:GetDescendants()) do
        if not moduleScript:IsA('ModuleScript') then continue end
        if moduleScript.Name == 'ProfileService' then continue end
        local module = require(moduleScript)
        if module.PlayerAdded then
            Thread.Spawn(module.PlayerAdded, module, player)
        end
    end
end

for _,player in pairs(Players:GetChildren()) do
    PlayerAdded(player)
end
Players.PlayerAdded:Connect(function(player)
    PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
    Thread.Spawn(function()
        if players[player] then players[player] = nil end
        for _,moduleScript in pairs(game.ServerScriptService.Server.Services:GetDescendants()) do
            if not moduleScript:IsA('ModuleScript') then continue end
            if moduleScript.Name == 'ProfileService' then continue end
            local module = require(moduleScript)
            if module.PlayerRemoving then
                Thread.Spawn(module.PlayerRemoving, module, player)
            end
        end
    end)
end)
