-- Timestamp // 10/29/2023 18:21:22 MNT
-- Author // @iohgoodness
-- Description // Mouse follow

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MouseFollow = Knit.CreateService {
    Name = "MouseFollow",
    Client = {
        PushUpdate = Knit.CreateSignal();
    },
}

return MouseFollow
