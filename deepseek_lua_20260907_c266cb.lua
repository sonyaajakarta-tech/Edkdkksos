-- =====================================================================
-- DARK HUB San Aurie 
-- =====================================================================

-- =====================================================================
-- Services
-- =====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInput = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =====================================================================
-- Logger
-- =====================================================================
local function Log(msg)
    if rconsoleprint then
        rconsoleprint("[DARK HUB] " .. msg .. "\n")
    else
        print("[DARK HUB] " .. msg)
    end
end

-- =====================================================================
-- Settings
-- =====================================================================
_G.Settings = {
    -- Combat
    AimPlayers      = false,
    WallCheck       = false,
    SilentAim       = false,
    Triggerbot      = false,
    Smoothness      = 0.15,
    FOV             = 150,
    ShowFOVCircle   = false,
    FOVCircleColor  = Color3.fromRGB(255, 255, 255),
    FOVCircleThickness = 1.5,
    FOVCircleTransparency = 0.8,
    TeamCheck       = false,

    -- ESP
    PlayerESP       = false,
    PlayerName      = false,
    PlayerBox       = false,
    PlayerDistance  = false,
    PlayerHealthBar = false,
    PlayerWanted    = false,
    TextSize        = 12,
    ESPRange        = 20000,
    ShowTracer      = false,

    -- Team Colors
    TeamColors = {
        Police    = Color3.fromRGB(0, 100, 255),
        Civilian  = Color3.fromRGB(0, 255, 0),
        Medical   = Color3.fromRGB(255, 255, 255),
        Farmer    = Color3.fromRGB(255, 255, 0),
        Transit   = Color3.fromRGB(255, 165, 0),
        Prisoner  = Color3.fromRGB(255, 0, 255),
        Delivery  = Color3.fromRGB(0, 255, 255),
        Neutral   = Color3.fromRGB(128, 128, 128),
    },
    WantedColor     = Color3.fromRGB(255, 0, 0),

    -- World
    FullBright      = false,
    TPWalk          = false,
    TPWalkSpeed     = 25,
    AntiAFK         = true,
    AntiRagdoll     = false,

    -- Interact
    InstantInteract = false,
    InteractDistance = 2000,
    InteractHoldDuration = 0,

    -- Misc
    Noclip          = false,
    HitboxExtender  = false,
    HitboxSize      = 15,
    HitboxColor     = Color3.fromRGB(255, 0, 0),

    -- Auto-Arrest
    AutoArrest      = false,
    ArrestDistance  = 20000,
}

-- =====================================================================
-- Configuration Saving
-- =====================================================================
local function SaveConfig()
    if Rayfield and Rayfield.SaveConfiguration then
        pcall(Rayfield.SaveConfiguration)
    end
end

-- =====================================================================
-- Notifications
-- =====================================================================
local lastNotification = {}
local function NotifyToggle(name, state)
    local key = name .. tostring(state)
    if lastNotification[key] and (tick() - lastNotification[key]) < 0.5 then
        return
    end
    lastNotification[key] = tick()

    local content = state and "ON" or "OFF"
    local image   = state and "check" or "x"

    if Rayfield and Rayfield.Notify then
        pcall(function()
            Rayfield:Notify({
                Title = name,
                Content = content,
                Duration = 2.5,
                Image = image,
            })
        end)
    else
        Log(name .. " " .. content)
    end
end

local function Notify(title, content, icon, duration)
    local key = title .. content
    if lastNotification[key] and (tick() - lastNotification[key]) < 0.5 then
        return
    end
    lastNotification[key] = tick()

    if Rayfield and Rayfield.Notify then
        pcall(function()
            Rayfield:Notify({
                Title = title,
                Content = content,
                Duration = duration or 3,
                Image = icon or "info",
            })
        end)
    else
        Log(title .. ": " .. content)
    end
end

-- =====================================================================
-- System 1: Noclip 
-- =====================================================================
local noclipConnection = nil
local noclipEnabled = false

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- Restore collisions
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function ToggleNoclip(state)
    _G.Settings.Noclip = state
    toggleNoclip(state)
    NotifyToggle("Noclip", state)
    SaveConfig()
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    if _G.Settings.Noclip then
        toggleNoclip(true)
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if noclipEnabled then
        toggleNoclip(false)
    end
end)

-- =====================================================================
-- System 2: Hitbox Extender
-- =====================================================================
local hitboxConnection = nil
local hitboxActive = false
local hitboxData = {}

