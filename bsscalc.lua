-- ==============================================================================
-- 🐝 BSS BEEQUIP ADVISOR ENGINE | V5.3 (STRIPPED & FOCUSED)
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local GUI_NAME = "BSS_Advisor_Engine_V5"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

-- ==============================================================================
-- 🧮 FOCUSED DATABASE ENGINE
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
    ["Caustic"] = {success = 25,  destroy = 75, points = 4, desc = "25% Success, 75% DELETE. Unlocks Caustic Pool."},
    ["Swirled"] = {success = 100, destroy = 0,  points = 3, desc = "100% Safe. Rerolls based on Potential."} 
}

-- ==============================================================================
-- 🖥️ GUI ARCHITECTURE (Modern Dark Theme)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
local success = pcall(function() ScreenGui.Parent = gethui() end)
if not success or not ScreenGui.Parent then ScreenGui.Parent = CoreGui end

-- Main Application Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarCover = Instance.new("Frame")
SidebarCover.Size = UDim2.new(0, 10, 1, 0)
SidebarCover.Position = UDim2.new(1, -10, 0, 0)
SidebarCover.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
SidebarCover.BorderSizePixel = 0
SidebarCover.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "🐝 BSS PRO"
Title.TextColor3 = Color3.fromRGB(255, 190, 60)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = Sidebar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, 370, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -20)
ContentArea.Position = UDim2.new(0, 150, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Output Console
local ConsoleFrame = Instance.new("Frame")
ConsoleFrame.Size = UDim2.new(1, 0, 0, 140)
ConsoleFrame.Position = UDim2.new(0, 0, 1, -140)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
ConsoleFrame.Parent = ContentArea
Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", ConsoleFrame).Color = Color3.fromRGB(40, 40, 50)

local OutputScroll = Instance.new("ScrollingFrame")
OutputScroll.Size = UDim2.new(1, -10, 1, -10)
OutputScroll.Position = UDim2.new(0, 5, 0, 5)
OutputScroll.BackgroundTransparency = 1
OutputScroll.ScrollBarThickness = 4
OutputScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
OutputScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
OutputScroll.Parent = ConsoleFrame
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
-- 📑 TAB MANAGEMENT SYSTEM
-- ==============================================================================
local Tabs = {}
local TabFrames = {}

local function CreateTabButton(name, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function CreateTabFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, -150)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = ContentArea
    return frame
end

local function SwitchTab(tabName)
    for name, btn in pairs(Tabs) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(255, 190, 60)
            btn.TextColor3 = Color3.fromRGB(20, 20, 25)
            TabFrames[name].Visible = true
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            TabFrames[name].Visible = false
        end
    end
end

-- ---------------------------------------------------------
-- TAB 1: BEEQUIP SIMULATOR
-- ---------------------------------------------------------
Tabs["Beequips"] = CreateTabButton("🍯 Wax Simulator", 60)
TabFrames["Beequips"] = CreateTabFrame()

local B_Frame = TabFrames["Beequips"]
Instance.new("UIListLayout", B_Frame).Padding = UDim.new(0, 10)

local bqIdx = 1
local waxes = {"Caustic", "Hard", "Soft", "Swirled"}
local waxIdx = 1

local W_Row = Instance.new("Frame", B_Frame)
W_Row.Size = UDim2.new(1, 0, 0, 40)
W_Row.BackgroundTransparency = 1

local B_Cycle = Instance.new("TextButton", W_Row)
B_Cycle.Size = UDim2.new(0, 150, 1, 0)
B_Cycle.BackgroundColor3 = Color3.fromRGB(70, 45, 90)
B_Cycle.TextColor3 = Color3.fromRGB(255, 255, 255)
B_Cycle.TextScaled = true
B_Cycle.Text = beequipNames[bqIdx]
B_Cycle.Font = Enum.Font.GothamBold
Instance.new("UICorner", B_Cycle).CornerRadius = UDim.new(0, 6)

local W_Cycle = Instance.new("TextButton", W_Row)
W_Cycle.Size = UDim2.new(0, 110, 1, 0)
W_Cycle.Position = UDim2.new(0, 160, 0, 0)
W_Cycle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
W_Cycle.TextColor3 = Color3.fromRGB(255, 255, 255)
W_Cycle.Text = waxes[waxIdx]
W_Cycle.Font = Enum.Font.GothamBold
Instance.new("UICorner", W_Cycle).CornerRadius = UDim.new(0, 6)

local W_Calc = Instance.new("TextButton", W_Row)
W_Calc.Size = UDim2.new(1, -280, 1, 0)
W_Calc.Position = UDim2.new(0, 280, 0, 0)
W_Calc.BackgroundColor3 = Color3.fromRGB(180, 120, 50)
W_Calc.TextColor3 = Color3.fromRGB(255, 255, 255)
W_Calc.Text = "WIKI PREDICT"
W_Calc.Font = Enum.Font.GothamBold
Instance.new("UICorner", W_Calc).CornerRadius = UDim.new(0, 6)

B_Cycle.MouseButton1Click:Connect(function()
    bqIdx = (bqIdx % #beequipNames) + 1
    B_Cycle.Text = beequipNames[bqIdx]
end)

W_Cycle.MouseButton1Click:Connect(function()
    waxIdx = (waxIdx % #waxes) + 1
    W_Cycle.Text = waxes[waxIdx]
end)

W_Calc.MouseButton1Click:Connect(function()
    local beequipName = B_Cycle.Text
    local waxType = W_Cycle.Text
    local data = BeequipDatabase[beequipName]
    local wax = WaxMechanics[waxType]
    
    Log("----------------------------------------")
    Log(string.format("🍯 <b>WAXING: %s with %s Wax</b>", string.upper(beequipName), string.upper(waxType)), Color3.fromRGB(255, 210, 80))
    Log(string.format("<b>Mechanics:</b> %s", wax.desc))
    Log(string.format("<b>Limit:</b> %s", data.Limit), Color3.fromRGB(150, 150, 150))
    
    if waxType == "Caustic" then
        Log("<b>⚠️ DANGER: 75% CHANCE TO DELETE ITEM FOREVER.</b>", Color3.fromRGB(255, 70, 70))
        Log("<b>✨ IF SUCCESS (25%): Unlocks Caustic stat pool:</b>", Color3.fromRGB(200, 120, 255))
        for _, stat in ipairs(data.Caustic) do Log("  > " .. stat, Color3.fromRGB(220, 180, 255)) end
    else
        local pStats = ""
        for _, s in ipairs(data.Normal) do pStats = pStats .. " | " .. s end
        Log(string.format("<b>✅ IF SUCCESS (%d%%): Adds %d stat(s) from:</b>", wax.success, wax.points), Color3.fromRGB(100, 255, 100))
        Log(pStats, Color3.fromRGB(180, 255, 180))
    end
end)

-- Link Buttons to Tabs
Tabs["Beequips"].MouseButton1Click:Connect(function() SwitchTab("Beequips") end)

-- Initialize
SwitchTab("Beequips")
Log("<b>✅ BSS Pro V5.3 Initialized.</b> Bloat removed. Pure Beequip focus active.", Color3.fromRGB(100, 255, 100))
