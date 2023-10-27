-- Timestamp // 05/28/2023 19:07:01 MNT
-- Author // @iohgoodness
-- Description // For loading the client
--[[ 
SKIP_LOADING = true

local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild('PlayerGui')
local camera = workspace.CurrentCamera
camera.FieldOfView = 75

local ZOOMED_IN = CFrame.new(-39.1523094, -272.164185, -8171.73828, 0.959244549, 0.138704196, 0.246193513, -0, 0.871242225, -0.490853459, -0.282577604, 0.470848501, 0.835734189)
local ZOOMED_OUT = CFrame.new(-15.1950235, -319.332336, -8090.4585, 0.959226429, 0.137463585, 0.246958345, -0, 0.873759747, -0.486357898, -0.282638729, 0.466527343, 0.838133454)

local loadingUI = ReplicatedFirst:WaitForChild('LoadingIntro')
local playUI = ReplicatedFirst:WaitForChild('PlayIntro')
local frontUI = playerGui:WaitForChild('Front')

local loadingUIFrame = loadingUI:WaitForChild('Frame')
local loadingUIGradient = loadingUIFrame:WaitForChild('UIGradient')
local loadingUIText = loadingUI:WaitForChild('Title')
local loadingUITextGradient = loadingUIText:WaitForChild('UIGradient')

local playUITitle1 = playUI:WaitForChild('Title1')
local playUITitle2 = playUI:WaitForChild('Title2')
local playUIBtn = playUI:WaitForChild('PlayBtn')
local playUIBtnUIStroke = playUIBtn:WaitForChild('UIStroke')
local playUIFrame = playUI:WaitForChild('Frame')

local waitingUI = playerGui:WaitForChild('Waiting')
local waitingMenu = waitingUI:WaitForChild('Menu')

ContentProvider:PreloadAsync({
    loadingUI;
    playUI;
});

if SKIP_LOADING then
    _G.AllowRotate = true
    task.delay(4, function() ReplicatedFirst:RemoveDefaultLoadingScreen() end)
    frontUI.Enabled = true
    _G.PlayButtonHit = true
    frontUI.Frame.Visible = true
    playUI:Destroy()
    loadingUI:Destroy()
    script:Destroy()
end

if not SKIP_LOADING then

    loadingUI.Parent = playerGui

    task.delay(4, function() ReplicatedFirst:RemoveDefaultLoadingScreen() end)

    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    task.spawn(function()
        for i=1, 5 do
            TweenService:Create(loadingUITextGradient, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
            task.wait(3.1)
            TweenService:Create(loadingUITextGradient, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 120}):Play()
            task.wait(3.1)
        end
    end)

    task.spawn(function()
        for i=1, 5 do
            TweenService:Create(loadingUIGradient, TweenInfo.new(1.85, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Offset = Vector2.new(0,math.random(15,30)/100)}):Play()
            task.wait(1.85)
            TweenService:Create(loadingUIGradient, TweenInfo.new(1.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Offset = Vector2.new(0,math.random(40,55)/100)}):Play()
            task.wait(1.75)
        end
    end)

    local loaded = false
    task.spawn(function()
        local x,y = 45,65
        for i=1, 4 do
            loadingUIText.Text = 'L O A D I N G'
            task.wait(math.random(x,y)/100)
            loadingUIText.Text = 'L O A D I N G .'
            task.wait(math.random(x,y)/100)
            loadingUIText.Text = 'L O A D I N G . .'
            task.wait(math.random(x,y)/100)
            loadingUIText.Text = 'L O A D I N G . . .'
            task.wait(math.random(x,y)/100)
        end
        loaded = true
    end)

    repeat task.wait() until loaded

    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = ZOOMED_OUT

    loadingUIText.Text = 'R E A D Y'
    TweenService:Create(loadingUIText, TweenInfo.new(1.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    TweenService:Create(loadingUIFrame, TweenInfo.new(1.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Transparency = 1}):Play()
    Debris:AddItem(loadingUI, 1.76)
    task.wait(1.76)

    playUI.Parent = playerGui

    TweenService:Create(camera, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = ZOOMED_IN}):Play()

    playUITitle1.TextTransparency = 1
    playUITitle2.TextTransparency = 1

    TweenService:Create(playUITitle1, TweenInfo.new(.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
    TweenService:Create(playUITitle2, TweenInfo.new(.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
    task.wait(.8)
    TweenService:Create(playUITitle2, TweenInfo.new(1.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 1}):Play()

    TweenService:Create(playUIBtn, TweenInfo.new(1.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
    task.wait(1.11)

    local tween = TweenService:Create(camera, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {FieldOfView = 90}) ; tween:Play()

    local play = false
    playUIBtn.Activated:Connect(function()
        _G.AllowRotate = true
        if play then return end ; play = true
        --playUIBtn.Size = UDim2.fromScale(playUIBtn.Size.X.Scale*.85, playUIBtn.Size.Y.Scale*.85)
        TweenService:Create(playUIBtn.UIStroke, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Thickness = 100}):Play()
        tween:Cancel()
        TweenService:Create(playUIFrame, TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
        task.wait(1)
        camera.CameraType = Enum.CameraType.Custom
        playUI:Destroy()
        frontUI.Enabled = true
        waitingMenu.Visible = true
        TweenService:Create(playUIFrame, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
        task.wait(1.81)
        _G.PlayButtonHit = true
        loadingUI:Destroy()
        frontUI.Frame.Visible = true
        script:Destroy()
    end)
end ]]