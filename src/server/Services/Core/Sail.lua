-- Timestamp // 11/18/2023 21:49:47 MNT
-- Author // @iohgoodness
-- Description // Knit Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Sail = Knit.CreateService {
    Name = "Sail",
    Client = {
        Pull = Knit.CreateSignal();
    },
}

local PremiumShop = Knit.cfg.PremiumShop

function Sail.Client:SailingDevproducts(player, option)
    if PremiumShop.Sailing[option] then
        local data = PremiumShop.Sailing[option]
        if Knit.pd(player).Leaderboards.Gems >= data.Gems then
            Knit.GetService('Values'):AddGems(player, -data.Gems)
            Knit.pd(player).Sailing.DevProducts[option] += 1
            return true, Knit.pd(player).Sailing.DevProducts[option]
        else
            return 'Not Enough Gems'
        end
    end
end

function Sail:KnitStart()
    self.sailing = {}
end

function Sail:PlayerAdded(player)
    self.Client.Pull:Fire(player, Knit.pd(player).Sailing.DevProducts)
end

function Sail:PlayerRemoving(player)
    self.sailing[player] = nil
end

function Sail:CreateBoat(player)

end

function Sail.Client:Start(player)
    if self.sailing[player] then return end
    self.sailing[player] = {'sailing data like ship'}

    -- sailing code
    warn 'now sailing'

    Sail:End(player)
end

function Sail:End(player)
    for option,_ in pairs(Knit.pd(player).Sailing.DevProducts) do
        Knit.pd(player).Sailing.DevProducts[option] = math.clamp(Knit.pd(player).Sailing.DevProducts[option]-1, 0, 99)
    end
    if self.sailing[player] then
        self.sailing[player] = nil
    end
end

return Sail
