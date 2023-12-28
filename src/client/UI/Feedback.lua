local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local UI = ReplicatedFirst:WaitForChild("UI")

local UserFeedback = require(ReplicatedStorage.Events.Feedback.UserFeedback):Client()

local Default = require(script.Parent:WaitForChild("Template"):WaitForChild("Default"))

local Feedback = {}
Feedback.__index = Feedback

function Feedback.new()
    local self = setmetatable(Default, Feedback)

    local existingUI = self.playerGui:FindFirstChild("Feedback")
    if existingUI then
        self:Toggle(existingUI.Name)
        self:Destroy()
    end

    self.player = game.Players.LocalPlayer
    self.playerGui = self.player.PlayerGui
    self.gui = UI:WaitForChild("Feedback"):Clone()
    self.gui.Enabled = false
    self.gui.Parent = self.playerGui

    self.min = 20
    self.max = 250

    local textbox = self.playerGui.Feedback.Frame.Background.TextBox
    local chrcount = self.playerGui.Feedback.Frame.Background.TextLabel
    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        local amount = textbox.Text:len()
        if amount >= self.min and amount <= self.max then
            chrcount.Text = `{amount}/{self.max}`
            chrcount.TextColor3 = Color3.fromRGB(35, 255, 23)
        elseif amount < self.min then
            chrcount.Text = `{amount}/{self.min}`
            chrcount.TextColor3 = Color3.fromRGB(255, 2, 6)
        elseif amount > self.max then
            chrcount.Text = `{amount}/{self.max}`
            chrcount.TextColor3 = Color3.fromRGB(255, 2, 6)
        end
    end)

    self:Button(self.playerGui.Feedback.Frame.Background.Send, function()
        local amount = textbox.Text:len()
        if amount < self.min then
            return
        elseif amount > self.max then
            return
        end
        UserFeedback:Fire(textbox.Text)
    end)

    for _,v in pairs(self.gui:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name == "X" then
            self:Button(v, function()
                task.wait(0.08)
                self:Toggle()
                self:Destroy()
            end)
            break
        end
    end

    self:Toggle()

    return self
end

function Feedback:Destroy()
    self.gui:Destroy()
end

return Feedback