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

local BlocksData = Knit.cfg.Blocks

function Building:KnitStart()
    self.GridsService = Knit.GetService('Grids')
end

function Building:MakeObject(player,instanceID,instanceName,instanceCFrame)
    local grid = Building.GridsService:GetGrid(player)
    if not grid then return end
    local instance = ReplicatedStorage.Assets.Physical.Building.Blocks[instanceName]:Clone()
    instance.PrimaryPart.Transparency = 1
    instance:PivotTo(instanceCFrame)
    instance.Name = instanceID
    instance:SetAttribute('Object', true)
    instance:SetAttribute('ObjectName', instanceName)
    for key,value in pairs(BlocksData.Blocks[instanceName]) do
        instance:SetAttribute(key, value)
    end
    Knit.GetService('Achievements'):Earn(player, 'Architect', 1)
    instance.Parent = grid.Objects
end

function Building:LoadIndex(player, index)
    local grid = self.GridsService:GetGrid(player)
    if not grid then return end
    if not index then return end
    grid.Objects:ClearAllChildren()
    for _,v in pairs(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index]) do
        v = HttpService:JSONDecode(v)
        local instanceID,instanceName,instanceCFrame = v[1], v[2], CFrame.new(unpack(v[3]))
        self:MakeObject(player,instanceID,instanceName,instanceCFrame)
    end
end

function Building:RemoveObject(player, instanceID)
    local grid = Building.GridsService:GetGrid(player)
    if not grid then return end
    local instance = grid.Objects:FindFirstChild(instanceID)
    if not instance then return end
    local objectName = instance:GetAttribute('ObjectName')
    instance:Destroy()
    for i,v in pairs(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index]) do
        v = HttpService:JSONDecode(v)
        if v[1] == instanceID then
            table.remove(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index], i)
            Knit.pd(player).Inventory.Blocks[objectName] += 1
            return
        end
    end
end

function Building:Clear(player)
    local grid = Building.GridsService:GetGrid(player)
    if not grid then return end
    for _,instance in pairs(grid.Objects:GetChildren()) do
        local objectName = instance:GetAttribute('ObjectName')
        Knit.pd(player).Inventory.Blocks[objectName] += 1
        instance:Destroy()
    end
    Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index] = {}
end

function Building.Client:Clear(player)
    Building:Clear(player)
    return Knit.pd(player).Inventory.Blocks
end

function Building.Client:RemoveObject(player, instanceID)
    Building:RemoveObject(player, instanceID)
    return Knit.pd(player).Inventory.Blocks
end

function Building.Client:AddObject(player, data)
    local instanceID,instanceName,instanceCFrame = data[1], data[2], data[3]
    if not Knit.pd(player).Inventory.Blocks[instanceName] or Knit.pd(player).Inventory.Blocks[instanceName] == 0 then return Knit.pd(player).Inventory.Blocks end
    Knit.pd(player).Inventory.Blocks[instanceName] -= 1
    Building:MakeObject(player,instanceID,instanceName,instanceCFrame)
    local encoded = HttpService:JSONEncode({data[1], data[2], {data[3]:components()}})
    table.insert(Knit.pd(player).Plots.BoatData[Knit.pd(player).Plots.Index], encoded)
    Knit.GetService('Values'):AddXP(player, 5)
    return Knit.pd(player).Inventory.Blocks
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
