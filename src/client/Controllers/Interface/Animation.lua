-- Timestamp // 10/29/2023 11:11:59 MNT
-- Author // @iohgoodness
-- Description // Animation controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local cfg = Knit.cfg.Front

local Animation = Knit.CreateController { Name = "Animation" }

function Animation:Timebased(itemType)
    local coinAmount = 10
    local function createCoin()
        local coin = self.image:Clone()
        coin.Image = self.items[itemType][math.random(1, #self.items[itemType])]
        coin.BackgroundTransparency = 1
        coin.Rotation = math.random(-2, 2)
        coin.Visible = true
        coin.Parent = self.ui.Front.Frame
        return coin
    end
    local function coinFountain()
        for i = 1, coinAmount do
            local coin = createCoin()
            coin.Position = UDim2.fromScale(math.random(10, 20)/100, -1*math.random(80, 90)/100)
            local endPosition = itemType=='Coins' and UDim2.fromScale(.183, .237) or UDim2.fromScale(.183, .387)
            local tweenInfo = TweenInfo.new(
                math.random(25, 40)/20,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            )
            local tween = TweenService:Create(coin, tweenInfo, {Position = endPosition; Size = UDim2.new(0, 15, 0, 15)})
            tween:Play()
            tween.Completed:Connect(function()
                coin:Destroy()
            end)
            task.wait(.02)
        end
    end
    coinFountain()
end

function Animation:Fountain(itemType, scale)
    scale = scale or 1
    local coinAmount = 40 * scale
    local function createCoin()
        local coin = self.image:Clone()
        coin.Image = self.items[itemType][math.random(1, #self.items[itemType])]
        coin.BackgroundTransparency = 1
        coin.Rotation = math.random(-2, 2)
        coin.Visible = true
        coin.Parent = self.ui.Animation
        return coin
    end
    local function coinFountain()
        for i = 1, coinAmount do
            local coin = createCoin()
            coin.Position = UDim2.new(math.random(40-((scale-1)*10), 60+((scale-1)*10))/100, 0, 1, -coin.AbsoluteSize.Y)
            local endPosition = UDim2.new(
                math.random() * 0.5 + 0.25, 0,
                math.random() * -0.5, 0
            )
            local tweenInfo = TweenInfo.new(
                math.random(25, 40)/10,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            )
            local tween = TweenService:Create(coin, tweenInfo, {Position = endPosition; Size = UDim2.new(0, 0, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                coin:Destroy()
            end)
            task.wait(.02)
        end
    end
    coinFountain()
end

local function convertStringToFraction(str)
    local parts = string.split(str, "/")
    local numerator = tonumber(parts[1])
    local denominator = tonumber(parts[2])
    if denominator and denominator ~= 0 then
        return numerator / denominator
    end
end

function Animation:KnitStart()
    self.image = self.cd(self.ui.Animation.ImageLabel)
    self.items = {
        Coins = {'rbxassetid://15222450377'};
        Gems = {'rbxassetid://15299117188'};
    }
    repeat task.wait() until Players.LocalPlayer:GetAttribute('MoneyTimer') or Players.LocalPlayer:GetAttribute('GemsTimer')
    Thread.DelayRepeat(1, function()
        self.ui.Front.Frame.MoneyLabel.Text = `{Players.LocalPlayer:GetAttribute('CoinCounter')}`
        self.ui.Front.Frame.GemsLabel.Text = `{Players.LocalPlayer:GetAttribute('GemsCounter')}`
        self.ui.Front.Frame.MoneyTimer.Text = Players.LocalPlayer:GetAttribute('MoneyTimer')
        if convertStringToFraction(Players.LocalPlayer:GetAttribute('MoneyTimer')) == 1 then
            self:Timebased('Coins')
        end
        self.ui.Front.Frame.GemsTimer.Text = Players.LocalPlayer:GetAttribute('GemsTimer')
        if convertStringToFraction(Players.LocalPlayer:GetAttribute('GemsTimer')) == 1 then
            self:Timebased('Gems')
        end
    end)
end

return Animation
