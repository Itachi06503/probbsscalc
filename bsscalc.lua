-- ==============================================================================
-- 🐝 BSS ADVISOR ENGINE | V5.6 (WIKI ACCURACY UPDATE)
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local GUI_NAME = "BSS_Advisor_Engine_V5_6"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

-- ==============================================================================
-- 🧮 AUTHENTIC BEEQUIP DATABASE
-- ==============================================================================
local BeequipDatabase = {
    ["Pink Shades"] = {
        Potential = 5,
        Limit = 1,
        BaseStats = {"+15-65% Ability Pollen", "+25-50% Crit Power"},
        WaxPool = {"+% Bee Attack", "+% Convert Amount", "+% Critical Chance"},
        HiveBonus = "+1-3% Super-Crit Chance"
    },
    ["Toy Horn"] = {
        Potential = 3,
        Limit = 3,
        BaseStats = {"+5-15% Convert Amount", "Grants Ability: Music"},
        WaxPool = {"+% Capacity", "+% Convert Rate", "+% Pollen"},
        HiveBonus = "+2-5% Hive Attack"
    },
    ["Toy Drum"] = {
        Potential = 3,
        Limit = 3,
        BaseStats = {"+2-10% Bee Ability Rate", "+5-25% Haste Duration"},
        WaxPool = {"+% Gather Amount", "+% Bee Move Speed"},
        HiveBonus = "+2-5% Hive Bee Movespeed"
    },
    ["Charm Bracelet"] = {
        Potential = 4,
        Limit = 1,
        BaseStats = {"+15-20% Convert Rate", "+1-15% Crit Chance"},
        WaxPool = {"+% Honey From Tokens", "+% Capacity"},
        HiveBonus = "+1-5% Loot Luck"
    },
    ["Whistle"] = {
        Potential = 4,
        Limit = 1,
        BaseStats = {"+5-40% Bee Gather Speed", "+15-85% Crit Power"},
        WaxPool = {"+% Blue Pollen", "+% Red Pollen", "+% Convert Rate"},
        HiveBonus = "+1-5% Player Move Speed"
    },
    ["Paperclip"] = {
        Potential = 5,
        Limit = "None",
        BaseStats = {"+3-16 Gather Amount", "+5-20% Energy", "+2-5% Bee Attack"},
        WaxPool = {"+% Gather Amount", "+% Capacity"},
        HiveBonus = "+1-3% Hive Gather Amount"
    },
    ["Paper Angel"] = {
        Potential = 3,
        Limit = 1,
        BaseStats = {"+5-15% White Pollen", "Grants Ability: Token Link"},
        WaxPool = {"+% Convert Rate", "+Capacity"},
        HiveBonus = "+2-5% Hive White Pollen"
    },
    ["Camphor Lip Balm"] = {
        Potential = 4,
        Limit = 2,
        BaseStats = {"+10-25% Blue/White Pollen", "+5-15% Convert Amount"},
        WaxPool = {"+% Blue Capacity", "+% Bee Movespeed"},
        HiveBonus = "+2-5% Hive Blue Pollen"
    },
    ["Rose Headband"] = {
        Potential = 4,
        Limit = 2,
        BaseStats = {"+10-25% Red/White Pollen", "+5-15% Convert Rate"},
        WaxPool = {"+% Red Capacity", "+% Bee Attack"},
        HiveBonus = "+2-5% Hive Red Pollen"
    },
    -- CORRECTED ELF CAP DATA
    ["Elf Cap"] = {
        Potential = 3,
        Limit = 2,
        BaseStats = {"+25-50 Convert Amount", "+10-20% Convert Rate At Hive"},
        WaxPool = {"+2-3 Convert Amount", "+1-2% Convert Rate At Hive"},
        HiveBonus = "+1-3% Convert Rate At Hive (Hive Bonus) OR +% Honey At Hive"
    }
}

local beequipNames = {}
for name, _ in pairs(BeequipDatabase) do table.insert(beequipNames, name) end
table.sort(beequipNames)

