local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Janitor = require(ReplicatedStorage.Packages.Janitor)

local UpdateCurrency = require(ReplicatedStorage.Events.Front.UpdateCurrency):Server()

local Front = Knit.CreateService {
    Name = "Front";
    Client = {};
}

function Front:CharacterAdded(character)
    character.Parent = workspace.Characters
end

function Front:PlayerAdded(player)
    local data = Knit.pd(player)

    self.janitor = Janitor.new()

    self.player = player
    self.character = self.player.Character or player.CharacterAdded:Wait()
    self.janitor:Add(self.player.CharacterAdded:Connect(function(character)
        self:CharacterAdded(character)
    end))
    self:CharacterAdded(self.character)

    UpdateCurrency:Fire(
        player,
        data.Leaderboards.Money,
        data.Leaderboards.Gems,
        data.Leaderboards.XP,
        data.Leaderboards.Level
    )
end

return Front