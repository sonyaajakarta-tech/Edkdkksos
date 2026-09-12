-- ================================================================
-- ZOLAR UI + LENGER Features (Aimbot / ESP / OthersTP)
-- Integrated build — Zolar UI library preserved
-- ================================================================

local Zolar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Da7mu/Ui-Collection/refs/heads/main/Zolar%20Ui/Library.lua"))()

-- ================================================================
-- SERVICES
-- ================================================================
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Workspace   = game:GetService("Workspace")
local plr         = Players.LocalPlayer

-- ================================================================
-- STATE
-- ================================================================
local State = {
    Aim = {
        Enabled        = true,
        Keybind        = Enum.KeyCode.Q,   -- toggle master (keybind UI di AimMain)
        AimKey         = Enum.KeyCode.E,   -- hold to aim
        TeamCheck      = true,
        VisibleCheck   = false,
        TargetPart     = "Head",
        IgnoredTeams   = { "Red" },
        FOV            = 120,              -- px
        Smoothing      = 45,               -- %
        RangeMin       = 50,
        RangeMax       = 600,
        FOVColor       = Color3.fromRGB(179, 165, 255),
        Prediction     = true,
        PredictionFac  = 1.2,
        Resolver       = false,
        ShowFOV        = true,
        ShowTarget     = false,
        FOVThickness   = 2,
        FOVFilled      = false,
        FOVCircleColor = Color3.fromRGB(179, 165, 255),
    },
    Trigger = {
        Enabled     = false,
        Delay       = 80,      -- ms
        Whitelist   = "",
        WallCheck   = true,
        IgnoredTeams = {},
    },
    ESP = {
        Boxes       = true,
        Names       = true,
        Tracers     = false,
        BoxColor    = Color3.fromRGB(255, 110, 120),
        TextSize    = 14,
        Style       = "Corner",           -- "Corner" | "Full"
        Distance    = 1500,
    },
}

-- Aimbot internal
local AimTarget = nil
local RMBHeld   = false
local AimKeyHeld = false

UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 then RMBHeld = true end
    if i.KeyCode == State.Aim.AimKey then AimKeyHeld = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then RMBHeld = false end
    if i.KeyCode == State.Aim.AimKey then AimKeyHeld = false end
end)

-- ================================================================
-- DRAWINGS — FOV Circle + ESP pool (ported from Lenger)
-- ================================================================
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness  = 1.5
FovCircle.Color      = Color3.fromRGB(255, 255, 255)
FovCircle.Filled     = false
FovCircle.NumSides   = 64
FovCircle.Visible    = false

local ESP = {}

local function _mkLine(thick, col)
    local d = Drawing.new("Line")
    d.Thickness = thick; d.Color = col; d.Visible = false
    return d
end
local function _mkText(sz, col)
    local d = Drawing.new("Text")
    d.Size = sz; d.Color = col; d.Outline = true
    d.OutlineColor = Color3.fromRGB(0,0,0)
    d.Center = true; d.Font = Drawing.Fonts.Plex; d.Visible = false
    return d
end

local function _hideESP(e)
    e.box.Visible      = false
    e.hpbg.Visible     = false
    e.hpbar.Visible    = false
    e.hpnum.Visible    = false
    e.dispname.Visible = false
    e.dist.Visible     = false
    e.weapon.Visible   = false
    e.tracer.Visible   = false
    for _, c in ipairs(e.corners) do c.Visible = false end
    for _, s in ipairs(e.skeleton) do s.Visible = false end
end

local function createESP(p)
    if ESP[p] or p == plr then return end
    local _c = {}
    for i = 1, 8 do
        local cl = Drawing.new("Line")
        cl.Thickness = 2; cl.Color = Color3.fromRGB(255,255,255); cl.Visible = false
        _c[i] = cl
    end
    local _sk = {}
    for i = 1, 15 do
        local sl = Drawing.new("Line")
        sl.Thickness = 1.2; sl.Color = Color3.fromRGB(255,255,255); sl.Visible = false
        _sk[i] = sl
    end
    local e = {
        box      = Drawing.new("Square"),
        hpbg     = Drawing.new("Square"),
        hpbar    = Drawing.new("Square"),
        hpnum    = _mkText(10, Color3.fromRGB(255,255,255)),
        dispname = _mkText(13, Color3.fromRGB(255,255,255)),
        dist     = _mkText(11, Color3.fromRGB(180,180,180)),
        weapon   = _mkText(11, Color3.fromRGB(255,220,80)),
        tracer   = _mkLine(1.2, Color3.fromRGB(255,255,255)),
        corners  = _c,
        skeleton = _sk,
    }
    e.box.Thickness = 1.5; e.box.Filled = false
    e.hpbg.Thickness = 1; e.hpbg.Filled = true; e.hpbg.Color = Color3.fromRGB(0,0,0)
    e.hpbar.Thickness = 1; e.hpbar.Filled = true
    ESP[p] = e
