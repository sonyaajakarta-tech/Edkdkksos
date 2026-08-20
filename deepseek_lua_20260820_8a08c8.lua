-- // LOAD ATHER-HUB LIBRARY
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NIcoGabrielRealYtr/Ather-Hub-Library/refs/heads/main/Source"))()

-- // CREATE WINDOW
local Window = Library:Window({
    Name = '<font color="rgb(108, 221, 255)">Dark</font> hub',
    Subtitle = "South Bronx: The Trenches",
    Logo = nil -- bisa diisi jika ada
})

-- // PAGES
local CombatPage = Window:Page({
    Name = "Combat",
    Description = "Aimbot & Noclip",
    Icon = "lucide:sword",
    Search = true
})

local SettingsPage = Window:Page({
    Name = "Settings",
    Description = "UI Settings",
    Icon = "lucide:settings"
})

-- // SUBPAGES
local AimbotSub = CombatPage:SubPage({
    Name = "Aimbot",
    Icon = "lucide:target",
    DisplayName = true
})

local NoclipSub = CombatPage:SubPage({
    Name = "Noclip",
    Icon = "lucide:ghost",
    DisplayName = true
})

local WhitelistSub = CombatPage:SubPage({
    Name = "Whitelist",
    Icon = "lucide:shield",
    DisplayName = true
})

-- // SECTIONS
local MainSection = AimbotSub:Section({
    Name = "Main Settings",
    Side = 1
})

local VisualSection = AimbotSub:Section({
    Name = "Visual Settings",
    Side = 2
})

local NoclipSection = NoclipSub:Section({
    Name = "Noclip",
    Side = 1
})

local WhitelistSection = WhitelistSub:Section({
    Name = "Whitelist Management",
    Side = 1
})

local ThemeSection = SettingsPage:Section({
    Name = "Theme",
    Side = 1
})

local KeybindSection = SettingsPage:Section({
    Name = "Keybinds",
    Side = 2
})

-- // CONFIG TABLE
local CFG = {
    ENABLED = true,
    WALLBANG = false,
    FOV_RADIUS = 180,
    FOV_COLOR = Color3.fromRGB(255, 255, 255),
    FOV_THICK = 1.5,
    SHOW_FOV = true,
    SHOW_TRACER = true,
    TRACER_COLOR = Color3.fromRGB(255, 255, 255),
    TARGET_PART = "Head",
    MOBILE_Y_OFFSET = 107,
    ACCENT_COLOR = Color3.fromRGB(108, 221, 255)
}

local Whitelist = {}
local CurrentTarget = nil

-- // SILENT AIM LOGIC (dipertahankan dari script asli)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- Drawing objects
local circle = Drawing.new("Circle")
circle.Radius = CFG.FOV_RADIUS
circle.Color = CFG.FOV_COLOR
circle.Thickness = CFG.FOV_THICK
circle.Filled = false
circle.NumSides = 64
circle.Visible = CFG.SHOW_FOV

local tracer = Drawing.new("Line")
tracer.Color = CFG.TRACER_COLOR
tracer.Thickness = 1.5
tracer.Visible = false

-- Helper functions
local function getAimPosition()
    local mouseLoc = UserInputService:GetMouseLocation()
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        local viewport = Camera.ViewportSize
        return Vector2.new(viewport.X / 2, (viewport.Y / 2) - CFG.MOBILE_Y_OFFSET)
    else
        return mouseLoc
    end
end

local function toScreen(worldPos)
    local v, on = Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(v.X, v.Y), on
end

local function isAlive(char)
    local h = char and char:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function isWhitelisted(plr)
    return Whitelist[plr.Name] == true
end

local function getTarget()
    if not CFG.ENABLED then return nil end
    local mp = getAimPosition()
    local best = math.huge
    local found = nil
    local camPos = Camera.CFrame.Position

    for _, plr in Players:GetPlayers() do
        if plr == LP or isWhitelisted(plr) then continue end
        local char = plr.Character
        if not char or not isAlive(char) then continue end
        local targetPart = char:FindFirstChild(CFG.TARGET_PART)
        if not targetPart then continue end

        local sp, onScreen = toScreen(targetPart.Position)
        if not onScreen then continue end
        local screenDist = (sp - mp).Magnitude
        if screenDist < CFG.FOV_RADIUS then
            local worldDist = (camPos - targetPart.Position).Magnitude
            if worldDist < best then
                best = worldDist
                found = targetPart
            end
        end
    end
    return found
end

