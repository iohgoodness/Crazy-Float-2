-- Timestamp // 10/26/2023 19:18:07 MNT
-- Author // @iohgoodness
-- Description // Trading Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Trading = Knit.CreateService {
    Name = "Trading",
    Client = {
        PushCancelTrade = Knit.CreateSignal();
        PushInitiateTrade = Knit.CreateSignal();
        PushStartTrade = Knit.CreateSignal();
        PushConfirmTrade = Knit.CreateSignal();
    },
}

function Trading:KnitInit()
    self.ActiveTrades = {}
    self.TradeInvites = {}
end

function Trading:CancelTrade(player)
    for k,v in pairs(self.ActiveTrades) do
        if k == player.Name or v == player.Name then
            self.ActiveTrades[k] = nil
        end
    end
    for k,v in pairs(self.TradeInvites) do
        if k == player.Name or v == player.Name then
            Players[k]:SetAttribute(`{v}InviteCooldown`, nil)
            Players[v]:SetAttribute(`{k}InviteCooldown`, nil)
            self.TradeInvites[k] = nil
        end
    end
end

function Trading:PlayerRemoving(player)
    self:CancelTrade(player)
end

function Trading.Client:CancelTrade(player)
    Trading:CancelTrade(player)
end

function Trading.Client:ConfirmTrade(player)

end

function Trading.Client:InitiateTrade(initiator : Player, receiver : Player)
    if not Players:FindFirstChild(receiver.Name) then return 'Player not in Game' end
    if Trading.ActiveTrades[initiator.Name] then return 'Already Trading' end
    if Trading.ActiveTrades[receiver.Name] then return 'Already Trading' end
    if Trading.TradeInvites[receiver.Name] == initiator.Name then
        -- trade being confirmed / started
        Trading.TradeInvites[initiator.Name] = nil
        receiver:SetAttribute(`{initiator}InviteCooldown`, nil)
        Trading.ActiveTrades[initiator.Name] = {}
        Trading.ActiveTrades[receiver.Name] = {}
        for _,player in pairs({initiator, receiver}) do
            Trading.Client.PushStartTrade:Fire(player)
        end
        return nil
    else
        -- trade being sent
        if Trading.TradeInvites[initiator.Name] then return `Wait {Knit.cfg.Trading.Cooldown - (math.ceil(os.clock()) - receiver:GetAttribute(`{initiator}InviteCooldown`))} Seconds to Invite Again` end
        Trading.TradeInvites[initiator.Name] = receiver.Name
        receiver:SetAttribute(`{initiator}InviteCooldown`, math.ceil(os.clock()))
        Thread.Delay(Knit.cfg.Trading.Cooldown, function()
            if Trading.TradeInvites[initiator.Name] then
                Trading.TradeInvites[initiator.Name] = nil
                receiver:SetAttribute(`{initiator}InviteCooldown`, nil)
            end
        end)
        Trading.Client.PushInitiateTrade:Fire(receiver, initiator)
        return 'Invite Sent'
    end
    return 'Declined'
end

return Trading
