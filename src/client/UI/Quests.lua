local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")

local UI = ReplicatedFirst:WaitForChild("UI")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))
local Interface = require(ReplicatedStorage.Packages.Interface)
local Math = require(ReplicatedStorage.Packages.Math)
local LoadQuests = require(ReplicatedStorage.Events.Quests.LoadQuests)
local UpdateQuest = require(ReplicatedStorage.Events.Quests.UpdateQuest):Client()

local Quests = {}
Quests.__index = Quests

function Quests:LoadQuests(questType)
    if self.loading then return end
    self.loading = true
    local questData = LoadQuests:Call(questType):Await()
    for _,v in pairs(self.playerGui.Quests.Frame.ScrollingFrame:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    for index,data in ipairs(questData) do
        local quest = self.questTemplate:Clone()
        quest.Coins.Text = Math.Commas(data.Reward.Coins)
        quest.Gems.Text = Math.Commas(data.Reward.Gems)
        data.Name = index
        quest.Info.Title.Text = data.Title
        quest.Info.Desc.Text = data.Desc:gsub("*", data.Goal)
        quest.Choose.Progress.Text = `{data.Value}/{data.Goal}`
        quest.Parent = self.playerGui.Quests.Frame.ScrollingFrame
    end
    self.loading = false
end

function Quests:UpdateQuest(questType, index, progress)
    if self.selectedQuestType ~= questType then return end
    local quest = self.playerGui.Quests.Frame.ScrollingFrame:FindFirstChild(index)
    if not quest then return end
    local goal = quest.Choose.Progress:split("/")[2]
    quest.Choose.Progress = `{progress}/{goal}`
end

function Quests.new(uiName)
    local self = setmetatable({}, Quests)

    self.player = game.Players.LocalPlayer
    self.playerGui = self.player.PlayerGui
    self.gui = UI:WaitForChild(uiName):Clone()
    self.gui.Enabled = false
    self.gui.Parent = self.playerGui
    self.questTemplate = self.playerGui.Quests.Frame.ScrollingFrame.Template:Clone()
    self.playerGui.Quests.Frame.ScrollingFrame.Template:Destroy()
    self.selectedQuestType = "Day"

    for _,v in pairs({"Day", "Week", "Month"}) do
        local btn = self.playerGui.Quests.Frame.QuestType[v]
        Interface.Button(btn, function()
            TweenService:Create(btn, TweenInfo.new(.2), {Size = UDim2.fromScale(0.315, 0.85)}):Play()
            for _,v2 in pairs({"Day", "Week", "Month"}) do
                if v2==v then continue end
                local otherbtn = self.playerGui.Quests.Frame.QuestType[v2]
                TweenService:Create(otherbtn, TweenInfo.new(.2), {Size = UDim2.fromScale(0.315, 0.65)}):Play()
            end
            if self.selectedQuestType == v then return end
            self.selectedQuestType = v
            self:LoadQuests(v)
        end)
    end

    Interface.XButton(self.gui, uiName)

    Interface.Toggle(self.gui)

    self:LoadQuests("Day")

    return self
end

function Quests:Destroy()
    if self.gui then Interface.Toggle(self.gui) end
    task.wait(.29)
    self.gui:Destroy()
    self = nil
end

return Quests