-- Metatable hook
local Mouse = LP:GetMouse()
local mt = getrawmetatable(Mouse)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = function(self, key)
    if CurrentTarget and CFG.ENABLED and (key == "X" or key == "Y" or key == "Hit" or key == "Target") then
        if key == "Hit" then
            return CFrame.new(CurrentTarget.Position, Camera.CFrame.Position)
        elseif key == "Target" then
            return CurrentTarget
        elseif key == "X" then
            return Camera:WorldToScreenPoint(CurrentTarget.Position).X
        elseif key == "Y" then
            return Camera:WorldToScreenPoint(CurrentTarget.Position).Y
        end
    end
    return oldIndex(self, key)
end
setreadonly(mt, true)

-- Wallbang hook
local Gc = getgc()
local function SearchGc(FunctionName)
    for i, v in pairs(Gc) do
        if type(v) == "function" then
            local info = debug.getinfo(v)
            if info.name == FunctionName then return v end
        end
    end
end

local CastBlacklist = SearchGc("CastBlacklist")
local CastWhitelist = SearchGc("CastWhitelist")

if CastBlacklist and CastWhitelist then
    local OldCastBlacklist = hookfunction(CastBlacklist, function(...)
        local args = {...}
        if CFG.WALLBANG and CFG.ENABLED and CurrentTarget and CurrentTarget.Parent and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
            local dir = CurrentTarget.Position - args[1]
            return CastWhitelist(args[1], dir.Unit * 999999, {CurrentTarget.Parent})
        end
        return OldCastBlacklist(...)
    end)
end

-- Gun mod (ACS)
local function modifyGun(tool)
    if tool:IsA("Tool") and tool:FindFirstChild("Setting") then
        local success, settings = pcall(require, tool.Setting)
        if success and type(settings) == "table" then
            settings.Range = 999999
            settings.Accuracy = 9999
            settings.SpreadX = 0
            settings.SpreadY = 0
            settings.Recoil = 10
        end
    end
end

local function setupCharacter(character)
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then modifyGun(child) end
    end
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then modifyGun(child) end
    end)
end

if LP.Character then setupCharacter(LP.Character) end
LP.CharacterAdded:Connect(setupCharacter)

-- Noclip logic (dipertahankan)
getgenv().NoclipActive = false
getgenv().OriginalPartStates = getgenv().OriginalPartStates or {}

local function restoreAllParts()
    for part, state in pairs(getgenv().OriginalPartStates) do
        if part and part.Parent then
            pcall(function()
                if part.CanCollide ~= state.CanCollide then part.CanCollide = state.CanCollide end
                if part.CanTouch ~= state.CanTouch then part.CanTouch = state.CanTouch end
            end)
        end
    end
    table.clear(getgenv().OriginalPartStates)
end

