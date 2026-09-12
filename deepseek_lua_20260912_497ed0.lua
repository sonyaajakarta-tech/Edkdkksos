-- ================================================================
-- DARK HUB V3.0 — Kiwisense UI
-- ================================================================
local LoadingTick = os.clock()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/Kiwisense/Library.lua"))()

-- Services
local TweenService  = game:GetService("TweenService")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local Players       = game:GetService("Players")
local Http          = game:GetService("HttpService")
local ProximitySvc  = game:GetService("ProximityPromptService")
local VirtualUser   = game:GetService("VirtualUser")
local RS            = game:GetService("ReplicatedStorage")
local Lighting      = game:GetService("Lighting")
local plr           = Players.LocalPlayer

-- Anti-idle
plr.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================================================================
-- FLAGS & VARIABLES
-- ================================================================
local Flags = {
    BoxESP=false, Tracer=false,
    ESPName=true, ESPDist=true, ESPHPBar=true, ESPWeapon=true, ESPSkeleton=false, ESPMasak=true,
    TPNoClip=false, AimLock=false, WallCheck=false,
    InvScan=false, InstantInteract=false,
    AutoCook=false, InfStamina=false, HybridSpeed=false, AuraKill=false,
    SilentAim=false, SilentAimWallbang=false,
    ShowAimFOV=true, ShowSilentFOV=true,
}

local AimFOV_Radius    = 120
local SilentFOV_Radius = 120
local AimMax_Dist      = 300
local TracerMaxDist    = 300
local ESPMaxDist       = 500
local AimSmooth        = 0.85
local AimTarget        = nil
local AimPart          = "Head"
local AimMode          = "PC"
local BoxESPMode       = "FULL"
local BlinkMode        = "PC"
local SilentMode       = "PC"
local AimWhitelist     = {}
local AutoBuySettings  = { Enabled = false, Amount = 10, Mode = "PACK" }

local tpBusy      = false
local tpCancelled = false
local tpActive    = false
local _overlayActive = false
local Running     = true
local doSuicideTP, tpToPos

-- ================================================================
-- ESP SETUP
-- ================================================================
local ESP = {}
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5; FovCircle.Color = Color3.fromRGB(80, 150, 255)
FovCircle.Filled = false; FovCircle.NumSides = 64; FovCircle.Visible = false

local SilentFovCircle = Drawing.new("Circle")
SilentFovCircle.Thickness = 1.5; SilentFovCircle.Color = Color3.fromRGB(255, 100, 0)
SilentFovCircle.Filled = false; SilentFovCircle.NumSides = 64; SilentFovCircle.Visible = false

local SilentLine = Drawing.new("Line")
SilentLine.Thickness = 1.5; SilentLine.Color = Color3.fromRGB(255, 100, 0)
SilentLine.Transparency = 1; SilentLine.Visible = false

local function _mkLine(thick, col)
    local d = Drawing.new("Line"); d.Thickness=thick; d.Color=col; d.Visible=false; return d
end
local function _mkText(sz, col)
    local d = Drawing.new("Text"); d.Size=sz; d.Color=col; d.Outline=true
    d.OutlineColor=Color3.fromRGB(0,0,0); d.Center=true; d.Font=Drawing.Fonts.Plex; d.Visible=false; return d
end
local function _hideESP(e)
    e.box.Visible=false; e.hpbg.Visible=false; e.hpbar.Visible=false
    e.hpnum.Visible=false; e.dispname.Visible=false; e.username.Visible=false
    e.dist.Visible=false; e.weapon.Visible=false; e.masak.Visible=false; e.tracer.Visible=false
    for _,c in ipairs(e.corners) do c.Visible=false end
    for _,s in ipairs(e.skeleton) do s.Visible=false end
end
local function removeESP(p)
    if not ESP[p] then return end
    local _e = ESP[p]
    if _e.corners then for _,c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
    if _e.skeleton then for _,s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
    for k,d in pairs(_e) do
        if k~="corners" and k~="skeleton" then pcall(function() d:Remove() end) end
    end
    ESP[p]=nil
end
local function createESP(p)
    if ESP[p] or p == plr then return end
    local _c = {}
    for ci = 1, 8 do
        local cl = Drawing.new("Line"); cl.Thickness=2; cl.Color=Color3.fromRGB(255,255,255); cl.Visible=false; _c[ci] = cl
    end
    local _sk = {}
    for si = 1, 15 do
        local sl = Drawing.new("Line"); sl.Thickness=1.2; sl.Color=Color3.fromRGB(255,255,255); sl.Visible=false; _sk[si] = sl
    end
    local e = {
        box = Drawing.new("Square"),
        hpbg = Drawing.new("Square"),
        hpbar = Drawing.new("Square"),
        hpnum = _mkText(10, Color3.fromRGB(255,255,255)),
        dispname = _mkText(13, Color3.fromRGB(255,255,255)),
        username = _mkText(11, Color3.fromRGB(200,200,200)),
        dist = _mkText(11, Color3.fromRGB(180,180,180)),
        weapon = _mkText(11, Color3.fromRGB(255,220,80)),
        tracer = _mkLine(1.2, Color3.fromRGB(255,255,255)),
        masak = _mkText(13, Color3.fromRGB(0,255,80)),
        corners = _c, skeleton = _sk,
    }
    e.box.Thickness=1.5; e.box.Filled=false
    e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
    e.hpbar.Thickness=1; e.hpbar.Filled=true
    ESP[p] = e
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ESP Cache
local ESP_MASAK_KW = {"water","sugar","gelatin","marshmallow"}
local espCache, espConns = {}, {}
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
        if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") and isKW(v.Name) then hb = true end end end
        local ch = p.Character
        if ch then for _, v in ipairs(ch:GetChildren()) do
            if v:IsA("Tool") then if isKW(v.Name) then hb = true else wn = v.Name end end
        end end
    end)
    espCache[p] = {hasBahan = hb, wName = wn}
end
local function connectESPPlayer(p)
    if p == plr or espConns[p] then return end
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
    table.insert(conns, p.CharacterAdded:Connect(function(ch) task.wait(0.1); watchChar(ch) end))
end
for _, p in ipairs(Players:GetPlayers()) do connectESPPlayer(p) end
Players.PlayerAdded:Connect(connectESPPlayer)

-- RMB aimlock
local RMB = false
UIS.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then RMB = true end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then RMB = false; AimTarget = nil end
end)

