-- ================================================================
-- DARK HUB | Cali Streets
-- Clean & deobfuscated version (original by @strixwashere)
-- ================================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Locals
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local setclipboard = setclipboard or toboard or writeclipboard

-- Optional webhook logger (can be removed)
local WebhookURL = "https://discord.com/api/webhooks/1541446505104281763/L1WexPhFcug6t5kGDxiRgAvnzfXpoFLJ2YDfTI3Gqedeprpa0jYNz7_zcRfSzDYtr44T"
local function sendWebhook()
    task.spawn(function()
        local req = syn and syn.request or (http and http.request or http_request)
        if not req then return end
        local gameName = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId) and MarketplaceService:GetProductInfo(game.PlaceId).Name or "Cali Streets"
        local data = {
            embeds = {{
                title = "🔹 | **Execution Logger**",
                description = string.format("⚠️ - **NEW:** Exploiter executed a DARK HUB script.\n🔽 - **Game:** %s", gameName),
                footer = { text = "by @strixwashere" },
                color = 65535
            }}
        }
        pcall(function()
            req({
                Url = WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(data)
            })
        end)
    end)
end
sendWebhook()

-- ================================================================
-- Cleanup old GUI elements
-- ================================================================
local function destroyIfExists(name)
    local gui = CoreGui:FindFirstChild(name)
    if gui then gui:Destroy() end
end
destroyIfExists("DARKHUB_LoadingScreen")
destroyIfExists("MobileToggleGui")
destroyIfExists("CaliStreetsWatermark")
destroyIfExists("DARKHUB_AutoFarmGUI")
destroyIfExists("CustomAimbotGui")

-- ================================================================
-- Loading Screen
-- ================================================================
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "DARKHUB_LoadingScreen"
LoadingScreen.Parent = CoreGui
LoadingScreen.ResetOnSpawn = false
LoadingScreen.IgnoreGuiInset = true
LoadingScreen.DisplayOrder = 99999

local LoadFrame = Instance.new("CanvasGroup")
LoadFrame.Name = "LoadFrame"
LoadFrame.Size = UDim2.new(1, 0, 1, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
LoadFrame.BorderSizePixel = 0
LoadFrame.GroupTransparency = 0
LoadFrame.Parent = LoadingScreen

local LoadStroke = Instance.new("UIStroke")
LoadStroke.Color = Color3.fromRGB(255, 255, 255)
LoadStroke.Thickness = 1
LoadStroke.Transparency = 0.85
LoadStroke.Parent = LoadFrame

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.new(0, 420, 0, 200)
Container.BackgroundTransparency = 1
Container.Parent = LoadFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "DARK HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 38
Title.Parent = Container

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(255, 255, 255)
TitleStroke.Thickness = 2
TitleStroke.Transparency = 0.2
TitleStroke.Parent = Title

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 58)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.Text = "DARK HUB  |  Cali Streets"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 11
Subtitle.Parent = Container

local BarBackground = Instance.new("Frame")
BarBackground.Name = "BarBackground"
BarBackground.AnchorPoint = Vector2.new(0.5, 0)
BarBackground.Position = UDim2.new(0.5, 0, 0, 115)
BarBackground.Size = UDim2.new(0, 360, 0, 8)
BarBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = Container

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarStroke = Instance.new("UIStroke")
BarStroke.Color = Color3.fromRGB(255, 255, 255)
BarStroke.Thickness = 1
BarStroke.Transparency = 0.6
BarStroke.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Name = "BarFill"
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.7, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.08, 0, 0, 133)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Loading"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Container

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Name = "PercentLabel"
PercentLabel.Size = UDim2.new(0.2, 0, 0, 20)
PercentLabel.Position = UDim2.new(0.72, 0, 0, 133)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PercentLabel.TextSize = 12
PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
PercentLabel.Parent = Container

local loadingActive = true
local statusText = "Initializing Core"
task.spawn(function()
    while loadingActive do
        StatusLabel.Text = statusText .. string.rep(".", (os.clock() % 3) + 1)
        task.wait(0.35)
    end
end)

local function updateLoading(progress, newStatus)
    if newStatus then statusText = newStatus end
    PercentLabel.Text = math.floor(progress * 100) .. "%"
    local tween = TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(progress, 0, 1, 0)
    })
    tween:Play()
end

-- ================================================================
-- Load Fluent UI (modded)
-- ================================================================
updateLoading(0.15, "Loading Modded UI")
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"))()

