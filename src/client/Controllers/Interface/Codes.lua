-- Timestamp // 10/24/2023 21:50:08 MNT
-- Author // @iohgoodness
-- Description // Codes redeeming

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Codes = Knit.CreateController { Name = "Codes" }

function Codes:KnitStart()
    self.btn(self.ui.Codes.Frame.Frame.Submit, function()
        local code = self.ui.Codes.Frame.Frame.Frame.Tab.Text
        if code == "" then return end
        self.service:SubmitCode(code):andThen(function(response)
            Thread.Spawn(function()
                if response == 'Success!' then
                    self.toggle('Codes')
                end
            end)
            self.txtswap(self.ui.Codes.Frame.Frame.Frame.Tab, response, '')
        end)
    end)
end

return Codes
