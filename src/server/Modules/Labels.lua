
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Thread = require(ReplicatedStorage.Packages.Thread)

local Labels = {}

Labels.Connections = {}

Labels.Disco = function(label)
    Labels.Connections[label] = Thread.DelayRepeat(0.05, function()
        if not label then Labels.Connections[label]:Disconnect() end
        label.TextColor3 = Color3.fromHSV(tick() % 20/20, 1, 1)
    end)
end

Labels.Glowing = function(label)
    local colorA = Color3.fromRGB(255, 115, 187)
    local colorB = Color3.fromRGB(96, 33, 66)
    Labels.Connections[label] = Thread.DelayRepeat(0.01, function()
        if not label then Labels.Connections[label]:Disconnect() end
        label.TextColor3 = colorA:Lerp(colorB, math.sin(tick() * (2*2)) / 2 + 0.5)
    end)
end

return Labels