local function IsTargetPlayer(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if _G.Settings.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end
    return true
end

local function ApplyHitbox(player)
    if not player or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not hitboxData[player] then
        hitboxData[player] = {
            part = root,
            origSize = root.Size,
            origColor = root.Color,
            origTrans = root.Transparency,
            origMat = root.Material,
        }
    end
    local size = _G.Settings.HitboxSize
    local color = _G.Settings.HitboxColor
    root.Size = Vector3.new(size, size, size)
    root.CanCollide = false
    root.Transparency = 0.5
    root.Color = color
    root.Material = Enum.Material.Neon
end

local function ResetHitbox(player)
    local data = hitboxData[player]
    if data and data.part and data.part.Parent then
        data.part.Size = data.origSize or Vector3.new(2, 2, 1)
        data.part.CanCollide = true
        data.part.Transparency = data.origTrans or 0
        data.part.Color = data.origColor or Color3.fromRGB(255, 255, 255)
        data.part.Material = data.origMat or Enum.Material.Plastic
    end
    hitboxData[player] = nil
end

local function ApplyToAll()
    for _, player in pairs(Players:GetPlayers()) do
        if IsTargetPlayer(player) then
            ApplyHitbox(player)
        end
    end
end

local function StartHitboxExtender()
    if hitboxConnection then
        hitboxConnection:Disconnect()
        hitboxConnection = nil
    end
    hitboxActive = true
    ApplyToAll()
    hitboxConnection = RunService.Stepped:Connect(function()
        if not hitboxActive then return end
        for _, player in pairs(Players:GetPlayers()) do
            if IsTargetPlayer(player) then
                local data = hitboxData[player]
                if not data or not data.part or not data.part.Parent then
                    ApplyHitbox(player)
                else
                    local root = data.part
                    if root and root.Parent then
                        root.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                        root.CanCollide = false
                        root.Transparency = 0.5
                        root.Color = _G.Settings.HitboxColor
                        root.Material = Enum.Material.Neon
                    end
                end
            else
                if hitboxData[player] then ResetHitbox(player) end
            end
        end
    end)
end

local function StopHitboxExtender()
    hitboxActive = false
    if hitboxConnection then
        hitboxConnection:Disconnect()
        hitboxConnection = nil
    end
    for player, _ in pairs(hitboxData) do
        ResetHitbox(player)
    end
    hitboxData = {}
end

local function ToggleHitboxExtender(state)
    _G.Settings.HitboxExtender = state
    if state then StartHitboxExtender() else StopHitboxExtender() end
    NotifyToggle("Hitbox Extender", state)
    SaveConfig()
end

local function UpdateHitboxSize(newSize)
    _G.Settings.HitboxSize = newSize
    if hitboxActive then
        for player, data in pairs(hitboxData) do
            if data and data.part and data.part.Parent then
                data.part.Size = Vector3.new(newSize, newSize, newSize)
            end
        end
    end
    SaveConfig()
end

local function UpdateHitboxColor(newColor)
    _G.Settings.HitboxColor = newColor
    if hitboxActive then
        for player, data in pairs(hitboxData) do
            if data and data.part and data.part.Parent then
                data.part.Color = newColor
            end
        end
    end
    SaveConfig()
end

Players.PlayerAdded:Connect(function(player)
    if hitboxActive then
        player.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            if hitboxActive and IsTargetPlayer(player) then
                ApplyHitbox(player)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if hitboxData[player] then ResetHitbox(player) end
end)

-- =====================================================================
-- System 3: Instant Interact
-- =====================================================================
local OriginalPromptData = {}

local function ApplyToPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    if not _G.Settings.InstantInteract then
        local data = OriginalPromptData[prompt]
        if data then
            prompt.HoldDuration = data.HoldDuration
            prompt.MaxActivationDistance = data.MaxActivationDistance
            OriginalPromptData[prompt] = nil
        end
        return
    end
    if not OriginalPromptData[prompt] then
        OriginalPromptData[prompt] = {
            HoldDuration = prompt.HoldDuration,
            MaxActivationDistance = prompt.MaxActivationDistance,
        }
    end
    prompt.HoldDuration = _G.Settings.InteractHoldDuration
    prompt.MaxActivationDistance = _G.Settings.InteractDistance
end

local function ApplyToAllPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            ApplyToPrompt(prompt)
        end
    end
end

local function ToggleInstantInteract(state)
    _G.Settings.InstantInteract = state
    if state then
        ApplyToAllPrompts()
    else
        for prompt, data in pairs(OriginalPromptData) do
            if prompt and prompt.Parent then
                prompt.HoldDuration = data.HoldDuration
                prompt.MaxActivationDistance = data.MaxActivationDistance
            end
        end
        OriginalPromptData = {}
    end
    NotifyToggle("Instant Interact", state)
    SaveConfig()
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        ApplyToPrompt(descendant)
    end
end)

ProximityPromptService.PromptShown:Connect(function(prompt)
    ApplyToPrompt(prompt)
end)

