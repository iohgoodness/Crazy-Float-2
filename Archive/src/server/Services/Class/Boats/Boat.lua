-- Timestamp // 12/03/2023 17:28:40 MNT
-- Author // @iohgoodness
-- Description // Boats

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Boat = {}
Boat.__index = Boat

local HpUI = ReplicatedStorage.Assets.Physical.Misc.Hp

function Boat.new(player, cframe)
	local self = setmetatable({}, Boat)



    return self
end