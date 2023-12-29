
Blocks = {
	['Concrete Beam'] = {
		Rarity = 'Rare',
		Weight = 5.0,
		Value = 6.0,
		Durability = 8.0,
		CraftingTime = 120,
		LayoutOrder = 3,
	},
	['Concrete Half'] = {
		Rarity = 'Rare',
		Weight = 4.5,
		Value = 5.5,
		Durability = 8.0,
		CraftingTime = 110,
		LayoutOrder = 3,
	},
	['Concrete Square'] = {
		Rarity = 'Rare',
		Weight = 4.8,
		Value = 5.8,
		Durability = 7.5,
		CraftingTime = 100,
		LayoutOrder = 3,
	},
	['Concrete Triangle'] = {
		Rarity = 'Rare',
		Weight = 4.6,
		Value = 5.7,
		Durability = 7.0,
		CraftingTime = 90,
		LayoutOrder = 3,
	},
	['Concrete Window'] = {
		Rarity = 'Rare',
		Weight = 5.2,
		Value = 6.5,
		Durability = 8.5,
		CraftingTime = 130,
		LayoutOrder = 3,
	},
	['Plastic Beam'] = {
		Rarity = 'Common',
		Weight = 1.5,
		Value = 2.0,
		Durability = 3.0,
		CraftingTime = 30,
		LayoutOrder = 1,
	},
	['Plastic Square'] = {
		Rarity = 'Common',
		Weight = 1.6,
		Value = 2.1,
		Durability = 3.1,
		CraftingTime = 35,
		LayoutOrder = 1,
	},
	['Plastic Triangle'] = {
		Rarity = 'Common',
		Weight = 1.7,
		Value = 2.2,
		Durability = 3.2,
		CraftingTime = 40,
		LayoutOrder = 1,
	},
	['Plastic Window'] = {
		Rarity = 'Common',
		Weight = 1.8,
		Value = 2.3,
		Durability = 3.3,
		CraftingTime = 45,
		LayoutOrder = 1,
	},
	['Steel Beam'] = {
		Rarity = 'Epic',
		Weight = 6.5,
		Value = 9.0,
		Durability = 10.0,
		CraftingTime = 180,
		LayoutOrder = 4,
	},
	['Steel Half'] = {
		Rarity = 'Epic',
		Weight = 6.4,
		Value = 8.9,
		Durability = 9.9,
		CraftingTime = 175,
		LayoutOrder = 4,
	},
	['Steel Square'] = {
		Rarity = 'Epic',
		Weight = 6.6,
		Value = 9.1,
		Durability = 10.1,
		CraftingTime = 185,
		LayoutOrder = 4,
	},
	['Steel Square 2'] = {
		Rarity = 'Epic',
		Weight = 6.7,
		Value = 9.2,
		Durability = 10.2,
		CraftingTime = 190,
		LayoutOrder = 4,
	},
	['Steel Triangle'] = {
		Rarity = 'Epic',
		Weight = 6.3,
		Value = 8.8,
		Durability = 9.8,
		CraftingTime = 170,
		LayoutOrder = 4,
	},
	['Steel Window'] = {
		Rarity = 'Epic',
		Weight = 6.8,
		Value = 9.3,
		Durability = 10.3,
		CraftingTime = 195,
		LayoutOrder = 4,
	},
	['Wood Beam'] = {
		Rarity = 'Uncommon',
		Weight = 3.0,
		Value = 3.5,
		Durability = 5.0,
		CraftingTime = 60,
		LayoutOrder = 2,
	},
	['Wood Half'] = {
		Rarity = 'Uncommon',
		Weight = 2.9,
		Value = 3.4,
		Durability = 4.9,
		CraftingTime = 55,
		LayoutOrder = 2,
	},
	['Wood Square'] = {
		Rarity = 'Uncommon',
		Weight = 3.1,
		Value = 3.6,
		Durability = 5.1,
		CraftingTime = 65,
		LayoutOrder = 2,
	},
	['Wood Triangle'] = {
		Rarity = 'Uncommon',
		Weight = 2.8,
		Value = 3.3,
		Durability = 4.8,
		CraftingTime = 50,
		LayoutOrder = 2,
	},
	['Wood Window'] = {
		Rarity = 'Uncommon',
		Weight = 3.2,
		Value = 3.7,
		Durability = 5.2,
		CraftingTime = 70,
		LayoutOrder = 2,
	},
};

return {
	
	Blocks = Blocks;
	
	Rarity = {
		Common = Color3.fromRGB(157, 157, 157), -- Gray
		Uncommon = Color3.fromRGB(30, 200, 30), -- Green
		Rare = Color3.fromRGB(0, 112, 221), -- Blue
		Epic = Color3.fromRGB(163, 53, 238), -- Purple
		Legend = Color3.fromRGB(255, 128, 0), -- Orange
	};
	
	GetMax = function(amount)
		local tbl = {}
		for k,v in pairs(Blocks) do
			tbl[k] = amount or 99
		end
		return tbl
	end,
}