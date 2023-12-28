local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Web = require(ReplicatedStorage.Packages.Web)
local Math = require(ReplicatedStorage.Packages.Math)

local UserFeedback = require(ReplicatedStorage.Events.Feedback.UserFeedback):Server()

local Feedback = Knit.CreateService {
    Name = "Feedback";
    Client = {};
}

function Feedback:SendFeedback(player, message)
    if message == "" then return end
    if string.len(message) < 20 then return end
    if string.len(message) > 250 then return end
    local name = player.Name
    local userId = player.UserId
    local sessionTime = math.floor(tick()-player:GetAttribute("JoinTick"))
    local inGameTime = Math.SecondsToHHMMSS(sessionTime)
    local totalPlaytime = Math.SecondsToDHMS(Knit.pd(player).Analytics.TotalTime+sessionTime)
    local robuxSpent = Math.Commas(Knit.pd(player).Analytics.RobuxSpent)
    Web.Send({
        URI = "https://webhook.lewisakura.moe/api/webhooks/1189831907270217728/4hnrRX2kbthsemsZxKQtkT_8PtOTkBIwZ5o24AuxjInSOrtrTXiBp9hGblaTMRP3NB7I";
        JSONData = {
            avatar_url = 'https://i.postimg.cc/q7bgxX4C/release-icon.png';
            username = 'Feedback';
            embeds = {
                {
                    title = `{message}\n\n`;
                    description = `\n**Player:** {name} [{userId}]\n**In-Game Time:** {inGameTime}\n**Total Playtime:** {totalPlaytime}\n**Robux Spent:** {robuxSpent}`;
                    color = tonumber('0x00FFFF');
                    footer = {
                        text = 'Feedback';
                        icon_url = 'https://i.postimg.cc/q7bgxX4C/release-icon.png';
                    };
                };
            };
        };
    })
end

function Feedback:PlayerAdded(player)
    self:SendFeedback(player, "maecenas sed enim ut sem viverra aliquet eget sit amet tellus cras adipiscing enim eu turpis egestas pretium aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros in cursus turpis massa tincidunt dui ut ornare lectus sit amet est placerat in egestas erat imperdiet sed euismod nisi porta lorem mollis aliquam ut porttitor leo a diam sollicitudin tempor id eu nisl nunc mi ipsum faucibus vitae aliquet nec ullamcorper sit amet risus nullam eget felis eget nunc lobortis mattis aliquam faucibus purus in massa tempor nec feugiat nisl pretium fusce id velit ut tortor pretium viverra suspendisse potenti nullam ac tortor vitae purus faucibus ornare suspendisse sed nisi lacus sed viverra tellus in hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus at augue eget arcu dictum varius duis at consectetur lorem donec massa sapien faucibus et molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices vitae auctor eu augue ut lectus arcu bibendum at varius vel pharetra vel turpis nunc eget lorem")
end

function Feedback:KnitStart()
    UserFeedback:On(function(player, message)
        self:SendFeedback(player, message)
    end)
end

return Feedback