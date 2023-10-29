-- Timestamp // 10/26/2023 19:18:07 MNT
-- Author // @iohgoodness
-- Description // Trading Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Trading = Knit.CreateService {
    Name = "Trading",
    Client = {
        TradeReady = Knit.CreateSignal();
        UpdateTrade = Knit.CreateSignal();
        CancelTrade = Knit.CreateSignal();
    },
}

function Trading:PlayerCancelTrade(player)

end

function Trading:KnitInit()
    self.ActiveTrades = {}
    self.TradeInvites = {}
    self.InActiveTrade = {}
end

function Trading:PlayerRemoving(player)
    self:PlayerCancelTrade(player)
end

function Trading:InitiateTrade(initiator : Player, receiver : Player)
    if not Players:FindFirstChild(receiver.Name) then return 'Player not in Game' end
    if self.ActiveTrades[initiator.Name] then return 'Already Trading' end
    if self.ActiveTrades[receiver.Name] then return 'Already Trading' end
end

return Trading