end

local function removeESP(p)
    if not ESP[p] then return end
    local e = ESP[p]
    for _, c in ipairs(e.corners) do pcall(function() c:Remove() end) end
    for _, s in ipairs(e.skeleton) do pcall(function() s:Remove() end) end
    for k, d in pairs(e) do
        if k ~= "corners" and k ~= "skeleton" then
            pcall(function() d:Remove() end)
        end
    end
    ESP[p] = nil
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ================================================================
-- HELPERS
-- ================================================================
local function getTargetPart(char)
    if not char then return nil end
    local part = State.Aim.TargetPart
    if part == "Head" then
        return char:FindFirstChild("Head")
    elseif part == "Torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif part == "Legs" then
        return char:FindFirstChild("LowerTorso") or char:FindFirstChild("LeftUpperLeg")
    else -- Random
        local opts = {}
        local h  = char:FindFirstChild("Head")
        local t  = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local l  = char:FindFirstChild("LowerTorso") or char:FindFirstChild("LeftUpperLeg")
        if h then table.insert(opts, h) end
        if t then table.insert(opts, t) end
        if l then table.insert(opts, l) end
        if #opts == 0 then return nil end
        return opts[math.random(1, #opts)]
    end
end

local function isTeamIgnored(p)
    if not p.Team then return false end
    for _, t in ipairs(State.Aim.IgnoredTeams) do
        if p.Team.Name == t then return true end
    end
    return false
end

local wpRayParams = RaycastParams.new()
wpRayParams.FilterType = Enum.RaycastFilterType.Blacklist

-- ================================================================
-- MAIN RENDER LOOP  (Aimbot + FOV + ESP)
-- ================================================================
local SKEL_BONES = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
    {"RightUpperLeg","LeftUpperLeg"},
}

local function applyAimbot(cam, fovCenter, localRoot)
    if not State.Aim.Enabled or not localRoot then
        AimTarget = nil
        FovCircle.Visible = false
        return
    end

    local shouldAim = AimKeyHeld or RMBHeld
    FovCircle.Radius    = State.Aim.FOV
    FovCircle.Position  = fovCenter
    FovCircle.Thickness = State.Aim.FOVThickness
    FovCircle.Filled    = State.Aim.FOVFilled
    FovCircle.Color     = State.Aim.FOVCircleColor
    FovCircle.Visible   = State.Aim.ShowFOV

    if not shouldAim then
        AimTarget = nil
        return
    end

    -- VALIDATE existing target
    if AimTarget then
        local hum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then AimTarget = nil end
    end

    -- FIND target
    if not AimTarget then
        local bestDist, bestPart = math.huge, nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p == plr then continue end
            local ch = p.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not ch or not hum or hum.Health <= 0 then continue end
            if State.Aim.TeamCheck and p.Team == plr.Team then continue end
            if isTeamIgnored(p) then continue end

            local part = getTargetPart(ch)
            if not part then continue end

            local d3 = (part.Position - localRoot.Position).Magnitude
            if d3 < State.Aim.RangeMin or d3 > State.Aim.RangeMax then continue end

            local sp, onScreen = cam:WorldToViewportPoint(part.Position)
            if not onScreen or sp.Z <= 0 then continue end

            if State.Aim.VisibleCheck then
                local dir = part.Position - cam.CFrame.Position
                wpRayParams.FilterDescendantsInstances = { cam, plr.Character }
                local hit = Workspace:Raycast(cam.CFrame.Position, dir.Unit * dir.Magnitude, wpRayParams)
                if hit and not hit.Instance:IsDescendantOf(ch) then continue end
            end

            local d2 = (Vector2.new(sp.X, sp.Y) - fovCenter).Magnitude
            if d2 <= State.Aim.FOV and d2 < bestDist then
                bestDist = d2
                bestPart = part
            end
        end
        AimTarget = bestPart
    end

    -- ACT on target
    if AimTarget then
        local targetPos = AimTarget.Position

        -- Velocity prediction (Lenger style)
        if State.Aim.Prediction and AimTarget.Parent then
            local hum = AimTarget.Parent:FindFirstChildOfClass("Humanoid")
            local hrp = AimTarget.Parent:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                targetPos = targetPos + hrp.AssemblyLinearVelocity * (State.Aim.PredictionFac * 0.1)
            end
        end

        local targetCF = CFrame.lookAt(cam.CFrame.Position, targetPos)
        local alpha = math.clamp(1 - (State.Aim.Smoothing / 100), 0.02, 1)
        cam.CFrame = cam.CFrame:Lerp(targetCF, alpha)

        FovCircle.Color = Color3.fromRGB(220, 50, 50)
    else
        FovCircle.Color = State.Aim.FOVCircleColor
    end
end

local function renderESP(cam, localRoot)
    local anyESP = State.ESP.Boxes or State.ESP.Names or State.ESP.Tracers

    for p, e in pairs(ESP) do
        local ch  = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")

        if not anyESP or not ch or not hum or not root then
            _hideESP(e)
            continue
        end

        local pos3, onScreen = cam:WorldToViewportPoint(root.Position)
        if not onScreen or pos3.Z <= 0 then _hideESP(e) continue end

        local isDead = hum.Health <= 0

        if localRoot and (root.Position - localRoot.Position).Magnitude > State.ESP.Distance then
            _hideESP(e); continue
        end

        local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
        local sY = math.abs(botPos.Y - topPos.Y)
        local sX = sY * 0.6
        local bx = pos3.X - sX / 2
        local by = math.min(topPos.Y, botPos.Y)

        local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)

        -- BOXES
        if State.ESP.Boxes then
            e.box.Color = W
            e.box.Size  = Vector2.new(sX, sY)
            e.box.Position = Vector2.new(bx, by)
            local isFull = State.ESP.Style == "Full"
            e.box.Visible = isFull
            local showC = not isFull
            local cL = math.min(sX, sY) * 0.25
            local cx = e.corners
            cx[1].From = Vector2.new(bx, by);           cx[1].To = Vector2.new(bx + cL, by)
            cx[2].From = Vector2.new(bx, by);           cx[2].To = Vector2.new(bx, by + cL)
            cx[3].From = Vector2.new(bx + sX, by);      cx[3].To = Vector2.new(bx + sX - cL, by)
            cx[4].From = Vector2.new(bx + sX, by);      cx[4].To = Vector2.new(bx + sX, by + cL)
            cx[5].From = Vector2.new(bx, by + sY);      cx[5].To = Vector2.new(bx + cL, by + sY)
            cx[6].From = Vector2.new(bx, by + sY);      cx[6].To = Vector2.new(bx, by + sY - cL)
            cx[7].From = Vector2.new(bx + sX, by + sY); cx[7].To = Vector2.new(bx + sX - cL, by + sY)
            cx[8].From = Vector2.new(bx + sX, by + sY); cx[8].To = Vector2.new(bx + sX, by + sY - cL)
            for i = 1, 8 do
                cx[i].Color = W
                cx[i].Visible = showC
            end
        else
            e.box.Visible = false
            for i = 1, 8 do e.corners[i].Visible = false end
        end

        -- HP BAR
        local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local barH = math.max(1, sY * hp)
        local barX = bx - 7
        local hpCol = hp > 0.5 and Color3.fromRGB(0,220,0)
                   or hp > 0.2 and Color3.fromRGB(255,165,0)
                   or Color3.fromRGB(255,0,0)
        e.hpbg.Size = Vector2.new(4, sY)
        e.hpbg.Position = Vector2.new(barX, by)
        e.hpbg.Visible = true
        e.hpbar.Color = hpCol
        e.hpbar.Size = Vector2.new(4, barH)
        e.hpbar.Position = Vector2.new(barX, by + (sY - barH))
        e.hpbar.Visible = true
        e.hpnum.Text = math.floor(hum.Health) .. "HP"
        e.hpnum.Size = 11
        e.hpnum.Position = Vector2.new(barX + 2, by - 1)
        e.hpnum.Center = false
        e.hpnum.Color = hpCol
        e.hpnum.Visible = true

        -- NAME
        local distNow = localRoot and (root.Position - localRoot.Position).Magnitude or 100
        local tSize = math.clamp(math.floor(State.ESP.TextSize - distNow / 60), 8, State.ESP.TextSize)
        if State.ESP.Names then
            e.dispname.Text = (p.DisplayName or p.Name)
            e.dispname.Size = tSize
            e.dispname.Color = W
            e.dispname.Position = Vector2.new(pos3.X, by - 14)
            e.dispname.Visible = true
        else
            e.dispname.Visible = false
        end

        e.dist.Text = math.floor(distNow) .. "m"
        e.dist.Size = tSize
        e.dist.Color = W
        e.dist.Position = Vector2.new(pos3.X, by + sY + 3)
        e.dist.Visible = true

        -- TRACER
        if State.ESP.Tracers then
            local vp = cam.ViewportSize
            e.tracer.From = Vector2.new(vp.X / 2, vp.Y)
            e.tracer.To   = Vector2.new(pos3.X, by + sY)
            e.tracer.Color = W
            e.tracer.Visible = true
        else
            e.tracer.Visible = false
        end

        e.weapon.Visible = false
        for _, s in ipairs(e.skeleton) do s.Visible = false end
    end
