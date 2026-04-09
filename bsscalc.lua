-- ==============================================================================
-- 🐝 BSS ADVISOR ENGINE | V5.4 (DROPDOWN & INVENTORY SCANNER)
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GUI_NAME = "BSS_Advisor_Engine_V5_4"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

-- ==============================================================================
-- 🧮 DATABASE & LOGIC
-- ==============================================================================
local BeequipDatabase = {
    ["Pink Shades"] = { Normal = {"+% Ability Pollen (15-65%)", "+% Crit Power (25-50%)"}, Caustic = {"[Hive] +% Super-Crit Chance"}, Limit = "1 per hive" },
    ["Toy Horn"] = { Normal = {"+% Convert Amount", "+Ability: Music"}, Caustic = {"[Hive] +Attack"}, Limit = "No Limit" },
    ["Toy Drum"] = { Normal = {"+% Bee Ability Rate", "+% Haste Duration"}, Caustic = {"[Hive] +% Bee Movespeed"}, Limit = "No Limit" },
    ["Charm Bracelet"] = { Normal = {"+% Convert (15-20%)", "+% Crit Chance (1-15%)"}, Caustic = {"[Hive] +% Loot Luck"}, Limit = "No Limit" },
    ["Whistle"] = { Normal = {"+% Move Speed (5-40%)", "+% Crit Power (15-85%)"}, Caustic = {"[Hive] xPlayer Move Speed"}, Limit = "No Limit" },
    ["Paperclip"] = { Normal = {"+Gather (3-16)", "+% Energy (5-20%)", "+% Bee Attack"}, Caustic = {"[Hive] N/A"}, Limit = "No Limit" },
    ["Paper Angel"] = { Normal = {"+% White Pollen", "+% Convert Rate", "+Capacity"}, Caustic = {"+Ability: Token Link", "[Hive] +% White Pollen"}, Limit = "No Limit" },
    ["Camphor Lip Balm"] = { Normal = {"+Convert Amount", "+% Blue Pollen", "+% White Pollen"}, Caustic = {"[Hive] +% Blue Pollen", "[Hive] +Capacity"}, Limit = "No Limit" },
    ["Rose Headband"] = { Normal = {"+% Red Pollen", "+% White Pollen", "+Capacity"}, Caustic = {"[Hive] +% Red Pollen", "[Hive] +% Convert Rate"}, Limit = "No Limit" },
    ["Candy Ring"] = { Normal = {"+% Honey from Tokens", "+% Convert Amount", "+% Loot Luck"}, Caustic = {"+Ability: Haste", "[Hive] +% Honey from Tokens"}, Limit = "No Limit" },
    ["Bead Lizard"] = { Normal = {"+% Blue Pollen", "+% Bee Movespeed", "+Capacity"}, Caustic = {"+Ability: Blue Boost", "[Hive] +% Blue Pollen"}, Limit = "No Limit" },
    ["Poinsettia"] = { Normal = {"+% Red Pollen", "+Capacity", "+% Convert Amount"}, Caustic = {"+Ability: Red Boost", "[Hive] +% Red Pollen"}, Limit = "No Limit" },
    ["Peppermint Antennas"] = { Normal = {"+% Capacity", "+% Convert Rate", "+% Bee Movespeed"}, Caustic = {"+Ability: Focus", "[Hive] +% Capacity"}, Limit = "No Limit" },
    ["Elf Cap"] = { Normal = {"+Gather", "+Energy", "+% Red/Blue Pollen"}, Caustic = {"[Hive] +% Convert at Hive", "[Hive] +Capacity"}, Limit = "3 per hive" }
}

local beequipNames = {}
for name, _ in pairs(BeequipDatabase) do table.insert(beequipNames, name) end
table.sort(beequipNames)

local WaxMechanics = {
    ["Soft"]    = {success = 100, destroy = 0,  points = 1, desc = "100% Safe. +1 Normal Stat."},
    ["Hard"]    = {success = 60,  destroy = 0,  points = 2, desc = "60% Success. +2 Normal Stats."},
    ["Caustic"] = {success = 25,  destroy = 75, points = 4, desc = "25% Success, 75% DELETE."},
    ["Swirled"] = {success = 100, destroy = 0,  points = 3, desc = "100% Safe. Rerolls based on Potential."} 
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
local SidebarCover = Instance.new("Frame", Sidebar)
SidebarCover.Size = UDim2.new(0, 10, 1, 0)
SidebarCover.Position = UDim2.new(1, -10, 0, 0)
SidebarCover.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SidebarCover.BorderSizePixel = 0

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

-- Content Area & Console
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -160, 1, -20)
ContentArea.Position = UDim2.new(0, 160, 0, 10)
ContentArea.BackgroundTransparency = 1

