-- Timestamp // 11/18/2023 21:49:47 MNT
-- Author // @iohgoodness
-- Description // Knit Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Sail = Knit.CreateService {
    Name = "Sail",
    Client = {
        Pull = Knit.CreateSignal();
        UpdateGameUI = Knit.CreateSignal();
    },
}

local PremiumShop = Knit.cfg.PremiumShop

local COUNTDOWN = 20
local WARNING = 10
local FINAL_COUNTDOWN = 3

function Sail:KnitStart()
    self.sailing = {}
    self.roster =  {}
    Thread.Spawn(self.Running, self)
end

function Sail:PlayerAdded(player)
    self.Client.Pull:Fire(player, Knit.pd(player).Sailing.DevProducts)
end

function Sail:PlayerRemoving(player)
    table.remove(self.roster, table.find(self.roster, player.Name))
    self.Client.UpdateGameUI:FireAll({Roster = Sail.roster})
end

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

function Sail:Running()
    while game and game.Players do
        for i=COUNTDOWN, 0, -1 do
            if i == WARNING then
                for _,playerName in pairs(self.roster) do
                    if not Players:FindFirstChild(playerName) then continue end
                    self.Client.UpdateGameUI:Fire(Players[playerName], {Timer = i; TimerWarning = i})
                end
            elseif i <= FINAL_COUNTDOWN then
                for _,playerName in pairs(self.roster) do
                    if not Players:FindFirstChild(playerName) then continue end
                    self.Client.UpdateGameUI:Fire(Players[playerName], {Timer = i; TimerWarning = i})
                end
            end
            self.Client.UpdateGameUI:FireAll({Timer = i})
            task.wait(1)
        end
        -- get all sailing players
        self.sailing = {}
        for _,playerName in pairs(self.roster) do
            local player = Players:FindFirstChild(playerName)
            if not player then continue end
            self.sailing[player] = {Player = player}
        end
        table.clear(self.roster)
        -- spawn map
        self.spawns = {}
        self.map = Knit.GetService('Map').new('Honey Pits')
        for player,_ in pairs(self.sailing) do
            if not player then continue end
            self.spawns[player] = self.map:SetSpawn(player)
        end
        -- build boats
        self.boats = {}
        for player,_ in pairs(self.sailing) do
            if not player then continue end
            self.boats[player] = Knit.GetService('Boat').new(player, self.spawns[player].CFrame)
        end
        -- move players
        for player,_ in pairs(self.sailing) do
            local character = player.Character or player.CharacterAdded:Wait()
            if not character then continue end
            character:PivotTo(self.boats[player].Boat:GetPivot())
        end
        -- start sailing

        self.decayBootsConnection = Thread.DelayRepeat(1, function()
            for player,boat in pairs(self.boats) do
                boat.DecayBoat(1)
            end
        end)

        self.map:Activate()

        repeat task.wait() until false
    end
end

function Sail.Client:ToggleJoin(player)
    if table.find(Sail.roster, player.Name) then
        player:SetAttribute('Sailing', nil)
        table.remove(Sail.roster, table.find(Sail.roster, player.Name))
        Sail.Client.UpdateGameUI:FireAll({Roster = Sail.roster})
        return false
    else
        player:SetAttribute('Sailing', true)
        table.insert(Sail.roster, player.Name)
        Sail.Client.UpdateGameUI:FireAll({Roster = Sail.roster})
        return true
    end
end

function Sail:End(player)
    for option,_ in pairs(Knit.pd(player).Sailing.DevProducts) do
        Knit.pd(player).Sailing.DevProducts[option] = math.clamp(Knit.pd(player).Sailing.DevProducts[option]-1, 0, 99)
    end
end

return Sail
