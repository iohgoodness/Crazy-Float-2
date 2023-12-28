local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Interface = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Interface"))

local Default = {}
Default.__index = Default

function Default:Open(frameName)
    frameName = frameName or "Frame"
    local frame = self.gui[frameName]
    if not frame:GetAttribute("SizeX") then
        frame:SetAttribute("SizeX", frame.Size.X.Scale)
        frame:SetAttribute("SizeY", frame.Size.Y.Scale)
    end
    if not frame:GetAttribute("PositionX") then
        frame:SetAttribute("PositionX", frame.Position.X.Scale)
        frame:SetAttribute("PositionY", frame.Position.Y.Scale)
    end
    frame.Size = UDim2.fromScale(0, 0)
    frame.Position = UDim2.fromScale(0.5, 1.2)
    self.gui.Enabled = true
    Interface.Tween(self.gui[frameName], {
        Size = UDim2.fromScale(frame:GetAttribute("SizeX"), frame:GetAttribute("SizeY"))
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    Interface.Tween(self.gui[frameName], {
        Position = UDim2.fromScale(frame:GetAttribute("PositionX"), frame:GetAttribute("PositionY"))
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.wait(0.28)
end

function Default:Close(frameName)
    frameName = frameName or "Frame"
    local frame = self.gui[frameName]
    if not frame:GetAttribute("SizeX") then
        frame:SetAttribute("SizeX", frame.Size.X.Scale)
        frame:SetAttribute("SizeY", frame.Size.Y.Scale)
    end
    if not frame:GetAttribute("PositionX") then
        frame:SetAttribute("PositionX", frame.Position.X.Scale)
        frame:SetAttribute("PositionY", frame.Position.Y.Scale)
    end
    Interface.Tween(self.gui[frameName], {
        Size = UDim2.fromScale(0, 0)
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    Interface.Tween(self.gui[frameName], {
        Position = UDim2.fromScale(0.5, 1.2)
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.wait(0.28)
end

function Default:Toggle(frameName)
    frameName = frameName or "Frame"
    local frame = self.gui[frameName]
    if frame:GetAttribute("Transitioning") then return end
    frame:SetAttribute("Transitioning", true)
    if not frame:GetAttribute("Open") then
        frame:SetAttribute("Open", true)
        self:Open(frameName)
    else
        frame:SetAttribute("Open", nil)
        self:Close(frameName)
    end
    frame:SetAttribute("Transitioning", nil)
end

function Default:Button(button, callback)
    button.MouseButton1Click:Connect(function()
        if button:GetAttribute("InUse") then return end
        button:SetAttribute("InUse", true)
        Interface.Tween(button, {
            Size = UDim2.fromScale(button.Size.X.Scale*.85, button.Size.Y.Scale*.85)
        }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
        callback()
        button:SetAttribute("InUse", nil)
    end)
end

function Default.new()
    local self = setmetatable({}, Default)
    return self
end

return Default