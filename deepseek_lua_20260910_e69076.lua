-- ================================================================
-- DARK HUB V3.0 — OBSIDIAN UI EDITION
-- TikTok: @drakhub | Discord: discord.gg/AbHhEACZC
-- ================================================================

-- ══════════════════════════════════════════════════════════════
-- OBSIDIAN UI SETUP
-- ══════════════════════════════════════════════════════════════
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "DARK HUB",
    Footer = "version: V3.0 | @drakhub",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main    = Window:AddTab("Main", "user"),
    Visual  = Window:AddTab("Visual", "eye"),
    Aim     = Window:AddTab("Aim", "crosshair"),
    Farm    = Window:AddTab("Farm", "wheat"),
    TP      = Window:AddTab("TP", "map-pin"),
    Vehicle = Window:AddTab("Vehicle", "car"),
    Info    = Window:AddTab("Info", "info"),
    Config  = Window:AddTab("Config", "settings"),
}

-- ══════════════════════════════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local Http         = game:GetService("HttpService")
local RS           = game:GetService("ReplicatedStorage")
local plr          = game.Players.LocalPlayer
local VirtualUser  = game:GetService("VirtualUser")

-- ══════════════════════════════════════════════════════════════
-- GLOBAL FLAGS
-- ══════════════════════════════════════════════════════════════
local Flags = {
    BoxESP=false, Tracer=false,
    ESPName=true, ESPDist=true, ESPHPBar=true, ESPWeapon=true, ESPSkeleton=false, ESPMasak=true,
    TPNoClip=false, AimLock=false,
    WallCheck=false,
    InvScan=false, InstantInteract=false,
    AutoCook=false, InfStamina=false,
    HybridSpeed=false,
    AuraKill=false,
}

local AimFOV_Radius   = 120
local SilentFOV_Radius= 120
local AimMax_Dist     = 300
local TracerMaxDist   = 300
local ESPMaxDist      = 500
local AimSmooth       = 0.85
local AimTarget       = nil
local AimPart         = "Head"
local AimMode         = "PC"
local BoxESPMode      = "FULL"
local AimWhitelist    = {}
local BlinkMode       = "PC"
local SilentAim       = false
local SilentAimWallbang = false
local ShowAimFOV      = true
local ShowSilentFOV   = true
local SilentMode      = "PC"

local AutoBuySettings = { Enabled = false, Amount = 10, Mode = "PACK" }
_G.DARKHUB_AUTOBUY = AutoBuySettings

-- ══════════════════════════════════════════════════════════════
-- NOTIFICATION POPUP
-- ══════════════════════════════════════════════════════════════
task.spawn(function()
    Library:Notify({
        Title = "DARK HUB V3.0",
        Description = "TikTok: @drakhub\nDiscord: discord.gg/AbHhEACZC",
        Time = 6,
    })
end)

-- ══════════════════════════════════════════════════════════════
-- TP OVERLAY — "WAIT" ANIMATION
-- ══════════════════════════════════════════════════════════════
local TPOverlay = Instance.new("ScreenGui")
TPOverlay.Name = "DARKHUB_TPOverlay"
TPOverlay.ResetOnSpawn = false
TPOverlay.DisplayOrder = 5
TPOverlay.IgnoreGuiInset = true
TPOverlay.Enabled = false
TPOverlay.Parent = CoreGui

local OvBG = Instance.new("Frame", TPOverlay)
OvBG.Size = UDim2.new(1, 0, 1, 0)
OvBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OvBG.BackgroundTransparency = 1
OvBG.BorderSizePixel = 0
OvBG.ZIndex = 9999

local ovCenter = Instance.new("Frame", OvBG)
ovCenter.Size = UDim2.new(0, 400, 0, 160)
ovCenter.AnchorPoint = Vector2.new(0.5, 0.5)
ovCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
ovCenter.BackgroundTransparency = 1
ovCenter.ZIndex = 10000

local ovTitle = Instance.new("TextLabel", ovCenter)
ovTitle.Size = UDim2.new(1, 0, 0, 80)
ovTitle.Position = UDim2.new(0, 0, 0, 0)
ovTitle.BackgroundTransparency = 1
ovTitle.Text = "WAIT"
ovTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ovTitle.Font = Enum.Font.GothamBlack
ovTitle.TextSize = 72
ovTitle.ZIndex = 10001
local ovTitleStroke = Instance.new("UIStroke", ovTitle)
ovTitleStroke.Color = Color3.fromRGB(0, 220, 80)
ovTitleStroke.Thickness = 3

local ovLabel = Instance.new("TextLabel", ovCenter)
ovLabel.Size = UDim2.new(1, 0, 0, 20)
ovLabel.Position = UDim2.new(0, 0, 0, 90)
ovLabel.BackgroundTransparency = 1
ovLabel.Text = "Teleporting, please wait..."
ovLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
ovLabel.Font = Enum.Font.Gotham
ovLabel.TextSize = 14
ovLabel.ZIndex = 10001

