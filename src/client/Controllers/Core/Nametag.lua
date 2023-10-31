-- Timestamp // 10/29/2023 14:55:59 MNT
-- Author // @iohgoodness
-- Description // NameTag Controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Nametag = Knit.CreateController { Name = "Nametag" }

local AFK_TIME = 60

function Nametag:WatchAFK()
    self.timer  = 0
    self.counter = 0
    UserInputService.InputEnded:Connect(function()
        if self.afktimer then self.afktimer:Disconnect() end
        self.afktimer = RunService.RenderStepped:Connect(function(dt)
            self.counter += dt
            if self.counter > 1 then
				self.counter = 0
				self.timer += 1
                if self.timer >= AFK_TIME then
                    task.spawn(function()
                        self.service:SetStatus('afk', {TimeAFK = self.timer})
                    end)
                end
            end
        end)
    end)
    UserInputService.InputBegan:Connect(function()
        if self.afktimer then self.afktimer:Disconnect() end
        self.service:SetStatus('afk', nil)
        self.timer  = 0
        self.counter = 0
    end)
end

function Nametag:KnitStart()
    self.afktimer = nil
    self:WatchAFK()
end

return Nametag
