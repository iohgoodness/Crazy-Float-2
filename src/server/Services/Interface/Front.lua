-- Timestamp // 10/30/2023 18:25:20 MNT
-- Author // @iohgoodness
-- Description // Animation service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Thread = require(ReplicatedStorage.Packages.Thread)

local cfg = Knit.cfg.Front

local CountDict = Knit.shared.Math.CountDict

local Front = Knit.CreateService {
    Name = "Front",
    Client = {},
}

function Front:KnitInit()
    self.timerData = {}
end

function Front:KnitStart()
    Thread.DelayRepeat(1, function()
        for _,player in pairs(Players:GetPlayers()) do
            if not self.timerData[player] then continue end
            if player:GetAttribute('AFK') then continue end
            if #Players:GetChildren() < 1 then
                player:SetAttribute('MoneyTimer', `Need {10-#Players:GetChildren()} More Players`)
                player:SetAttribute('GemsTimer', `Need {10-#Players:GetChildren()} More Players`)
                player:SetAttribute('CoinCounter', `+$0`)
                player:SetAttribute('GemsCounter', `+0 💎`)
                continue
            end
            if not player:GetAttribute('CoinCounter') or player:GetAttribute('CoinCounter') == 0 then
                player:SetAttribute('CoinCounter', `+${cfg.Values[self.timerData[player].CoinCounter].Coins}  >  +${cfg.Values[math.clamp(self.timerData[player].CoinCounter+1, 1, CountDict(cfg.Values))].Coins}`)
            end
            if not player:GetAttribute('GemsCounter') or player:GetAttribute('GemsCounter') == 0 then
                player:SetAttribute('GemsCounter', `+{cfg.Values[self.timerData[player].GemsCounter].Gems} 💎  >  +{cfg.Values[math.clamp(self.timerData[player].GemsCounter+1, 1, CountDict(cfg.Values))].Gems} 💎`)
            end
            self.timerData[player].CoinTimer += 1
            self.timerData[player].GemsTimer += 1
            player:SetAttribute('MoneyTimer', `{self.timerData[player].CoinTimer}/{self.timerData[player].MaxCoins}`)
            player:SetAttribute('GemsTimer', `{self.timerData[player].GemsTimer}/{self.timerData[player].MaxGems}`)
            if self.timerData[player].CoinTimer >= self.timerData[player].MaxCoins then
                Knit.GetService('Values'):AddMoney(player, cfg.Values[self.timerData[player].CoinCounter].Coins)
                self.timerData[player].CoinTimer = 0
                self.timerData[player].CoinCounter = math.clamp(self.timerData[player].CoinCounter+1, 1, CountDict(cfg.Values))
                if self.timerData[player].CoinCounter == CountDict(cfg.Values) then
                    player:SetAttribute('CoinCounter', `+${cfg.Values[self.timerData[player].CoinCounter].Coins}`)
                else
                    player:SetAttribute('CoinCounter', `+${cfg.Values[self.timerData[player].CoinCounter].Coins} > +${cfg.Values[math.clamp(self.timerData[player].CoinCounter+1, 1, CountDict(cfg.Values))].Coins}`)
                end
            end
            if self.timerData[player].GemsTimer >= self.timerData[player].MaxGems then
                Knit.GetService('Values'):AddGems(player, cfg.Values[self.timerData[player].GemsCounter].Gems)
                self.timerData[player].GemsTimer = 0
                self.timerData[player].GemsCounter = math.clamp(self.timerData[player].GemsCounter+1, 1, CountDict(cfg.Values))
                if self.timerData[player].GemsCounter == CountDict(cfg.Values) then
                    player:SetAttribute('GemsCounter', `+{cfg.Values[self.timerData[player].GemsCounter].Gems} 💎`)
                else
                    player:SetAttribute('GemsCounter', `+{cfg.Values[self.timerData[player].GemsCounter].Gems} 💎 > +{cfg.Values[math.clamp(self.timerData[player].GemsCounter+1, 1, CountDict(cfg.Values))].Gems} 💎`)
                end
            end
        end
    end)
end

function Front:PlayerAdded(player)
    self.timerData[player] = {
        CoinTimer = 0;
        CoinCounter = 1;
        MaxCoins = cfg.Timers.Coins;
        GemsTimer = 0;
        GemsCounter = 1;
        MaxGems = cfg.Timers.Gems;
    }
end

function Front:PlayerRemoving(player)
    self.timerData[player] = nil
end

return Front