local NoclipConnection = nil
local function StartNoclip()
    if NoclipConnection then NoclipConnection:Disconnect() end
    
    local charCache, hrpCache, charParts
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local function updateCharCache()
        local charsFolder = workspace:FindFirstChild("Characters")
        local c = charsFolder and charsFolder:FindFirstChild(LP.Name) or LP.Character
        if not c then return false end
        charCache = c
        hrpCache = c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart or c:FindFirstChildWhichIsA("BasePart")
        charParts = {}
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then charParts[p] = true end
        end
        params.FilterDescendantsInstances = {c}
        return true
    end

    local function getHRP()
        if not charCache or not charCache.Parent then updateCharCache() end
        return hrpCache, charCache
    end

    local function isProtected(part, model)
        if part:FindFirstAncestorOfClass("Tool") then return true end
        if model and model:FindFirstChildOfClass("VehicleSeat", true) then return true end
        if part.Size.X > 300 or part.Size.Z > 300 then return true end
        local pName = string.lower(part.Name)
        local mName = model and string.lower(model.Name) or ""
        if string.find(pName, "baseplate") or string.find(pName, "floor") or string.find(pName, "lantai") or 
           string.find(pName, "stair") or string.find(pName, "step") or string.find(pName, "tangga") or 
           string.find(pName, "weapon") or string.find(pName, "gun") or string.find(pName, "sword") or 
           string.find(pName, "mobil") or string.find(pName, "car") or string.find(pName, "vehicle") then
            return true
        end
        if string.find(mName, "stair") or string.find(mName, "vehicle") or string.find(mName, "car") or string.find(mName, "mobil") then
            return true
        end
        return false
    end

    local function isWalkableSurface(part, feetY)
        if not feetY then return false end
        local topY = part.Position.Y + part.Size.Y/2
        if part.CFrame.UpVector.Y > 0.6 and topY <= feetY + 1 and topY >= feetY - 2.5 then
            return true
        end
        return false
    end

    local function noclipPart(part, feetY)
        if charParts and charParts[part] then return end
        if isWalkableSurface(part, feetY) then return end
        local model = part:FindFirstAncestorWhichIsA("Model")
        if isProtected(part, model) then return end
        if not getgenv().OriginalPartStates[part] then
            getgenv().OriginalPartStates[part] = {
                CanCollide = part.CanCollide,
                CanTouch = part.CanTouch
            }
        end
        if part.CanCollide then part.CanCollide = false end
        if part.CanTouch then part.CanTouch = false end
    end

    local function processTarget(part, feetY)
        local model = part:FindFirstAncestorWhichIsA("Model")
        if model and model:FindFirstChildOfClass("Humanoid") then
            for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") then noclipPart(p, feetY) end
            end
        else
            noclipPart(part, feetY)
        end
    end

    local function findSolidBelow(origin)
        local ray = workspace:Raycast(origin, Vector3.new(0, -20, 0), params)
        if ray and ray.Instance then
            local p = ray.Instance
            if p:IsA("BasePart") and not p:IsA("Terrain") and p.CFrame.UpVector.Y > 0.5 then
                return p
            end
        end
        return nil
    end

    local tickCounter = 0
    local cleanupTimer = 0

    NoclipConnection = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().NoclipActive then return end
        local hrp = getHRP()
        if not hrp then return end
        local feetY = hrp.Position.Y - 3
        local origin = hrp.Position

        tickCounter = tickCounter + 1
        if tickCounter % 3 == 0 then
            local solid = findSolidBelow(origin)
            if solid and not solid.CanCollide then
                solid.CanCollide = true
            end
        end

        for _, part in ipairs(hrp:GetTouchingParts()) do
            processTarget(part, feetY)
        end
        local look = hrp.CFrame.LookVector * 4
        local rayLook = workspace:Raycast(origin, look, params)
        if rayLook and rayLook.Instance then processTarget(rayLook.Instance, feetY) end

        cleanupTimer = cleanupTimer + dt
        if cleanupTimer >= 2 then
            cleanupTimer = 0
            local hrpPos = hrp.Position
            for part, state in pairs(getgenv().OriginalPartStates) do
                if not part or not part.Parent then
                    getgenv().OriginalPartStates[part] = nil
                else
                    if (part.Position - hrpPos).Magnitude > 60 then
                        pcall(function()
                            part.CanCollide = state.CanCollide
                            part.CanTouch = state.CanTouch
                        end)
                        getgenv().OriginalPartStates[part] = nil
                    end
                end
            end
        end
    end)
end

-- // UI ELEMENTS

-- Aimbot Toggle + Keybind
local aimbotToggle = MainSection:Toggle({
    Name = "Enable Silent Aim",
    Flag = "SilentAim",
    Default = CFG.ENABLED,
    Callback = function(Value)
        CFG.ENABLED = Value
    end
})

aimbotToggle:Keybind({
    Flag = "SilentAimKey",
    Default = Enum.KeyCode.K,
    Mode = "Toggle",
    Callback = function()
        aimbotToggle:Set(not aimbotToggle:Get())
    end
})

-- Wallbang Toggle + Keybind
local wallbangToggle = MainSection:Toggle({
    Name = "Wallbang",
    Flag = "Wallbang",
    Default = CFG.WALLBANG,
    Callback = function(Value)
        CFG.WALLBANG = Value
    end
})

wallbangToggle:Keybind({
    Flag = "WallbangKey",
    Default = Enum.KeyCode.L,
    Mode = "Toggle",
    Callback = function()
        wallbangToggle:Set(not wallbangToggle:Get())
    end
})

-- FOV Slider
MainSection:Slider({
    Name = "FOV Radius",
    Flag = "FOVRadius",
    Default = CFG.FOV_RADIUS,
    Min = 10,
    Max = 800,
    Decimals = 0,
    Suffix = "px",
    Callback = function(Value)
        CFG.FOV_RADIUS = Value
        circle.Radius = Value
    end
})

-- Show FOV Toggle
VisualSection:Toggle({
    Name = "Show FOV Circle",
    Flag = "ShowFOV",
    Default = CFG.SHOW_FOV,
    Callback = function(Value)
        CFG.SHOW_FOV = Value
        circle.Visible = Value
    end
})

-- Tracer Toggle + Colorpicker
local tracerToggle = VisualSection:Toggle({
    Name = "Show Tracer",
    Flag = "ShowTracer",
    Default = CFG.SHOW_TRACER,
    Callback = function(Value)
        CFG.SHOW_TRACER = Value
    end
})

