
-- Timestamp // 11/25/2023 19:28:37 MNT
-- Author // @iohgoodness
-- Description // spawnables for server

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Spawnables = ServerStorage.Assets.Physical.Spawnables
local Coin = Spawnables.Coin
local Gem = Spawnables.Gem

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Spawnables = Knit.CreateService {
    Name = "Spawnables",
    Client = {},
}

function Spawnables:KnitStart()
    local spawnPart = workspace.Island.Spawning.Part
    local coinsDir = workspace.Island.Spawning.Coins
    local gemsDir = workspace.Island.Spawning.Gems
    for i=1, 100 do
        local coin = Coin:Clone()
        local rayOrigin = Vector3.new(math.random(spawnPart.Position.X-spawnPart.Size.X/2, spawnPart.Position.X+spawnPart.Size.X/2), spawnPart.Position.Y, math.random(spawnPart.Position.Z-spawnPart.Size.Z/2, spawnPart.Position.Z+spawnPart.Size.Z/2))
		local rayDirection = Vector3.new(0, -1000, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {workspace.Terrain}
		raycastParams.FilterType = Enum.RaycastFilterType.Include
        raycastParams.IgnoreWater = false
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
		if raycastResult then
            coin.CFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(90))
            coin.Position = raycastResult.Position + Vector3.new(0, 5, 0)
		end
        coin:SetAttribute('Value', math.random(10, 15))
        coin.Parent = coinsDir
        coin.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild('Humanoid') and coin:GetAttribute('Touched')==nil then
                coin:SetAttribute('Touched', true)
                coin.Transparency = 1
                for i2=1, 4 do
                    if coin:FindFirstChild(tostring(i2)) then
                        coin[tostring(i2)].Enabled = false
                    end
                end
                Knit.GetService('Values'):AddMoney(Players[hit.Parent.Name], coin:GetAttribute('Value'), true)
                Thread.Delay(10, function()
                    coin:SetAttribute('Touched', nil)
                    coin.Transparency = 0
                    for i2=1, 4 do
                        if coin:FindFirstChild(tostring(i2)) then
                            coin[tostring(i2)].Enabled = true
                        end
                    end
                    coin.CFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(90))
                end)
            end
        end)
    end
    for i=1, 50 do
        local gem = Gem:Clone()
        local rayOrigin = Vector3.new(math.random(spawnPart.Position.X-spawnPart.Size.X/2, spawnPart.Position.X+spawnPart.Size.X/2), spawnPart.Position.Y, math.random(spawnPart.Position.Z-spawnPart.Size.Z/2, spawnPart.Position.Z+spawnPart.Size.Z/2))
		local rayDirection = Vector3.new(0, -1000, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {workspace.Terrain}
		raycastParams.FilterType = Enum.RaycastFilterType.Include
        raycastParams.IgnoreWater = false
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
		if raycastResult then
            gem.CFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
            gem.Position = raycastResult.Position + Vector3.new(0, 5, 0)
		end
        gem:SetAttribute('Value', math.random(1, 3))
        gem.Parent = coinsDir
        gem.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild('Humanoid') and gem:GetAttribute('Touched')==nil then
                gem:SetAttribute('Touched', true)
                gem.Transparency = 1
                for i2=1, 4 do
                    if gem:FindFirstChild(tostring(i2)) then
                        gem[tostring(i2)].Enabled = false
                    end
                end
                Knit.GetService('Values'):AddGems(Players[hit.Parent.Name], gem:GetAttribute('Value'), true)
                Thread.Delay(10, function()
                    gem:SetAttribute('Touched', nil)
                    gem.Transparency = 0
                    for i2=1, 4 do
                        if gem:FindFirstChild(tostring(i2)) then
                            gem[tostring(i2)].Enabled = true
                        end
                    end
                    gem.CFrame = CFrame.new(raycastResult.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
                end)
            end
        end)
    end
end

return Spawnables
