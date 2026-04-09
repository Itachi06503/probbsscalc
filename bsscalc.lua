-- ==============================================================================
-- 🐝 BSS ALL-IN-ONE CALCULATOR & ADVISOR | DELTA GUI EDITION (V3)
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Clean up old UI if re-executing
local GUI_NAME = "BSS_Advisor_Engine"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

-- ==============================================================================
-- 🧮 MATH & DATABASE ENGINE
-- ==============================================================================
local function GetBinomialProbability(chance, attempts)
    if attempts <= 0 then return 0 end
    local probability = 1 - math.pow(1 - (1 / chance), attempts)
    return probability * 100 
end

local BeequipDatabase = {
    ["Elf Cap"] = { NormalStats = {"+Convert Amount", "+Capacity", "+% Honey from Tokens"}, CausticStats = {"[Hive] +% Convert at Hive", "[Hive] +Capacity"} },
    ["Kazoo"] = { NormalStats = {"+% Convert Amount", "+% Critical Power", "-% Energy"}, CausticStats = {"+Ability: Melody", "[Hive] +% Super-Crit Power"} },
    ["Pink Shades"] = { NormalStats = {"+% Ability Pollen", "+% Critical Chance", "+% Critical Power"}, CausticStats = {"+Ability: Focus", "[Hive] +% Super-Crit Chance"} },
    ["Beret"] = { NormalStats = {"+Convert Amount", "+% Ability Pollen", "+% Blue Field Capacity"}, CausticStats = {"+Ability: Blue Boost", "[Hive] +Capacity"} },
    ["Sweatband"] = { NormalStats = {"+Red Field Capacity", "+% Bee Movespeed", "+Convert Rate"}, CausticStats = {"+Ability: Red Boost", "[Hive] +% Pollen"} },
    ["Pinecone"] = { NormalStats = {"+Pine Tree Pollen", "+Capacity", "+% Convert Amount"}, CausticStats = {"+Ability: Pine Tree Drop", "[Hive] +% Capacity"} }
}

-- Create an array of Beequip names for the cycler
local beequipNames = {}
for name, _ in pairs(BeequipDatabase) do table.insert(beequipNames, name) end
table.sort(beequipNames)

local WaxMechanics = {
    ["Soft"]    = {success = 100, destroy = 0,  points = 1, allowsCaustic = false},
    ["Hard"]    = {success = 60,  destroy = 0,  points = 2, allowsCaustic = false},
    ["Caustic"] = {success = 25,  destroy = 75, points = 4, allowsCaustic = true},
    ["Swirled"] = {success = 100, destroy = 0,  points = 0, allowsCaustic = false} 
}

-- ==============================================================================
-- 🖥️ GUI CONSTRUCTION
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = gethui() end)
if not success or not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 380)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.Text = " 🐝 BSS Advisor Engine (Pro)"
TitleBar.TextColor3 = Color3.fromRGB(255, 200, 50)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- output terminal
local OutputScroll = Instance.new("ScrollingFrame")
OutputScroll.Size = UDim2.new(1, -20, 0, 160)
OutputScroll.Position = UDim2.new(0, 10, 1, -170)
OutputScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OutputScroll.ScrollBarThickness = 4
OutputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScroll.Parent = MainFrame

local OutputLayout = Instance.new("UIListLayout")
OutputLayout.SortOrder = Enum.SortOrder.LayoutOrder
OutputLayout.Padding = UDim.new(0, 5)
OutputLayout.Parent = OutputScroll

local function LogOutput(text, color)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -10, 0, 0)
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    msg.Font = Enum.Font.Code
    msg.TextSize = 13
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.Parent = OutputScroll
    
    task.wait(0.05)
    OutputScroll.CanvasPosition = Vector2.new(0, OutputScroll.AbsoluteCanvasSize.Y)
end

-- ==============================================================================
-- 🎛️ CONTROLS CREATION HELPER
-- ==============================================================================
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 160)
ControlFrame.Position = UDim2.new(0, 10, 0, 40)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local function CreateRow(yPos, labelText, createCallback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 35)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = ControlFrame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 90, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    createCallback(row)
end

