local LP = game:GetService("Players").LocalPlayer
local WS = game:GetService("Workspace")
local RS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local TS = game:GetService("TweenService")

local spdOn = false
local espOn = false

local espStates = { Gold = true, Key = true, Lever = true, Door = true, Chest = true, FakeDoor = true }
local monStates = { Rush = true, Ambush = true, Seek = true, Screech = true, Eyes = true, Halt = true, Figure = true, A60 = true, A90 = true, A120 = true }

-- تنظيف الواجهة
local guiTarget = LP:FindFirstChild("PlayerGui")
pcall(function() guiTarget = CG end)
pcall(function() guiTarget.DoorsProUI:Destroy() end)

local gui = Instance.new("ScreenGui", guiTarget)
gui.Name = "DoorsProUI"

local function addCorner(obj, radius)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius or 6)
end

-- ==========================================
-- 1. بناء الواجهة الرئيسية (Main UI)
-- ==========================================
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
addCorner(mainFrame, 8)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Color = Color3.fromRGB(80, 80, 90)
uiStroke.Thickness = 1

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
topBar.BorderSizePixel = 0
addCorner(topBar, 8)

local fixSquare = Instance.new("Frame", topBar)
fixSquare.Size = UDim2.new(1, 0, 0, 10)
fixSquare.Position = UDim2.new(0, 0, 1, -10)
fixSquare.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
fixSquare.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0.6, 10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Scripter Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local isMinimized = false
local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 30, 0, 25)
minBtn.Position = UDim2.new(1, -65, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
addCorner(minBtn, 4)

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
addCorner(closeBtn, 4)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1

minBtn.MouseButton1Down:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 200, 0, 35) or UDim2.new(0, 200, 0, 250)
    TS:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end)
closeBtn.MouseButton1Down:Connect(function() gui:Destroy() end)

local function makeBtn(parent, txt, y, func)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = txt
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    addCorner(btn, 6)

    btn.MouseButton1Down:Connect(function()
        TS:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.85, 0, 0, 31), Position = UDim2.new(0.075, 0, 0, y+2)}):Play()
        task.wait(0.1)
        TS:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0, 35), Position = UDim2.new(0.05, 0, 0, y)}):Play()
        func(btn)
    end)
    return btn
end

-- ==========================================
-- 2. نظام القوائم الجانبية المنسدلة
-- ==========================================
local function createMenu(titleText, stateTable)
    local menu = Instance.new("Frame", mainFrame)
    menu.Size = UDim2.new(1, 0, 1, -35)
    menu.Position = UDim2.new(1, 0, 0, 35)
    menu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    menu.BorderSizePixel = 0
    
    local mTop = Instance.new("Frame", menu)
    mTop.Size = UDim2.new(1, 0, 0, 30)
    mTop.BackgroundTransparency = 1
    
    local mTitle = Instance.new("TextLabel", mTop)
    mTitle.Size = UDim2.new(0.6, 0, 1, 0)
    mTitle.Position = UDim2.new(0, 10, 0, 0)
    mTitle.BackgroundTransparency = 1
    mTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    mTitle.Text = titleText
    mTitle.Font = Enum.Font.GothamBold
    mTitle.TextSize = 12
    mTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local mClose = Instance.new("TextButton", mTop)
    mClose.Size = UDim2.new(0, 50, 0, 20)
    mClose.Position = UDim2.new(1, -55, 0, 5)
    mClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    mClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    mClose.Text = "Back"
    mClose.Font = Enum.Font.GothamBold
    mClose.TextSize = 11
    addCorner(mClose, 4)
    
    mClose.MouseButton1Down:Connect(function()
        TS:Create(menu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 0, 0, 35)}):Play()
    end)
    
    local scroll = Instance.new("ScrollingFrame", menu)
    scroll.Size = UDim2.new(1, 0, 1, -65)
    scroll.Position = UDim2.new(0, 0, 0, 65)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    
    local uiBoxes = {}
    
    local selectAllBtn = Instance.new("TextButton", menu)
    selectAllBtn.Size = UDim2.new(0.9, 0, 0, 25)
    selectAllBtn.Position = UDim2.new(0.05, 0, 0, 35)
    selectAllBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    selectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectAllBtn.Text = "Select / Deselect All"
    selectAllBtn.Font = Enum.Font.GothamBold
    selectAllBtn.TextSize = 12
    addCorner(selectAllBtn, 4)
    
    selectAllBtn.MouseButton1Down:Connect(function()
        local allOn = true
        for k, v in pairs(stateTable) do if not v then allOn = false break end end
        local newState = not allOn
        for k, _ in pairs(stateTable) do
            stateTable[k] = newState
            if uiBoxes[k] then
                uiBoxes[k].Text = newState and "✓" or ""
                uiBoxes[k].Parent.BackgroundColor3 = newState and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 60)
            end
        end
    end)
    
    local yPos = 0
    for key, _ in pairs(stateTable) do
        local row = Instance.new("TextButton", scroll)
        row.Size = UDim2.new(0.9, 0, 0, 30)
        row.Position = UDim2.new(0.05, 0, 0, yPos)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        row.Text = "  " .. key
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextColor3 = Color3.fromRGB(200, 200, 200)
        row.Font = Enum.Font.Gotham
        row.TextSize = 12
        addCorner(row, 4)
        
        local checkBg = Instance.new("Frame", row)
        checkBg.Size = UDim2.new(0, 20, 0, 20)
        checkBg.Position = UDim2.new(1, -25, 0.5, -10)
        checkBg.BackgroundColor3 = stateTable[key] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 60)
        addCorner(checkBg, 4)
        
        local checkMark = Instance.new("TextLabel", checkBg)
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Text = stateTable[key] and "✓" or ""
        checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
        checkMark.Font = Enum.Font.GothamBold
        checkMark.TextSize = 14
        
        uiBoxes[key] = checkMark
        
        row.MouseButton1Down:Connect(function()
            stateTable[key] = not stateTable[key]
            checkMark.Text = stateTable[key] and "✓" or ""
            TS:Create(checkBg, TweenInfo.new(0.2), {BackgroundColor3 = stateTable[key] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 50, 60)}):Play()
        end)
        yPos = yPos + 35
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    return menu
end