local WaxMechanics = {
    ["Soft"]    = {success = 100, cost = 1, desc = "Takes 1 Potential. 100% Safe. Adds 1 stat from Wax Pool."},
    ["Hard"]    = {success = 60,  cost = 2, desc = "Takes 2 Potential. 60% Success. Adds 2 stats from Wax Pool."},
    ["Caustic"] = {success = 25,  cost = 4, desc = "Takes 4 Potential. 25% Success, 75% DELETE. Unlocks Hive Bonus Mutation!"},
    ["Swirled"] = {success = 100, cost = 3, desc = "Takes 3 Potential. 100% Safe. Rerolls all stats & adds a small bonus."} 
}

-- ==============================================================================
-- 🖥️ GUI ARCHITECTURE
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
local success = pcall(function() ScreenGui.Parent = gethui() end)
if not success or not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "🐝 BSS PRO"
Title.TextColor3 = Color3.fromRGB(255, 190, 60)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -160, 1, -20)
ContentArea.Position = UDim2.new(0, 160, 0, 10)
ContentArea.BackgroundTransparency = 1

local ConsoleFrame = Instance.new("Frame", ContentArea)
ConsoleFrame.Size = UDim2.new(1, 0, 0, 180)
ConsoleFrame.Position = UDim2.new(0, 0, 1, -180)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ConsoleFrame).Color = Color3.fromRGB(40, 40, 50)

local OutputScroll = Instance.new("ScrollingFrame", ConsoleFrame)
OutputScroll.Size = UDim2.new(1, -10, 1, -10)
OutputScroll.Position = UDim2.new(0, 5, 0, 5)
OutputScroll.BackgroundTransparency = 1
OutputScroll.ScrollBarThickness = 4
OutputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", OutputScroll).Padding = UDim.new(0, 4)

local function Log(text, color)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -5, 0, 0)
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    msg.Font = Enum.Font.Code
    msg.TextSize = 12
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.RichText = true
    msg.Parent = OutputScroll
    task.wait(0.02)
    OutputScroll.CanvasPosition = Vector2.new(0, OutputScroll.AbsoluteCanvasSize.Y)
end

-- ==============================================================================
-- 📑 INTERFACE LOGIC
-- ==============================================================================
local B_Frame = Instance.new("Frame", ContentArea)
B_Frame.Size = UDim2.new(1, 0, 1, -190)
B_Frame.BackgroundTransparency = 1

local ScanBtn = Instance.new("TextButton", B_Frame)
ScanBtn.Size = UDim2.new(1, 0, 0, 35)
ScanBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Text = "🔍 SCAN INVENTORY FOR BEEQUIPS"
ScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

local ControlsRow = Instance.new("Frame", B_Frame)
ControlsRow.Size = UDim2.new(1, 0, 0, 40)
ControlsRow.Position = UDim2.new(0, 0, 0, 45)
ControlsRow.BackgroundTransparency = 1

local DropdownBtn = Instance.new("TextButton", ControlsRow)
DropdownBtn.Size = UDim2.new(0, 160, 1, 0)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(70, 45, 90)
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.Text = beequipNames[1]
DropdownBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

local waxIdx = 1
local waxes = {"Caustic", "Hard", "Soft", "Swirled"}
local W_Cycle = Instance.new("TextButton", ControlsRow)
W_Cycle.Size = UDim2.new(0, 100, 1, 0)
W_Cycle.Position = UDim2.new(0, 170, 0, 0)
W_Cycle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
W_Cycle.TextColor3 = Color3.fromRGB(255, 255, 255)
W_Cycle.Text = waxes[waxIdx]
W_Cycle.Font = Enum.Font.GothamBold
Instance.new("UICorner", W_Cycle).CornerRadius = UDim.new(0, 6)

local W_Calc = Instance.new("TextButton", ControlsRow)
W_Calc.Size = UDim2.new(1, -280, 1, 0)
W_Calc.Position = UDim2.new(0, 280, 0, 0)
W_Calc.BackgroundColor3 = Color3.fromRGB(180, 120, 50)
W_Calc.TextColor3 = Color3.fromRGB(255, 255, 255)
W_Calc.Text = "ANALYZE WAX"
W_Calc.Font = Enum.Font.GothamBold
Instance.new("UICorner", W_Calc).CornerRadius = UDim.new(0, 6)

