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
    self.inc = 2
    self.doubletapcd = .200
    self.cycle(self.ui.Building.Frame.Plot.Personal.Personal, function(button)
        self.btn(button, function()
            self.cycle(self.ui.Building.Frame.Plot.Personal.Personal, function(btn)
                self.tween(btn, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
            end)
            task.wait(.1)
            task.wait(.12)
            self.tween(button, {BackgroundColor3 = Color3.fromRGB(3, 124, 57)}, .1)
            self.service:ChangeBoat(tonumber(button.Name))
        end)
    end)
    local x,y,z,q,e = false,false,false,false,false
    local xt,yt,zt,qt,et = 0,0,0,0,0
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.ghostObject then
                self:Place()
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Z then
                x = true
            elseif input.KeyCode == Enum.KeyCode.X then
                y = true
            elseif input.KeyCode == Enum.KeyCode.Q then
                q = true
            elseif input.KeyCode == Enum.KeyCode.E then
                e = true
            elseif input.KeyCode == Enum.KeyCode.C then
                z = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Z then
                x = false
                xt += 1
            elseif input.KeyCode == Enum.KeyCode.X then
                y = false
                yt += 1
            elseif input.KeyCode == Enum.KeyCode.Q then
                q = false
                qt += 1
            elseif input.KeyCode == Enum.KeyCode.E then
                e = false
                et += 1
            elseif input.KeyCode == Enum.KeyCode.C then
                z = false
                zt += 1
            end
        end
    end)
    local counter = 0
    RunService.RenderStepped:Connect(function(dt)
        counter += dt
        if counter > self.doubletapcd then
            if xt >= 2 then
                self.ghostX = 0
            end
            if yt >= 2 then
                self.ghostY = 0
            end
            if zt >= 2 then
                self.ghostZ = 0
            end
            if qt >= 2 then
                self.ghostY = 0
            end
            if et >= 2 then
                self.ghostY = 0
            end
            xt,yt,zt,qt,et = 0,0,0,0,0
            counter = 0
        end
        if x then
            self.ghostX = (self.ghostX==360-self.inc) and 0 or self.ghostX + self.inc
        end
        if y then
            self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY + self.inc
        end
        if z then
            self.ghostZ = (self.ghostZ==360-self.inc) and 0 or self.ghostZ + self.inc
        end
        if q then
            print 'q'
            self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY - self.inc
        end
        if e then
            print 'e'
            self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY + self.inc
        end
        --print(self.inc)
        --print(self.ghostY)
    end)
    self.raycastParams = RaycastParams.new()
    self.raycastParams.FilterDescendantsInstances = {workspace.Island.Ghost, workspace.Characters}
    self.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    self.raycastParams.IgnoreWater = true
end

function Building:Place()
    if not self.ghostObject then return end
    local data = {
        #workspace.Island.Grids[Players.LocalPlayer.Name].Objects:GetChildren();
        self.ghostObject.Name;
        CFrame.new(self.ghostObjectSpringPosition.Target) * CFrame.Angles(math.rad(self.ghostObjectSpringRotation.Position.X), math.rad(self.ghostObjectSpringRotation.Position.Y), math.rad(self.ghostObjectSpringRotation.Position.Z));
    }
    self.service:AddObject(data):andThen(function()
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
