-- Timestamp // 11/01/2023 23:29:06 MNT
-- Author // @iohgoodness
-- Description // Building controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Building = Knit.CreateController { Name = "Building" }

local Spring = Knit.shared.Spring

function Building:KnitStart()
    self.mouse = game.Players.LocalPlayer:GetMouse()
    self.ghostObject = nil
    self.ghostCFrame = nil
    self.ghostX = 0
    self.ghostY = 0
    self.ghostZ = 0
    self.selectedBoat = 1
    self.inc = 30
    self.cycle(self.ui.Building.Frame.Plot.Personal.Personal, function(button)
        self.btn(button, function()
            self.cycle(self.ui.Building.Frame.Plot.Personal.Personal, function(btn)
                self.tween(btn.Tab.UIStroke, {Color = Color3.new(255, 255, 255)})
            end)
            button.Tab.UIStroke.Color = Color3.fromRGB(0, 0, 0)
            self.service:ChangeBoat(tonumber(button.Name))
        end)
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.ghostObject then
                self:Place()
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Z then
                self.ghostX = (self.ghostX==360-self.inc) and 0 or self.ghostX + self.inc
            elseif input.KeyCode == Enum.KeyCode.X then
                self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY + self.inc
            elseif input.KeyCode == Enum.KeyCode.C then
                self.ghostZ = (self.ghostZ==360-self.inc) and 0 or self.ghostZ + self.inc
            end
        end
    end)
    self.raycastParams = RaycastParams.new()
    self.raycastParams.FilterDescendantsInstances = {workspace.Island.Ghost, workspace.Characters}
    self.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    self.raycastParams.IgnoreWater = true
end

function Building:Place()
    if not self.ghostObject then return end
    self.service:AddObject({#workspace.Island.Grids[Players.LocalPlayer.Name].Objects:GetChildren(), self.ghostObject.Name, self.ghostObject:GetPivot()}):andThen(function()
        self:StopPlacing()
    end)
end

function Building:StopPlacing()
    if self.placingconn then
        self.placingconn:Disconnect()
        self.placingconn = nil
    end
    if self.ghostObject then
        self.ghostObject:Destroy()
        self.ghostObject = nil
    end
    if self.ghostObjectSpringPosition then
        self.ghostObjectSpringPosition = nil
    end
    if self.ghostObjectSpringRotation then
        self.ghostObjectSpringRotation = nil
    end
end

function Building:GetMouseHit()
    local mouse = UserInputService:GetMouseLocation()
    local ray = workspace.Camera:ViewportPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, self.raycastParams)
    if result then
        return CFrame.new(result.Position)
    end
end

function Building:Placing(itemName)
    self.ghostObject = ReplicatedStorage.Assets.Physical.Building.Blocks[itemName]:Clone()
    self.ghostObject:PivotTo(CFrame.new())
    self.ghostObject.Parent = workspace.Island.Ghost
    for _,v in pairs(self.ghostObject:GetDescendants()) do
        if not v:IsA('BasePart') then continue end
        v.Transparency = 0
        v.CanCollide = false
    end
    self.ghostObjectSpringPosition = Spring.new(Vector3.new())
    self.ghostObjectSpringRotation = Spring.new(Vector3.new())
    self.ghostObjectSpringPosition.Speed = 25
    self.ghostObjectSpringPosition.Damper = 1
    self.ghostObjectSpringRotation.Speed = 25
    self.ghostObjectSpringRotation.Damper = 1
    local mouse = self.mouse
    self.placingconn = RunService.RenderStepped:Connect(function(dt)
        local hit = self:GetMouseHit()
        if mouse.Target and hit then
            self.ghostObjectSpringPosition.Target = hit.Position
            self.ghostObjectSpringRotation.Target = Vector3.new(self.ghostX, self.ghostY, self.ghostZ)
            self.ghostCFrame = CFrame.new(self.ghostObjectSpringPosition.Position) * CFrame.Angles(math.rad(self.ghostObjectSpringRotation.Position.X), math.rad(self.ghostObjectSpringRotation.Position.Y), math.rad(self.ghostObjectSpringRotation.Position.Z))
            self.ghostObject:PivotTo(self.ghostCFrame)
        end
    end)
end

return Building
