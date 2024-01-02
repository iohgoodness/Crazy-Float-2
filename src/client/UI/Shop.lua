local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Interface = require(ReplicatedStorage.Packages.Interface)

local Shop = {}
Shop.__index = Shop

function Shop:ChangeCategory(categoryName)
    if self.currentCategory == categoryName then return end
    self.currentCategory = categoryName
    local btn = self.playerGui.Shop.Frame.Menu[categoryName]
    Interface.ButtonCycle(
    --[[ for _,v in pairs(self.playerGui.Shop.Frame.Menu:GetChildren()) do
        if v:IsA("ImageButton") and v.Name ~= categoryName then
            Interface.Tween(v, {
                ImageTransparency = 0.7
            }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end
    Interface.Tween(btn, {
        ImageTransparency = 0
    }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) ]]
end

function Shop.new(uiName)
    local self = setmetatable({}, Shop)

    Interface.Setup(self, uiName)

    self.template = Interface.CloneDestroy(self.playerGui.Shop.Frame.Items.Template)

    for _,v in pairs(self.playerGui.Shop.Frame.Menu:GetChildren()) do
        if v:IsA("ImageButton") then
            Interface.Button(v, function()
                self:ChangeCategory(v.Name)
            end, function() return (self.currentCategory == v.Name) end)
        end
    end

    Interface.XButton(self.gui, uiName)
    Interface.Toggle(self.gui)

    return self
end

function Shop:Destroy()
    if self.gui then Interface.Toggle(self.gui) end
    task.wait(.29)
    self.gui:Destroy()
    self = nil
end

return Shop