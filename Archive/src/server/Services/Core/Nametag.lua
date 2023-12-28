-- Timestamp // 10/29/2023 14:57:32 MNT
-- Author // @iohgoodness
-- Description // NameTag Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Nametag = Knit.CreateService {
    Name = "Nametag",
    Client = {},
}

local Status = ReplicatedStorage.Assets.UI.Nametags.Status:Clone()

function convertToHMS(seconds)
	local Minutes = (seconds - seconds%60)/60
	seconds = seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return string.format("%02i", Minutes)..":"..string.format("%02i", seconds)
end

function Nametag.Client:SetStatus(player, statusType, data)
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end
    local humanoid = character:WaitForChild('Humanoid')
    if not humanoid then return end
    local head = character:WaitForChild('Head')
    if not head then return end
    local status = head:FindFirstChild('Status')
    if not status then
        status = Status:Clone()
    end
    if statusType == 'afk' then
        if data == nil then
            player:SetAttribute('AFK', nil)
            status:Destroy()
            return
        end
        if data.TimeAFK > 60*5 then
            player:SetAttribute('AFK', true)
        end
        status.Frame.Bar.ImageLabel.Image = 'rbxassetid://15211434411'
        status.Frame.Bar.TextLabel.Text = `AFK {convertToHMS(data.TimeAFK)}`
    end
    status.Parent = head
end

function Nametag:KnitInit()
    self.status = {}
end

function Nametag:PlayerAdded(player)
    self.status[player] = 'afk'
end

function Nametag:PlayerRemoving(player)
    self.status[player] = nil
end

return Nametag
