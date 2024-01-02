local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

local Interface = {}

Interface.Tween = function(obj, tbl, timer, easingStyle, easingDirection, repeatCount, reverses)
    TweenService:Create(obj, TweenInfo.new(timer or 0.21, easingStyle or Enum.EasingStyle.Linear, easingDirection or Enum.EasingDirection.InOut, repeatCount or 0, reverses or false), tbl):Play()
end;

Interface.Blur = function(size)
    TweenService:Create(game.Lighting.Blur, TweenInfo.new(0.21, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = size}):Play()
end;

function Interface.Popup(popupType, data)
    Knit.toggle("Popup", {popupType = popupType, data = data})
end

function Interface.Open(gui, frameName)
    frameName = frameName or "Frame"
    local frame = gui[frameName]
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
    gui.Enabled = true
    Interface.Tween(gui[frameName], {
        Size = UDim2.fromScale(frame:GetAttribute("SizeX"), frame:GetAttribute("SizeY"))
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    Interface.Tween(gui[frameName], {
        Position = UDim2.fromScale(frame:GetAttribute("PositionX"), frame:GetAttribute("PositionY"))
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.wait(0.28)
end

function Interface.Close(gui, frameName)
    frameName = frameName or "Frame"
    local frame = gui[frameName]
    if not frame:GetAttribute("SizeX") then
        frame:SetAttribute("SizeX", frame.Size.X.Scale)
        frame:SetAttribute("SizeY", frame.Size.Y.Scale)
    end
    if not frame:GetAttribute("PositionX") then
        frame:SetAttribute("PositionX", frame.Position.X.Scale)
        frame:SetAttribute("PositionY", frame.Position.Y.Scale)
    end
    Interface.Tween(gui[frameName], {
        Size = UDim2.fromScale(0, 0)
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    Interface.Tween(gui[frameName], {
        Position = UDim2.fromScale(0.5, 1.2)
    }, 0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    task.wait(0.28)
end

function Interface.Toggle(gui, frameName)
    frameName = frameName or "Frame"
    local frame = gui[frameName]
    if frame:GetAttribute("Transitioning") then return end
    frame:SetAttribute("Transitioning", true)
    if not frame:GetAttribute("Open") then
        frame:SetAttribute("Open", true)
        Interface.Open(gui, frameName)
    else
        frame:SetAttribute("Open", nil)
        Interface.Close(gui, frameName)
    end
    frame:SetAttribute("Transitioning", nil)
end

function Interface.Button(button, callback, ignoreCallback)
    button.MouseButton1Click:Connect(function()
        if ignoreCallback and ignoreCallback() then return end
        if button:GetAttribute("InUse") then return end
        button:SetAttribute("InUse", true)
        Interface.Tween(button, {
            Size = UDim2.fromScale(button.Size.X.Scale*.85, button.Size.Y.Scale*.85)
        }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true)
        callback()
        button:SetAttribute("InUse", nil)
    end)
end

function Interface.XButton(gui, uiName)
    task.spawn(function()
        for _,v in pairs(gui:GetDescendants()) do
            if v:IsA("ImageButton") and v.Name == "X" then
                Interface.Button(v, function()
                    task.wait(0.08)
                    Knit.openui[uiName]:Destroy()
                    Knit.openui[uiName] = nil
                end)
                break
            end
        end
    end)
end

return Interface