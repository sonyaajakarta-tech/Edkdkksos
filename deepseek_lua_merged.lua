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

-- ══════════════════════════════════════════════════════════════
-- TAB: FARM — APARTMENT SELECTOR
-- ══════════════════════════════════════════════════════════════
local FarmGroup  = Tabs.Farm:AddLeftGroupbox("Auto Farm")
local FarmGroupR = Tabs.Farm:AddRightGroupbox("Auto Buy / Sell")

local apartValues = {}
for _, a in ipairs(APARTMENTS) do table.insert(apartValues, a.name) end

local ApartDrop = FarmGroup:AddDropdown("SelectApartment", {
    Values = apartValues,
    Default = nil,
    Text = "Pilih Apartment",
    Searchable = true,
    Callback = function(v)
        for _, a in ipairs(APARTMENTS) do
            if a.name == v then
                selectedApart = a
                Library:Notify({Title="Apartment", Description="Selected: "..v, Time=2})
                break
            end
        end
    end,
})

FarmGroup:AddDropdown("ApartSide", {
    Values = {"L (Left)", "R (Right)"},
    Default = "L (Left)",
    Text = "Cook Spot Side",
    Callback = function(v)
        if not selectedApart then return end
        local isR = v:find("R") ~= nil
        selectedApart.side = isR and "R" or "L"
        if isR and selectedApart.rx then
            selectedApart.cx = selectedApart.rx
            selectedApart.cy = selectedApart.ry
            selectedApart.cz = selectedApart.rz
            if selectedApart.topRx then
                selectedApart.topCx = selectedApart.topRx
                selectedApart.topCy = selectedApart.topRy
                selectedApart.topCz = selectedApart.topRz
            end
        else
            selectedApart.cx = selectedApart.lx
            selectedApart.cy = selectedApart.ly
            selectedApart.cz = selectedApart.lz
            if selectedApart.topLx then
                selectedApart.topCx = selectedApart.topLx
                selectedApart.topCy = selectedApart.topLy
                selectedApart.topCz = selectedApart.topLz
            end
        end
    end,
})

FarmGroup:AddButton({
    Text = "GO — TP ke Apartment",
    Func = function()
        if not selectedApart then
            Library:Notify({Title="Error", Description="Pilih apartment dulu!", Time=3})
            return
        end
        local apt = selectedApart
        directTP(apt.cx or apt.x, apt.cy or apt.y, apt.cz or apt.z, apt.name)
    end,
})

FarmGroup:AddDivider()

-- ══════════════════════════════════════════════════════════════
-- AUTO COOK
-- ══════════════════════════════════════════════════════════════
local totalMasak = 0
local currentCookStep = 1
local lastCookProgressTime = 0
local COOK_WATCHDOG_SECS = 150

local cookSteps = {
    {keyword="water", baseWait=20},
    {multi = {{keyword="sugar", wait=1.5}, {keyword="gelatin", wait=45}}},
    {keyword="empty", baseWait=2},
}

FarmGroup:AddToggle("AutoCook", {
    Text = "Auto Cook", Default = false,
    Tooltip = "Auto masak marshmallow",
    Callback = function(v)
        Flags.AutoCook = v
        if v then
            lastCookProgressTime = tick()
            if selectedApart and not selectedApart.name:lower():find("casino") then
                task.spawn(function()
                    local apt = selectedApart
                    local ch = plr.Character
                    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                    if hrp and apt.cx then
                        directTP(apt.cx, apt.cy, apt.cz, apt.name)
                    end
                end)
            end
        end
    end,
})

local CookInfo = FarmGroup:AddLabel("Cooked: 0 | Step: —")

FarmGroup:AddButton({
    Text = "Reset Counter",
    Func = function()
        totalMasak = 0
        currentCookStep = 1
        CookInfo:SetText("Cooked: 0 | Step: —")
    end,
})

-- Cam Lock
local camLocked = false
local camLockConn = nil
local lockedCF = nil

FarmGroup:AddToggle("CamLock", {
    Text = "Cam Lock", Default = false,
    Callback = function(v)
        camLocked = v
        if v then
            local cam = workspace.CurrentCamera
            lockedCF = cam.CFrame
            cam.CameraType = Enum.CameraType.Scriptable
            if camLockConn then camLockConn:Disconnect() end
            camLockConn = RunService.RenderStepped:Connect(function()
                if not camLocked then return end
                workspace.CurrentCamera.CFrame = lockedCF
            end)
        else
            if camLockConn then camLockConn:Disconnect(); camLockConn=nil end
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            lockedCF = nil
        end
    end,
})

-- ══════════════════════════════════════════════════════════════
-- INVENTORY VIEWER
-- ══════════════════════════════════════════════════════════════
local INGREDIENTS = {
    {label="Water", key="water"}, {label="Sugar", key="sugar"},
    {label="Gelatin", key="gelatin"}, {label="Marshmallow", key="marshmallow"},
    {label="Small", key="small"}, {label="Medium", key="medium"}, {label="Large", key="large"},
}
local invLabels = {}
for _, item in ipairs(INGREDIENTS) do
    invLabels[item.key] = FarmGroup:AddLabel(item.label .. ": 0")
end

FarmGroup:AddButton({
    Text = "Refresh Inventory",
    Func = function()
        local counts = {}
        for _, item in ipairs(INGREDIENTS) do counts[item.key] = 0 end
        local function scan(container)
            if not container then return end
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Tool") then
                    local lower = v.Name:lower()
                    for _, item in ipairs(INGREDIENTS) do
                        if lower:find(item.key) then counts[item.key] = counts[item.key] + 1 end
                    end
                end
            end
        end
        scan(plr.Backpack)
        if plr.Character then scan(plr.Character) end
        for key, lbl in pairs(invLabels) do
            lbl:SetText((key:sub(1,1):upper()..key:sub(2)) .. ": " .. (counts[key] or 0))
        end
    end,
})

-- ══════════════════════════════════════════════════════════════
-- AUTO BUY LAMBERT BELL
-- ══════════════════════════════════════════════════════════════
FarmGroupR:AddSlider("BuyAmount", {
    Text = "Jumlah Beli", Default = 10, Min = 1, Max = 100, Rounding = 0, Suffix = "x",
    Callback = function(v) AutoBuySettings.Amount = v end,
})

local function abBuyItems(itemNames)
    local remEvts = RS:FindFirstChild("RemoteEvents")
    local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
    if not spRE then
        Library:Notify({Title="Error", Description="StorePurchase tidak ada!", Time=3})
        return
    end
    task.spawn(function()
        local qty = AutoBuySettings.Amount
        for _, item in ipairs(itemNames) do
            Library:Notify({Title="Buy", Description="Beli "..item.." ×"..qty, Time=2})
            for i = 1, qty do
                pcall(function() spRE:FireServer(item, 1) end)
                task.wait(0.4)
            end
        end
        Library:Notify({Title="Done", Description="Pembelian selesai!", Time=3})
    end)
