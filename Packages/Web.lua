local HttpService = game:GetService("HttpService")

return {

    GetHeadshot = function(userId)
        local Players = game:GetService("Players")
        local PLACEHOLDER_IMAGE = "rbxassetid://0" -- replace with placeholder image
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        return (isReady and content) or PLACEHOLDER_IMAGE
    end;

    Send = function(data)
        local URI = data.URI
        local JSONData = data.JSONData
        local success, err = pcall(function()
            HttpService:PostAsync(URI, HttpService:JSONEncode(JSONData))
        end)
    end;

    ImportantSend = function()

    end;

}