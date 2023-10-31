-- Timestamp // 10/29/2023 11:42:32 MNT
-- Author // @iohgoodness
-- Description // Values Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Values = Knit.CreateService {
    Name = "Values",
    Client = {
        PushValues = Knit.CreateSignal();
    },
}

function Values:AddMoney(player, amount, special)
    if not player then return end
    Knit.pd(player).Leaderboards.Money += amount
    if special then
        self.ShopService.Client.PushPurchased:Fire(player, 'Coins', amount<2000 and 1 or amount<10000 and 2 or 3)
    end
    self.Client.PushValues:Fire(player, Knit.pd(player).Leaderboards.Money, Knit.pd(player).Leaderboards.Gems)
end

function Values:AddGems(player, amount, special)
    if not player then return end
    Knit.pd(player).Leaderboards.Gems += amount
    if special then
        self.ShopService.Client.PushPurchased:Fire(player, 'Gems', amount<200 and 1 or amount<500 and 2 or 3)
    end
    self.Client.PushValues:Fire(player, Knit.pd(player).Leaderboards.Money, Knit.pd(player).Leaderboards.Gems)
end

function Values:PlayerAdded(player)
    self:AddMoney(player, 0)
    self:AddGems(player, 0)
end

function Values:KnitStart()
    self.ShopService = Knit.GetService('Shop')
end

return Values
