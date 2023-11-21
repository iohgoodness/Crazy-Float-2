-- Timestamp // 11/18/2023 21:49:32 MNT
-- Author // @iohgoodness
-- Description // Sailing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

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
    self.btn(self.ui.Sailing.Frame.Frame.Submit, function()
        self:DisableAll()
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
end

return Sail
