local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Web = require(ReplicatedStorage.Packages.Web)
local Math = require(ReplicatedStorage.Packages.Math)
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Interface = require(ReplicatedStorage.Packages.Interface)

local UpdateCurrency = require(ReplicatedStorage.Events.Front.UpdateCurrency):Client()

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
    local menu = self.playerGui.Front.Frame.Frame.Menu
    for _,v in pairs(self.playerGui.Front.Frame.Frame:GetChildren()) do
        if v.Name == "Menu" then continue end
        v:SetAttribute("px", v.Position.X.Scale)
        v:SetAttribute("py", v.Position.Y.Scale)
        v.Position = menu.Position
        v.Visible = false
        v.ImageTransparency = 1
    end
    self.playerGui.Front.Frame.Frame.Visible = true
    self.playerGui.Front.Frame.Frame.ImageTransparency = 1
    Interface.Button(self.playerGui.Front.Frame.Frame.Menu, function()
        if not self.menuOpen then
            self.playerGui.Front.Frame.Frame.Visible = true
            Interface.Tween(self.playerGui.Front.Frame.Frame, {
                ImageTransparency = 0
            }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            for _,v in pairs(self.playerGui.Front.Frame.Frame:GetChildren()) do
                if v.Name == "Menu" then continue end
                v.Visible = true
                Interface.Tween(v, {
                    Position = UDim2.fromScale(v:GetAttribute("px"), v:GetAttribute("py")),
                    ImageTransparency = 0
                }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.wait(.08)
            end
            task.wait(0.35)
            self.menuOpen = true
        else
            Interface.Tween(self.playerGui.Front.Frame.Frame, {
                ImageTransparency = 1
            }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            for _,v in pairs(self.playerGui.Front.Frame.Frame:GetChildren()) do
                if v.Name == "Menu" then continue end
                Interface.Tween(v, {
                    Position = menu.Position,
                    ImageTransparency = 1
                }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.delay(0.35, function()
                    v.Visible = false
                end)
            end
            task.wait(0.35)
            self.menuOpen = false
        end
    end)
    Interface.Button(self.playerGui.Front.Frame.Frame.Feedback, function()
        Knit.toggle("Feedback")
    end, function() return (not self.menuOpen) end)
    Interface.Button(self.playerGui.Front.Frame.Frame.Quests, function()
        Knit.toggle("Quests")
    end, function() return (not self.menuOpen) end)
    Interface.Button(self.playerGui.Front.Frame.Frame.Inventory, function()
        Knit.toggle("Inventory")
    end, function() return (not self.menuOpen) end)
    Interface.Button(self.playerGui.Front.Frame.Frame.Shop, function()
        Knit.toggle("Shop")
    end, function() return (not self.menuOpen) end)
end

function Front.new()
    local self = setmetatable({}, Front)

    self.janitor = Janitor.new()

    Interface.Setup(self, "Front", true)

    self.menuOpen = false

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