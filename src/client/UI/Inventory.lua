local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Default = require(script.Parent:WaitForChild("Template"):WaitForChild("Default"))

local UI = ReplicatedFirst:WaitForChild("UI")

local Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
    local self = setmetatable(Default.new(), Inventory)

    self.player = game.Players.LocalPlayer
    self.playerGui = self.player.PlayerGui

    self.gui = UI:WaitForChild("Inventory"):Clone()
    self.gui.Parent = self.playerGui

    self:Open()

    return self
end

function Inventory:Destroy()
    self.gui:Destroy()
end

return Inventory