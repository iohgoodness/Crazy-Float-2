-- Timestamp // 06/07/2023 10:23:03 MNT
-- Author // @iohgoodness
-- Description // For handling the player data

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ProfileService = Knit.CreateService {
    Name = "ProfileService",
    Client = {

    },
}

USING_RANDOM_KEY = true

local KEY = 'PLAYER_DATA_TESTING_0001.1.0005'

if USING_RANDOM_KEY then
    warn '★ USING RANDOM KEY ★'
    local min, max, final = ("a"):byte(), ("z"):byte(), ""
    for i=1, 30 do final ..= string.char(math.random(min, max)) end
    KEY = final
end

function ProfileService.Client:GetKeyData(player, key)
    local fullKeySplit = string.split(key, '.')
    local lastTbl = {}
    for _,keyName in ipairs(fullKeySplit) do
        lastTbl = lastTbl[keyName] or Knit.pd(player)[keyName]
    end
    return lastTbl
end

function ProfileService:KnitStart()
    local ProfileTemplate = {
        Leaderboards = { };
        Settings = {
            Abbreviate = false;
            Music = 5;
            SFX = 5;
        };
        Inventory = {
            Blocks = {
                ['Wood Square'] = 4;
                ['Steel Triangle'] = 1;
            };
            Plots = {
                Plot = {
                    Active = 'Basic';
                    Owned = {'Basic'};
                };
                Label = {
                    Active = 'Glowing';
                    Owned = {'Disco'};
                };
            };
        };
    }
    local ProfileServiceModule = require(game.ServerScriptService.ProfileService)
    local Players = game:GetService("Players")
    local ProfileStore = ProfileServiceModule.GetProfileStore( KEY, ProfileTemplate )
    Knit.Profiles = {}
    local function PlayerAdded(player)
        local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            Knit.Profiles[player] = nil
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Knit.Profiles[player] = profile
        else
            profile:Release()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do task.spawn(PlayerAdded, player) end
    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(function(player)
        local profile = Knit.Profiles[player]
        if profile then profile:Release() end
    end)
    Knit.pd = function(player)
        return Knit.Profiles[player].Data
    end
end

return ProfileService
