-- Timestamp // 10/30/2023 19:11:32 MNT
-- Author // @iohgoodness
-- Description // Messaging Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local cfg = Knit.cfg.Gifts

local Messaging = Knit.CreateService {
    Name = "Messaging",
    Client = {},
}

function Messaging:KnitStart()
    local _,_ = pcall(function()
        return MessagingService:SubscribeAsync('ServerChat', function(message)
            Knit.GetService('Chat'):Send(message.Data, Color3.fromRGB(255, 0, 217))
            if string.find(message.Data, 'coins') then
                for _,player in pairs(Players:GetChildren()) do
                    Knit.GetService('Values'):AddMoney(player, cfg.Values.Coins, true)
                    Knit.GetService('Chat'):Send(`[GIFT] You have been given your +{cfg.Values.Coins} coins!`, Color3.fromRGB(132, 0, 255), player)
                end
            elseif string.find(message.Data, 'gems') then
                for _,player in pairs(Players:GetChildren()) do
                    Knit.GetService('Values'):AddGems(player, cfg.Values.Gems, true)
                    Knit.GetService('Chat'):Send(`[GIFT] You have been given your +{cfg.Values.Gems} gems!`, Color3.fromRGB(132, 0, 255), player)
                end
            end
        end)
    end)
end

return Messaging
