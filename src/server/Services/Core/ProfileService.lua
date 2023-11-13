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

local KEY = 'PLAYER_DATA_TESTING_0001.1.0009'

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

function ProfileService:Default(ProfileTemplate)
    if not ProfileTemplate.Achievements then
        ProfileTemplate.Achievements = Knit.cfg.Achievements.GetDefault()
    end
    return ProfileTemplate
end

function ProfileService:KnitInit()
    local ProfileTemplate = {
        Leaderboards = {
            Level = 0;
            Money = 0;
            Gems = 0;
        };
        XP = 0;
        RedeemedCodes = {};
        Settings = {
            Abbreviate = true;
            ['Head Turn'] = true;
            ['Dark Mode'] = false;
            Music = 5;
            SFX = 5;
            FOV = 5;
        };
        Inventory = {
            Blocks = Knit.cfg.Blocks.GetMax(10);
            Plots = {
                Plot = {
                    Active = 'Vaporwave';
                    Owned = {'Basic', 'Vaporwave'};
                };
                Label = {
                    Active = 'Glowing';
                    Owned = {'Disco'};
                };
            };
        };
        Plots = {
            Index = 1;
            BoatData = {{};{};{};{};{};};
        };
    }
    ProfileTemplate = self:Default(ProfileTemplate)
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
