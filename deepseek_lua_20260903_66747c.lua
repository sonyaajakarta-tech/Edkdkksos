-- ============================================================
-- STR HUB | Cali Streets
-- Cleaned version by removing obfuscation leftovers
-- Original deobfuscated by NNVN Hub & BaconCheatz
-- ============================================================

-- Deklarasi fungsi dekripsi (harus ada di lingkungan eksekusi)
local DecodeString = DecodeString or function(s, key)
    -- Placeholder: jika tidak tersedia, kembalikan string asli
    return s
end

-- Tabel string (dari obfuskasi)
local StringTable = StringTable or setmetatable({}, {
    __index = function(t, k)
        -- fallback ke k (untuk keperluan debugging)
        return k
    end,
    __metatable = nil
})

-- ============================================================
-- AMBIENT & VARIABEL GLOBAL
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local setclipboard = setclipboard or toboard or writeclipboard

-- ============================================================
-- WEBHOOK LOGGER (opsional, tetap dipertahankan)
-- ============================================================
local WebhookURL = "https://discord.com/api/webhooks/1541446505104281763/L1WexPhFcug6t5kGDxiRgAvnzfXpoFLJ2YDfTI3Gqedeprpa0jYNz7_zcRfSzDYtr44T"
task.spawn(function()
    local requestFunc = syn and syn.request or (http and http.request or http_request)
    if not requestFunc then return end
    local gameName = "Cali Streets"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)
    local payload = {
        embeds = {{
            title = "ð | **Execution Logger**",
            description = string.format("âï¸ -  **NEW:** Exploiter executed an STR script.\nð· - **Game:** %s", gameName),
            footer = { text = "by @darkhub" },
            color = 65535
        }}
    }
    pcall(function()
        requestFunc({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end)

-- ============================================================
-- HAPUS GUI LAMA
-- ============================================================
local function destroyGUI(name)
    local gui = CoreGui:FindFirstChild(name)
    if gui then gui:Destroy() end
end
destroyGUI("STRHUB_LoadingScreen")
destroyGUI("MobileToggleGui")
destroyGUI("CaliStreetsWatermark")
destroyGUI("STRHUB_AutoFarmGUI")
destroyGUI("CustomAimbotGui")

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "STRHUB_LoadingScreen"
LoadingScreen.Parent = CoreGui
LoadingScreen.ResetOnSpawn = false
LoadingScreen.IgnoreGuiInset = true
LoadingScreen.DisplayOrder = 99999

local LoadFrame = Instance.new("CanvasGroup")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(1,0,1,0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(8,8,8)
LoadFrame.BorderSizePixel = 0
LoadFrame.GroupTransparency = 0
LoadFrame.Parent = LoadingScreen

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255,255,255)
Stroke.Thickness = 1
Stroke.Transparency = 0.85
Stroke.Parent = LoadFrame

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.AnchorPoint = Vector2.new(0.5,0.5)
Container.Position = UDim2.new(0.5,0,0.5,0)
Container.Size = UDim2.new(0,420,0,200)
Container.BackgroundTransparency = 1
Container.Parent = LoadFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1,0,0,45)
Title.Position = UDim2.new(0,0,0,10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "DARK HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 38
Title.Parent = Container

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(255,255,255)
TitleStroke.Thickness = 2
TitleStroke.Transparency = 0.2
TitleStroke.Parent = Title

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1,0,0,20)
Subtitle.Position = UDim2.new(0,0,0,58)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.Text = "STR HUB  |  Cali Streets"
Subtitle.TextColor3 = Color3.fromRGB(150,150,150)
Subtitle.TextSize = 11
Subtitle.Parent = Container

local BarBackground = Instance.new("Frame")
BarBackground.Name = "BarBackground"
BarBackground.AnchorPoint = Vector2.new(0.5,0)
BarBackground.Position = UDim2.new(0.5,0,0,115)
BarBackground.Size = UDim2.new(0,360,0,8)
BarBackground.BackgroundColor3 = Color3.fromRGB(20,20,20)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = Container

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1,0)
BarCorner.Parent = BarBackground