-- =====================================================================
-- System 4: Shop Opener
-- =====================================================================
local function OpenShop()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then
        Notify("Shop", "PlayerGui not found.", "error", 3)
        return
    end

    local prompts = gui:FindFirstChild("ProximityPrompts")
    if not prompts then
        Notify("Shop", "ProximityPrompts folder not found.", "error", 3)
        return
    end

    local shopButton = nil
    for _, child in pairs(prompts:GetDescendants()) do
        if child:IsA("ImageButton") or child:IsA("TextButton") then
            local name = child.Name:lower()
            local tooltip = child.ToolTip and child.ToolTip:lower() or ""
            if name:find("shop") or tooltip:find("shop") then
                shopButton = child
                break
            end
        end
    end

    if not shopButton then
        Notify("Shop", "Shop button not found. Get closer to the NPC.", "error", 3)
        return
    end

    local success = false
    pcall(function() shopButton:Activate() success = true end)
    if not success then
        pcall(function() shopButton:SimulateClick() success = true end)
    end
    if not success then
        pcall(function() shopButton.MouseButton1Click:Fire() success = true end)
    end
    if not success then
        pcall(function() shopButton.MouseButton1Down:Fire() success = true end)
    end

    if success then
        Notify("Shop", "Shop opened successfully!", "shopping-cart", 3)
    else
        Notify("Shop", "Failed to open shop.", "error", 3)
    end
end

-- =====================================================================
-- System 5: Team Check & Wanted
-- =====================================================================
local function IsTeamAllowed(player)
    if not _G.Settings.TeamCheck then return true end
    if not player or not player.Team or not LocalPlayer.Team then return true end
    return player.Team ~= LocalPlayer.Team
end

local WantedCache = {}

local function IsPlayerWanted(player)
    if not player then return false, 0 end
    if player.Team then
        local team = player.Team.Name
        if team == "Police" or team == "Medical" or team == "Fire" or team == "Neutral" then
            return false, 0
        end
    end
    local wantedLevel = player:GetAttribute("WantedLevel")
    if wantedLevel and wantedLevel > 0 then
        if player:GetAttribute("Arrested") == true or
           player:GetAttribute("Downed") == true or
           player:GetAttribute("Dead") == true then
            return false, 0
        end
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            return false, 0
        end
        return true, wantedLevel
    end
    return false, 0
end

local function SetupWantedListener(player)
    if not player then return end
    local function OnAttributeChanged(attr)
        if attr == "WantedLevel" or attr == "Arrested" or attr == "Downed" or attr == "Dead" then
            WantedCache[player] = nil
        end
    end
    local function OnTeamChanged()
        WantedCache[player] = nil
    end
    player.AttributeChanged:Connect(OnAttributeChanged)
    player:GetPropertyChangedSignal("Team"):Connect(OnTeamChanged)
end

for _, p in pairs(Players:GetPlayers()) do SetupWantedListener(p) end
Players.PlayerAdded:Connect(SetupWantedListener)

local function GetTeamColor(player)
    if not player or not player.Team then
        return Color3.fromRGB(255, 255, 255)
    end
    local color = _G.Settings.TeamColors[player.Team.Name]
    return color or Color3.fromRGB(255, 255, 255)
end

-- =====================================================================
-- System 6: FOV Circle
-- =====================================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Visible = false

local function UpdateFOVCircle()
    FOVCircle.Visible = _G.Settings.ShowFOVCircle
    FOVCircle.Radius = _G.Settings.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Color = _G.Settings.FOVCircleColor
    FOVCircle.Thickness = _G.Settings.FOVCircleThickness
    FOVCircle.Transparency = _G.Settings.FOVCircleTransparency
end

-- =====================================================================
-- System 7: Aimbot
-- =====================================================================
local function GetDist(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return math.floor((char.HumanoidRootPart.Position - pos).Magnitude)
    end
    return 99999
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = true

local function IsVisible(targetPart)
    if not targetPart or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then
        return false
    end
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, raycastParams)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function GetClosestTarget()
    if not _G.Settings.AimPlayers then return nil end
    local targetPart = nil
    local dist = _G.Settings.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            if not IsTeamAllowed(v) then continue end
            local head = v.Character:FindFirstChild("Head")
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                if _G.Settings.WallCheck and not IsVisible(head) then continue end
                local pos, vis = Camera:WorldToViewportPoint(head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if mag < dist then
                        targetPart = head
                        dist = mag
                    end
                end
            end
        end
    end
    return targetPart
end

-- =====================================================================
-- System 8: ESP
-- =====================================================================
local ESPCache = {}
local HighlightCache = {}
local TracerCache = {}

local function GetOrCreateESP(char, tag)
    local cache = ESPCache[char]
    if not cache then
        cache = {}
        ESPCache[char] = cache
    end
    local bill = cache[tag]
    if not bill then
        local root = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        bill = Instance.new("BillboardGui")
        bill.Name = tag
        bill.Adornee = root
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 150, 0, 60)
        bill.StudsOffset = Vector3.new(0, 3.5, 0)
        bill.Parent = root
        local label = Instance.new("TextLabel")
        label.Name = "TextL"
        label.Parent = bill
        label.Text = ""
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        cache[tag] = bill
    end
    return bill
end

