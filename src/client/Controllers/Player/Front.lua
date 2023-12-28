local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Front = Knit.CreateController { Name = "Front" }

function Front:KnitStart()
    self.frontUI = Knit.spawnui("Front")
end

return Front