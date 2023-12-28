
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Data = ReplicatedStorage:WaitForChild("Data"):FindFirstChild("ProfileService") and require(ReplicatedStorage.Data.ProfileService) or {}

local ProfileService = Knit.CreateService {
    Name = "ProfileService",
    Client = {},
}

local NO_SAVE = true

local KEY = 'Crazy.Float.0001'

function ProfileService:Rollback(userId, year, month, day, hour, minute, second)
    local ProfileStore = ProfileService.GetProfileStore(KEY, self.ProfileTemplate)
    local maxDate = DateTime.fromUniversalTime(year, month, day, hour, minute, second)
    local query = ProfileStore:ProfileVersionQuery(userId, Enum.SortDirection.Descending, nil, maxDate)
    local profile = query:NextAsync()
    if profile ~= nil then
        profile:ClearGlobalUpdates()
        profile:OverwriteAsync()
        print("Rollback success!")
    else
        print("No version to rollback to.")
    end
end

function ProfileService:Get()
    return Data.ProfileTemplate
end

function ProfileService:KnitInit()
    local ProfileServiceModule = require(game.ServerScriptService.ProfileService)
    local Players = game:GetService("Players")
    local ProfileStore = ProfileServiceModule.GetProfileStore(KEY, self:Get())
    Knit.Profiles = {}
    local function PlayerAdded(player)
        if NO_SAVE then
            Knit.Profiles[player] = {Data = self:Get()}
            player:SetAttribute("DataLoaded", true)
            return
        end
        local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            Knit.Profiles[player] = nil
            player:Kick()
        end)
        if player:IsDescendantOf(Players) == true then
            Knit.Profiles[player] = profile
            player:SetAttribute("DataLoaded", true)
        else
            profile:Release()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do task.spawn(PlayerAdded, player) end
    Players.PlayerAdded:Connect(PlayerAdded)
    Players.PlayerRemoving:Connect(function(player)
        task.spawn(function()
            local t = tick()
            repeat task.wait() until player:SetAttribute("ReadyToRemove", true) or tick()-t > 5
            local profile = Knit.Profiles[player]
            if profile then
                pcall(function() profile:Release() end)
            end
        end)
    end)
    Knit.pd = function(player)
        return Knit.Profiles[player].Data
    end
end

return ProfileService