local BarStroke = Instance.new("UIStroke")
BarStroke.Color = Color3.fromRGB(255,255,255)
BarStroke.Thickness = 1
BarStroke.Transparency = 0.6
BarStroke.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Name = "BarFill"
BarFill.Size = UDim2.new(0,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1,0)
FillCorner.Parent = BarFill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.7,0,0,20)
StatusLabel.Position = UDim2.new(0.08,0,0,133)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Loading"
StatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Container

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Name = "PercentLabel"
PercentLabel.Size = UDim2.new(0.2,0,0,20)
PercentLabel.Position = UDim2.new(0.72,0,0,133)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255,255,255)
PercentLabel.TextSize = 12
PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
PercentLabel.Parent = Container

local loadingActive = true
local loadingText = "Initializing Core"
task.spawn(function()
    while loadingActive do
        StatusLabel.Text = loadingText .. string.rep(".", (#StatusLabel.Text % 3) + 1)
        task.wait(0.35)
    end
end)

local function updateProgress(progress, statusText)
    if statusText then
        loadingText = statusText
        PercentLabel.Text = math.floor(progress * 100) .. "%"
        local tween = TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(progress, 0, 1, 0)
        })
        tween:Play()
    end
end

updateProgress(0.15, "Loading Modded UI")

-- ============================================================
-- LOAD FLUENT UI (MODDED)
-- ============================================================
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"))()
updateProgress(0.35, "Creating Windows & Modules")

local Window = Fluent:CreateWindow({
    Title = "Dark HUB | Cali Streets",
    SubTitle = "by @darkhub",
    TabWidth = 160,
    Size = UDim2.fromOffset(480,320),
    Acrylic = true,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Search = true
})

-- Tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "solar/home-bold" })
local AutoFarmTab = Window:AddTab({ Title = "Auto Farm", Icon = "solar/card-bold" })
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "solar/target-bold" })
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "solar/eye-bold" })
local SocialsTab = Window:AddTab({ Title = "Socials", Icon = "solar/chat-round-dots-bold" })
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "solar/user-heart-bold" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })

-- Global toggle states
_G.InfiniteStaminaEnabled = false
_G.AutoLoot = false
_G.NoJumpCooldownEnabled = false
_G.ESPEnabled = false
_G.FPSBoostUsed = false
_G.NoclipEnabled = false
_G.WalkSpeedEnabled = false
_G.WalkSpeedMultiplier = 1.25
_G.InstantInteractEnabled = false
_G.InfiniteZoomEnabled = false
_G.CustomAutoFarmVisible = false
_G.AutoFarmDraggable = true
local autoFarmRunning = false
_G.CustomAimbotVisible = false
_G.CustomAimbotActive = false
_G.AimbotDraggable = true
local aimbotFOV = 120
local noRecoilActive = false
local recoilMemory = {}

updateProgress(0.55, "Injecting Game Hooks & Features")

-- ============================================================
-- MAIN TAB
-- ============================================================
MainTab:AddToggle("InfiniteStamina", {
    Title = "Infinite Stamina",
    Description = "Locks stamina at 100 so you can sprint endlessly.",
    Default = false,
    Callback = function(val) _G.InfiniteStaminaEnabled = val end
})