updateLoading(0.35, "Creating Windows & Modules")
local Window = Fluent:CreateWindow({
    Title = "DARK HUB | Cali Streets",
    SubTitle = "by @strixwashere",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 320),
    Acrylic = true,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.LeftControl,
    Search = true
})

local MainTab = Window:AddTab({ Title = "Main", Icon = "solar/home-bold" })
local AutoFarmTab = Window:AddTab({ Title = "Auto Farm", Icon = "solar/card-bold" })
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "solar/target-bold" })
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "solar/eye-bold" })
local SocialsTab = Window:AddTab({ Title = "Socials", Icon = "solar/chat-round-dots-bold" })
local CreditsTab = Window:AddTab({ Title = "Credits", Icon = "solar/user-heart-bold" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })

-- ================================================================
-- Global toggles / variables
-- ================================================================
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

local autoFarmRunning = false
local noRecoilActive = false
local aimbotFOV = 120

-- ================================================================
-- Helper functions
-- ================================================================
local function getCharacter()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- ================================================================
-- Auto Farm functions
-- ================================================================
local function teleportTo(position)
    if not autoFarmRunning then return end
    local root = getCharacter()
    if not root then return end

    local distance = (position - root.Position).Magnitude / 25
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
    local tween = TweenService:Create(root, TweenInfo.new(distance, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(position)
    })
    tween:Play()
    while distance > 0 do
        if not autoFarmRunning then
            tween:Cancel()
            return
        end
        if not getCharacter() then
            tween:Cancel()
            return
        end
        local r = getCharacter()
        if r then r.AssemblyLinearVelocity = Vector3.new(0,0,0) end
        task.wait(0.05)
        distance = distance - 0.05
    end
    local r = getCharacter()
    if r then
        r.CFrame = CFrame.new(position)
        r.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end

local function interactWithPrompt(position, radius)
    if not autoFarmRunning then return false end
    radius = radius or 35
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parent = obj.Parent
            if parent:IsA("BasePart") then
                if (parent.Position - position).Magnitude < radius then
                    pcall(function()
                        if fireproximityprompt then
                            fireproximityprompt(obj)
                        else
                            obj:Hold(LocalPlayer)
                            task.wait(obj.HoldDuration or 2)
                            obj:Release()
                        end
                    end)
                    return true
                end
            end
        end
    end
    return false
end

local function equipTool(toolName)
    if not autoFarmRunning then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(toolName)) then
            return true
        end
    end

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(toolName)) then
                humanoid:EquipTool(tool)
                task.wait(0.4)
                return true
            end
        end
    end
    return false
end

local function autoFarmLoop()
    while autoFarmRunning do
        if not getCharacter() then
            task.wait(1)
            goto continue
        end

        teleportTo(Vector3.new(-337, 693, 366))
        for _ = 1, 2 do
            if not autoFarmRunning then break end
            interactWithPrompt(Vector3.new(-337, 693, 366))
            task.wait(0.6)
        end
        if not autoFarmRunning then break end

        for _, pos in ipairs({
            Vector3.new(-467, 693, 41),
            Vector3.new(-475, 693, 45)
        }) do
            if not autoFarmRunning then break end
            teleportTo(pos)
            equipTool("blank")
            task.wait(0.4)
            interactWithPrompt(pos)
            task.wait(0.8)
        end
        if not autoFarmRunning then break end

        for _ = 1, 17 do
            if not autoFarmRunning then break end
            task.wait(1)
        end
        if not autoFarmRunning then break end

        teleportTo(Vector3.new(-319, 692, 29))
        for _ = 1, 2 do
            if not autoFarmRunning then break end
            equipTool("activated")
            task.wait(0.4)
            interactWithPrompt(Vector3.new(-319, 692, 29))
            task.wait(0.6)
        end
        task.wait(1)

        ::continue::
    end
end

-- ================================================================
-- Auto Farm UI (floating button)
-- ================================================================
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

local AutoFarmCorner = Instance.new("UICorner")
AutoFarmCorner.CornerRadius = UDim.new(0,6)
AutoFarmCorner.Parent = AutoFarmFrame