tracerToggle:Colorpicker({
    Flag = "TracerColor",
    Default = CFG.TRACER_COLOR,
    Callback = function(Color)
        CFG.TRACER_COLOR = Color
        tracer.Color = Color
    end
})

-- Noclip Toggle + Keybind
local noclipToggle = NoclipSection:Toggle({
    Name = "Enable Noclip",
    Flag = "Noclip",
    Default = false,
    Callback = function(Value)
        getgenv().NoclipActive = Value
        if Value then
            StartNoclip()
        else
            restoreAllParts()
            if NoclipConnection then NoclipConnection:Disconnect() end
        end
    end
})

noclipToggle:Keybind({
    Flag = "NoclipKey",
    Default = Enum.KeyCode.J,
    Mode = "Toggle",
    Callback = function()
        noclipToggle:Set(not noclipToggle:Get())
    end
})

-- Whitelist Management (menggunakan GUI terpisah seperti script asli)
-- Kita buat button yang membuka popup whitelist sederhana
local whitelistOpenBtn = WhitelistSection:Button({
    Name = "Open Whitelist Manager",
    Callback = function()
        -- Buat GUI whitelist jika belum ada
        if not getgenv().WhitelistGui then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "DarkHub_Whitelist"
            ScreenGui.Parent = game:GetService("CoreGui")
            ScreenGui.ResetOnSpawn = false
            getgenv().WhitelistGui = ScreenGui

            local MainFrame = Instance.new("Frame")
            MainFrame.Size = UDim2.new(0, 360, 0, 420)
            MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
            MainFrame.BackgroundTransparency = 0
            MainFrame.Parent = ScreenGui
            MainFrame.ClipsDescendants = true
            Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", MainFrame)
            stroke.Color = CFG.ACCENT_COLOR
            stroke.Thickness = 1

            -- Header
            local header = Instance.new("Frame", MainFrame)
            header.Size = UDim2.new(1, 0, 0, 45)
            header.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
            header.BackgroundTransparency = 0
            Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

            local title = Instance.new("TextLabel", header)
            title.Text = "Whitelist"
            title.Font = Enum.Font.GothamBold
            title.TextSize = 14
            title.TextColor3 = Color3.fromRGB(240, 240, 240)
            title.BackgroundTransparency = 1
            title.Size = UDim2.new(1, -60, 1, 0)
            title.Position = UDim2.new(0, 15, 0, 0)
            title.TextXAlignment = Enum.TextXAlignment.Left

            local closeBtn = Instance.new("TextButton", header)
            closeBtn.Text = "×"
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.TextSize = 18
            closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Size = UDim2.new(0, 35, 1, 0)
            closeBtn.Position = UDim2.new(1, -38, 0, 0)
            closeBtn.MouseButton1Click:Connect(function()
                ScreenGui:Destroy()
                getgenv().WhitelistGui = nil
            end)

            -- Search box
            local searchBox = Instance.new("TextBox", MainFrame)
            searchBox.Size = UDim2.new(1, -20, 0, 30)
            searchBox.Position = UDim2.new(0, 10, 0, 52)
            searchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
            searchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
            searchBox.Font = Enum.Font.Gotham
            searchBox.TextSize = 12
            searchBox.PlaceholderText = "Search player..."
            searchBox.TextXAlignment = Enum.TextXAlignment.Left
            searchBox.ClearTextOnFocus = false
            Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", searchBox).Color = Color3.fromRGB(45, 45, 50)

            -- Scrolling frame
            local scroll = Instance.new("ScrollingFrame", MainFrame)
            scroll.Size = UDim2.new(1, -20, 1, -95)
            scroll.Position = UDim2.new(0, 10, 0, 90)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarThickness = 4
            scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
            local list = Instance.new("UIListLayout", scroll)
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Padding = UDim.new(0, 8)

            -- Populate function
            local function populate()
                for _, child in ipairs(scroll:GetChildren()) do
                    if child:IsA("Frame") or child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end
                local filter = searchBox.Text:lower()
                local count = 0
                for _, plr in Players:GetPlayers() do
                    if plr == LP then continue end
                    if filter ~= "" and not string.find(plr.Name:lower(), filter) and not string.find(plr.DisplayName:lower(), filter) then continue end
                    count = count + 1
                    local item = Instance.new("Frame", scroll)
                    item.Size = UDim2.new(1, -5, 0, 50)
                    item.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
                    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
                    Instance.new("UIStroke", item).Color = Color3.fromRGB(35, 35, 40)

                    local avatar = Instance.new("ImageLabel", item)
                    avatar.Size = UDim2.new(0, 38, 0, 38)
                    avatar.Position = UDim2.new(0, 6, 0.5, -19)
                    avatar.BackgroundTransparency = 1
                    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
                    Instance.new("UIStroke", avatar).Color = CFG.ACCENT_COLOR

                    local nameLabel = Instance.new("TextLabel", item)
                    nameLabel.Text = plr.DisplayName .. "\n@" .. plr.Name
                    nameLabel.Font = Enum.Font.Gotham
                    nameLabel.TextSize = 11
                    nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Size = UDim2.new(1, -100, 1, 0)
                    nameLabel.Position = UDim2.new(0, 52, 0, 0)
                    nameLabel.TextWrapped = true
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local toggleBtn = Instance.new("TextButton", item)
                    toggleBtn.Size = UDim2.new(0, 32, 0, 32)
                    toggleBtn.Position = UDim2.new(1, -40, 0.5, -16)
                    toggleBtn.BackgroundColor3 = Whitelist[plr.Name] and CFG.ACCENT_COLOR or Color3.fromRGB(40, 40, 45)
                    toggleBtn.TextColor3 = Whitelist[plr.Name] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                    toggleBtn.Text = Whitelist[plr.Name] and "✓" or ""
                    toggleBtn.Font = Enum.Font.GothamBold
                    toggleBtn.TextSize = 14
                    toggleBtn.AutoButtonColor = false
                    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

                    toggleBtn.MouseButton1Click:Connect(function()
                        Whitelist[plr.Name] = not Whitelist[plr.Name]
                        local state = Whitelist[plr.Name]
                        toggleBtn.Text = state and "✓" or ""
                        toggleBtn.BackgroundColor3 = state and CFG.ACCENT_COLOR or Color3.fromRGB(40, 40, 45)
                        toggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                    end)
                end
                if count == 0 then
                    local no = Instance.new("TextLabel", scroll)
                    no.Text = "No other players found."
                    no.Font = Enum.Font.Gotham
                    no.TextSize = 12
                    no.TextColor3 = Color3.fromRGB(150, 150, 150)
                    no.BackgroundTransparency = 1
                    no.Size = UDim2.new(1, 0, 0, 50)
                    no.TextXAlignment = Enum.TextXAlignment.Center
                end
            end

            searchBox:GetPropertyChangedSignal("Text"):Connect(populate)
            populate()
            -- Update when players join/leave
            Players.PlayerAdded:Connect(populate)
            Players.PlayerRemoving:Connect(populate)
        else
            getgenv().WhitelistGui.Enabled = true
        end
    end
})

