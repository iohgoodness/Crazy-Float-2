-- Timestamp // 10/29/2023 14:14:15 MNT
-- Author // @iohgoodness
-- Description // Chat Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Chat = Knit.CreateController { Name = "Chat" }

function Chat:KnitStart()
    self.service.SystemMessage:Connect(function(message, color)
        game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = message, Color = color, Font = Enum.Font.GothamBlack, FontSize = Enum.FontSize.Size8 } )
    end)
end

return Chat
