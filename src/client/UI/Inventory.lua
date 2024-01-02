local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local Interface = require(ReplicatedStorage.Packages.Interface)

--[[ local LoadInventory = require(ReplicatedStorage.Events.Inventory.LoadInventory)
local UpdateInventory = require(ReplicatedStorage.Events.Inventory.UpdateInventory):Client() ]]

local Inventory = {}
Inventory.__index = Inventory

function Inventory:ChangeCategory(categoryName)
    if self.currentCategory == categoryName then return end
    self.currentCategory = categoryName
    local btn = self.playerGui.Inventory.Frame.Buttons[categoryName]
    for _,v in pairs(self.playerGui.Inventory.Frame.Buttons:GetChildren()) do
        if v:IsA("ImageButton") and v.Name ~= categoryName then
            Interface.Tween(v, {
                Size = UDim2.fromScale(0.6, 0.15)
            }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end
    Interface.Tween(btn, {
        Size = UDim2.fromScale(0.85, 0.15)
    }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function Inventory.new(uiName)
    local self = setmetatable({}, Inventory)

    Interface.Setup(self, uiName)
    Interface.XButton(self.gui, uiName)

    for _,v in pairs(self.playerGui.Inventory.Frame.Buttons:GetChildren()) do
        if v:IsA("ImageButton") then
            Interface.Button(v, function()
                self:ChangeCategory(v.Name)
            end, function() return (self.currentCategory == v.Name) end)
        end
    end

    self.currentCategory = "Blocks"
    self:ChangeCategory("Blocks")

    Interface.Toggle(self.gui)

    return self
end

function Inventory:Destroy()
    if self.gui then Interface.Toggle(self.gui) end
    task.wait(.29)
    self.gui:Destroy()
    self = nil
end

return Inventory