-- ================================================================
-- TELEPORT DATA (ATM & HOMELESS REMOVED)
-- ================================================================
local TP_CATEGORIES = {
    {name = "Apartment", locs = {
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
    {name = "Others", locs = {
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

local APARTMENTS = {
    {name="Apt 1 Main", x=1142.93, y=10.10, z=453.42, lx=1144.22, ly=4.81, lz=443.35, rx=1145.58, ry=4.81, rz=453.44, side="L"},
    {name="Apt 2 Main", x=1142.9, y=10.10, z=424.90, lx=1145.47, ly=3.36, lz=421.24, rx=1145.58, ry=4.81, rz=425.46, side="L"},
    {name="Apt 3 Mid", x=984.06, y=10.10, z=245.47, lx=980.83, ly=3.36, lz=249.26, rx=981.39, ry=4.81, rz=244.9, side="L"},
    {name="Apt 4 Mid", x=984.02, y=10.10, z=216.83, lx=981.20, ly=3.36, lz=220.62, rx=981.97, ry=4.81, rz=219.16, side="L"},
    {name="Apt 5 West", x=928.82, y=10.10, z=38.43, lx=924.15, ly=3.36, lz=36.13, rx=928.6, ry=3.36, rz=35.91, side="L"},
    {name="Apt 6 West", x=900.62, y=10.10, z=38.39, lx=893.63, ly=3.36, lz=36.9, rx=900.79, ry=3.36, rz=37.24, side="L"},
    {name="Apt 7 Casino", x=1180.46, y=3.71, z=-193.92, lx=1182.30, ly=7.45, lz=-191.07, rx=1182.42, ry=7.56, rz=-188.66, side="L", topLx=1182.51, topLy=15.96, topLz=-191.75, topRx=1182.54, topRy=15.96, topRz=-188.08},
    {name="Apt 8 Casino", x=1202.21, y=3.71, z=-189.78, lx=1200.61, ly=7.80, lz=-179.03, rx=1200.42, ry=7.80, rz=-180.42, side="L", topLx=1200.27, topLy=15.96, topLz=-178.01, topRx=1200.29, topRy=15.96, topRz=-181.31},
    {name="Apt 9 Casino", x=1180.47, y=3.71, z=-222.41, lx=1182.72, ly=7.56, lz=-229.21, rx=1182.84, ry=7.56, rz=-226.89, side="L", topLx=1182.76, topLy=15.96, topLz=-229.35, topRx=1182.65, topRy=15.96, topRz=-227.35},
    {name="Apt 10 Casino", x=1202.08, y=3.71, z=-222.91, lx=1200.68, ly=7.53, lz=-217.65, rx=1200.72, ry=7.53, rz=-219.78, side="L", topLx=1200.00, topLy=15.96, topLz=-217.06, topRx=1199.99, topRy=15.96, topRz=-220.03},
}

-- updateApartCook
local function updateApartCook(apart)
    if apart.side == "R" and apart.rx then
        apart.cx=apart.rx; apart.cy=apart.ry; apart.cz=apart.rz
    elseif apart.lx then
        apart.cx=apart.lx; apart.cy=apart.ly; apart.cz=apart.lz
    else
        apart.cx=nil; apart.cy=nil; apart.cz=nil
    end
    if apart.side == "R" and apart.topRx then
        apart.topCx=apart.topRx; apart.topCy=apart.topRy; apart.topCz=apart.topRz
    elseif apart.topLx then
        apart.topCx=apart.topLx; apart.topCy=apart.topLy; apart.topCz=apart.topLz
    else
        apart.topCx=nil; apart.topCy=nil; apart.topCz=nil
    end
end
for _, a in ipairs(APARTMENTS) do updateApartCook(a) end

-- ================================================================
-- TELEPORT / VEHICLE / FARM HELPERS
-- ================================================================
local function doVehicleTP(targetCFrame)
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat then return false end
    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return false end
    local vRoot = vehicle.PrimaryPart or seat
    vRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    vRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    vehicle:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
    task.wait(0.1)
    vRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    vRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    return true
end

local UNDERGROUND_Y = -4.00
local TP_SPEED = 16

local function resetHumanoid()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end
    if hum then
        hum.Sit = false; task.wait(0.05)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end); task.wait(0.1)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

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

-- Simple TP overlay (menggantikan overlay kompleks)
local TPOverlayGui = Instance.new("ScreenGui")
TPOverlayGui.Name = "DARKHUB_TPOverlay"
TPOverlayGui.ResetOnSpawn = false
TPOverlayGui.DisplayOrder = 5
TPOverlayGui.IgnoreGuiInset = true
TPOverlayGui.Enabled = false
TPOverlayGui.Parent = game:GetService("CoreGui")

local OvBG = Instance.new("Frame", TPOverlayGui)
OvBG.Size = UDim2.new(1, 0, 1, 0)
OvBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OvBG.BackgroundTransparency = 0
OvBG.BorderSizePixel = 0

local OvTitle = Instance.new("TextLabel", OvBG)
OvTitle.Size = UDim2.new(0, 300, 0, 80)
OvTitle.AnchorPoint = Vector2.new(0.5, 0.5)
OvTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
OvTitle.BackgroundTransparency = 1
OvTitle.Text = "WAIT"
OvTitle.TextColor3 = Color3.fromRGB(80, 150, 255)
OvTitle.Font = Enum.Font.GothamBlack
OvTitle.TextSize = 64
OvTitle.TextStrokeTransparency = 0
OvTitle.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

local OvSub = Instance.new("TextLabel", OvBG)
OvSub.Size = UDim2.new(0, 400, 0, 20)
OvSub.AnchorPoint = Vector2.new(0.5, 0)
OvSub.Position = UDim2.new(0.5, 0, 0.5, 50)
OvSub.BackgroundTransparency = 1
OvSub.Text = "Teleporting, please wait..."
OvSub.TextColor3 = Color3.fromRGB(130, 130, 130)
OvSub.Font = Enum.Font.Gotham
OvSub.TextSize = 13

local function showTPOverlay() _overlayActive = true; TPOverlayGui.Enabled = true end
local function hideTPOverlay() _overlayActive = false; TPOverlayGui.Enabled = false end

tpToPos = function(cx, cy, cz, _unused, destName)
    if tpActive then return end
    tpActive = true; tpCancelled = false
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then tpActive = false; return end
    showTPOverlay()
    local underPos = Vector3.new(hrp.Position.X, UNDERGROUND_Y, hrp.Position.Z)
    local ok = lerpChar(hrp.Position, underPos, TP_SPEED)
    if ok and not tpCancelled then
        local h2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if h2 then ok = lerpChar(h2.Position, Vector3.new(cx, UNDERGROUND_Y, cz), TP_SPEED) else ok=false end
    end
    if ok and not tpCancelled then
        local h3 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if h3 then lerpChar(h3.Position, Vector3.new(cx, cy + 3, cz), TP_SPEED) end
    end
    hideTPOverlay()
    resetHumanoid()
    tpActive = false
end

local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)
doSuicideTP = function(loc)
    tpBusy = true
    showTPOverlay()
    local ch = plr.Character
    local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp0 then tpBusy=false; hideTPOverlay(); return end
    hrp0.CFrame = CFrame.new(RESPAWN_WARP)
    local newChar = plr.CharacterAdded:Wait()
    local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
    local hum = newChar:WaitForChild("Humanoid", 10)
    if not hrp or not hum then tpBusy=false; hideTPOverlay(); return end
    local waited = 0
    while hum.Health <= 0 and waited < 5 do task.wait(0.1); waited += 0.1 end
    task.wait(0.8)
    local targetCF = CFrame.new(loc.x, loc.y + 3, loc.z)
    for _ = 1, 4 do hrp.CFrame = targetCF; task.wait(0.15) end
    task.wait(0.1)
    hideTPOverlay()
    tpBusy = false
end

-- ================================================================
-- AUTO COOK / FARM HELPERS
-- ================================================================
local totalMasak = 0
local currentCookStep = 1
local lastCookProgressTime = 0
local COOK_WATCHDOG_SECS = 150

local cookSteps = {
    {keyword="water", baseWait=20},
    {multi = {{keyword="sugar", wait=1.5}, {keyword="gelatin", wait=45}}},
    {keyword="empty", baseWait=2},
}

-- setApart56FloorCollide
local function setApart56FloorCollide(state)
    local function setObj(obj)
        pcall(function()
            if obj:IsA("BasePart") then obj.CanCollide = state end
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = state end
            end
        end)
    end
    pcall(function()
        local lt1 = workspace.Map.Houses.LT1.Interior
        setObj(lt1.Floor); setObj(lt1.Stove); setObj(lt1.Part)
        setObj(lt1:GetChildren()[22]); setObj(lt1:GetChildren()[23]); setObj(lt1:GetChildren()[32])
    end)
    pcall(function()
        local bh1 = workspace.Map.Houses.BH1.Interior
        setObj(bh1.Floor); setObj(bh1.Stove); setObj(bh1.Part)
        setObj(bh1:GetChildren()[22]); setObj(bh1:GetChildren()[23]); setObj(bh1:GetChildren()[32])
    end)
end

local selectedApart = nil
local function getPromptPosition(prompt)
    local part = prompt.Parent
    if part:IsA("Attachment") then return part.WorldPosition, part.Parent
    elseif part:IsA("BasePart") then return part.Position, part
    elseif part:IsA("Model") then
        local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
        if rp then return rp.Position, rp end
    end
    return nil, nil
end

local function findCookPrompt()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    local fallback, fallbackDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local pos = getPromptPosition(obj)
            if not pos then continue end
            local dist = (pos - hrp.Position).Magnitude
            if dist > 30 then continue end
            local parent = obj.Parent
            local gp = (parent and parent.Parent and parent.Parent.Name or ""):lower()
            local pn = parent.Name:lower()
            local at = obj.ActionText:lower()
            local isCook = gp:find("cooking pot") or gp:find("pot") or pn:find("pot") or pn:find("cook")
                or at:find("cook") or at:find("interact") or at:find("add") or at:find("place")
                or at:find("use") or at:find("put")
            if isCook and dist < bestDist then bestDist = dist; best = obj end
            if dist < 10 and dist < fallbackDist then fallbackDist = dist; fallback = obj end
        end
    end
    return best or fallback
end

local function triggerPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    pcall(function()
        local origDist = prompt.MaxActivationDistance
        local origLOS = prompt.RequiresLineOfSight
        prompt.MaxActivationDistance = 9999
        prompt.RequiresLineOfSight = false
        task.wait()
        fireproximityprompt(prompt)
        task.wait(0.05)
        prompt.MaxActivationDistance = origDist
        prompt.RequiresLineOfSight = origLOS
    end)
    return true
end

local function isCasinoApart()
    return selectedApart and selectedApart.name:lower():find("casino") ~= nil
end

local function snapToCookPos()
    if not selectedApart or not selectedApart.cx then return end
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local targetCF = CFrame.new(selectedApart.cx, selectedApart.cy, selectedApart.cz)
    local dist = (hrp.Position - targetCF.Position).Magnitude
    if dist < 0.5 then return end
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist / 10000, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = targetCF})
    tw:Play(); tw.Completed:Wait()
end

local function snapToTopPos()
    if not selectedApart or not selectedApart.topCx then return end
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(selectedApart.topCx, selectedApart.topCy, selectedApart.topCz)
    task.wait(0.1)
end

-- Auto buy helpers
local function abGetMoney()
    local MONEY_KEYS = {"Money","Cash","Coins","Dollars","Credits","Currency","Gold","Bucks","Pat"}
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        for _, key in ipairs(MONEY_KEYS) do
            local v = ls:FindFirstChild(key)
            if v and (v:IsA("IntValue") or v:IsA("NumberValue")) then return v.Value, key end
        end
        for _, v in pairs(ls:GetChildren()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") then return v.Value, v.Name end
        end
    end
    return nil, nil
end

local function abCountItem(name)
    local n = 0
    for _, t in ipairs(plr.Backpack:GetChildren()) do if t.Name == name then n += 1 end end
    local ch = plr.Character
    if ch then for _, t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t.Name == name then n += 1 end end end
    return n
end

local abBusy = false
local abCancelled = false
local abStatusLbl -- set by UI

local function doRemoteBuy(itemNames, qty)
    task.spawn(function()
        local remEvts = RS:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then
            if abStatusLbl then abStatusLbl.Text = "RemoteEvent tidak ada!" end
            abBusy = false; return
        end
        local totalBought = 0
        for _, itemName in ipairs(itemNames) do
            if abCancelled then break end
            local before = abCountItem(itemName)
            for i = 1, qty do
                if abCancelled then break end
                pcall(function() spRE:FireServer(itemName, 1) end)
                task.wait(0.4)
            end
            local elapsed, gained = 0, 0
            repeat
                if abCancelled then break end
                task.wait(0.2); elapsed += 0.2
                gained = abCountItem(itemName) - before
            until gained >= qty or elapsed > 8
            totalBought += gained
        end
        if abStatusLbl then abStatusLbl.Text = "Selesai! " .. totalBought .. " item" end
        abBusy = false; abCancelled = false
    end)
end

-- ================================================================
-- RENDER LOOP (ESP + AIMBOT)
-- ================================================================
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
    if not Running then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local mousePos = UIS:GetMouseLocation()
    local localChar = plr.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    if _overlayActive then
        FovCircle.Visible = false
        SilentFovCircle.Visible = false
        SilentLine.Visible = false
        for _, e in pairs(ESP) do _hideESP(e) end
        return
    end

    local fovCenter = (AimMode == "HP") and Vector2.new(vp.X/2, vp.Y/2) or mousePos
    FovCircle.Radius = AimFOV_Radius
    FovCircle.Visible = Flags.AimLock and Flags.ShowAimFOV

    -- Silent aim circle
    if Flags.SilentAim then
        local saOrigin = SilentMode == "HP" and Vector2.new(vp.X/2, vp.Y/2) or mousePos
        local bestWorldD, bestScreenPos = math.huge, nil
        for _, p in pairs(Players:GetPlayers()) do
            if p == plr then continue end
            local ch = p.Character
            if not ch then continue end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local part = ch:FindFirstChild(AimPart == "Head" and "Head" or "HumanoidRootPart")
            if not part or not hum or hum.Health <= 0 then continue end
            local sp, onScreen = cam:WorldToViewportPoint(part.Position)
            if not onScreen or sp.Z <= 0 then continue end
            if (saOrigin - Vector2.new(sp.X, sp.Y)).Magnitude > SilentFOV_Radius then continue end
            local worldD = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
            if worldD < bestWorldD then bestWorldD = worldD; bestScreenPos = Vector2.new(sp.X, sp.Y) end
        end
        if bestScreenPos then
            SilentFovCircle.Position = (SilentMode == "HP") and bestScreenPos or saOrigin
            SilentFovCircle.Radius = SilentFOV_Radius
            SilentFovCircle.Visible = Flags.ShowSilentFOV
            SilentLine.From = saOrigin
            SilentLine.To = bestScreenPos
            SilentLine.Visible = Flags.ShowSilentFOV
        else
            SilentFovCircle.Position = saOrigin
            SilentFovCircle.Radius = SilentFOV_Radius
            SilentFovCircle.Visible = Flags.ShowSilentFOV
            SilentLine.Visible = false
        end
    else
        SilentFovCircle.Visible = false
        SilentLine.Visible = false
    end

    if AimTarget then
        local tHum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not tHum or tHum.Health <= 0 then AimTarget = nil end
    end

    if AimTarget and AimMode == "PC" then
        local sp, onScreen = cam:WorldToScreenPoint(AimTarget.Position)
        if not onScreen then AimTarget = nil
        else
            local d = math.sqrt((sp.X - fovCenter.X)^2 + (sp.Y - fovCenter.Y)^2)
            if d > AimFOV_Radius then AimTarget = nil end
        end
    end

    local shouldAim = Flags.AimLock and localRoot and (AimMode == "HP" or RMB)
    if shouldAim then
        if AimMode == "HP" or not AimTarget then
            local bestDist, bestPart = math.huge, nil
            for _, p in pairs(Players:GetPlayers()) do
                if p == plr or AimWhitelist[p.Name] then continue end
                local ch = p.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local targetPart = ch and ch:FindFirstChild(AimPart == "Head" and "Head" or "HumanoidRootPart")
                if not targetPart or not hum or hum.Health <= 0 then continue end
                if (targetPart.Position - localRoot.Position).Magnitude > AimMax_Dist then continue end
                local sp, onScreen = cam:WorldToScreenPoint(targetPart.Position)
                if not onScreen then continue end
                if Flags.WallCheck then
                    local camPos = cam.CFrame.Position
                    local dir = targetPart.Position - camPos
                    wpRayParams.FilterDescendantsInstances = {cam, plr.Character}
                    local hit = workspace:Raycast(camPos, dir.Unit * dir.Magnitude, wpRayParams)
                    if hit and not hit.Instance:IsDescendantOf(ch) then continue end
                end
                local d = math.sqrt((sp.X - fovCenter.X)^2 + (sp.Y - fovCenter.Y)^2)
                if d <= AimFOV_Radius and d < bestDist then bestDist = d; bestPart = targetPart end
            end
            AimTarget = bestPart
        end
        if AimTarget then
            local targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCF, AimSmooth)
            FovCircle.Color = Color3.fromRGB(220,50,50)
        else
            FovCircle.Color = Color3.fromRGB(80,150,255)
        end
    else
        if AimMode == "PC" and not RMB then AimTarget = nil end
        FovCircle.Color = Color3.fromRGB(80,150,255)
    end

    if AimMode == "HP" and AimTarget then
        local sp2, vis2 = cam:WorldToViewportPoint(AimTarget.Position)
        if vis2 and sp2.Z > 0 then FovCircle.Position = Vector2.new(sp2.X, sp2.Y) else FovCircle.Position = fovCenter end
    else
        FovCircle.Position = fovCenter
    end

    -- ESP render
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

        -- skeleton
        if Flags.ESPSkeleton and ch then
            local W2 = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)
            for si, bone in ipairs(SKEL_BONES) do
                local p1 = ch:FindFirstChild(bone[1])
                local p2 = ch:FindFirstChild(bone[2])
                local sk = e.skeleton[si]
                if p1 and p2 then
                    local s1, v1 = cam:WorldToViewportPoint(p1.Position)
                    local s2, v2 = cam:WorldToViewportPoint(p2.Position)
                    if v1 and v2 and s1.Z>0 and s2.Z>0 then
                        sk.From = Vector2.new(s1.X, s1.Y); sk.To = Vector2.new(s2.X, s2.Y)
                        sk.Color = W2; sk.Visible = true
                    else sk.Visible = false end
                else sk.Visible = false end
            end
        else
            for _, s in ipairs(e.skeleton) do s.Visible = false end
        end

        local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
        local sY = math.abs(botPos.Y - topPos.Y)
        local sX = sY * 0.6
        local bx = pos3.X - sX/2
        local by = math.min(topPos.Y, botPos.Y)

        local cache = espCache[p] or {hasBahan=false, wName=nil}
        local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)

        if Flags.BoxESP then
            e.box.Color = W; e.box.Size = Vector2.new(sX, sY)
            e.box.Position = Vector2.new(bx, by)
            e.box.Visible = (BoxESPMode == "FULL")
            local showC = (BoxESPMode == "CORNER")
            local cL = math.min(sX, sY)*0.25
            local cx = e.corners
            cx[1].From=Vector2.new(bx,by); cx[1].To=Vector2.new(bx+cL,by)
            cx[2].From=Vector2.new(bx,by); cx[2].To=Vector2.new(bx,by+cL)
            cx[3].From=Vector2.new(bx+sX,by); cx[3].To=Vector2.new(bx+sX-cL,by)
            cx[4].From=Vector2.new(bx+sX,by); cx[4].To=Vector2.new(bx+sX,by+cL)
            cx[5].From=Vector2.new(bx,by+sY); cx[5].To=Vector2.new(bx+cL,by+sY)
            cx[6].From=Vector2.new(bx,by+sY); cx[6].To=Vector2.new(bx,by+sY-cL)
            cx[7].From=Vector2.new(bx+sX,by+sY); cx[7].To=Vector2.new(bx+sX-cL,by+sY)
            cx[8].From=Vector2.new(bx+sX,by+sY); cx[8].To=Vector2.new(bx+sX,by+sY-cL)
            for ci=1,8 do cx[ci].Color=W; cx[ci].Visible=showC end
        else
            e.box.Visible=false
            for ci=1,8 do e.corners[ci].Visible=false end
        end

        local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local barH = math.max(1, sY*hp)
        local barX = bx - 7
        local hpCol = hp>0.5 and Color3.fromRGB(0,220,0) or hp>0.2 and Color3.fromRGB(255,165,0) or Color3.fromRGB(255,0,0)
        if Flags.ESPHPBar then
            e.hpbg.Size=Vector2.new(4,sY); e.hpbg.Position=Vector2.new(barX,by)
            e.hpbg.Color=Color3.fromRGB(0,0,0); e.hpbg.Filled=false; e.hpbg.Thickness=1; e.hpbg.Visible=true
            e.hpbar.Color=hpCol; e.hpbar.Size=Vector2.new(4,barH)
            e.hpbar.Position=Vector2.new(barX,by+(sY-barH)); e.hpbar.Filled=true; e.hpbar.Visible=true
            e.hpnum.Text=math.floor(hum.Health).."HP"; e.hpnum.Size=11
            e.hpnum.Position=Vector2.new(barX+2,by-1); e.hpnum.Center=false
            e.hpnum.Color=hpCol; e.hpnum.Visible=true
        else
            e.hpbg.Visible=false; e.hpbar.Visible=false; e.hpnum.Visible=false
        end

        local distNow = localRoot and (root.Position-localRoot.Position).Magnitude or 100
        local tSize = math.clamp(math.floor(14 - distNow/40), 8, 14)

        if Flags.ESPName then
            e.dispname.Text = (p.DisplayName or p.Name).."(@"..p.Name..")"
            e.dispname.Size = tSize; e.dispname.Color = W
            e.dispname.Position = Vector2.new(pos3.X, by-14)
            e.dispname.Visible = true
            e.username.Visible = false
        else e.dispname.Visible=false; e.username.Visible=false end

        local dist = localRoot and math.floor((root.Position-localRoot.Position).Magnitude) or 0
        local nY = by+sY+3
        if Flags.ESPDist then
            e.dist.Text = dist.."m"; e.dist.Size = tSize; e.dist.Color = W
            e.dist.Position = Vector2.new(pos3.X, nY); e.dist.Visible = true
            nY = nY + 13
        else e.dist.Visible=false end
        if Flags.ESPWeapon and cache.wName then
            e.weapon.Text=cache.wName; e.weapon.Color=Color3.fromRGB(255,220,80)
            e.weapon.Position=Vector2.new(pos3.X,nY); e.weapon.Visible=true
        else e.weapon.Visible=false end
        if Flags.ESPMasak and cache.hasBahan then
            e.masak.Text="MASAK"; e.masak.Position=Vector2.new(bx+sX+4,by+sY/2-6)
            e.masak.Center=false; e.masak.Visible=true
        else e.masak.Visible=false end
        local tracerDist = localRoot and (root.Position-localRoot.Position).Magnitude or 999
        if Flags.Tracer and tracerDist < TracerMaxDist then
            local vp2 = cam.ViewportSize
            e.tracer.From = Vector2.new(vp2.X/2, vp2.Y)
            e.tracer.To = Vector2.new(pos3.X, by+sY)
            e.tracer.Color = W; e.tracer.Visible = true
        else e.tracer.Visible=false end
    end
