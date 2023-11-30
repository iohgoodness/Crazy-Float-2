-- Timestamp // 11/26/2023 10:26:44 MNT
-- Author // @iohgoodness
-- Description // For boat handling

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Boat = Knit.CreateService {
    Name = "Boat",
    Client = {},
}

local Hp = ReplicatedStorage.Assets.Physical.Misc.Hp

function Boat.new(player,cframe)
    local self = setmetatable({}, Boat)

    self.CreateBoat = function(player, cframe)
        local grid = Knit.GetService('Building').GridsService:GetGrid(player)
        if not grid then return end
        local boat = Instance.new('Model')
        boat.Name = 'Boat'
        for _,object in pairs(grid.Objects:GetChildren()) do
            local newObject = object:Clone()
            newObject.Parent = boat
        end

        local rootPart = Instance.new('Part')
        rootPart.Name = 'RootPart'
        rootPart.Anchored = true
        rootPart.Transparency = .5
        rootPart.CanCollide = false
        rootPart.CFrame, rootPart.Size = boat:GetBoundingBox()

        local alignPart = Instance.new('Part')
        alignPart.Name = 'AlignPart'
        alignPart.Anchored = true
        alignPart.Transparency = .5
        alignPart.CanCollide = false
        alignPart.CFrame, alignPart.Size = boat:GetBoundingBox()

        local alignAttachment = Instance.new('Attachment')
        alignAttachment.Name = 'AlignAttachment'
        alignAttachment.Parent = alignPart

        local rootAttachment = Instance.new('Attachment')
        rootAttachment.Name = 'RootAttachment'
        rootAttachment.Parent = rootPart

        self.boatParts = {}
        for _,part in pairs(boat:GetDescendants()) do
            if not part:IsA('BasePart') then continue end
            local model = part.Parent
            local weld = Instance.new('WeldConstraint')
            weld.Part0 = rootPart
            weld.Part1 = part
            weld.Parent = part
            part.Anchored = false
            local DENSITY = .1
            local FRICTION = 1
            local ELASTICITY = 1
            local FRICTION_WEIGHT = 1
            local ELASTICITY_WEIGHT = 1
            local physProperties = PhysicalProperties.new(DENSITY, FRICTION, ELASTICITY, FRICTION_WEIGHT, ELASTICITY_WEIGHT)
            part.CustomPhysicalProperties = physProperties
            if part.Name == 'Root' then
                local hp = Hp:Clone()
                hp.Parent = model
                table.insert(self.boatParts, model)
                hp.Outer.Transparency = 1
                hp.Outer.Inner.Transparency = 1
                model:SetAttribute('MaxHealth', 100)
                model:SetAttribute('Health', model:GetAttribute('MaxHealth'))
                local connection
                connection = model:GetAttributeChangedSignal('Health'):Connect(function()
                    local health = model:GetAttribute('Health')
                    local maxHealth = model:GetAttribute('MaxHealth')
                    local percent = health/maxHealth
                    hp.Outer.Transparency = .6
                    hp.Outer.Inner.Transparency = 0
                    hp.Outer.Inner.Size = UDim2.fromScale(percent, 1)
                    if health <= 0 then
                        connection:Disconnect()
                        model:BreakJoints()
                        Thread.Delay(5, function()
                            model:Destroy()
                        end)
                    else
                        Thread.Delay(3, function()
                            if not hp then return end
                            hp.Outer.Transparency = 1
                            hp.Outer.Inner.Transparency = 1
                        end)
                    end
                end)
            end
        end

        self.DecayBoat = function(amount)
            for _,model in pairs(self.boatParts) do
                model:SetAttribute('Health', model:GetAttribute('Health')-amount)
            end
        end

        rootPart.Parent = boat
        boat.PrimaryPart = rootPart

        boat.Parent = workspace.Generation.Boats
        boat:PivotTo(cframe)

        local vectorForce = Instance.new('VectorForce')
        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        vectorForce.Force = Vector3.new(0, 0, -850)
        vectorForce.Attachment0 = rootAttachment
        vectorForce.Parent = rootPart

        self.rootPart = rootPart
        self.rootAttachment = rootAttachment
        self.alignPart = alignPart
        self.alignAttachment = alignAttachment

        self.rootPart.Anchored = false

        return boat
    end

    self.Boat = self.CreateBoat(player,cframe)

    return self
end

return Boat
