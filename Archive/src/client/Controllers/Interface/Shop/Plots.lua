-- Timestamp // 11/11/2023 18:50:17 MNT
-- Author // @iohgoodness
-- Description // Plots shopping

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Plots = Knit.CreateController { Name = "Plots" }

function Plots:OpenShop()

end

function Plots:CloseShop()

end

function Plots:KnitStart()
    --[[ local camera = workspace.CurrentCamera
    local grid = workspace.Island.Grids:WaitForChild(Players.LocalPlayer.Name)
    local cf = grid:GetPivot()*CFrame.new(-10, 30, -10)
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = cf
    self.btn(self.ui.PremiumShop.Plots.Left, function()

    end)
    self.btn(self.ui.PremiumShop.Plots.Right, function()

    end)
    self.btn(self.ui.PremiumShop.Plots.Buy, function()

    end) ]]
end

return Plots
