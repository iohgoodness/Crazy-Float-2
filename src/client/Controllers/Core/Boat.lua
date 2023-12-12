-- Timestamp // 12/03/2023 16:55:48 MNT
-- Author // @iohgoodness
-- Description // For boat replication to the clients

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Boat = Knit.CreateController { Name = "Boat" }

function Boat:KnitStart()

end

return Boat
