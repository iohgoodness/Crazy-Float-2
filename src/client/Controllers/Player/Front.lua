local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

function Front:KnitStart()
    print 'front start'
    self.frontUI = Knit.spawn("Front")
    --self.s = Knit.spawn("Shop")
    --self.inventory = Knit.toggle("Inventory")
end

return Front