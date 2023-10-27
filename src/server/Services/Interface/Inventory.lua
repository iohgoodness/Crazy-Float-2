-- Timestamp // 10/25/2023 00:13:05 MNT
-- Author // @iohgoodness
-- Description // Inventory service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Inventory = Knit.CreateService {
    Name = "Inventory",
    Client = {
        Pull = Knit.CreateSignal();
    },
}

function Inventory:KnitStart()

end

function Inventory:PlayerAdded(player)
    self.Client.Pull:Fire(player, Knit.pd(player).Inventory.Blocks)
end

return Inventory
