-- Timestamp // 11/18/2023 21:49:32 MNT
-- Author // @iohgoodness
-- Description // Sailing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local Sail = Knit.CreateController { Name = "Sail" }

local PremiumShop = Knit.cfg.PremiumShop

-- 0.05, 0

function Sail:Enable(option, amount)
    self.ui.Sailing.Frame.Options[option].Enabled.Text = `2X {option} ENABLED! (x{amount})`
    -- refresh
    self.tween(self.ui.Sailing.Frame.Options[option].Enabled, {BackgroundTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options[option].Enabled, {TextTransparency = 1})
    task.wait(.22)
    self.tween(self.ui.Sailing.Frame.Options[option].Enabled, {BackgroundTransparency = 0.05})
    self.tween(self.ui.Sailing.Frame.Options[option].Enabled, {TextTransparency = 0})
end

function Sail:DisableAll()
    self.tween(self.ui.Sailing.Frame.Options['Coins'].Enabled, {BackgroundTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options['Coins'].Enabled, {TextTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options['Gems'].Enabled, {BackgroundTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options['Gems'].Enabled, {TextTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options['HP'].Enabled, {BackgroundTransparency = 1})
    self.tween(self.ui.Sailing.Frame.Options['HP'].Enabled, {TextTransparency = 1})
end

function Sail:UpdateRoster(roster)
    -- remove players, log already added
    local alreadyAdded = {}
    for index=1, 16 do
        local frame = self.ui.GameUI.Frame.Tab[index%2==0 and 'Even' or 'Odd']
        local playerSlot = frame[index]
        local playerName = playerSlot:GetAttribute('Player')
        if playerName then
            if not table.find(roster, playerName) then
                playerSlot:SetAttribute('Player', nil)
                Thread.Spawn(function()
                    self.tween(playerSlot, {ImageTransparency = 1})
                    task.wait(.21)
                    playerSlot.Visible = false
                end)
            else
                table.insert(alreadyAdded, playerName)
            end
        end
    end
    -- any not already added, add
    for index=1, #roster do
        local frame = self.ui.GameUI.Frame.Tab[index%2==0 and 'Even' or 'Odd']
        local playerSlot = frame[index]
        local playerName = roster[index]
        if not table.find(alreadyAdded, playerName) and not playerSlot:GetAttribute('Player') then
            playerSlot:SetAttribute('Player', playerName)
            local player = Players:FindFirstChild(playerName)
            playerSlot.Image = Knit.shared.Web.GetHeadshot(player.UserId) or 'rbxassetid://15460201085'
            playerSlot.Visible = true
            Thread.Spawn(function()
                self.tween(playerSlot, {ImageTransparency = 0})
            end)
        end
    end
end

function Sail:KnitStart()
    local options = self.ui.Sailing.Frame.Options
    self.cycle(options, function(btn)
        self.btn(btn, function()
            if btn.Name == 'Gems' then
                if Knit.popup('interactive', `Are you sure you want to spend <font color="#eb0bcd">{PremiumShop.Sailing[btn.Parent.Name].Gems} Gems</font> to sail for <font color="#eb0bcd">2x {btn.Parent.Name}</font>?`, 'NO', 'YES') then
                    self.service:SailingDevproducts(btn.Parent.Name):andThen(function(response, amount)
                        if response == true then
                            self:Enable(btn.Parent.Name, amount)
                        elseif response == 'Not Enough Gems' then
                            Knit.popup('okay', `You do not have enough Gems to purchase this.`)
                        else
                            Knit.popup('okay', 'An error occured while trying to purchase this.')
                        end
                    end)
                end
            elseif btn.Name == 'Robux' then
                MarketplaceService:PromptProductPurchase(Players.LocalPlayer, PremiumShop['Sailing'][btn.Parent.Name].ID)
            end
        end)
    end)
    self.lastDevproducts = {}
    self.service.Pull:Connect(function(devproducts)
        for option,amount in pairs(devproducts) do
            if amount>0 and self.lastDevproducts[option]~=amount then
                self:Enable(option, amount)
            end
        end
        self.lastDevproducts = devproducts
    end)
    self.service.UpdateGameUI:Connect(function(response)
        if response.Timer then
            self.ui.GameUI.Frame.Tab.Frame.TextLabel.Text = `SAILING IN {response.Timer} SECONDS`
        end
        if response.Roster then
            self:UpdateRoster(response.Roster)
        end
        if response.TimerWarning then
            if response.TimerWarning == 10 then
                self.ui.GameUI.Start.TextLabel.Text = 'SAILING IN 10 SECONDS'
                self.tween(self.ui.GameUI.Start.TextLabel, {TextTransparency = 0}, 1)
                task.wait(3)
                self.tween(self.ui.GameUI.Start.TextLabel, {TextTransparency = 1}, .21)
            elseif response.TimerWarning~=0 and response.TimerWarning <= 5 then
                self.ui.GameUI.Start.TextLabel.Text = `{response.TimerWarning}`
                self.tween(self.ui.GameUI.Start, {BackgroundTransparency = (Knit.shared.Math.Map(response.TimerWarning, 0, 5, 0, 1))}, 1.1)
                self.tween(self.ui.GameUI.Start.TextLabel, {TextTransparency = 0}, .21)
            elseif response.TimerWarning == 0 then
                self.ui.GameUI.Start.TextLabel.Text = 'HERE WE GO!'
                Knit.GetController('Front'):Hide() 
                task.wait(3)
                self.tween(self.ui.GameUI.Start, {BackgroundTransparency = 1}, .21)
                self.tween(self.ui.GameUI.Start.TextLabel, {TextTransparency = 1}, .21)
                self.ui.GameUI.Frame.Visible = false
                Knit.GetController('Building'):StopPlacing()
                self.ui.GameUI.Frame.Tab.Frame.TextLabel.Text = `SAILING IN PROGRESS`
            end
        end
    end)
    self.btn(self.ui.GameUI.Frame.Tab.Join, function()
        self.service:ToggleJoin():andThen(function(response)
            if response then
                self.ui.GameUI.Frame.Tab.Join.Tab.TextLabel.Text = 'Leave'
            else
                self.ui.GameUI.Frame.Tab.Join.Tab.TextLabel.Text = 'Join'
            end
        end)
    end)
end

return Sail
