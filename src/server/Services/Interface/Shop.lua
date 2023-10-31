-- Timestamp // 10/29/2023 09:49:04 MNT
-- Author // @iohgoodness
-- Description // Shop Service

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Thread = require(ReplicatedStorage.Packages.Thread)

local cfgGifts = Knit.cfg.Gifts
local cfg = Knit.cfg.PremiumShop

local Shop = Knit.CreateService {
    Name = "Shop",
    Client = {
        PushPurchased = Knit.CreateSignal();
        PushLimited = Knit.CreateSignal();
    },
}

local wordBank = {
    "BlueSky8", "WanderingEagle", "PaperMoon", "FuzzyLlama77", "SilverStream", "DoodleDuck4",
    "QuietMist", "MangoTango123", "WobblyPenguin", "CrispLeaf", "GoldenHaze91", "TwilightTrekker",
    "LostPebble", "OceanDreams", "SunnyPickle", "StarryDino", "PolarBear22", "DustyRoses",
    "TangledWebb", "WhisperWoods", "JumpingJellybean", "MoonlitMeadow", "SpiralStaircase",
    "FrozenFlame", "TickingClock", "ChirpingCheer", "BubblingBrook9", "WindyWillow",
    "SilentSnowflake", "DreamyDolphin", "RapidRabbit", "SilverSunset", "CrimsonCloud5",
    "DappledDawn", "LaughingLemon", "PonderingPine", "MurmuringMango", "GigglingGrapes",
    "EagerElephant", "FloatingFeather", "TwistedTeacup", "BouncingBubble", "GlisteningGrove",
    "LuckyLavender", "PerkyPineapple", "ZigzagZebra", "WaryWalrus", "PricklyPear3",
    "VelvetViolet", "SleepySloth", "RustyRaven", "GalacticGuitar", "MysticMushroom",
    "NimbleNewt", "BrightBamboo", "CleverCactus", "ScurryingSquirrel", "MeanderingMantis",
    "HarmoniousHawk", "DazzlingDaisy", "LustrousLynx", "MajesticMaple", "BreezyBison",
    "ElusiveEcho", "WanderingWhale", "PleasantPebble", "RockingRobin", "PristinePinecone",
    "WhimsicalWren", "CuriousKoala", "CharmingChameleon", "BashfulBulldog", "GentleGazelle",
    "VividVista", "GracefulGrasshopper", "DelicateDewdrop", "BoldBasil", "HastyHummingbird",
    "CautiousCat", "MellowMeadow", "RadiantRainbow", "CheeryCherry", "DashingDolphin",
    "HopefulHedgehog", "JubilantJackal", "LightheartedLlama", "MerryMango", "NostalgicNightingale",
    "OptimisticOwl", "PlayfulPanda", "QuizzicalQuokka", "ResilientRaccoon", "SillySeagull",
    "TranquilTurtle", "UpbeatUmbrella", "VivaciousVulture", "WholesomeWalnut", "ExuberantElephant",
    "YouthfulYucca", "ZealousZinnia", "AdventurousApple", "BubblyBee", "CheerfulCheetah",
    "DynamicDuck", "EffervescentElm", "FancifulFox", "GraciousGiraffe", "HeartfeltHedge",
    "InspiredIguana", "JovialJuniper", "KeenKangaroo", "LuminousLark", "MindfulMoose",
    "NurturingNarwhal", "ObservantOtter", "PeacefulPenguin", "QuirkyQuartz", "ReflectiveRabbit",
    "SereneSwan", "ThoughtfulThrush", "UnderstandingUrchin", "VibrantVole", "WiseWeasel",
    "ExquisiteEagle", "YieldingYew", "ZappyZebra", "AmiableAnt", "BountifulButterfly",
    "ComposedCoyote", "DeterminedDove", "EarnestEchidna", "FreeFalcon", "GenerousGuppy",
    "HarmoniousHare", "ImaginativeIbis", "JoyfulJaguar", "KindKite", "LivelyLobster",
    "MusingMantis", "NobleNewt", "OpenOstrich", "PeacefulPanther", "QuaintQuail",
    "ReverentRat", "SteadfastStarling", "TenderToucan", "UnderstandingUakari", "VenerableViper",
    "WarmWalrus", "XenialX-ray", "YieldingYak", "ZealousZorse", "AffectionateAardvark",
    "BlissfulBat", "ConsiderateCougar", "DevotedDingo", "EagerEagle", "FriendlyFerret",
    "GratefulGoose", "HonestHeron", "InnocentIbis", "JoyousJellyfish", "KindheartedKookaburra",
    "LoyalLion", "MirthfulMeerkat", "NurturingNuthatch", "OptimisticOcelot", "PleasedPuma",
    "QuietQuetzal", "RespectfulRaven", "SincereSwallow", "TrustingTiger", "UnderstandingUguisu",
    "ValuableVicuna", "WelcomingWeasel", "ExaltedEgret", "YoungYak", "ZestfulZebu",
    "AmicableAlpaca", "BenevolentBison", "ContentCougar", "DignifiedDuck", "EnthusiasticEel",
    "FaithfulFalcon", "GlowingGorilla", "HappyHippopotamus", "InterestedIguanodon", "JoyfulJaguarundi"
}