end

RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local localChar = plr.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local fovCenter = UIS:GetMouseLocation()

    pcall(applyAimbot, cam, fovCenter, localRoot)
    pcall(renderESP, cam, localRoot)
end)

-- ================================================================
-- TRIGGERBOT LOOP
-- ================================================================
task.spawn(function()
    while task.wait(0.05) do
        if not State.Trigger.Enabled then continue end
        local cam = Workspace.CurrentCamera
        if not cam then continue end
        local localChar = plr.Character
        if not localChar then continue end
        local hum = localChar:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        -- Ray from center of screen
        local vp = cam.ViewportSize
        local ray = cam:ViewportPointToRay(vp.X / 2, vp.Y / 2)
        wpRayParams.FilterDescendantsInstances = { cam, localChar }
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 500, wpRayParams)
        if hit then
            local model = hit.Instance:FindFirstAncestorOfClass("Model")
            local hitHum = model and model:FindFirstChildOfClass("Humanoid")
            local hitPlayer = model and Players:GetPlayerFromCharacter(model)
            if hitHum and hitHum.Health > 0 and hitPlayer and hitPlayer ~= plr then
                -- team check
                if State.Aim.TeamCheck and hitPlayer.Team == plr.Team then continue end
                if State.Trigger.Whitelist ~= "" and string.find(string.lower(hitPlayer.Name), string.lower(State.Trigger.Whitelist)) then
                    continue
                end
                task.wait(State.Trigger.Delay / 1000)
                local tool = localChar:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
        end
    end
