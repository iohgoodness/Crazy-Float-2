local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))
local Interface = require(ReplicatedStorage.Packages.Interface)

local Popup = {}
Popup.__index = Popup

function Popup.new(uiName, data)
    local self = setmetatable({}, Popup)

    Interface.Setup(self, uiName)

    self.popupType = data.popupType
    self.frame = self.gui[self.popupType]
    self.okay = self.frame.Accept
    self.frame.Visible = true

    Interface.Blur(50)
    Interface.Toggle(self.gui, self.popupType)

    if self.popupType == "Okay" then
        Interface.Button(self.okay, function()
            Interface.Blur(0)
            task.wait(0.08)
            Knit.openui[uiName]:Destroy()
            Knit.openui[uiName] = nil
        end)
    end

    return self
end

function Popup:Destroy()
    if self.gui then Interface.Toggle(self.gui, self.popupType) end
    task.wait(.29)
    self.gui:Destroy()
    self = nil
end

return Popup