local AutoFarmTitle = Instance.new("TextLabel")
AutoFarmTitle.Size = UDim2.new(1,0,0,30)
AutoFarmTitle.BackgroundTransparency = 1
AutoFarmTitle.Text = "BLANK CARD AUTO-FARM"
AutoFarmTitle.TextColor3 = Color3.fromRGB(255,255,255)
AutoFarmTitle.TextSize = 13
AutoFarmTitle.Font = Enum.Font.GothamBold
AutoFarmTitle.Parent = AutoFarmFrame

local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Size = UDim2.new(0.85,0,0,35)
AutoFarmButton.Position = UDim2.new(0.075,0,0.45,0)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
AutoFarmButton.TextColor3 = Color3.fromRGB(255,100,100)
AutoFarmButton.Text = "Auto Farm: OFF"
AutoFarmButton.TextSize = 12
AutoFarmButton.Font = Enum.Font.GothamBold
AutoFarmButton.Parent = AutoFarmFrame

local AutoFarmBtnCorner = Instance.new("UICorner")
AutoFarmBtnCorner.CornerRadius = UDim.new(0,4)
AutoFarmBtnCorner.Parent = AutoFarmButton

AutoFarmButton.MouseButton1Click:Connect(function()
    if not autoFarmRunning then
        autoFarmRunning = true
        AutoFarmButton.Text = "Auto Farm: ON"
        AutoFarmButton.TextColor3 = Color3.fromRGB(100,255,100)
        task.spawn(autoFarmLoop)
    else
        autoFarmRunning = false
        AutoFarmButton.Text = "Auto Farm: OFF"
        AutoFarmButton.TextColor3 = Color3.fromRGB(255,100,100)
    end
end)

-- ================================================================
-- Aimbot UI (FOV circle)
-- ================================================================
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
FOVCircle.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Parent = FOVCircle
FOVStroke.Color = Color3.fromRGB(0,170,255)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1,0)
FOVCorner.Parent = FOVCircle

local AimbotToggleButton = Instance.new("TextButton")
AimbotToggleButton.Name = "AimbotBtn"
AimbotToggleButton.Parent = AimbotGui
AimbotToggleButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
AimbotToggleButton.BorderColor3 = Color3.fromRGB(0,170,255)
AimbotToggleButton.BorderSizePixel = 2
AimbotToggleButton.Position = UDim2.new(0,50,0,110)
AimbotToggleButton.Size = UDim2.new(0,90,0,45)
AimbotToggleButton.Font = Enum.Font.SourceSansBold
AimbotToggleButton.Text = "AIMBOT: OFF"
AimbotToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
AimbotToggleButton.TextSize = 12

local AimbotBtnCorner = Instance.new("UICorner")
AimbotBtnCorner.CornerRadius = UDim.new(0,8)
AimbotBtnCorner.Parent = AimbotToggleButton

AimbotToggleButton.MouseButton1Click:Connect(function()
    _G.CustomAimbotActive = not _G.CustomAimbotActive
    if _G.CustomAimbotActive then
        AimbotToggleButton.Text = "AIMBOT: ON"
        AimbotToggleButton.TextColor3 = Color3.fromRGB(0,255,100)
        FOVStroke.Color = Color3.fromRGB(0,255,100)
    else
        AimbotToggleButton.Text = "AIMBOT: OFF"
        AimbotToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
        FOVStroke.Color = Color3.fromRGB(0,170,255)
    end
end)

-- Dragging for aimbot button
local dragging = false
local dragStart, startPos

AimbotToggleButton.InputBegan:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = AimbotToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not _G.AimbotDraggable then return end
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        AimbotToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ================================================================
-- No Recoil (memory manipulation)
-- ================================================================
local function clearRecoil()
    local function setRecoil(table, key, value)
        if typeof(table) ~= "table" then return end
        pcall(function()
            if setreadonly then setreadonly(table, false) end
            rawset(table, key, value)
        end)
    end

    for _, module in ipairs(getgc and getgc() or {}) do
        if type(module) == "table" then
            pcall(function()
                local recoil = rawget(module, "Recoil")
                if recoil then
                    if typeof(recoil) == "table" then
                        for k,_ in pairs(recoil) do
                            setRecoil(recoil, k, 0)
                        end
                    elseif typeof(recoil) == "number" then
                        setRecoil(module, "Recoil", 0)
                    end
                end
                local recoil2 = rawget(module, "recoil")
                if recoil2 then
                    if typeof(recoil2) == "table" then
                        for k,_ in pairs(recoil2) do
                            setRecoil(recoil2, k, 0)
                        end
                    elseif typeof(recoil2) == "number" then
                        setRecoil(module, "recoil", 0)
                    end
                end
            end)
        end
    end
