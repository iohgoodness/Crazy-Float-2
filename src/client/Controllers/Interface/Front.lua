-- Timestamp // 10/24/2023 22:12:21 MNT
-- Author // @iohgoodness
-- Description // Front UI

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

local Abbreviate = Knit.shared.Math.Abbreviate

local Levels = Knit.cfg.Levels

-- cap xp fill to 0.07 min

function Front:UpdateValues(money, gems, xp)
    if not money then money = self.lastMoney end
    if not gems then gems = self.lastGems end
    if not xp then xp = self.lastXP end
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
    local level,title = Levels.GetPlayerLevel(xp)
    local nextXP = Levels.Data[math.clamp(level+1, 1, #Levels.Data)].XPThreshold
    local subtract = 0
    if level > 1 then
        subtract = Levels.Data[level].XPThreshold
    end
    self.tween(self.ui.Front.Frame.Level.Fill, {Size = UDim2.fromScale(math.clamp((xp-subtract) / (nextXP-subtract), 0.07, 1), 1)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    self.ui.Front.Frame.Level.TextLabel.Text = `{level}  |  {title}`
end

function Front:KnitStart()
    self.lastMoney = 0
    self.lastGems = 0
    self.lastXP = 0
    self.lastOpen = nil
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
                self.cycle(self.ui.Front.Frame.Buttons, function(btn)
                    self.tween(btn, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
                end)
                if self.lastOpen ~= button.Name then
                    self.tween(button, {BackgroundColor3 = Color3.fromRGB(3, 124, 57)}, .1)
                    self.lastOpen = button.Name
                else
                    self.lastOpen = nil
                end
                if table.find({'Building'}, button.Name) then
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
                    self.cycle(self.ui.Front.Frame.Buttons, function(btn)
                        self.tween(btn, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
                    end)
                    Knit.toggle(ui.Name)
                end)
            end
        end
    end
    Knit.GetService('Values').PushValues:Connect(function(money, gems, xp)
        self.lastMoney = money
        self.lastGems = gems
        self.lastXP = xp
        self:UpdateValues(money, gems, xp)
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
