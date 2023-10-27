-- Timestamp // 10/25/2023 00:05:13 MNT
-- Author // @iohgoodness
-- Description // Inventory controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Inventory = Knit.CreateController { Name = "Inventory" }

function Inventory:KnitStart()
    self.service.Pull:Connect(function(inventory)
        self.inventory = inventory
        local frame = self.ui.Inventory.Frame.Frame.Personal.Personal
        local item = Knit.cd(frame.Item)
        for k,v in pairs(inventory) do
            local newItem = item:Clone()
            newItem.Tab.ItemName.Text = k
            newItem.Tab.Count.Text = v
            newItem.Tab.UIStroke.Color = Knit.cfg.Blocks.Rarity[Knit.cfg.Blocks.Blocks[k].Rarity]
            local vf = newItem.Tab.ViewportFrame
            local model = ReplicatedStorage.Assets.Physical.Building.Blocks[k]:Clone()
            model.Parent = vf
            local viewportCamera = Instance.new("Camera")
            vf.CurrentCamera = viewportCamera
            viewportCamera.Parent = vf
            viewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, 6), model:GetPivot().Position)
            newItem.Parent = frame
            self.btn(newItem, function()
                
            end)
        end
    end)
    --[[ for _,frame in pairs(self.ui.Settings.Frame.Frame.Settings.Settings:GetChildren()) do
        if not frame:IsA('Frame') then continue end
        if frame:FindFirstChild('Toggle') then
            self.btn(frame.Toggle, function()
                frame.Toggle.Tab.TextLabel.Text = frame.Toggle.Tab.TextLabel.Text == 'ON' and 'OFF' or 'ON'
                self.service:Push(frame.Name, frame.Toggle.Tab.TextLabel.Text == 'ON' and true or false)
            end)
        elseif frame:FindFirstChild('Down') and frame:FindFirstChild('Up') then
            self.btn(frame.Down, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) - 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
            end, .02, 1.03)
            self.btn(frame.Up, function()
                frame.Number.Text = math.clamp(tonumber(frame.Number.Text) + 1, 0, 10)
                self.service:Push(frame.Name, tonumber(frame.Number.Text))
            end, .02, 1.03)
        end
    end ]]
end

return Inventory