local espMenu = createMenu("ESP Settings", espStates)
local monMenu = createMenu("Monster Settings", monStates)

local btnSpd = makeBtn(contentFrame, "Speed: OFF", 15, function(btn)
    spdOn = not spdOn
    btn.Text = spdOn and "Speed: ON" or "Speed: OFF"
    TS:Create(btn, TweenInfo.new(0.3), {TextColor3 = spdOn and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(200, 200, 200)}):Play()
end)

local btnEsp = makeBtn(contentFrame, "Toggle ESP", 60, function(btn)
    espOn = not espOn
    btn.Text = espOn and "ESP: ON" or "Toggle ESP"
    TS:Create(btn, TweenInfo.new(0.3), {TextColor3 = espOn and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(200, 200, 200)}):Play()
end)

makeBtn(contentFrame, "⚙️ ESP Items", 105, function()
    TS:Create(espMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 35)}):Play()
end)

makeBtn(contentFrame, "⚙️ Monsters", 150, function()
    TS:Create(monMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 0, 0, 35)}):Play()
end)

-- ==========================================
-- 3. نظام التنبيه في الزاوية اليمنى (باللون الرمادي)
-- ==========================================
local warnFrame = Instance.new("Frame", gui)
warnFrame.Size = UDim2.new(0, 250, 0, 45)
warnFrame.Position = UDim2.new(1, 10, 0, 20) -- مخفي خارج الشاشة يميناً
warnFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- رمادي أنيق
addCorner(warnFrame, 8)

-- حدود رمادية فاتحة للتنبيه
local warnStroke = Instance.new("UIStroke", warnFrame)
warnStroke.Color = Color3.fromRGB(150, 150, 150)
warnStroke.Thickness = 1.5

local warnText = Instance.new("TextLabel", warnFrame)
warnText.Size = UDim2.new(1, 0, 1, 0)
warnText.BackgroundTransparency = 1
warnText.TextColor3 = Color3.fromRGB(255, 255, 255)
warnText.Font = Enum.Font.GothamBold
warnText.TextSize = 14

local isWarning = false
local function triggerWarning(msg)
    if isWarning then return end
    isWarning = true
    warnText.Text = "⚠️ " .. msg
    
    -- تنزلق للداخل (تظهر)
    TS:Create(warnFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -260, 0, 20)}):Play()
    
    -- تبقى لمدة 3.5 ثوانٍ فقط
    task.wait(3.5)
    
    -- تنزلق للخارج (تختفي تماماً)
    TS:Create(warnFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 10, 0, 20)}):Play()
    task.wait(0.4)
    isWarning = false
