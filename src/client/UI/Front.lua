local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local UI = ReplicatedFirst:WaitForChild("UI")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Web = require(ReplicatedStorage.Packages.Web)
local Math = require(ReplicatedStorage.Packages.Math)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Interface = require(ReplicatedStorage.Packages.Interface)

local UpdateCurrency = require(ReplicatedStorage.Events.Front.UpdateCurrency):Client()

local Default = require(script.Parent:WaitForChild("Template"):WaitForChild("Default"))

local Front = {}
Front.__index = Front

function Front:HealthUpdate()
    Interface.Tween(self.playerGui.Front.HealthBar.GreenHealth, {
        Size = UDim2.fromScale(math.clamp(Math.Map(self.humanoid.Health, 0, self.humanoid.MaxHealth, 0.1, 1), 0, 1), 1)
    }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function Front:CharacterAdded(character)
    self.humanoid = character:WaitForChild("Humanoid")
    for _,attribute in pairs({"Health", "MaxHealth"}) do
        self.janitor:Add(self.humanoid:GetPropertyChangedSignal(attribute):Connect(function()
            self:HealthUpdate()
        end))
    end
    self:HealthUpdate()
end

function Front:MenuButtons()
    self:Button(self.playerGui.Front.Frame.Frame.Feedback, function()
        self.feedbackUI = Knit.spawnui("Feedback")
    end)
end

function Front.new()
    local self = setmetatable(Default, Front)

    self.janitor = Janitor.new()

    self.player = game.Players.LocalPlayer
    self.playerGui = self.player.PlayerGui

    self.gui = UI:WaitForChild("Front"):Clone()
    self.gui.Parent = self.playerGui

    UpdateCurrency:On(function(coins, gems, xp, level)
        self.playerGui.Front.Frame.Money.TextLabel.Text = Math.Commas(coins)
        self.playerGui.Front.Frame.Gems.TextLabel.Text = Math.Commas(gems)
    end)
    self.playerGui.Front.HealthBar.PlayerImage.Player.Image = Web.GetHeadshot(self.player.UserId)
    self.playerGui.Front.HealthBar.PlayerName.Text = self.player.Name

    self.character = self.player.Character or self.player.CharacterAdded:Wait()
    self.janitor:Add(self.player.CharacterAdded:Connect(function(character)
        self:CharacterAdded(character)
    end))
    self:CharacterAdded(self.character)

    self:MenuButtons()

    return self
end

function Front:Destroy()
    self.gui:Destroy()
end

return Front