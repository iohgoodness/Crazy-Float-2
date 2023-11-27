return {

    GetHeadshot = function(userId)
        --[[ local httpService = game:GetService("HttpService")
        local URL = "https://thumbnails.roproxy.com/v1/users/avatar-bust?userIds=%s&size=150x150&format=Png&isCircular=true"
        local userID = userId
        local response
        local success, err = pcall(function()
            response = httpService:GetAsync(URL:format(userID))
        end)
        if not success then
            return
        end
        return httpService:JSONDecode(response).data[1].imageUrl ]]

        local Players = game:GetService("Players")
        local PLACEHOLDER_IMAGE = "rbxassetid://0" -- replace with placeholder image
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        return (isReady and content) or PLACEHOLDER_IMAGE
    end

}