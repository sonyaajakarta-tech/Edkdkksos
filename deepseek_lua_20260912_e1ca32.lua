-- ============================================================
-- CHIPS FARM — Simple UI (Fixed Logic)
-- ============================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

while not Players.LocalPlayer do task.wait(0.1) end
local LocalPlayer = Players.LocalPlayer

local UI_Target = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

for _, name in ipairs({"ChipsFarm_UI"}) do
    local old = UI_Target:FindFirstChild(name)
    if old then old:Destroy() end
end

local originalGravity = Workspace.Gravity

-- ============================================================
-- CONFIG
-- ============================================================
local CHIPS_STORE = Vector3.new(-773.72, 3.66, -187.54)   -- ← KILL TP ke sini

local POTS = {
    Vector3.new(-515.28, 3.86, -451.71),  -- Pot 1
    Vector3.new(-515.24, 3.86, -462.26),  -- Pot 2
    Vector3.new(-515.28, 3.86, -471.89),  -- Pot 3
    Vector3.new(-515.28, 3.86, -481.75),  -- Pot 4
    Vector3.new(-515.24, 3.86, -492.10),  -- Pot 5
}

local State = {
    running     = false,
    cookCount   = 10,   -- 1 - 40 (nanti jadi qty buy juga)
    selectedPot = 1,    -- 1 - 5
    currentCook = 0,
}

-- ============================================================
-- ANTI-AFK
-- ============================================================
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)
end)

-- ============================================================
-- GHOST MODE (untuk blinkTeleport)
-- ============================================================
local modifiedParts = {}
local ghostConn = nil

local function startGhostMode()
    if ghostConn then return end
    ghostConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Sit then return end
        local hrp = char.HumanoidRootPart

        local function processPart(part)
            if not part or not part:IsA("BasePart") or part:IsA("Terrain") then return end
            if part:IsDescendantOf(char) then return end
            if part:IsA("Seat") or part:IsA("VehicleSeat") or part.Name:lower():find("seat") then return end
            if not modifiedParts[part] then
                modifiedParts[part] = { CanCollide = part.CanCollide, CanTouch = part.CanTouch }
            end
            part.CanCollide = false
            part.CanTouch = false
        end

        for _, part in ipairs(hrp:GetTouchingParts()) do processPart(part) end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}

        for _, dir in ipairs({
            Vector3.new(0, -4, 0),
            hrp.CFrame.LookVector * 3.5,
            -hrp.CFrame.LookVector * 3.5,
            hrp.CFrame.RightVector * 3.5,
            -hrp.CFrame.RightVector * 3.5
        }) do
            local res = Workspace:Raycast(hrp.Position, dir, params)
            if res and res.Instance then processPart(res.Instance) end
        end
    end)
end

local function stopGhostMode()
    if ghostConn then ghostConn:Disconnect(); ghostConn = nil end
    for part, state in pairs(modifiedParts) do
        if part and part.Parent then
            part.CanCollide = state.CanCollide
            part.CanTouch   = state.CanTouch
        end
    end
    modifiedParts = {}
end

-- ============================================================
-- TELEPORT
-- ============================================================
local function discreteStepTP(startP, endP)
    local stepDist = 0.8
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = char.HumanoidRootPart

    while State.running do
        local dist = (endP - hrp.Position).Magnitude
        if dist <= stepDist then
            hrp.CFrame = CFrame.new(endP)
            hrp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            return true
        else
            hrp.CFrame = CFrame.new(hrp.Position + ((endP - hrp.Position).Unit * stepDist))
            hrp.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        task.wait(0.08)
    end
    return false
end

local function blinkTeleport(targetPos, isUnderground)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    startGhostMode()
    local hrp      = char.HumanoidRootPart
    local humanoid = char:FindFirstChild("Humanoid")
    humanoid.PlatformStand = true
    Workspace.Gravity = 0

    if isUnderground then
        local underY = -4
        discreteStepTP(hrp.Position, Vector3.new(hrp.Position.X, underY, hrp.Position.Z))
        discreteStepTP(hrp.Position, Vector3.new(targetPos.X, underY, targetPos.Z))
        discreteStepTP(hrp.Position, targetPos)
    else
        discreteStepTP(hrp.Position, targetPos)
    end

    Workspace.Gravity = originalGravity
    humanoid.PlatformStand = false
    stopGhostMode()
end

