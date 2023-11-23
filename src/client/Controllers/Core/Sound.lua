-- Timestamp // 11/23/2023 07:57:06 MNT
-- Author // @iohgoodness
-- Description // Sound Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Thread = require(ReplicatedStorage.Packages.Thread)

local Sound = Knit.CreateController { Name = "Sound" }

local SoundData = Knit.cfg.Sound

function Sound:LocalSound(name)
    Thread.Spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = 'rbxassetid://'..SoundData[name][1]
        sound.Volume = SoundData[name][2]
        SoundService:PlayLocalSound(sound)
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

return Sound