end

FarmGroupR:AddButton({Text="Buy PACK (Water+Sugar+Gelatin)", Func=function() abBuyItems({"Water","Sugar Block Bag","Gelatin"}) end})
FarmGroupR:AddButton({Text="Buy WATER", Func=function() abBuyItems({"Water"}) end})
FarmGroupR:AddButton({Text="Buy SUGAR", Func=function() abBuyItems({"Sugar Block Bag"}) end})
FarmGroupR:AddButton({Text="Buy GELATIN", Func=function() abBuyItems({"Gelatin"}) end})

FarmGroupR:AddDivider()

-- ══════════════════════════════════════════════════════════════
-- AUTO SELL MARSHMALLOW
-- ══════════════════════════════════════════════════════════════
local isSellingMarsh = false

local function findNearestPrompt()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local part = obj.Parent
            local pos
            if part:IsA("Attachment") then pos = part.WorldPosition
            elseif part:IsA("BasePart") then pos = part.Position
            elseif part:IsA("Model") then
                local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                if rp then pos = rp.Position end
            end
            if pos then
                local d = (pos - hrp.Position).Magnitude
                if obj.ActionText:lower():find("interact") and d < bestDist then
                    bestDist = d; best = obj
                end
            end
        end
    end
    return best
end

FarmGroupR:AddButton({
    Text = "Sell Marshmallow",
    Func = function()
        if isSellingMarsh then return end
        isSellingMarsh = true
        task.spawn(function()
            local function getMarsh()
                local list = {}
                for _, c in ipairs({plr.Backpack, plr.Character}) do
                    if c then
                        for _, v in pairs(c:GetChildren()) do
                            if v:IsA("Tool") and v.Name:lower():find("marshmallow") then
                                table.insert(list, v)
                            end
                        end
                    end
                end
                return list
            end
            local list = getMarsh()
            if #list == 0 then
                Library:Notify({Title="Sell", Description="Tidak ada Marshmallow!", Time=3})
                isSellingMarsh = false; return
            end
            local sellP = findNearestPrompt()
            if not sellP then
                Library:Notify({Title="Sell", Description="Prompt tidak ditemukan!", Time=3})
                isSellingMarsh = false; return
            end
            pcall(function()
                sellP.MaxActivationDistance = 9999
                sellP.RequiresLineOfSight = false
            end)
            local total, sold = #list, 0
            for _, marsh in ipairs(list) do
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if not hum then break end
                pcall(function() hum:EquipTool(marsh) end)
                task.wait(0.1)
                pcall(function() fireproximityprompt(sellP) end)
                task.wait(0.2)
                sold = sold + 1
            end
            pcall(function()
                if sellP.Parent then
                    sellP.MaxActivationDistance = 10
                    sellP.RequiresLineOfSight = true
                end
            end)
            Library:Notify({Title="Sell", Description="Terjual: "..sold, Time=3})
            isSellingMarsh = false
        end)
    end,
})

-- ══════════════════════════════════════════════════════════════
-- FULLY AUTO FARM
-- ══════════════════════════════════════════════════════════════
local AF = {active=false, paused=false, packQty=10}
local MARSH_X, MARSH_Y, MARSH_Z = 510.38, 3.59, 603.50

FarmGroup:AddDivider()
local afHdr = FarmGroup:AddLabel("━━ FULLY AUTO FARM ━━")

FarmGroup:AddSlider("AFPackQty", {
    Text = "Pack per Siklus", Default = 10, Min = 1, Max = 100, Rounding = 0, Suffix = "x",
    Callback = function(v) AF.packQty = v end,
})

local AFStatus = FarmGroup:AddLabel("Status: —")

local function afSetStatus(txt)
    AFStatus:SetText("Status: " .. txt)
end

FarmGroup:AddToggle("AFActive", {
    Text = "Fully Auto Farm", Default = false,
    Tooltip = "Loop: KillTP → Buy → TP apt → Cook → TP marsh → Sell",
    Callback = function(v)
        if v then
            if not selectedApart then
                Library:Notify({Title="AutoFarm", Description="Pilih apartment dulu!", Time=3})
                Toggles.AFActive:SetValue(false)
                return
            end
            AF.active = true; AF.paused = false
            task.spawn(function()
                local cycle = 0
                local needsKillTP = true
                while AF.active do
                    while AF.paused and AF.active do task.wait(0.3) end
                    if not AF.active then break end

                    if needsKillTP then
                        afSetStatus("Kill TP → Buy Marshmallow...")
                        doSuicideTP({name="Buy Marshmallow", x=MARSH_X, y=MARSH_Y, z=MARSH_Z})
                        task.wait(1)
                        needsKillTP = false
                    end

                    afSetStatus("Buy Pack ×"..AF.packQty.."...")
                    local remEvts = RS:FindFirstChild("RemoteEvents")
                    local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
                    if spRE then
                        for _, item in ipairs({"Water", "Sugar Block Bag", "Gelatin"}) do
                            for i = 1, AF.packQty do
                                if not AF.active then break end
                                pcall(function() spRE:FireServer(item, 1) end)
                                task.wait(0.4)
                            end
                        end
                    end
                    task.wait(1)

                    afSetStatus("TP → "..selectedApart.name)
                    tpToPos(selectedApart.x, selectedApart.y, selectedApart.z, nil, selectedApart.name)
                    local wt = 0
                    while tpActive and wt < 200 do task.wait(0.1); wt=wt+1 end
                    task.wait(1)

                    afSetStatus("Cook "..AF.packQty.."x...")
                    local startMasak = totalMasak
                    local target = startMasak + AF.packQty
                    Flags.AutoCook = true
                    Toggles.AutoCook:SetValue(true)
                    local timeout = tick() + 900
                    while AF.active and totalMasak < target and tick() < timeout do
                        while AF.paused and AF.active do task.wait(0.3) end
                        if not AF.active then break end
                        afSetStatus(("Cook %d/%d"):format(totalMasak - startMasak, AF.packQty))
                        task.wait(1)
                    end
                    Flags.AutoCook = false
                    Toggles.AutoCook:SetValue(false)

                    afSetStatus("TP → Marshmallow sell...")
                    tpToPos(MARSH_X, MARSH_Y, MARSH_Z, nil, "Buy Marshmallow")
                    wt = 0
                    while tpActive and wt < 200 do task.wait(0.1); wt=wt+1 end
                    task.wait(1)

                    afSetStatus("Sell marshmallow...")
                    local sellP = findNearestPrompt()
                    if sellP then
                        pcall(function()
                            sellP.MaxActivationDistance = 9999
                            sellP.RequiresLineOfSight = false
                        end)
                        for _, c in ipairs({plr.Backpack, plr.Character}) do
                            if c then
                                for _, v in pairs(c:GetChildren()) do
                                    if v:IsA("Tool") and v.Name:lower():find("marshmallow") then
                                        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                                        if hum then
                                            pcall(function() hum:EquipTool(v) end)
                                            task.wait(0.1)
                                            pcall(function() fireproximityprompt(sellP) end)
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    cycle = cycle + 1
                    afSetStatus("Siklus #"..cycle.." selesai!")
                    task.wait(1)
                end
                AF.active = false
                afSetStatus("Stopped.")
            end)
        else
            AF.active = false; AF.paused = false
            Flags.AutoCook = false
            Toggles.AutoCook:SetValue(false)
        end
    end,
})