MainTab:AddToggle("AutoPickup", {
    Title = "Auto Pickup Dropped Loot",
    Description = "Teleports dropped tools to you.",
    Default = false,
    Callback = function(val)
        _G.AutoLoot = val
        if val then
            task.spawn(function()
                while _G.AutoLoot do
                    pcall(function()
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj:IsA("Tool") or string.find(obj.Name:lower(), "loot") then
                                local handle = obj:FindFirstChild("Handle")
                                local char = LocalPlayer.Character
                                local root = char and char:FindFirstChild("HumanoidRootPart")
                                if handle and root then
                                    handle.CFrame = root.CFrame
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

MainTab:AddToggle("InstantInteractToggle", {
    Title = "Instant Interact",
    Description = "Removes hold timers on proximity prompts.",
    Default = false,
    Callback = function(val) _G.InstantInteractEnabled = val end
})

MainTab:AddToggle("NoJumpCooldown", {
    Title = "No Jump Cooldown",
    Description = "Removes jump cooldown for continuous jumping.",
    Default = false,
    Callback = function(val) _G.NoJumpCooldownEnabled = val end
})

MainTab:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Allows you to walk through walls.",
    Default = false,
    Callback = function(val) _G.NoclipEnabled = val end
})

MainTab:AddToggle("WalkSpeedToggle", {
    Title = "Safe Speed Boost",
    Description = "Boost your speed by a little without anti-cheat detecting it.",
    Default = false,
    Callback = function(val) _G.WalkSpeedEnabled = val end
})

-- ============================================================
-- AUTO FARM FUNCTIONS
-- ============================================================
local getCharRoot = function()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local teleportTo = function(pos)
    if not autoFarmRunning then return end
    local root = getCharRoot()
    while not root do
        if not autoFarmRunning then return end
        task.wait(0.5)
        root = getCharRoot()
    end
    if not autoFarmRunning or not root then return end
    local distance = (pos - root.Position).Magnitude / 25  -- speed adjustment
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
    local tween = TweenService:Create(root, TweenInfo.new(distance, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(pos)
    })
    tween:Play()
    while distance > 0 do
        if not autoFarmRunning then
            tween:Cancel()
            return
        end
        local r = getCharRoot()
        if not r then
            tween:Cancel()
            task.wait(0.5)
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(0,0,0)
        task.wait(0.05)
        distance = distance - 0.05
    end
    local r = getCharRoot()
    if r then
        r.CFrame = CFrame.new(pos)
        r.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end

local interactPrompt = function(pos, radius)
    if not autoFarmRunning then return false end
    radius = radius or 35
    local targetPrompt = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                if (parent.Position - pos).Magnitude < radius then
                    targetPrompt = obj
                    break
                end
            end
        end
    end
    if targetPrompt then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(targetPrompt)
            else
                targetPrompt:Hold(LocalPlayer)
                task.wait(targetPrompt.HoldDuration or 2)
                targetPrompt:Release()
            end
        end)
        return true
    end
    return false
end

local hasTool = function(toolName)
    if not autoFarmRunning then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    -- check equipped
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), toolName:lower()) then
            return true
        end
    end
    -- check backpack
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(tool.Name:lower(), toolName:lower()) then
                hum:EquipTool(tool)
                task.wait(0.4)
                return true
            end
        end
    end
    return false
end

-- Auto Farm GUI
local AutoFarmGui = Instance.new("ScreenGui")
AutoFarmGui.Name = "SRTHUB_AutoFarmGUI"
AutoFarmGui.Parent = CoreGui
AutoFarmGui.ResetOnSpawn = false
AutoFarmGui.Enabled = false

local AutoFarmFrame = Instance.new("Frame")
AutoFarmFrame.Name = "AutoFarmMainFrame"
AutoFarmFrame.Size = UDim2.new(0,200,0,90)
AutoFarmFrame.Position = UDim2.new(0.05,0,0.2,0)
AutoFarmFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
AutoFarmFrame.BorderSizePixel = 0
AutoFarmFrame.Active = true
AutoFarmFrame.Draggable = true
AutoFarmFrame.Parent = AutoFarmGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0,6)
FrameCorner.Parent = AutoFarmFrame

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Size = UDim2.new(1,0,0,30)
FarmTitle.BackgroundTransparency = 1
FarmTitle.Text = "BLANK CARD AUTO-FARM"
FarmTitle.TextColor3 = Color3.fromRGB(255,255,255)
FarmTitle.TextSize = 13
FarmTitle.Font = Enum.Font.GothamBold
FarmTitle.Parent = AutoFarmFrame

local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0.85,0,0,35)
FarmButton.Position = UDim2.new(0.075,0,0.45,0)
FarmButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
FarmButton.TextColor3 = Color3.fromRGB(255,100,100)
FarmButton.Text = "Auto Farm: OFF"
FarmButton.TextSize = 12
FarmButton.Font = Enum.Font.GothamBold
FarmButton.Parent = AutoFarmFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0,4)
BtnCorner.Parent = FarmButton