local function UpdateESP(char, text, color, tag, show)
    if not show then
        local cache = ESPCache[char]
        if cache and cache[tag] then
            cache[tag].Enabled = false
        end
        return
    end
    local bill = GetOrCreateESP(char, tag)
    if bill then
        bill.Enabled = true
        local label = bill:FindFirstChild("TextL")
        if label then
            label.TextSize = _G.Settings.TextSize
            label.TextColor3 = color
            label.Text = text
        end
    end
end

local function UpdateHighlight(char, color, enabled)
    if not enabled then
        local h = HighlightCache[char]
        if h then h.Enabled = false end
        return
    end
    local highlight = HighlightCache[char]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "DARKHUBHighlight"
        highlight.Parent = char
        HighlightCache[char] = highlight
    end
    highlight.Enabled = true
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
end

local function UpdateTracer(player, color)
    if not _G.Settings.ShowTracer then
        local t = TracerCache[player]
        if t then t.Visible = false end
        return
    end
    local char = player.Character
    if not char then
        if TracerCache[player] then TracerCache[player].Visible = false end
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not root then
        if TracerCache[player] then TracerCache[player].Visible = false end
        return
    end
    local dist = GetDist(root.Position)
    if dist > _G.Settings.ESPRange then
        if TracerCache[player] then TracerCache[player].Visible = false end
        return
    end
    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then
        if TracerCache[player] then TracerCache[player].Visible = false end
        return
    end
    local tracer = TracerCache[player]
    if not tracer then
        tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Color = color
        tracer.Transparency = 0.5
        tracer.Visible = false
        TracerCache[player] = tracer
    end
    tracer.Visible = true
    tracer.Color = color
    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    tracer.To = Vector2.new(pos.X, pos.Y)
end

local function CleanupPlayer(player)
    if not player then return end
    local char = player.Character
    if char then
        local cache = ESPCache[char]
        if cache then
            for _, bill in pairs(cache) do bill:Destroy() end
            ESPCache[char] = nil
        end
        local h = HighlightCache[char]
        if h then h:Destroy(); HighlightCache[char] = nil end
    end
    local tracer = TracerCache[player]
    if tracer then
        tracer.Visible = false
        TracerCache[player] = nil
    end
end

local function UpdatePlayerESP()
    if not _G.Settings.PlayerESP then
        for char, _ in pairs(ESPCache) do
            local p = char.Parent and Players:FindFirstChild(char.Parent.Name)
            if p then CleanupPlayer(p) end
        end
        return
    end
    local range = _G.Settings.ESPRange
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local rp = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if rp and hum and hum.Health > 0 then
                local dist = GetDist(rp.Position)
                if dist > range then
                    CleanupPlayer(p)
                    continue
                end
                local show = _G.Settings.PlayerName or _G.Settings.PlayerDistance or _G.Settings.PlayerHealthBar or _G.Settings.PlayerWanted
                local text = ""
                if _G.Settings.PlayerName then text = p.Name end
                if _G.Settings.PlayerDistance then text = text .. (text ~= "" and "\n" or "") .. "[" .. dist .. "m]" end
                if _G.Settings.PlayerHealthBar then text = text .. (text ~= "" and "\n" or "") .. "HP: " .. math.floor(hum.Health) end
                local color = GetTeamColor(p)
                if _G.Settings.PlayerWanted then
                    local wanted, level = IsPlayerWanted(p)
                    if wanted then
                        text = text .. (text ~= "" and "\n" or "") .. "WANTED [" .. level .. "]"
                        color = _G.Settings.WantedColor
                    end
                end
                UpdateESP(char, text, color, "DARKHUBESP", show)
                UpdateHighlight(char, color, _G.Settings.PlayerBox)
                UpdateTracer(p, color)
            else
                CleanupPlayer(p)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(UpdatePlayerESP)
    end
end)

-- =====================================================================
-- System 9: TP-Walk 
-- =====================================================================
local tpWalkConnection = nil

