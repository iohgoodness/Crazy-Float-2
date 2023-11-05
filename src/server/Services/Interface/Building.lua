-- Timestamp // 11/01/2023 23:29:32 MNT
-- Author // @iohgoodness
-- Description // Building service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Building = Knit.CreateService {
    Name = "Building",
    Client = { },
}

function Building:KnitStart()
    self.GridsService = Knit.GetService('Grids')
end

function Building:LoadIndex(player, index)
    local grid = self.GridsService:GetGrid(player)
    if not grid then return end
    if not index then return end
    grid.Objects:ClearAllChildren()
    for _,v in pairs(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index]) do
        v = HttpService:JSONDecode(v)
        local instanceID,instanceName,instanceCFrame = v[1], v[2], CFrame.new(unpack(v[3]))
        local instance = ReplicatedStorage.Assets.Physical.Building.Blocks[instanceName]:Clone()
        instance:PivotTo(instanceCFrame)
        instance.Name = instanceID
        instance.Parent = grid.Objects
    end
end

function Building:RemoveObject(player, instanceID)
    local grid = Building.GridsService:GetGrid(player)
    if not grid then return end
    local instance = grid.Objects:FindFirstChild(instanceID)
    if not instance then return end
    instance:Destroy()
    for i,v in pairs(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index]) do
        v = HttpService:JSONDecode(v)
        if v[1] == instanceID then
            table.remove(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index], i)
            return
        end
    end
end

function Building.Client:AddObject(player, data)
    local grid = Building.GridsService:GetGrid(player)
    if not grid then return end
    local instanceID,instanceName,instanceCFrame = data[1], data[2], data[3]
    local instance = ReplicatedStorage.Assets.Physical.Building.Blocks[instanceName]:Clone()
    instance:PivotTo(instanceCFrame)
    instance.Name = instanceID
    instance.Parent = grid.Objects
    local encoded = HttpService:JSONEncode({data[1], data[2], {data[3]:components()}})
    table.insert(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index], encoded)
    return true
end

function Building:PlayerAdded(player)
    self:LoadIndex(player, Knit.pd(player).Plots.Index)
end

function Building.Client:ChangeBoat(player, index)
    if not tonumber(index) then return end
    Knit.pd(player).Plots.Index = index
    Building:LoadIndex(player, index)
end

return Building
