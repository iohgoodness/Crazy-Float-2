-- Timestamp // 10/29/2023 13:30:13 MNT
-- Author // @iohgoodness
-- Description // Chat system

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Chat = Knit.CreateService {
    Name = "Chat",
    Client = {
        SystemMessage = Knit.CreateSignal();
    },
}

local chatRanks = {
    {Rank = 255; Data = {TagText = "Owner", TagColor = Color3.fromRGB(255, 0, 217)}};
    {Rank = 245; Data = {TagText = "Admin", TagColor = Color3.fromRGB(255, 0, 0)}};
    {Rank = 235; Data = {TagText = "Developer", TagColor = Color3.fromRGB(0, 255, 0)}};
    {Rank = 10; Data = {TagText = "VIP", TagColor = Color3.fromRGB(132, 0, 255)}};
}

function Chat:KnitInit()
    self.chatService = require(game.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
    self.chatService.SpeakerAdded:Connect(function(playerName)
        local player = Players[playerName]
        if not player then return end
        local rank = player:GetRankInGroup(Knit.GroupID)
        local tags = {}
        for _,rankData in ipairs(chatRanks) do
            if rank >= rankData.Rank then
                table.insert(tags, rankData.Data)
                break
            end
        end
        local speaker = self.chatService:GetSpeaker(playerName)
        speaker:SetExtraData('Tags', tags)
    end)
end

function Chat:Send(message, color, player)
    if player then
        self.Client.SystemMessage:Fire(player, message, color)
    else
        self.Client.SystemMessage:FireAll(message, color)
    end
end

function Chat:PlayerAdded(player)
    self:Send(`[SYSTEM] {player.Name} joined the game!`, Color3.fromRGB(6, 255, 122))
end

function Chat:PlayerRemoving(player)
    self:Send(`[SYSTEM] {player.Name} left the game.`, Color3.fromRGB(87, 72, 61))
end

return Chat