function Shop:GiveGlobalGift(message)
    local success,_ = pcall(function()
        MessagingService:PublishAsync('ServerChat', `{message}`)
    end)
    if success then
        local _,_ = pcall(function()
            self.CrazyFloatStore:SetAsync("LastGivenGift", tick())
        end)
    end
end

function Shop:CreateNewLimitedItems(lastLimited)
    lastLimited = lastLimited or {}
    local newLimited = {}
    while #newLimited < 4 and not table.find(lastLimited, newLimited) do
        local item = cfg.Limited.Gems[math.random(1, #cfg.Limited.Gems)]
        if not table.find(newLimited, item) then
            table.insert(newLimited, item)
        end
    end
    return newLimited
end

function Shop:KnitStart()
    local productFunctions = {}

    self.CrazyFloatStore = DataStoreService:GetDataStore('CrazyFloatStore')
    local success, lastGivenGift = pcall(function()
        return self.CrazyFloatStore:GetAsync("LastGivenGift")
    end)
    if success and not lastGivenGift then
        local _,_ = pcall(function()
            self.CrazyFloatStore:SetAsync("LastGivenGift", tick())
        end)
    end

    local success, limitedItems = pcall(function()
        return self.CrazyFloatStore:GetAsync("LimitedItems")
    end)
    if success and not limitedItems then
        local _,_ = pcall(function()
            self.CrazyFloatStore:SetAsync("LimitedItems", {Items = self:CreateNewLimitedItems(); Timer = tick()})
        end)
    end

    local limitedRefresh = cfg.LimitedRefresh
    Thread.DelayRepeat(1, function()
        local success, limitedItems = pcall(function()
            return self.CrazyFloatStore:GetAsync("LimitedItems")
        end)
        if success and limitedItems then
            if limitedItems.Timer + limitedRefresh < tick() then
                self.CrazyFloatStore:SetAsync("LimitedItems", {Items = self:CreateNewLimitedItems(limitedItems); Timer = tick()})
                self.Client.PushLimited:FireAll(limitedItems.Items, math.clamp(limitedItems.Timer + limitedRefresh - tick(), 0, math.huge))
            else
                self.Client.PushLimited:FireAll(limitedItems.Items, math.clamp(limitedItems.Timer + limitedRefresh - tick(), 0, math.huge))
            end
        end
    end)

    local x,y = cfgGifts.Timers.Min, cfgGifts.Timers.Max
    Thread.Spawn(function()
        local delaytimer = math.random(x, y)
        while true do
            task.wait(delaytimer)
            pcall(function()
                _,lastGivenGift = pcall(function()
                    return self.CrazyFloatStore:GetAsync("LastGivenGift")
                end)
                if (tick() - lastGivenGift) > math.random(x, y) then
                    -- no gift given within the last 10 seconds, generate fake gift
                    success,_ = pcall(function()
                        self.CrazyFloatStore:SetAsync("LastGivenGift", tick())
                    end)
                    if success then
                        self:GiveGlobalGift(`[SERVER GIFT] {string.upper(wordBank[math.random(1, #wordBank)])} bought a Coin Wheelbarrow so everyone gets +{cfgGifts.Values.Coins} coins!`)
                    end
                end
            end)
            delaytimer = math.random(x, y)
        end
    end)

    for i,v in pairs(cfg.Coins) do
        productFunctions[v.ID] = function(receipt, player)
            Knit.GetService('Values'):AddMoney(player, v.Amount, true)
            if i == 7 then
                self:GiveGlobalGift(`[SERVER GIFT] {string.upper(player.Name)} bought a Coin Wheelbarrow so everyone gets +{cfgGifts.Values.Coins} coins!`)
            end
            return true
        end
    end
    for i,v in pairs(cfg.Gems) do
        productFunctions[v.ID] = function(receipt, player)
            Knit.GetService('Values'):AddGems(player, v.Amount, true)
            if i == 7 then
                self:GiveGlobalGift(`[SERVER GIFT] {string.upper(player.Name)} bought a [GEM ITEM] so everyone gets +{cfgGifts.Values.Gems} gems!`)
            end
            return true
        end
    end

    local function processReceipt(receiptInfo)
        local userId = receiptInfo.PlayerId
        local productId = receiptInfo.ProductId
        local player = Players:GetPlayerByUserId(userId)
        if player then
            local handler = productFunctions[productId]
            local success, result = pcall(handler, receiptInfo, player)
            if success then
                return Enum.ProductPurchaseDecision.PurchaseGranted
            else
                warn("Failed to process receipt:", receiptInfo, result)
            end
        end
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
    MarketplaceService.ProcessReceipt = processReceipt
end

return Shop