end)

-- ================================================================
-- STAMINA / SPEED / NOCLIP / BLINK / INTERACT
-- ================================================================
RunService:BindToRenderStep("DARKHUB_InfStamina", 0, function()
    if not Flags.InfStamina then return end
    pcall(function()
        local MovCtrl = require(plr.PlayerScripts["Client.Initializer"].Modules.MovementController)
        MovCtrl.Stamina = 100
    end)
end)

RunService.Heartbeat:Connect(function(dt)
    if Flags.HybridSpeed then
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            if hum.WalkSpeed ~= 22 then hum.WalkSpeed = 22 end
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + hum.MoveDirection * 3 * dt
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Flags.AuraKill then
        local char = plr.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode == Enum.KeyCode.T then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
                {CFrame = hrp.CFrame * CFrame.new(0, 0, -6)}):Play()
        end
    end
end)

ProximitySvc.PromptShown:Connect(function(prompt)
    if Flags.InstantInteract then
        pcall(function() if prompt.HoldDuration > 0 then prompt.HoldDuration = 0.05 end end)
    end
end)

-- ================================================================
-- SILENT AIM HOOK
-- ================================================================
task.spawn(function()
    local function searchGc(fname)
        local ok, gc = pcall(getgc)
        if not ok then return nil end
        for _, v in pairs(gc) do
            if type(v) == "function" then
                local ok2, info = pcall(debug.getinfo, v)
                if ok2 and info and info.name == fname then return v end
            end
        end
    end
    local tries = 0
    while tries < 30 do
        task.wait(1); tries = tries + 1
        local cb = searchGc("CastBlacklist")
        local cw = searchGc("CastWhitelist")
        if cb and cw then
            local OldCast = hookfunction(cb, function(...)
                if not Flags.SilentAim then return OldCast(...) end
                local cam = workspace.CurrentCamera
                local vp2 = cam.ViewportSize
                local saFovCenter = SilentMode == "HP" and Vector2.new(vp2.X/2, vp2.Y/2) or UIS:GetMouseLocation()
                local Target, LowestDist = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    local ch = p.Character
                    if p == plr or not ch then continue end
                    local hitPart = ch:FindFirstChild(AimPart == "Head" and "Head" or "HumanoidRootPart")
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if not hitPart or not hrp or not hum or hum.Health <= 0 then continue end
                    local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    if not onScreen then continue end
                    local d = (saFovCenter - Vector2.new(sp.X, sp.Y)).Magnitude
                    if d < SilentFOV_Radius and d < LowestDist then Target = p; LowestDist = d end
                end
                if Target then
                    local args = {...}
                    local hitPart = Target.Character and Target.Character:FindFirstChild(AimPart == "Head" and "Head" or "HumanoidRootPart")
                    if hitPart then
                        args[2] = hitPart.Position - args[1]
                        if Flags.SilentAimWallbang then
                            args[3] = {Target.Character}
                            return cw(table.unpack(args))
                        end
                    end
                    return OldCast(table.unpack(args))
                end
                return OldCast(...)
            end)
            break
        end
    end
end)

