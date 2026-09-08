-- ============================================================
-- DARK HUB | Cali Streets (Baselined UI - Fully Working)
-- by @strixwashere
-- ============================================================

local Baselined = loadstring(game:HttpGet("https://raw.githubusercontent.com/fiangg20/nox/refs/heads/main/baselined-assets/comp/source.luau"))()

local Window = Baselined:Create({
    Title = "DARK HUB | Cali Streets",
    Icon = "bolt",
    SizeX = 480,
    SizeY = 600,
    Theme = "MonochromeDark",
    ToggleKey = Enum.KeyCode.K,
    UseIntegratedSettings = true,
    Search = true,
    SearchPlaceholder = "Search components...",
    ConfigurationSaving = { Enabled = true }
})

-- Tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local AutoFarmTab = Window:AddTab({ Title = "Auto Farm", Icon = "agriculture" })
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "target" })
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "visibility" })
local SocialsTab = Window:AddTab({ Title = "Socials", Icon = "chat" })
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "favorite" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Global vars (sama seperti sebelumnya)
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
_G.CustomAimbotVisible = false
_G.CustomAimbotActive = false
_G.AimbotDraggable = true

local AutoFarmRunning = false
local AimbotFOV = 120
local NoRecoilActive = false
local SelectedPlayer = nil

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local SetClipboard = setclipboard or toboard or writeclipboard

-- ============================================================
-- Utility Functions (sama)
-- ============================================================
local function GetCharacter()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function TeleportTo(pos)
    if not AutoFarmRunning then return end
    local root = GetCharacter()
    if not root then return end
    local dist = (pos - root.Position).Magnitude / 25
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
    local tween = TweenService:Create(root, TweenInfo.new(dist, Enum.EasingStyle.Linear), { CFrame = CFrame.new(pos) })
    tween:Play()
    while dist > 0 do
        if not AutoFarmRunning then tween:Cancel() return end
        if not GetCharacter() then tween:Cancel() return end
        GetCharacter().AssemblyLinearVelocity = Vector3.new(0,0,0)
        task.wait(0.05)
        dist = dist - 0.05
    end
    local r = GetCharacter()
    if r then
        r.CFrame = CFrame.new(pos)
        r.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end

local function InteractNearby(pos, radius)
    if not AutoFarmRunning then return false end
    radius = radius or 35
    local targetPrompt = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local part = obj.Parent
            if part and part:IsA("BasePart") then
                if (part.Position - pos).Magnitude < radius then
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

local function EquipToolByName(name)
    if not AutoFarmRunning then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(name)) then
            return true
        end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(name)) then
                hum:EquipTool(tool)
                task.wait(0.4)
                return true
            end
        end
    end
    return false
end

-- ============================================================
-- Auto Farm Loop
-- ============================================================
local function AutoFarmLoop()
    while AutoFarmRunning do
        if not GetCharacter() then
            while not GetCharacter() and AutoFarmRunning do task.wait(1) end
            if not AutoFarmRunning then break end
        end

        TeleportTo(Vector3.new(-337, 693, 366))
        for i = 1, 2 do
            if not AutoFarmRunning then break end
            InteractNearby(Vector3.new(-337, 693, 366))
            task.wait(0.6)
        end
        if not AutoFarmRunning then break end

        local positions = {
            Vector3.new(-467, 693, 41),
            Vector3.new(-475, 693, 45)
        }
        for _, pos in ipairs(positions) do
            if not AutoFarmRunning then break end
            TeleportTo(pos)
            EquipToolByName("blank")
            task.wait(0.4)
            InteractNearby(pos)
            task.wait(0.8)
        end
        if not AutoFarmRunning then break end

        for i = 1, 17 do
            if not AutoFarmRunning then break end
            task.wait(1)
        end
        if not AutoFarmRunning then break end

        TeleportTo(Vector3.new(-319, 692, 29))
        for i = 1, 2 do
            if not AutoFarmRunning then break end
            EquipToolByName("activated")
            task.wait(0.4)
            InteractNearby(Vector3.new(-319, 692, 29))
            task.wait(0.6)
        end
        task.wait(1)
    end
end