local function autoFarmLoop()
    while autoFarmRunning do
        local root = getCharRoot()
        if not root then
            while not getCharRoot() do
                if not autoFarmRunning then break end
                task.wait(1)
            end
            if not autoFarmRunning then break end
            teleportTo(Vector3.new(-337,693,366))
            for _ = 1,2 do
                if not autoFarmRunning then break end
                interactPrompt(Vector3.new(-337,693,366))
                task.wait(0.6)
            end
            if not autoFarmRunning then break end
            for _, pos in ipairs({Vector3.new(-467,693,41), Vector3.new(-475,693,45)}) do
                if not autoFarmRunning then break end
                teleportTo(pos)
                hasTool("blank")
                task.wait(0.4)
                interactPrompt(pos)
                task.wait(0.8)
            end
            if not autoFarmRunning then break end
            for _ = 1,17 do
                if not autoFarmRunning then break end
                task.wait(1)
            end
            if not autoFarmRunning then break end
            teleportTo(Vector3.new(-319,692,29))
            for _ = 1,2 do
                if not autoFarmRunning then break end
                hasTool("activated")
                task.wait(0.4)
                interactPrompt(Vector3.new(-319,692,29))
                task.wait(0.6)
            end
            task.wait(1)
        end
    end
end

FarmButton.MouseButton1Click:Connect(function()
    if not autoFarmRunning then
        autoFarmRunning = true
        FarmButton.Text = "Auto Farm: ON"
        FarmButton.TextColor3 = Color3.fromRGB(100,255,100)
        task.spawn(autoFarmLoop)
    else
        autoFarmRunning = false
        FarmButton.Text = "Auto Farm: OFF"
        FarmButton.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)

AutoFarmTab:AddToggle("SpawnAutoFarmGui", {
    Title = "Spawn Auto Farm Button",
    Description = "Show or hide the floating auto farm menu.",
    Default = false,
    Callback = function(val)
        _G.CustomAutoFarmVisible = val
        AutoFarmGui.Enabled = val
        if not val then
            autoFarmRunning = false
            FarmButton.Text = "Auto Farm: OFF"
            FarmButton.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
})

AutoFarmTab:AddToggle("FreezeAutoFarmBtn", {
    Title = "Freeze Auto Farm UI",
    Description = "Lock's the floating auto farm UI so you cannot drag it.",
    Default = false,
    Callback = function(val)
        _G.AutoFarmDraggable = not val
        AutoFarmFrame.Draggable = not val
    end
})

-- ============================================================
-- COMBAT / AIMBOT & NO RECOIL
-- ============================================================
local AimbotGui = Instance.new("ScreenGui")
AimbotGui.Name = "CustomAimbotGui"
AimbotGui.Parent = CoreGui
AimbotGui.ResetOnSpawn = false
AimbotGui.Enabled = false

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Parent = AimbotGui
FOVCircle.BackgroundTransparency = 1
FOVCircle.AnchorPoint = Vector2.new(0.5,0.5)
FOVCircle.Position = UDim2.new(0.5,0,0.5,0)
FOVCircle.Size = UDim2.new(0, aimbotFOV*2, 0, aimbotFOV*2)

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Parent = FOVCircle
FOVStroke.Color = Color3.fromRGB(0,170,255)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1,0)
FOVCorner.Parent = FOVCircle

local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Name = "AimbotBtn"
AimbotBtn.Parent = AimbotGui
AimbotBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
AimbotBtn.BorderColor3 = Color3.fromRGB(0,170,255)
AimbotBtn.BorderSizePixel = 2
AimbotBtn.Position = UDim2.new(0,50,0,110)
AimbotBtn.Size = UDim2.new(0,90,0,45)
AimbotBtn.Font = Enum.Font.SourceSansBold
AimbotBtn.Text = "AIMBOT: OFF"
AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
AimbotBtn.TextSize = 12