-- ================================================================
-- AUTO COOK LOOP
-- ================================================================
task.spawn(function()
    while Running do
        task.wait(math.random(10,20)/100)
        if Flags.AutoCook then
            -- watchdog
            if lastCookProgressTime > 0 and (tick() - lastCookProgressTime) > COOK_WATCHDOG_SECS then
                currentCookStep = 1; lastCookProgressTime = tick()
            end

            local data = cookSteps[currentCookStep]
            local ch = plr.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")

            local function findTool(keyword)
                local t = nil
                for i = 1, 6 do
                    if not Flags.AutoCook or not Running then break end
                    if plr.Backpack then
                        for _, v in pairs(plr.Backpack:GetChildren()) do
                            if string.find(string.lower(v.Name), keyword) then t = v; break end
                        end
                    end
                    if not t and plr.Character then
                        for _, v in pairs(plr.Character:GetChildren()) do
                            if v:IsA("Tool") and string.find(string.lower(v.Name), keyword) then t = v; break end
                        end
                    end
                    if t then break end
                    task.wait(0.2)
                end
                return t
            end

            local function doBahan(keyword, waitTime, needDown)
                local hm = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                local tool = findTool(keyword)
                if not tool or not hm then return false end
                if isCasinoApart() then snapToCookPos(); task.wait(0.2)
                elseif selectedApart and selectedApart.cx then snapToCookPos(); task.wait(0.15) end
                task.wait(math.random(1,2)/10)
                hm:EquipTool(tool)
                task.wait(math.random(1,2)/10)
                local prompt = findCookPrompt()
                if prompt then triggerPrompt(prompt); task.wait(math.random(1,2)/10) end
                if isCasinoApart() and not needDown then snapToTopPos() end
                local tw = 0
                local hw = waitTime + (math.random(1,5)/10)
                while tw < hw and Flags.AutoCook and Running do
                    task.wait(math.random(3,5)/10)
                    tw = tw + 0.4
                end
                return true
            end

            if data.multi then
                local allOk = true
                for _, sub in ipairs(data.multi) do
                    if not Flags.AutoCook or not Running then allOk = false; break end
                    local ok = doBahan(sub.keyword, sub.wait, false)
                    if not ok then
                        Flags.AutoCook = false; allOk = false; break
                    end
                end
                if allOk and Flags.AutoCook and Running then
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
                    task.wait(math.random(1,2)/10)
                    hum:EquipTool(tool)
                    task.wait(math.random(1,2)/10)
                    local prompt = findCookPrompt()
                    if prompt then
                        triggerPrompt(prompt); task.wait(math.random(1,2)/10)
                        if data.keyword == "empty" then
                            task.wait(math.random(1,2)/10)
                            local p2 = findCookPrompt()
                            if p2 then triggerPrompt(p2) end
                        end
                    end
                    if isCasinoApart() and not needDown then snapToTopPos() end
                    local hw = data.baseWait + (math.random(1,5)/10)
                    local tw = 0
                    while tw < hw and Flags.AutoCook and Running do
                        task.wait(math.random(3,5)/10); tw = tw + 0.4
                    end
                    if Flags.AutoCook and Running then
                        if data.keyword == "empty" then totalMasak = totalMasak + 1 end
                        currentCookStep = currentCookStep + 1
                        if currentCookStep > #cookSteps then currentCookStep = 1 end
                        lastCookProgressTime = tick()
                    end
                else
                    Flags.AutoCook = false
                end
            end
        end
    end
end)

-- ================================================================
-- UI STRUCTURE (Kiwisense)
-- ================================================================
local Window = Library:Window({
    Name = "DARK HUB",
    Version = "v3.0",
    Logo = "135215559087473",
    FadeSpeed = 0.25,
})

local ESPPreview = Library:ESPPreview({ MainFrame = Window.Items["MainFrame"] })
local ChatSystem = Library:ChatSystem({ MainFrame = Window.Items["MainFrame"] })
local Watermark = Library:Watermark("DARK HUB v3.0", "135215559087473")
Watermark:SetVisibility(false)
local KeybindList = Library:KeybindsList()
KeybindList:SetVisibility(false)

-- ================================================================
-- PAGES
-- ================================================================
local Pages = {
    ["Main"]     = Window:Page({ Name = "main",     Icon = "111178525804834", Columns = 2 }),
    ["Visual"]   = Window:Page({ Name = "visual",   Icon = "115907015044719", Columns = 2 }),
    ["Aim"]      = Window:Page({ Name = "aim",      Icon = "111386589037485", Columns = 2 }),
    ["Farm"]     = Window:Page({ Name = "farm",     Icon = "136623465713368", Columns = 2, SubPages = true }),
    ["TP"]       = Window:Page({ Name = "tp",       Icon = "109463522861706", Columns = 2 }),
    ["Vehicle"]  = Window:Page({ Name = "vehicle",  Icon = "126028986879491", Columns = 2 }),
    ["Info"]     = Window:Page({ Name = "info",     Icon = "103174889897193", Columns = 1 }),
    ["Config"]   = Window:Page({ Name = "config",   Icon = "137300573942266", Columns = 2 }),
}

-- ================================================================
-- MAIN PAGE
-- ================================================================
do
    local MainSection   = Pages["Main"]:Section({ Name = "Quick Toggles", Icon = "103174889897193", Side = 1 })
    local FakeNameSec   = Pages["Main"]:Section({ Name = "Fake Name",     Icon = "135799335731002", Side = 2 })
    local GrafikSec     = Pages["Main"]:Section({ Name = "Graphics",      Icon = "136623465713368", Side = 2 })

    -- Quick toggles
    MainSection:Toggle({
        Name = "NoClip",
        Flag = "AuraKill",
        Default = false,
        Callback = function(v) Flags.AuraKill = v end
    })

    MainSection:Toggle({
        Name = "Infinite Stamina",
        Flag = "InfStamina",
        Default = false,
        Callback = function(v) Flags.InfStamina = v end
    })

    MainSection:Toggle({
        Name = "Speed Hack",
        Flag = "HybridSpeed",
        Default = false,
        Callback = function(v) Flags.HybridSpeed = v end
    })

    MainSection:Toggle({
        Name = "Instant Interact",
        Flag = "InstantInteract",
        Default = false,
        Callback = function(v) Flags.InstantInteract = v end
    })

    MainSection:Toggle({
        Name = "Inventory Scan",
        Flag = "InvScan",
        Default = false,
        Callback = function(v) Flags.InvScan = v end
    })

    MainSection:Toggle({
        Name = "Blink TP",
        Flag = "TPNoClip",
        Default = false,
        Callback = function(v) Flags.TPNoClip = v end
    }):Keybind({
        Name = "Blink Keybind",
        Flag = "BlinkKeybind",
        Default = Enum.KeyCode.T,
        Mode = "hold",
        Callback = function() end
    })

    MainSection:Dropdown({
        Name = "Blink Mode",
        Flag = "BlinkMode",
        Items = {"PC", "HP"},
        Default = "PC",
        MaxSize = 60,
        Callback = function(v) BlinkMode = v end
    })

    -- Fake Name
    local fnName1, fnName2
    FakeNameSec:Textbox({
        Name = "In-Game Name",
        Flag = "FakeName1",
        Placeholder = "Enter name...",
        Default = "",
        Callback = function(v) fnName1 = v end
    })
    FakeNameSec:Textbox({
        Name = "Username",
        Flag = "FakeName2",
        Placeholder = "Enter username...",
        Default = "",
        Callback = function(v) fnName2 = v end
    })
    FakeNameSec:Button({
        Name = "Apply Fake Name",
        Callback = function()
            pcall(function()
                local char = plr.Character
                local myChar = (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(plr.Name)) or char
                if not myChar then return end
                if fnName1 and fnName1 ~= "" then
                    local tag1 = myChar.Head and myChar.Head:FindFirstChild("NameTag")
                    if tag1 then
                        local lbl = tag1:FindFirstChild("MainFrame") and tag1.MainFrame:FindFirstChild("NameLabel")
                        if lbl then lbl.Text = fnName1 end
                    end
                end
                if fnName2 and fnName2 ~= "" then
                    local tag2 = myChar.Head and myChar.Head:FindFirstChild("RankTag")
                    if tag2 then
                        local lbl = tag2:FindFirstChild("MainFrame") and tag2.MainFrame:FindFirstChild("NameLabel")
                        if lbl then lbl.Text = fnName2 end
                    end
                end
            end)
        end
    })

    -- Reduce Grafik
    GrafikSec:Button({
        Name = "⚠ Reduce Grafik",
        Callback = function()
            task.spawn(function()
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") then pcall(function() v:Destroy() end) end
                end
                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.Brightness = 2
                end)
                local localChar = plr.Character
                for _, v in ipairs(workspace:GetDescendants()) do
                    pcall(function()
                        if v:IsA("BasePart") and not (localChar and v:IsDescendantOf(localChar)) then
                            v.Material = Enum.Material.SmoothPlastic
                            v.Reflectance = 0
                        end
                        if (v:IsA("Texture") or v:IsA("Decal")) and not (localChar and v:IsDescendantOf(localChar)) then
                            v.Transparency = 1
                        end
                    end)
                end
                pcall(function()
                    local terrain = workspace:FindFirstChild("Terrain")
                    if terrain then
                        terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0
                        terrain.WaterReflectance = 0; terrain.WaterTransparency = 1
                    end
                end)
                pcall(function()
                    settings().Rendering.QualityLevel = 1
                    settings().Rendering.TextureQuality = Enum.TextureQuality.Low
                end)
            end)
        end
    })
end

-- ================================================================
-- VISUAL PAGE
-- ================================================================
do
    local ESP_Section     = Pages["Visual"]:Section({ Name = "ESP",            Icon = "135799335731002", Side = 1 })
    local Wall_Section    = Pages["Visual"]:Section({ Name = "Wall Selector",  Icon = "103174889897193", Side = 2 })

    -- ESP toggles
    ESP_Section:Toggle({
        Name = "Box ESP",
        Flag = "BoxESP",
        Default = false,
        Callback = function(v) Flags.BoxESP = v end
    })
    ESP_Section:Dropdown({
        Name = "Box Mode",
        Flag = "BoxMode",
        Items = {"FULL", "CORNER"},
        Default = "FULL",
        MaxSize = 80,
        Callback = function(v) BoxESPMode = v end
    })
    ESP_Section:Toggle({
        Name = "Tracer",
        Flag = "Tracer",
        Default = false,
        Callback = function(v) Flags.Tracer = v end
    })
    ESP_Section:Toggle({
        Name = "Name",
        Flag = "ESPName",
        Default = true,
        Callback = function(v) Flags.ESPName = v end
    })
    ESP_Section:Toggle({
        Name = "Distance",
        Flag = "ESPDist",
        Default = true,
        Callback = function(v) Flags.ESPDist = v end
    })
    ESP_Section:Toggle({
        Name = "HP Bar",
        Flag = "ESPHPBar",
        Default = true,
        Callback = function(v) Flags.ESPHPBar = v end
    })
    ESP_Section:Toggle({
        Name = "Weapon",
        Flag = "ESPWeapon",
        Default = true,
        Callback = function(v) Flags.ESPWeapon = v end
    })
    ESP_Section:Toggle({
        Name = "Skeleton",
        Flag = "ESPSkeleton",
        Default = false,
        Callback = function(v) Flags.ESPSkeleton = v end
    })
    ESP_Section:Toggle({
        Name = "Masak Indicator",
        Flag = "ESPMasak",
        Default = true,
        Callback = function(v) Flags.ESPMasak = v end
    })
    ESP_Section:Slider({
        Name = "Tracer Distance",
        Flag = "TracerDist",
        Min = 50, Max = 1000, Default = 300, Suffix = " studs",
        Decimals = 0,
        Callback = function(v) TracerMaxDist = v end
    })
    ESP_Section:Slider({
        Name = "ESP Max Distance",
        Flag = "ESPMaxDist",
        Min = 10, Max = 5000, Default = 500, Suffix = " studs",
        Decimals = 0,
        Callback = function(v) ESPMaxDist = v end
    })

    -- Wall selector
    local wsSelectMode = false
    local wsSelected = {}
    local wsDisabled = {}
    local wsHighlights = {}
    local mouse = plr:GetMouse()
    local cam = workspace.CurrentCamera

    local wsHoverBox = Instance.new("SelectionBox", workspace)
    wsHoverBox.Color3 = Color3.fromRGB(80, 150, 255)
    wsHoverBox.LineThickness = 0.05
    wsHoverBox.SurfaceTransparency = 0.88

    local function wsGetTarget()
        local unitRay = cam:ScreenPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local chars = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then table.insert(chars, p.Character) end
        end
        params.FilterDescendantsInstances = chars
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
        if result then return result.Instance end
        return nil
    end

    local function wsAddHL(part)
        if wsHighlights[part] then return end
        local b = Instance.new("SelectionBox", workspace)
        b.Adornee = part
        b.Color3 = Color3.fromRGB(255, 55, 55)
        b.LineThickness = 0.07
        b.SurfaceTransparency = 0.75
        wsHighlights[part] = b
    end

    local function wsRemoveHL(part)
        if wsHighlights[part] then wsHighlights[part]:Destroy(); wsHighlights[part] = nil end
    end

    local function wsDoSelect(part)
        if not part or not part:IsA("BasePart") then return end
        local anc = part.Parent
        while anc do
            if anc:IsA("Model") and anc:FindFirstChildOfClass("Humanoid") then return end
            anc = anc.Parent
        end
        if wsSelected[part] then wsSelected[part] = nil; wsRemoveHL(part)
        else wsSelected[part] = true; wsAddHL(part) end
    end

    local function wsDoDisable()
        for part in pairs(wsSelected) do
            if part and part.Parent then
                wsDisabled[part] = {trans = part.Transparency, collide = part.CanCollide, shadow = part.CastShadow}
                pcall(function()
                    part.Transparency = 0.9
                    part.CanCollide = false
                    part.CastShadow = false
                end)
                wsRemoveHL(part)
            end
        end
        wsSelected = {}
    end

    local function wsDoRestore()
        for part, p in pairs(wsDisabled) do
            if part and part.Parent then
                pcall(function()
                    part.Transparency = p.trans
                    part.CanCollide = p.collide
                    part.CastShadow = p.shadow
                end)
            end
        end
        wsDisabled = {}
    end

    local function wsDoClr()
        for part in pairs(wsSelected) do wsRemoveHL(part) end
        wsSelected = {}
        wsHoverBox.Adornee = nil
    end

    RunService.RenderStepped:Connect(function()
        if not wsSelectMode then wsHoverBox.Adornee = nil; return end
        local t = wsGetTarget()
        wsHoverBox.Adornee = (t and not wsSelected[t]) and t or nil
    end)

    mouse.Button1Down:Connect(function()
        if not wsSelectMode then return end
        local t = wsGetTarget()
        if t then wsDoSelect(t) end
    end)

    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.P and wsSelectMode ~= nil then
            -- disabled: hanya aktif kalau toggled via UI
        end
    end)

    Wall_Section:Toggle({
        Name = "Wall Select Mode",
        Flag = "WSMode",
        Default = false,
        Callback = function(v)
            wsSelectMode = v
            if not v then wsHoverBox.Adornee = nil end
        end
    })
    Wall_Section:Button({ Name = "Disable Selected", Callback = wsDoDisable })
    Wall_Section:Button({ Name = "Restore Disabled", Callback = wsDoRestore })
    Wall_Section:Button({ Name = "Clear Selection",  Callback = wsDoClr })