-- ============================================================
-- No Recoil
-- ============================================================
local function NoRecoilLoop()
    while NoRecoilActive do
        task.wait(3)
        pcall(function()
            local gc = getgc()
            for _, obj in ipairs(gc) do
                if type(obj) == "table" then
                    pcall(function()
                        local recoil = rawget(obj, "Recoil")
                        if type(recoil) == "table" then
                            for k, _ in pairs(recoil) do
                                rawset(obj, "Recoil", k, 0)
                            end
                        elseif type(recoil) == "number" then
                            rawset(obj, "Recoil", 0)
                        end
                        local recoil2 = rawget(obj, "recoil")
                        if type(recoil2) == "table" then
                            for k, _ in pairs(recoil2) do
                                rawset(obj, "recoil", k, 0)
                            end
                        elseif type(recoil2) == "number" then
                            rawset(obj, "recoil", 0)
                        end
                    end)
                end
            end
        end)
    end
end

-- ============================================================
-- ESP System
-- ============================================================
local ESPData = {}
local ESPPlayersList = {}

local function ClearESP(player)
    if ESPData[player] then
        if ESPData[player].Billboard then ESPData[player].Billboard:Destroy() end
        if ESPData[player].Highlight then ESPData[player].Highlight:Destroy() end
        if ESPData[player].CharConn then ESPData[player].CharConn:Disconnect() end
        ESPData[player] = nil
    end
end

local function SetupESP(player)
    if player == LocalPlayer then return end
    ESPData[player] = ESPData[player] or {}
    local function OnCharacterAdded(char)
        ClearESP(player)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if not head or not hum then return end

        local bill = Instance.new("BillboardGui")
        bill.Name = "ESP_NameTag"
        bill.Adornee = head
        bill.Size = UDim2.new(0, 100, 0, 40)
        bill.StudsOffset = Vector3.new(0, 2, 0)
        bill.AlwaysOnTop = true
        bill.Parent = head

        local label = Instance.new("TextLabel")
        label.Parent = bill
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1,0,1,0)
        label.Font = Enum.Font.SourceSansBold
        label.Text = player.DisplayName
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.TextSize = 14
        label.TextStrokeTransparency = 0.5

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(0, 170, 255)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.OutlineTransparency = 0
        hl.Parent = char

        ESPData[player].Billboard = bill
        ESPData[player].Highlight = hl
        ESPData[player].Character = char
    end

    if player.Character then OnCharacterAdded(player.Character) end
    ESPData[player].CharConn = player.CharacterAdded:Connect(OnCharacterAdded)
end

-- Init existing players
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        table.insert(ESPPlayersList, plr.DisplayName)
        SetupESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        table.insert(ESPPlayersList, plr.DisplayName)
        if DropdownTargetPlayer then
            DropdownTargetPlayer:SetOptions(ESPPlayersList)
        end
        SetupESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    ClearESP(plr)
    for i, name in ipairs(ESPPlayersList) do
        if name == plr.DisplayName then
            table.remove(ESPPlayersList, i)
            break
        end
    end
    if DropdownTargetPlayer then
        DropdownTargetPlayer:SetOptions(ESPPlayersList)
    end
end)

-- ============================================================
-- Floating Auto Farm GUI
-- ============================================================
local AutoFarmGui = Instance.new("ScreenGui")
AutoFarmGui.Name = "DARKHUB_AutoFarmGUI"
AutoFarmGui.Parent = CoreGui
AutoFarmGui.ResetOnSpawn = false
AutoFarmGui.Enabled = false

local AutoFarmFrame = Instance.new("Frame")
AutoFarmFrame.Name = "AutoFarmMainFrame"
AutoFarmFrame.Size = UDim2.new(0, 200, 0, 90)
AutoFarmFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
AutoFarmFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
AutoFarmFrame.BorderSizePixel = 0
AutoFarmFrame.Active = true
AutoFarmFrame.Draggable = true
AutoFarmFrame.Parent = AutoFarmGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = AutoFarmFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1,0,0,30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BLANK CARD AUTO-FARM"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = AutoFarmFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85,0,0,35)
ToggleBtn.Position = UDim2.new(0.075,0,0.45,0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
ToggleBtn.TextColor3 = Color3.fromRGB(255,100,100)
ToggleBtn.Text = "Auto Farm: OFF"
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = AutoFarmFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0,4)
BtnCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if not AutoFarmRunning then
        AutoFarmRunning = true
        ToggleBtn.Text = "Auto Farm: ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(100,255,100)
        task.spawn(AutoFarmLoop)
    else
        AutoFarmRunning = false
        ToggleBtn.Text = "Auto Farm: OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)