local ovDest = Instance.new("TextLabel", ovCenter)
ovDest.Size = UDim2.new(1, 0, 0, 20)
ovDest.Position = UDim2.new(0, 0, 0, 115)
ovDest.BackgroundTransparency = 1
ovDest.Text = ""
ovDest.TextColor3 = Color3.fromRGB(0, 220, 80)
ovDest.Font = Enum.Font.GothamBlack
ovDest.TextSize = 15
ovDest.ZIndex = 10001

-- Animasi dots
task.spawn(function()
    while true do
        if TPOverlay.Enabled then
            for i = 1, 4 do
                if not TPOverlay.Enabled then break end
                ovTitle.Text = "WAIT" .. string.rep(".", i)
                task.wait(0.28)
            end
        else
            task.wait(0.3)
        end
    end
end)

local _overlayActive = false
local function showTPOverlay(destName)
    _overlayActive = true
    ovDest.Text = destName or ""
    OvBG.BackgroundTransparency = 0
    TPOverlay.Enabled = true
end
local function hideTPOverlay()
    TPOverlay.Enabled = false
    OvBG.BackgroundTransparency = 1
    _overlayActive = false
end
_G.DARKHUB_ISOVERLAY = function() return _overlayActive end

-- ══════════════════════════════════════════════════════════════
-- ESP SYSTEM
-- ══════════════════════════════════════════════════════════════
local ESP = {}

local FovCircle = Drawing.new("Circle")
FovCircle.Thickness=1.5; FovCircle.Color=Color3.fromRGB(210,210,210)
FovCircle.Filled=false; FovCircle.NumSides=64; FovCircle.Visible=false

local SilentFovCircle = Drawing.new("Circle")
SilentFovCircle.Thickness=1.5; SilentFovCircle.Color=Color3.fromRGB(255,100,0)
SilentFovCircle.Filled=false; SilentFovCircle.NumSides=64; SilentFovCircle.Visible=false

local SilentLine = Drawing.new("Line")
SilentLine.Thickness=1.5; SilentLine.Color=Color3.fromRGB(255,100,0)
SilentLine.Visible=false

local function _mkLine(thick, col)
    local d = Drawing.new("Line")
    d.Thickness=thick; d.Color=col; d.Visible=false
    return d
end
local function _mkText(sz, col)
    local d = Drawing.new("Text")
    d.Size=sz; d.Color=col; d.Outline=true
    d.OutlineColor=Color3.fromRGB(0,0,0)
    d.Center=true; d.Font=Drawing.Fonts.Plex; d.Visible=false
    return d
end
local function _hideESP(e)
    e.box.Visible=false; e.hpbg.Visible=false; e.hpbar.Visible=false
    e.hpnum.Visible=false; e.dispname.Visible=false; e.username.Visible=false
    e.dist.Visible=false; e.weapon.Visible=false; e.masak.Visible=false; e.tracer.Visible=false
    for _, c in ipairs(e.corners) do c.Visible=false end
    for _, s in ipairs(e.skeleton) do s.Visible=false end
end

local function createESP(p)
    if ESP[p] or p == plr then return end
    local _c = {}
    for ci = 1, 8 do
        local cl = Drawing.new("Line")
        cl.Thickness=2; cl.Color=Color3.fromRGB(255,255,255); cl.Visible=false
        _c[ci] = cl
    end
    local _sk = {}
    for si = 1, 15 do
        local sl = Drawing.new("Line")
        sl.Thickness=1.2; sl.Color=Color3.fromRGB(255,255,255); sl.Visible=false
        _sk[si] = sl
    end
    local e = {
        box=Drawing.new("Square"),
        hpbg=Drawing.new("Square"),
        hpbar=Drawing.new("Square"),
        hpnum=_mkText(10, Color3.fromRGB(255,255,255)),
        dispname=_mkText(13, Color3.fromRGB(255,255,255)),
        username=_mkText(11, Color3.fromRGB(200,200,200)),
        dist=_mkText(11, Color3.fromRGB(180,180,180)),
        weapon=_mkText(11, Color3.fromRGB(255,220,80)),
        tracer=_mkLine(1.2, Color3.fromRGB(255,255,255)),
        masak=_mkText(13, Color3.fromRGB(0,255,80)),
        corners=_c,
        skeleton=_sk,
    }
    e.box.Thickness=1.5; e.box.Filled=false
    e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
    e.hpbar.Thickness=1; e.hpbar.Filled=true
    ESP[p] = e
end

local function removeESP(p)
    if not ESP[p] then return end
    local _e = ESP[p]
    if _e.corners then for _, c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
    if _e.skeleton then for _, s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
    for k, d in pairs(_e) do
        if k ~= "corners" and k ~= "skeleton" then pcall(function() d:Remove() end) end
    end
    ESP[p] = nil