local AimbotBtnCorner = Instance.new("UICorner")
AimbotBtnCorner.CornerRadius = UDim.new(0,8)
AimbotBtnCorner.Parent = AimbotBtn

-- No Recoil: collect recoil tables from garbage collection
local function noRecoilCollect()
    local gc = getgc()
    recoilMemory = {}
    for _, obj in ipairs(gc) do
        pcall(function()
            local recoil = rawget(obj, "Recoil")
            if type(recoil) == "table" then
                for k, v in pairs(recoil) do
                    rawset(recoil, k, 0)
                end
            elseif type(recoil) == "number" then
                rawset(obj, "Recoil", 0)
            end
            local recoil2 = rawget(obj, "recoil")
            if type(recoil2) == "table" then
                for k, v in pairs(recoil2) do
                    rawset(recoil2, k, 0)
                end
            elseif type(recoil2) == "number" then
                rawset(obj, "recoil", 0)
            end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if not noRecoilActive then return end
    for _, obj in ipairs(recoilMemory) do
        pcall(function()
            local recoil = rawget(obj, "Recoil")
            if type(recoil) == "table" then
                for k, v in pairs(recoil) do
                    rawset(recoil, k, 0)
                end
            elseif type(recoil) == "number" then
                rawset(obj, "Recoil", 0)
            end
            local recoil2 = rawget(obj, "recoil")
            if type(recoil2) == "table" then
                for k, v in pairs(recoil2) do
                    rawset(recoil2, k, 0)
                end
            elseif type(recoil2) == "number" then
                rawset(obj, "recoil", 0)
            end
        end)
    end
end)

CombatTab:AddButton({
    Title = "No Recoil",
    Description = "When you shoot, your camera won't move AKA freeze your aim without it going up.",
    Callback = function()
        if noRecoilActive then
            Fluent:Notify({ Title = "No Recoil", Content = "No Recoil is already active!", Duration = 3 })
            return
        end
        noRecoilActive = true
        task.spawn(function()
            while noRecoilActive do
                task.wait(3)
                pcall(noRecoilCollect)
            end
        end)
        Fluent:Notify({ Title = "No Recoil Enabled", Content = "Weapon recoil modified to 0.", Duration = 4 })
    end
})

CombatTab:AddToggle("SpawnAimbotGui", {
    Title = "Spawn Aimbot UI",
    Description = "Show or hide the floating aimbot UI and FOV ring.",
    Default = false,
    Callback = function(val)
        _G.CustomAimbotVisible = val
        AimbotGui.Enabled = val
        if not val then
            _G.CustomAimbotActive = false
            AimbotBtn.Text = "AIMBOT: OFF"
            AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
            FOVStroke.Color = Color3.fromRGB(0,170,255)
        end
    end
})

CombatTab:AddSlider("AimbotCircleSize", {
    Title = "Aimbot Circle Size (FOV)",
    Description = "Adjust the size of the aimbot FOV circle.",
    Default = 120,
    Min = 40,
    Max = 300,
    Rounding = 0,
    Callback = function(val)
        aimbotFOV = val
        FOVCircle.Size = UDim2.new(0, aimbotFOV*2, 0, aimbotFOV*2)
    end
})

CombatTab:AddToggle("FreezeAimbotBtn", {
    Title = "Freeze Aimbot UI",
    Description = "Lock's the floating aimbot UI so you cannot drag it.",
    Default = false,
    Callback = function(val)
        _G.AimbotDraggable = not val
        -- draggable handled by input events
    end
})

-- Aimbot button toggle
AimbotBtn.MouseButton1Click:Connect(function()
    _G.CustomAimbotActive = not _G.CustomAimbotActive
    if _G.CustomAimbotActive then
        AimbotBtn.Text = "AIMBOT: ON"
        AimbotBtn.TextColor3 = Color3.fromRGB(0,255,100)
        FOVStroke.Color = Color3.fromRGB(0,255,100)
    else
        AimbotBtn.Text = "AIMBOT: OFF"
        AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
        FOVStroke.Color = Color3.fromRGB(0,170,255)
    end
end)