-- ============================================================
-- Floating Aimbot GUI
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
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5,0,0.5,0)
FOVCircle.Size = UDim2.new(0, AimbotFOV * 2, 0, AimbotFOV * 2)

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Parent = FOVCircle
FOVStroke.Color = Color3.fromRGB(0, 170, 255)
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
AimbotBtn.Position = UDim2.new(0, 50, 0, 110)
AimbotBtn.Size = UDim2.new(0, 90, 0, 45)
AimbotBtn.Font = Enum.Font.SourceSansBold
AimbotBtn.Text = "AIMBOT: OFF"
AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
AimbotBtn.TextSize = 12

local AimbotBtnCorner = Instance.new("UICorner")
AimbotBtnCorner.CornerRadius = UDim.new(0,8)
AimbotBtnCorner.Parent = AimbotBtn

local AimbotDragging = false
local AimbotDragStart = nil
local AimbotBtnPos = nil

AimbotBtn.InputBegan:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        AimbotDragging = true
        AimbotDragStart = input.Position
        AimbotBtnPos = AimbotBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                AimbotDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if AimbotDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - AimbotDragStart
        AimbotBtn.Position = UDim2.new(AimbotBtnPos.X.Scale, AimbotBtnPos.X.Offset + delta.X,
                                       AimbotBtnPos.Y.Scale, AimbotBtnPos.Y.Offset + delta.Y)
    end
end)

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

-- ============================================================
-- Main Tab
-- ============================================================
MainTab:AddSection({ Text = "Player Enhancements" })

MainTab:AddSwitch({
    Title = "Infinite Stamina",
    Default = false,
    Icon = "bolt",
    Flag = "InfiniteStamina",
    Callback = function(State) _G.InfiniteStaminaEnabled = State end
})

