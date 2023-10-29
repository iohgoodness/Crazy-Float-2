-- Timestamp // 10/25/2023 21:44:57 MNT
-- Author // @iohgoodness
-- Description // Trading Controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Trading = Knit.CreateController { Name = "Trading" }

function Trading:PlayerAdded()
    for _,player in pairs(Players:GetChildren()) do
        if self.tradingInviteFrame:FindFirstChild(player.Name) --[[ or Players.LocalPlayer==player ]] then continue end
        local playerButton = self.playerToInvite:Clone()
        playerButton.Name = player.Name
        playerButton.Tab.PlayerName.Text = player.Name
        playerButton.Parent = self.tradingInviteFrame
        self.btn(playerButton, function()
            self.service:InitiateTrade(player):andThen(function(response)
                self.txtswap(playerButton.Tab.PlayerName, response)
            end)
        end)
    end
end

function Trading:PlayerRemoving()
    for _,player in pairs(Players:GetChildren()) do
        if not self.tradingInviteFrame:FindFirstChild(player.Name) then continue end
        self.tradingInviteFrame[player.Name]:Destroy()
    end
end

function Trading:SetupTradeFrame()
    local tradeFrame = self.ui.Trading.Trade.Frame
    self.btn(self.ui.Trading.Select.X, function()
        self.tween(self.ui.Trading.Trade, {Position = UDim2.fromScale(0.5, 0.5)}, .61, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        self.ui.Trading.Select.Visible = true
        self.tween(self.ui.Trading.Select, {Position = UDim2.fromScale(-0.35, 0.5)}, .61, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end)
    for _,cell in pairs(tradeFrame.Personal.Boxes:GetChildren()) do
        if not cell:IsA('ImageButton') then continue end
        cell.Tab.Count.Text = ''
        self.btn(cell, function()
            self.tween(self.ui.Trading.Trade, {Position = UDim2.fromScale(0.6, 0.5)}, .61, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            self.ui.Trading.Select.Visible = true
            self.tween(self.ui.Trading.Select, {Position = UDim2.fromScale(0.18, 0.5)}, .61, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end)
    end
    for _,cell in pairs(tradeFrame.Recipient.Boxes:GetChildren()) do
        if not cell:IsA('ImageButton') then continue end
        cell.Tab.Count.Text = ''
    end
    self.btn(self.ui.Trading.Trade.X, function()
        self.toggle('Trading', 'Trade')
        Knit.GetController('Front'):Show()
        self.service:CancelTrade()
    end)
end

function Trading:KnitStart()
    self.tradingInviteFrame = self.ui.Trading.Frame.Frame.Personal.Personal
    self.playerToInvite = self.cd(self.tradingInviteFrame.Item)
    self.ui.Trading.Select.Position = UDim2.fromScale(-0.35, 0.5)
    self.ui.Trading.Trade.Position = UDim2.fromScale(0.5, 0.5)
    self.btn(self.ui.Trading.Trade.Ready, function()
        self.service:ConfirmTrade()
    end)
    self.service.PushInitiateTrade:Connect(function(initiator)
        if Knit.popup('interactive', `{string.gsub(tostring(initiator), "^%l", function(c) return string.upper(c) end)} wants to trade with you.`) then
            self.service:InitiateTrade(initiator)
        end
    end)
    self.service.PushStartTrade:Connect(function()
        Knit.GetController('Front'):Hide()
        self.toggle('Trading', 'Trade')
    end)
    self.service.PushConfirmTrade:Connect(function()

    end)
    self.service.PushCancelTrade:Connect(function()
        --[[ self.toggle('Trading', 'Trade') ]]
        --[[ Knit.GetController('Front'):Show() ]]
    end)
    self:SetupTradeFrame()
end

return Trading
