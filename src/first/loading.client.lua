-- Timestamp // 05/28/2023 19:07:01 MNT
-- Author // @iohgoodness
-- Description // For loading the client

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

if false then

local player = Players.LocalPlayer
local playerGui = player:WaitForChild('PlayerGui')
ContentProvider:PreloadAsync({
    playerGui:WaitForChild('Loading');
    playerGui:WaitForChild('Front');
    playerGui:WaitForChild('Loading'):WaitForChild('Black');
});

playerGui:WaitForChild('Loading'):WaitForChild('Black').BackgroundTransparency = 0
playerGui:WaitForChild('Loading'):WaitForChild('Version').Position = UDim2.fromScale(0.15, -.5)
playerGui:WaitForChild('Loading'):WaitForChild('Content').Position = UDim2.fromScale(0.85, 1.5)

playerGui:WaitForChild('Loading').Enabled = true

ReplicatedFirst:RemoveDefaultLoadingScreen()

local camera = workspace.CurrentCamera
local blur = Lighting:WaitForChild('Blur')

SKIP_LOADING = true

local function tween(obj, tbl, timer, easingStyle, easingDirection, repeatCount, reverses)
    TweenService:Create(obj, TweenInfo.new(timer or 0.21, easingStyle or Enum.EasingStyle.Linear, easingDirection or Enum.EasingDirection.InOut, repeatCount or 0, reverses or false), tbl):Play()
end

local function tween2(obj, tbl, timer, easingStyle, easingDirection, repeatCount, reverses)
    return TweenService:Create(obj, TweenInfo.new(timer or 0.21, easingStyle or Enum.EasingStyle.Linear, easingDirection or Enum.EasingDirection.InOut, repeatCount or 0, reverses or false), tbl)
end

local spawnPoint = CFrame.new(-16.477808, 3.90949726, 38.7186852, -0.203543916, -0.108843409, -0.972996891, -1.86264537e-09, 0.993801355, -0.111170664, 0.979065895, -0.0226281099, -0.20228219)
camera.CameraType = Enum.CameraType.Scriptable

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

RunService:BindToRenderStep('Loading', 1, function()
    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = 55
    spawnPoint *= CFrame.Angles(0, math.rad(0.1), 0)
    camera.CFrame = spawnPoint
    blur.Size = 14
end)

tween(playerGui:WaitForChild('Loading'):WaitForChild('Black'), {BackgroundTransparency = 1}, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(1)
tween(playerGui:WaitForChild('Loading'):WaitForChild('Version'), {Position = UDim2.fromScale(0.15, 0.5)}, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(.4)
tween(playerGui:WaitForChild('Loading'):WaitForChild('Content'), {Position = UDim2.fromScale(0.85, 0.5)}, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(.5)

local hiding = false
local t1, t2
task.spawn(function()
    while not hiding do
        t1 = tween2(playerGui.Loading.Desc, {Position = UDim2.fromScale(.5, .89)}, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        t1:Play()
        task.wait(1.21)
        if hiding then break end
        t2 = tween2(playerGui.Loading.Desc, {Position = UDim2.fromScale(.5, .91)}, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        t2:Play()
        task.wait(1.21)
        if hiding then break end
    end
end)

tween(playerGui.Loading.ImageLabel.UIGradient, {Offset = Vector2.new(0,-.2)}, 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(2+math.random(14, 21)/400)
tween(playerGui.Loading.ImageLabel.UIGradient, {Offset = Vector2.new(0,-.4)}, 2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(2.2+math.random(14, 21)/400)
tween(playerGui.Loading.ImageLabel.UIGradient, {Offset = Vector2.new(0,-.5)}, 1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(1.6+math.random(14, 21)/400)
tween(playerGui.Loading.ImageLabel.UIGradient, {Offset = Vector2.new(0,-.7)}, 3.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(3.2+math.random(14, 21)/400)
tween(playerGui.Loading.ImageLabel.UIGradient, {Offset = Vector2.new(0,-1)}, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(1+math.random(14, 21)/400)

tween(playerGui.Loading.ImageLabel, {Rotation = 60; Size = UDim2.fromScale(1.8, 1.8)}, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween(playerGui:WaitForChild('Loading'):WaitForChild('Version'), {Position = UDim2.fromScale(0.15, 1.5)}, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween(playerGui:WaitForChild('Loading'):WaitForChild('Content'), {Position = UDim2.fromScale(0.85, -0.5)}, 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
hiding = true
t1:Cancel()
t2:Cancel()
tween(playerGui.Loading.Desc, {Position = UDim2.fromScale(.5, 1.4)}, .4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(1.21)
tween(playerGui.Loading.ImageLabel, {Rotation = -120; Size = UDim2.fromScale(0, 0)}, .8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween(playerGui:WaitForChild('Loading'):WaitForChild('Black'), {BackgroundTransparency = 0}, .4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(.4)
RunService:UnbindFromRenderStep('Loading')
camera.CameraType = Enum.CameraType.Custom
playerGui:WaitForChild('Front').Frame.Visible = true
tween(playerGui:WaitForChild('Loading'):WaitForChild('Black'), {BackgroundTransparency = 1}, 1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(1)
tween(camera, {FieldOfView = 70}, .4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
tween(blur, {Size = 0}, .4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
task.wait(.4)

playerGui:WaitForChild('Loading').Enabled = false

else
    local playerGui = Players.LocalPlayer:WaitForChild('PlayerGui')
    playerGui:WaitForChild('Front').Frame.Visible = true
end