FarmGroup:AddButton({
    Text = "PAUSE / RESUME",
    Func = function()
        AF.paused = not AF.paused
        Library:Notify({Title="AutoFarm", Description=AF.paused and "Paused" or "Resumed", Time=2})
    end,
})

-- ══════════════════════════════════════════════════════════════
-- AUTO BUY CHIPS + CHIPS AUTO FARM + AUTO SELL CHIPS
-- ══════════════════════════════════════════════════════════════
local FarmChips = Tabs.Farm:AddRightGroupbox("Chips")

local chipBuyAmt = { Amount = 10 }
FarmChips:AddSlider("ChipBuyAmt", {
    Text = "Jumlah Beli Chips", Default = 10, Min = 1, Max = 100, Rounding = 0, Suffix = "x",
    Callback = function(v) chipBuyAmt.Amount = v end,
})

local function chipBuyItems(itemNames)
    local remEvts = RS:FindFirstChild("RemoteEvents")
    local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
    if not spRE then
        Library:Notify({Title="Error", Description="StorePurchase tidak ada!", Time=3})
        return
    end
    task.spawn(function()
        for _, item in ipairs(itemNames) do
            for i = 1, chipBuyAmt.Amount do
                pcall(function() spRE:FireServer(item, 1) end)
                task.wait(0.4)
            end
        end
        Library:Notify({Title="Chips", Description="Beli selesai!", Time=3})
    end)
end

FarmChips:AddButton({Text="Buy POTATO", Func=function() chipBuyItems({"Potato"}) end})
FarmChips:AddButton({Text="Buy FLOUR", Func=function() chipBuyItems({"Flour"}) end})
FarmChips:AddButton({Text="Buy PACK (Potato+Flour)", Func=function() chipBuyItems({"Potato","Flour"}) end})

-- Chips Auto Farm
local CF2 = { active=false, paused=false, pot=1 }
local CHIPS_COORDS = {
    A = {x=-478.83, y=3.86, z=-438.92, name="Station A"},
    B = {x=-461.69, y=3.86, z=-461.25, name="Station B"},
    C = {x=-461.69, y=3.86, z=-472.88, name="Station C"},
    D = {x=-462.75, y=3.86, z=-521.94, name="Station D"},
}
local CHIPS_POTS = {
    {x=-515.28, y=3.86, z=-451.71, name="Pot 1"},
    {x=-515.24, y=3.86, z=-462.26, name="Pot 2"},
    {x=-515.28, y=3.86, z=-471.89, name="Pot 3"},
    {x=-515.28, y=3.86, z=-481.75, name="Pot 4"},
    {x=-515.24, y=3.86, z=-492.10, name="Pot 5"},
    {x=-496.99, y=3.86, z=-452.21, name="Pot 6"},
    {x=-496.95, y=3.86, z=-462.02, name="Pot 7"},
    {x=-496.98, y=3.86, z=-471.73, name="Pot 8"},
    {x=-496.99, y=3.86, z=-481.82, name="Pot 9"},
    {x=-497.04, y=3.86, z=-491.37, name="Pot 10"},
}

FarmChips:AddDropdown("ChipPot", {
    Values = (function() local t={} for i=1,10 do t[i]="Pot "..i end return t end)(),
    Default = "Pot 1",
    Text = "Pilih Pot",
    Callback = function(v) CF2.pot = tonumber(v:match("%d+")) or 1 end,
})

local CFStatus = FarmChips:AddLabel("Chips: —")
local function cfSet(txt) CFStatus:SetText("Chips: "..txt) end

local function cfMoveTo(targetPos)
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
end

local function cfTPTo(coord)
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local from = hrp.Position
    local to = Vector3.new(coord.x, coord.y, coord.z)
    local dist = (to - from).Magnitude
    if dist < 0.05 then return end
    local t = dist / 30
    local el = 0
    while el < t and CF2.active do
        local h = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not h then break end
        cfMoveTo(from:Lerp(to, math.clamp(el/t, 0, 1)))
        local _, dt = RunService.Stepped:Wait()
        el = el + dt
    end
    if CF2.active then cfMoveTo(to) end
end

local function cfFindPrompt(pos, radius)
    radius = radius or 20
    local best, bd = nil, radius
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local part = obj.Parent
            local pp
            if part:IsA("Attachment") then pp = part.WorldPosition
            elseif part:IsA("BasePart") then pp = part.Position
            elseif part:IsA("Model") then
                local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                if rp then pp = rp.Position end
            end
            if pp then
                local d = (pp - pos).Magnitude
                if d < bd then bd = d; best = obj end
            end
        end
    end
    return best
end

local function cfFire(targetPos)
    local p = cfFindPrompt(targetPos)
    if not p then return end
    pcall(function()
        p.MaxActivationDistance = 9999
        p.RequiresLineOfSight = false
        task.wait(0.05)
        fireproximityprompt(p)
        task.wait(0.1)
        p.MaxActivationDistance = 10
        p.RequiresLineOfSight = true
    end)
end

local function cfEquip(name)
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local tool = plr.Backpack:FindFirstChild(name)
    if tool then pcall(function() hum:EquipTool(tool) end) end
end

FarmChips:AddToggle("ChipsAutoFarm", {
    Text = "Chips Auto Farm", Default = false,
    Callback = function(v)
        if v then
            CF2.active = true; CF2.paused = false
            task.spawn(function()
                local cycle = 0
                while CF2.active do
                    while CF2.paused and CF2.active do task.wait(0.3) end
                    if not CF2.active then break end

                    cfSet("Step A · "..CHIPS_COORDS.A.name)
                    cfTPTo(CHIPS_COORDS.A); cfFire(Vector3.new(CHIPS_COORDS.A.x, CHIPS_COORDS.A.y, CHIPS_COORDS.A.z))

                    cfSet("Step B · Potato")
                    cfTPTo(CHIPS_COORDS.B); cfEquip("Potato")
                    cfFire(Vector3.new(CHIPS_COORDS.B.x, CHIPS_COORDS.B.y, CHIPS_COORDS.B.z))
                    task.wait(2)

                    cfSet("Step C")
                    cfTPTo(CHIPS_COORDS.C)
                    cfFire(Vector3.new(CHIPS_COORDS.C.x, CHIPS_COORDS.C.y, CHIPS_COORDS.C.z))
                    task.wait(2)

                    cfSet("Step D · Flour")
                    cfTPTo(CHIPS_COORDS.D); cfEquip("Flour")
                    cfFire(Vector3.new(CHIPS_COORDS.D.x, CHIPS_COORDS.D.y, CHIPS_COORDS.D.z))
                    task.wait(2)

                    local pot = CHIPS_POTS[CF2.pot]
                    cfSet("Step E · "..pot.name)
                    cfTPTo(pot)
                    cfFire(Vector3.new(pot.x, pot.y, pot.z))
                    task.wait(2)

                    local wait_t = 0
                    while CF2.active and wait_t < 60 do
                        while CF2.paused and CF2.active do task.wait(0.3) end
                        if not CF2.active then break end
                        cfSet(("Masak... %ds"):format(60 - wait_t))
                        task.wait(1)
                        wait_t = wait_t + 1
                    end

                    cfSet("Claim!")
                    cfTPTo(pot)
                    cfFire(Vector3.new(pot.x, pot.y, pot.z))
                    task.wait(1)

                    cycle = cycle + 1
                    cfSet("Siklus #"..cycle.." selesai!")
                    task.wait(0.8)
                end
                cfSet("Stopped.")
            end)
        else
            CF2.active = false
        end
    end,
})