end

-- ESP Cache event-driven
local ESP_MASAK_KW = {"water","sugar","gelatin","marshmallow"}
local ESP_GUN_KW   = {"gun","pistol","rifle","ak","m4","uzi","revolver","shotgun","sniper","smg","weapon","knife","sword","blade"}
local espCache = {}
local espConns = {}

local function isKW(name)
    local n = name:lower()
    for _, kw in ipairs(ESP_MASAK_KW) do if n:find(kw) then return true end end
    return false
end

local function rebuildCache(p)
    if not p or not p.Parent then return end
    local hb, wn = false, nil
    pcall(function()
        local bp = p.Backpack
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") and isKW(v.Name) then hb = true end
            end
        end
        local ch = p.Character
        if ch then
            for _, v in ipairs(ch:GetChildren()) do
                if v:IsA("Tool") then
                    if isKW(v.Name) then hb = true else wn = v.Name end
                end
            end
        end
    end)
    espCache[p] = {hasBahan=hb, wName=wn}
end

local function connectESPPlayer(p)
    if p == plr then return end
    if espConns[p] then return end
    local conns = {}
    espConns[p] = conns
    rebuildCache(p)
    local bp = p.Backpack
    if bp then
        table.insert(conns, bp.ChildAdded:Connect(function() rebuildCache(p) end))
        table.insert(conns, bp.ChildRemoved:Connect(function() rebuildCache(p) end))
    end
    local function watchChar(ch)
        if not ch then return end
        table.insert(conns, ch.ChildAdded:Connect(function(v) if v:IsA("Tool") then rebuildCache(p) end end))
        table.insert(conns, ch.ChildRemoved:Connect(function(v) if v:IsA("Tool") then rebuildCache(p) end end))
        rebuildCache(p)
    end
    if p.Character then watchChar(p.Character) end
    table.insert(conns, p.CharacterAdded:Connect(function(ch) task.wait(0.1) watchChar(ch) end))
end

local function disconnectESPPlayer(p)
    local conns = espConns[p]
    if conns then
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        espConns[p] = nil
    end
    espCache[p] = nil
end

for _, p in pairs(game.Players:GetPlayers()) do
    createESP(p); connectESPPlayer(p)
end
game.Players.PlayerAdded:Connect(function(p) createESP(p); connectESPPlayer(p) end)
game.Players.PlayerRemoving:Connect(function(p) removeESP(p); disconnectESPPlayer(p) end)

-- ══════════════════════════════════════════════════════════════
-- HELPER FUNCTIONS
-- ══════════════════════════════════════════════════════════════
local function doVehicleTP(targetCFrame)
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat then return false end
    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return false end
    local vRoot = vehicle.PrimaryPart or seat
    vRoot.AssemblyLinearVelocity = Vector3.zero
    vRoot.AssemblyAngularVelocity = Vector3.zero
    vehicle:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
    task.wait(0.1)
    vRoot.AssemblyLinearVelocity = Vector3.zero
    vRoot.AssemblyAngularVelocity = Vector3.zero
    return true
end

local function resetHumanoid()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then
        hum.Sit = false
        task.wait(0.05)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        task.wait(0.1)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

local UNDERGROUND_Y = -4.00
local TP_SPEED = 16
local tpActive = false
local tpCancelled = false
local tpBusy = false

local function moveCharTo(targetPos)
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local offset = targetPos - hrp.Position
    for _, p in pairs(ch:GetDescendants()) do
        if p:IsA("BasePart") and p ~= hrp then
            pcall(function() p.CFrame = p.CFrame + offset end)
        end
    end
    hrp.CFrame = CFrame.new(targetPos) * (hrp.CFrame - hrp.CFrame.Position)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function lerpChar(fromPos, toPos, speed)
    local dist = (toPos - fromPos).Magnitude
    if dist < 0.05 then return true end
    local travelT = dist / speed
    local elapsed = 0
    while elapsed < travelT and not tpCancelled do
        local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp2 then return false end
        local t = math.clamp(elapsed / travelT, 0, 1)
        moveCharTo(fromPos:Lerp(toPos, t))
        local _, dt = RunService.Stepped:Wait()
        elapsed = elapsed + dt
    end
    if not tpCancelled then moveCharTo(toPos) end
    return not tpCancelled
end

local function tpToPos(cx, cy, cz, _unused, destName)
    if tpActive then return end
    tpActive = true
    tpCancelled = false

    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then tpActive=false return end

    showTPOverlay(destName or "Destination")

    local underPos = Vector3.new(hrp.Position.X, UNDERGROUND_Y, hrp.Position.Z)
    local ok = lerpChar(hrp.Position, underPos, TP_SPEED)

    if ok and not tpCancelled then
        local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp2 then
            local slideTarget = Vector3.new(cx, UNDERGROUND_Y, cz)
            ok = lerpChar(hrp2.Position, slideTarget, TP_SPEED)
        else ok = false end
    end

    if ok and not tpCancelled then
        local hrp3 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp3 then
            local riseTarget = Vector3.new(cx, cy + 3, cz)
            ok = lerpChar(hrp3.Position, riseTarget, TP_SPEED)
        end
    end

    hideTPOverlay()
    resetHumanoid()
    tpActive = false