end

RunService.Heartbeat:Connect(function()
    if noRecoilActive then
        clearRecoil()
    end
end)

-- ================================================================
-- Aimbot logic (silent aim)
-- ================================================================
local function isVisible(part)
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character }
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        table.insert(params.FilterDescendantsInstances, LocalPlayer.Character.Head)
    end
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, part.Position - origin, params)
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

RunService.RenderStepped:Connect(function()
    if not _G.CustomAimbotVisible or not _G.CustomAimbotActive then return end

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestDist = aimbotFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") then
                local head = char.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < bestDist then
                        if isVisible(head) then
                            bestDist = dist
                            bestTarget = head
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

-- ================================================================
-- ESP System
-- ================================================================
local espData = {}

local function removeESP(player)
    if espData[player] then
        if espData[player].Billboard then espData[player].Billboard:Destroy() end
        if espData[player].Highlight then espData[player].Highlight:Destroy() end
        espData[player] = nil
    end
end

local function setupESP(player)
    if player == LocalPlayer then return end
    espData[player] = espData[player] or {}

    local function onCharacterAdded(character)
        removeESP(player)
        if not character then return end
        local head = character:WaitForChild("Head", 5)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not head or not humanoid then return end

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
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(0,170,255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.Parent = character

        espData[player].Billboard = billboard
        espData[player].Highlight = highlight
        espData[player].Character = character
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Initial setup
for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end

Players.PlayerAdded:Connect(function(player)
    setupESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- ================================================================
-- Main Tab features
-- ================================================================
MainTab:AddToggle("InfiniteStamina", {
    Title = "Infinite Stamina",
    Description = "Locks stamina at 100 so you can sprint endlessly.",
    Default = false,
    Callback = function(state) _G.InfiniteStaminaEnabled = state end
})

MainTab:AddToggle("AutoPickup", {
    Title = "Auto Pickup Dropped Loot",
    Description = "Teleports dropped tools to you.",
    Default = false,
    Callback = function(state)
        _G.AutoLoot = state
        if state then
            task.spawn(function()
                while _G.AutoLoot do
                    pcall(function()
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj:IsA("Tool") or string.find(string.lower(obj.Name), "loot") then
                                local handle = obj:FindFirstChild("Handle")
                                if handle and handle:IsA("BasePart") then
                                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if root then
                                        handle.CFrame = root.CFrame
                                    end
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
    Callback = function(state) _G.InstantInteractEnabled = state end
})

MainTab:AddToggle("NoJumpCooldown", {
    Title = "No Jump Cooldown",
    Description = "Removes jump cooldown for continuous jumping.",
    Default = false,
    Callback = function(state) _G.NoJumpCooldownEnabled = state end
})

MainTab:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Allows you to walk through walls.",
    Default = false,
    Callback = function(state) _G.NoclipEnabled = state end
})

MainTab:AddToggle("WalkSpeedToggle", {
    Title = "Safe Speed Boost",
    Description = "Boost your speed by a little without anti-cheat detecting it.",
    Default = false,
    Callback = function(state) _G.WalkSpeedEnabled = state end
})

-- ================================================================
-- Auto Farm Tab
-- ================================================================
AutoFarmTab:AddToggle("SpawnAutoFarmGui", {
    Title = "Spawn Auto Farm Button",
    Description = "Show or hide the floating auto farm menu.",
    Default = false,
    Callback = function(state)
        _G.CustomAutoFarmVisible = state
        AutoFarmGui.Enabled = state
        if not state then
            autoFarmRunning = false
            AutoFarmButton.Text = "Auto Farm: OFF"
            AutoFarmButton.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end
})

AutoFarmTab:AddToggle("FreezeAutoFarmBtn", {
    Title = "Freeze Auto Farm UI",
    Description = "Lock's the floating auto farm UI so you cannot drag it.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmDraggable = not state
        AutoFarmFrame.Draggable = not state
    end
})

-- ================================================================
-- Combat Tab
-- ================================================================
CombatTab:AddButton({
    Title = "No Recoil",
    Description = "When you shoot, your camera won't move AKA freeze your aim without it going up.",
    Callback = function()
        if noRecoilActive then
            Fluent:Notify({
                Title = "No Recoil",
                Content = "No Recoil is already active!",
                Duration = 3
            })
            return
        end
        noRecoilActive = true
        task.spawn(function()
            while noRecoilActive do
                task.wait(3)
                pcall(clearRecoil)
            end
        end)
        Fluent:Notify({
            Title = "No Recoil Enabled",
            Content = "Weapon recoil modified to 0.",
            Duration = 4
        })
    end
})

CombatTab:AddToggle("SpawnAimbotGui", {
    Title = "Spawn Aimbot UI",
    Description = "Show or hide the floating aimbot UI and FOV ring.",
    Default = false,
    Callback = function(state)
        _G.CustomAimbotVisible = state
        AimbotGui.Enabled = state
        if not state then
            _G.CustomAimbotActive = false
            AimbotToggleButton.Text = "AIMBOT: OFF"
            AimbotToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
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
    Callback = function(value)
        aimbotFOV = value
        FOVCircle.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
    end
})

CombatTab:AddToggle("FreezeAimbotBtn", {
    Title = "Freeze Aimbot UI",
    Description = "Lock's the floating aimbot UI so you cannot drag it.",
    Default = false,
    Callback = function(state)
        _G.AimbotDraggable = not state
    end
})

-- ================================================================
-- Visuals Tab
-- ================================================================
VisualsTab:AddToggle("InfiniteZoomToggle", {
    Title = "Max Zoom Out",
    Description = "Bypasses max camera zoom limits.",
    Default = false,
    Callback = function(state)
        _G.InfiniteZoomEnabled = state
        if not state then
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
})

VisualsTab:AddToggle("PlayerESP", {
    Title = "Player ESP (Name & Body Highlight)",
    Description = "Highlight characters & shows their name tag.",
    Default = false,
    Callback = function(state)
        _G.ESPEnabled = state
    end
})

-- Player selection dropdown (for inspect inventory)
local playerNames = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.DisplayName)
    end
end

local selectedPlayer = nil
local dropdown = VisualsTab:AddDropdown("SelectTargetPlayer", {
    Title = "Select Player",
    Description = "Choose a player to inspect.",
    Values = playerNames,
    Default = 1,
    Callback = function(value)
        selectedPlayer = value
    end
})

VisualsTab:AddButton({
    Title = "Inspect Inventory",
    Description = "Check the user's tools & equipped tools.",
    Callback = function()
        if not selectedPlayer then return end
        local target = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player.DisplayName == selectedPlayer or player.Name == selectedPlayer then
                target = player
                break
            end
        end
        if not target then return end

        local inventory = {}
        local char = target.Character
        if char then
            local backpack = char:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(inventory, tool.Name)
                    end
                end
            end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local equipped = humanoid:FindFirstChild("EquippedTool") or humanoid:FindFirstChild("ActiveTool")
                if equipped and equipped:IsA("Tool") then
                    table.insert(inventory, equipped.Name .. " (Equipped)")
                end
            end
        end

        local content = #inventory > 0 and table.concat(inventory, ", ") or "Inventory is empty."
        Fluent:Notify({
            Title = target.DisplayName .. "'s Inventory",
            Content = content,
            Duration = 6
        })
    end
})

-- ================================================================
-- Socials Tab
-- ================================================================
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
        if setclipboard then setclipboard("https://youtube.com/@strixwashere") end
    end
})

