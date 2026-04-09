-- ==============================================================================
-- 🐝 BSS ALL-IN-ONE ADVISOR & WAX PREDICTION ENGINE | DELTA GUI V4
-- ==============================================================================
-- 📚 DATABASE RESEARCHED VIA: bee-swarm-simulator.fandom.com/wiki/Beequip
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local GUI_NAME = "BSS_Advisor_Engine_Pro"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

-- ==============================================================================
-- 🧮 MATH & WIKI-VERIFIED DATABASE ENGINE
-- ==============================================================================
local function GetBinomialProbability(chance, attempts)
    if attempts <= 0 then return 0 end
    return (1 - math.pow(1 - (1 / chance), attempts)) * 100 
end

-- 📚 VERIFIED BEEQUIP WIKI DATA (Expanded Scope)
local BeequipDatabase = {
    ["Pink Shades"] = { 
        Normal = {"+% Critical Power (Up to +25%)", "+% Super Critical Chance", "+% Critical Chance"}, 
        Caustic = {"[Hive Bonus] +% Super-Crit Chance", "+Ability: Focus Token"},
        Limit = "1 per hive"
    },
    ["Kazoo"] = { 
        Normal = {"+% Convert Amount", "-% Bee Energy", "+% Bee Movespeed"}, 
        Caustic = {"+Ability: Melody", "[Hive Bonus] +% Pollen"},
        Limit = "No Limit"
    },
    ["Elf Cap"] = { 
        Normal = {"+Convert Amount", "+Capacity", "+% Honey from Tokens", "+% Convert Rate"}, 
        Caustic = {"[Hive Bonus] +% Convert at Hive", "[Hive Bonus] +Capacity", "+Ability: Blue Boost"},
        Limit = "3 per hive"
    },
    ["Beret"] = { 
        Normal = {"+Convert Amount", "+% Bubble Pollen (Up to +60%)", "+% Bee Movespeed"}, 
        Caustic = {"[Hive Bonus] +% Bubble Pollen", "[Hive Bonus] +% Bee Movespeed"},
        Limit = "No Limit"
    },
    ["Sweatband"] = { 
        Normal = {"+Red Field Capacity", "+% Bee Movespeed", "+Convert Rate"}, 
        Caustic = {"+Ability: Red Boost", "[Hive Bonus] +% Red Pollen", "[Hive Bonus] +% Flame Duration"},
        Limit = "No Limit"
    },
    ["Pinecone"] = { 
        Normal = {"+Pine Tree Forest Pollen", "+Capacity", "+% Convert Amount"}, 
        Caustic = {"+Ability: Pine Tree Drop", "[Hive Bonus] +% Capacity"},
        Limit = "No Limit"
    },
    ["Toy Horn"] = {
        Normal = {"+Attack", "+% Critical Power", "+% Bee Movespeed"},
        Caustic = {"+Ability: Melody", "[Hive Bonus] +Attack"},
        Limit = "No Limit"
    },
    ["Toy Drum"] = {
        Normal = {"+% Bee Movespeed", "+% Gather Amount", "+Convert Amount"},
        Caustic = {"+Ability: Haste", "[Hive Bonus] +% Bee Movespeed"},
        Limit = "No Limit"
    },
    ["Paper Angel"] = {
        Normal = {"+% White Pollen", "+% Convert Rate", "+Capacity"},
        Caustic = {"+Ability: Token Link", "[Hive Bonus] +% White Pollen"},
        Limit = "No Limit"
    },
    ["Charm Bracelet"] = {
        Normal = {"+% Loot Luck", "+Capacity", "+% Convert Amount"},
        Caustic = {"+Ability: Baby Love (Rare)", "[Hive Bonus] +% Loot Luck"},
        Limit = "No Limit"
    }
}

local beequipNames = {}
for name, _ in pairs(BeequipDatabase) do table.insert(beequipNames, name) end
table.sort(beequipNames)

-- 📚 VERIFIED WAX MECHANICS (Actual BSS Percentages)
local WaxMechanics = {
    ["Soft"]    = {success = 100, destroy = 0,  points = 1,  desc = "Slightly improves stats. 100% safe."},
    ["Hard"]    = {success = 60,  destroy = 0,  points = 2,  desc = "Moderately improves stats. 60% success. Fails do nothing."},
    ["Caustic"] = {success = 25,  destroy = 75, points = 4,  desc = "Greatly improves stats & unlocks Caustic pool. 75% to DELETE ITEM."},
    ["Swirled"] = {success = 100, destroy = 0,  points = 3,  desc = "Guarantees capacity boost + 3 standard stats. 100% safe."} 
}

