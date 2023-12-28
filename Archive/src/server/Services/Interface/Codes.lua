-- Timestamp // 10/29/2023 09:32:31 MNT
-- Author // @iohgoodness
-- Description // Codes Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Codes = Knit.CreateService {
    Name = "Codes",
    Client = {
        TestRemote = Knit.CreateUSignal();
    },
}

local CodesData = require(ServerStorage.Private.Codes)

function Codes:Redeem(player, codeData)
    if codeData.Coins then
        Knit.GetService('Values'):AddMoney(player, codeData.Coins, true)
    end
    if codeData.Gems then
        Knit.GetService('Values'):AddGems(player, codeData.Gems, true)
    end
    if codeData.Blocks then

    end
end

function Codes.Client:SubmitCode(player, code)
    local codeData = CodesData[string.upper(code)]
    if not codeData then return 'Code Not Found' end
    if Knit.pd(player).RedeemedCodes[code] then return 'Already Used' end
    if not codeData.Reusable then
        Knit.pd(player).RedeemedCodes[code] = true
    end
    Codes:Redeem(player, codeData)
    return 'Success!'
end

function Codes:KnitStart()
    --[[ self.Client.TestRemote:Connect(function(player)
        print(player)
    end) ]]
end

return Codes
