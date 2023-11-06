-- Timestamp // 10/24/2023 22:12:21 MNT
-- Author // @iohgoodness
-- Description // Front UI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

local Abbreviate = Knit.shared.Math.Abbreviate

function Front:UpdateValues(money, gems)
    if not money then money = self.lastMoney end
    if not gems then gems = self.lastGems end
    if Knit.GetController('Settings').save and Knit.GetController('Settings').save['Abbreviate'] or false then
        money = Abbreviate(money)
        gems = Abbreviate(gems)
    end
    self.ui.Front.Frame.Money.TextLabel.Text = `${money}`
    self.ui.Front.Frame.CrazyGems.TextLabel.Text = gems
    if money and tonumber(money) then
        self.lastMoney = money
    end
    if gems and tonumber(gems) then
        self.lastGems = gems
    end
end

function Front:KnitStart()
    self.lastMoney = 0
    self.lastGems = 0
    self.defaultPositions = {}
    for _,v in pairs(self.ui.Front.Frame:GetChildren()) do
        if v:IsA('Frame') or v:IsA('TextLabel') then
            self.defaultPositions[v] = v.Position
        end
    end

    for _,button in pairs(self.ui.Front.Frame.Buttons:GetChildren()) do
        if not button:IsA('ImageButton') then continue end
        self.btn(button, function()
            if self.ui:FindFirstChild(button.Name) then
                if table.find({'Building'}, 'Building') then
                    Knit.toggle(button.Name, nil, true)
                else
                    Knit.toggle(button.Name)
                end
            end
        end)
    end
    for _,ui in pairs(self.ui:GetChildren()) do
        if ui:FindFirstChild('Frame') then
            if ui.Frame:FindFirstChild('X') then
                self.btn(ui.Frame.X, function()
                    Knit.toggle(ui.Name)
                end)
            end
        end
    end
    Knit.GetService('Values').PushValues:Connect(function(money, gems)
        self.lastMoney = money
        self.lastGems = gems
        self:UpdateValues(money, gems)
    end)
end

function Front:Hide()
    for _,v in pairs(self.ui.Front.Frame:GetChildren()) do
        if v:IsA('Frame') or v:IsA('TextLabel') then
            self.tween(v, {Position = UDim2.fromScale(v.Position.X.Scale-1.5, v.Position.Y.Scale)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    end
end

function Front:Show()
    for _,v in pairs(self.ui.Front.Frame:GetChildren()) do
        if v:IsA('Frame') or v:IsA('TextLabel') then
            self.tween(v, {Position = self.defaultPositions[v]}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    end
end

return Front
