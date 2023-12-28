-- Timestamp // 10/25/2023 00:05:13 MNT
-- Author // @iohgoodness
-- Description // Inventory controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Viewport = Knit.shared.Viewport

local Inventory = Knit.CreateController { Name = "Inventory" }

function Inventory:Load(frame, fn)
    if frame:FindFirstChild('Item') then
        self.items[frame] = Knit.cd(frame.Item)
    end
    for k,v in pairs(self.inventory) do
        if v == 0 and frame:FindFirstChild(k) then
            frame[k]:Destroy()
        elseif frame:FindFirstChild(k) then
            frame[k].Tab.Count.Text = v
        else
            local newItem = self.items[frame]:Clone()
            newItem.Name = k
            newItem.Tab.ItemName.Text = k
            newItem.Tab.Count.Text = v
            newItem.Tab.BackgroundColor3 = Knit.cfg.Blocks.Rarity[Knit.cfg.Blocks.Blocks[k].Rarity]
            newItem.LayoutOrder = Knit.cfg.Blocks.Blocks[k].LayoutOrder
            local model = ReplicatedStorage.Assets.Physical.Building.Blocks[k]:Clone()
            model.PrimaryPart.Transparency = 1
            local camera = Instance.new("Camera")
            camera.FieldOfView = 70
            camera.Parent = newItem.Tab.ViewportFrame
            model.Parent = newItem.Tab.ViewportFrame
            newItem.Tab.ViewportFrame.CurrentCamera = camera
            newItem.Parent = frame
            local vpfModel = Viewport.new(newItem.Tab.ViewportFrame, camera)
            local cf,_ = model:GetBoundingBox()
            vpfModel:SetModel(model)
            local theta = 0
            local orientation = CFrame.new()
            local distance = vpfModel:GetFitDistance(cf.Position)
            RunService.RenderStepped:Connect(function(dt)
                theta = theta + (dt*.1)
                orientation = CFrame.fromEulerAnglesYXZ(math.rad(-20), theta, 0)
                camera.CFrame = CFrame.new(cf.Position) * orientation * CFrame.new(0, 0, distance)
            end)
            if fn then
                self.btn(frame[k], function()
                    fn(frame[k])
                    self.cycle(frame, function(btn)
                        self.tween(btn, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
                    end)
                    self.tween(frame[k], {BackgroundColor3 = Color3.fromRGB(3, 124, 57)}, .1)
                end)
            end
        end
    end
end

function Inventory:KnitStart()
    self.items = {}
    self.service.Pull:Connect(function(inventory)
        self.inventory = inventory
        self:Load(self.ui.Building.Frame.Frame.Personal.Personal, function(item)
            Knit.GetController('Building'):Placing(item.Name)
        end)
    end)
end

return Inventory
