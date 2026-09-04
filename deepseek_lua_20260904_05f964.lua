-- =============================================
-- DARK HUB | Cali Streets
-- Using Venyx UI Library
-- by @strixwashere (converted to Venyx)
-- =============================================

-- Load Venyx (pastikan library sudah di-inject)
-- Jika tidak, Anda bisa memuatnya dari sumber, misalnya:
-- local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/.../Venyx.lua"))()
-- Namun diasumsikan library global tersedia.
local library = library or error("Venyx library not found!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local setclipboard = setclipboard or toboard or writeclipboard

-- =============================================
-- GLOBAL SETTINGS
-- =============================================
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
_G.CustomAimbotActive = false
_G.AimbotFOV = 120
_G.ShowAimbotRing = false
_G.AutoFarmEnabled = false
_G.AutoFarmRunning = false

local aimbotFOV = 120
local noRecoilActive = false
local espData = {}
local selectedPlayer = nil
local autoFarmThread = nil

-- =============================================
-- HELPER FUNCTIONS
-- =============================================
local function getCharacter()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return char
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- =============================================
-- UI CREATION (Venyx)
-- =============================================
local ui = library.new("DARK HUB")

-- Pages
local mainPage = ui:addPage("Main")
local farmPage = ui:addPage("Auto Farm")
local combatPage = ui:addPage("Combat")
local visualsPage = ui:addPage("Visuals")
local socialsPage = ui:addPage("Socials")
local creditsPage = ui:addPage("Credits")
local settingsPage = ui:addPage("Settings")

-- Sections (one per page)
local mainSection = mainPage:addSection("Main Features")
local farmSection = farmPage:addSection("Auto Farm")
local combatSection = combatPage:addSection("Combat")
local visualsSection = visualsPage:addSection("Visuals")
local socialsSection = socialsPage:addSection("Socials")
local creditsSection = creditsPage:addSection("Credits")
local settingsSection = settingsPage:addSection("Settings")

-- =============================================
-- MAIN TAB
-- =============================================
mainSection:addToggle("Infinite Stamina", false, function(state)
    _G.InfiniteStaminaEnabled = state
end)

mainSection:addToggle("Auto Pickup", false, function(state)
    _G.AutoLoot = state
    if state then
        task.spawn(function()
            while _G.AutoLoot do
                pcall(function()
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if not _G.AutoLoot then break end
                        if obj:IsA("Tool") or string.find(string.lower(obj.Name), "loot") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle and handle:IsA("BasePart") then
                                local root = getRootPart()
                                if root then handle.CFrame = root.CFrame end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

mainSection:addToggle("Instant Interact", false, function(state)
    _G.InstantInteractEnabled = state
end)

mainSection:addToggle("No Jump Cooldown", false, function(state)
    _G.NoJumpCooldownEnabled = state
end)

mainSection:addToggle("Noclip", false, function(state)
    _G.NoclipEnabled = state
end)

mainSection:addToggle("Safe Speed Boost", false, function(state)
    _G.WalkSpeedEnabled = state
end)

-- =============================================
-- AUTO FARM TAB
-- =============================================
-- Auto farm logic (same as before)
local function tweenToPosition(targetPos)
    if not _G.AutoFarmEnabled then return end
    local root = getRootPart()
    if not root then return end
    local dist = (targetPos - root.Position).Magnitude
    local speed = 25
    local tweenTime = dist / speed
    root.AssemblyLinearVelocity = Vector3.new(0,0,0)
    root.AssemblyAngularVelocity = Vector3.new(0,0,0)
    local tween = TweenService:Create(root, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(targetPos)
    })
    tween:Play()
    while tweenTime > 0 do
        if not _G.AutoFarmEnabled then tween:Cancel() return end
        local root2 = getRootPart()
        if not root2 then tween:Cancel() return end
        root2.AssemblyLinearVelocity = Vector3.new(0,0,0)
        task.wait(0.05)
        tweenTime = tweenTime - 0.05
    end
    local root3 = getRootPart()
    if root3 then
        root3.CFrame = CFrame.new(targetPos)
        root3.AssemblyLinearVelocity = Vector3.new(0,0,0)
    end
end

local function interactWithPrompt(targetPos, radius)
    if not _G.AutoFarmEnabled then return false end
    radius = radius or 35
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (parent.Position - targetPos).Magnitude
                if dist < radius then
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

local function findToolInInventory(pattern)
    if not _G.AutoFarmEnabled then return false end
    local char = getCharacter()
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(pattern)) then
            return true
        end
    end
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(pattern)) then
                hum:EquipTool(tool)
                task.wait(0.4)
                return true
            end
        end
    end
    return false
end

local function autoFarmLoop()
    _G.AutoFarmRunning = true
    while _G.AutoFarmEnabled and _G.AutoFarmRunning do
        if not getCharacter() then task.wait(1) continue end
        -- Approach NPC
        tweenToPosition(Vector3.new(-337, 693, 366))
        for _ = 1, 2 do
            if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
            interactWithPrompt(Vector3.new(-337, 693, 366))
            task.wait(0.6)
        end
        if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
        -- Pick blanks
        local posList = {Vector3.new(-467, 693, 41), Vector3.new(-475, 693, 45)}
        for _, pos in ipairs(posList) do
            if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
            tweenToPosition(pos)
            findToolInInventory("blank")
            task.wait(0.4)
            interactWithPrompt(pos)
            task.wait(0.8)
        end
        if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
        for _ = 1, 17 do
            if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
            task.wait(1)
        end
        if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
        -- Activate
        tweenToPosition(Vector3.new(-319, 692, 29))
        for _ = 1, 2 do
            if not _G.AutoFarmEnabled or not _G.AutoFarmRunning then break end
            findToolInInventory("activated")
            task.wait(0.4)
            interactWithPrompt(Vector3.new(-319, 692, 29))
            task.wait(0.6)
        end
        task.wait(1)
    end
    _G.AutoFarmRunning = false
end

farmSection:addToggle("Enable Auto Farm", false, function(state)
    _G.AutoFarmEnabled = state
    if state and not _G.AutoFarmRunning then
        task.spawn(autoFarmLoop)
    elseif not state and _G.AutoFarmRunning then
        _G.AutoFarmRunning = false
    end
end)

-- Optional: floating button? We'll skip for simplicity.

-- =============================================
-- COMBAT TAB
-- =============================================
-- Aimbot ring GUI
local ringGui = Instance.new("ScreenGui")
ringGui.Name = "AimbotRing"
ringGui.Parent = CoreGui
ringGui.ResetOnSpawn = false
ringGui.Enabled = false

local ringFrame = Instance.new("Frame")
ringFrame.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
ringFrame.Position = UDim2.new(0.5, -aimbotFOV, 0.5, -aimbotFOV)
ringFrame.BackgroundTransparency = 1
ringFrame.Parent = ringGui

local ringStroke = Instance.new("UIStroke")
ringStroke.Color = Color3.fromRGB(0,170,255)
ringStroke.Thickness = 1.5
ringStroke.Transparency = 0.3
ringStroke.Parent = ringFrame

local ringCorner = Instance.new("UICorner")
ringCorner.CornerRadius = UDim.new(1,0)
ringCorner.Parent = ringFrame

-- Toggle untuk menampilkan ring
combatSection:addToggle("Show Aimbot Ring", false, function(state)
    _G.ShowAimbotRing = state
    ringGui.Enabled = state
end)

-- Toggle aimbot aktif
combatSection:addToggle("Aimbot Active", false, function(state)
    _G.CustomAimbotActive = state
end)

-- Slider FOV
combatSection:addSlider("Aimbot FOV", 120, 40, 300, function(value)
    aimbotFOV = value
    _G.AimbotFOV = value
    ringFrame.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
    ringFrame.Position = UDim2.new(0.5, -aimbotFOV, 0.5, -aimbotFOV)
end)

-- No Recoil (placeholder)
combatSection:addButton("No Recoil (Beta)", function()
    if noRecoilActive then
        library:Notify("No Recoil", "Already active!", function() end)
        return
    end
    noRecoilActive = true
    task.spawn(function()
        while noRecoilActive do
            task.wait(3)
            -- actual recoil zeroing would go here (requires getgc)
        end
    end)
    library:Notify("No Recoil", "Enabled (placeholder)", function() end)
end)

-- =============================================
-- VISUALS TAB
-- =============================================
visualsSection:addToggle("Max Zoom Out", false, function(state)
    _G.InfiniteZoomEnabled = state
    if not state then LocalPlayer.CameraMaxZoomDistance = 128 end
end)

visualsSection:addToggle("Player ESP", false, function(state)
    _G.ESPEnabled = state
end)

-- ESP logic
local function removeESP(player)
    if espData[player] then
        if espData[player].Billboard then espData[player].Billboard:Destroy() end
        if espData[player].Highlight then espData[player].Highlight:Destroy() end
        if espData[player].CharConn then espData[player].CharConn:Disconnect() end
        espData[player] = nil
    end
end

local function addESP(player)
    if player == LocalPlayer then return end
    espData[player] = {}
    local function setupESP(char)
        removeESP(player)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if not head or not hum then return end

        local bill = Instance.new("BillboardGui")
        bill.Name = "ESP_NameTag"
        bill.Adornee = head
        bill.Size = UDim2.new(0,100,0,40)
        bill.StudsOffset = Vector3.new(0,2,0)
        bill.AlwaysOnTop = true
        bill.Parent = head

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = bill
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(1,0,1,0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Text = player.DisplayName
        nameLabel.TextColor3 = Color3.fromRGB(0,255,255)
        nameLabel.TextSize = 14
        nameLabel.TextStrokeTransparency = 0.5

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(0,170,255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255,255,255)
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        espData[player].Billboard = bill
        espData[player].Highlight = highlight
        espData[player].Character = char
    end

    if player.Character then setupESP(player.Character) end
    espData[player].CharConn = player.CharacterAdded:Connect(setupESP)
end

local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.DisplayName)
        addESP(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        table.insert(playerNames, p.DisplayName)
        dropdown:UpdateValues(playerNames) -- we'll store dropdown reference
        addESP(p)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
    for i, name in ipairs(playerNames) do
        if name == p.DisplayName then table.remove(playerNames, i) break end
    end
    if dropdown then dropdown:UpdateValues(playerNames) end
end)

-- Dropdown for player selection
local dropdown = visualsSection:addDropdown("Select Player", playerNames, function(value)
    selectedPlayer = value
end)

-- Button to inspect inventory
visualsSection:addButton("Inspect Inventory", function()
    if not selectedPlayer then return end
    local target
    for _, p in ipairs(Players:GetPlayers()) do
        if p.DisplayName == selectedPlayer or p.Name == selectedPlayer then target = p break end
    end
    if not target then return end
    local inv = {}
    local char = target.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then table.insert(inv, tool.Name) end
        end
        local bp = target:FindFirstChildOfClass("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then table.insert(inv, tool.Name .. " (Equipped)") end
            end
        end
    end
    local content = #inv > 0 and table.concat(inv, ", ") or "Empty inventory."
    library:Notify(target.DisplayName .. "'s Inventory", content, function() end)
end)

-- =============================================
-- SOCIALS TAB
-- =============================================
socialsSection:addButton("Copy Discord Link", function()
    if setclipboard then setclipboard("https://discord.gg/xKvegCV6yf") end
    library:Notify("Copied!", "Discord invite copied.", function() end)
end)

socialsSection:addButton("Copy YouTube Link", function()
    if setclipboard then setclipboard("https://youtube.com/@strixwashere") end
    library:Notify("Copied!", "YouTube channel copied.", function() end)
end)

-- =============================================
-- CREDITS TAB
-- =============================================
creditsSection:addButton("Solo Developer", function()
    library:Notify("Developer", "@strixwashere", function() end)
end)
creditsSection:addButton("UI Library", function()
    library:Notify("UI", "Venyx UI Library", function() end)
end)

-- =============================================
-- SETTINGS TAB
-- =============================================
settingsSection:addButton("FPS Booster (Potato)", function()
    if _G.FPSBoostUsed then
        library:Notify("FPS Booster", "Already used!", function() end)
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
    library:Notify("FPS Booster", "Graphics optimized!", function() end)
end)

settingsSection:addButton("Unload Script", function()
    pcall(function()
        ui:Toggle() -- close UI
        ringGui:Destroy()
        -- Clean up ESP
        for player, data in pairs(espData) do
            removeESP(player)
        end
        _G.CustomAimbotActive = false
        _G.AutoFarmEnabled = false
        _G.AutoFarmRunning = false
        noRecoilActive = false
    end)
    library:Notify("Unloaded", "DARK HUB has been unloaded.", function() end)
end)

-- =============================================
-- BACKGROUND FEATURES (Heartbeat/Stepped/Render)
-- =============================================
RunService.Heartbeat:Connect(function()
    -- Infinite Zoom
    if _G.InfiniteZoomEnabled then
        LocalPlayer.CameraMaxZoomDistance = 100000
    end
    -- ESP visibility
    for _, data in pairs(espData) do
        if data.Billboard then
            data.Billboard.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChild("Humanoid")
        end
        if data.Highlight then
            data.Highlight.Enabled = _G.ESPEnabled and data.Character and data.Character:FindFirstChild("Humanoid")
        end
    end
    -- Aimbot ring visibility (if ring enabled)
    if _G.ShowAimbotRing then
        ringGui.Enabled = true
    end
end)

RunService.Stepped:Connect(function()
    local char = getCharacter()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- Noclip
    if _G.NoclipEnabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Infinite Stamina
    if _G.InfiniteStaminaEnabled then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("NumberValue") and string.find(string.lower(obj.Name), "stamina") then
                obj.Value = 100
            end
        end
        local attrs = hum:GetAttributes()
        for name, val in pairs(attrs) do
            if string.find(string.lower(name), "stamina") and typeof(val) == "number" then
                hum:SetAttribute(name, 100)
            end
        end
    end

    -- Speed boost
    if _G.WalkSpeedEnabled then
        root.CFrame = root.CFrame + hum.MoveDirection * (_G.WalkSpeedMultiplier - 1) * 0.5
    end
end)

-- No Jump Cooldown
UserInputService.JumpRequest:Connect(function()
    if _G.NoJumpCooldownEnabled then
        local char = getCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if _G.NoJumpCooldownEnabled then
        local char = getCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                end)
            end
        end
    end
end)

-- Instant Interact hook
game:GetService("ProximityPromptService").PromptTriggered:Connect(function(prompt)
    if _G.InstantInteractEnabled then
        fireproximityprompt(prompt)
    end
end)

-- Aimbot logic (RenderStepped)
RunService.RenderStepped:Connect(function()
    if not _G.CustomAimbotActive then return end
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X/2, viewport.Y/2)
    local closest = nil
    local closestDist = aimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist <= aimbotFOV then
                    -- visibility check
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    params.FilterDescendantsInstances = {LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character.Head}
                    params.IgnoreWater = true
                    local result = Workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, params)
                    local visible = not result or result.Instance:IsDescendantOf(head.Parent)
                    if visible and dist < closestDist then
                        closestDist = dist
                        closest = head
                    end
                end
            end
        end
    end
    if closest then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
    end
end)

-- =============================================
-- WATERMARK (optional, not needed with Venyx)
-- =============================================
-- Venyx already has its own title

print("DARK HUB loaded successfully.")