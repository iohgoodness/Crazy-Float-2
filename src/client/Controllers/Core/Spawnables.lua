-- Timestamp // 11/25/2023 19:24:58 MNT
-- Author // @iohgoodness
-- Description // Spawnables client

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Spawnables = Knit.CreateController { Name = "Spawnables" }

function Spawnables:KnitStart()
    local spawningDir = workspace:WaitForChild('Island'):WaitForChild('Spawning')
    local coinsDir = spawningDir:WaitForChild('Coins')
    local giftsDir = spawningDir:WaitForChild('Gifts')
    local gemsDir = spawningDir:WaitForChild('Gems')
    for _,dir in pairs({coinsDir, giftsDir, gemsDir}) do
        for _,part in pairs(dir:GetChildren()) do
            if not part:IsA('BasePart') then continue end
            if part:GetAttribute('Touched') then continue end
            part.Touched:Connect(function(hit)
                if not (hit.Parent.Name == Players.LocalPlayer.Name) then return end
                part.Transparency = 1
                for i=1, 4 do
                    if part:FindFirstChild(tostring(i)) then
                        part[tostring(i)].Enabled = false
                    end
                end
                Thread.Delay(10, function()
                    part.Transparency = 0
                    for i=1, 4 do
                        if part:FindFirstChild(tostring(i)) then
                            part[tostring(i)].Enabled = true
                        end
                    end
                end)
            end)
            task.delay(math.random(10000, 20000)/10000, function()
                self.tween(part, {Position = part.Position+Vector3.new(0,math.random(800, 1200)/1000,0)}, math.random(800, 1200)/1000, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
            end)
        end
    end
end

return Spawnables