-- KILL TP (respawn warp)
local function killTP(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 9e9, 0)
        bv.Parent   = hrp
    end

    local newChar = LocalPlayer.CharacterAdded:Wait()
    local newHrp  = newChar:WaitForChild("HumanoidRootPart", 10)
    if newHrp then
        task.wait(0.5)
        newHrp.CFrame = CFrame.new(targetPos)
        task.wait(0.2)
        newHrp.CFrame = CFrame.new(targetPos)
    end
    task.wait(1.2)
end

-- ============================================================
-- PROXIMITY PROMPT
-- ============================================================
local function makePromptInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
    end
end
for _, obj in ipairs(Workspace:GetDescendants()) do makePromptInstant(obj) end
Workspace.DescendantAdded:Connect(makePromptInstant)

local function firePromptAt(pos, maxDist, keyword)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local pPos = obj.Parent and (
                obj.Parent:IsA("BasePart") and obj.Parent.Position or
                (obj.Parent:IsA("Attachment") and obj.Parent.WorldPosition)
            )
            if pPos and (pos - pPos).Magnitude <= maxDist then
                local match = true
                if keyword then
                    match = string.find(string.lower(obj.ActionText or ""), string.lower(keyword)) ~= nil
                end
                if match then
                    obj.RequiresLineOfSight = false
                    obj.HoldDuration = 0
                    if fireproximityprompt then
                        fireproximityprompt(obj, 0)
                    else
                        obj:InputHoldBegin(); task.wait(0.05); obj:InputHoldEnd()
                    end
                    return true
                end
            end
        end
    end
    return false
end

-- ============================================================
-- INVENTORY
-- ============================================================
local function countTool(names)
    local count = 0
    local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack") }
    for _, cont in ipairs(containers) do
        if cont then
            for _, item in ipairs(cont:GetChildren()) do
                if item:IsA("Tool") then
                    if type(names) == "table" then
                        for _, n in ipairs(names) do
                            if item.Name == n then count = count + 1 end
                        end
                    elseif item.Name == names then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

local function equipTool(name)
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    if char:FindFirstChild(name) then return true end
    hum:UnequipTools()
    task.wait(0.05)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local tool = bp and bp:FindFirstChild(name)
    if tool then
        hum:EquipTool(tool)
        task.wait(0.1)
        return true
    end
    return false
end

-- ============================================================
-- AUTO BUY CHIPS (Potato & Flour)
-- ============================================================
local function buyChipsItems(itemNames, qty)
    local remEvts = ReplicatedStorage:FindFirstChild("RemoteEvents")
    local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
    if not spRE then
        warn("[CHIP BUY] StorePurchase RemoteEvent tidak ditemukan!")
        return false
    end

    local totalBought = 0
    for _, itemName in ipairs(itemNames) do
        if not State.running then break end

        local before = countTool(itemName)
        updateStatus(("Beli %s ×%d..."):format(itemName, qty), Color3.fromRGB(255, 200, 60))

        for i = 1, qty do
            if not State.running then break end
            pcall(function() spRE:FireServer(itemName, 1) end)
            task.wait(0.4)
        end

        -- Tunggu item masuk (max 8s)
        local elapsed = 0
        local gained = 0
        repeat
            task.wait(0.2)
            elapsed += 0.2
            gained = countTool(itemName) - before
        until gained >= qty or elapsed > 8

        -- Retry kalau kurang
        local missing = qty - gained
        if missing > 0 then
            for i = 1, missing do
                if not State.running then break end
                pcall(function() spRE:FireServer(itemName, 1) end)
                task.wait(0.5)
            end
            elapsed = 0
            repeat
                task.wait(0.2)
                elapsed += 0.2
                gained = countTool(itemName) - before
            until gained >= qty or elapsed > 5
        end

        totalBought += gained
        task.wait(0.3)
    end

    return totalBought > 0
end