-- ---------------------------------------------------------
-- ROW 1: GIFTING
-- ---------------------------------------------------------
local giftRarities = {"Mythic", "Legendary", "Epic", "Rare"}
local giftIdx = 1

CreateRow(0, "🍓 Gifting:", function(row)
    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 90, 0, 25)
    CycleBtn.Position = UDim2.new(0, 90, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = giftRarities[giftIdx]
    CycleBtn.Parent = row
    
    local AmountBox = Instance.new("TextBox")
    AmountBox.Size = UDim2.new(0, 90, 0, 25)
    AmountBox.Position = UDim2.new(0, 190, 0, 5)
    AmountBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmountBox.PlaceholderText = "Fruits (e.g. 5000)"
    AmountBox.Text = ""
    AmountBox.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 130, 0, 25)
    CalcBtn.Position = UDim2.new(0, 290, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "CALC ODDS"
    CalcBtn.Parent = row
    
    CycleBtn.MouseButton1Click:Connect(function()
        giftIdx = (giftIdx % #giftRarities) + 1
        CycleBtn.Text = giftRarities[giftIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local amt = tonumber(AmountBox.Text)
        if not amt then return LogOutput("[!] Please enter a valid number of fruits.", Color3.fromRGB(255, 100, 100)) end
        
        local oddsTable = { ["Rare"] = 8000, ["Epic"] = 10000, ["Legendary"] = 12000, ["Mythic"] = 24000 }
        local chance = oddsTable[CycleBtn.Text]
        local prob = GetBinomialProbability(chance, amt)
        
        LogOutput("==============================")
        LogOutput(string.format("🍓 GIFTING TARGET: %s BEE", CycleBtn.Text), Color3.fromRGB(255, 150, 150))
        LogOutput(string.format("Fruits: %,d | Base Odds: 1 in %,d", amt, chance))
        LogOutput(string.format("Probability: %.2f%%", prob), Color3.fromRGB(100, 255, 100))
        
        if prob >= 90 then LogOutput("[💡 ADVICE]: Safe to gamble!", Color3.fromRGB(100, 255, 100))
        elseif prob >= 50 then LogOutput("[💡 ADVICE]: Coin toss. Good luck.", Color3.fromRGB(255, 200, 100))
        else LogOutput("[🚨 ADVICE]: Odds against you (<50%). Save fruits!", Color3.fromRGB(255, 100, 100)) end
    end)
end)

-- ---------------------------------------------------------
-- ROW 2: ROYAL JELLY
-- ---------------------------------------------------------
local jellyTargets = {"Mythic", "Gifted", "Legendary"}
local jellyIdx = 1

CreateRow(45, "🧪 RJelly:", function(row)
    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 90, 0, 25)
    CycleBtn.Position = UDim2.new(0, 90, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = jellyTargets[jellyIdx]
    CycleBtn.Parent = row
    
    local AmountBox = Instance.new("TextBox")
    AmountBox.Size = UDim2.new(0, 90, 0, 25)
    AmountBox.Position = UDim2.new(0, 190, 0, 5)
    AmountBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmountBox.PlaceholderText = "Jellies"
    AmountBox.Text = ""
    AmountBox.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 130, 0, 25)
    CalcBtn.Position = UDim2.new(0, 290, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 150)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "ROLL PROBABILITY"
    CalcBtn.Parent = row
    
    CycleBtn.MouseButton1Click:Connect(function()
        jellyIdx = (jellyIdx % #jellyTargets) + 1
        CycleBtn.Text = jellyTargets[jellyIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local amt = tonumber(AmountBox.Text)
        if not amt then return LogOutput("[!] Please enter a valid number of Jellies.", Color3.fromRGB(255, 100, 100)) end
        
        local oddsTable = { ["Legendary"] = 33, ["Gifted"] = 250, ["Mythic"] = 25000 }
        local chance = oddsTable[CycleBtn.Text]
        local prob = GetBinomialProbability(chance, amt)
        
        LogOutput("==============================")
        LogOutput(string.format("🧪 ROLLING FOR: %s", CycleBtn.Text), Color3.fromRGB(150, 200, 255))
        LogOutput(string.format("Jellies: %,d | Base Odds: 1 in %,d", amt, chance))
        LogOutput(string.format("Probability: %.2f%%", prob), Color3.fromRGB(100, 255, 100))
        
        if CycleBtn.Text == "Mythic" and amt < 25000 then
            LogOutput("[🚨 ADVICE]: Under 25k jellies! Only roll if you accept losing it all.", Color3.fromRGB(255, 100, 100))
        end
    end)
end)

-- ---------------------------------------------------------
-- ROW 3: WAX PREDICTION (UPDATED - NO TYPING!)
-- ---------------------------------------------------------
local bqIdx = 1
local waxes = {"Caustic", "Hard", "Soft", "Swirled"}
local waxIdx = 1

CreateRow(90, "🍯 Waxing:", function(row)
    -- NEW: Cycle Button for Beequip instead of TextBox
    local ItemCycleBtn = Instance.new("TextButton")
    ItemCycleBtn.Size = UDim2.new(0, 90, 0, 25)
    ItemCycleBtn.Position = UDim2.new(0, 90, 0, 5)
    ItemCycleBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
    ItemCycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ItemCycleBtn.TextScaled = true -- Adjusts font size to fit long names
    ItemCycleBtn.Text = beequipNames[bqIdx]
    ItemCycleBtn.Parent = row

    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 90, 0, 25)
    CycleBtn.Position = UDim2.new(0, 190, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = waxes[waxIdx]
    CycleBtn.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 130, 0, 25)
    CalcBtn.Position = UDim2.new(0, 290, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "PREDICT RESULTS"
    CalcBtn.Parent = row

    -- Logic to cycle through Beequip Names
    ItemCycleBtn.MouseButton1Click:Connect(function()
        bqIdx = (bqIdx % #beequipNames) + 1
        ItemCycleBtn.Text = beequipNames[bqIdx]
    end)

    -- Logic to cycle through Wax Types
    CycleBtn.MouseButton1Click:Connect(function()
        waxIdx = (waxIdx % #waxes) + 1
        CycleBtn.Text = waxes[waxIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local beequipName = ItemCycleBtn.Text
        local waxType = CycleBtn.Text
        
        -- Exact match using our cycled name
        local beequipData = BeequipDatabase[beequipName]
        local waxInfo = WaxMechanics[waxType]
        
        LogOutput("==============================")
        LogOutput(string.format("🍯 WAXING: %s with %s Wax", string.upper(beequipName), waxType), Color3.fromRGB(255, 200, 50))
        LogOutput(string.format("Success: %d%% | Destroy: %d%%", waxInfo.success, waxInfo.destroy))
        
        if waxInfo.allowsCaustic then
            LogOutput("- ☠️ 75% CHANCE ITEM IS PERMANENTLY DESTROYED.", Color3.fromRGB(255, 80, 80))
            LogOutput("- ✨ IF SUCCESS: Unlocks exclusive modifiers:")
            for _, stat in ipairs(beequipData.CausticStats) do LogOutput("  > " .. stat, Color3.fromRGB(200, 100, 255)) end
            LogOutput("[💡 ADVICE]: DO NOT use this on your only copy!", Color3.fromRGB(255, 200, 50))
        else
            local pStats = ""
            for _, s in ipairs(beequipData.NormalStats) do pStats = pStats .. s .. ", " end
            LogOutput(string.format("- IF SUCCESS: Grants %d standard stat boost(s).", waxInfo.points), Color3.fromRGB(100, 255, 100))
            LogOutput("- Pool: " .. string.sub(pStats, 1, -3))
        end
    end)
end)

LogOutput("✅ Engine Loaded! Ready to crunch numbers.", Color3.fromRGB(100, 255, 100))