MainTab:AddSwitch({
    Title = "Auto Pickup Dropped Loot",
    Default = false,
    Icon = "inbox",
    Flag = "AutoPickup",
    Callback = function(State)
        _G.AutoLoot = State
        if State then
            task.spawn(function()
                while _G.AutoLoot do
                    pcall(function()
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj:IsA("Tool") or string.find(string.lower(obj.Name), "loot") then
                                local handle = obj:FindFirstChild("Handle")
                                if handle and handle:IsA("BasePart") then
                                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if root then handle.CFrame = root.CFrame end
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

MainTab:AddSwitch({
    Title = "Instant Interact",
    Default = false,
    Icon = "flash_on",
    Flag = "InstantInteract",
    Callback = function(State) _G.InstantInteractEnabled = State end
})

MainTab:AddSwitch({
    Title = "No Jump Cooldown",
    Default = false,
    Icon = "upgrade",
    Flag = "NoJumpCooldown",
    Callback = function(State) _G.NoJumpCooldownEnabled = State end
})

MainTab:AddSwitch({
    Title = "Noclip",
    Default = false,
    Icon = "gesture",
    Flag = "Noclip",
    Callback = function(State) _G.NoclipEnabled = State end
})

MainTab:AddSwitch({
    Title = "Safe Speed Boost",
    Default = false,
    Icon = "speed",
    Flag = "WalkSpeed",
    Callback = function(State) _G.WalkSpeedEnabled = State end
})

-- ============================================================
-- Auto Farm Tab
-- ============================================================
AutoFarmTab:AddSection({ Text = "Auto Farm Controls" })

AutoFarmTab:AddSwitch({
    Title = "Spawn Auto Farm Button",
    Default = false,
    Icon = "agriculture",
    Flag = "AutoFarmVisible",
    Callback = function(State)
        _G.CustomAutoFarmVisible = State
        AutoFarmGui.Enabled = State
        if not State then
            AutoFarmRunning = false
            ToggleBtn.Text = "Auto Farm: OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
})

AutoFarmTab:AddSwitch({
    Title = "Freeze Auto Farm UI",
    Default = false,
    Icon = "lock",
    Flag = "FreezeAutoFarm",
    Callback = function(State)
        _G.AutoFarmDraggable = not State
        AutoFarmFrame.Draggable = not State
    end
})

-- ============================================================
-- Combat Tab
-- ============================================================
CombatTab:AddSection({ Text = "Combat Enhancements" })

CombatTab:AddButton({
    Text = "Enable No Recoil",
    Type = "filled",
    Icon = "my_location",
    Callback = function()
        if NoRecoilActive then
            Window:Notify({ Text = "No Recoil is already active!", Duration = 3 })
            return
        end
        NoRecoilActive = true
        task.spawn(NoRecoilLoop)
        Window:Notify({ Text = "No Recoil Enabled", Duration = 4 })
    end
})

CombatTab:AddSwitch({
    Title = "Spawn Aimbot UI",
    Default = false,
    Icon = "target",
    Flag = "AimbotVisible",
    Callback = function(State)
        _G.CustomAimbotVisible = State
        AimbotGui.Enabled = State
        if not State then
            _G.CustomAimbotActive = false
            AimbotBtn.Text = "AIMBOT: OFF"
            AimbotBtn.TextColor3 = Color3.fromRGB(255,255,255)
            FOVStroke.Color = Color3.fromRGB(0,170,255)
        end
    end
})

CombatTab:AddSlider({
    Title = "Aimbot Circle Size (FOV)",
    Min = 40,
    Max = 300,
    Default = 120,
    Icon = "tune",
    Flag = "AimbotFOV",
    Callback = function(Value)
        AimbotFOV = Value
        FOVCircle.Size = UDim2.new(0, AimbotFOV * 2, 0, AimbotFOV * 2)
    end
})

CombatTab:AddSwitch({
    Title = "Freeze Aimbot UI",
    Default = false,
    Icon = "lock",
    Flag = "FreezeAimbot",
    Callback = function(State)
        _G.AimbotDraggable = not State
    end
})

-- ============================================================
-- Visuals Tab
-- ============================================================
VisualsTab:AddSection({ Text = "Visual Enhancements" })

VisualsTab:AddSwitch({
    Title = "Max Zoom Out",
    Default = false,
    Icon = "zoom_out",
    Flag = "InfiniteZoom",
    Callback = function(State)
        _G.InfiniteZoomEnabled = State
        if not State then LocalPlayer.CameraMaxZoomDistance = 128 end
    end
})

VisualsTab:AddSwitch({
    Title = "Player ESP (Name & Body Highlight)",
    Default = false,
    Icon = "visibility",
    Flag = "ESP",
    Callback = function(State) _G.ESPEnabled = State end
})

local DropdownTargetPlayer = VisualsTab:AddDropdown({
    Title = "Select Player",
    Options = ESPPlayersList,
    Default = 1,
    Icon = "person",
    Flag = "SelectedPlayer",
    Callback = function(Option) SelectedPlayer = Option end
})

VisualsTab:AddButton({
    Text = "Inspect Inventory",
    Type = "filled",
    Icon = "inventory",
    Callback = function()
        if not SelectedPlayer then
            Window:Notify({ Text = "No player selected.", Duration = 3 })
            return
        end
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == SelectedPlayer or plr.Name == SelectedPlayer then
                target = plr
                break
            end
        end
        if not target then
            Window:Notify({ Text = "Player not found.", Duration = 3 })
            return
        end
        local inv = {}
        local char = target.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then table.insert(inv, tool.Name .. " (Equipped)") end
            end
        end
        local backpack = target:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then table.insert(inv, tool.Name) end
            end
        end
        local content = #inv > 0 and table.concat(inv, ", ") or "Inventory is empty."
        Window:Notify({
            Text = target.DisplayName .. "'s Inventory: " .. content,
            Duration = 6
        })
    end
})

-- ============================================================
-- Socials Tab
-- ============================================================
SocialsTab:AddSection({ Text = "Discord Server" })
SocialsTab:AddButton({
    Text = "Copy Discord Link",
    Type = "filled",
    Icon = "content_copy",
    Callback = function()
        if SetClipboard then
            SetClipboard("https://discord.gg/xKvegCV6yf")
            Window:Notify({ Text = "Discord link copied!", Duration = 2 })
        end
    end
})

SocialsTab:AddDivider()

SocialsTab:AddSection({ Text = "YouTube Channel" })
SocialsTab:AddButton({
    Text = "Copy YouTube Link",
    Type = "filled",
    Icon = "content_copy",
    Callback = function()
        if SetClipboard then
            SetClipboard("https://youtube.com/@strixwashere")
            Window:Notify({ Text = "YouTube link copied!", Duration = 2 })
        end
    end
})

-- ============================================================
-- Credits Tab
-- ============================================================
CreditsTab:AddSection({ Text = "Solo Developer" })
CreditsTab:AddButton({
    Text = "@strixwashere",
    Type = "filled",
    Icon = "person",
    Callback = function()
        Window:Notify({ Text = "Developer: strixwashere", Duration = 2 })
    end
})

CreditsTab:AddDivider()

CreditsTab:AddSection({ Text = "UI Library" })
CreditsTab:AddButton({
    Text = "Baselined by fiangg20",
    Type = "filled",
    Icon = "code",
    Callback = function()
        Window:Notify({ Text = "UI Library: Baselined", Duration = 2 })
    end
})

-- ============================================================
-- Settings Tab
-- ============================================================
SettingsTab:AddSection({ Text = "Performance" })

SettingsTab:AddButton({
    Text = "FPS Booster (Potato Graphics)",
    Type = "filled",
    Icon = "speed",
    Callback = function()
        if _G.FPSBoostUsed then
            Window:Notify({ Text = "FPS Booster already used.", Duration = 2 })
            return
        end
        _G.FPSBoostUsed = true
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
            for _, obj in ipairs(lighting:GetChildren()) do
                if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("Clouds") or obj:IsA("BlurEffect") then
                    obj:Destroy()
                end
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj:Destroy()
                end
            end
        end)
        Window:Notify({ Text = "FPS Booster applied!", Duration = 3 })
    end
})

SettingsTab:AddDivider()
SettingsTab:AddSection({ Text = "Unload" })

SettingsTab:AddButton({
    Text = "Unload Script",
    Type = "filled",
    Icon = "power_settings_new",
    Callback = function()
        pcall(function()
            AutoFarmGui:Destroy()
            AimbotGui:Destroy()
            Window:Destroy()
        end)
        AutoFarmRunning = false
        NoRecoilActive = false
        _G.ESPEnabled = false
        _G.CustomAimbotActive = false
        for plr, data in pairs(ESPData) do ClearESP(plr) end
        _G.InfiniteStaminaEnabled = false
        _G.AutoLoot = false
        _G.NoJumpCooldownEnabled = false
        _G.NoclipEnabled = false
        _G.WalkSpeedEnabled = false
        _G.InstantInteractEnabled = false
        _G.InfiniteZoomEnabled = false
        Window:Notify({ Text = "Unloaded successfully.", Duration = 2 })
        task.wait(2)
        for _, gui in ipairs(CoreGui:GetChildren()) do
            if gui.Name:find("DARKHUB") or gui.Name:find("CustomAimbot") or gui.Name:find("CaliStreets") then
                gui:Destroy()
            end
        end
    end
})

-- ============================================================
-- Game Loops (Heartbeat, Input, dll)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if _G.InfiniteZoomEnabled then
        LocalPlayer.CameraMaxZoomDistance = 100000
    end
    for player, data in pairs(ESPData) do
        if data.Billboard then
            data.Billboard.Enabled = _G.ESPEnabled and player.Character and player.Character:FindFirstChild("Humanoid") ~= nil
        end
        if data.Highlight then
            data.Highlight.Enabled = _G.ESPEnabled and player.Character and player.Character:FindFirstChild("Humanoid") ~= nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not root then return end

    if _G.NoclipEnabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if _G.WalkSpeedEnabled then
        root.CFrame = root.CFrame + hum.MoveDirection * (_G.WalkSpeedMultiplier - 1) * 0.5
    end

    if _G.InfiniteStaminaEnabled then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("NumberValue") and string.match(string.lower(obj.Name), "stamina") then
                obj.Value = 100
            end
        end
        for attr, val in pairs(hum:GetAttributes()) do
            if string.match(string.lower(attr), "stamina") and type(val) == "number" then
                hum:SetAttribute(attr, 100)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and _G.NoJumpCooldownEnabled then
            hum.JumpPower = hum.JumpPower
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end)
        end
    end
end)

UIS.InputBegan:Connect(function(input)
    if _G.NoJumpCooldownEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Freefall and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local ProximityPromptService = game:GetService("ProximityPromptService")
ProximityPromptService.PromptShown:Connect(function(prompt)
    if _G.InstantInteractEnabled then
        fireproximityprompt(prompt)
    end
end)

-- ============================================================
-- Aimbot RenderStepped
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not _G.CustomAimbotVisible or not _G.CustomAimbotActive then return end

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local bestTarget = nil
    local bestDist = AimbotFOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist <= bestDist then
                            -- visibility check
                            local origin = Camera.CFrame.Position
                            local ray = RaycastParams.new()
                            ray.FilterType = Enum.RaycastFilterType.Exclude
                            ray.FilterDescendantsInstances = { LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character.Head }
                            ray.IgnoreWater = true
                            local hit = Workspace:Raycast(origin, head.Position - origin, ray)
                            local visible = true
                            if hit then
                                visible = hit.Instance:IsDescendantOf(char)
                            end
                            if visible then
                                bestDist = dist
                                bestTarget = head
                            end
                        end
                    end
                end
            end
        end
    end

    if bestTarget then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position)
    end
end)

-- ============================================================
-- Startup Notification
-- ============================================================
Window:Notify({ Text = "DARK HUB Loaded successfully!", Duration = 4 })