end

-- Direct CFrame TP (buat apartemen)
local function directTP(cx, cy, cz, destName)
    task.spawn(function()
        local ch = plr.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        showTPOverlay(destName or "Destination")
        task.wait(0.2)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(cx, cy + 3, cz)
        task.wait(0.3)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = CFrame.new(cx, cy + 3, cz)
        task.wait(0.3)
        hideTPOverlay()
    end)
end

-- Suicide TP (Kill TP)
local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)
local function doSuicideTP(loc)
    tpBusy = true
    task.spawn(function()
        showTPOverlay(loc.name)
        local ch = plr.Character
        local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp0 then tpBusy=false; hideTPOverlay(); return end
        hrp0.CFrame = CFrame.new(RESPAWN_WARP)

        local newChar = plr.CharacterAdded:Wait()
        local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
        local hum = newChar:WaitForChild("Humanoid", 10)
        if not hrp or not hum then tpBusy=false; hideTPOverlay(); return end

        local waited = 0
        while hum.Health <= 0 and waited < 5 do
            task.wait(0.1)
            waited += 0.1
        end
        task.wait(0.8)

        ovDest.Text = loc.name or ""
        local targetCF = CFrame.new(loc.x, loc.y + 3, loc.z)
        for _ = 1, 4 do
            hrp.CFrame = targetCF
            task.wait(0.15)
        end
        task.wait(0.1)
        hideTPOverlay()
        tpBusy = false
    end)
end

-- ══════════════════════════════════════════════════════════════
-- SETTINGS SAVE/LOAD
-- ══════════════════════════════════════════════════════════════
local SAVEFILE = "darkhub_settings.json"
local function saveSettings()
    pcall(function()
        writefile(SAVEFILE, Http:JSONEncode({
            Flags = Flags,
            AimFOV_Radius = AimFOV_Radius,
            AimMax_Dist = AimMax_Dist,
            TracerMaxDist = TracerMaxDist,
            ESPMaxDist = ESPMaxDist,
            AimSmooth = AimSmooth,
            AimPart = AimPart,
            AimMode = AimMode,
            BoxESPMode = BoxESPMode,
            BlinkMode = BlinkMode,
        }))
    end)
end
local function loadSettings()
    pcall(function()
        if isfile and isfile(SAVEFILE) then
            local d = Http:JSONDecode(readfile(SAVEFILE))
            if d.Flags then for k,v in pairs(d.Flags) do if Flags[k] ~= nil then Flags[k]=v end end end
            if d.AimFOV_Radius then AimFOV_Radius=d.AimFOV_Radius end
            if d.AimMax_Dist then AimMax_Dist=d.AimMax_Dist end
            if d.TracerMaxDist then TracerMaxDist=d.TracerMaxDist end
            if d.ESPMaxDist then ESPMaxDist=d.ESPMaxDist end
            if d.AimSmooth then AimSmooth=d.AimSmooth end
            if d.AimPart then AimPart=d.AimPart end
            if d.AimMode then AimMode=d.AimMode end
            if d.BoxESPMode then BoxESPMode=d.BoxESPMode end
            if d.BlinkMode then BlinkMode=d.BlinkMode end
        end
    end)
end
loadSettings()

