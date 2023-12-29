
Data = {
	{Level = 1, Name = "New Sailor's Drift", XPThreshold = 0},
	{Level = 2, Name = "Breezy Crosswinds", XPThreshold = 95},
	{Level = 3, Name = "Tidal Apprentice", XPThreshold = 202},
	{Level = 4, Name = "Stern Navigator", XPThreshold = 323},
	{Level = 5, Name = "Cresting Cadet", XPThreshold = 457},
	{Level = 6, Name = "Buoyant Builder", XPThreshold = 604},
	{Level = 7, Name = "Gale Wrangler", XPThreshold = 764},
	{Level = 8, Name = "Wave Tamer", XPThreshold = 937},
	{Level = 9, Name = "Vortex Veteran", XPThreshold = 1123},
	{Level = 10, Name = "Currents Commander", XPThreshold = 1322},
	{Level = 11, Name = "Sea Explorer Elite", XPThreshold = 1534},
	{Level = 12, Name = "Squall Surpasser", XPThreshold = 1759},
	{Level = 13, Name = "Tempest Trailblazer", XPThreshold = 1997},
	{Level = 14, Name = "Deep Sea Sage", XPThreshold = 2248},
	{Level = 15, Name = "Mystic Tide Master", XPThreshold = 2512},
	{Level = 16, Name = "Gale Force Guardian", XPThreshold = 2789},
	{Level = 17, Name = "Tsunami Titan", XPThreshold = 3079},
	{Level = 18, Name = "Ocean Odyssey Overlord", XPThreshold = 3382},
	{Level = 19, Name = "Leviathan's Bane", XPThreshold = 3698},
	{Level = 20, Name = "Sea Sovereign", XPThreshold = 4027},
	{Level = 21, Name = "Eternal Captain", XPThreshold = 4370};
};

return {
	
	Data = Data;
	
	GetPlayerLevel = function(playerXP)
		local playerLevel = 1
		local playerName = "New Sailor's Drift"

		for i, levelInfo in ipairs(Data) do
			if playerXP >= levelInfo.XPThreshold then
				playerLevel = levelInfo.Level
				playerName = levelInfo.Name
			else
				break
			end
		end

		return playerLevel, playerName
	end;
	
}