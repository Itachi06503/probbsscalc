-- ==============================================================================
-- 🐝 BSS ALL-IN-ONE CALCULATOR & WAX PREDICTION ENGINE (V2)
-- ==============================================================================
-- A mathematical and strategic guide for Bee Swarm Simulator resource management.
-- Output: Console Print()
-- ==============================================================================

local BSS_Calc = {}

-- ==============================================================================
-- 🧮 CORE MATH HELPER
-- ==============================================================================
local function GetBinomialProbability(chance, attempts)
    if attempts <= 0 then return 0 end
    local probability = 1 - math.pow(1 - (1 / chance), attempts)
    return probability * 100 
end

local function PrintHeader(title)
    print("\n========================================================")
    print(" " .. title)
    print("========================================================")
end

-- ==============================================================================
-- 🧢 MODULE 1: BEEQUIP WAX PREDICTION & STAT SIMULATOR (NEW)
-- ==============================================================================
-- Built-in database of highly demanded Beequips and their actual game stat pools.
local BeequipDatabase = {
    ["Elf Cap"] = {
        NormalStats = {"+Convert Amount", "+Capacity", "+% Honey from Tokens"},
        CausticStats = {"[Hive] +% Convert at Hive", "[Hive] +Capacity"}
    },
    ["Kazoo"] = {
        NormalStats = {"+% Convert Amount", "+% Critical Power", "-% Energy"},
        CausticStats = {"+Ability: Melody", "[Hive] +% Super-Crit Power"}
    },
    ["Pink Shades"] = {
        NormalStats = {"+% Ability Pollen", "+% Critical Chance", "+% Critical Power"},
        CausticStats = {"+Ability: Focus", "[Hive] +% Super-Crit Chance"}
    },
    ["Beret"] = {
        NormalStats = {"+Convert Amount", "+% Ability Pollen", "+% Blue Field Capacity"},
        CausticStats = {"+Ability: Blue Boost", "[Hive] +Capacity"}
    }
}

local WaxMechanics = {
    ["Soft"]    = {success = 100, destroy = 0,  points = 1, allowsCaustic = false},
    ["Hard"]    = {success = 60,  destroy = 0,  points = 2, allowsCaustic = false},
    ["Caustic"] = {success = 25,  destroy = 75, points = 4, allowsCaustic = true},
    ["Swirled"] = {success = 100, destroy = 0,  points = 0, allowsCaustic = false} 
}

function BSS_Calc.PredictWax(beequipName, waxType, potentialStars)
    PrintHeader("🔮 BEEQUIP WAX PREDICTOR: " .. string.upper(beequipName))
    
    local beequip = BeequipDatabase[beequipName]
    local wax = WaxMechanics[waxType]
    
    if not beequip then
        print(string.format("[!] Error: '%s' not found in database. Check spelling.", beequipName))
        return
    elseif not wax then
        print(string.format("[!] Error: Unknown wax type '%s'.", waxType))
        return
    end

    print(string.format("Target Item: %s (Potential: %d⭐)", beequipName, potentialStars))
    print(string.format("Wax Applied: %s Wax", waxType))
    print(string.format("Mechanics: %d%% Success | %d%% Destroy | Grants %d Upgrade Points", wax.success, wax.destroy, wax.points))
    print("--------------------------------------------------------")
    
    -- Simulation Logic
    print("[🎲 SIMULATION RESULTS]:")
    if waxType == "Swirled" then
        print("- Swirled Wax does not add upgrade points.")
        print(string.format("- It will reroll your base stats based on your %d⭐ potential.", potentialStars))
        if potentialStars >= 4 then
            print("- High potential! You have a great chance of getting maxed base stats.")
        else
            print("- Low potential! Rerolling might actually make your stats worse.")
        end
    else
        local possibleRolls = ""
        for _, stat in ipairs(beequip.NormalStats) do possibleRolls = possibleRolls .. stat .. ", " end
        
        if wax.allowsCaustic then
            print("- ☠️ DANGER: 75% chance item is DELETED from inventory forever.")
            print("- ✨ IF SUCCESSFUL: You get 4 major stat upgrades.")
            print("- 🔓 CAUSTIC UNLOCKS: You now have a chance to roll the following exclusive stats:")
            for _, cStat in ipairs(beequip.CausticStats) do
                print("   > " .. cStat)
            end
        else
            print(string.format("- IF SUCCESSFUL: You get %d minor stat upgrade(s).", wax.points))
            print("- Possible stat boosts: " .. string.sub(possibleRolls, 1, -3))
            if waxType == "Hard" then
                print("- ❌ IF FAIL: You lose the wax and a wax slot, but the item is SAFE.")
            end
        end
    end
    print("--------------------------------------------------------")
    
    -- Strategic Advice Engine
    if waxType == "Caustic" then
        print("[💡 VETERAN ADVICE]: ONLY use Caustic on a 4⭐ or 5⭐ " .. beequipName .. ". If you are trying to get '" .. beequip.CausticStats[1] .. "', you must use this wax, but have backups ready. Do NOT use this on your only copy!")
    elseif waxType == "Hard" then
        print("[💡 VETERAN ADVICE]: Hard wax is the meta for mid-tier upgrading. If the item base stats don't explicitly require Caustic (like gold bubble pollen vs pepper patch pollen), stick to Hard Wax. If you get 3 successful Hard Waxes and bad stats, use a Swirled Wax to reroll.")
    elseif waxType == "Soft" then
        print("[💡 VETERAN ADVICE]: Soft wax is mostly a waste of a wax slot on a high-potential " .. beequipName .. ". Save this for cheap, throwaway Beequips.")
    end