-- ══════════════════════════════════════════════════════════════
-- TABLES: TP_CATEGORIES
-- ══════════════════════════════════════════════════════════════
local TP_CATEGORIES = {
    { name = "ATM", locs = {
        {name="ATM 1", x=-651.92, y=3.73, z=156.71},
        {name="ATM 2", x=-378.48, y=3.72, z=-360.00},
        {name="ATM 3", x=-265.71, y=3.85, z=-212.04},
        {name="ATM 4", x=-536.51, y=3.73, z=-20.06},
        {name="ATM 5", x=-33.15, y=3.72, z=-300.05},
        {name="ATM 6", x=525.03, y=-7.77, z=-96.41},
        {name="ATM 7", x=-10.79, y=3.73, z=234.15},
        {name="ATM 8", x=-455.03, y=3.73, z=370.77},
        {name="ATM 9", x=236.67, y=3.72, z=-163.25},
        {name="ATM 10", x=538.89, y=3.73, z=-349.09},
        {name="ATM 11", x=360.74, y=3.72, z=-359.25},
        {name="ATM 12", x=701.47, y=3.73, z=-241.29},
        {name="ATM 13", x=875.01, y=3.36, z=-346.32},
        {name="ATM 14", x=894.71, y=3.73, z=145.68},
        {name="ATM 15", x=716.74, y=3.81, z=413.77},
        {name="ATM 16", x=497.89, y=3.78, z=405.70},
        {name="ATM 17", x=1016.72, y=3.36, z=-229.20},
        {name="ATM 18", x=1054.08, y=3.72, z=589.36},
        {name="ATM 19", x=1097.58, y=3.36, z=178.35},
    }},
    { name = "Homeless", locs = {
        {name="Homeless 1", x=-315.35, y=3.72, z=-361.56},
        {name="Homeless 2", x=-273.52, y=3.85, z=-211.32},
        {name="Homeless 3", x=1102.42, y=3.36, z=527.05},
        {name="Homeless 4", x=52.89, y=3.72, z=-425.36},
        {name="Homeless 5", x=152.88, y=3.73, z=-210.08},
        {name="Homeless 6", x=-522.75, y=-7.86, z=-165.08},
        {name="Homeless 7", x=65.12, y=3.73, z=68.10},
        {name="Homeless 8", x=26.04, y=3.73, z=217.89},
        {name="Homeless 9", x=520.08, y=3.87, z=-295.52},
        {name="Homeless 10", x=699.28, y=3.72, z=-427.05},
        {name="Homeless 11", x=900.03, y=3.94, z=-283.12},
        {name="Homeless 12", x=874.89, y=3.73, z=-63.02},
    }},
    { name = "Apartment", locs = {
        {name="Apt 1 — Main", x=1142.93, y=10.10, z=453.42},
        {name="Apt 2 — Main", x=1142.9, y=10.10, z=424.9},
        {name="Apt 3 — Mid", x=984.06, y=10.10, z=245.47},
        {name="Apt 4 — Mid", x=984.02, y=10.10, z=216.83},
        {name="Apt 5 — West", x=928.82, y=10.10, z=38.43},
        {name="Apt 6 — West", x=900.62, y=10.10, z=38.39},
        {name="Apt 7 — Casino", x=1180.46, y=3.71, z=-193.92},
        {name="Apt 8 — Casino", x=1202.21, y=3.71, z=-189.78},
        {name="Apt 9 — Casino", x=1180.47, y=3.71, z=-222.41},
        {name="Apt 10 — Casino", x=1202.08, y=3.71, z=-222.91},
    }},
    { name = "Others", locs = {
        {name="Bag Store", x=992.77, y=3.78, z=422.53},
        {name="Bank", x=-48.64, y=3.73, z=-320.46},
        {name="Binary Store", x=-281.06, y=3.74, z=251.23},
        {name="Boutique Store", x=992.60, y=3.78, z=453.07},
        {name="Box Job", x=-578.48, y=3.53, z=-74.82},
        {name="Buy Marshmellow", x=510.38, y=3.59, z=603.50},
        {name="Cap Store", x=-270.15, y=3.88, z=-331.36},
        {name="Casino", x=1152.53, y=20.32, z=-26.31},
        {name="Chips Cook", x=-487.11, y=3.86, z=-454.16},
        {name="Chips Store", x=-773.72, y=3.66, z=-187.54},
        {name="Chips Tukar", x=-34.91, y=4.56, z=-24.15},
        {name="Clothes Store 1", x=-202.62, y=3.48, z=-58.82},
        {name="Clothes Store 2", x=-747.62, y=3.76, z=571.96},
        {name="Dealer", x=730.24, y=3.7, z=449.47},
        {name="Deli Grocery", x=-364.30, y=3.61, z=-325.87},
        {name="Fake Card", x=216.28, y=3.73, z=-331.79},
        {name="Food Corp", x=365.69, y=3.48, z=-349.23},
        {name="Glasses Store", x=-697.77, y=4.21, z=-336.85},
        {name="Gun Sell", x=75.09, y=3.76, z=26.53},
        {name="Gun Store 1", x=215.77, y=3.73, z=-179.89},
        {name="Gun Store 2", x=-468.37, y=3.86, z=349.56},
        {name="Gun Tier", x=1114.80, y=3.78, z=167.36},
        {name="Haircut", x=52.73, y=3.73, z=-71.39},
        {name="Jewerely Store", x=-75.48, y=4.29, z=-176.28},
        {name="Shoes Store", x=524.48, y=3.75, z=-196.93},
        {name="Store 1", x=904.05, y=3.53, z=-87.44},
        {name="Store 2", x=530.13, y=3.46, z=430.07},
        {name="Tattoo Shop", x=951.72, y=3.83, z=-72.93},
        {name="The Deli 2", x=-662.23, y=3.98, z=159.33},
    }},
}