end)

-- ================================================================
-- OTHERS TP — locations from Lenger (VERBATIM)
-- ================================================================
local OTHERS_LOCATIONS = {
    {name="Bag Store",         x=992.77,  y=3.78,  z=422.53},
    {name="Bank",              x=-48.64,  y=3.73,  z=-320.46},
    {name="Binary Store",      x=-281.06, y=3.74,  z=251.23},
    {name="Boutique Store",    x=992.60,  y=3.78,  z=453.07},
    {name="Box Job",           x=-578.48, y=3.53,  z=-74.82},
    {name="Buy Marshmellow",   x=510.38,  y=3.59,  z=603.50},
    {name="Cap Store",         x=-270.15, y=3.88,  z=-331.36},
    {name="Casino",            x=1152.53, y=20.32, z=-26.31},
    {name="Chips Cook",        x=-487.11, y=3.86,  z=-454.16},
    {name="Chips Store",       x=-773.72, y=3.66,  z=-187.54},
    {name="Chips Tukar",       x=-34.91,  y=4.56,  z=-24.15},
    {name="Clothes Store 1",   x=-202.62, y=3.48,  z=-58.82},
    {name="Clothes Store 2",   x=-747.62, y=3.76,  z=571.96},
    {name="Dealer",            x=730.24,  y=3.7,   z=449.47},
    {name="Deli Grocery",      x=-364.30, y=3.61,  z=-325.87},
    {name="Fake Card",         x=216.28,  y=3.73,  z=-331.79},
    {name="Food Corp",         x=365.69,  y=3.48,  z=-349.23},
    {name="Glasses Store",     x=-697.77, y=4.21,  z=-336.85},
    {name="Gun Sell",          x=75.09,   y=3.76,  z=26.53},
    {name="Gun Store 1",       x=215.77,  y=3.73,  z=-179.89},
    {name="Gun Store 2",       x=-468.37, y=3.86,  z=349.56},
    {name="Gun Tier",          x=1114.80, y=3.78,  z=167.36},
    {name="Haircut",           x=52.73,   y=3.73,  z=-71.39},
    {name="Jewerely Store",    x=-75.48,  y=4.29,  z=-176.28},
    {name="Shoes Store",       x=524.48,  y=3.75,  z=-196.93},
    {name="Store 1",           x=904.05,  y=3.53,  z=-87.44},
    {name="Store 2",           x=530.13,  y=3.46,  z=430.07},
    {name="Tattoo Shop",       x=951.72,  y=3.83,  z=-72.93},
    {name="The Deli 2",        x=-662.23, y=3.98,  z=159.33},
}

