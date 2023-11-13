-- Timestamp // 11/12/2023 10:48:27 MNT
-- Author // @iohgoodness
-- Description // Webhook control

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Webhooks = Knit.CreateService {
    Name = "Webhooks",
    Client = {},
}

local WEBHOOKS = {
    Logs = {
        Hook = 'https://webhook.lewisakura.moe/api/webhooks/1173316561042407424/ta1MuT0OutY9-hOUv7N_nMeKNGIWo4s5u6q5keU4kzq0nLIz0CpOsaBv7sfwAz9qSrRa';
        JSONData = {
            avatar_url = 'https://i.postimg.cc/q7bgxX4C/release-icon.png';
            username = 'Logger';
            embeds = {
                {
                    title = '🔇 MUTE';
                    description = '';
                    color = tonumber('0xf44336');
                    thumbnail = {
                        url = '';
                    };
                    fields = {
                        {
                            name = 'Offender';
                            value = '';
                        };
                        {
                            name = 'Reason';
                            value = '';
                        };
                        {
                            name = 'Action';
                            value = '';
                        };
                    };
                    footer = {
                        text = 'Mod Log';
                        icon_url = 'https://i.postimg.cc/q7bgxX4C/release-icon.png';
                    };
                };
            };
        };
    }
}

function Webhooks:Log(player, target, title, action, reason)
    local newJSONData = WEBHOOKS.Logs.JSONData
    newJSONData.embeds[1].title = `**{title}**`
    newJSONData.embeds[1].fields[1].value = `> **{target.Name}({target.UserId})**`
    newJSONData.embeds[1].fields[2].value = `> **{reason}**`
    newJSONData.embeds[1].fields[3].value = `> **{action}**`
    newJSONData.embeds[1].footer.text = `{player.Name}({player.UserId})`
    newJSONData.embeds[1].title = title
    self:Send(WEBHOOKS.Logs.Hook, HttpService:JSONEncode(newJSONData))
end

function Webhooks:GetHeadshot(userId)
    local httpService = game:GetService("HttpService")
    local URL = "https://thumbnails.roproxy.com/v1/users/avatar-bust?userIds=%s&size=150x150&format=Png&isCircular=true"
    local userID = userId
    local response
    local success, err = pcall(function()
        response = httpService:GetAsync(URL:format(userID))
    end)
    if not success then
        return
    end
    return httpService:JSONDecode(response).data[1].imageUrl
end

function Webhooks:Send(hook, JSONData)
    Thread.Spawn(function()
        local tries,sent = 0, false
        while tries < 3 and not sent do
            local success,_ = pcall(function()
                HttpService:PostAsync(hook, JSONData)
            end)
            if success then break end
            tries += 1
            task.wait(5)
        end
    end)
end

return Webhooks