-- Auto Sell Chips
local SC = { active = false }
local SC_TUKAR = {x=-34.91, y=4.56, z=-24.15}
local SC_COOK  = {x=-487.11, y=3.86, z=-454.16}
local SC_HOMELESS = {
    {x=-315.35, y=3.72, z=-361.56}, {x=-273.52, y=3.85, z=-211.32},
    {x=1102.42, y=3.36, z=527.05}, {x=52.89, y=3.72, z=-425.36},
    {x=152.88, y=3.73, z=-210.08}, {x=-522.75, y=-7.86, z=-165.08},
    {x=65.12, y=3.73, z=68.10}, {x=26.04, y=3.73, z=217.89},
    {x=520.08, y=3.87, z=-295.52}, {x=699.28, y=3.72, z=-427.05},
    {x=900.03, y=3.94, z=-283.12}, {x=874.89, y=3.73, z=-63.02},
}

local function scCount(name)
    local n = 0
    for _, c in ipairs({plr.Backpack, plr.Character}) do
        if c then
            for _, t in pairs(c:GetChildren()) do
                if t:IsA("Tool") and t.Name == name then n = n + 1 end
            end
        end
    end
    return n
end

FarmChips:AddToggle("AutoSellChips", {
    Text = "Auto Sell Chips (Vehicle)", Default = false,
    Tooltip = "Harus duduk di kendaraan dulu",
    Callback = function(v)
        if v then
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if not hum or not hum.SeatPart then
                Library:Notify({Title="Sell Chips", Description="Naik kendaraan dulu!", Time=3})
                Toggles.AutoSellChips:SetValue(false)
                return
            end
            SC.active = true
            task.spawn(function()
                local potato = scCount("Potato Chips")
                local hot = scCount("Hot Chips")
                if potato == 0 and hot == 0 then
                    Library:Notify({Title="Sell Chips", Description="Tidak ada chips!", Time=3})
                    SC.active = false; Toggles.AutoSellChips:SetValue(false); return
                end
                local visitCount
                if hot == 0 then
                    visitCount = math.min(potato, 12)
                    doVehicleTP(CFrame.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z))
                    task.wait(0.4)
                    cfFire(Vector3.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z))
                    task.wait(0.5)
                    cfEquip("Hot Chips")
                else
                    visitCount = math.min(hot, 12)
                    cfEquip("Hot Chips")
                end
                for i = 1, visitCount do
                    if not SC.active then break end
                    local h = SC_HOMELESS[i]
                    doVehicleTP(CFrame.new(h.x, h.y, h.z))
                    task.wait(0.25)
                    cfEquip("Hot Chips")
                    cfFire(Vector3.new(h.x, h.y, h.z))
                    task.wait(0.2)
                end
                SC.active = false
                Library:Notify({Title="Sell Chips", Description="Selesai!", Time=3})
                Toggles.AutoSellChips:SetValue(false)
            end)
        else
            SC.active = false
        end
    end,
})

-- ══════════════════════════════════════════════════════════════
-- AUTO FARM BOX
-- ══════════════════════════════════════════════════════════════
local FarmBox = Tabs.Farm:AddLeftGroupbox("Auto Farm Box")
local BOX_POS_A = CFrame.new(-551.47, 3.54, -84.97)
local BOX_POS_B = CFrame.new(-401.96, 3.36, -70.98)
local boxActive = false

local BoxStatus = FarmBox:AddLabel("Box: —")

local function boxTween(targetCF)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - targetCF.Position).Magnitude
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist/20, 0.05), Enum.EasingStyle.Linear), {CFrame=targetCF})
    tw:Play()
    tw.Completed:Wait()
end

local function boxFire(pos)
    local best, bd = nil, 25
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local part = obj.Parent
            local pp
            if part:IsA("BasePart") then pp = part.Position
            elseif part:IsA("Model") then
                local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                if rp then pp = rp.Position end
            end
            if pp then
                local d = (pp - pos).Magnitude
                if d < bd then bd = d; best = obj end
            end
        end
    end
    if best then pcall(function() fireproximityprompt(best) end) end
end

FarmBox:AddToggle("AutoFarmBox", {
    Text = "Auto Farm Box", Default = false,
    Callback = function(v)
        boxActive = v
        if v then
            task.spawn(function()
                while boxActive do
                    BoxStatus:SetText("Box: → A")
                    boxTween(BOX_POS_A)
                    if not boxActive then break end
                    task.wait(0.3)
                    BoxStatus:SetText("Box: Interact A")
                    boxFire(BOX_POS_A.Position)
                    task.wait(0.5)
                    if not boxActive then break end
                    BoxStatus:SetText("Box: → B")
                    boxTween(BOX_POS_B)
                    if not boxActive then break end
                    task.wait(0.3)
                    BoxStatus:SetText("Box: Equip Crate")
                    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local crate = plr.Backpack:FindFirstChild("Crate") or plr.Backpack:FindFirstChild("crate")
                        if crate then pcall(function() hum:EquipTool(crate) end) end
                    end
                    task.wait(0.3)
                    BoxStatus:SetText("Box: Interact B")
                    boxFire(BOX_POS_B.Position)
                    task.wait(0.5)
                end
                BoxStatus:SetText("Box: Stopped.")
            end)
        else
            BoxStatus:SetText("Box: Off")
        end
    end,
})

-- ══════════════════════════════════════════════════════════════
-- TAB: TP
-- ══════════════════════════════════════════════════════════════
local TPGroup   = Tabs.TP:AddLeftGroupbox("Teleport")
local TPPlayer  = Tabs.TP:AddRightGroupbox("TP to Player")
local TPLoading = Tabs.TP:AddLeftGroupbox("Teleport Loading (Info)")

TPLoading:AddLabel("Overlay 'WAIT' muncul saat TP sedang berjalan.")
TPLoading:AddLabel("Cancel TP tidak tersedia — biarkan selesai.")