local OtherLocByName = {}
local OtherNamesList = {}
for _, loc in ipairs(OTHERS_LOCATIONS) do
    OtherLocByName[loc.name] = loc
    table.insert(OtherNamesList, loc.name)
end

local function doTeleportTo(locName)
    local loc = OtherLocByName[locName]
    if not loc then return false, "Location not found" end

    local char = plr.Character
    if not char then
        char = plr.CharacterAdded:Wait()
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        hrp = char:WaitForChild("HumanoidRootPart", 5)
    end
    if not hrp then return false, "No HumanoidRootPart" end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        -- reset state dulu biar TP nempel
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(loc.x, loc.y + 3, loc.z)
    task.wait(0.1)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(loc.x, loc.y + 3, loc.z)

    return true, loc.name
end

-- ================================================================
-- UI — ZOLAR
-- ================================================================
local Window = Zolar:Window({
    Name = "ZOLAR",
    Icon = "128056142918696",
    Accent = Color3.fromRGB(179, 165, 255)
})

-- ================================================================
-- COMBAT TAB
-- ================================================================
local Combat = Window:Tab({
    Name = "Combat",
    Icon = "swords"
})

local Aimbot = Combat:SubTab({
    Name = "Aimbot",
    Icon = "crosshair"
})

local Triggerbot = Combat:SubTab({
    Name = "Triggerbot",
    Icon = "zap"
})

-- ---------- AIMBOT — MAIN ----------
local AimMain = Aimbot:Section({
    Name = "Main",
    Side = 1
})

local AimEnabledToggle
AimEnabledToggle = AimMain:Toggle({
    Name = "Enabled",
    Default = true,
    Flag = "aim_enabled",
    Callback = function(Value)
        State.Aim.Enabled = Value
        if Value then
            Zolar:Notification({
                Name = "Aimbot enabled",
                Description = "Hold aim key (default E) or RMB to lock.",
                Icon = "crosshair",
                Duration = 3
            })
        end
    end
})

AimEnabledToggle:Keybind({
    Default = Enum.KeyCode.Q,
    Flag = "aim_enabled_key",
    Callback = function(key)
        if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
            State.Aim.Keybind = key
        end
    end
})

AimMain:Toggle({
    Name = "Team check",
    Default = true,
    Flag = "aim_team",
    Callback = function(Value) State.Aim.TeamCheck = Value end
})

AimMain:Toggle({
    Name = "Visible check",
    Default = false,
    Flag = "aim_visible",
    Callback = function(Value) State.Aim.VisibleCheck = Value end
})

AimMain:Dropdown({
    Name = "Target part",
    Items = { "Head", "Torso", "Legs", "Random" },
    Default = "Head",
    Flag = "aim_part",
    Callback = function(Value) State.Aim.TargetPart = Value end
})

AimMain:Dropdown({
    Name = "Ignored teams",
    Items = { "Red", "Blue", "Green", "Yellow", "Neutral" },
    Multi = true,
    Default = { "Red" },
    Flag = "aim_ignore",
    Callback = function(Value)
        State.Aim.IgnoredTeams = Value or {}
    end
})

-- ---------- AIMBOT — TUNING ----------
local AimTuning = Aimbot:Section({
    Name = "Tuning",
    Side = 2
})

AimTuning:Slider({
    Name = "FOV",
    Min = 0, Max = 360,
    Default = 120,
    Suffix = "°",
    Flag = "aim_fov",
    Callback = function(Value) State.Aim.FOV = Value end
})

AimTuning:Slider({
    Name = "Smoothing",
    Min = 0, Max = 100,
    Default = 45,
    Suffix = "%",
    Flag = "aim_smooth",
    Callback = function(Value) State.Aim.Smoothing = Value end
})