local function StartTPWalk()
    if tpWalkConnection then return end
    tpWalkConnection = RunService.Heartbeat:Connect(function()
        if not _G.Settings.TPWalk then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local speed = _G.Settings.TPWalkSpeed
            root.Velocity = moveDir * speed
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local function StopTPWalk()
    if tpWalkConnection then
        tpWalkConnection:Disconnect()
        tpWalkConnection = nil
    end
end

local function ToggleTPWalk(state)
    _G.Settings.TPWalk = state
    if state then StartTPWalk() else StopTPWalk() end
    NotifyToggle("TP-Walk", state)
    SaveConfig()
end

-- =====================================================================
-- System 10: Anti-Ragdoll 
-- =====================================================================
local antiRagdollConnection = nil

local function StartAntiRagdoll()
    if antiRagdollConnection then return end
    
    antiRagdollConnection = RunService.Heartbeat:Connect(function()
        if not _G.Settings.AntiRagdoll then 
            StopAntiRagdoll()
            return 
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local currentState = hum:GetState()
        if currentState == Enum.HumanoidStateType.Physics or 
           currentState == Enum.HumanoidStateType.Ragdoll or
           currentState == Enum.HumanoidStateType.Dead then
            
            hum:ChangeState(Enum.HumanoidStateType.Running)
            
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    NotifyToggle("Anti-Ragdoll", true)
end

local function StopAntiRagdoll()
    if antiRagdollConnection then
        antiRagdollConnection:Disconnect()
        antiRagdollConnection = nil
    end
    NotifyToggle("Anti-Ragdoll", false)
end

local function ToggleAntiRagdoll(state)
    _G.Settings.AntiRagdoll = state
    if state then StartAntiRagdoll() else StopAntiRagdoll() end
    SaveConfig()
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    if _G.Settings.AntiRagdoll then
        StopAntiRagdoll()
        StartAntiRagdoll()
    end
end)

-- =====================================================================
-- System 11: Auto-Arrest 
-- =====================================================================
local autoArrestConnection = nil
local autoArrestGlueConnection = nil
local lastArrestAttempt = {}
local currentTarget = nil
local isHoldingE = false
local isArresting = false

local function StartAutoArrest()
    if autoArrestConnection then return end
    
    autoArrestConnection = RunService.Heartbeat:Connect(function()
        if not _G.Settings.AutoArrest then 
            StopAutoArrest()
            return 
        end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Check if player is police
        if LocalPlayer.Team and LocalPlayer.Team.Name ~= "Police" then
            return
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- If currently arresting someone, check if they're still wanted
        if currentTarget and isArresting then
            if not currentTarget.Character then
                StopAutoArrest()
                return
            end
            
            local wanted, _ = IsPlayerWanted(currentTarget)
            if not wanted then
                -- Target no longer wanted, release
                StopAutoArrest()
                return
            end
            
            -- Continue arresting current target
            return
        end
        
        -- Find new target if not currently arresting
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            
            -- Skip if recently attempted (unless it's the current target)
            if lastArrestAttempt[player] and (tick() - lastArrestAttempt[player]) < 3 then
                continue
            end
            
            local wanted, _ = IsPlayerWanted(player)
            if not wanted then continue end
            
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then continue end
            
            local dist = (root.Position - targetRoot.Position).Magnitude
            
            if dist <= _G.Settings.ArrestDistance then
                -- Found a new target, start arresting
                currentTarget = player
                isArresting = true
                lastArrestAttempt[player] = tick()
                
                pcall(function()
                    -- Equip handcuffs
                    local handcuffs = nil
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") and item.Name == "PD Handcuffs" then
                            handcuffs = item
                            break
                        end
                    end
                    
                    if not handcuffs then
                        for _, item in pairs(char:GetChildren()) do
                            if item:IsA("Tool") and item.Name == "PD Handcuffs" then
                                handcuffs = item
                                break
                            end
                        end
                    end
                    
                    if handcuffs then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:EquipTool(handcuffs)
                            task.wait(0.15)
                        end
                    end
                    
                    -- Start glue loop
                    if autoArrestGlueConnection then
                        autoArrestGlueConnection:Disconnect()
                        autoArrestGlueConnection = nil
                    end
                    
                    -- Hold E key down
                    if not isHoldingE then
                        VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        isHoldingE = true
                    end
                    
                    local glueCount = 0
                    autoArrestGlueConnection = RunService.Heartbeat:Connect(function()
                        if not _G.Settings.AutoArrest then
                            StopAutoArrest()
                            return
                        end
                        
                        if not currentTarget or not currentTarget.Character then
                            StopAutoArrest()
                            return
                        end
                        
                        local currentRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetRoot2 = currentTarget.Character:FindFirstChild("HumanoidRootPart")
                        
                        if not currentRoot or not targetRoot2 then 
                            StopAutoArrest()
                            return 
                        end
                        
                        -- Check if target is still wanted
                        local wanted, _ = IsPlayerWanted(currentTarget)
                        if not wanted then
                            StopAutoArrest()
                            return
                        end
                        
                        -- Keep teleporting to target (glued)
                        local targetPos = targetRoot2.Position
                        currentRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, 0.3))
                        currentRoot.CFrame = CFrame.new(currentRoot.Position, targetRoot2.Position)
                        
                        glueCount = glueCount + 1
                        
                        -- Keep trying until arrested (no timeout)
                        -- The only exit conditions are: target not wanted, target dead, or auto-arrest toggled off
                    end)
                    
                    Notify("Auto-Arrest", "Arresting " .. currentTarget.Name .. "!", "handcuffs", 2)
                end)
                break
            end
        end
    end)
end

local function StopAutoArrest()
    -- Release E key
    if isHoldingE then
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        isHoldingE = false
    end
    
    if autoArrestGlueConnection then
        autoArrestGlueConnection:Disconnect()
        autoArrestGlueConnection = nil
    end
    
    currentTarget = nil
    isArresting = false
    
    if autoArrestConnection then
        autoArrestConnection:Disconnect()
        autoArrestConnection = nil
    end
end