-- APARTMENTS (untuk Auto Cook + Full Auto Farm)
local APARTMENTS = {
    {name="Farm — Apt 1 Main", x=1142.93, y=10.10, z=453.42, lx=1144.22, ly=4.81, lz=443.35, rx=1145.58, ry=4.81, rz=453.44, side="L"},
    {name="Farm — Apt 2 Main", x=1142.9, y=10.10, z=424.90, lx=1145.47, ly=3.36, lz=421.24, rx=1145.58, ry=4.81, rz=425.46, side="L"},
    {name="Farm — Apt 3 Mid", x=984.06, y=10.10, z=245.47, lx=980.83, ly=3.36, lz=249.26, rx=981.39, ry=4.81, rz=244.9, side="L"},
    {name="Farm — Apt 4 Mid", x=984.02, y=10.10, z=216.83, lx=981.20, ly=3.36, lz=220.62, rx=981.97, ry=4.81, rz=219.16, side="L"},
    {name="Farm — Apt 5 West", x=928.82, y=10.10, z=38.43, lx=924.15, ly=3.36, lz=36.13, rx=928.6, ry=3.36, rz=35.91, side="L"},
    {name="Farm — Apt 6 West", x=900.62, y=10.10, z=38.39, lx=893.63, ly=3.36, lz=36.9, rx=900.79, ry=3.36, rz=37.24, side="L"},
    {name="Farm — Apt 7 Casino", x=1180.46, y=3.71, z=-193.92, lx=1182.30, ly=7.45, lz=-191.07, rx=1182.42, ry=7.56, rz=-188.66, side="L", topLx=1182.51, topLy=15.96, topLz=-191.75, topRx=1182.54, topRy=15.96, topRz=-188.08},
    {name="Farm — Apt 8 Casino", x=1202.21, y=3.71, z=-189.78, lx=1200.61, ly=7.80, lz=-179.03, rx=1200.42, ry=7.80, rz=-180.42, side="L", topLx=1200.27, topLy=15.96, topLz=-178.01, topRx=1200.29, topRy=15.96, topRz=-181.31},
    {name="Farm — Apt 9 Casino", x=1180.47, y=3.71, z=-222.41, lx=1182.72, ly=7.56, lz=-229.21, rx=1182.84, ry=7.56, rz=-226.89, side="L", topLx=1182.76, topLy=15.96, topLz=-229.35, topRx=1182.65, topRy=15.96, topRz=-227.35},
    {name="Farm — Apt 10 Casino", x=1202.08, y=3.71, z=-222.91, lx=1200.68, ly=7.53, lz=-217.65, rx=1200.72, ry=7.53, rz=-219.78, side="L", topLx=1200.00, topLy=15.96, topLz=-217.06, topRx=1199.99, topRy=15.96, topRz=-220.03},
}
for _, a in ipairs(APARTMENTS) do
    a.cx = a.lx or a.x
    a.cy = a.ly or a.y
    a.cz = a.lz or a.z
    a.topCx = a.topLx
    a.topCy = a.topLy
    a.topCz = a.topLz
end

local selectedApart = nil

-- ══════════════════════════════════════════════════════════════
-- TAB: MAIN
-- ══════════════════════════════════════════════════════════════
local MainGroup  = Tabs.Main:AddLeftGroupbox("Main Features")
local MainGroupR = Tabs.Main:AddRightGroupbox("Misc")

MainGroup:AddToggle("InstantInteract", {
    Text = "Instant Interact", Default = false,
    Tooltip = "ProximityPrompt instant",
    Callback = function(v) Flags.InstantInteract = v end,
})
MainGroup:AddToggle("InvScan", {
    Text = "Inv Scan", Default = false,
    Tooltip = "Lihat inventory player di atas kepala",
    Callback = function(v) Flags.InvScan = v end,
})
MainGroup:AddToggle("TPNoClip", {
    Text = "Blink TP (T key)", Default = false,
    Tooltip = "Tekan T untuk TP 6 studs ke depan",
    Callback = function(v) Flags.TPNoClip = v end,
})
MainGroup:AddToggle("InfStamina", {
    Text = "Inf Stamina", Default = false,
    Callback = function(v) Flags.InfStamina = v end,
})
MainGroup:AddToggle("HybridSpeed", {
    Text = "Speed Hack", Default = false,
    Callback = function(v) Flags.HybridSpeed = v end,
})
MainGroup:AddToggle("AuraKill", {
    Text = "NoClip", Default = false,
    Tooltip = "Tembus dinding",
    Callback = function(v) Flags.AuraKill = v end,
})

MainGroupR:AddDropdown("BlinkMode", {
    Values = {"PC", "HP"}, Default = "PC",
    Text = "Blink Mode",
    Callback = function(v) BlinkMode = v end,
})