-- ================================================================
-- Credits Tab
-- ================================================================
CreditsTab:AddParagraph({
    Title = "Solo Developer",
    Content = "@strixwashere"
})
CreditsTab:AddParagraph({
    Title = "UI Library",
    Content = "Modded Fluent UI by @strixwashere"
})

-- ================================================================
-- Settings Tab
-- ================================================================
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
            for _, child in ipairs(lighting:GetChildren()) do
                if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Sky") or child:IsA("Clouds") or child:IsA("BlurEffect") then
                    child:Destroy()
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
    Callback = function(value)
        if value == "Small" then
            Window.Root.Size = UDim2.fromOffset(480, 320)
        elseif value == "Medium" then
            Window.Root.Size = UDim2.fromOffset(580, 440)
        end
    end
})

-- ================================================================
-- Watermark
-- ================================================================
local Watermark = Instance.new("ScreenGui")
Watermark.Name = "CaliStreetsWatermark"
Watermark.Parent = CoreGui
Watermark.ResetOnSpawn = false
Watermark.DisplayOrder = -1

local WatermarkText = Instance.new("TextLabel")
WatermarkText.Name = "WatermarkText"
WatermarkText.Parent = Watermark
WatermarkText.BackgroundTransparency = 1
WatermarkText.AnchorPoint = Vector2.new(0.5, 0)
WatermarkText.Position = UDim2.new(0.5, 0, 0, 5)
WatermarkText.Size = UDim2.new(0, 400, 0, 20)
WatermarkText.Font = Enum.Font.SourceSansBold
WatermarkText.Text = "DARK HUB | by @strixwashere"
WatermarkText.TextColor3 = Color3.fromRGB(255,255,255)
WatermarkText.TextTransparency = 0.4
WatermarkText.TextSize = 13
WatermarkText.TextXAlignment = Enum.TextXAlignment.Center

