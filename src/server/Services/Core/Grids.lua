-- Timestamp // 10/25/2023 10:21:10 MNT
-- Author // @iohgoodness
-- Description // Grid Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Grids = Knit.CreateService {
    Name = "Grids",
    Client = {},
}

function Grids:KnitInit()
    self.gridsDir = workspace.Island.Grids
    self.backupGrids = {}
    self.gridsInUse = {}
    for i,v in pairs(self.gridsDir:GetChildren()) do
        v.Name = i
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
    label:Destroy()
    newLabel.Parent = plot.Base
    Knit.modules.Labels[labelName](newLabel.Frame.Bar.TextLabel)
end

function Grids:SwapPlot(player, plotName)
    local foundGrid = workspace.Island.Grids:FindFirstChild(player.Name)
    if not foundGrid then return end
    local plot = foundGrid.Plot
    local newPlot = ReplicatedStorage.Assets.Physical.Plots[plotName]:Clone()
    newPlot:PivotTo(plot:GetPivot())
    newPlot.Parent = foundGrid
    plot:Destroy()
    self:SwapLabel(player, Knit.pd(player).Inventory.Plots.Label.Active)
end

function Grids:PlayerAdded(player)
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
    character:PivotTo(newGrid.Part.CFrame)
end

function Grids:PlayerRemoving(player)
    local gridName = player:GetAttribute('Grid')
    local gridIndex = table.find(self.gridsInUse, gridName)
    if gridIndex then
        table.remove(self.gridsInUse, gridIndex)
    end
end

return Grids