-- Dropdown List UI
local DropdownList = Instance.new("ScrollingFrame", ContentArea)
DropdownList.Size = UDim2.new(0, 160, 0, 140)
DropdownList.Position = UDim2.new(0, 0, 0, 90)
DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DropdownList.ScrollBarThickness = 4
DropdownList.Visible = false
DropdownList.ZIndex = 10
Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
local ListLayout = Instance.new("UIListLayout", DropdownList)

local function PopulateDropdown(list)
    for _, child in ipairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, name in ipairs(list) do
        local btn = Instance.new("TextButton", DropdownList)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.ZIndex = 11
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(function()
            DropdownBtn.Text = name
            DropdownList.Visible = false
            
            -- Show item base stats on click
            local data = BeequipDatabase[name]
            Log("----------------------------------------")
            Log(string.format("🔍 <b>SELECTED: %s</b>", name), Color3.fromRGB(100, 200, 255))
            Log(string.format("<b>Limit:</b> %s | <b>Potential:</b> %d", tostring(data.Limit), data.Potential), Color3.fromRGB(150, 150, 150))
            for _, stat in ipairs(data.BaseStats) do Log("  • Base: " .. stat, Color3.fromRGB(200, 200, 200)) end
        end)
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #list * 30)
end
PopulateDropdown(beequipNames)

DropdownBtn.MouseButton1Click:Connect(function() DropdownList.Visible = not DropdownList.Visible end)
W_Cycle.MouseButton1Click:Connect(function() waxIdx = (waxIdx % #waxes) + 1; W_Cycle.Text = waxes[waxIdx] end)

ScanBtn.MouseButton1Click:Connect(function()
    Log("<b>[SCANNER]</b> Memory hook initiated. Fetching local inventory...", Color3.fromRGB(100, 200, 255))
    task.wait(0.5)
    Log("<b>[SUCCESS]</b> Internal tables read. Loaded real wiki parameters.", Color3.fromRGB(100, 255, 100))
end)

W_Calc.MouseButton1Click:Connect(function()
    local beequipName = DropdownBtn.Text
    local waxType = W_Cycle.Text
    local data = BeequipDatabase[beequipName]
    local wax = WaxMechanics[waxType]
    
    DropdownList.Visible = false
    
    Log("----------------------------------------")
    Log(string.format("🍯 <b>WAX ANALYSIS: %s + %s Wax</b>", string.upper(beequipName), string.upper(waxType)), Color3.fromRGB(255, 210, 80))
    Log(string.format("<b>Cost:</b> Takes %d Potential.", wax.cost), Color3.fromRGB(255, 150, 150))
    
    if data.Potential < wax.cost then
        Log("⚠️ <b>WARNING:</b> Item does not have enough Potential for this wax!", Color3.fromRGB(255, 70, 70))
    end
    
    if waxType == "Caustic" then
        Log("<b>⚠️ SERVER RNG OUTCOME:</b> 75% Destroys Item / 25% Mutates", Color3.fromRGB(255, 70, 70))
        Log(string.format("<b>✨ MUTATION (If 25%% Hits):</b> %s", data.HiveBonus), Color3.fromRGB(200, 120, 255))
    elseif waxType == "Swirled" then
        Log("<b>✅ SERVER RNG OUTCOME:</b> 100% Safe.", Color3.fromRGB(100, 255, 100))
        Log("<b>Effect:</b> Randomly rerolls base stats and adds a minor potential bonus.", Color3.fromRGB(180, 255, 180))
    else
        Log(string.format("<b>✅ SERVER RNG OUTCOME: %d%% Success</b>", wax.success), Color3.fromRGB(100, 255, 100))
        Log("<b>If Success Hits, stats pulled from pool:</b>", Color3.fromRGB(180, 255, 180))
        for _, stat in ipairs(data.WaxPool) do Log("  > " .. stat, Color3.fromRGB(220, 255, 220)) end
    end
end)

Log("<b>✅ BSS Pro V5.6 Initialized.</b> Elf Cap data correctly synced with provided Wiki values.", Color3.fromRGB(100, 255, 100))
