-- Timestamp // 11/12/2023 18:32:25 MNT
-- Author // @iohgoodness
-- Description // Mod Access

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ModAccess = Knit.CreateController { Name = "ModAccess" }

function ModAccess:ConfigurePanel(panel, target)
    for _,frame in pairs({panel.SoftMutes, panel.HardMutes}) do
        self.cycle(frame, function(btn)
            self.btn(btn, function()
                local reason = Knit.popup('input', `Why are you muting {target} for {btn.Tab.TextLabel}?`, 'CONFIRM')
                if reason then
                    self.service:Action(target, `{btn.Name}{btn.Parent.Name}`, reason)
                end
            end)
        end)
    end
    self.btn(panel.Kick, function()
        local reason = Knit.popup('input', `Why are you kicking {target} for?`, 'CONFIRM')
        if reason then
            self.service:Action(target, `Kick`, reason)
        end
    end)
    self.btn(panel.MetoThem, function()
        local reason = Knit.popup('input', `Why are you teleporting to {target}?`, 'CONFIRM')
        if reason then
            self.service:Action(target, `MetoThem`, reason)
        end
    end)
    self.btn(panel.ThemToMe, function()
        local reason = Knit.popup('input', `Why are you teleporting {target} to you?`, 'CONFIRM')
        if reason then
            self.service:Action(target, `ThemToMe`, reason)
        end
    end)
    self.cycle(panel.Rollback, function(btn)
        self.btn(btn, function()
            local reason = Knit.popup('input', `Why are you muting {target} for {btn.Tab.TextLabel}?`, 'CONFIRM')
            if reason then
                self.service:Action(target, `{btn.Name}`, reason)
            end
        end)
    end)
end

function ModAccess:KnitStart()
    self.playerFrames = {}
    self.lastPanel = nil
    self.panel = self.cd(self.ui.ModAccess.Frame.Frame.Mod.Mod.Template.Template)
    self.playerFrame = self.cd(self.ui.ModAccess.Frame.Frame.Mod.Mod.Template)
end

function ModAccess:PlayerAdded(player)
    self.playerFrames[player] = self.playerFrame:Clone()
    self.playerFrames[player].Parent = self.ui.ModAccess.Frame.Frame.Mod.Mod
    self.playerFrames[player].TextLabel.Text = player.Name
    self.btn(self.playerFrames[player].View, function()
        if self.playerFrames[player].View.Tab.TextLabel.Text == 'VIEW' then
            self.lastPanel = self.panel:Clone()
            self:ConfigurePanel(self.lastPanel, Players:FindFirstChild(player.Name))
            self.lastPanel.Parent = self.playerFrames[player]
            self.playerFrames[player].View.Tab.TextLabel.Text = 'HIDE'
        else
            self.lastPanel:Destroy()
            self.playerFrames[player].View.Tab.TextLabel.Text = 'VIEW'
        end
    end)
end

function ModAccess:PlayerRemoving(player)
    self.playerFrames[player]:Destroy()
    self.playerFrames[player] = nil
end

return ModAccess
