-- Timestamp // 05/28/2023 19:05:07 MNT
-- Author // @iohgoodness
-- Description // Knit controllers

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Thread = require(ReplicatedStorage.Packages.Thread)

local modules = {}; for _,module in pairs(ReplicatedStorage.Shared:GetDescendants()) do if module:IsA('ModuleScript') then modules[tostring(module)]=require(module) end end; Knit.Shared = modules; Knit.shared = modules; Knit.SHARED = modules;
modules = {}; for _,module in pairs(ReplicatedStorage.Configurations:GetDescendants()) do if module:IsA('ModuleScript') then modules[tostring(module)]=require(module) end end; Knit.Cfg = modules; Knit.cfg = modules; Knit.CFG = modules;

game:GetService('ContentProvider'):PreloadAsync(ReplicatedFirst:WaitForChild('GUI'):GetChildren())
for _,ui in pairs(ReplicatedFirst:WaitForChild('GUI'):GetChildren()) do ui:SetAttribute('Invert', true); ui.Parent = Players.LocalPlayer.PlayerGui end
warn '★ UI LOADED ★'

local btnDebounce = false
Knit.btn = function(btn, fn, timer, scale, ignoreRotate)
    if not btn:GetAttribute('sx') and not btn:GetAttribute('sy') then btn:SetAttribute('sx', btn.Size.X.Scale) btn:SetAttribute('sy', btn.Size.Y.Scale) end
    if not btn.Tab:GetAttribute('sx') and not btn.Tab:GetAttribute('sy') then btn.Tab:SetAttribute('sx', btn.Tab.Size.X.Scale) btn.Tab:SetAttribute('sy', btn.Tab.Size.Y.Scale) end
    local MouseEnter, MouseLeave = Knit.Shared.Hover.MouseEnterLeaveEvent(btn) 
    MouseEnter:Connect(function()
        --TweenService:Create(btn.Tab, TweenInfo.new(0.21, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Rotation = 3}):Play()
        TweenService:Create(btn.Tab, TweenInfo.new(timer or 0.09, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.fromScale(btn.Tab:GetAttribute('sx')*.91, btn.Tab:GetAttribute('sy')*.91)}):Play()
    end)
    MouseLeave:Connect(function()
        --TweenService:Create(btn.Tab, TweenInfo.new(0.21, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Rotation = 0}):Play()
        TweenService:Create(btn.Tab, TweenInfo.new(timer or 0.09, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.fromScale(btn.Tab:GetAttribute('sx'), btn.Tab:GetAttribute('sy'))}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if btnDebounce then return end
        btnDebounce = true
        if not btn then return end
        Knit.GetController('Sound'):LocalSound('Click')
        TweenService:Create(btn.Tab, TweenInfo.new(timer or 0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {Size = UDim2.fromScale(scale or .81, scale or .81)}):Play()
        Thread.Spawn(function() fn() end)
        task.wait(timer and timer+.1 or 0.09+.1)
        btnDebounce = false
    end)
end

local lastOpenFrame = nil
local luiName, lframe, ldisableDimmer = nil, nil, nil
local debounce = false
Knit.toggle = function(uiName, frame, disableDimmer)
    if debounce then return end
    debounce = true
    Knit.GetController('Sound'):LocalSound('Swoosh')
    luiName, lframe, ldisableDimmer = uiName, frame, disableDimmer
    local inUI = false
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild('PlayerGui')
    local foundUI = playerGui:FindFirstChild(uiName)
    if not frame then frame = foundUI:FindFirstChild('Frame') else frame = foundUI:FindFirstChild(frame) end
    if not frame:GetAttribute('sx') and not frame:GetAttribute('sy') then frame:SetAttribute('sx', frame.Size.X.Scale) frame:SetAttribute('sy', frame.Size.Y.Scale) end

    if lastOpenFrame == frame then
        lastOpenFrame = nil
        TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0,0)}):Play()
        task.wait(.081)
        frame.Visible = false
        TweenService:Create(game.Lighting.Blur, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        TweenService:Create(game.Lighting.ColorCorrection, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TintColor = Color3.fromRGB(255,255,255)}):Play()
        Knit.GetController('Settings').fns['FOV']('FOV')
        --TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = Knit.GetController('Settings').save['FOV']}):Play()
        task.wait(.121)
        debounce = false
        return
    elseif lastOpenFrame and not disableDimmer then
        TweenService:Create(lastOpenFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0,0)}):Play()
        task.wait(.081)
        lastOpenFrame.Visible = false
        inUI = true
    elseif lastOpenFrame and disableDimmer then
        TweenService:Create(lastOpenFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0,0)}):Play()
        task.wait(.081)
        lastOpenFrame.Visible = false
        inUI = true
        TweenService:Create(game.Lighting.Blur, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
        TweenService:Create(game.Lighting.ColorCorrection, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TintColor = Color3.fromRGB(255,255,255)}):Play()
    end

    if not disableDimmer then
        TweenService:Create(game.Lighting.Blur, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 8}):Play()
        TweenService:Create(game.Lighting.ColorCorrection, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TintColor = Color3.fromRGB(143, 143, 143)}):Play()
        if not inUI then
            TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.48, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = workspace.CurrentCamera.FieldOfView+10}):Play()
        end
    end
    frame.Size = UDim2.fromScale(0,0)
    frame.Visible = true
    TweenService:Create(frame, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(frame:GetAttribute('sx'),frame:GetAttribute('sy'))}):Play()
    lastOpenFrame = frame
    task.wait(.121)
    debounce = false