-- ================================================================
-- Mobile Toggle Button (minimize)
-- ================================================================
local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "MobileToggleGui"
MobileGui.Parent = CoreGui
MobileGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MobileGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
ToggleBtn.BorderColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "DARK HUB"
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.TextSize = 11

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1,0)
ToggleCorner.Parent = ToggleBtn

-- Dragging for mobile button
local mobileDrag = false
local mobileStart, mobilePos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        mobileDrag = true
        mobileStart = input.Position
        mobilePos = ToggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mobileDrag = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if mobileDrag and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - mobileStart
        ToggleBtn.Position = UDim2.new(mobilePos.X.Scale, mobilePos.X.Offset + delta.X,
                                       mobilePos.Y.Scale, mobilePos.Y.Offset + delta.Y)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- ================================================================
-- Instant Interact (ProximityPrompt hook)
-- ================================================================
ProximityPromptService.PromptShown:Connect(function(prompt)
    if _G.InstantInteractEnabled then
        fireproximityprompt(prompt)
    end
end)

-- ================================================================
-- RunService loops for features
-- ================================================================
RunService.Stepped:Connect(function()
    -- Infinite Zoom
    if _G.InfiniteZoomEnabled then
        LocalPlayer.CameraMaxZoomDistance = 100000
    end

    -- ESP visibility
    for _, data in pairs(espData) do
        if data.Billboard then
            data.Billboard.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChildOfClass("Humanoid")
        end
        if data.Highlight then
            data.Highlight.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    -- Noclip
    if _G.NoclipEnabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Walk Speed
    if _G.WalkSpeedEnabled then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if humanoid and root then
            -- Stamina lock (if InfiniteStamina enabled)
            if _G.InfiniteStaminaEnabled then
                for _, val in ipairs(char:GetDescendants()) do
                    if val:IsA("NumberValue") and string.lower(val.Name):match("stamina") then
                        val.Value = 100
                    end
                end
                -- Also check attributes
                for attr, val in pairs(char:GetAttributes()) do
                    if string.lower(attr):match("stamina") and type(val) == "number" then
                        char:SetAttribute(attr, 100)
                    end
                end
            end

            -- Speed boost
            root.CFrame = root.CFrame + humanoid.MoveDirection * (_G.WalkSpeedMultiplier - 1) * 0.5
        end
    end
end)

-- Jump cooldown removal (tick)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and _G.NoJumpCooldownEnabled then
            humanoid.JumpPower = humanoid.JumpPower
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            end)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if _G.NoJumpCooldownEnabled then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local state = humanoid:GetState()
                if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

-- ================================================================
-- Cleanup on close
-- ================================================================
local function cleanup()
    pcall(function()
        autoFarmRunning = false
        noRecoilActive = false
        _G.CustomAimbotActive = false
        if AutoFarmGui then AutoFarmGui:Destroy() end
        if AimbotGui then AimbotGui:Destroy() end
        if LoadingScreen then LoadingScreen:Destroy() end
        if MobileGui then MobileGui:Destroy() end
        if Watermark then Watermark:Destroy() end
    end)
end

if Window and Window.Closed then
    Window.Closed:Connect(cleanup)
end

-- ================================================================
-- Finish loading
-- ================================================================
updateLoading(1, "Ready")
task.wait(0.5)
loadingActive = false

local finishTween = TweenService:Create(LoadFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    GroupTransparency = 1
})
finishTween:Play()
finishTween.Completed:Wait()
LoadingScreen:Destroy()

Fluent:Notify({
    Title = "DARK HUB Loaded",
    Content = "Welcome! All features are ready.",
    Duration = 5
})