-- Draggable logic for aimbot button
local isDraggingAimbot = false
local dragStartAimbot, dragOffsetAimbot

AimbotBtn.InputBegan:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingAimbot = true
        dragStartAimbot = input.Position
        dragOffsetAimbot = AimbotBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDraggingAimbot = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if isDraggingAimbot and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartAimbot
        AimbotBtn.Position = UDim2.new(
            dragOffsetAimbot.X.Scale, dragOffsetAimbot.X.Offset + delta.X,
            dragOffsetAimbot.Y.Scale, dragOffsetAimbot.Y.Offset + delta.Y
        )
    end
end)

-- Visibility check for aimbot (raycast)
local function isVisible(head)
    local origin = CurrentCamera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = { LocalPlayer.Character }
    local charHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if charHead then table.insert(ignore, charHead) end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, head.Position - origin, params)
    if result then
        return result.Instance:IsDescendantOf(head.Parent)
    end
    return true
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
    if not _G.CustomAimbotVisible or not _G.CustomAimbotActive then return end
    local center = Vector2.new(CurrentCamera.ViewportSize.X/2, CurrentCamera.ViewportSize.Y/2)
    local bestTarget = nil
    local bestDist = aimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local pos, onScreen = CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local screenPos = Vector2.new(pos.X, pos.Y)
                        local dist = (screenPos - center).Magnitude
                        if dist <= aimbotFOV then
                            if isVisible(head) then
                                if dist < bestDist then
                                    bestDist = dist
                                    bestTarget = head
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if bestTarget then
        CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, bestTarget.Position)
    end
end)

-- ============================================================
-- VISUALS TAB
-- ============================================================
VisualsTab:AddToggle("InfiniteZoomToggle", {
    Title = "Max Zoom Out",
    Description = "Bypasses max camera zoom limits.",
    Default = false,
    Callback = function(val)
        _G.InfiniteZoomEnabled = val
        if not val then
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
})

VisualsTab:AddToggle("PlayerESP", {
    Title = "Player ESP (Name & Body Highlight)",
    Description = "Highlight characters & shows their name tag.",
    Default = false,
    Callback = function(val)
        _G.ESPEnabled = val
    end
})

-- ESP management
local espData = {}
local playerList = {}

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.DisplayName)
    end
end

local playerDropdown = VisualsTab:AddDropdown("SelectTargetPlayer", {
    Title = "Select Player",
    Description = "Choose a player to inspect.",
    Values = playerList,
    Default = 1,
    Callback = function(val) end
})

local function removeESPForPlayer(player)
    if espData[player] then
        if espData[player].Billboard then espData[player].Billboard:Destroy() end
        if espData[player].Highlight then espData[player].Highlight:Destroy() end
        espData[player] = nil
    end
end

local function cleanupPlayer(player)
    removeESPForPlayer(player)
    if espData[player] and espData[player].CharConn then
        espData[player].CharConn:Disconnect()
    end
    espData[player] = nil
end

local function setupPlayerESP(player)
    if player == LocalPlayer then return end
    if not espData[player] then espData[player] = {} end

    local function onCharacterAdded(char)
        removeESPForPlayer(player)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_NameTag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0,100,0,40)
        billboard.StudsOffset = Vector3.new(0,2,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1,0,1,0)
        label.Font = Enum.Font.SourceSansBold
        label.Text = player.DisplayName
        label.TextColor3 = Color3.fromRGB(0,255,255)
        label.TextSize = 14
        label.TextStrokeTransparency = 0.5

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(0,170,255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        espData[player].Billboard = billboard
        espData[player].Highlight = highlight
        espData[player].Character = char
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    espData[player].CharConn = player.CharacterAdded:Connect(onCharacterAdded)
end

-- Initial ESP setup
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayerESP(player)
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        table.insert(playerList, player.DisplayName)
        playerDropdown:SetValues(playerList)
        setupPlayerESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    cleanupPlayer(player)
    for i, name in ipairs(playerList) do
        if name == player.DisplayName then
            table.remove(playerList, i)
            break
        end
    end
    playerDropdown:SetValues(playerList)
end)

