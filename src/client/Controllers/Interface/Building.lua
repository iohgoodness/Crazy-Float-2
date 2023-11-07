-- Timestamp // 11/01/2023 23:29:06 MNT
-- Author // @iohgoodness
-- Description // Building controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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
            task.wait(.11)
            self.tween(button, {BackgroundColor3 = Color3.fromRGB(3, 124, 57)}, .1)
            self.service:ChangeBoat(tonumber(button.Name))
        end)
    end)
    local q,e = false,false
    local qt,et = 0,0
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if self.ghostObject then
                self:Place()
            elseif self.deleteHighlightObject then
                self.service:RemoveObject(tonumber(self.deleteHighlightObject.Name)):andThen(function(newInventoryData)
                    Knit.GetController('Inventory').inventory = newInventoryData
                    Knit.GetController('Inventory'):Load(self.ui.Building.Frame.Frame.Personal.Personal, function(item)
                        Knit.GetController('Building'):Placing(item.Name)
                    end)
                end)
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Q then
                q = true
            elseif input.KeyCode == Enum.KeyCode.E then
                e = true
            elseif input.KeyCode == Enum.KeyCode.C then
                self:StopPlacing()
            elseif input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Backspace then
                self:Deleting()
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
           if input.KeyCode == Enum.KeyCode.Q then
                q = false
                qt += 1
            elseif input.KeyCode == Enum.KeyCode.E then
                e = false
                et += 1
            end
        end
    end)
    local counter = 0
    RunService.RenderStepped:Connect(function(dt)
        counter += dt
        if counter > self.doubletapcd then
            if qt >= 2 then
                self.ghostY = 0
            end
            if et >= 2 then
                self.ghostY = 0
            end
            qt,et = 0,0
            counter = 0
        end
        if q then
            self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY - self.inc
        end
        if e then
            self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY + self.inc
        end
    end)
    self.raycastParams = RaycastParams.new()
    self.raycastParams.FilterDescendantsInstances = {workspace.Island.Ghost, workspace.Characters}
    self.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    self.raycastParams.IgnoreWater = true

    self.btn(self.ui.Building.Frame.Placing.Personal.Trash, function()
        self:Deleting()
    end)
    self.btn(self.ui.Building.Frame.Placing.Personal.Place, function()
        self:Place()
    end)
    self.btn(self.ui.Building.Frame.Placing.Personal.Y, function()
        self.ghostY = (self.ghostY==360-self.inc) and 0 or self.ghostY + 360/10 --[[ self.inc ]]
    end)
end

function Building:Delete()

end

function Building:Place()
    if not self.ghostObject then return end
    local data = {
        #workspace.Island.Grids[Players.LocalPlayer.Name].Objects:GetChildren();
        self.ghostObject.Name;
        CFrame.new(self.ghostObjectSpringPosition.Target) * CFrame.Angles(math.rad(self.ghostObjectSpringRotation.Position.X), math.rad(self.ghostObjectSpringRotation.Position.Y), math.rad(self.ghostObjectSpringRotation.Position.Z));
    }
    self.service:AddObject(data):andThen(function(newInventoryData)
        self:StopPlacing()
        Knit.GetController('Inventory').inventory = newInventoryData
        Knit.GetController('Inventory'):Load(self.ui.Building.Frame.Frame.Personal.Personal, function(item)
            Knit.GetController('Building'):Placing(item.Name)
        end)
        self:Placing()
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
    self.cycle(self.ui.Building.Frame.Frame.Personal.Personal, function(btn)
        self.tween(btn, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
    end)
end

function Building:StopDeleting()
    if self.deletingconn then
        self.deletingconn:Disconnect()
        self.deletingconn = nil
    end
    if self.deleteHighlight then
        self.deleteHighlight:Destroy()
    end
    self.tween(self.ui.Building.Frame.Placing.Personal.Trash, {BackgroundColor3 = Color3.fromRGB(189, 255, 197)}, .1)
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
    if not itemName then itemName = self.lastItem end
    if Knit.GetController('Inventory').inventory[itemName] == 0 then return self:StopPlacing() end
    self.ghostObject = ReplicatedStorage.Assets.Physical.Building.Blocks[itemName]:Clone()
    self.ghostObject.PrimaryPart.Transparency = 1
    self.ghostObject:PivotTo(Players.LocalPlayer.Character:GetPivot())
    self.ghostObject.Parent = workspace.Island.Ghost
    for _,v in pairs(self.ghostObject:GetDescendants()) do
        if not v:IsA('BasePart') then continue end
        v.CanCollide = false
    end
    self.ghostObjectSpringPosition = Spring.new(self.ghostObject.PrimaryPart.Position)
    self.ghostObjectSpringRotation = Spring.new(Vector3.new())
    self.ghostObjectSpringPosition.Speed = 15
    self.ghostObjectSpringPosition.Damper = .75
    self.ghostObjectSpringRotation.Speed = 15
    self.ghostObjectSpringRotation.Damper = .75
    local mouse = self.mouse
    self.placingconn = RunService.RenderStepped:Connect(function()
        local hit = self:GetMouseHit()
        if mouse.Target and hit and self.placingconn then
            self.ghostObjectSpringPosition.Target = hit.Position
            self.ghostObjectSpringRotation.Target = Vector3.new(self.ghostX, self.ghostY, self.ghostZ)
            self.ghostCFrame = CFrame.new(self.ghostObjectSpringPosition.Position) * CFrame.Angles(math.rad(self.ghostObjectSpringRotation.Position.X), math.rad(self.ghostObjectSpringRotation.Position.Y), math.rad(self.ghostObjectSpringRotation.Position.Z))
            self.ghostObject:PivotTo(self.ghostCFrame)
        end
    end)
    self.lastItem = itemName
end

function Building:GetObjectModel(part)
    while part:GetAttribute('Object')==nil and part~=Workspace do
        part = part.Parent
    end
    return part==Workspace and nil or part
end

function Building:Deleting()
    if self.placingconn then self:StopPlacing() end
    if self.deletingconn then self:StopDeleting() return end
    self.tween(self.ui.Building.Frame.Placing.Personal.Trash, {BackgroundColor3 = Color3.fromRGB(3, 124, 57)}, .1)
    local mouse = self.mouse
    self.deletingconn = RunService.RenderStepped:Connect(function(dt)
        local hit = self:GetMouseHit()
        if mouse.Target and hit and self.deletingconn then
            local object = self:GetObjectModel(mouse.Target)
            if object and object~=Workspace and object:FindFirstChild('Highlight')==nil then
                if self.deleteHighlightObject and self.deleteHighlightObject ~= object and self.deleteHighlightObject:FindFirstChild('Highlight') then
                    self.deleteHighlightObject.Highlight:Destroy()
                end
                self.deleteHighlight = Instance.new('Highlight')
                self.deleteHighlight.Parent = object
                self.deleteHighlight.Adornee = object
                self.deleteHighlightObject = object
            elseif (object:FindFirstChild('Highlight') and not object or object==Workspace) then
                if self.deleteHighlight then
                    self.deleteHighlight:Destroy()
                end
            end
        end
    end)
end

return Building