local function ToggleAutoArrest(state)
    _G.Settings.AutoArrest = state
    if state then 
        StartAutoArrest()
    else 
        StopAutoArrest()
    end
    NotifyToggle("Auto-Arrest", state)
    SaveConfig()
end

-- Cleanup on character death
LocalPlayer.CharacterRemoving:Connect(function()
    StopAutoArrest()
end)

-- Cleanup on player team change
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if _G.Settings.AutoArrest then
        StopAutoArrest()
        task.wait(0.5)
        StartAutoArrest()
    end
end)

-- =====================================================================
-- System 12: Full Bright
-- =====================================================================
local function UpdateFullBright()
    if _G.Settings.FullBright then        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end

-- =====================================================================
-- System 13: Anti-AFK
-- =====================================================================
LocalPlayer.Idled:Connect(function()
    if _G.Settings.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- =====================================================================
-- UI (Rayfield)
-- =====================================================================
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not success then
    Log("Failed to load Rayfield: " .. tostring(err))
    return
end

local Window = Rayfield:CreateWindow({
    Name = "DARK HUB San Aurie",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by DARK HUB",
    Theme = "DarkBlue",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DARK_HUB_SanAurie",
        FileName = "Config"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local CombatTab = Window:CreateTab("Combat", nil)
local VisualsTab = Window:CreateTab("Visuals", nil)
local WorldTab = Window:CreateTab("World", nil)
local KeybindsTab = Window:CreateTab("Keybinds", nil)

-- ===== Combat Tab =====
CombatTab:CreateSection("Aimbot")
local AimToggle = CombatTab:CreateToggle({
    Name = "Aim at Players",
    CurrentValue = false,
    Flag = "Aim",
    Callback = function(v)
        _G.Settings.AimPlayers = v
        NotifyToggle("Aimbot", v)
        SaveConfig()
    end
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Flag = "Wall",
    Callback = function(v)
        _G.Settings.WallCheck = v
        NotifyToggle("Wall Check", v)
        SaveConfig()
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "Silent",
    Callback = function(v)
        _G.Settings.SilentAim = v
        NotifyToggle("Silent Aim", v)
        SaveConfig()
    end
})

CombatTab:CreateToggle({
    Name = "Triggerbot",
    Description = "Auto-shoot when crosshair is on target (Right-click)",
    CurrentValue = false,
    Flag = "Trigger",
    Callback = function(v)
        _G.Settings.Triggerbot = v
        NotifyToggle("Triggerbot", v)
        SaveConfig()
    end
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 15,
    Flag = "Smooth",
    Callback = function(v)
        _G.Settings.Smoothness = v / 100
        SaveConfig()
    end
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 1000},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOV",
    Callback = function(v)
        _G.Settings.FOV = v
        UpdateFOVCircle()
        SaveConfig()
    end
})

CombatTab:CreateSection("Team Check")
CombatTab:CreateToggle({
    Name = "Avoid Same Team",
    Description = "Prevents aiming at players from your own team",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(v)
        _G.Settings.TeamCheck = v
        NotifyToggle("Team Check", v)
        SaveConfig()
    end
})

CombatTab:CreateSection("Hitbox Extender")
local HitboxToggle = CombatTab:CreateToggle({
    Name = "Enable Hitbox Extender",
    Description = "Expand enemy hitboxes for easier targeting",
    CurrentValue = false,
    Flag = "Hitbox",
    Callback = function(v)
        ToggleHitboxExtender(v)
    end
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Description = "Size of enemy hitboxes (max 200)",
    Range = {1, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Flag = "HitboxSize",
    Callback = function(v)
        UpdateHitboxSize(v)
    end
})

CombatTab:CreateColorPicker({
    Name = "Hitbox Color",
    Description = "Color of expanded hitboxes",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "HitboxColor",
    Callback = function(v)
        UpdateHitboxColor(v)
    end
})

-- ===== Visuals Tab =====
VisualsTab:CreateSection("ESP")
local ESPToggle = VisualsTab:CreateToggle({
    Name = "Master ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v)
        _G.Settings.PlayerESP = v
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                CleanupPlayer(p)
            end
        end
        NotifyToggle("ESP", v)
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Names",
    CurrentValue = false,
    Flag = "Names",
    Callback = function(v)
        _G.Settings.PlayerName = v
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Boxes (Highlight)",
    CurrentValue = false,
    Flag = "Boxes",
    Callback = function(v)
        _G.Settings.PlayerBox = v
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Flag = "Dist",
    Callback = function(v)
        _G.Settings.PlayerDistance = v
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Flag = "Health",
    Callback = function(v)
        _G.Settings.PlayerHealthBar = v
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Wanted Status",
    CurrentValue = false,
    Flag = "Wanted",
    Callback = function(v)
        _G.Settings.PlayerWanted = v
        NotifyToggle("Wanted Status", v)
        SaveConfig()
    end
})

VisualsTab:CreateToggle({
    Name = "Tracer (Line)",
    CurrentValue = false,
    Flag = "Tracer",
    Callback = function(v)
        _G.Settings.ShowTracer = v
        NotifyToggle("Tracer", v)
        SaveConfig()
    end
})

VisualsTab:CreateSlider({
    Name = "ESP Range",
    Range = {100, 20000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = 20000,
    Flag = "Range",
    Callback = function(v)
        _G.Settings.ESPRange = v
        SaveConfig()
    end
})

VisualsTab:CreateSlider({
    Name = "Text Size",
    Range = {8, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = 12,
    Flag = "TextSize",
    Callback = function(v)
        _G.Settings.TextSize = v
        SaveConfig()
    end
})

VisualsTab:CreateSection("FOV Circle")
VisualsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "FOVShow",
    Callback = function(v)
        _G.Settings.ShowFOVCircle = v
        UpdateFOVCircle()
        NotifyToggle("FOV Circle", v)
        SaveConfig()
    end
})

VisualsTab:CreateColorPicker({
    Name = "FOV Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColor",
    Callback = function(v)
        _G.Settings.FOVCircleColor = v
        UpdateFOVCircle()
        SaveConfig()
    end
})

VisualsTab:CreateSlider({
    Name = "FOV Thickness",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "px",
    CurrentValue = 1.5,
    Flag = "FOVThick",
    Callback = function(v)
        _G.Settings.FOVCircleThickness = v
        UpdateFOVCircle()
        SaveConfig()
    end
})

VisualsTab:CreateSlider({
    Name = "FOV Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.8,
    Flag = "FOVTrans",
    Callback = function(v)
        _G.Settings.FOVCircleTransparency = v
        UpdateFOVCircle()
        SaveConfig()
    end
})

VisualsTab:CreateSection("Team Colors")
VisualsTab:CreateColorPicker({ Name = "Police", Color = Color3.fromRGB(0, 100, 255), Flag = "Police", Callback = function(v) _G.Settings.TeamColors.Police = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Civilian", Color = Color3.fromRGB(0, 255, 0), Flag = "Civilian", Callback = function(v) _G.Settings.TeamColors.Civilian = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Medical", Color = Color3.fromRGB(255, 255, 255), Flag = "Medical", Callback = function(v) _G.Settings.TeamColors.Medical = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Farmer", Color = Color3.fromRGB(255, 255, 0), Flag = "Farmer", Callback = function(v) _G.Settings.TeamColors.Farmer = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Transit", Color = Color3.fromRGB(255, 165, 0), Flag = "Transit", Callback = function(v) _G.Settings.TeamColors.Transit = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Prisoner", Color = Color3.fromRGB(255, 0, 255), Flag = "Prisoner", Callback = function(v) _G.Settings.TeamColors.Prisoner = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Delivery", Color = Color3.fromRGB(0, 255, 255), Flag = "Delivery", Callback = function(v) _G.Settings.TeamColors.Delivery = v SaveConfig() end })
VisualsTab:CreateColorPicker({ Name = "Wanted", Color = Color3.fromRGB(255, 0, 0), Flag = "WantedColor", Callback = function(v) _G.Settings.WantedColor = v SaveConfig() end })

-- ===== World Tab =====
WorldTab:CreateSection("World")
WorldTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Flag = "Bright",
    Callback = function(v)
        _G.Settings.FullBright = v
        UpdateFullBright()
        NotifyToggle("Full Bright", v)
        SaveConfig()
    end
})

WorldTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AFK",
    Callback = function(v)
        _G.Settings.AntiAFK = v
        SaveConfig()
    end
})