local function buildTPButtons()
    for _, cat in ipairs(TP_CATEGORIES) do
        TPGroup:AddDivider()
        TPGroup:AddLabel("━━ " .. cat.name .. " ━━")
        for _, loc in ipairs(cat.locs) do
            local line = TPGroup:AddLabel(loc.name)
            line:AddButton({
                Text = "GO",
                Func = function()
                    tpToPos(loc.x, loc.y, loc.z, nil, loc.name)
                end,
            })
            line:AddButton({
                Text = "KILL",
                Func = function()
                    doSuicideTP(loc)
                end,
            })
            line:AddButton({
                Text = "VEH",
                Func = function()
                    local ok = doVehicleTP(CFrame.new(loc.x, loc.y, loc.z))
                    Library:Notify({
                        Title = "Vehicle TP",
                        Description = ok and ("Berhasil ke " .. loc.name) or "Tidak di kendaraan!",
                        Time = 3,
                    })
                end,
            })
        end
    end
end
buildTPButtons()

-- TP to Player
local TPPDrop = TPPlayer:AddDropdown("TPTarget", {
    Values = (function()
        local t = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr then table.insert(t, p.Name) end
        end
        return t
    end)(),
    Default = nil,
    Text = "Select Player",
    Searchable = true,
    Callback = function() end,
})

TPPlayer:AddButton({
    Text = "TP to Selected",
    Func = function()
        local val = Options.TPTarget.Value
        if not val or val == "" then
            Library:Notify({Title="TP", Description="Pilih player dulu!", Time=3})
            return
        end
        local target = game.Players:FindFirstChild(val)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then tpToPos(hrp.Position.X, hrp.Position.Y, hrp.Position.Z, nil, val) end
        end
    end,
})

TPPlayer:AddButton({
    Text = "KILL TP to Selected",
    Func = function()
        local val = Options.TPTarget.Value
        if not val or val == "" then
            Library:Notify({Title="TP", Description="Pilih player dulu!", Time=3})
            return
        end
        local target = game.Players:FindFirstChild(val)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then doSuicideTP({name=val, x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z}) end
        end
    end,
})

TPPlayer:AddButton({
    Text = "Refresh Player List",
    Func = function()
        local t = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr then table.insert(t, p.Name) end
        end
        TPPDrop:SetValues(t)
    end,
})

-- ══════════════════════════════════════════════════════════════
-- TAB: VEHICLE
-- ══════════════════════════════════════════════════════════════
local VehicleGroup = Tabs.Vehicle:AddLeftGroupbox("Vehicle Fly")
local vFlyActive = false
local vFlySpeed = 50
local vLockedCF = nil
local vFlyLoop = nil

local function vStopFly()
    vLockedCF = nil
    if vFlyLoop then vFlyLoop:Disconnect(); vFlyLoop = nil end
end

local function vStartFly()
    vStopFly()
    vFlyLoop = RunService.Heartbeat:Connect(function(dt)
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if seat then
            local vehicle = seat:FindFirstAncestorOfClass("Model")
            local vRoot = (vehicle and vehicle.PrimaryPart) or seat
            if not vLockedCF then vLockedCF = vRoot.CFrame end
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then dir = dir.Unit end
            local newPos = vLockedCF.Position + (dir * vFlySpeed * dt)
            vLockedCF = CFrame.new(newPos) * vLockedCF.Rotation
            vRoot.CFrame = vLockedCF
            vRoot.AssemblyLinearVelocity = Vector3.zero
            vRoot.AssemblyAngularVelocity = Vector3.zero
        else
            if vFlyActive then
                vFlyActive = false
                vStopFly()
                Toggles.VehicleFly:SetValue(false)
            end
        end
    end)
end

VehicleGroup:AddToggle("VehicleFly", {
    Text = "Vehicle Fly", Default = false,
    Tooltip = "WASD gerak + E naik + Q turun",
    Callback = function(v)
        vFlyActive = v
        if v then vStartFly() else vStopFly() end
    end,
})

VehicleGroup:AddSlider("VehicleFlySpeed", {
    Text = "Fly Speed", Default = 50, Min = 10, Max = 500, Rounding = 0, Suffix = "",
    Callback = function(v) vFlySpeed = v end,
})

VehicleGroup:AddLabel("ℹ Duduk di kendaraan dulu sebelum ON")
VehicleGroup:AddLabel("• W/A/S/D = gerak ngikutin kamera")
VehicleGroup:AddLabel("• E = naik | Q = turun")
VehicleGroup:AddLabel("• Auto OFF kalau keluar kendaraan")

-- ══════════════════════════════════════════════════════════════
-- TAB: INFO
-- ══════════════════════════════════════════════════════════════
local InfoGroup  = Tabs.Info:AddLeftGroupbox("Contact")
local InfoGroupR = Tabs.Info:AddRightGroupbox("Warning")

InfoGroup:AddLabel("TikTok: @drakhub")
InfoGroup:AddLabel("Discord: discord.gg/AbHhEACZC")
InfoGroup:AddDivider()
InfoGroup:AddButton({
    Text = "Copy TikTok",
    Func = function()
        pcall(function() setclipboard("@drakhub") end)
        Library:Notify({Title="Copied", Description="TikTok @drakhub", Time=2})
    end,
})
InfoGroup:AddButton({
    Text = "Copy Discord",
    Func = function()
        pcall(function() setclipboard("https://discord.gg/AbHhEACZC") end)
        Library:Notify({Title="Copied", Description="Discord link", Time=2})
    end,
})

InfoGroupR:AddLabel("⚠ USE AT YOUR OWN RISK")
InfoGroupR:AddLabel("We are not responsible for any bans.")
InfoGroupR:AddDivider()
InfoGroupR:AddLabel("🚫 DILARANG SHARING SCRIPT INI!")
InfoGroupR:AddLabel("🚫 DILARANG MENJUAL KEMBALI SCRIPT INI!")

-- ══════════════════════════════════════════════════════════════
-- TAB: CONFIG — SaveManager + ThemeManager
-- ══════════════════════════════════════════════════════════════
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("DarkHub")
SaveManager:SetFolder("DarkHub/specific-game")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)

local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddButton({Text="Unload Dark Hub", Func=function() Library:Unload() end})
Library.ToggleKeybind = Options.MenuKeybind

-- ══════════════════════════════════════════════════════════════
-- RENDER LOOP — ESP + AIMBOT
-- ══════════════════════════════════════════════════════════════
local SKEL_BONES = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
    {"RightUpperLeg","LeftUpperLeg"},
}

local wpRayParams = RaycastParams.new()
wpRayParams.FilterType = Enum.RaycastFilterType.Blacklist

