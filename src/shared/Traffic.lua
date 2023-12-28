local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IS_SERVER = RunService:IsServer()

local ServerScriptService
if IS_SERVER then
    ServerScriptService = game:GetService("ServerScriptService")
end

local Traffic = {}

function Traffic.PlayerAdded(player)
    if Traffic.players[player] then return end
    Traffic.players[player] = true
    if IS_SERVER then
        repeat task.wait() until player:GetAttribute("ClientReady")
        repeat task.wait() until player:GetAttribute("DataLoaded")
        player:SetAttribute("JoinTick", tick())
        player:SetAttribute("ClientReady", nil)
        player:SetAttribute("DataLoaded", nil)
        for _,moduleScript in pairs(ServerScriptService.Server.Services:GetDescendants()) do
            if not moduleScript:IsA("ModuleScript") then continue end
            local module = require(moduleScript)
            if module.PlayerAdded then
                task.spawn(function()
                    module.PlayerAdded(module, player)
                end)
            end
        end
    else
        for _,moduleScript in pairs(Players.LocalPlayer.PlayerScripts.Client.Controllers:GetDescendants()) do
            if not moduleScript:IsA("ModuleScript") then continue end
            local module = require(moduleScript)
            if module.PlayerAdded then
                task.spawn(function()
                    module.PlayerAdded(module, Players.LocalPlayer)
                end)
            end
        end
    end
end

function Traffic.PlayerRemoving(player)
    if IS_SERVER then
        local Knit = require(ReplicatedStorage.Packages.Knit)
        Knit.pd(player).Analytics.TotalTime += (tick()-player:GetAttribute("JoinTick"))
        for _,moduleScript in pairs(ServerScriptService.Server.Services:GetDescendants()) do
            if not moduleScript:IsA("ModuleScript") then continue end
            local module = require(moduleScript)
            if module.PlayerRemoving then
                module.PlayerRemoving(module, player)
            end
        end
        player:SetAttribute("ReadyToRemove", true)
    end
    if not Traffic.players[player] then return end
    Traffic.players[player] = nil
end

function Traffic.Init()
    Traffic.players = {}
    for _,player in pairs(Players:GetChildren()) do
        task.spawn(function()
            Traffic.PlayerAdded(player)
        end)
    end
    Players.PlayerAdded:Connect(function(player)
        task.spawn(function()
            Traffic.PlayerAdded(player)
        end)
    end)
    Players.PlayerRemoving:Connect(function(player)
        task.spawn(function()
            Traffic.PlayerRemoving(player)
        end)
    end)
end

return Traffic