WorldTab:CreateSection("Movement")
local TPWalkToggle = WorldTab:CreateToggle({
    Name = "TP-Walk",
    CurrentValue = false,
    Flag = "TP",
    Callback = function(v)
        ToggleTPWalk(v)
    end
})

WorldTab:CreateSlider({
    Name = "TP Speed",
    Range = {5, 150},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = 25,
    Flag = "TPSpeed",
    Callback = function(v)
        _G.Settings.TPWalkSpeed = v
        SaveConfig()
    end
})

WorldTab:CreateSection("Anti-Ragdoll")
local AntiRagdollToggle = WorldTab:CreateToggle({
    Name = "Anti-Ragdoll",
    Description = "Prevents your character from falling or ragdolling",
    CurrentValue = false,
    Flag = "AntiRagdoll",
    Callback = function(v)
        ToggleAntiRagdoll(v)
    end
})

WorldTab:CreateSection("Noclip")
WorldTab:CreateToggle({
    Name = "Noclip",
    Description = "Walk through walls and objects",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(v)
        ToggleNoclip(v)
    end
})

WorldTab:CreateSection("Auto-Arrest")
local AutoArrestToggle = WorldTab:CreateToggle({
    Name = "Auto-Arrest",
    Description = "Automatically arrest wanted players nearby",
    CurrentValue = false,
    Flag = "AutoArrest",
    Callback = function(v)
        ToggleAutoArrest(v)
    end
})