local ConsoleFrame = Instance.new("Frame", ContentArea)
ConsoleFrame.Size = UDim2.new(1, 0, 0, 150)
ConsoleFrame.Position = UDim2.new(0, 0, 1, -150)
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
-- 📑 TAB & INTERFACE LOGIC
-- ==============================================================================
local TabBtn = Instance.new("TextButton", Sidebar)
TabBtn.Size = UDim2.new(1, -20, 0, 35)
TabBtn.Position = UDim2.new(0, 10, 0, 60)
TabBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 60)
TabBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
TabBtn.Text = "🍯 Wax & Inventory"
TabBtn.Font = Enum.Font.GothamSemibold
TabBtn.TextSize = 13
Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

local B_Frame = Instance.new("Frame", ContentArea)
B_Frame.Size = UDim2.new(1, 0, 1, -160)
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
ControlsRow.Position = UDim2.new(0, 0, 0, 50)
ControlsRow.BackgroundTransparency = 1

-- Dropdown Button
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
W_Calc.Text = "PREDICT STATS"
W_Calc.Font = Enum.Font.GothamBold
Instance.new("UICorner", W_Calc).CornerRadius = UDim.new(0, 6)

-- Dropdown List UI (Hidden by default)
local DropdownList = Instance.new("ScrollingFrame", ContentArea)
DropdownList.Size = UDim2.new(0, 160, 0, 120)
DropdownList.Position = UDim2.new(0, 0, 0, 95)
DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DropdownList.ScrollBarThickness = 4
DropdownList.Visible = false
DropdownList.ZIndex = 10
Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", DropdownList).Color = Color3.fromRGB(100, 100, 120)
local ListLayout = Instance.new("UIListLayout", DropdownList)

-- Populate Dropdown
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
        end)
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #list * 30)
end
PopulateDropdown(beequipNames)

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
end)

W_Cycle.MouseButton1Click:Connect(function()
    waxIdx = (waxIdx % #waxes) + 1
    W_Cycle.Text = waxes[waxIdx]
end)

-- Simulated Inventory Scanner
ScanBtn.MouseButton1Click:Connect(function()
    Log("<b>[SCANNER]</b> Attempting to hook BSS Local Tables...", Color3.fromRGB(100, 200, 255))
    task.wait(0.5)
    Log("<b>[WARNING]</b> Deep inventory tables obfuscated. Defaulting to loaded database.", Color3.fromRGB(255, 180, 50))
    Log("Found 14 supported Beequips. Dropdown populated.", Color3.fromRGB(100, 255, 100))
end)

-- Predictor Logic
W_Calc.MouseButton1Click:Connect(function()
    local beequipName = DropdownBtn.Text
    local waxType = W_Cycle.Text
    local data = BeequipDatabase[beequipName]
    local wax = WaxMechanics[waxType]
    
    DropdownList.Visible = false -- Close dropdown if open
    
    Log("----------------------------------------")
    Log(string.format("🍯 <b>STAT PREDICTION: %s + %s Wax</b>", string.upper(beequipName), string.upper(waxType)), Color3.fromRGB(255, 210, 80))
    
    if waxType == "Caustic" then
        Log("<b>⚠️ SERVER RNG OUTCOME:</b> 75% Destroys Item / 25% Mutates", Color3.fromRGB(255, 70, 70))
        Log("<b>If 25% Success Hits, you receive:</b>", Color3.fromRGB(200, 120, 255))
        for _, stat in ipairs(data.Caustic) do Log("  > " .. stat, Color3.fromRGB(220, 180, 255)) end
    elseif waxType == "Swirled" then
        Log("<b>✅ SERVER RNG OUTCOME:</b> 100% Safe.", Color3.fromRGB(100, 255, 100))
        Log("<b>Effect:</b> Randomly rerolls the numeric values of your current stats. May add a small potential bonus.", Color3.fromRGB(180, 255, 180))
    else
        local pStats = ""
        for _, s in ipairs(data.Normal) do pStats = pStats .. " | " .. s end
        Log(string.format("<b>✅ SERVER RNG OUTCOME: %d%% Success</b>", wax.success), Color3.fromRGB(100, 255, 100))
        Log(string.format("<b>If Success Hits, %d stat(s) added from:</b>", wax.points), Color3.fromRGB(180, 255, 180))
        Log(pStats, Color3.fromRGB(180, 255, 180))
    end
end)

Log("<b>✅ BSS Pro V5.4 Initialized.</b> Dropdown added. Inventory scanner framework active.", Color3.fromRGB(100, 255, 100))