-- Inspect inventory button
VisualsTab:AddButton({
    Title = "Inspect Inventory",
    Description = "Check the user's tools & equipped tools.",
    Callback = function()
        local targetPlayer = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player.DisplayName == playerDropdown.Value or player.Name == playerDropdown.Value then
                targetPlayer = player
                break
            end
        end
        if not targetPlayer then return end

        local inventory = {}
        local char = targetPlayer.Character
        if char then
            local backpack = char:FindFirstChildOfClass("Backpack") -- Actually Character doesn't have Backpack; use Player's Backpack
        end
        -- Actually use Player's Backpack
        local backpack = targetPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(inventory, tool.Name)
                end
            end
        end
        -- equipped tools
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    table.insert(inventory, tool.Name .. " (Equipped)")
                end
            end
        end
        local content = #inventory > 0 and table.concat(inventory, ", ") or "Inventory is empty."
        Fluent:Notify({
            Title = targetPlayer.DisplayName .. "'s Inventory",
            Content = content,
            Duration = 6
        })
    end
})

-- ============================================================
-- SOCIALS & CREDITS
-- ============================================================
SocialsTab:AddParagraph({
    Title = "Discord Server",
    Content = "If you aren't in the discord server, please join!"
})
SocialsTab:AddButton({
    Title = "Copy Link",
    Description = "Copies invite link to your clipboard.",
    Callback = function()
        if setclipboard then setclipboard("https://discord.gg/xKvegCV6yf") end
    end
})

SocialsTab:AddParagraph({
    Title = "YouTube Channel",
    Content = "Subscribe to my channel with notifications on to support me!"
})
SocialsTab:AddButton({
    Title = "Copy Link",
    Description = "Copies YouTube channel link to your clipboard.",
    Callback = function()
        if setclipboard then setclipboard("https://youtube.com/@drkroblox") end
    end
})

CreditsTab:AddParagraph({
    Title = "Solo Developer",
    Content = "@darkhub"
})
CreditsTab:AddParagraph({
    Title = "UI Library",
    Content = "Modded Fluent UI by @Darkhub"
})

-- ============================================================
-- SETTINGS
-- ============================================================
SettingsTab:AddButton({
    Title = "FPS Booster (Potato Graphics)",
    Description = "Strips heavy textures and effects to boost FPS.",
    Callback = function()
        if _G.FPSBoostUsed then return end
        _G.FPSBoostUsed = true
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
            for _, effect in ipairs(lighting:GetChildren()) do
                if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") or effect:IsA("Clouds") or effect:IsA("BlurEffect") then
                    effect:Destroy()
                end
            end
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.SmoothPlastic
                    part.CastShadow = false
                elseif part:IsA("Texture") or part:IsA("Decal") then
                    part:Destroy()
                end
            end
        end)
    end
})

SettingsTab:AddDropdown("UISize", {
    Title = "UI Size",
    Description = "Scale menu dimensions.",
    Values = { "Small", "Medium" },
    Default = 1,
    Callback = function(val)
        if val == "Small" then
            Window.Root.Size = UDim2.fromOffset(480,320)
        elseif val == "Medium" then
            Window.Root.Size = UDim2.fromOffset(580,440)
        end
    end
})

-- ============================================================
-- WATERMARK & MOBILE TOGGLE
-- ============================================================
local Watermark = Instance.new("ScreenGui")
Watermark.Name = "CaliStreetsWatermark"
Watermark.Parent = CoreGui
Watermark.ResetOnSpawn = false
Watermark.DisplayOrder = -1

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Name = "WatermarkText"
WatermarkLabel.Parent = Watermark
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.AnchorPoint = Vector2.new(0.5,0)
WatermarkLabel.Position = UDim2.new(0.5,0,0,5)
WatermarkLabel.Size = UDim2.new(0,400,0,20)
WatermarkLabel.Font = Enum.Font.SourceSansBold
WatermarkLabel.Text = "STR HUB | by @strixwashere"
WatermarkLabel.TextColor3 = Color3.fromRGB(255,255,255)
WatermarkLabel.TextTransparency = 0.4
WatermarkLabel.TextSize = 13
WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Center