AimTuning:RangeSlider({
    Name = "Distance range",
    Min = 0, Max = 1000,
    Default = { 50, 600 },
    Suffix = "m",
    Flag = "aim_range",
    Callback = function(Value)
        if type(Value) == "table" then
            State.Aim.RangeMin = Value[1] or 50
            State.Aim.RangeMax = Value[2] or 600
        end
    end
})

AimTuning:Keybind({
    Name = "Aim key",
    Default = Enum.KeyCode.E,
    Flag = "aim_key",
    Callback = function(key)
        if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
            State.Aim.AimKey = key
        end
    end
})

AimTuning:Colorpicker({
    Name = "FOV color",
    Default = Color3.fromRGB(179, 165, 255),
    Transparency = 0.2,
    Flag = "aim_fov_color",
    Callback = function(Value)
        State.Aim.FOVCircleColor = Value
        State.Aim.FOVColor = Value
    end
})

AimTuning:Button({
    Name = "Reset tuning",
    Callback = function()
        State.Aim.FOV = 120
        State.Aim.Smoothing = 45
        State.Aim.RangeMin = 50
        State.Aim.RangeMax = 600
        State.Aim.AimKey = Enum.KeyCode.E
        State.Aim.PredictionFac = 1.2
        Zolar:Notification({
            Name = "Tuning reset",
            Description = "All aim values returned to defaults.",
            Icon = "rotate-ccw",
            Duration = 3
        })
    end
})

-- ---------- AIMBOT — PREDICTION ----------
local AimPrediction = Aimbot:Section({
    Name = "Prediction",
    Side = 1
})

AimPrediction:Toggle({
    Name = "Velocity prediction",
    Default = true,
    Flag = "aim_pred",
    Callback = function(Value) State.Aim.Prediction = Value end
})

AimPrediction:Slider({
    Name = "Prediction factor",
    Min = 0, Max = 3,
    Default = 1.2,
    Decimals = 0.1,
    Flag = "aim_pred_factor",
    Callback = function(Value) State.Aim.PredictionFac = Value end
})

AimPrediction:Toggle({
    Name = "Resolver",
    Default = false,
    Flag = "aim_resolver",
    Callback = function(Value) State.Aim.Resolver = Value end
})

-- ---------- AIMBOT — VISUALS ----------
local AimExtras = Aimbot:Section({
    Name = "Aim visuals",
    Side = 2
})

local FovCircleToggle
FovCircleToggle = AimExtras:Toggle({
    Name = "FOV circle",
    Default = true,
    Flag = "aim_fov_show",
    Callback = function(Value) State.Aim.ShowFOV = Value end
})

local FovOptions = FovCircleToggle:Extra({})

FovOptions:Slider({
    Name = "Thickness",
    Min = 1, Max = 6,
    Default = 2,
    Flag = "aim_fov_thick",
    Callback = function(Value) State.Aim.FOVThickness = Value end
})

FovOptions:Toggle({
    Name = "Filled",
    Default = false,
    Flag = "aim_fov_filled",
    Callback = function(Value) State.Aim.FOVFilled = Value end
})

FovOptions:Colorpicker({
    Name = "Circle color",
    Default = Color3.fromRGB(179, 165, 255),
    Flag = "aim_fov_circle_color",
    Callback = function(Value) State.Aim.FOVCircleColor = Value end
})

AimExtras:Toggle({
    Name = "Show target",
    Default = false,
    Flag = "aim_show_target",
    Callback = function(Value) State.Aim.ShowTarget = Value end
})

-- ================================================================
-- TRIGGERBOT TAB
-- ================================================================
local TriggerMain = Triggerbot:Section({
    Name = "Trigger",
    Side = 1
})

TriggerMain:Toggle({
    Name = "Enabled",
    Default = false,
    Flag = "trig_enabled",
    Callback = function(Value) State.Trigger.Enabled = Value end
})

TriggerMain:Slider({
    Name = "Delay",
    Min = 0, Max = 500,
    Default = 80,
    Suffix = "ms",
    Flag = "trig_delay",
    Callback = function(Value) State.Trigger.Delay = Value end
})

TriggerMain:Textbox({
    Name = "Whitelist name",
    Placeholder = "username",
    Finished = true,
    Flag = "trig_whitelist",
    Callback = function(Value) State.Trigger.Whitelist = Value or "" end
})