-- Accent Color Picker
ThemeSection:Colorpicker({
    Name = "Accent Color",
    Flag = "AccentColor",
    Default = CFG.ACCENT_COLOR,
    Callback = function(Color)
        CFG.ACCENT_COLOR = Color
        -- Update UI stroke colors if needed
        if getgenv().WhitelistGui then
            for _, obj in ipairs(getgenv().WhitelistGui:GetDescendants()) do
                if obj:IsA("UIStroke") then
                    obj.Color = Color
                end
            end
        end
    end
})

-- Toggle UI Keybind
KeybindSection:Keybind({
    Name = "Toggle UI",
    Flag = "ToggleUI",
    Default = Enum.KeyCode.RightAlt,
    Mode = "Toggle",
    Callback = function()
        Window:ToggleUI()
    end
})

-- // MAIN LOOP (RenderStepped) untuk update target dan drawing
RunService.RenderStepped:Connect(function()
    local mp = getAimPosition()
    CurrentTarget = getTarget()

    circle.Position = mp
    circle.Visible = CFG.SHOW_FOV and CFG.ENABLED
    circle.Radius = CFG.FOV_RADIUS
    circle.Color = CFG.FOV_COLOR

    if CurrentTarget and CFG.ENABLED then
        local sp, on = toScreen(CurrentTarget.Position)
        if on then
            tracer.From = mp
            tracer.To = sp
            tracer.Visible = CFG.SHOW_TRACER
            tracer.Color = CFG.TRACER_COLOR
        else
            tracer.Visible = false
        end
    else
        tracer.Visible = false
    end
end)

-- // NOTIFIKASI AWAL
Window:Notify({
    Title = "Dark hub loaded",
    Description = "All systems ready.",
    Duration = 3
})

-- // AUTO LOAD (jika ada fitur)
Library:CheckForAutoLoad()