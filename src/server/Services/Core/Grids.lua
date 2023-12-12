-- Timestamp // 10/25/2023 10:21:10 MNT
-- Author // @iohgoodness
-- Description // Grid Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Grids = Knit.CreateService {
    Name = "Grids",
    Client = {},
}

function Grids:GetGrid(player)
    return workspace.Island.Grids:WaitForChild(player.Name)
end

function Grids:KnitInit()
    self.gridsDir = workspace.Island.Grids
    self.backupGrids = {}
    self.playerThreads = {}
    self.gridsInUse = {}
    for i,v in pairs(self.gridsDir:GetChildren()) do
        v.Name = i
        local objects = Instance.new('Folder')
        objects.Name = 'Objects'
        objects.Parent = v
        table.insert(self.backupGrids, v:Clone())
        v:Destroy()
    end
end

function Grids:SwapLabel(player, labelName)
    local foundGrid = workspace.Island.Grids:FindFirstChild(player.Name)
    if not foundGrid then return end
    local plot = foundGrid[Knit.pd(player).Inventory.Plots.Plot.Active]
    local label = plot.Base:FindFirstChildOfClass('BillboardGui')
    local newLabel = ReplicatedStorage.Assets.UI.Plots.Labels[labelName]:Clone()
    newLabel.Frame.Bar.TextLabel.Text = player.DisplayName
    newLabel.Head.Bar.Image = Knit.shared.Web.GetHeadshot(player.UserId) or 'rbxassetid://15460201085'
    label:Destroy()
    newLabel.Parent = plot.Base
    Knit.modules.Labels[labelName](newLabel.Frame.Bar.TextLabel)
end

function Grids:SwapPlot(player, plotName)
    local foundGrid = workspace.Island.Grids:FindFirstChild(player.Name)
    if not foundGrid then return end
    local plot = foundGrid.Plot
    local newPlot = ReplicatedStorage.Assets.Physical.Plots[plotName]:Clone()
    --[[ newPlot:PivotTo( (CFrame.new(plot:GetPivot().Position, workspace.Island.Ground.Center.Position))*CFrame.Angles(0, math.rad(180), 0) ) ]]
    newPlot:PivotTo(CFrame.new(plot:GetPivot().Position))
    newPlot.Parent = foundGrid
    plot:Destroy()
    self:SwapLabel(player, Knit.pd(player).Inventory.Plots.Label.Active)
end

function Grids:CharacterAdded(player, character)
    character.Parent = workspace.Characters
    character:PivotTo(workspace.Island.Grids[character.Name]:FindFirstChildOfClass('Model').Base.CFrame * CFrame.new(0, 20, 0))
    local Humanoid = character:WaitForChild('Humanoid')
    local hp = ReplicatedStorage.Assets.UI.Hp:Clone()
    hp.Parent = character.Head
    local cf, size = character:GetBoundingBox()
    local Swimming = false
    Humanoid.StateChanged:Connect(function (oldState, newState)
        if newState == Enum.HumanoidStateType.Swimming then
            Swimming = true
        elseif oldState == Enum.HumanoidStateType.Swimming and newState ~= Enum.HumanoidStateType.Jumping then
            Swimming = false
        elseif oldState ~= Enum.HumanoidStateType.Swimming and oldState ~= newState then
            Swimming = false
        end
    end)
    self.playerThreads[player]['WaterDamage'] = Thread.Spawn(function()
        while task.wait(1) do
            if not Swimming then continue end
            Humanoid:TakeDamage(5)
        end
    end)
    hp.Outer.BackgroundTransparency = 1
    hp.Outer.Inner.BackgroundTransparency = 1
    hp.Outer.Inner.Size = UDim2.fromScale(math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, Humanoid.MaxHealth),1)
    Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
        if hp.Outer.BackgroundTransparency >= 1 and Humanoid.Health < Humanoid.MaxHealth then
            TweenService:Create(hp.Outer, TweenInfo.new(.41, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(hp.Outer.Inner, TweenInfo.new(.41, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
            task.wait(.11)
            TweenService:Create(hp.Outer.Inner, TweenInfo.new(.21, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, Humanoid.MaxHealth),1)}):Play()
        elseif Humanoid.Health >= Humanoid.MaxHealth then
            TweenService:Create(hp.Outer, TweenInfo.new(.41, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
            TweenService:Create(hp.Outer.Inner, TweenInfo.new(.41, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
        else
            TweenService:Create(hp.Outer.Inner, TweenInfo.new(.21, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, Humanoid.MaxHealth),1)}):Play()
        end
    end)
end

function Grids:PlayerAdded(player)
    self.playerThreads[player] = {}
    local pickedGrid
    for _,grid in ipairs(self.backupGrids) do
        if not table.find(self.gridsInUse, grid.Name) then
            table.insert(self.gridsInUse, grid.Name)
            pickedGrid = grid
            player:SetAttribute('Grid', pickedGrid.Name)
            break
        end
    end
    local newGrid = pickedGrid:Clone()
    newGrid.Name = player.Name
    newGrid.Parent = workspace.Island.Grids
    self:SwapPlot(player, Knit.pd(player).Inventory.Plots.Plot.Active)
    local character = player.Character or player.CharacterAdded:Wait()
    self:CharacterAdded(player, character)
    player.CharacterAdded:Connect(function(character)
        repeat task.wait() until character.Parent ~= nil
        self:CharacterAdded(player, character)
    end)
end

function Grids:PlayerRemoving(player)
    for _,thread in ipairs(self.playerThreads[player]) do
        pcall(function() thread:Disconnect() end)
        thread = nil
    end
    self.playerThreads[player] = nil
    local gridName = player:GetAttribute('Grid')
    local gridIndex = table.find(self.gridsInUse, gridName)
    if gridIndex then
        table.remove(self.gridsInUse, gridIndex)
    end
end

return Grids