RunService.RenderStepped:Connect(function()
    if _overlayActive then
        FovCircle.Visible = false
        SilentFovCircle.Visible = false
        SilentLine.Visible = false
        for _, e in pairs(ESP) do _hideESP(e) end
        return
    end

    local cam = workspace.CurrentCamera
    local vp = cam.ViewportSize
    local mousePos = UIS:GetMouseLocation()
    local localRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local fovCenter = AimMode == "HP" and Vector2.new(vp.X/2, vp.Y/2) or mousePos

    -- Aimbot FOV
    FovCircle.Radius = AimFOV_Radius
    FovCircle.Visible = Flags.AimLock and ShowAimFOV
    FovCircle.Position = fovCenter

    -- Silent Aim FOV
    if SilentAim then
        local saOrigin = SilentMode == "HP" and Vector2.new(vp.X/2, vp.Y/2) or mousePos
        local bestWorldD, bestScreenPos = math.huge, nil
        for _, p in pairs(game.Players:GetPlayers()) do
            if p == plr then continue end
            local ch = p.Character
            if not ch then continue end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local part = ch:FindFirstChild(AimPart)
            if not part or not hum or hum.Health <= 0 then continue end
            local sp, onScreen = cam:WorldToViewportPoint(part.Position)
            if not onScreen or sp.Z <= 0 then continue end
            local screenPos = Vector2.new(sp.X, sp.Y)
            if (saOrigin - screenPos).Magnitude > SilentFOV_Radius then continue end
            local wd = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
            if wd < bestWorldD then bestWorldD = wd; bestScreenPos = screenPos end
        end
        if bestScreenPos then
            SilentFovCircle.Position = SilentMode == "HP" and bestScreenPos or saOrigin
            SilentFovCircle.Radius = SilentFOV_Radius
            SilentFovCircle.Visible = ShowSilentFOV
            SilentLine.From = saOrigin; SilentLine.To = bestScreenPos
            SilentLine.Visible = ShowSilentFOV
        else
            SilentFovCircle.Position = saOrigin
            SilentFovCircle.Radius = SilentFOV_Radius
            SilentFovCircle.Visible = ShowSilentFOV
            SilentLine.Visible = false
        end
    else
        SilentFovCircle.Visible = false
        SilentLine.Visible = false
    end

    -- Aimbot
    if AimTarget then
        local tHum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not tHum or tHum.Health <= 0 then AimTarget = nil end
    end
    local shouldAim = Flags.AimLock and localRoot and (AimMode == "HP" or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
    if shouldAim then
        if AimMode == "HP" or not AimTarget then
            local bestD, bestPart = math.huge, nil
            for _, p in pairs(game.Players:GetPlayers()) do
                if p == plr or AimWhitelist[p.Name] then continue end
                local ch = p.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local part = ch and ch:FindFirstChild(AimPart)
                if not part or not hum or hum.Health <= 0 then continue end
                if (part.Position - localRoot.Position).Magnitude > AimMax_Dist then continue end
                local sp, onScreen = cam:WorldToScreenPoint(part.Position)
                if not onScreen then continue end
                if Flags.WallCheck then
                    local camPos = cam.CFrame.Position
                    local dir = part.Position - camPos
                    wpRayParams.FilterDescendantsInstances = {cam, plr.Character}
                    local hit = workspace:Raycast(camPos, dir.Unit * dir.Magnitude, wpRayParams)
                    if hit and not hit.Instance:IsDescendantOf(ch) then continue end
                end
                local d = (Vector2.new(sp.X, sp.Y) - fovCenter).Magnitude
                if d <= AimFOV_Radius and d < bestD then
                    bestD = d; bestPart = part
                end
            end
            AimTarget = bestPart
        end
        if AimTarget then
            local targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCF, AimSmooth)
            FovCircle.Color = Color3.fromRGB(220, 50, 50)
        else
            FovCircle.Color = Color3.fromRGB(255, 255, 255)
        end
    else
        FovCircle.Color = Color3.fromRGB(255, 255, 255)
    end

    -- ESP
    local anyESP = Flags.BoxESP or Flags.Tracer or Flags.ESPName or Flags.ESPDist or Flags.ESPHPBar or Flags.ESPWeapon or Flags.ESPSkeleton or Flags.ESPMasak
    for p, e in pairs(ESP) do
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not anyESP or not ch or not hum or not root then _hideESP(e); continue end

        local pos3, onScreen = cam:WorldToViewportPoint(root.Position)
        if not onScreen or pos3.Z <= 0 then _hideESP(e); continue end
        local isDead = hum.Health <= 0
        if localRoot and (root.Position - localRoot.Position).Magnitude > ESPMaxDist then _hideESP(e); continue end

        -- Skeleton
        if Flags.ESPSkeleton then
            local W2 = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)
            for si, bone in ipairs(SKEL_BONES) do
                local p1 = ch:FindFirstChild(bone[1])
                local p2 = ch:FindFirstChild(bone[2])
                local sk = e.skeleton[si]
                if p1 and p2 then
                    local s1, v1 = cam:WorldToViewportPoint(p1.Position)
                    local s2, v2 = cam:WorldToViewportPoint(p2.Position)
                    if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                        sk.From = Vector2.new(s1.X, s1.Y)
                        sk.To = Vector2.new(s2.X, s2.Y)
                        sk.Color = W2; sk.Visible = true
                    else sk.Visible = false end
                else sk.Visible = false end
            end
        else
            for _, s in ipairs(e.skeleton) do s.Visible = false end
        end

        -- Box dims
        local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
        local sY = math.abs(botPos.Y - topPos.Y)
        local sX = sY * 0.6
        local bx = pos3.X - sX / 2
        local by = math.min(topPos.Y, botPos.Y)

        local cache = espCache[p] or {hasBahan=false, wName=nil}
        local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)

        -- Box
        if Flags.BoxESP then
            e.box.Color = W; e.box.Size = Vector2.new(sX, sY)
            e.box.Position = Vector2.new(bx, by)
            e.box.Visible = (BoxESPMode == "FULL")
            local showC = (BoxESPMode == "CORNER")
            local cL = math.min(sX, sY) * 0.25
            local cx = e.corners
            cx[1].From=Vector2.new(bx,by); cx[1].To=Vector2.new(bx+cL,by)
            cx[2].From=Vector2.new(bx,by); cx[2].To=Vector2.new(bx,by+cL)
            cx[3].From=Vector2.new(bx+sX,by); cx[3].To=Vector2.new(bx+sX-cL,by)
            cx[4].From=Vector2.new(bx+sX,by); cx[4].To=Vector2.new(bx+sX,by+cL)
            cx[5].From=Vector2.new(bx,by+sY); cx[5].To=Vector2.new(bx+cL,by+sY)
            cx[6].From=Vector2.new(bx,by+sY); cx[6].To=Vector2.new(bx,by+sY-cL)
            cx[7].From=Vector2.new(bx+sX,by+sY); cx[7].To=Vector2.new(bx+sX-cL,by+sY)
            cx[8].From=Vector2.new(bx+sX,by+sY); cx[8].To=Vector2.new(bx+sX,by+sY-cL)
            for ci = 1, 8 do cx[ci].Color = W; cx[ci].Visible = showC end
        else
            e.box.Visible = false
            for ci = 1, 8 do e.corners[ci].Visible = false end
        end

        -- HP Bar
        local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local barH = math.max(1, sY * hp)
        local barX = bx - 7
        local hpCol = hp > 0.5 and Color3.fromRGB(0,220,0) or hp > 0.2 and Color3.fromRGB(255,165,0) or Color3.fromRGB(255,0,0)
        if Flags.ESPHPBar then
            e.hpbg.Size=Vector2.new(4,sY); e.hpbg.Position=Vector2.new(barX,by)
            e.hpbg.Color=Color3.fromRGB(0,0,0); e.hpbg.Visible=true
            e.hpbar.Color=hpCol; e.hpbar.Size=Vector2.new(4,barH)
            e.hpbar.Position=Vector2.new(barX, by + (sY - barH)); e.hpbar.Visible=true
            e.hpnum.Text=math.floor(hum.Health).."HP"
            e.hpnum.Size=11; e.hpnum.Position=Vector2.new(barX+2, by-1)
            e.hpnum.Center=false; e.hpnum.Color=hpCol; e.hpnum.Visible=true
        else
            e.hpbg.Visible=false; e.hpbar.Visible=false; e.hpnum.Visible=false
        end

        local distNow = localRoot and (root.Position - localRoot.Position).Magnitude or 100
        local tSize = math.clamp(math.floor(14 - distNow/40), 8, 14)

        if Flags.ESPName then
            e.dispname.Text = (p.DisplayName or p.Name).."(@"..p.Name..")"
            e.dispname.Size = tSize; e.dispname.Color = W
            e.dispname.Position = Vector2.new(pos3.X, by-14)
            e.dispname.Visible = true
        else e.dispname.Visible = false end

        local dist = localRoot and math.floor((root.Position - localRoot.Position).Magnitude) or 0
        local nY = by + sY + 3
        if Flags.ESPDist then
            e.dist.Text = dist.."m"; e.dist.Size = tSize
            e.dist.Color = W; e.dist.Position = Vector2.new(pos3.X, nY)
            e.dist.Visible = true; nY = nY + 13
        else e.dist.Visible = false end

        if Flags.ESPWeapon and cache.wName then
            e.weapon.Text = cache.wName
            e.weapon.Color = Color3.fromRGB(255,220,80)
            e.weapon.Position = Vector2.new(pos3.X, nY)
            e.weapon.Visible = true
        else e.weapon.Visible = false end

        if Flags.ESPMasak and cache.hasBahan then
            e.masak.Text = "MASAK"
            e.masak.Position = Vector2.new(bx+sX+4, by+sY/2-6)
            e.masak.Center = false
            e.masak.Visible = true
        else e.masak.Visible = false end

        local tracerDist = localRoot and (root.Position - localRoot.Position).Magnitude or 999
        if Flags.Tracer and tracerDist < TracerMaxDist then
            e.tracer.From = Vector2.new(vp.X/2, vp.Y)
            e.tracer.To = Vector2.new(pos3.X, by+sY)
            e.tracer.Color = W; e.tracer.Visible = true
        else e.tracer.Visible = false end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- LOGIC LOOPS