end

local UserInputService = game:GetService("UserInputService")
local function isWithinFrame(frame, input)
    if not frame then return end
    local frameCorners = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    local clickPosition = input.Position
    return
        clickPosition.X >= frameCorners.X and
        clickPosition.X <= frameCorners.X + frameSize.X and
        clickPosition.Y >= frameCorners.Y and
        clickPosition.Y <= frameCorners.Y + frameSize.Y
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if lastOpenFrame and not isWithinFrame(lastOpenFrame, input) and not ldisableDimmer then
            Knit.toggle(luiName, lframe)
        end
    end
end)


Knit.tween = function(obj, tbl, timer, easingStyle, easingDirection, repeatCount, reverses)
    TweenService:Create(obj, TweenInfo.new(timer or 0.21, easingStyle or Enum.EasingStyle.Linear, easingDirection or Enum.EasingDirection.InOut, repeatCount or 0, reverses or false), tbl):Play()
end

local restricted = {};
Knit.txtswap = function(object, text, secondText, timer)
    if table.find(restricted, object) then return end
    table.insert(restricted, object)
    local previousText = object.Text
    object.Text = text
    task.wait(timer or 1)
    object.Text = secondText or previousText
    table.remove(restricted, table.find(restricted, object))
end

Knit.pd = function(fullKey)
    return Knit.GetService('ProfileService'):GetKeyData(fullKey)
end

Knit.cd = function(obj)
    local temp = obj:Clone()
    obj:Destroy()
    return temp
end

Knit.cycle = function(frame, fn)
    for _,v in pairs(frame:GetDescendants()) do
        if not v:IsA('ImageButton') then continue end
        fn(v)
    end
end

Knit.AddControllersDeep(script.Parent.Controllers)
for _,module in pairs(script.Parent.Controllers:GetDescendants()) do if module:IsA('ModuleScript') then
    module = require(module)
    module.player = Players.LocalPlayer
    module.ui = Players.LocalPlayer.PlayerGui
    module.btn = Knit.btn
    module.toggle = Knit.toggle
    module.txtswap = Knit.txtswap
    module.tween = Knit.tween
    module.cd = Knit.cd
    module.cycle = Knit.cycle
end end

local ui = Players.LocalPlayer.PlayerGui
local inpopup = false
local toggleData
Knit.popup = function(popupType, mainText, noText, yesText)
    if inpopup then return end
    inpopup = true
    Knit.popupAnswer = nil
    if popupType == 'interactive' then
        ui.Notification.Interactive.Frame.TextLabel.Text = mainText or 'No text provided'
        ui.Notification.Interactive.No.Tab.TextLabel.Text = string.upper(noText or 'IGNORE')
        ui.Notification.Interactive.Yes.Tab.TextLabel.Text = string.upper(yesText or 'ACCEPT')
        Knit.toggle('Notification', 'Interactive')
        toggleData = 'Interactive'
    elseif popupType == 'okay' then
        ui.Notification.Okay.Frame.TextLabel.Text = mainText or 'No text provided'
        Knit.toggle('Notification', 'Okay')
        toggleData = 'Okay'
    elseif popupType == 'input' then
        ui.Notification.Input.Frame.TextLabel.Text = mainText or 'No text provided'
        Knit.toggle('Notification', 'Input')
        toggleData = 'Input'
    end
    repeat task.wait() until Knit.popupAnswer~=nil
    local answerCopy = Knit.popupAnswer
    Knit.toggle('Notification', toggleData)
    toggleData = nil
    Knit.popupAnswer = nil
    inpopup = false
    return answerCopy
end

--warn 'KNIT START'
Knit.Start():catch(warn)

local readyRemote = ReplicatedStorage:WaitForChild('Ready')
readyRemote:FireServer()

local function PlayerAdded(player)
    Thread.Spawn(function()
        for _,module in pairs(script.Parent.Controllers:GetDescendants()) do if module:IsA('ModuleScript') then
            module = require(module)
            if module.PlayerAdded then
                Thread.Spawn(module.PlayerAdded, module, player)
            end
        end end
    end)
end
for _,player in pairs(Players:GetChildren()) do
    PlayerAdded(player)
end
Players.PlayerAdded:Connect(function(player)
    PlayerAdded(player)
end)
Players.PlayerRemoving:Connect(function(player)
    for _,module in pairs(script.Parent.Controllers:GetDescendants()) do if module:IsA('ModuleScript') then
        module = require(module)
        if module.PlayerRemoving then
            Thread.Spawn(module.PlayerRemoving, module, player)
        end
    end end
end)

warn '★ FRAMEWORK LOADED ★'