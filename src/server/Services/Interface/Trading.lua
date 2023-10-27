-- Timestamp // 10/26/2023 19:18:07 MNT
-- Author // @iohgoodness
-- Description // Trading Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Trading = Knit.CreateService {
    Name = "Trading",
    Client = {
        TradeReady = Knit.CreateSignal();
        UpdateTrade = Knit.CreateSignal();
    },
}

function Trading:KnitStart()

end

return Trading