end

-- ================================================================
-- AIM PAGE
-- ================================================================
do
    local Aimbot_Section = Pages["Aim"]:Section({ Name = "Aimbot",     Icon = "111386589037485", Side = 1 })
    local Silent_Section = Pages["Aim"]:Section({ Name = "Silent Aim", Icon = "126028986879491", Side = 2 })

    Aimbot_Section:Toggle({
        Name = "Auto Aim (RMB)",
        Flag = "AimLock",
        Default = false,
        Callback = function(v) Flags.AimLock = v end
    })
    Aimbot_Section:Dropdown({
        Name = "Aim Mode",
        Flag = "AimMode",
        Items = {"PC", "HP"},
        Default = "PC",
        MaxSize = 60,
        Callback = function(v) AimMode = v end
    })
    Aimbot_Section:Dropdown({
        Name = "Aim Part",
        Flag = "AimPart",
        Items = {"Head", "Body"},
        Default = "Head",
        MaxSize = 80,
        Callback = function(v) AimPart = (v == "Head") and "Head" or "Body" end
    })
    Aimbot_Section:Toggle({
        Name = "Wall Check",
        Flag = "WallCheck",
        Default = false,
        Callback = function(v) Flags.WallCheck = v end
    })
    Aimbot_Section:Toggle({
        Name = "Show FOV",
        Flag = "ShowAimFOV",
        Default = true,
        Callback = function(v) Flags.ShowAimFOV = v end
    })
    Aimbot_Section:Slider({
        Name = "FOV Radius",
        Flag = "AimFOV",
        Min = 30, Max = 400, Default = 120, Suffix = " px", Decimals = 0,
        Callback = function(v) AimFOV_Radius = v end
    })
    Aimbot_Section:Slider({
        Name = "Max Distance",
        Flag = "AimMaxDist",
        Min = 50, Max = 1000, Default = 300, Suffix = " studs", Decimals = 0,
        Callback = function(v) AimMax_Dist = v end
    })
    Aimbot_Section:Slider({
        Name = "Smoothness",
        Flag = "AimSmooth",
        Min = 1, Max = 100, Default = 85, Suffix = "%", Decimals = 0,
        Callback = function(v) AimSmooth = math.clamp(v / 100, 0.01, 0.99) end
    })

    Silent_Section:Toggle({
        Name = "Silent Aim",
        Flag = "SilentAim",
        Default = false,
        Callback = function(v) Flags.SilentAim = v end
    })
    Silent_Section:Dropdown({
        Name = "Silent Mode",
        Flag = "SilentMode",
        Items = {"PC", "HP"},
        Default = "PC",
        MaxSize = 60,
        Callback = function(v) SilentMode = v end
    })
    Silent_Section:Toggle({
        Name = "Wallbang",
        Flag = "SilentWallbang",
        Default = false,
        Callback = function(v) Flags.SilentAimWallbang = v end
    })
    Silent_Section:Toggle({
        Name = "Show FOV (Silent)",
        Flag = "ShowSilentFOV",
        Default = true,
        Callback = function(v) Flags.ShowSilentFOV = v end
    })
    Silent_Section:Slider({
        Name = "FOV Radius (Silent)",
        Flag = "SilentFOV",
        Min = 30, Max = 400, Default = 120, Suffix = " px", Decimals = 0,
        Callback = function(v) SilentFOV_Radius = v end
    })

    -- Whitelist via playerlist
    local AimPlayerlist = Pages["Aim"]:Playerlist({
        Callback = function(action, plrSelected)
            if not plrSelected then return end
            if action == "Added" or action == "Add" then
                AimWhitelist[plrSelected.Name] = true
            else
                AimWhitelist[plrSelected.Name] = nil
            end
        end
    })
end

