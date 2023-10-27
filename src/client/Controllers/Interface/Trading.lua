-- Timestamp // 10/25/2023 21:44:57 MNT
-- Author // @iohgoodness
-- Description // Trading Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Trading = Knit.CreateController { Name = "Trading" }

function Trading:KnitStart()
    self.ui.Trading.Select.Position = UDim2.fromScale(-0.5, 0.5)
    for _,button in pairs(self.ui.Trading.Frame.Frame.Personal.Boxes:GetChildren()) do
        if not button:IsA('ImageButton') then continue end
        self.btn(button, function()
            self.tween(self.ui.Trading.Frame, {Position = UDim2.fromScale(0.6, 0.5)})
            self.ui.Trading.Select.Visible = true
            self.tween(self.ui.Trading.Select, {Position = UDim2.fromScale(0.18, 0.5)})
        end)
    end
    self.btn(self.ui.Trading.Frame.Ready, function()

    end)
end

-- sample

return Trading
