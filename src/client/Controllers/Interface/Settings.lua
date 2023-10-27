-- Timestamp // 10/24/2023 22:57:20 MNT
-- Author // @iohgoodness
-- Description // Settings UI

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = Knit.CreateController { Name = "Settings" }


function Settings:KnitStart()
    self.service.Pull:Connect(function(settings)
        for k,v in pairs(settings) do
            local frame = self.ui.Settings.Frame.Frame.Settings.Settings:FindFirstChild(k)
            if not frame then continue end
            if frame:FindFirstChild('Toggle') then
                frame.Toggle.Tab.TextLabel.Text = v and 'ON' or 'OFF'
            elseif frame:FindFirstChild('Down') and frame:FindFirstChild('Up') then
                frame.Number.Text = v
            end
        end
    end)
    for _,frame in pairs(self.ui.Settings.Frame.Frame.Settings.Settings:GetChildren()) do
        if not frame:IsA('Frame') then continue end
        if frame:FindFirstChild('Toggle') then
            self.btn(frame.Toggle, function()
                frame.Toggle.Tab.TextLabel.Text = frame.Toggle.Tab.TextLabel.Text == 'ON' and 'OFF' or 'ON'
                self.service:Push(frame.Name, frame.Toggle.Tab.TextLabel.Text == 'ON' and true or false)
            end)
        elseif frame:FindFirstChild('Down') and frame:FindFirstChild('Up') then
            self.btn(frame.Down, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) - 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
            end, .02, 1.03)
            self.btn(frame.Up, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) + 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
            end, .02, 1.03)
        end
    end
end

return Settings