local TriggerFilters = Triggerbot:Section({
    Name = "Filters",
    Side = 2
})

local WallCheckToggle
WallCheckToggle = TriggerFilters:Toggle({
    Name = "Wall check",
    Default = true,
    Flag = "trig_walls",
    Callback = function(Value) State.Trigger.WallCheck = Value end
})

WallCheckToggle:Keybind({
    Default = Enum.KeyCode.T,
    Flag = "trig_walls_key"
})

TriggerFilters:Dropdown({
    Name = "Ignored classes",
    Items = { "Scout", "Sniper", "Medic", "Heavy", "Spy" },
    Multi = true,
    Flag = "trig_ignore",
    Callback = function(Value) State.Trigger.IgnoredTeams = Value or {} end
})

local TriggerInfo = Triggerbot:Section({
    Name = "Notes",
    Side = 2
})

TriggerInfo:Paragraph({
    Title = "How it works",
    Content = "Triggerbot fires when your crosshair rests on a valid target for longer than the delay."
})

-- ================================================================
-- VISUALS TAB
-- ================================================================
local Visuals = Window:Tab({
    Name = "Visuals",
    Icon = "eye"
})

local Esp = Visuals:SubTab({
    Name = "ESP",
    Icon = "scan-eye"
})

local World = Visuals:SubTab({
    Name = "World",
    Icon = "globe"
})

-- ---------- ESP MAIN ----------
local EspMain = Esp:Section({
    Name = "Players",
    Side = 1
})

EspMain:Toggle({
    Name = "Boxes",
    Default = true,
    Flag = "esp_boxes",
    Callback = function(Value) State.ESP.Boxes = Value end
})

EspMain:Toggle({
    Name = "Names",
    Default = true,
    Flag = "esp_names",
    Callback = function(Value) State.ESP.Names = Value end
})

EspMain:Toggle({
    Name = "Tracers",
    Default = false,
    Flag = "esp_tracers",
    Callback = function(Value) State.ESP.Tracers = Value end
})

EspMain:Colorpicker({
    Name = "Box color",
    Default = Color3.fromRGB(255, 110, 120),
    Flag = "esp_box_color",
    Callback = function(Value) State.ESP.BoxColor = Value end
})

EspMain:Slider({
    Name = "Text size",
    Min = 8, Max = 24,
    Default = 14,
    Flag = "esp_text_size",
    Callback = function(Value) State.ESP.TextSize = Value end
})

EspMain:Keybind({
    Name = "Toggle ESP",
    Default = Enum.KeyCode.X,
    Flag = "esp_toggle_key"
})

-- ---------- ESP EXTRA ----------
local EspExtra = Esp:Section({
    Name = "Extras",
    Side = 2
})

EspExtra:Dropdown({
    Name = "Box style",
    Items = { "Corner", "Full", "3D" },
    Default = "Corner",
    Flag = "esp_style",
    Callback = function(Value)
        if Value == "3D" then
            State.ESP.Style = "Full"
        else
            State.ESP.Style = Value
        end
    end
})

EspExtra:Slider({
    Name = "Render distance",
    Min = 100, Max = 5000,
    Default = 1500,
    Suffix = "m",
    Flag = "esp_distance",
    Callback = function(Value) State.ESP.Distance = Value end
})

EspExtra:Label({
    Name = "Live ESP for all players"
})

-- ---------- WORLD ----------
local WorldMain = World:Section({
    Name = "Environment",
    Side = 1
})

WorldMain:Toggle({
    Name = "Fullbright",
    Default = false,
    Flag = "world_fullbright",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        if Value then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = 2
            Lighting.GlobalShadows = true
        end
    end
})

WorldMain:Slider({
    Name = "Time of day",
    Min = 0, Max = 24,
    Default = 14,
    Suffix = "h",
    Flag = "world_time",
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").ClockTime = Value
        end)
    end
})

WorldMain:Colorpicker({
    Name = "Ambient",
    Default = Color3.fromRGB(120, 130, 160),
    Flag = "world_ambient",
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").Ambient = Value
        end)
    end
})

WorldMain:Dropdown({
    Name = "Sky preset",
    Items = { "Default", "Clear", "Storm", "Night" },
    Default = "Default",
    Flag = "world_sky",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        pcall(function()
            if Value == "Clear" then
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
            elseif Value == "Storm" then
                Lighting.ClockTime = 17
                Lighting.FogEnd = 500
                Lighting.FogColor = Color3.fromRGB(80, 80, 90)
            elseif Value == "Night" then
                Lighting.ClockTime = 0
                Lighting.Brightness = 1
            else
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.Brightness = 2
            end
        end)
    end
})

