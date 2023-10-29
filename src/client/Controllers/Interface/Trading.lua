-- Timestamp // 10/25/2023 21:44:57 MNT
-- Author // @iohgoodness
-- Description // Trading Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Trading = Knit.CreateController { Name = "Trading" }

function Trading:KnitStart()
    self.ui.Trading.Select.Position = UDim2.fromScale(-0.5, 0.5)
    self.ui.Trading.Trade.Position = UDim2.fromScale(0.5, 0.5)
    for _,button in pairs(self.ui.Trading.Trade.Frame.Personal.Boxes:GetChildren()) do
        if not button:IsA('ImageButton') then continue end
        self.btn(button, function()
            self.tween(self.ui.Trading.Trade, {Position = UDim2.fromScale(0.6, 0.5)})
            self.ui.Trading.Select.Visible = true
            self.tween(self.ui.Trading.Select, {Position = UDim2.fromScale(0.18, 0.5)})
        end)
    end
    self.btn(self.ui.Trading.Select.X, function()
        self.tween(self.ui.Trading.Trade, {Position = UDim2.fromScale(0.5, 0.5)})
        self.ui.Trading.Select.Visible = true
        self.tween(self.ui.Trading.Select, {Position = UDim2.fromScale(-0.5, 0.5)})
    end)
    self.btn(self.ui.Trading.Trade.Ready, function()

    end)

    Knit.popup('okay', 'this is a test')

    Knit.popup('interactive', 'this is an interactive test', 'ignore', 'accept')
end

return Trading
