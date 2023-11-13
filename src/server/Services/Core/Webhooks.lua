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
    MOD_LOGGING = {
        Hook = 'https://webhook.lewisakura.moe/api/webhooks/1158183177744039997/32uhnO-dL-8BZVRmd9AXsOjnMxg-651uij5GJ6e9OPBE5CVko4W5j4ga6DxOGfREXdbM';
        JSONData = {
            avatar_url = 'https://i.postimg.cc/qRSNz1Zw/gifgit-3.gif';
            username = 'MOD LOGS';
            embeds = {
                {
                    title = '・Player {X} gave to Player {Y}.\n・Gave x{count} {item}.';
                    description = '';
                    color = tonumber('0xD98EFF');
                };
            };
        };
    };
}

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
