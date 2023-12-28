-- Timestamp // 11/12/2023 18:44:03 MNT
-- Author // @iohgoodness
-- Description // Mod access

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatService = require(game:GetService('ServerScriptService'):WaitForChild('ChatServiceRunner').ChatService)

local ModAccess = Knit.CreateService {
    Name = "ModAccess",
    Client = {
        Visible = Knit.CreateSignal();
    },
}

ModAccess.fns = {
    ['Mute1SoftMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 10 * 60)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 10 Minutes.`, reason)
    end;
    ['Mute2SoftMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 30 * 60)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 30 Minutes.`, reason)
    end;
    ['Mute3SoftMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 60 * 60 * 1)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 1 Hour.`, reason)
    end;
    ['Mute1HardMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 60 * 60 * 6)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 6 Hours.`, reason)
    end;
    ['Mute2HardMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 60 * 60 * 24)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 1 Day.`, reason)
    end;
    ['Mute3HardMutes'] = function(player, target, reason)
        ChatService:GetChannel('All'):MuteSpeaker(player.Name, reason, 60 * 60 * 24 * 5)
        ModAccess.Webhooks:Log(player, target, 'MUTE', `Muted for 5 Days.`, reason)
    end;
    ['Kick'] = function(player, target, reason)
        target:Kick(reason)
        ModAccess.Webhooks:Log(player, target, 'KICK', `Kicked from the game.`, reason)
    end;
    ['MetoThem'] = function(player, target, reason)
        local character = player.Character or player.CharacterAdded:Wait()
        local targetCharacter = target.Character or target.CharacterAdded:Wait()
        character:PivotTo(targetCharacter:GetPivot()*CFrame.new(0, 5, 0))
        ModAccess.Webhooks:Log(player, target, 'TELEPORT', `Teleported {player} to {target}.`, reason)
    end;
    ['ThemToMe'] = function(player, target, reason)
        local character = player.Character or player.CharacterAdded:Wait()
        local targetCharacter = target.Character or target.CharacterAdded:Wait()
        targetCharacter:PivotTo(character:GetPivot()*CFrame.new(0, 5, 0))
        ModAccess.Webhooks:Log(player, target, 'TELEPORT', `Teleported {target} to {player}.`, reason)
    end;
    ['RB1'] = function(player, target, reason)
        ModAccess.Webhooks:Log(player, target, 'DATA ROLLBACK', `Revert data 6 hours ago.`, reason)
    end;
    ['RB2'] = function(player, target, reason)
        ModAccess.Webhooks:Log(player, target, 'DATA ROLLBACK', `Revert data 2 days ago.`, reason)
    end;
    ['RB3'] = function(player, target, reason)
        ModAccess.Webhooks:Log(player, target, 'DATA ROLLBACK', `Revert data 7 days ago.`, reason)
    end;
}

function ModAccess:Verify(player)
    if game.PlaceId == 15284783306 then
        if not player:IsInGroup(9291891) then
            return false
        else
            warn 'ALLOWED MOD ACCESS FOR TESTERS'
            if not (player:GetRankInGroup(9291891) >= 225) then
                return false
            end
        end
    end
    if game:GetService('RunService'):IsStudio() then
        return true
    end
end

function ModAccess:KnitStart()
    self.Webhooks = Knit.GetService('Webhooks')
end

function ModAccess.Client:Action(player, target, action, reason)
    if not target then return end
    if not ModAccess:Verify(player) then return end
    if not ModAccess.fns[action] then return end
    ModAccess.fns[action](player, target, reason) 
end

function ModAccess:PlayerAdded(player)
    self.Client.Visible:Fire(player, self:Verify(player))
end

return ModAccess
