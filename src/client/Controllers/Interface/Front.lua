-- Timestamp // 10/24/2023 22:12:21 MNT
-- Author // @iohgoodness
-- Description // Front UI

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

function Front:KnitStart()
    for _,button in pairs(self.ui.Front.Frame.Buttons:GetChildren()) do
        if not button:IsA('ImageButton') then continue end
        self.btn(button, function()
            if self.ui:FindFirstChild(button.Name) then
                Knit.toggle(button.Name)
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
end

function Front:Hide()
    self.tween(self.ui.Front.Frame.Money, {Position = UDim2.fromScale(0.189-1.5, 0.048)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.delay(.1, function()
        self.tween(self.ui.Front.Frame.CrazyGems, {Position = UDim2.fromScale(0.189-1.5, 0.2)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end)
    task.delay(.1, function()
        self.tween(self.ui.Front.Frame.Buttons, {Position = UDim2.fromScale(0.109-1.5, 0.322)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end)
end

function Front:Show()
    self.tween(self.ui.Front.Frame.Money, {Position = UDim2.fromScale(0.189, 0.048)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.delay(.1, function()
        self.tween(self.ui.Front.Frame.CrazyGems, {Position = UDim2.fromScale(0.189, 0.2)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end)
    task.delay(.1, function()
        self.tween(self.ui.Front.Frame.Buttons, {Position = UDim2.fromScale(0.109, 0.322)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end)
end

return Front
