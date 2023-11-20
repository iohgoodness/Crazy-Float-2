-- Timestamp // 11/18/2023 21:49:32 MNT
-- Author // @iohgoodness
-- Description // Sailing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Sail = Knit.CreateController { Name = "Sail" }

function Sail:KnitStart()
    local options = self.ui.Sailing.Frame.Options
    self.cycle(options, function(btn)
        self.btn(btn, function()
            -- MarketplaceService:PromptProductPurchase(Players.LocalPlayer,data.ID)
            local btnName = btn.Parent.Name
            print(btnName)
        end)
    end)
    self.btn(self.ui.Sailing.Frame.Frame.Submit, function()
        print 'sailing'
    end)
end

return Sail