WorldTab:CreateSlider({
    Name = "Arrest Distance",
    Range = {5, 20000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = 20000,
    Flag = "ArrestDistance",
    Callback = function(v)
        _G.Settings.ArrestDistance = v
        SaveConfig()
    end
})

WorldTab:CreateSection("Instant Interact")
local II_Toggle = WorldTab:CreateToggle({
    Name = "Enable Instant Interact",
    CurrentValue = false,
    Flag = "II",
    Callback = function(v)
        ToggleInstantInteract(v)
    end
})

WorldTab:CreateSlider({
    Name = "Interaction Distance",
    Range = {10, 2000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 2000,
    Flag = "IIDist",
    Callback = function(v)
        _G.Settings.InteractDistance = v
        if _G.Settings.InstantInteract then ApplyToAllPrompts() end
        SaveConfig()
    end
})

WorldTab:CreateSlider({
    Name = "Hold Duration",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = " sec",
    CurrentValue = 0,
    Flag = "IIHold",
    Callback = function(v)
        _G.Settings.InteractHoldDuration = v
        if _G.Settings.InstantInteract then ApplyToAllPrompts() end
        SaveConfig()
    end
})

WorldTab:CreateSection("Utilities")
WorldTab:CreateButton({
    Name = "Open Shop",
    Callback = function()
        OpenShop()
    end
})

WorldTab:CreateButton({
    Name = "Unload",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do CleanupPlayer(p) end
        if _G.Settings.InstantInteract then ToggleInstantInteract(false) end
        ToggleNoclip(false)
        ToggleHitboxExtender(false)
        ToggleTPWalk(false)
        ToggleAntiRagdoll(false)
        ToggleAutoArrest(false)
        FOVCircle:Remove()
        Rayfield:Destroy()
        Log("Unloaded")
    end
})

-- ===== Keybinds Tab =====
KeybindsTab:CreateSection("Keybinds")

KeybindsTab:CreateKeybind({
    Name = "Toggle ESP",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyESP",
    Callback = function()
        _G.Settings.PlayerESP = not _G.Settings.PlayerESP
        ESPToggle:Set(_G.Settings.PlayerESP)
        NotifyToggle("ESP", _G.Settings.PlayerESP)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Aimbot",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyAim",
    Callback = function()
        _G.Settings.AimPlayers = not _G.Settings.AimPlayers
        AimToggle:Set(_G.Settings.AimPlayers)
        NotifyToggle("Aimbot", _G.Settings.AimPlayers)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle TP-Walk",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyTP",
    Callback = function()
        _G.Settings.TPWalk = not _G.Settings.TPWalk
        TPWalkToggle:Set(_G.Settings.TPWalk)
        ToggleTPWalk(_G.Settings.TPWalk)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Anti-Ragdoll",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyAntiRagdoll",
    Callback = function()
        _G.Settings.AntiRagdoll = not _G.Settings.AntiRagdoll
        AntiRagdollToggle:Set(_G.Settings.AntiRagdoll)
        ToggleAntiRagdoll(_G.Settings.AntiRagdoll)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Auto-Arrest",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyAutoArrest",
    Callback = function()
        _G.Settings.AutoArrest = not _G.Settings.AutoArrest
        AutoArrestToggle:Set(_G.Settings.AutoArrest)
        ToggleAutoArrest(_G.Settings.AutoArrest)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Instant Interact",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyII",
    Callback = function()
        _G.Settings.InstantInteract = not _G.Settings.InstantInteract
        II_Toggle:Set(_G.Settings.InstantInteract)
        ToggleInstantInteract(_G.Settings.InstantInteract)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Noclip",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyNoclip",
    Callback = function()
        _G.Settings.Noclip = not _G.Settings.Noclip
        ToggleNoclip(_G.Settings.Noclip)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Toggle Hitbox Extender",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeyHitbox",
    Callback = function()
        _G.Settings.HitboxExtender = not _G.Settings.HitboxExtender
        HitboxToggle:Set(_G.Settings.HitboxExtender)
        ToggleHitboxExtender(_G.Settings.HitboxExtender)
        SaveConfig()
    end
})

KeybindsTab:CreateKeybind({
    Name = "Save Config",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "KeySave",
    Callback = function()
        SaveConfig()
        Notify("Config", "Saved successfully!", "save", 3)
    end
})

-- =====================================================================
-- Main Loop
-- =====================================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        UpdateFOVCircle()
        UpdateFullBright()

        local aimPart = GetClosestTarget()
        if aimPart then
            if _G.Settings.AimPlayers and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPart.Position), _G.Settings.Smoothness)
            end
            if _G.Settings.SilentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPart.Position), _G.Settings.Smoothness)
            end
        end
    end)
end)

-- =====================================================================
-- Cleanup
-- =====================================================================
Players.PlayerRemoving:Connect(CleanupPlayer)

-- =====================================================================
-- Startup
-- =====================================================================
Log("DARK HUB San Aurie Loaded Successfully!")