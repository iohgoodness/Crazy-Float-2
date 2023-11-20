-- Timestamp // 11/18/2023 21:49:47 MNT
-- Author // @iohgoodness
-- Description // Knit Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Sail = Knit.CreateService {
    Name = "Sail",
    Client = {
        Pull = Knit.CreateSignal();
    },
}

function Sail:KnitStart()

end

return Sail