MainGroupR:AddButton({
    Text = "Reduce Grafik (Rejoin to restore)",
    DoubleClick = true,
    Func = function()
        task.spawn(function()
            local Lighting = game:GetService("Lighting")
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then pcall(function() v:Destroy() end) end
            end
            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 2
            end)
            local localChar = plr.Character
            local all = workspace:GetDescendants()
            for i = 1, #all, 100 do
                for j = i, math.min(i+99, #all) do
                    local inst = all[j]
                    pcall(function()
                        if inst:IsA("BasePart") and not (localChar and inst:IsDescendantOf(localChar)) then
                            inst.Material = Enum.Material.SmoothPlastic
                            inst.Reflectance = 0
                        end
                        if (inst:IsA("Texture") or inst:IsA("Decal")) and not (localChar and inst:IsDescendantOf(localChar)) then
                            inst.Transparency = 1
                        end
                    end)
                end
                task.wait()
            end
            pcall(function()
                local t = workspace:FindFirstChild("Terrain")
                if t then
                    t.WaterWaveSize=0; t.WaterWaveSpeed=0
                    t.WaterReflectance=0; t.WaterTransparency=1
                end
                settings().Rendering.QualityLevel = 1
            end)
        end)
        Library:Notify({Title="Reduce Grafik", Description="Aktif! Rejoin untuk restore.", Time=4})
    end,
})

-- ══════════════════════════════════════════════════════════════
-- TAB: VISUAL
-- ══════════════════════════════════════════════════════════════
local VisualGroup  = Tabs.Visual:AddLeftGroupbox("ESP")
local VisualGroupR = Tabs.Visual:AddRightGroupbox("Extra ESP")
local VisualSpec   = Tabs.Visual:AddLeftGroupbox("Spectate Player")

VisualGroup:AddToggle("BoxESP", {
    Text = "Box ESP", Default = false,
    Callback = function(v) Flags.BoxESP = v end,
})
VisualGroup:AddDropdown("BoxESPMode", {
    Values = {"FULL", "CORNER"}, Default = "FULL",
    Text = "Box Style",
    Callback = function(v) BoxESPMode = v end,
})
VisualGroup:AddToggle("Tracer", {
    Text = "Tracer", Default = false,
    Callback = function(v) Flags.Tracer = v end,
})
VisualGroup:AddSlider("TracerMaxDist", {
    Text = "Tracer Distance", Default = 300, Min = 50, Max = 1000, Rounding = 0, Suffix = " studs",
    Callback = function(v) TracerMaxDist = v; saveSettings() end,
})
VisualGroup:AddSlider("ESPMaxDist", {
    Text = "ESP Distance", Default = 500, Min = 10, Max = 5000, Rounding = 0, Suffix = " studs",
    Callback = function(v) ESPMaxDist = v; saveSettings() end,
})

VisualGroupR:AddToggle("ESPName",     {Text="Name",     Default=true, Callback=function(v) Flags.ESPName=v end})
VisualGroupR:AddToggle("ESPDist",     {Text="Distance", Default=true, Callback=function(v) Flags.ESPDist=v end})
VisualGroupR:AddToggle("ESPHPBar",    {Text="HP Bar",   Default=true, Callback=function(v) Flags.ESPHPBar=v end})
VisualGroupR:AddToggle("ESPWeapon",   {Text="Weapon",   Default=true, Callback=function(v) Flags.ESPWeapon=v end})
VisualGroupR:AddToggle("ESPSkeleton", {Text="Skeleton", Default=false, Callback=function(v) Flags.ESPSkeleton=v end})
VisualGroupR:AddToggle("ESPMasak",    {Text="Masak Tag",Default=true, Callback=function(v) Flags.ESPMasak=v end})

-- Spectate
local specTarget = nil
local specConn = nil

local function stopSpectate()
    if specConn then specConn:Disconnect(); specConn = nil end
    specTarget = nil
    local cam = workspace.CurrentCamera
    pcall(function()
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    end)
end

local specDropdownValues = {}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= plr then table.insert(specDropdownValues, p.Name) end
end

local SpecDrop = VisualSpec:AddDropdown("SpectatePlayer", {
    Values = specDropdownValues,
    Default = nil,
    Text = "Select Player to Spectate",
    Searchable = true,
    Callback = function(v)
        if v and v ~= "" then
            local target = game.Players:FindFirstChild(v)
            if target and target.Character then
                stopSpectate()
                specTarget = target
                local cam = workspace.CurrentCamera
                specConn = RunService.RenderStepped:Connect(function()
                    if not specTarget or not specTarget.Parent then stopSpectate(); return end
                    local char = specTarget.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        if cam.CameraType ~= Enum.CameraType.Custom then cam.CameraType = Enum.CameraType.Custom end
                        if cam.CameraSubject ~= hum then cam.CameraSubject = hum end
                    end
                end)
                Library:Notify({Title="Spectate", Description="Spectating: "..v, Time=3})
            end
        end
    end,
})

VisualSpec:AddButton({
    Text = "Stop Spectate",
    Func = function()
        stopSpectate()
        Library:Notify({Title="Spectate", Description="Stopped.", Time=2})
    end,
})

