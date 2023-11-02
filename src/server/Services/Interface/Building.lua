-- Timestamp // 11/01/2023 23:29:32 MNT
-- Author // @iohgoodness
-- Description // Building service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Building = Knit.CreateService {
    Name = "Building",
    Client = {
        PushUpdatePlot = Knit.CreateSignal();
    },
}

--Knit.shared.Rose to compress

function Building:KnitStart()

end

function Building:UpdatePlot(player, object)

end

function Building:PlayerAdded(player)

end

return Building
