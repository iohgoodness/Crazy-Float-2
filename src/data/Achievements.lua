
Achievements = {
	-- Placing Blocks
	Architect = {
		Order = 1;
		Data = {
			{50; 5};
			{100; 10};
			{500; 20};
			{1000; 50};
			{2500; 100};
		};
		Suffix = ' Blocks Placed';
	};
	-- spent how many
	Millionaire = {
		Order = 2;
		Data = {
			{1000; 5};
			{2500; 10};
			{5000; 20};
			{10000; 50};
			{20000; 200};
		};
		Prefix = '$';
		Suffix = ' Total';
	};
	-- How many gems you have earned
	['Gems Lord'] = {
		Order = 3;
		Data = {
			{200; 5};
			{500; 10};
			{1000; 20};
			{2500; 50};
			{5000; 100};
		};
		Suffix = ' Total Gems';
	};
	-- Sailed how many studs
	Sailor = {
		Order = 4;
		Data = {
			{100; 5};
			{500; 10};
			{1000; 20};
			{2000; 50};
			{3000; 100};
		};
		Suffix = ' Studs';
	};
	-- Plot Owner
	['Plot Owner'] = {
		Order = 5;
		Data = {
			{2; 5};
			{4; 10};
			{6; 20};
			{8; 50};
			{11; 100};
		};
		Suffix = ' Plots Owned';
	};
	-- trade
	Negotiator = {
		Order = 6;
		Data = {
			{1; 5};
			{5; 10};
			{20; 20};
			{50; 50};
			{100; 100};
		};
		Suffix = ' Trades Completed';
	};
};

return {
	
	Achievements = Achievements;
	
	GetDefault = function()
		local default = {}
		for achName,_ in pairs(Achievements) do
			default[achName] = 0
		end
		return default
	end;
	
}