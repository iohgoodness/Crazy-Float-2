-- Timestamp // 10/24/2023 22:57:20 MNT
-- Author // @iohgoodness
-- Description // Settings UI

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Settings = Knit.CreateController { Name = "Settings" }

local Map = Knit.shared.Math.Map

Settings.fns = {}

Settings.fns['Abbreviate'] = function(name)
    Knit.GetController('Front'):UpdateValues()
end

Settings.fns['FOV'] = function(name)
    if tonumber(Settings.save[name]) == 5 then
        Knit.tween(workspace.CurrentCamera, {FieldOfView = 70}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    else
        Knit.tween(workspace.CurrentCamera, {FieldOfView = Map(tonumber(Settings.save[name]), 1, 10, 20, 110)}, .31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    end
end

Settings.fns['Dark Mode'] = function(name)
    if Settings.save[name] then
        for _,ui in pairs(Settings.ui:GetChildren()) do
            if not ui:GetAttribute('Invert') then continue end
            for _,uiObject in pairs(ui:GetDescendants()) do
                pcall(function()
                    if uiObject:IsA('ImageLabel') and uiObject.Image == 'rbxassetid://15162041721' then
                        uiObject.ImageColor3 = Knit.cfg.Settings.DarkMode
                    end
                    uiObject.BackgroundColor3 = Knit.cfg.Settings.DarkMode
                end)
            end
        end
    else
        for _,ui in pairs(Settings.ui:GetChildren()) do
            if not ui:GetAttribute('Invert') then continue end
            for _,uiObject in pairs(ui:GetDescendants()) do
                pcall(function()
                    if uiObject:IsA('ImageLabel') and uiObject.Image == 'rbxassetid://15162041721' then
                        uiObject.ImageColor3 = Knit.cfg.Settings.LightMode
                    end
                    uiObject.BackgroundColor3 = Knit.cfg.Settings.LightMode
                end)
            end
        end
    end
end

function Settings:KnitStart()
    self.save = nil
    self.service.Pull:Connect(function(settings)
        for k,v in pairs(settings) do
            self.save = settings
            local frame = self.ui.Settings.Frame.Frame.Settings.Settings:FindFirstChild(k)
            if not frame then continue end
            frame.TextLabel.Text = frame.Name
            if frame:FindFirstChild('Toggle') then
                frame.Toggle.Tab.TextLabel.Text = v and 'ON' or 'OFF'
                if Settings.fns[frame.Name] then Settings.fns[frame.Name](frame.Name) end
            elseif frame:FindFirstChild('Down') and frame:FindFirstChild('Up') then
                frame.Number.Text = v
                if Settings.fns[frame.Name] then Settings.fns[frame.Name](frame.Name) end
            end
        end
    end)
    for _,frame in pairs(self.ui.Settings.Frame.Frame.Settings.Settings:GetChildren()) do
        if not frame:IsA('Frame') then continue end
        if frame:FindFirstChild('Toggle') then
            self.btn(frame.Toggle, function()
                frame.Toggle.Tab.TextLabel.Text = frame.Toggle.Tab.TextLabel.Text == 'ON' and 'OFF' or 'ON'
                self.service:Push(frame.Name, frame.Toggle.Tab.TextLabel.Text == 'ON' and true or false)
                self.save[frame.Name] = frame.Toggle.Tab.TextLabel.Text == 'ON' and true or false
                if Settings.fns[frame.Name] then Settings.fns[frame.Name](frame.Name) end
            end)
        elseif frame:FindFirstChild('Down') and frame:FindFirstChild('Up') then
            self.btn(frame.Down, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) - 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
                self.save[frame.Name] = tonumber(frame.Number.Text)
                if Settings.fns[frame.Name] then Settings.fns[frame.Name](frame.Name) end
            end, .02, 1.03)
            self.btn(frame.Up, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) + 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
                self.save[frame.Name] = tonumber(frame.Number.Text)
                if Settings.fns[frame.Name] then Settings.fns[frame.Name](frame.Name) end
            end, .02, 1.03)
        end
    end
end

return Settings
