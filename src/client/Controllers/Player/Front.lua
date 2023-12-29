local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

function Front:KnitStart()
    self.frontUI = Knit.spawn("Front")
    --self.q = Knit.spawn("Quests")
end

return Front