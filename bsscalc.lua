-- ==============================================================================
-- 🐝 BSS ALL-IN-ONE CALCULATOR & ADVICE ENGINE
-- ==============================================================================
-- A mathematical and strategic guide for Bee Swarm Simulator resource management.
-- Output: Console Print()
-- ==============================================================================

local BSS_Calc = {}

-- ==============================================================================
-- 🧮 CORE MATH HELPER
-- ==============================================================================
-- Calculates the Binomial Probability of getting AT LEAST ONE success.
-- Formula: 1 - (1 - (1 / chance))^attempts
local function GetBinomialProbability(chance, attempts)
    if attempts <= 0 then return 0 end
    -- math.pow is used for exponents in Lua
    local probability = 1 - math.pow(1 - (1 / chance), attempts)
    return probability * 100 -- Return as a percentage
end

-- Formatting helper for cleaner output
local function PrintHeader(title)
    print("\n========================================")
    print(" " .. title)
    print("========================================")
end

-- ==============================================================================
-- 🍓 MODULE 1: TREAT & GIFTING
-- ==============================================================================
function BSS_Calc.GiftBee(rarity, fruitsOwned)
    PrintHeader("🍓 TREAT & GIFTING ANALYSIS")
    
    local oddsTable = {
        ["Rare"] = 8000,
        ["Epic"] = 10000,
        ["Legendary"] = 12000,
        ["Mythic"] = 24000
    }
    
    local chance = oddsTable[rarity]
    if not chance then
        print("[!] Error: Unknown rarity. Use Rare, Epic, Legendary, or Mythic.")
        return
    end

    local probPercent = GetBinomialProbability(chance, fruitsOwned)
    
    print(string.format("Target: Gifted %s Bee", rarity))
    print(string.format("Base Odds: 1 in %,d", chance))
    print(string.format("Fruits Owned: %,d", fruitsOwned))
    print(string.format("Probability of Success: %.2f%%", probPercent))
    print("----------------------------------------")
    
    -- Advice Engine
    if probPercent >= 90 then
        print("[💡 Advice]: Excellent odds! You are mathematically very safe to feed those fruits. Good luck with your gifted bee!")
    elseif probPercent >= 50 then
        print("[💡 Advice]: Decent odds, but still a coin toss. If you are feeling lucky, go for it, but be prepared for disappointment.")
    else
        print("[🚨 Advice]: DO NOT GAMBLE! The odds are against you (<50%). Save your fruits for crafting Extracts at the Blender, which guarantee progression.")
    end
end

-- ==============================================================================
-- 🍯 MODULE 2: BEEQUIP WAXING
-- ==============================================================================
function BSS_Calc.ApplyWax(waxType, itemValue)
    PrintHeader("🍯 BEEQUIP WAX ADVISOR")
    
    local waxStats = {
        ["Soft"]    = {success = 100, destroy = 0},
        ["Hard"]    = {success = 60,  destroy = 0},
        ["Caustic"] = {success = 25,  destroy = 75},
        ["Swirled"] = {success = 100, destroy = 0} -- Added standard BSS Swirled logic
    }
    
    local stats = waxStats[waxType]
    if not stats then
        print("[!] Error: Unknown wax type. Use Soft, Hard, Caustic, or Swirled.")
        return
    end

    print(string.format("Wax Type: %s Wax", waxType))
    print(string.format("Item Value: %s", itemValue))
    print(string.format("Success Rate: %d%% | Destroy Rate: %d%%", stats.success, stats.destroy))
    print("----------------------------------------")
    
    -- Advice Engine
    if waxType == "Caustic" then
        if itemValue == "High" then
            print("[⚠️ CRITICAL WARNING ⚠️]: STOP IMMEDIATELY! Do NOT put Caustic Wax on a high-value Beequip! A 75% destroy rate means you will almost certainly lose this rare item.")
            print("[💡 Advice]: Use Soft or Hard wax for safe, zero-risk upgrades on valuable gear.")
        else
            print("[💡 Advice]: Since this is a low-value item, you can risk the Caustic Wax for the massive buff. Just expect it to break.")
        end
    elseif waxType == "Hard" then
        print("[💡 Advice]: Hard wax is a solid choice. Even if it fails (40% chance), your item is perfectly safe. Good for mid-to-high value gear.")
    elseif waxType == "Soft" or waxType == "Swirled" then
        print("[💡 Advice]: Completely safe to apply! You have a 0% chance of destroying your Beequip.")
    end
end

-- ==============================================================================
-- 🧪 MODULE 3: ROYAL JELLY
-- ==============================================================================
function BSS_Calc.RollJelly(target, jelliesOwned)
    PrintHeader("🧪 ROYAL JELLY ROLLER")
    
    local targetOdds = {
        ["Legendary"] = 33,
        ["Gifted"]    = 250,
        ["Mythic"]    = 25000
    }
    
    local chance = targetOdds[target]
    if not chance then
        print("[!] Error: Unknown target. Use Legendary, Gifted, or Mythic.")
        return
    end

    local probPercent = GetBinomialProbability(chance, jelliesOwned)
    
    print(string.format("Target: %s", target))
    print(string.format("Base Odds: 1 in %,d", chance))
    print(string.format("Jellies Owned: %,d", jelliesOwned))
    print(string.format("Probability of Success: %.2f%%", probPercent))
    print("----------------------------------------")
    
    -- Advice Engine
    if target == "Mythic" then
        if jelliesOwned < 25000 then
            print("[🚨 Advice]: You have less than the statistical threshold (25k) to roll a Mythic. You are at a mathematical disadvantage. Only roll if you can afford to lose these jellies and get nothing!")
        elseif probPercent >= 63.2 then 
            -- 63.2% is roughly the chance of hitting a 1/X event in X attempts
            print("[💡 Advice]: You have enough jellies to cover the base odds. It's a solid time to attempt a Mythic roll, but remember RNG can still be cruel!")
        end
    elseif target == "Gifted" then
        if probPercent > 80 then
            print("[💡 Advice]: Great odds for a Gifted bee. Setting 'Require Gifted' on Auto-Jelly is heavily recommended.")
        else
            print("[💡 Advice]: You might burn through your jellies without getting a Gifted. Proceed with caution.")
        end
    elseif target == "Legendary" then
        print("[💡 Advice]: Legendary rolling is incredibly easy. You should have no problem hitting this.")
    end
end


-- ==============================================================================
-- 🛠️ EXAMPLES / TEST CALLS
-- ==============================================================================
-- Uncomment or modify these lines to test the engine!

-- Test 1: Trying to get a Mythic Gifted Bee with 10,000 strawberries
BSS_Calc.GiftBee("Mythic", 10000)

-- Test 2: Being reckless with Caustic Wax on a rare Peppermint Antenna
BSS_Calc.ApplyWax("Caustic", "High")

-- Test 3: Rolling for a Mythic Bee with only 5,000 Royal Jellies
BSS_Calc.RollJelly("Mythic", 5000)

-- Test 4: Safe rolling for a Mythic Bee with 40,000 Royal Jellies
BSS_Calc.RollJelly("Mythic", 40000)