local MobileToggle = Instance.new("ScreenGui")
MobileToggle.Name = "MobileToggleGui"
MobileToggle.Parent = CoreGui
MobileToggle.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MobileToggle
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
ToggleBtn.BorderColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Position = UDim2.new(0,50,0,50)
ToggleBtn.Size = UDim2.new(0,45,0,45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "STR HUB"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 11

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = ToggleBtn

-- Mobile toggle draggable
local isDraggingToggle = false
local dragStartToggle, dragOffsetToggle

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingToggle = true
        dragStartToggle = input.Position
        dragOffsetToggle = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDraggingToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingToggle and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartToggle
        ToggleBtn.Position = UDim2.new(
            dragOffsetToggle.X.Scale, dragOffsetToggle.X.Offset + delta.X,
            dragOffsetToggle.Y.Scale, dragOffsetToggle.Y.Offset + delta.Y
        )
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- ============================================================
-- INSTANT INTERACT (global hook)
-- ============================================================
game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
    if _G.InstantInteractEnabled then
        fireproximityprompt(prompt)
    end
end)

-- ============================================================
-- INFINITE ZOOM & ESP UPDATE (RunService loops)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if _G.InfiniteZoomEnabled then
        LocalPlayer.CameraMaxZoomDistance = 100000
    end
    -- ESP visibility toggle
    for _, data in pairs(espData) do
        if data.Billboard then
            data.Billboard.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChild("Humanoid")
        end
        if data.Highlight then
            data.Highlight.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChild("Humanoid")
        end
    end
end)

-- ============================================================
-- NOCLIP, WALKSPEED, STAMINA, JUMP COOLDOWN (RunService)
-- ============================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not root then return end

    -- Noclip
    if _G.NoclipEnabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Walk Speed Boost
    if _G.WalkSpeedEnabled then
        -- Safe speed boost: add a small velocity increment
        root.CFrame = root.CFrame + hum.MoveDirection * (_G.WalkSpeedMultiplier - 1) * 0.5
    end

    -- Infinite Stamina (check number values and attributes)
    if _G.InfiniteStaminaEnabled then
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("NumberValue") then
                local nameLower = child.Name:lower()
                if nameLower:match("stamina") or nameLower:match("energy") or nameLower:match("tired") or nameLower:match("exhaustion") then
                    child.Value = 100
                end
            end
        end
        -- also check attributes on Humanoid
        for attr, val in hum:GetAttributes() do
            local attrLower = attr:lower()
            if attrLower:match("stamina") and type(val) == "number" then
                hum:SetAttribute(attr, 100)
            end
        end
    end
end)

-- No Jump Cooldown
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if _G.NoJumpCooldownEnabled then
        hum.JumpPower = hum.JumpPower -- dummy to update?
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.NoJumpCooldownEnabled then
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ============================================================
-- CLEANUP ON WINDOW CLOSE
-- ============================================================
local function cleanupAll()
    pcall(function()
        autoFarmRunning = false
        _G.CustomAimbotActive = false
        if AimbotGui then AimbotGui:Destroy() end
        if AutoFarmGui then AutoFarmGui:Destroy() end
        if Watermark then Watermark:Destroy() end
        if MobileToggle then MobileToggle:Destroy() end
        noRecoilActive = false
    end)
end

if Window then
    Window:OnClose(cleanupAll)
end

-- ============================================================
-- FINISH LOADING
-- ============================================================
updateProgress(0.9, "Finalizing UI Interfaces")
updateProgress(1, "Loaded!")

task.wait(0.5)
loadingActive = false
local fadeOut = TweenService:Create(LoadFrame, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
    GroupTransparency = 1
})
fadeOut:Play()
fadeOut.Completed:Wait()
LoadingScreen:Destroy()

Fluent:Notify({
    Title = "DRK HUB Loaded",
    Content = "Enjoy! by @DARKHUB",
    Duration = 5
})
