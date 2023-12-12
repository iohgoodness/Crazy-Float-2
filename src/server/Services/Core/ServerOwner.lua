-- Timestamp // 12/03/2023 17:05:34 MNT
-- Author // @iohgoodness
-- Description // Server owner, client with best ping

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local ServerOwner = Knit.CreateService {
    Name = "ServerOwner",
    Client = {},
}

function ServerOwner:PlayerRemoving(player)
    self.PingData[player] = nil
    if player == self.ServerOwner then
        Knit.BestClient = self:GetPlayerWithBestPing()
    end
end

function ServerOwner:GetPlayerWithBestPing()
    local bestPing = math.huge
    local bestPlayer = nil
    for player,ping in pairs(self.PingData) do
        if ping < bestPing then
            bestPing = ping
            bestPlayer = player
        end
    end
    return bestPlayer or Players:GetChildren()[1]
end

function ServerOwner:KnitInit()
    self.PingData = {}
    Knit.BestClient = self:GetPlayerWithBestPing()
    Thread.DelayRepeat(1, function()
        for _,player in pairs(game.Players:GetPlayers()) do
            self.PingData[player] = player:GetNetworkPing()
        end
    end)
end

return ServerOwner
