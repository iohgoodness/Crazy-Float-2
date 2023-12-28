-- Timestamp // 11/25/2023 10:59:30 MNT
-- Author // @iohgoodness
-- Description // Map service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Map = Knit.CreateService {
    Name = "Map",
    Client = {},
}

local MapData = Knit.cfg.Maps

function Map.new(mapName)
    local self = setmetatable({}, Map)

    self.settings = MapData[mapName]
    self.Map = ServerStorage.Assets.Physical.Maps[mapName]:Clone()
    self.Map.Parent = workspace.Generation.Maps
    game.Workspace.Terrain:FillBlock(self.Map.Part.CFrame, self.Map.Part.Size, Enum.Material.Water)
    self.Map.Part:Destroy()
    for _,spot in pairs(self.Map.Spawns:GetChildren()) do
        spot.CanCollide = false
        spot.Transparency = 1
    end

    self.SetSpawn = function(player)
        for _,spot in pairs(self.Map.Spawns:GetChildren()) do
            if spot:GetAttribute('Player')==nil then
                spot:SetAttribute('Player', player.Name)
                return spot
            end
        end
    end

    self.Activate = function()
        -- decay boat
        -- spawn coins
        -- spawn obstacles
    end

    return self
end

return Map
