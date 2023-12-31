-- Timestamp // 10/28/2023 15:54:55 MNT
-- Author // @iohgoodness
-- Description // Notification Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Notification = Knit.CreateController { Name = "Notification" }

function Notification:KnitStart()
    self.btn(self.ui.Notification.Okay.Yes, function()
        Knit.popupAnswer = true
    end)
    self.btn(self.ui.Notification.Okay.X, function()
        Knit.popupAnswer = true
    end)
    self.btn(self.ui.Notification.Input.X, function()
        Knit.popupAnswer = false
    end)
    self.btn(self.ui.Notification.Input.Yes, function()
        if self.ui.Notification.Input.Frame.Tab.Text ~= '' then
            Knit.popupAnswer = self.ui.Notification.Input.Frame.Tab.Text
        end
    end)
    self.btn(self.ui.Notification.Interactive.Yes, function()
        Knit.popupAnswer = true
    end)
    self.btn(self.ui.Notification.Interactive.No, function()
        Knit.popupAnswer = false
    end)
    self.btn(self.ui.Notification.Interactive.X, function()
        Knit.popupAnswer = false
    end)
end

--[[

Knit.popup('okay', 'this is a test 2') : boolean
Knit.popup('interactive', 'this is an interactive test 3', 'ignore 1', 'accept 2') : boolean
Knit.popup('input', 'this is a test 2') : string

]]

return Notification
