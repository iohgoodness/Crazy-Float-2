local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local UI = ReplicatedFirst:WaitForChild("UI")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))
local Interface = require(ReplicatedStorage.Packages.Interface)

local UserFeedback = require(ReplicatedStorage.Events.Feedback.UserFeedback):Client()

local Feedback = {}
Feedback.__index = Feedback

function Feedback.new(uiName, data)
    local self = setmetatable({}, Feedback)

    self.player = game.Players.LocalPlayer
    self.playerGui = self.player.PlayerGui
    self.gui = UI:WaitForChild(uiName):Clone()
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

    Interface.Button(self.playerGui.Feedback.Frame.Background.Send, function()
        local amount = textbox.Text:len()
        if amount < self.min then
            return
        elseif amount > self.max then
            return
        end
        UserFeedback:Fire(textbox.Text)
        Interface.Popup("Okay", {
            Message = string.upper("Thank you for submitting your feedback! Your opinion will be taken into consideration and our team will try our best to implement them into future updates to make experiences more enjoyable for everyone!");
        });
        Knit.openui[uiName]:Destroy()
        Knit.openui[uiName] = nil
    end)

    for _,v in pairs(self.gui:GetDescendants()) do
        if v:IsA("ImageButton") and v.Name == "X" then
            Interface.Button(v, function()
                task.wait(0.08)
                Knit.openui[uiName]:Destroy()
                Knit.openui[uiName] = nil
            end)
            break
        end
    end

    Interface.Toggle(self.gui)

    return self
end

function Feedback:Destroy()
    if self.gui then Interface.Toggle(self.gui) end
    task.wait(.29)
    self.gui:Destroy()
    self = nil
end

return Feedback