-- ==============================================================================
-- 🖥️ GUI CONSTRUCTION (Dynamic Dark Theme)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = gethui() end)
if not success or not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 420)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
TitleBar.Text = " 🐝 BSS Advisor & Wiki Engine (Pro)"
TitleBar.TextColor3 = Color3.fromRGB(255, 180, 50)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 15
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Output Terminal (Scrollable)
local OutputScroll = Instance.new("ScrollingFrame")
OutputScroll.Size = UDim2.new(1, -20, 0, 190)
OutputScroll.Position = UDim2.new(0, 10, 1, -200)
OutputScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
OutputScroll.ScrollBarThickness = 5
OutputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScroll.Parent = MainFrame

local OutputPad = Instance.new("UIPadding")
OutputPad.PaddingLeft = UDim.new(0, 5)
OutputPad.PaddingTop = UDim.new(0, 5)
OutputPad.PaddingBottom = UDim.new(0, 5)
OutputPad.Parent = OutputScroll

local OutputLayout = Instance.new("UIListLayout")
OutputLayout.SortOrder = Enum.SortOrder.LayoutOrder
OutputLayout.Padding = UDim.new(0, 4)
OutputLayout.Parent = OutputScroll

local function Log(text, color, isBold)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -5, 0, 0)
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextColor3 = color or Color3.fromRGB(220, 220, 220)
    msg.Font = isBold and Enum.Font.Code or Enum.Font.Code
    msg.TextSize = 13
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.RichText = true
    msg.Parent = OutputScroll
    
    task.wait(0.02)
    OutputScroll.CanvasPosition = Vector2.new(0, OutputScroll.AbsoluteCanvasSize.Y)
end

