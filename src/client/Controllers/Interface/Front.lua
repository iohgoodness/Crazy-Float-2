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

return Front
