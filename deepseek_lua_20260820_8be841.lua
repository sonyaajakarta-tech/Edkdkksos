-- // LOADING SCREEN (dari script Dark)
do
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")

    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "tana_load_" .. HttpService:GenerateGUID(false)
    LoadingGui.IgnoreGuiInset = true
    LoadingGui.ResetOnSpawn = false
    LoadingGui.DisplayOrder = 9999
    LoadingGui.Parent = CoreGui

    local CenterContainer = Instance.new("Frame", LoadingGui)
    CenterContainer.Size = UDim2.new(0, 320, 0, 120)
    CenterContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    CenterContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    CenterContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    CenterContainer.BackgroundTransparency = 0.05

    local CCorner = Instance.new("UICorner", CenterContainer)
    CCorner.CornerRadius = UDim.new(0, 8)
    local CStroke = Instance.new("UIStroke", CenterContainer)
    CStroke.Color = Color3.fromRGB(108, 221, 255)
    CStroke.Thickness = 1

    local Title = Instance.new("TextLabel", CenterContainer)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = "Tana UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24

    local Shimmer = Instance.new("UIGradient", Title)
    Shimmer.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(108, 221, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(108, 221, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    Shimmer.Offset = Vector2.new(-1, 0)

    task.spawn(function()
        while LoadingGui.Parent do
            TweenService:Create(Shimmer, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Offset = Vector2.new(1, 0)}):Play()
            task.wait(1.5)
            Shimmer.Offset = Vector2.new(-1, 0)
        end
    end)

    local SubText = Instance.new("TextLabel", CenterContainer)
    SubText.Size = UDim2.new(1, 0, 0, 20)
    SubText.Position = UDim2.new(0, 0, 0, 60)
    SubText.BackgroundTransparency = 1
    SubText.Text = "initializing system"
    SubText.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubText.Font = Enum.Font.Gotham
    SubText.TextSize = 12

    local BarBg = Instance.new("Frame", CenterContainer)
    BarBg.Size = UDim2.new(1, -40, 0, 2)
    BarBg.Position = UDim2.new(0, 20, 0, 90)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    BarBg.BorderSizePixel = 0

    local BarFill = Instance.new("Frame", BarBg)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(108, 221, 255)
    BarFill.BorderSizePixel = 0

    local texts = {"initializing system", "bypassing restrictions", "fetching modules", "rendering interface", "finalizing setup"}
    local ti = 1
    task.spawn(function()
        while task.wait(0.5) do
            ti = ti + 1
            if ti > #texts then ti = 1 end
            TweenService:Create(SubText, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
            task.wait(0.3)
            SubText.Text = texts[ti]
            TweenService:Create(SubText, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
        end
    end)

    TweenService:Create(BarFill, TweenInfo.new(4.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(4.8)

    TweenService:Create(CenterContainer, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
    TweenService:Create(CStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    TweenService:Create(SubText, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    LoadingGui:Destroy()
end

-- // LOAD ATHER HUB LIBRARY
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NIcoGabrielRealYtr/Ather-Hub-Library/refs/heads/main/Source"))()

-- // FEATURES FROM DARK SCRIPT (Silent Aim, Noclip, Whitelist)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- Config
local CFG = {
    ENABLED = false,
    WALLBANG = false,
    FOV_RADIUS = 180,
    FOV_COLOR = Color3.fromRGB(255, 255, 255),
    TRACER_COLOR = Color3.fromRGB(255, 255, 255),
    SHOW_FOV = true,
    SHOW_TRACER = true,
    TARGET_PART = "Head",
    MOBILE_Y_OFFSET = 107
}

local Whitelist = {}
local CurrentTarget = nil

-- Drawing objects
local circle = Drawing.new("Circle")
circle.Radius = CFG.FOV_RADIUS
circle.Color = CFG.FOV_COLOR
circle.Thickness = 1.5
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
local function SearchGc(FunctionName)
    local Gc = getgc()
    for i, v in pairs(Gc) do
        if type(v) == "function" then
            local info = debug.getinfo(v)
            if info.name == FunctionName then return v end
        end
    end
end

local CastBlacklist = SearchGc("CastBlacklist")
local CastWhitelist = SearchGc("CastWhitelist")

if not CastBlacklist or not CastWhitelist then
    warn("[WARNING] Wallbang functions not found.")
else
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

-- Noclip logic
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

-- Main loop for aimbot visuals
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

-- // CREATE UI USING ATHER HUB
local Window = Library:Window({
    Name = '<font color="rgb(108, 221, 255)">Tana</font> UI',
    Logo = "rbxassetid://133425623304338" -- optional, you can change
})

-- Pages
local Combat = Window:Page({
    Name = "Combat",
    Description = "Aimbot & Noclip",
    Icon = "lucide:sword",
    Search = true
})

local Visuals = Window:Page({
    Name = "Visuals",
    Description = "FOV & Tracer",
    Icon = "lucide:eye"
})

local Settings = Window:Page({
    Name = "Settings",
    Description = "UI & Config",
    Icon = "lucide:settings"
})

-- Subpages
local AimbotSub = Combat:SubPage({
    Name = "Aimbot",
    Icon = "lucide:target",
    DisplayName = true
})

local NoclipSub = Combat:SubPage({
    Name = "Noclip",
    Icon = "lucide:ghost",
    DisplayName = true
})

-- Sections for Aimbot
local MainSection = AimbotSub:Section({
    Name = "Main Settings",
    Side = 1
})

local VisualSection = AimbotSub:Section({
    Name = "Visual Options",
    Side = 2
})

-- Toggle: Enable Aimbot
local aimbotToggle = MainSection:Toggle({
    Name = "Enable Aimbot",
    Flag = "AimbotEnabled",
    Default = false,
    Callback = function(Value)
        CFG.ENABLED = Value
    end
})

aimbotToggle:Keybind({
    Flag = "AimbotKeybind",
    Default = Enum.KeyCode.RightShift,
    Mode = "Toggle",
    Callback = function()
        CFG.ENABLED = not CFG.ENABLED
        aimbotToggle:Set(CFG.ENABLED)
    end
})

-- Toggle: Wallbang
MainSection:Toggle({
    Name = "Wallbang",
    Flag = "Wallbang",
    Default = false,
    Callback = function(Value)
        CFG.WALLBANG = Value
    end
})

-- Slider: FOV Radius
MainSection:Slider({
    Name = "FOV Radius",
    Flag = "FOVRadius",
    Default = 180,
    Min = 10,
    Max = 800,
    Decimals = 0,
    Suffix = "°",
    Callback = function(Value)
        CFG.FOV_RADIUS = Value
    end
})

-- Colorpicker: FOV Color
MainSection:Label({
    Name = "FOV Color"
}):Colorpicker({
    Flag = "FOVColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        CFG.FOV_COLOR = Color
    end
})

-- Toggle: Show FOV
MainSection:Toggle({
    Name = "Show FOV Circle",
    Flag = "ShowFOV",
    Default = true,
    Callback = function(Value)
        CFG.SHOW_FOV = Value
    end
})

-- Visual options for Tracer
VisualSection:Toggle({
    Name = "Show Tracer",
    Flag = "ShowTracer",
    Default = true,
    Callback = function(Value)
        CFG.SHOW_TRACER = Value
    end
})

VisualSection:Label({
    Name = "Tracer Color"
}):Colorpicker({
    Flag = "TracerColor",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        CFG.TRACER_COLOR = Color
    end
})

-- Noclip Subpage
local NoclipSection = NoclipSub:Section({
    Name = "Noclip Settings",
    Side = 1
})

local noclipToggle = NoclipSection:Toggle({
    Name = "Enable Noclip",
    Flag = "NoclipEnabled",
    Default = false,
    Callback = function(Value)
        getgenv().NoclipActive = Value
        if Value then
            StartNoclip()
        else
            restoreAllParts()
        end
    end
})

noclipToggle:Keybind({
    Flag = "NoclipKeybind",
    Default = Enum.KeyCode.J,
    Mode = "Toggle",
    Callback = function()
        local newState = not getgenv().NoclipActive
        noclipToggle:Set(newState)
        getgenv().NoclipActive = newState
        if newState then StartNoclip() else restoreAllParts() end
    end
})

-- Whitelist button (opens separate window)
NoclipSection:Button({
    Name = "Manage Whitelist",
    Callback = function()
        OpenWhitelistWindow()
    end
})

-- // WHITELIST WINDOW (custom GUI, similar to dark script)
local WhitelistCard = nil
local WLScale = nil
local WLContainer = nil
local WLSearchBox = nil
local WLCloseBtn = nil

local function BuildWhitelistUI()
    -- We'll create it inside the Library's ScreenGui
    local screenGui = Library:GetScreenGui() -- assume library has this method? If not, we can use CoreGui
    -- Since Ather Hub doesn't expose ScreenGui directly, we'll use CoreGui
    local parent = game:GetService("CoreGui")
    if not WhitelistCard then
        WhitelistCard = Instance.new("Frame")
        WhitelistCard.Size = UDim2.new(0, 360, 0, 420)
        WhitelistCard.Position = UDim2.new(0.5, 0, 0.5, 0)
        WhitelistCard.AnchorPoint = Vector2.new(0.5, 0.5)
        WhitelistCard.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        WhitelistCard.ClipsDescendants = true
        WhitelistCard.Visible = false
        WhitelistCard.ZIndex = 200
        WhitelistCard.Parent = parent

        local UICorner = Instance.new("UICorner", WhitelistCard)
        UICorner.CornerRadius = UDim.new(0, 10)
        local WLStroke = Instance.new("UIStroke", WhitelistCard)
        WLStroke.Color = Color3.fromRGB(108, 221, 255)
        WLStroke.Thickness = 1

        WLScale = Instance.new("UIScale", WhitelistCard)
        WLScale.Scale = 0.76

        local WLHeader = Instance.new("Frame", WhitelistCard)
        WLHeader.Size = UDim2.new(1, 0, 0, 45)
        WLHeader.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
        WLHeader.ZIndex = 201
        local hCorner = Instance.new("UICorner", WLHeader)
        hCorner.CornerRadius = UDim.new(0, 10)
        -- draggable
        local function MakeDraggable(topbar, object)
            local dragging, dragInput, dragStart, startPos
            topbar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = object.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            topbar.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
        MakeDraggable(WLHeader, WhitelistCard)

        local WLHeaderTitle = Instance.new("TextLabel", WLHeader)
        WLHeaderTitle.Size = UDim2.new(1, -60, 1, 0)
        WLHeaderTitle.Position = UDim2.new(0, 15, 0, 0)
        WLHeaderTitle.BackgroundTransparency = 1
        WLHeaderTitle.Text = "Whitelist"
        WLHeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
        WLHeaderTitle.Font = Enum.Font.GothamBold
        WLHeaderTitle.TextSize = 14
        WLHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
        WLHeaderTitle.ZIndex = 202

        WLCloseBtn = Instance.new("TextButton", WLHeader)
        WLCloseBtn.Size = UDim2.new(0, 35, 1, 0)
        WLCloseBtn.Position = UDim2.new(1, -38, 0, 0)
        WLCloseBtn.Text = "×"
        WLCloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        WLCloseBtn.Font = Enum.Font.GothamBold
        WLCloseBtn.TextSize = 18
        WLCloseBtn.BackgroundTransparency = 1
        WLCloseBtn.ZIndex = 202

        WLSearchBox = Instance.new("TextBox", WhitelistCard)
        WLSearchBox.Size = UDim2.new(1, -20, 0, 30)
        WLSearchBox.Position = UDim2.new(0, 10, 0, 52)
        WLSearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
        WLSearchBox.Font = Enum.Font.Gotham
        WLSearchBox.TextSize = 12
        WLSearchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
        WLSearchBox.PlaceholderText = "Search player..."
        WLSearchBox.TextXAlignment = Enum.TextXAlignment.Left
        WLSearchBox.ClearTextOnFocus = false
        WLSearchBox.ZIndex = 201
        local sCorner = Instance.new("UICorner", WLSearchBox)
        sCorner.CornerRadius = UDim.new(0, 6)
        local sStroke = Instance.new("UIStroke", WLSearchBox)
        sStroke.Color = Color3.fromRGB(45, 45, 50)
        sStroke.Thickness = 1

        WLContainer = Instance.new("ScrollingFrame", WhitelistCard)
        WLContainer.Size = UDim2.new(1, -20, 1, -95)
        WLContainer.Position = UDim2.new(0, 10, 0, 90)
        WLContainer.BackgroundTransparency = 1
        WLContainer.ScrollBarThickness = 4
        WLContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
        WLContainer.ZIndex = 201
        WLContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        WLContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local layout = Instance.new("UIListLayout", WLContainer)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)

        WLCloseBtn.MouseButton1Click:Connect(function()
            WhitelistCard.Visible = false
        end)

        WLSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            PopulateWhitelist()
        end)
    end
end

local function PopulateWhitelist()
    if not WLContainer then return end
    for _, child in ipairs(WLContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local filterText = WLSearchBox.Text:lower()
    local playerCount = 0

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        if filterText ~= "" and not string.find(plr.Name:lower(), filterText) and not string.find(plr.DisplayName:lower(), filterText) then continue end

        playerCount = playerCount + 1
        local isWL = Whitelist[plr.Name] or false
        local ItemFrame = Instance.new("Frame", WLContainer)
        ItemFrame.Size = UDim2.new(1, -5, 0, 50)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
        ItemFrame.ZIndex = 202
        local iCorner = Instance.new("UICorner", ItemFrame)
        iCorner.CornerRadius = UDim.new(0, 6)
        local iStroke = Instance.new("UIStroke", ItemFrame)
        iStroke.Color = Color3.fromRGB(35, 35, 40)
        iStroke.Thickness = 1

        local AvatarImg = Instance.new("ImageLabel", ItemFrame)
        AvatarImg.Size = UDim2.new(0, 38, 0, 38)
        AvatarImg.Position = UDim2.new(0, 6, 0.5, -19)
        AvatarImg.BackgroundTransparency = 1
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
        AvatarImg.ZIndex = 203
        local avCorner = Instance.new("UICorner", AvatarImg)
        avCorner.CornerRadius = UDim.new(1, 0)
        local avStroke = Instance.new("UIStroke", AvatarImg)
        avStroke.Color = Color3.fromRGB(108, 221, 255)
        avStroke.Thickness = 1

        local NameLabel = Instance.new("TextLabel", ItemFrame)
        NameLabel.Size = UDim2.new(1, -100, 1, 0)
        NameLabel.Position = UDim2.new(0, 52, 0, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = plr.DisplayName .. "\n@" .. plr.Name
        NameLabel.Font = Enum.Font.Gotham
        NameLabel.TextSize = 11
        NameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.TextWrapped = true
        NameLabel.ZIndex = 203

        local ToggleBtn = Instance.new("TextButton", ItemFrame)
        ToggleBtn.Size = UDim2.new(0, 32, 0, 32)
        ToggleBtn.Position = UDim2.new(1, -40, 0.5, -16)
        ToggleBtn.Text = isWL and "✓" or ""
        ToggleBtn.TextColor3 = isWL and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        ToggleBtn.Font = Enum.Font.GothamBold
        ToggleBtn.TextSize = 14
        ToggleBtn.BackgroundColor3 = isWL and Color3.fromRGB(108, 221, 255) or Color3.fromRGB(40, 40, 45)
        ToggleBtn.AutoButtonColor = false
        ToggleBtn.ZIndex = 204
        local tCorner = Instance.new("UICorner", ToggleBtn)
        tCorner.CornerRadius = UDim.new(0, 6)

        -- Add bounce effect
        local function AddBounce(button)
            local scale = Instance.new("UIScale", button)
            scale.Scale = 1
            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Scale = 0.96}):Play()
                end
            end)
            button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Scale = 1}):Play()
                end
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Scale = 1}):Play()
            end)
        end
        AddBounce(ToggleBtn)

        ToggleBtn.MouseButton1Click:Connect(function()
            Whitelist[plr.Name] = not Whitelist[plr.Name]
            local state = Whitelist[plr.Name]
            ToggleBtn.Text = state and "✓" or ""
            ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(108, 221, 255) or Color3.fromRGB(40, 40, 45)
            ToggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        end)
    end
    
    if playerCount == 0 then
        local empty = Instance.new("TextLabel", WLContainer)
        empty.Size = UDim2.new(1, 0, 0, 50)
        empty.BackgroundTransparency = 1
        empty.Text = "No other players found."
        empty.TextColor3 = Color3.fromRGB(150, 150, 150)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.TextXAlignment = Enum.TextXAlignment.Center
        empty.ZIndex = 202
    end
end

function OpenWhitelistWindow()
    if not WhitelistCard then BuildWhitelistUI() end
    PopulateWhitelist()
    WhitelistCard.Visible = true
    WLScale.Scale = 0.76
    WLScale:TweenScale(0.76) -- if needed
end

-- Also open on button from Noclip section (already done)

-- // SETTINGS PAGE
local SettingsPage = Window:CreateSettingsPage()
SettingsPage:CreateConfigsSection()  -- Save/load configs
SettingsPage:CreateThemingSection()   -- Theme color pickers

-- Add UI toggle keybind (global)
SettingsPage:Keybind({
    Name = "Toggle UI",
    Flag = "ToggleUI",
    Default = Enum.KeyCode.RightAlt,
    Mode = "Toggle",
    Callback = function()
        Window:Toggle()
    end
})

-- Notify on load
Window:Notify({
    Title = "Tana UI",
    Description = "Loaded successfully!",
    Duration = 3
})

-- Auto-load configs if any
Library:CheckForAutoLoad()