end

local function detectMonster(n)
    n = string.lower(n)
    if string.find(n, "rush") and monStates.Rush then triggerWarning("RUSH COMING!")
    elseif string.find(n, "ambush") and monStates.Ambush then triggerWarning("AMBUSH COMING!")
    elseif string.find(n, "seek") and monStates.Seek then triggerWarning("SEEK IS HERE!")
    elseif string.find(n, "screech") and monStates.Screech then triggerWarning("SCREECH! (LOOK AROUND)")
    elseif string.find(n, "eyes") and monStates.Eyes then triggerWarning("EYES! (DON'T LOOK)")
    elseif string.find(n, "halt") and monStates.Halt then triggerWarning("HALT ROOM AHEAD!")
    elseif string.find(n, "figure") and monStates.Figure then triggerWarning("FIGURE IS NEAR!")
    elseif string.find(n, "a60") and monStates.A60 then triggerWarning("A-60 COMING!")
    elseif string.find(n, "a90") and monStates.A90 then triggerWarning("A-90! (STOP MOVING!)")
    elseif string.find(n, "a120") and monStates.A120 then triggerWarning("A-120 COMING!")
    end
end

WS.ChildAdded:Connect(function(c) detectMonster(c.Name) end)
if WS.CurrentCamera then WS.CurrentCamera.ChildAdded:Connect(function(c) detectMonster(c.Name) end) end

-- ==========================================
-- 4. الأنظمة الخلفية (السرعة و ESP)
-- ==========================================
RS.RenderStepped:Connect(function()
    if spdOn then pcall(function() LP.Character.Humanoid.WalkSpeed = 21 end) end
end)

local function drawESP(obj, txt, color, typeName)
    if obj:FindFirstChild("MarkESP") then return end
    local mark = Instance.new("StringValue", obj)
    mark.Name = "MarkESP"
    mark.Value = typeName

    local bg = Instance.new("BillboardGui", obj)
    bg.Name = "EspGui"
    bg.Size = UDim2.new(0, 100, 0, 30)
    bg.AlwaysOnTop = true

    local tl = Instance.new("TextLabel", bg)
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color
    tl.TextStrokeTransparency = 1
    tl.Text = txt
    tl.TextSize = 13
    tl.Font = Enum.Font.GothamBold

    local hl = Instance.new("Highlight", obj)
    hl.Name = "EspHl"
    hl.FillColor = color
    hl.FillTransparency = 0.7
    hl.OutlineColor = color
end

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(WS:GetDescendants()) do
            if v.Name == "MarkESP" then
                if not espOn or not espStates[v.Value] then
                    if v.Parent:FindFirstChild("EspGui") then v.Parent.EspGui:Destroy() end
                    if v.Parent:FindFirstChild("EspHl") then v.Parent.EspHl:Destroy() end
                    v:Destroy()
                end
            end
        end

        if not espOn then continue end
        local rooms = WS:FindFirstChild("CurrentRooms")
        if not rooms then continue end
        
        for _, r in pairs(rooms:GetChildren()) do
            for _, i in pairs(r:GetDescendants()) do
                if i:IsA("Model") or i:IsA("Part") then
                    if i.Name == "GoldCoin" and espStates.Gold then 
                        drawESP(i, "Gold", Color3.fromRGB(255, 215, 0), "Gold")
                    elseif i.Name == "KeyObtain" and espStates.Key then 
                        drawESP(i, "Key", Color3.fromRGB(50, 255, 100), "Key")
                    elseif i.Name == "LeverForGate" and espStates.Lever then 
                        drawESP(i, "Lever", Color3.fromRGB(50, 150, 255), "Lever")
                    elseif i.Name == "Door" and i.Parent == r and espStates.Door then 
                        drawESP(i, "Door", Color3.fromRGB(200, 200, 200), "Door")
                    elseif string.find(i.Name, "ChestBox") and espStates.Chest then 
                        drawESP(i, "Chest", Color3.fromRGB(255, 150, 50), "Chest")
                    elseif (i.Name == "FakeDoor" or i.Name == "TrickDoor") and espStates.FakeDoor then
                        pcall(function() 
                            local prompt = i:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then prompt:Destroy() end
                        end)
                        drawESP(i, "[FAKE]", Color3.fromRGB(255, 50, 50), "FakeDoor")
                    end
                end
            end
        end
    end
end)