end

-- ==============================================================================
-- 🍓 MODULE 2: TREAT & GIFTING (PREVIOUS)
-- ==============================================================================
function BSS_Calc.GiftBee(rarity, fruitsOwned)
    PrintHeader("🍓 TREAT & GIFTING ANALYSIS")
    
    local oddsTable = { ["Rare"] = 8000, ["Epic"] = 10000, ["Legendary"] = 12000, ["Mythic"] = 24000 }
    local chance = oddsTable[rarity]
    
    if not chance then return print("[!] Error: Unknown rarity.") end
    local probPercent = GetBinomialProbability(chance, fruitsOwned)
    
    print(string.format("Target: Gifted %s Bee | Base Odds: 1 in %,d | Fruits Owned: %,d", rarity, chance, fruitsOwned))
    print(string.format("Probability of Success: %.2f%%", probPercent))
    print("--------------------------------------------------------")
    
    if probPercent >= 90 then print("[💡 Advice]: Excellent odds! You are mathematically safe to gamble.")
    elseif probPercent >= 50 then print("[💡 Advice]: Coin toss. Only gamble if you feel lucky.")
    else print("[🚨 Advice]: DO NOT GAMBLE! Save your fruits for crafting Extracts at the Blender.") end
end

-- ==============================================================================
-- 🧪 MODULE 3: ROYAL JELLY (PREVIOUS)
-- ==============================================================================
function BSS_Calc.RollJelly(target, jelliesOwned)
    PrintHeader("🧪 ROYAL JELLY ROLLER")
    
    local targetOdds = { ["Legendary"] = 33, ["Gifted"] = 250, ["Mythic"] = 25000 }
    local chance = targetOdds[target]
    
    if not chance then return print("[!] Error: Unknown target.") end
    local probPercent = GetBinomialProbability(chance, jelliesOwned)
    
    print(string.format("Target: %s | Base Odds: 1 in %,d | Jellies Owned: %,d", target, chance, jelliesOwned))
    print(string.format("Probability of Success: %.2f%%", probPercent))
    print("--------------------------------------------------------")
    
    if target == "Mythic" and jelliesOwned < 25000 then
        print("[🚨 Advice]: You have less than the 25k threshold. Only roll if you can afford to lose everything!")
    elseif probPercent > 60 then
        print("[💡 Advice]: You have solid mathematical odds. Good time to roll.")
    end
end

-- ==============================================================================
-- 🛠️ EXAMPLES / TEST CALLS
-- ==============================================================================

-- Test 1: Simulating applying a Caustic Wax to a 5-Star Elf Cap
BSS_Calc.PredictWax("Elf Cap", "Caustic", 5)

-- Test 2: Simulating applying a Hard Wax to Pink Shades
BSS_Calc.PredictWax("Pink Shades", "Hard", 3)

-- Test 3: Math check for Mythic Jelly rolling
BSS_Calc.RollJelly("Mythic", 15000)