-- ================================================================
-- FARM PAGE
-- ================================================================
do
    local FarmSub = {
        ["Cook"]  = Pages["Farm"]:SubPage({ Name = "cook",  Icon = "111178525804834", Columns = 2 }),
        ["Buy"]   = Pages["Farm"]:SubPage({ Name = "buy",   Icon = "115907015044719", Columns = 2 }),
        ["Chips"] = Pages["Farm"]:SubPage({ Name = "chips", Icon = "136623465713368", Columns = 2 }),
        ["Auto"]  = Pages["Farm"]:SubPage({ Name = "auto",  Icon = "109463522861706", Columns = 2 }),
    }

    -- Cook Section
    do
        local Cook_Sec = FarmSub["Cook"]:Section({ Name = "Auto Cook", Icon = "111178525804834", Side = 1 })

        -- Apartment dropdown
        local apartNames = {}
        for _, a in ipairs(APARTMENTS) do table.insert(apartNames, a.name) end

        Cook_Sec:Dropdown({
            Name = "Select Apartment",
            Flag = "SelectedApart",
            Items = apartNames,
            Default = apartNames[1],
            MaxSize = 200,
            Callback = function(v)
                for _, a in ipairs(APARTMENTS) do
                    if a.name == v then selectedApart = a; break end
                end
            end
        })

        Cook_Sec:Dropdown({
            Name = "Cook Side",
            Flag = "CookSide",
            Items = {"L", "R"},
            Default = "L",
            MaxSize = 60,
            Callback = function(v)
                if selectedApart then
                    selectedApart.side = v
                    updateApartCook(selectedApart)
                end
            end
        })

        Cook_Sec:Toggle({
            Name = "Auto Cook",
            Flag = "AutoCook",
            Default = false,
            Callback = function(v)
                Flags.AutoCook = v
                if v then
                    lastCookProgressTime = tick()
                    if selectedApart then
                        local nm = selectedApart.name:lower()
                        if nm:find("apt 5") or nm:find("apt5") or nm:find("west")
                            or nm:find("apt 6") or nm:find("apt6") then
                            setApart56FloorCollide(false)
                        end
                    end
                else
                    setApart56FloorCollide(true)
                end
            end
        })

        local cookStatusLbl = Cook_Sec:Label("Status: idle", "Left")
        -- Store reference for internal display
        _G.DARKHUB_COOK_STATUS = cookStatusLbl

        Cook_Sec:Button({
            Name = "Reset Counter",
            Callback = function() totalMasak = 0 end
        })
    end

    -- Buy Section
    do
        local Buy_Sec = FarmSub["Buy"]:Section({ Name = "Auto Buy (Lamont)", Icon = "115907015044719", Side = 2 })

        Buy_Sec:Slider({
            Name = "Amount",
            Flag = "BuyAmount",
            Min = 1, Max = 100, Default = 10, Suffix = "x", Decimals = 0,
            Callback = function(v) AutoBuySettings.Amount = v end
        })

        Buy_Sec:Button({
            Name = "Buy PACK",
            Callback = function()
                if abBusy then return end
                abBusy = true; abCancelled = false
                doRemoteBuy({"Water", "Sugar Block Bag", "Gelatin"}, AutoBuySettings.Amount)
            end
        })
        Buy_Sec:Button({
            Name = "Buy WATER",
            Callback = function()
                if abBusy then return end
                abBusy = true; abCancelled = false
                doRemoteBuy({"Water"}, AutoBuySettings.Amount)
            end
        })
        Buy_Sec:Button({
            Name = "Buy SUGAR",
            Callback = function()
                if abBusy then return end
                abBusy = true; abCancelled = false
                doRemoteBuy({"Sugar Block Bag"}, AutoBuySettings.Amount)
            end
        })
        Buy_Sec:Button({
            Name = "Buy GELATIN",
            Callback = function()
                if abBusy then return end
                abBusy = true; abCancelled = false
                doRemoteBuy({"Gelatin"}, AutoBuySettings.Amount)
            end
        })
        Buy_Sec:Button({
            Name = "Cancel Buy",
            Callback = function() if abBusy then abCancelled = true end end
        })
    end

    -- Chips Section
    do
        local Chip_Sec = FarmSub["Chips"]:Section({ Name = "Chips", Icon = "136623465713368", Side = 1 })
        local chipAmt = {Amount = 10}

        Chip_Sec:Slider({
            Name = "Buy Amount",
            Flag = "ChipBuyAmount",
            Min = 1, Max = 100, Default = 10, Suffix = "x", Decimals = 0,
            Callback = function(v) chipAmt.Amount = v end
        })
        Chip_Sec:Button({
            Name = "Buy POTATO",
            Callback = function()
                task.spawn(function()
                    local rem = RS:FindFirstChild("RemoteEvents")
                    local sp = rem and rem:FindFirstChild("StorePurchase")
                    if not sp then return end
                    for _ = 1, chipAmt.Amount do pcall(function() sp:FireServer("Potato", 1) end); task.wait(0.4) end
                end)
            end
        })
        Chip_Sec:Button({
            Name = "Buy FLOUR",
            Callback = function()
                task.spawn(function()
                    local rem = RS:FindFirstChild("RemoteEvents")
                    local sp = rem and rem:FindFirstChild("StorePurchase")
                    if not sp then return end
                    for _ = 1, chipAmt.Amount do pcall(function() sp:FireServer("Flour", 1) end); task.wait(0.4) end
                end)
            end
        })
        Chip_Sec:Button({
            Name = "Buy PACK (Potato+Flour)",
            Callback = function()
                task.spawn(function()
                    local rem = RS:FindFirstChild("RemoteEvents")
                    local sp = rem and rem:FindFirstChild("StorePurchase")
                    if not sp then return end
                    for _, item in ipairs({"Potato", "Flour"}) do
                        for _ = 1, chipAmt.Amount do pcall(function() sp:FireServer(item, 1) end); task.wait(0.4) end
                    end
                end)
            end
        })

        -- Chips Farm
        local CF = {active = false, paused = false, pot = 1}
        local CHIPS_COORDS = {
            A = {x=-478.83, y=3.86, z=-438.92},
            B = {x=-461.69, y=3.86, z=-461.25},
            C = {x=-461.69, y=3.86, z=-472.88},
            D = {x=-462.75, y=3.86, z=-521.94},
        }
        local CHIPS_POTS = {
            {x=-515.28, y=3.86, z=-451.71}, {x=-515.24, y=3.86, z=-462.26},
            {x=-515.28, y=3.86, z=-471.89}, {x=-515.28, y=3.86, z=-481.75},
            {x=-515.24, y=3.86, z=-492.10}, {x=-496.99, y=3.86, z=-452.21},
            {x=-496.95, y=3.86, z=-462.02}, {x=-496.98, y=3.86, z=-471.73},
            {x=-496.99, y=3.86, z=-481.82}, {x=-497.04, y=3.86, z=-491.37},
        }

        Chip_Sec:Dropdown({
            Name = "Pot (1-10)",
            Flag = "ChipPot",
            Items = {"1","2","3","4","5","6","7","8","9","10"},
            Default = "1",
            MaxSize = 100,
            Callback = function(v) CF.pot = tonumber(v) or 1 end
        })

        local function cfMoveCharTo(targetPos)
            local ch = plr.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local offset = targetPos - hrp.Position
            for _, p in pairs(ch:GetDescendants()) do
                if p:IsA("BasePart") and p ~= hrp then pcall(function() p.CFrame = p.CFrame + offset end) end
            end
            hrp.CFrame = CFrame.new(targetPos) * (hrp.CFrame - hrp.CFrame.Position)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        local function cfTPToCoord(coord)
            local ch = plr.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local fromPos = hrp.Position
            local toPos = Vector3.new(coord.x, coord.y, coord.z)
            local dist = (toPos - fromPos).Magnitude
            if dist < 0.05 then return end
            local travelT = dist / 16
            local elapsed = 0
            while elapsed < travelT and CF.active do
                local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp2 then break end
                local t = math.clamp(elapsed / travelT, 0, 1)
                cfMoveCharTo(fromPos:Lerp(toPos, t))
                local _, dt = RunService.Stepped:Wait()
                elapsed = elapsed + dt
            end
            if CF.active then cfMoveCharTo(toPos) end
        end

        local function cfFindPromptNear(targetPos, radius)
            radius = radius or 20
            local best, bestDist = nil, radius
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
                        local d = (pos - targetPos).Magnitude
                        if d < bestDist then bestDist = d; best = obj end
                    end
                end
            end
            return best
        end

        local function cfFirePromptAt(targetPos)
            local p = cfFindPromptNear(targetPos)
            if not p then return end
            pcall(function()
                p.MaxActivationDistance = 9999
                p.RequiresLineOfSight = false
            end)
            pcall(function() fireproximityprompt(p) end)
            pcall(function()
                if p and p.Parent then
                    p.MaxActivationDistance = 10
                    p.RequiresLineOfSight = true
                end
            end)
        end

        local function cfEquipTool(kw)
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            for _, v in pairs(plr.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.Name:lower():find(kw:lower()) then
                    pcall(function() hum:EquipTool(v) end); task.wait(0.2); return
                end
            end
        end

        local function startChipLoop()
            local cycle = 0
            while CF.active and Running do
                while CF.paused and CF.active do task.wait(0.3) end
                if not CF.active then break end
                local pot = CHIPS_POTS[CF.pot]

                cfTPToCoord(CHIPS_COORDS.A); cfFirePromptAt(Vector3.new(CHIPS_COORDS.A.x, CHIPS_COORDS.A.y, CHIPS_COORDS.A.z))
                task.wait(0.5)
                cfTPToCoord(CHIPS_COORDS.B)
                cfEquipTool("Potato")
                cfFirePromptAt(Vector3.new(CHIPS_COORDS.B.x, CHIPS_COORDS.B.y, CHIPS_COORDS.B.z))
                task.wait(2)
                cfTPToCoord(CHIPS_COORDS.C)
                cfFirePromptAt(Vector3.new(CHIPS_COORDS.C.x, CHIPS_COORDS.C.y, CHIPS_COORDS.C.z))
                task.wait(2)
                cfTPToCoord(CHIPS_COORDS.D)
                cfEquipTool("Flour")
                cfFirePromptAt(Vector3.new(CHIPS_COORDS.D.x, CHIPS_COORDS.D.y, CHIPS_COORDS.D.z))
                task.wait(2)
                cfTPToCoord(pot)
                cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
                task.wait(60)
                cfTPToCoord(pot)
                cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
                task.wait(1)
                cycle += 1
            end
            CF.active = false; CF.paused = false
        end

        Chip_Sec:Toggle({
            Name = "Chips Auto Farm",
            Flag = "ChipsFarm",
            Default = false,
            Callback = function(v)
                CF.active = v
                if v then task.spawn(startChipLoop) end
            end
        })

        -- Auto Sell Chips
        local SC = {active = false}
        local SC_TUKAR = {x=-34.91, y=4.56, z=-24.15}
        local SC_COOK  = {x=-487.11, y=3.86, z=-454.16}
        local SC_HOMELESS = {
            {x=-315.35, y=3.72, z=-361.56}, {x=-273.52, y=3.85, z=-211.32},
            {x=1102.42, y=3.36, z=527.05},  {x=52.89,   y=3.72, z=-425.36},
            {x=152.88,  y=3.73, z=-210.08}, {x=-522.75, y=-7.86, z=-165.08},
            {x=65.12,   y=3.73, z=68.10},   {x=26.04,   y=3.73, z=217.89},
            {x=520.08,  y=3.87, z=-295.52}, {x=699.28,  y=3.72, z=-427.05},
            {x=900.03,  y=3.94, z=-283.12}, {x=874.89,  y=3.73, z=-63.02},
        }

        local function scCountChips(name)
            local n = 0
            for _, t in ipairs(plr.Backpack:GetChildren()) do if t.Name == name then n += 1 end end
            local ch = plr.Character
            if ch then for _, t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t.Name == name then n += 1 end end end
            return n
        end

        local function scFirePrompt(targetPos)
            local p = cfFindPromptNear(targetPos, 60)
            if not p then return false end
            local od = p.MaxActivationDistance; local ol = p.RequiresLineOfSight
            pcall(function() p.MaxActivationDistance = 9999; p.RequiresLineOfSight = false end)
            task.wait(0.05)
            pcall(function() fireproximityprompt(p) end)
            task.wait(0.15)
            pcall(function()
                if p and p.Parent then
                    p.MaxActivationDistance = od; p.RequiresLineOfSight = ol
                end
            end)
            return true
        end

        local function scEquipTool(name)
            local ch = plr.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum then return false end
            local bp = plr.Backpack
            if bp then
                local tool = bp:FindFirstChild(name)
                if tool then pcall(function() hum:EquipTool(tool) end); task.wait(0.25); return true end
            end
            if ch then
                local tool = ch:FindFirstChild(name)
                if tool and tool:IsA("Tool") then return true end
            end
            return false
        end

        local function startSellChipsLoop()
            while SC.active and Running do
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if not seat then SC.active = false; break end
                local hotCount = scCountChips("Hot Chips")
                local potatoCount = scCountChips("Potato Chips")
                if hotCount == 0 and potatoCount == 0 then SC.active = false; break end
                local visitCount
                if hotCount > 0 then visitCount = math.min(hotCount, 12)
                else
                    visitCount = math.min(potatoCount, 12)
                    if not doVehicleTP(CFrame.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z)) then SC.active = false; break end
                    task.wait(0.3); if not SC.active then break end
                    scFirePrompt(Vector3.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z))
                    task.wait(0.4); if not SC.active then break end
                end
                scEquipTool("Hot Chips")
                if not SC.active then break end
                for i = 1, visitCount do
                    if not SC.active then break end
                    local h = SC_HOMELESS[i]
                    doVehicleTP(CFrame.new(h.x, h.y, h.z))
                    task.wait(0.25); if not SC.active then break end
                    scEquipTool("Hot Chips")
                    scFirePrompt(Vector3.new(h.x, h.y, h.z))
                    task.wait(0.2)
                end
                if not SC.active then break end
                local remaining = scCountChips("Hot Chips")
                if remaining > 0 then doVehicleTP(CFrame.new(SC_COOK.x, SC_COOK.y, SC_COOK.z))
                else SC.active = false; break end
                SC.active = false
            end
            SC.active = false
        end

        Chip_Sec:Toggle({
            Name = "Auto Sell Chips (Vehicle)",
            Flag = "ChipsSell",
            Default = false,
            Callback = function(v)
                if v then
                    local char = plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not hum or not hum.SeatPart then
                        -- fallback: biar library tidak nyala
                        v = false
                        return
                    end
                end
                SC.active = v
                if v then task.spawn(startSellChipsLoop) end
            end
        })
    end

    -- Auto Section (Fully Auto Farm + Box + Marshmallow)
    do
        local AutoFarm_Sec = FarmSub["Auto"]:Section({ Name = "Fully Auto Farm", Icon = "109463522861706", Side = 1 })
        local Box_Sec      = FarmSub["Auto"]:Section({ Name = "Auto Farm Box",    Icon = "111386589037485", Side = 2 })
        local Marsh_Sec    = FarmSub["Auto"]:Section({ Name = "Marshmallow",      Icon = "115907015044719", Side = 2 })

        local AF = {active = false, paused = false, packQty = 10}

        AutoFarm_Sec:Slider({
            Name = "Pack per Cycle",
            Flag = "AFPackQty",
            Min = 1, Max = 100, Default = 10, Suffix = "x", Decimals = 0,
            Callback = function(v) AF.packQty = v end
        })

        local function afDoSell()
            local sellP
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bestD = math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local pos
                    local part = obj.Parent
                    if part:IsA("Attachment") then pos = part.WorldPosition
                    elseif part:IsA("BasePart") then pos = part.Position
                    elseif part:IsA("Model") then
                        local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                        if rp then pos = rp.Position end
                    end
                    if pos and obj.ActionText:lower():find("interact") then
                        local d = (pos - hrp.Position).Magnitude
                        if d < bestD then bestD = d; sellP = obj end
                    end
                end
            end
            if not sellP then task.wait(1.5); return end
            pcall(function()
                sellP.MaxActivationDistance = 9999
                sellP.RequiresLineOfSight = false
            end)
            local function getMarsh()
                local list = {}
                for _, v in pairs(plr.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name:lower():find("marshmallow") then table.insert(list, v) end
                end
                if plr.Character then
                    for _, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("Tool") and v.Name:lower():find("marshmallow") then table.insert(list, v) end
                    end
                end
                return list
            end
            for _, marsh in ipairs(getMarsh()) do
                if not AF.active then break end
                while AF.paused and AF.active do task.wait(0.3) end
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if not hum then break end
                pcall(function() hum:EquipTool(marsh) end)
                task.wait(0.08)
                pcall(function() fireproximityprompt(sellP) end)
                task.wait(0.18)
            end
            pcall(function()
                if sellP and sellP.Parent then
                    sellP.MaxActivationDistance = 10
                    sellP.RequiresLineOfSight = true
                end
            end)
        end

        local function afDoBuyPack(qty)
            local rem = RS:FindFirstChild("RemoteEvents")
            local sp = rem and rem:FindFirstChild("StorePurchase")
            if not sp then return end
            local function countItem(name)
                local n = 0
                for _, t in ipairs(plr.Backpack:GetChildren()) do if t.Name == name then n += 1 end end
                local ch = plr.Character
                if ch then for _, t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t.Name == name then n += 1 end end end
                return n
            end
            local packItems = {"Water", "Sugar Block Bag", "Gelatin"}
            for _, item in ipairs(packItems) do
                if not AF.active then break end
                local before = countItem(item)
                for _ = 1, qty do
                    if not AF.active then break end
                    while AF.paused and AF.active do task.wait(0.3) end
                    pcall(function() sp:FireServer(item, 1) end)
                    task.wait(0.4)
                end
                local elapsed, gained = 0, 0
                repeat
                    if not AF.active then break end
                    task.wait(0.2); elapsed += 0.2
                    gained = countItem(item) - before
                until gained >= qty or elapsed > 8
                local missing = qty - gained
                if missing > 0 and AF.active then
                    for _ = 1, missing do
                        if not AF.active then break end
                        pcall(function() sp:FireServer(item, 1) end)
                        task.wait(0.5)
                    end
                end
            end
            task.wait(1)
        end

        local function startAFLoop()
            local cycleCount = 0
            local needsKillTP = true
            local AF_died = false
            local isDoingKillTP = false
            local deathConn
            deathConn = plr.CharacterAdded:Connect(function()
                if not isDoingKillTP and AF.active then AF_died = true end
            end)
            while AF.active and Running do
                AF_died = false
                if needsKillTP then
                    isDoingKillTP = true
                    doSuicideTP({name="Buy Marshmallow", x=510.38, y=3.59, z=603.50})
                    isDoingKillTP = false
                    needsKillTP = false
                end
                while AF.paused and AF.active do task.wait(0.3) end
                if not AF.active then break end
                if AF_died then needsKillTP = true; task.wait(1); continue end

                afDoBuyPack(AF.packQty)

                while AF.paused and AF.active do task.wait(0.3) end
                if not AF.active then break end
                if AF_died then needsKillTP = true; task.wait(1); continue end

                local apt = selectedApart
                if not apt then AF.active = false; break end
                tpToPos(apt.x, apt.y, apt.z, nil, apt.name)
                local wl = 0
                while tpActive and wl < 200 do task.wait(0.1); wl += 1 end
                task.wait(0.5)
                snapToCookPos()
                task.wait(0.5)

                local startMasak = totalMasak
                local target = startMasak + AF.packQty
                local afLastMasak = totalMasak
                local afLastMasakTime = tick()
                if selectedApart then
                    local nm = selectedApart.name:lower()
                    if nm:find("apt 5") or nm:find("apt5") or nm:find("west")
                        or nm:find("apt 6") or nm:find("apt6") then
                        setApart56FloorCollide(false)
                    end
                end
                Flags.AutoCook = true
                lastCookProgressTime = tick()

                while AF.active and Running and totalMasak < target do
                    if AF_died then break end
                    if AF.paused then
                        if Flags.AutoCook then Flags.AutoCook = false end
                        while AF.paused and AF.active do task.wait(0.3) end
                        if not AF.active then break end
                        Flags.AutoCook = true
                        lastCookProgressTime = tick()
                        snapToCookPos()
                    end
                    if totalMasak > afLastMasak then
                        afLastMasak = totalMasak; afLastMasakTime = tick()
                    elseif (tick() - afLastMasakTime) > COOK_WATCHDOG_SECS then
                        currentCookStep = 1; lastCookProgressTime = tick(); afLastMasakTime = tick()
                        snapToCookPos()
                        task.wait(1)
                    end
                    task.wait(0.5)
                end
                Flags.AutoCook = false
                setApart56FloorCollide(true)
                while AF.paused and AF.active do task.wait(0.3) end
                if not AF.active then break end
                if AF_died then needsKillTP = true; task.wait(1); continue end

                tpToPos(510.38, 3.59, 603.50, nil, "Buy Marshmallow")
                local wl2 = 0
                while tpActive and wl2 < 200 do task.wait(0.1); wl2 += 1 end
                task.wait(0.5)

                while AF.paused and AF.active do task.wait(0.3) end
                if not AF.active then break end
                if AF_died then needsKillTP = true; task.wait(1); continue end

                afDoSell()
                task.wait(0.5)

                cycleCount = cycleCount + 1
                task.wait(0.8)
            end
            if deathConn then deathConn:Disconnect() end
            AF.active = false; AF.paused = false
            Flags.AutoCook = false
            setApart56FloorCollide(true)
        end

        AutoFarm_Sec:Toggle({
            Name = "Fully Auto Farm (Loop)",
            Flag = "AFActive",
            Default = false,
            Callback = function(v)
                if v then
                    if not selectedApart then v = false; return end
                    AF.active = true; AF.paused = false
                    task.spawn(startAFLoop)
                else
                    AF.active = false; AF.paused = false
                end
            end
        })

        AutoFarm_Sec:Toggle({
            Name = "Pause Auto Farm",
            Flag = "AFPaused",
            Default = false,
            Callback = function(v) AF.paused = v end
        })

        -- Box
        local BOX_POS_A = CFrame.new(-551.47, 3.54, -84.97)
        local BOX_POS_B = CFrame.new(-401.96, 3.36, -70.98)
        local boxActive = false

        local function boxTweenTo(targetCF)
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local dist = (hrp.Position - targetCF.Position).Magnitude
            local tw = TweenService:Create(hrp,
                TweenInfo.new(math.max(dist / 20, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {CFrame = targetCF})
            tw:Play(); tw.Completed:Wait()
        end

        local function boxFindPromptNear(targetCF, radius)
            radius = radius or 20
            local best, bestDist = nil, radius
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local part = obj.Parent
                    local pos
                    if part:IsA("BasePart") then pos = part.Position
                    elseif part:IsA("Attachment") then pos = part.WorldPosition
                    elseif part:IsA("Model") then
                        local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                        if rp then pos = rp.Position end
                    end
                    if pos then
                        local d = (pos - targetCF.Position).Magnitude
                        if d < bestDist then bestDist = d; best = obj end
                    end
                end
            end
            return best
        end

        local function boxFirePrompt(prompt)
            if not prompt or not prompt.Parent then return end
            pcall(function()
                local od = prompt.MaxActivationDistance
                local ol = prompt.RequiresLineOfSight
                prompt.MaxActivationDistance = 9999
                prompt.RequiresLineOfSight = false
                task.wait(0.05)
                fireproximityprompt(prompt)
                task.wait(0.1)
                prompt.MaxActivationDistance = od
                prompt.RequiresLineOfSight = ol
            end)
        end

        local function boxLoop()
            while boxActive and Running do
                local ch = plr.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if not ch or not hum or hum.Health <= 0 then
                    local newChar = plr.CharacterAdded:Wait()
                    newChar:WaitForChild("HumanoidRootPart", 10)
                    task.wait(1)
                    if not boxActive then break end
                end
                boxTweenTo(BOX_POS_A)
                if not boxActive then break end
                task.wait(0.3)
                local pA = boxFindPromptNear(BOX_POS_A)
                if pA then boxFirePrompt(pA) end
                task.wait(0.5)
                if not boxActive then break end
                boxTweenTo(BOX_POS_B)
                if not boxActive then break end
                task.wait(0.3)
                local hum2 = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if hum2 then
                    local crate = plr.Backpack:FindFirstChild("Crate") or plr.Backpack:FindFirstChild("crate")
                    if crate then pcall(function() hum2:EquipTool(crate) end) end
                end
                task.wait(0.3)
                if not boxActive then break end
                local pB = boxFindPromptNear(BOX_POS_B)
                if pB then boxFirePrompt(pB) end
                task.wait(0.5)
            end
        end

        Box_Sec:Toggle({
            Name = "Auto Farm Box",
            Flag = "BoxFarm",
            Default = false,
            Callback = function(v)
                boxActive = v
                if v then task.spawn(boxLoop) end
            end
        })

        -- Marshmallow shortcut
        local MARSH_X, MARSH_Y, MARSH_Z = 510.38, 3.59, 603.50

        Marsh_Sec:Button({
            Name = "TP to Buy Marshmallow",
            Callback = function()
                task.spawn(function()
                    tpToPos(MARSH_X, MARSH_Y, MARSH_Z, nil, "Marshmallow")
                end)
            end
        })
        Marsh_Sec:Button({
            Name = "Vehicle TP to Marshmallow",
            Callback = function() doVehicleTP(CFrame.new(MARSH_X, MARSH_Y, MARSH_Z)) end
        })
        Marsh_Sec:Button({
            Name = "Kill TP to Marshmallow",
            Callback = function()
                if tpBusy then return end
                task.spawn(function()
                    doSuicideTP({name="Buy Marshmallow", x=MARSH_X, y=MARSH_Y, z=MARSH_Z})
                end)
            end
        })
        Marsh_Sec:Button({
            Name = "Sell All Marshmallow",
            Callback = function()
                task.spawn(function()
                    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local sellPrompt, bestD = nil, math.huge
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local part = obj.Parent
                            local pos
                            if part:IsA("BasePart") then pos = part.Position
                            elseif part:IsA("Attachment") then pos = part.WorldPosition
                            elseif part:IsA("Model") then
                                local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
                                if rp then pos = rp.Position end
                            end
                            if pos and obj.ActionText:lower():find("interact") then
                                local d = (pos - hrp.Position).Magnitude
                                if d < bestD then bestD = d; sellPrompt = obj end
                            end
                        end
                    end
                    if not sellPrompt then return end
                    sellPrompt.MaxActivationDistance = 9999
                    sellPrompt.RequiresLineOfSight = false
                    local function getMarsh()
                        local list = {}
                        for _, v in pairs(plr.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v.Name:lower():find("marshmallow") then table.insert(list, v) end
                        end
                        if plr.Character then
                            for _, v in pairs(plr.Character:GetChildren()) do
                                if v:IsA("Tool") and v.Name:lower():find("marshmallow") then table.insert(list, v) end
                            end
                        end
                        return list
                    end
                    for _, marsh in ipairs(getMarsh()) do
                        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                        if not hum then break end
                        pcall(function() hum:EquipTool(marsh) end)
                        task.wait(0.1)
                        pcall(function() fireproximityprompt(sellPrompt) end)
                        task.wait(0.2)
                    end
                end)
            end
        })
    end
end

-- ================================================================
-- TP PAGE
-- ================================================================
do
    local TP_Loc = Pages["TP"]:Section({ Name = "Locations",      Icon = "109463522861706", Side = 1 })
    local TP_Plr = Pages["TP"]:Section({ Name = "TP to Player",   Icon = "111386589037485", Side = 2 })
    local TP_Veh = Pages["TP"]:Section({ Name = "Vehicle Info",   Icon = "126028986879491", Side = 2 })

    local tpStatusLbl = TP_Loc:Label("Status: ready", "Left")

    for _, cat in ipairs(TP_CATEGORIES) do
        local names = {}
        for _, loc in ipairs(cat.locs) do table.insert(names, loc.name) end

        local selLoc
        TP_Loc:Dropdown({
            Name = cat.name,
            Flag = "TPCat_" .. cat.name,
            Items = names,
            Default = names[1],
            MaxSize = 200,
            Callback = function(v)
                for _, loc in ipairs(cat.locs) do
                    if loc.name == v then selLoc = loc; break end
                end
            end
        })

        TP_Loc:Button({
            Name = "GO — " .. cat.name,
            Callback = function()
                if not selLoc then return end
                local L = selLoc
                task.spawn(function()
                    tpToPos(L.x, L.y, L.z, nil, L.name)
                    if tpStatusLbl then tpStatusLbl:Set("Status: Arrived at " .. L.name) end
                end)
            end
        })

        TP_Loc:Button({
            Name = "KILL TP — " .. cat.name,
            Callback = function()
                if not selLoc then return end
                if tpBusy then return end
                local L = selLoc
                task.spawn(function()
                    doSuicideTP({name=L.name, x=L.x, y=L.y, z=L.z})
                    if tpStatusLbl then tpStatusLbl:Set("Status: Kill-TP to " .. L.name) end
                end)
            end
        })

        TP_Loc:Button({
            Name = "VEH — " .. cat.name,
            Callback = function()
                if not selLoc then return end
                local L = selLoc
                local ok = doVehicleTP(CFrame.new(L.x, L.y, L.z))
                if tpStatusLbl then tpStatusLbl:Set("Vehicle TP: " .. (ok and "OK" or "Not in vehicle")) end
            end
        })
    end

    -- Playerlist
    local TPPlayerlist = Pages["TP"]:Playerlist({
        Callback = function(action, plrSelected)
            if action == "TP" and plrSelected and plrSelected.Character then
                local hrp = plrSelected.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    task.spawn(function()
                        tpToPos(hrp.Position.X, hrp.Position.Y, hrp.Position.Z, nil, plrSelected.Name)
                    end)
                end
            elseif action == "KillTP" and plrSelected and plrSelected.Character then
                local hrp = plrSelected.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not tpBusy then
                    task.spawn(function()
                        doSuicideTP({name=plrSelected.Name, x=hrp.Position.X, y=hrp.Position.Y, z=hrp.Position.Z})
                    end)
                end
            elseif action == "VEH" and plrSelected and plrSelected.Character then
                local hrp = plrSelected.Character:FindFirstChild("HumanoidRootPart")
                if hrp then doVehicleTP(CFrame.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)) end
            end
        end
    })

    TP_Veh:Label("Gunakan tab Locations untuk VEH.\nPlayerlist di kanan mendukung TP/KillTP/VEH.", "Left")
end

-- ================================================================
-- VEHICLE PAGE
-- ================================================================
do
    local VehFly_Sec = Pages["Vehicle"]:Section({ Name = "Vehicle Fly", Icon = "126028986879491", Side = 1 })
    local VehInfo_Sec = Pages["Vehicle"]:Section({ Name = "Info",       Icon = "103174897193", Side = 2 })

    local vFlyActive = false
    local vFlySpeed = 50
    local vLockedCF = nil
    local vFlyLoop = nil
    local vCam = workspace.CurrentCamera

    local function vStopFly()
        vLockedCF = nil
        if vFlyLoop then vFlyLoop:Disconnect(); vFlyLoop = nil end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            vCam.CameraSubject = hum
            vCam.CameraType = Enum.CameraType.Custom
        end
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
                if vCam.CameraType ~= Enum.CameraType.Custom then vCam.CameraType = Enum.CameraType.Custom end
                if vCam.CameraSubject ~= hum then vCam.CameraSubject = hum end
                local dir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + vCam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - vCam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - vCam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + vCam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0,1,0) end
                if dir.Magnitude > 0 then dir = dir.Unit end
                local newPos = vLockedCF.Position + (dir * vFlySpeed * dt)
                vLockedCF = CFrame.new(newPos) * vLockedCF.Rotation
                vRoot.CFrame = vLockedCF
                vRoot.AssemblyLinearVelocity = Vector3.new(0,0,0)
                vRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
            else
                if vFlyActive then vFlyActive = false; vStopFly() end
            end
        end)
    end

    VehFly_Sec:Toggle({
        Name = "Vehicle Fly",
        Flag = "VehicleFly",
        Default = false,
        Callback = function(v)
            vFlyActive = v
            if v then vStartFly() else vStopFly() end
        end
    })
    VehFly_Sec:Slider({
        Name = "Fly Speed",
        Flag = "VehicleFlySpeed",
        Min = 10, Max = 500, Default = 50, Suffix = " studs", Decimals = 0,
        Callback = function(v) vFlySpeed = v end
    })

    VehInfo_Sec:Label("Duduk di kendaraan dulu sebelum ON.", "Left")
    VehInfo_Sec:Label("W/A/S/D = gerak · E = naik · Q = turun", "Left")
    VehInfo_Sec:Label("Auto OFF kalau keluar kendaraan.", "Left")
end

-- ================================================================
-- INFO PAGE
-- ================================================================
do
    local Contact_Sec = Pages["Info"]:Section({ Name = "Contact",   Icon = "103174889897193", Side = 1 })
    local Warn_Sec    = Pages["Info"]:Section({ Name = "Warning",   Icon = "136623465713368", Side = 1 })

    Contact_Sec:Button({
        Name = "TikTok — @drakhub (Click to Copy)",
        Callback = function() pcall(function() setclipboard("drakhub") end) end
    })
    Contact_Sec:Button({
        Name = "Discord — pDEyArQ5B (Click to Copy)",
        Callback = function() pcall(function() setclipboard("https://discord.gg/pDEyArQ5B") end) end
    })

    Warn_Sec:Label("USE AT YOUR OWN RISK", "Left")
    Warn_Sec:Label("We are not responsible for any bans.", "Left")
    Warn_Sec:Label("DILARANG KERAS SHARING!!!", "Left")
    Warn_Sec:Label("DILARANG MENJUAL KEMBALI SCRIPT INI!!!", "Left")
end

-- ================================================================
-- CONFIG PAGE
-- ================================================================
do
    local Config_Sec = Pages["Config"]:Section({ Name = "Configs", Icon = "137300573942266", Side = 1 })

    local selectedCfg
    local cfgName

    local ConfigsDropdown = Config_Sec:Dropdown({
        Name = "Saved Configs",
        Flag = "ConfigsList",
        Items = {},
        Multi = false,
        MaxSize = 200,
        Callback = function(v) selectedCfg = v end
    })

    -- load list
    local function refreshCfgList()
        local list = {}
        pcall(function()
            if isfolder and isfolder("darkhub_configs") then
                for _, f in ipairs(listfiles("darkhub_configs")) do
                    local n = f:match("([^/\\]+)$") or f
                    n = n:gsub("%.json$", "")
                    if n ~= "" then table.insert(list, n) end
                end
            end
        end)
        -- clear & re-add
        pcall(function() ConfigsDropdown:ClearOptions() end)
        for _, n in ipairs(list) do ConfigsDropdown:AddOption(n) end
    end

    Config_Sec:Textbox({
        Name = "Config Name",
        Flag = "CfgName",
        Placeholder = "Enter name...",
        Default = "",
        Callback = function(v) cfgName = v end
    })

    local function collectState()
        return {
            Flags = Flags,
            AimFOV_Radius = AimFOV_Radius,
            SilentFOV_Radius = SilentFOV_Radius,
            AimMax_Dist = AimMax_Dist,
            TracerMaxDist = TracerMaxDist,
            ESPMaxDist = ESPMaxDist,
            AimSmooth = AimSmooth,
            AimPart = AimPart,
            AimMode = AimMode,
            BoxESPMode = BoxESPMode,
            BlinkMode = BlinkMode,
            SilentMode = SilentMode,
        }
    end

    local function applyState(d)
        if d.Flags then for k,v in pairs(d.Flags) do if Flags[k] ~= nil then Flags[k] = v end end end
        if d.AimFOV_Radius then AimFOV_Radius = d.AimFOV_Radius end
        if d.SilentFOV_Radius then SilentFOV_Radius = d.SilentFOV_Radius end
        if d.AimMax_Dist then AimMax_Dist = d.AimMax_Dist end
        if d.TracerMaxDist then TracerMaxDist = d.TracerMaxDist end
        if d.ESPMaxDist then ESPMaxDist = d.ESPMaxDist end
        if d.AimSmooth then AimSmooth = d.AimSmooth end
        if d.AimPart then AimPart = d.AimPart end
        if d.AimMode then AimMode = d.AimMode end
        if d.BoxESPMode then BoxESPMode = d.BoxESPMode end
        if d.BlinkMode then BlinkMode = d.BlinkMode end
        if d.SilentMode then SilentMode = d.SilentMode end
    end

    Config_Sec:Button({
        Name = "Save Config",
        Callback = function()
            if not cfgName or cfgName == "" then return end
            pcall(function()
                if not isfolder("darkhub_configs") then makefolder("darkhub_configs") end
                writefile("darkhub_configs/" .. cfgName .. ".json", Http:JSONEncode(collectState()))
                refreshCfgList()
            end)
        end
    })
    Config_Sec:Button({
        Name = "Load Config",
        Callback = function()
            if not selectedCfg then return end
            pcall(function()
                local d = Http:JSONDecode(readfile("darkhub_configs/" .. selectedCfg .. ".json"))
                applyState(d)
            end)
        end
    })
    Config_Sec:Button({
        Name = "Delete Config",
        Callback = function()
            if not selectedCfg then return end
            pcall(function()
                delfile("darkhub_configs/" .. selectedCfg .. ".json")
                refreshCfgList()
            end)
        end
    })
    Config_Sec:Button({
        Name = "Refresh List",
        Callback = refreshCfgList
    })

    refreshCfgList()
end

-- ================================================================
-- SETTINGS INFO — Menu keybind, unload, etc.
-- ================================================================
do
    local Menu_Sec = Pages["Config"]:Section({ Name = "Menu", Icon = "93007870315593", Side = 2 })

    Menu_Sec:Label("Menu Keybind", "Left"):Keybind({
        Name = "MenuKeybind",
        Flag = "MenuKeybind",
        Mode = "toggle",
        Default = Library.MenuKeybind,
        Callback = function()
            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
        end
    })

    Menu_Sec:Toggle({
        Name = "Keybind List",
        Flag = "ShowKeybinds",
        Default = false,
        Callback = function(v) KeybindList:SetVisibility(v) end
    })

    Menu_Sec:Toggle({
        Name = "Watermark",
        Flag = "ShowWatermark",
        Default = false,
        Callback = function(v) Watermark:SetVisibility(v) end
    })

    Menu_Sec:Button({
        Name = "Unload DARK HUB",
        Callback = function()
            Running = false
            for p in pairs(ESP) do removeESP(p) end
            pcall(function() FovCircle:Remove() end)
            pcall(function() SilentFovCircle:Remove() end)
            pcall(function() SilentLine:Remove() end)
            Library:Unload()
        end
    })
end

-- ================================================================
-- NOTIFICATION & INIT
-- ================================================================
Library:Notification({
    Name = "DARK HUB Loaded",
    Description = "Loaded in " .. string.format("%.4f", os.clock() - LoadingTick) .. "s\nTikTok @drakhub",
    Duration = 5,
    Icon = "116339777575852",
    IconColor = Color3.fromRGB(80, 150, 255)
})

Library:Init()