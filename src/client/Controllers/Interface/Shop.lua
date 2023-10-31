-- Timestamp // 10/29/2023 09:48:51 MNT
-- Author // @iohgoodness
-- Description // Shop Controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Shop = Knit.CreateController { Name = "Shop" }

local cfg = Knit.cfg.PremiumShop

local SecondsToDHMS = Knit.shared.Math.SecondsToDHMS

function Shop:KnitStart()
    local Animation = Knit.GetController('Animation')
    self.service.PushPurchased:Connect(function(itemType, scale)
        Animation:Fountain(itemType, scale)
    end)
    self.limitedItems = {}
    self.service.PushLimited:Connect(function(limitedItems, timer)
        self.ui.PremiumShop.Frame.Top.Limited.Tab.Timer.Text = SecondsToDHMS(timer)
        if self.limitedItems ~= limitedItems and #limitedItems>0 then
            for i=1, 4 do
                local item = self.ui.PremiumShop.Frame.Limited.Bottom[tostring(i)]
                local data = limitedItems[i]
                item.Title.Text = data.Title
                item.LayoutOrder = tonumber(data.Gems)
                item.Desc.Text = data.Desc
                item.Tab.Tab.TextLabel.Text = data.Gems
            end
        end
    end)
    for _,v in pairs({'Coins', 'Gems'}) do
        for i=1, 3 do
            local item = self.ui.PremiumShop.Frame[v].Top[tostring(i)]
            local data = cfg[v][i]
            item.Tab.TextLabel.Text = (v == 'Coins' and `${data.Desc}` or `{data.Desc} 💎`)
            item.Tab.Tab.TextLabel.Text = data.Price
            self.btn(item, function()
                MarketplaceService:PromptProductPurchase(Players.LocalPlayer,data.ID)
            end)
        end
        for i=4, 7 do
            local item = self.ui.PremiumShop.Frame[v].Bottom[tostring(i)]
            local data = cfg[v][i]
            item.Tab.TextLabel.Text = (v == 'Coins' and `${data.Desc}` or `{data.Desc} 💎`)
            item.Tab.Tab.TextLabel.Text = data.Price
            self.btn(item, function()
                MarketplaceService:PromptProductPurchase(Players.LocalPlayer,data.ID)
            end)
        end
    end
    for _,button in pairs(self.ui.PremiumShop.Frame.Top:GetChildren()) do
        if not button:IsA("ImageButton") then continue end
        self.btn(button, function()
            for _,btn in pairs(self.ui.PremiumShop.Frame.Top:GetChildren()) do
                if not btn:IsA("ImageButton") then continue end
                btn.UIStroke.Thickness = 0
            end
            button.UIStroke.Thickness = 4
            for _,frame in pairs(self.ui.PremiumShop.Frame:GetChildren()) do
                if not frame:IsA("Frame") then continue end
                if frame.Name == 'Top' or frame.Name == 'Frame' then continue end
                frame.Visible = false
            end
            self.ui.PremiumShop.Frame[button.Name].Visible = true
        end)
    end
end

return Shop