-- ══════════════════════════════════════════════════════════════

-- Inf Stamina
RunService:BindToRenderStep("DarkHubInfStamina", 0, function()
    if not Flags.InfStamina then return end
    pcall(function()
        local MC = require(plr.PlayerScripts["Client.Initializer"].Modules.MovementController)
        MC.Stamina = 100
    end)
end)

-- Speed Hack
local HS_ANIM = 22
local HS_FINAL = 25
local HS_PUSH = HS_FINAL - HS_ANIM
RunService.Heartbeat:Connect(function(dt)
    if not Flags.HybridSpeed then return end
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if hum.WalkSpeed ~= HS_ANIM then hum.WalkSpeed = HS_ANIM end
    if hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + hum.MoveDirection * HS_PUSH * dt
    end
end)

-- Restore walkspeed saat speed hack mati
task.spawn(function()
    local last = Flags.HybridSpeed
    while true do
        task.wait(0.2)
        if Flags.HybridSpeed ~= last then
            last = Flags.HybridSpeed
            if not last then
                pcall(function()
                    local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                    if h then h.WalkSpeed = 16 end
                end)
            end
        end
    end
end)

-- NoClip
RunService:BindToRenderStep("DarkHubNoClip", 400, function()
    if not Flags.AuraKill then return end
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CanCollide = false end)
        end
    end
end)

-- Blink TP (T key)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode == Enum.KeyCode.T then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
                {CFrame = hrp.CFrame * CFrame.new(0, 0, -6)}):Play()
        end
    end
end)

-- Instant Interact
game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
    if Flags.InstantInteract then
        pcall(function() if prompt.HoldDuration > 0 then prompt.HoldDuration = 0.05 end end)
    end
end)

-- Inv Scan (BillboardGui)
local Inv_Tags = {}
local function createInvTag(p)
    if Inv_Tags[p] or p == plr then return end
    local it = Instance.new("BillboardGui")
    it.Size = UDim2.new(0, 250, 0, 150)
    it.StudsOffset = Vector3.new(0, 4, 0)
    it.AlwaysOnTop = true
    it.Enabled = false
    it.Parent = CoreGui
    local lbl = Instance.new("TextLabel", it)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.TextStrokeTransparency = 0.5
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    Inv_Tags[p] = it
    p.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local h = char:FindFirstChild("Head")
        if h and Inv_Tags[p] then Inv_Tags[p].Adornee = h end
    end)
    local ch = p.Character
    if ch then
        local h = ch:FindFirstChild("Head")
        if h then it.Adornee = h end
    end
end
local function removeInvTag(p)
    if Inv_Tags[p] then Inv_Tags[p]:Destroy(); Inv_Tags[p] = nil end
end
for _, p in pairs(game.Players:GetPlayers()) do createInvTag(p) end
game.Players.PlayerAdded:Connect(function(p) task.wait(1); createInvTag(p) end)
game.Players.PlayerRemoving:Connect(removeInvTag)