VisualSpec:AddButton({
    Text = "Refresh Player List",
    Func = function()
        local newVals = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr then table.insert(newVals, p.Name) end
        end
        SpecDrop:SetValues(newVals)
    end,
})

game.Players.PlayerRemoving:Connect(function(p)
    if specTarget == p then stopSpectate() end
end)

-- ══════════════════════════════════════════════════════════════
-- TAB: AIM
-- ══════════════════════════════════════════════════════════════
local AimGroup  = Tabs.Aim:AddLeftGroupbox("Aimbot")
local AimGroupR = Tabs.Aim:AddRightGroupbox("Silent Aim")
local AimWL     = Tabs.Aim:AddLeftGroupbox("Whitelist")

AimGroup:AddToggle("AimLock", {
    Text = "Auto Aim (RMB)", Default = false,
    Tooltip = "Hold RMB untuk aim",
    Callback = function(v) Flags.AimLock = v end,
})
AimGroup:AddDropdown("AimMode", {
    Values = {"PC", "HP"}, Default = "PC",
    Text = "Aim Mode",
    Callback = function(v) AimMode = v end,
})
AimGroup:AddDropdown("AimPart", {
    Values = {"Head", "Body"}, Default = "Head",
    Text = "Aim Part",
    Callback = function(v) AimPart = (v == "Head" and "Head" or "HumanoidRootPart") end,
})
AimGroup:AddToggle("WallCheck", {
    Text = "Wall Check", Default = false,
    Callback = function(v) Flags.WallCheck = v end,
})
AimGroup:AddSlider("AimFOV", {
    Text = "FOV Radius (Aimbot)", Default = 120, Min = 30, Max = 400, Rounding = 0, Suffix = "px",
    Callback = function(v) AimFOV_Radius = v; saveSettings() end,
})
AimGroup:AddSlider("AimMaxDist", {
    Text = "Max Distance", Default = 300, Min = 50, Max = 1000, Rounding = 0, Suffix = " studs",
    Callback = function(v) AimMax_Dist = v; saveSettings() end,
})
AimGroup:AddSlider("AimSmooth", {
    Text = "Smoothness", Default = 85, Min = 1, Max = 100, Rounding = 0, Suffix = "%",
    Callback = function(v) AimSmooth = math.clamp(v/100, 0.01, 0.99); saveSettings() end,
})
AimGroup:AddToggle("ShowAimFOV", {
    Text = "Show FOV Circle", Default = true,
    Callback = function(v) ShowAimFOV = v end,
})

AimGroupR:AddToggle("SilentAim", {
    Text = "Silent Aim", Default = false,
    Callback = function(v) SilentAim = v end,
})
AimGroupR:AddToggle("SilentAimWallbang", {
    Text = "Silent Wallbang", Default = false,
    Callback = function(v) SilentAimWallbang = v end,
})
AimGroupR:AddDropdown("SilentMode", {
    Values = {"PC", "HP"}, Default = "PC",
    Text = "Silent Aim Mode",
    Callback = function(v) SilentMode = v end,
})
AimGroupR:AddSlider("SilentFOV", {
    Text = "FOV Radius (Silent)", Default = 120, Min = 30, Max = 400, Rounding = 0, Suffix = "px",
    Callback = function(v) SilentFOV_Radius = v end,
})
AimGroupR:AddToggle("ShowSilentFOV", {
    Text = "Show FOV (Silent)", Default = true,
    Callback = function(v) ShowSilentFOV = v end,
})

-- Whitelist builder
local wlPlayers = {}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= plr then wlPlayers[p.Name] = false end
end

local WLDrop = AimWL:AddDropdown("WhitelistPlayer", {
    Values = (function()
        local t = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr then table.insert(t, p.Name) end
        end
        return t
    end)(),
    Default = nil,
    Text = "Toggle Whitelist Player",
    Searchable = true,
    Callback = function(v)
        if v and v ~= "" then
            if AimWhitelist[v] then
                AimWhitelist[v] = nil
                Library:Notify({Title="Whitelist", Description="Removed: "..v, Time=2})
            else
                AimWhitelist[v] = true
                Library:Notify({Title="Whitelist", Description="Added: "..v, Time=2})
            end
        end
    end,
})

AimWL:AddButton({
    Text = "Clear Whitelist",
    Func = function()
        AimWhitelist = {}
        Library:Notify({Title="Whitelist", Description="Cleared!", Time=2})
    end,
})

game.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    local newVals = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= plr then table.insert(newVals, p.Name) end
    end
    WLDrop:SetValues(newVals)
end)
game.Players.PlayerRemoving:Connect(function(p)
    AimWhitelist[p.Name] = nil
end)

-- ══════════════════════════════════════════════════════════════
-- END OF PART 1
-- ══════════════════════════════════════════════════════════════

-- [Lanjut ke PART 2 — TAB FARM, TP, VEHICLE, INFO, CONFIG, LOGIC LOOPS]