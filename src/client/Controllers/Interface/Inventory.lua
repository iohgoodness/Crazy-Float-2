-- Timestamp // 10/25/2023 00:05:13 MNT
-- Author // @iohgoodness
-- Description // Inventory controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Inventory = Knit.CreateController { Name = "Inventory" }

function Inventory:Load(frame, fn)
    local item = Knit.cd(frame.Item)
    for k,v in pairs(self.inventory) do
        if v == 0 and frame:FindFirstChild(k) then
            frame[k]:Destroy()
        elseif frame:FindFirstChild(k) then
            frame[k].Tab.Count.Text = v
        else
            local newItem = item:Clone()
            newItem.Name = k
            newItem.Tab.ItemName.Text = k
            newItem.Tab.Count.Text = v
            --newItem.Tab.UIStroke.Color = Knit.cfg.Blocks.Rarity[Knit.cfg.Blocks.Blocks[k].Rarity]
            newItem.Tab.BackgroundColor3 = Knit.cfg.Blocks.Rarity[Knit.cfg.Blocks.Blocks[k].Rarity]
            local vf = newItem.Tab.ViewportFrame
            local model = ReplicatedStorage.Assets.Physical.Building.Blocks[k]:Clone()
            model.Parent = vf
            local viewportCamera = Instance.new("Camera")
            vf.CurrentCamera = viewportCamera
            viewportCamera.Parent = vf
            viewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, 6), model:GetPivot().Position)
            newItem.Parent = frame
        end
        self.btn(frame[k], function()
            fn(frame[k])
        end)
    end
end

function Inventory:KnitStart()
    self.service.Pull:Connect(function(inventory)
        self.inventory = inventory
        self:Load(self.ui.Inventory.Frame.Frame.Personal.Personal, function(item)

        end)
        local TradingController = Knit.GetController('Trading')
        self:Load(self.ui.Trading.Select.Frame.Personal.Personal, function(item)
            TradingController.selectedItem = item
            TradingController.ui.Trading.Select.Add.Tab.TextLabel.Text = `+{TradingController.textbox.Text} {TradingController.selectedItem}`
        end)
        self:Load(self.ui.Building.Frame.Frame.Personal.Personal, function(item)
            Knit.GetController('Building'):Placing(item.Name, item.Name)
        end)
    end)
end

return Inventory
