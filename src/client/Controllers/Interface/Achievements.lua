-- Timestamp // 11/08/2023 19:57:31 MNT
-- Author // @iohgoodness
-- Description // Controller for achivements

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local Achievements = Knit.CreateController { Name = "Achievements" }

local cfg = Knit.cfg.Achievements

local function romanNumeral(int)
    local numerals = {
        {1000, "M"},
        {900, "CM"},
        {500, "D"},
        {400, "CD"},
        {100, "C"},
        {90, "XC"},
        {50, "L"},
        {40, "XL"},
        {10, "X"},
        {9, "IX"},
        {5, "V"},
        {4, "IV"},
        {1, "I"},
    }
    local roman = ""
    for _,v in ipairs(numerals) do
        while int >= v[1] do
            roman ..= v[2]
            int -= v[1]
        end
    end
    return roman
end

function Achievements:KnitStart()
    local template = self.cd(self.ui.Achievements.Frame.Frame.Achievements.Achievements.Template)
    self.service.PushValues:Connect(function(values)
        print(values)
        for achName,achData in pairs(cfg.Achievements) do
            local foundTemplate = self.ui.Achievements.Frame.Frame.Achievements.Achievements:FindFirstChild(achName)
            if foundTemplate then
                local tIndex = 1
                for _,v in ipairs(achData.Data) do
                    if values[achName] <= v[1] then
                        break
                    end
                    tIndex+=1
                end
                tIndex = math.clamp(tIndex, 1, #achData.Data)
                foundTemplate.TextLabel.Text = `{achName} {romanNumeral(tIndex)}`
                self.tween(foundTemplate.Progress.Fill, {Size = UDim2.fromScale(math.clamp(values[achName] / achData.Data[tIndex][1], 0, 1), 1)}, 0.21)
                foundTemplate.Progress.TextLabel.Text = `{achData.Prefix or ''}{values[achName]}{achData.Suffix or ''} / {achData.Prefix or ''}{achData.Data[tIndex][1]}{achData.Suffix or ''}`
            else
                local newTemplate = template:Clone()
                newTemplate.Name = achName
                local tIndex = 1
                for _,v in ipairs(achData.Data) do
                    if values[achName] <= v[1] then
                        break
                    end
                    tIndex+=1
                end
                tIndex = math.clamp(tIndex, 1, #achData.Data)
                newTemplate.TextLabel.Text = `{achName} {romanNumeral(tIndex)}`
                self.tween(newTemplate.Progress.Fill, {Size = UDim2.fromScale(math.clamp(values[achName] / achData.Data[tIndex][1], 0, 1), 1)}, 0.21)
                newTemplate.Progress.TextLabel.Text = `{achData.Prefix or ''}{values[achName]}{achData.Suffix or ''} / {achData.Prefix or ''}{achData.Data[tIndex][1]}{achData.Suffix or ''}`
                newTemplate.LayoutOrder = achData.Order
                newTemplate.Parent = self.ui.Achievements.Frame.Frame.Achievements.Achievements
            end
        end
    end)
end

return Achievements