-- ============================================================
-- MAIN FARM LOGIC
-- ============================================================
local function doChipsFarm()
    local totalCook = State.cookCount
    local potPos    = POTS[State.selectedPot]

    -- ─── STEP 1: KILL TP KE CHIPS STORE ───────────────────
    updateStatus("KILL TP → Chips Store...", Color3.fromRGB(220, 80, 80))
    killTP(CHIPS_STORE)
    if not State.running then return end
    task.wait(0.6)

    -- ─── STEP 2: AUTO BUY POTATO & FLOUR ──────────────────
    updateStatus("Auto buy Potato & Flour ×" .. totalCook, Color3.fromRGB(255, 200, 60))
    buyChipsItems({"Potato", "Flour"}, totalCook)
    if not State.running then return end
    task.wait(0.5)

    -- ─── STEP 3: BLINK TP KE POT ──────────────────────────
    updateStatus("Blink TP → Pot " .. State.selectedPot, Color3.fromRGB(80, 200, 255))
    blinkTeleport(potPos, true)
    if not State.running then return end
    task.wait(0.4)

    -- ─── STEP 4: LOOP MASAK ───────────────────────────────
    State.currentCook = 0
    updateProgress(0, totalCook)

    while State.running and State.currentCook < totalCook do
        local n = State.currentCook + 1
        updateStatus(string.format("Masak %d/%d...", n, totalCook), Color3.fromRGB(80, 200, 255))

        -- 4a. Potato
        equipTool("Potato")
        task.wait(0.25)
        firePromptAt(potPos, 8)
        task.wait(0.35)
        if not State.running then return end

        -- 4b. Flour
        equipTool("Flour")
        task.wait(0.25)
        firePromptAt(potPos, 8)
        task.wait(0.35)
        if not State.running then return end

        -- 4c. Tunggu masak 60s
        for i = 1, 60 do
            if not State.running then return end
            task.wait(1)
            if i % 5 == 0 then
                updateStatus(string.format("Masak %d/%d (sisa %ds)", n, totalCook, 60 - i),
                    Color3.fromRGB(80, 200, 255))
            end
        end

        -- 4d. Claim pakai Empty Bag
        equipTool("Empty Bag")
        task.wait(0.25)
        firePromptAt(potPos, 8)
        task.wait(1)

        State.currentCook = State.currentCook + 1
        updateProgress(State.currentCook, totalCook)
    end

    if State.running then
        updateStatus("Selesai! " .. totalCook .. " chips.", Color3.fromRGB(0, 220, 100))
    end
end

-- ============================================================
-- UI
-- ============================================================
local UI = {}

local Gui = Instance.new("ScreenGui")
Gui.Name = "ChipsFarm_UI"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 9999
Gui.Parent = UI_Target

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 220, 0, 250)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Color3.fromRGB(50, 50, 60)
mainStroke.Thickness = 1

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 34)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local headerFix = Instance.new("Frame", Header)
headerFix.Size = UDim2.new(1, 0, 0, 8)
headerFix.Position = UDim2.new(0, 0, 1, -8)
headerFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
headerFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍟 CHIPS FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -44)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============ ON / OFF ============
local ToggleBtn = Instance.new("TextButton", Content)
ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 14
ToggleBtn.AutoButtonColor = false
ToggleBtn.LayoutOrder = 1
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local toggleStroke = Instance.new("UIStroke", ToggleBtn)
toggleStroke.Color = Color3.fromRGB(80, 25, 25)
toggleStroke.Thickness = 1

-- ============ SLIDER JUMLAH MASAK ============
local CookCard = Instance.new("Frame", Content)
CookCard.Size = UDim2.new(1, 0, 0, 52)
CookCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
CookCard.LayoutOrder = 2
Instance.new("UICorner", CookCard).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", CookCard).Color = Color3.fromRGB(40, 40, 50)

local CookLabel = Instance.new("TextLabel", CookCard)
CookLabel.Size = UDim2.new(1, -16, 0, 18)
CookLabel.Position = UDim2.new(0, 8, 0, 4)
CookLabel.BackgroundTransparency = 1
CookLabel.Text = "Jumlah Masak: " .. State.cookCount
CookLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CookLabel.Font = Enum.Font.GothamBold
CookLabel.TextSize = 12
CookLabel.TextXAlignment = Enum.TextXAlignment.Left

local CookTrack = Instance.new("Frame", CookCard)
CookTrack.Size = UDim2.new(1, -16, 0, 6)
CookTrack.Position = UDim2.new(0, 8, 0, 34)
CookTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Instance.new("UICorner", CookTrack).CornerRadius = UDim.new(1, 0)

local CookFill = Instance.new("Frame", CookTrack)
CookFill.Size = UDim2.new((State.cookCount - 1) / 39, 0, 1, 0)
CookFill.BackgroundColor3 = Color3.fromRGB(255, 160, 60)
Instance.new("UICorner", CookFill).CornerRadius = UDim.new(1, 0)

local CookKnob = Instance.new("Frame", CookTrack)
CookKnob.Size = UDim2.new(0, 14, 0, 14)
CookKnob.Position = UDim2.new((State.cookCount - 1) / 39, -7, 0.5, -7)
CookKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CookKnob).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", CookKnob).Color = Color3.fromRGB(80, 80, 80)