WorldMain:Textbox({
    Name = "Skybox id",
    Placeholder = "rbxassetid://",
    Finished = true,
    Flag = "world_skybox",
    Callback = function(Value)
        if Value == "" then return end
        pcall(function()
            local Lighting = game:GetService("Lighting")
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Sky") then v:Destroy() end
            end
            local sky = Instance.new("Sky")
            sky.SkyboxBk = Value
            sky.SkyboxDn = Value
            sky.SkyboxFt = Value
            sky.SkyboxLf = Value
            sky.SkyboxRt = Value
            sky.SkyboxUp = Value
            sky.Parent = Lighting
        end)
    end
})

local WorldEffects = World:Section({
    Name = "Effects",
    Side = 2
})

WorldEffects:Toggle({
    Name = "No fog",
    Default = false,
    Flag = "world_nofog",
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").FogEnd = Value and 100000 or 500
        end)
    end
})

WorldEffects:Toggle({
    Name = "No shadows",
    Default = true,
    Flag = "world_noshadows",
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = not Value
        end)
    end
})

WorldEffects:Slider({
    Name = "Field of view",
    Min = 70, Max = 120,
    Default = 90,
    Suffix = "°",
    Flag = "world_fov",
    Callback = function(Value)
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = Value end
    end
})

WorldEffects:Button({
    Name = "Reset lighting",
    Callback = function()
        pcall(function()
            local Lighting = game:GetService("Lighting")
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(120, 130, 160)
        end)
        Zolar:Notification({
            Name = "Lighting reset",
            Description = "All environment values were restored.",
            Icon = "rotate-ccw",
            Duration = 3
        })
    end
})

-- ================================================================
-- TP TAB — OthersTP ONLY
-- ================================================================
local TP = Window:Tab({
    Name = "TP",
    Icon = "map-pin"
})

local OthersTP = TP:SubTab({
    Name = "OthersTP",
    Icon = "map"
})

local OthersSection = OthersTP:Section({
    Name = "Others Locations",
    Side = 1
})

-- Selected location state
local SelectedOther = OtherNamesList[1] or "Bank"

OthersSection:Dropdown({
    Name = "Location",
    Items = OtherNamesList,
    Default = SelectedOther,
    Flag = "others_loc",
    Callback = function(Value)
        if type(Value) == "table" then
            SelectedOther = Value[1] or SelectedOther
        else
            SelectedOther = Value
        end
    end
})

OthersSection:Button({
    Name = "Teleport",
    Callback = function()
        local locName = SelectedOther
        if not locName or not OtherLocByName[locName] then
            Zolar:Notification({
                Name = "TP failed",
                Description = "Pick a location first.",
                Icon = "alert-triangle",
                Duration = 3
            })
            return
        end

        local ok, result = doTeleportTo(locName)
        if ok then
            Zolar:Notification({
                Name = "Teleported",
                Description = "Teleported to " .. result,
                Icon = "map-pin",
                Duration = 3
            })
        else
            Zolar:Notification({
                Name = "TP failed",
                Description = tostring(result),
                Icon = "alert-triangle",
                Duration = 3
            })
        end
    end
})

-- Info card (Side 2) — daftar lokasi + koordinat
local OthersInfo = OthersTP:Section({
    Name = "Location Info",
    Side = 2
})

OthersInfo:Paragraph({
    Title = "How to use",
    Content = "1. Pilih lokasi di dropdown.\n2. Tekan tombol Teleport.\n3. Karakter akan dipindahkan ke koordinat lokasi tersebut."
})

OthersInfo:Paragraph({
    Title = "Total locations",
    Content = tostring(#OTHERS_LOCATIONS) .. " lokasi Others dari Lenger"
})

-- ================================================================
-- SETTINGS TAB
-- ================================================================
local Settings = Window:Tab({
    Name = "Settings",
    Icon = "settings"
})

local Config = Settings:SubTab({
    Name = "Config",
    Icon = "save"
})

Config:ThemeConfig({})

Window:Watermark({
    Name = "ZOLAR"
})

Zolar:Notification({
    Name = "ZOLAR loaded",
    Description = "Aimbot / ESP / TP ready. Hold aim key (E) or RMB to lock.",
    Icon = "check",
    Duration = 6
})