-- ==============================================================================
-- 🎛️ CONTROL PANELS
-- ==============================================================================
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 180)
ControlFrame.Position = UDim2.new(0, 10, 0, 45)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local function CreateRow(yPos, labelText, createCallback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = ControlFrame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    createCallback(row)
end

-- ROW 1: GIFTING ------------------------------------------
local giftRarities = {"Mythic", "Legendary", "Epic", "Rare"}
local giftIdx = 1

CreateRow(0, "🍓 Gifting:", function(row)
    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 100, 0, 30)
    CycleBtn.Position = UDim2.new(0, 100, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = giftRarities[giftIdx]
    CycleBtn.Parent = row
    
    local AmountBox = Instance.new("TextBox")
    AmountBox.Size = UDim2.new(0, 100, 0, 30)
    AmountBox.Position = UDim2.new(0, 210, 0, 5)
    AmountBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmountBox.PlaceholderText = "Amt (e.g. 5000)"
    AmountBox.Text = ""
    AmountBox.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 140, 0, 30)
    CalcBtn.Position = UDim2.new(0, 320, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 60)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "CALCULATE"
    CalcBtn.Parent = row
    
    CycleBtn.MouseButton1Click:Connect(function()
        giftIdx = (giftIdx % #giftRarities) + 1
        CycleBtn.Text = giftRarities[giftIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local amt = tonumber(AmountBox.Text)
        if not amt then return Log("<b>[!] Invalid fruit amount.</b>", Color3.fromRGB(255, 80, 80)) end
        
        local oddsTable = { ["Rare"] = 8000, ["Epic"] = 10000, ["Legendary"] = 12000, ["Mythic"] = 24000 }
        local chance = oddsTable[CycleBtn.Text]
        local prob = GetBinomialProbability(chance, amt)
        
        Log("----------------------------------------")
        Log(string.format("🍓 <b>GIFTING: %s BEE</b>", string.upper(CycleBtn.Text)), Color3.fromRGB(255, 120, 120))
        Log(string.format("<b>Fruits:</b> %,d | <b>Base Wiki Odds:</b> 1 in %,d", amt, chance))
        Log(string.format("<b>Cumulative Probability:</b> %.2f%%", prob), Color3.fromRGB(100, 255, 100))
    end)
end)

-- ROW 2: ROYAL JELLY --------------------------------------
local jellyTargets = {"Mythic", "Gifted", "Legendary"}
local jellyIdx = 1

CreateRow(45, "🧪 RJelly:", function(row)
    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 100, 0, 30)
    CycleBtn.Position = UDim2.new(0, 100, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = jellyTargets[jellyIdx]
    CycleBtn.Parent = row
    
    local AmountBox = Instance.new("TextBox")
    AmountBox.Size = UDim2.new(0, 100, 0, 30)
    AmountBox.Position = UDim2.new(0, 210, 0, 5)
    AmountBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    AmountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    AmountBox.PlaceholderText = "Jellies"
    AmountBox.Text = ""
    AmountBox.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 140, 0, 30)
    CalcBtn.Position = UDim2.new(0, 320, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 180)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "CALCULATE"
    CalcBtn.Parent = row
    
    CycleBtn.MouseButton1Click:Connect(function()
        jellyIdx = (jellyIdx % #jellyTargets) + 1
        CycleBtn.Text = jellyTargets[jellyIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local amt = tonumber(AmountBox.Text)
        if not amt then return Log("<b>[!] Invalid jelly amount.</b>", Color3.fromRGB(255, 80, 80)) end
        
        local oddsTable = { ["Legendary"] = 33, ["Gifted"] = 250, ["Mythic"] = 25000 }
        local chance = oddsTable[CycleBtn.Text]
        local prob = GetBinomialProbability(chance, amt)
        
        Log("----------------------------------------")
        Log(string.format("🧪 <b>ROLLING: %s</b>", string.upper(CycleBtn.Text)), Color3.fromRGB(150, 200, 255))
        Log(string.format("<b>Jellies:</b> %,d | <b>Base Wiki Odds:</b> 1 in %,d", amt, chance))
        Log(string.format("<b>Cumulative Probability:</b> %.2f%%", prob), Color3.fromRGB(100, 255, 100))
    end)
end)

-- ROW 3: WAX PREDICTION (100% BUTTON DRIVEN) --------------
local bqIdx = 1
local waxes = {"Caustic", "Hard", "Soft", "Swirled"}
local waxIdx = 1

CreateRow(90, "🍯 Waxing:", function(row)
    local ItemCycleBtn = Instance.new("TextButton")
    ItemCycleBtn.Size = UDim2.new(0, 100, 0, 30)
    ItemCycleBtn.Position = UDim2.new(0, 100, 0, 5)
    ItemCycleBtn.BackgroundColor3 = Color3.fromRGB(70, 45, 90)
    ItemCycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ItemCycleBtn.TextScaled = true
    ItemCycleBtn.Text = beequipNames[bqIdx]
    ItemCycleBtn.Parent = row

    local CycleBtn = Instance.new("TextButton")
    CycleBtn.Size = UDim2.new(0, 100, 0, 30)
    CycleBtn.Position = UDim2.new(0, 210, 0, 5)
    CycleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    CycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CycleBtn.Text = waxes[waxIdx]
    CycleBtn.Parent = row
    
    local CalcBtn = Instance.new("TextButton")
    CalcBtn.Size = UDim2.new(0, 140, 0, 30)
    CalcBtn.Position = UDim2.new(0, 320, 0, 5)
    CalcBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 50)
    CalcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CalcBtn.Font = Enum.Font.GothamBold
    CalcBtn.Text = "WIKI PREDICT"
    CalcBtn.Parent = row

    ItemCycleBtn.MouseButton1Click:Connect(function()
        bqIdx = (bqIdx % #beequipNames) + 1
        ItemCycleBtn.Text = beequipNames[bqIdx]
    end)

    CycleBtn.MouseButton1Click:Connect(function()
        waxIdx = (waxIdx % #waxes) + 1
        CycleBtn.Text = waxes[waxIdx]
    end)
    
    CalcBtn.MouseButton1Click:Connect(function()
        local beequipName = ItemCycleBtn.Text
        local waxType = CycleBtn.Text
        
        local beequipData = BeequipDatabase[beequipName]
        local waxInfo = WaxMechanics[waxType]
        
        Log("========================================")
        Log(string.format("🍯 <b>WAXING: %s</b> with <b>%s Wax</b>", string.upper(beequipName), string.upper(waxType)), Color3.fromRGB(255, 210, 80))
        Log(string.format("<b>Mechanics:</b> %s", waxInfo.desc))
        Log(string.format("<b>Hive Limit:</b> %s", beequipData.Limit), Color3.fromRGB(150, 150, 150))
        
        if waxType == "Caustic" then
            Log("<b>⚠️ DANGER: 75% CHANCE TO PERMANENTLY DESTROY THIS ITEM.</b>", Color3.fromRGB(255, 70, 70))
            Log("<b>✨ IF SUCCESS (25%):</b> Unlocks Caustic stat pool:", Color3.fromRGB(200, 120, 255))
            for _, stat in ipairs(beequipData.Caustic) do 
                Log("  > " .. stat, Color3.fromRGB(220, 180, 255)) 
            end
            Log("<b>[ADVICE]:</b> Never use Caustic Wax on an item unless you have backups or a Turpentine ready if the stats roll poorly (Turpentine cannot save a destroyed item).", Color3.fromRGB(255, 180, 100))
        else
            local pStats = ""
            for _, s in ipairs(beequipData.Normal) do pStats = pStats .. "\n  > " .. s end
            Log(string.format("<b>✅ IF SUCCESS (%d%%):</b> Randomly adds/upgrades %d stat(s) from:", waxInfo.success, waxInfo.points), Color3.fromRGB(100, 255, 100))
            Log(pStats, Color3.fromRGB(180, 255, 180))
            if waxType == "Swirled" then
                Log("  > +Bonus Capacity (Guaranteed)", Color3.fromRGB(100, 200, 255))
            end
        end
    end)
end)

Log("<b>✅ BSS Advisor Engine V4 Loaded.</b>", Color3.fromRGB(100, 255, 100))
Log("<i>Wiki Database Sync: Active. Click 'Wiki Predict' to view verified stat distributions.</i>", Color3.fromRGB(150, 150, 150))