task.spawn(function()
    while true do
        task.wait(2)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p == plr then continue end
            local it = Inv_Tags[p]
            if not it then continue end
            if _overlayActive then it.Enabled = false; continue end
            local ch = p.Character
            local head = ch and ch:FindFirstChild("Head")
            if Flags.InvScan and head then
                if it.Adornee ~= head then it.Adornee = head end
                it.Enabled = true
                pcall(function()
                    local held = "None"
                    local inv = {}
                    for _, v in pairs(ch:GetChildren()) do if v:IsA("Tool") then held = v.Name end end
                    for _, v in pairs(p.Backpack:GetChildren()) do table.insert(inv, "• "..v.Name) end
                    local lbl = it:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = "[HELD]: "..held.."\n\n[INV]:\n"..table.concat(inv, "\n") end
                end)
            else
                it.Enabled = false
            end
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- AUTO COOK MAIN LOOP
-- ══════════════════════════════════════════════════════════════
local function findCookPrompt()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bd = nil, math.huge
    local fb, fbd = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local part = obj.Parent
            local pp
            if part:IsA("Attachment") then pp = part.WorldPosition
            elseif part:IsA("BasePart") then pp = part.Position
            elseif part:IsA("Model") then
                local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                if rp then pp = rp.Position end
            end
            if not pp then continue end
            local d = (pp - hrp.Position).Magnitude
            if d > 30 then continue end
            local gp = (part and part.Parent and part.Parent.Name or ""):lower()
            local pn = part.Name:lower()
            local at = obj.ActionText:lower()
            local isCook = gp:find("cooking pot") or gp:find("pot") or pn:find("pot") or pn:find("cook")
                or at:find("cook") or at:find("interact") or at:find("add") or at:find("place")
                or at:find("use") or at:find("put")
            if isCook and d < bd then bd = d; best = obj end
            if d < 10 and d < fbd then fbd = d; fb = obj end
        end
    end
    return best or fb
end

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    pcall(function()
        local od = prompt.MaxActivationDistance
        local ol = prompt.RequiresLineOfSight
        prompt.MaxActivationDistance = 9999
        prompt.RequiresLineOfSight = false
        task.wait()
        fireproximityprompt(prompt)
        task.wait(0.05)
        prompt.MaxActivationDistance = od
        prompt.RequiresLineOfSight = ol
    end)
    return true
end

local function isCasinoApart()
    return selectedApart and selectedApart.name:lower():find("casino") ~= nil
end

local function snapToCookPos()
    if not selectedApart or not selectedApart.cx then return end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = CFrame.new(selectedApart.cx, selectedApart.cy, selectedApart.cz)
    local dist = (hrp.Position - target.Position).Magnitude
    if dist < 0.5 then return end
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist/10000, 0.05), Enum.EasingStyle.Linear), {CFrame=target})
    tw:Play(); tw.Completed:Wait()
end

local function snapToTopPos()
    if not selectedApart or not selectedApart.topCx then return end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(selectedApart.topCx, selectedApart.topCy, selectedApart.topCz)
    task.wait(0.1)
end

task.spawn(function()
    while true do
        task.wait(0.15)
        if not Flags.AutoCook then continue end

        if lastCookProgressTime > 0 and (tick() - lastCookProgressTime) > COOK_WATCHDOG_SECS then
            currentCookStep = 1
            lastCookProgressTime = tick()
        end

        local data = cookSteps[currentCookStep]
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        local function findTool(kw)
            for i = 1, 6 do
                if not Flags.AutoCook then return nil end
                if plr.Backpack then
                    for _, v in pairs(plr.Backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name:lower():find(kw) then return v end
                    end
                end
                if plr.Character then
                    for _, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("Tool") and v.Name:lower():find(kw) then return v end
                    end
                end
                task.wait(0.2)
            end
            return nil
        end

        if data.multi then
            local allOk = true
            for _, sub in ipairs(data.multi) do
                if not Flags.AutoCook then allOk=false; break end
                if isCasinoApart() then snapToCookPos(); task.wait(0.2)
                elseif selectedApart and selectedApart.cx then snapToCookPos(); task.wait(0.15) end
                local tool = findTool(sub.keyword)
                if not tool or not hum then allOk=false; break end
                task.wait(0.15)
                hum:EquipTool(tool)
                task.wait(0.15)
                local prompt = findCookPrompt()
                if prompt then triggerPrompt(prompt); task.wait(0.15) end
                if isCasinoApart() then snapToTopPos() end
                local wt = 0
                local hw = sub.wait + math.random(1,5)/10
                while wt < hw and Flags.AutoCook do
                    task.wait(0.4); wt = wt + 0.4
                end
            end
            if allOk and Flags.AutoCook then
                currentCookStep = currentCookStep + 1
                if currentCookStep > #cookSteps then currentCookStep = 1 end
                lastCookProgressTime = tick()
            end
        else
            local needDown = (data.keyword == "empty")
            if isCasinoApart() then snapToCookPos(); task.wait(0.2)
            elseif selectedApart and selectedApart.cx then snapToCookPos(); task.wait(0.15) end
            local tool = findTool(data.keyword)
            if tool and hum then
                task.wait(0.15)
                hum:EquipTool(tool)
                task.wait(0.15)
                local prompt = findCookPrompt()
                if prompt then
                    triggerPrompt(prompt)
                    task.wait(0.15)
                    if data.keyword == "empty" then
                        task.wait(0.15)
                        local p2 = findCookPrompt()
                        if p2 then triggerPrompt(p2) end
                    end
                end
                if isCasinoApart() and not needDown then snapToTopPos() end
                local hw = data.baseWait + math.random(1,5)/10
                local wt = 0
                while wt < hw and Flags.AutoCook do
                    task.wait(0.4); wt = wt + 0.4
                end
                if Flags.AutoCook then
                    if data.keyword == "empty" then
                        totalMasak = totalMasak + 1
                    end
                    currentCookStep = currentCookStep + 1
                    if currentCookStep > #cookSteps then currentCookStep = 1 end
                    lastCookProgressTime = tick()
                end
            else
                Flags.AutoCook = false
                Toggles.AutoCook:SetValue(false)
                Library:Notify({Title="Auto Cook", Description="Out of stock: "..data.keyword, Time=4})
            end
        end
    end
end)

-- Update status label tiap 1s
task.spawn(function()
    while true do
        task.wait(1)
        if totalMasak >= 0 then
            local stepName = "—"
            local d = cookSteps[currentCookStep]
            if d then
                if d.multi then stepName = "sugar+gelatin"
                else stepName = d.keyword end
            end
            CookInfo:SetText("Cooked: "..totalMasak.." | Step: "..stepName)
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ══════════════════════════════════════════════════════════════
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
end)

-- ══════════════════════════════════════════════════════════════
-- UNLOAD HANDLER
-- ══════════════════════════════════════════════════════════════
Library:OnUnload(function()
    for p in pairs(ESP) do removeESP(p) end
    for p in pairs(Inv_Tags) do removeInvTag(p) end
    pcall(function() FovCircle:Remove() end)
    pcall(function() SilentFovCircle:Remove() end)
    pcall(function() SilentLine:Remove() end)
    pcall(function() TPOverlay:Destroy() end)
    Flags.AutoCook = false
    AF.active = false
    CF2.active = false
    boxActive = false
    print("[DARK HUB] Unloaded!")
end)

-- ══════════════════════════════════════════════════════════════
-- LOADED NOTIFICATION
-- ══════════════════════════════════════════════════════════════
Library:Notify({
    Title = "DARK HUB Loaded!",
    Description = "Tekan RightShift untuk buka menu.\nDiscord: discord.gg/AbHhEACZC",
    Time = 6,
})