local draggingSlider = false
local function updateCookSlider(input)
    local rel = math.clamp((input.Position.X - CookTrack.AbsolutePosition.X) / CookTrack.AbsoluteSize.X, 0, 1)
    State.cookCount = math.floor(1 + rel * 39)
    CookFill.Size = UDim2.new(rel, 0, 1, 0)
    CookKnob.Position = UDim2.new(rel, -7, 0.5, -7)
    CookLabel.Text = "Jumlah Masak: " .. State.cookCount
end

CookTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        updateCookSlider(input)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        updateCookSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

-- ============ POT SELECTOR ============
local PotCard = Instance.new("Frame", Content)
PotCard.Size = UDim2.new(1, 0, 0, 62)
PotCard.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
PotCard.LayoutOrder = 3
Instance.new("UICorner", PotCard).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", PotCard).Color = Color3.fromRGB(40, 40, 50)

local PotLabel = Instance.new("TextLabel", PotCard)
PotLabel.Size = UDim2.new(1, -16, 0, 16)
PotLabel.Position = UDim2.new(0, 8, 0, 4)
PotLabel.BackgroundTransparency = 1
PotLabel.Text = "Pilih Pot: " .. State.selectedPot
PotLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PotLabel.Font = Enum.Font.GothamBold
PotLabel.TextSize = 12
PotLabel.TextXAlignment = Enum.TextXAlignment.Left

local potBtns = {}
local potRow = Instance.new("Frame", PotCard)
potRow.Size = UDim2.new(1, -16, 0, 30)
potRow.Position = UDim2.new(0, 8, 0, 26)
potRow.BackgroundTransparency = 1

local potLayout = Instance.new("UIListLayout", potRow)
potLayout.FillDirection = Enum.FillDirection.Horizontal
potLayout.Padding = UDim.new(0, 4)
potLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i = 1, 5 do
    local btn = Instance.new("TextButton", potRow)
    btn.Size = UDim2.new(0, 34, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    btn.Text = tostring(i)
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(50, 50, 60)
    table.insert(potBtns, btn)

    btn.MouseButton1Click:Connect(function()
        if State.running then return end
        State.selectedPot = i
        PotLabel.Text = "Pilih Pot: " .. i
        for idx, b in ipairs(potBtns) do
            if idx == i then
                b.BackgroundColor3 = Color3.fromRGB(20, 70, 130)
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                b.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
                b.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end)
end

potBtns[1].BackgroundColor3 = Color3.fromRGB(20, 70, 130)
potBtns[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- ============ STATUS ============
local StatusLabel = Instance.new("TextLabel", Content)
StatusLabel.Size = UDim2.new(1, 0, 0, 18)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.LayoutOrder = 4
UI.StatusLabel = StatusLabel

local ProgressLabel = Instance.new("TextLabel", Content)
ProgressLabel.Size = UDim2.new(1, 0, 0, 18)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Cook: 0/0"
ProgressLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ProgressLabel.Font = Enum.Font.GothamBold
ProgressLabel.TextSize = 11
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.LayoutOrder = 5
UI.ProgressLabel = ProgressLabel

function updateStatus(txt, col)
    if UI.StatusLabel then
        UI.StatusLabel.Text = txt
        if col then UI.StatusLabel.TextColor3 = col end
    end
end

function updateProgress(cur, total)
    if UI.ProgressLabel then
        UI.ProgressLabel.Text = string.format("Cook: %d/%d", cur, total)
    end
end

-- ============================================================
-- TOGGLE
-- ============================================================
local function setRunning(state)
    State.running = state
    if state then
        ToggleBtn.Text = "ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 45, 20)
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 220, 100)
        toggleStroke.Color = Color3.fromRGB(30, 100, 50)
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
        ToggleBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
        toggleStroke.Color = Color3.fromRGB(80, 25, 25)
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    if State.running then
        State.running = false
        setRunning(false)
        updateStatus("Dihentikan.", Color3.fromRGB(180, 60, 60))
    else
        State.running = true
        setRunning(true)
        updateStatus("Memulai...", Color3.fromRGB(255, 200, 60))
        task.spawn(function()
            local ok, err = pcall(doChipsFarm)
            if not ok then
                warn("[ChipsFarm] Error:", err)
                updateStatus("Error: " .. tostring(err), Color3.fromRGB(255, 80, 80))
            end
            State.running = false
            setRunning(false)
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    State.running = false
    Gui:Destroy()
end)

setRunning(false)
updateStatus("Idle", Color3.fromRGB(150, 150, 150))