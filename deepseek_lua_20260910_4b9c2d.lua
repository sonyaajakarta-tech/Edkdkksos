-- ================================================================
-- DARK HUB V3.0 — AETHER LIBRARY EDITION
-- Migrated from LENGER STORE / custom UI to Aether Library
-- Logic preserved, UI replaced with Aether
-- ================================================================

local AetherURL = "https://raw.githubusercontent.com/jewishskids/Aether.lua-Library/refs/heads/main/Source"
local Library = loadstring(game:HttpGet(AetherURL))()

-- ================================================================
-- SERVICES & SHARED STATE
-- ================================================================
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")
local RS           = game:GetService("ReplicatedStorage")
local ProximityPS  = game:GetService("ProximityPromptService")
local Http         = game:GetService("HttpService")
local plr          = Players.LocalPlayer

local SAVEFILE = "darkhub_settings.json"

-- Semua FLAGS (dipertahankan persis)
local Flags = {
    BoxESP=false, Tracer=false,
    ESPName=true, ESPDist=true, ESPHPBar=true, ESPWeapon=true, ESPSkeleton=false, ESPMasak=true,
    TPNoClip=false, AimLock=false,
    WallCheck=false,
    InvScan=false, InstantInteract=false,
    AutoCook=false, InfStamina=false,
    HybridSpeed=false, AuraKill=false,
}
local AimFOV_Radius  = 120
local SilentFOV_Radius = 120
local AimMax_Dist    = 300
local TracerMaxDist  = 300
local ESPMaxDist     = 500
local AimSmooth      = 0.85
local AimTarget      = nil
local AimPart        = "Head"
local AimMode        = "PC"
local BoxESPMode     = "FULL"
local BlinkMode      = "PC"
local SilentAim      = false
local SilentAimWallbang = false
local ShowAimFOV     = true
local ShowSilentFOV  = true
local SilentMode     = "PC"
local AimWhitelist   = {}

local Running        = true
local tpBusy         = false
local tpCancelled    = false
local tpActive       = false
local _htpo          = {fn = function() end}
local _overlayActive = false

local ESP = {}

local function saveSettings()
    pcall(function()
        writefile(SAVEFILE, Http:JSONEncode({
            Flags = Flags,
            AimFOV_Radius = AimFOV_Radius,
            AimMax_Dist = AimMax_Dist,
        }))
    end)
end

-- ================================================================
-- WINDOW
-- ================================================================
local MainWindow = Library:CreateWindow({
    Title = "DARK HUB",
    SubText = "TikTok: @darkhub | Discord: discord.gg/pDEyArQ5B",
    Image = "rbxassetid://95259225424429",
    IsMobile = true
})

local MainTab   = MainWindow:AddTab({ Text = "MAIN",   Icon = "rbxassetid://108020878442937" })
local VisualTab = MainWindow:AddTab({ Text = "VISUAL", Icon = "rbxassetid://108020878442937" })
local AimTab    = MainWindow:AddTab({ Text = "AIM",    Icon = "rbxassetid://108020878442937" })
local FarmTab   = MainWindow:AddTab({ Text = "FARM",   Icon = "rbxassetid://108020878442937" })
local TPTab     = MainWindow:AddTab({ Text = "TP",     Icon = "rbxassetid://108020878442937" })
local InfoTab   = MainWindow:AddTab({ Text = "INFO",   Icon = "rbxassetid://108020878442937" })
local CfgTab    = MainWindow:AddTab({ Text = "CFG",    Icon = "rbxassetid://108020878442937" })
local VehTab    = MainWindow:AddTab({ Text = "VEH",    Icon = "rbxassetid://108020878442937" })

-- ================================================================
-- DRAWING OBJECTS (ESP pool, FOV circles)
-- ================================================================
local FovCircle = Drawing.new("Circle")
FovCircle.Thickness=1.5; FovCircle.Color=Color3.fromRGB(0,170,255)
FovCircle.Filled=false; FovCircle.NumSides=64; FovCircle.Visible=false

local SilentFovCircle = Drawing.new("Circle")
SilentFovCircle.Thickness=1.5; SilentFovCircle.Color=Color3.fromRGB(0,170,255)
SilentFovCircle.Filled=false; SilentFovCircle.NumSides=64; SilentFovCircle.Visible=false

local SilentLine = Drawing.new("Line")
SilentLine.Thickness=1.5; SilentLine.Color=Color3.fromRGB(0,170,255)
SilentLine.Transparency=1; SilentLine.Visible=false

local function _mkLine(t,c) local d=Drawing.new("Line"); d.Thickness=t; d.Color=c; d.Visible=false; return d end
local function _mkText(s,c)
    local d=Drawing.new("Text"); d.Size=s; d.Color=c; d.Outline=true
    d.OutlineColor=Color3.fromRGB(0,0,0); d.Center=true; d.Font=Drawing.Fonts.Plex; d.Visible=false
    return d
end
local function _hideESP(e)
    e.box.Visible=false; e.hpbg.Visible=false; e.hpbar.Visible=false
    e.hpnum.Visible=false; e.dispname.Visible=false; e.username.Visible=false
    e.dist.Visible=false; e.weapon.Visible=false; e.masak.Visible=false; e.tracer.Visible=false
    for _,c in ipairs(e.corners) do c.Visible=false end
    for _,s in ipairs(e.skeleton) do s.Visible=false end
end

local function createESP(p)
    if ESP[p] or p == plr then return end
    local _c = {}
    for i=1,8 do
        local cl=Drawing.new("Line"); cl.Thickness=2; cl.Color=Color3.fromRGB(0,170,255); cl.Visible=false
        _c[i]=cl
    end
    local _sk = {}
    for i=1,15 do
        local sl=Drawing.new("Line"); sl.Thickness=1.2; sl.Color=Color3.fromRGB(0,170,255); sl.Visible=false
        _sk[i]=sl
    end
    local e = {
        box=Drawing.new("Square"), hpbg=Drawing.new("Square"), hpbar=Drawing.new("Square"),
        hpnum=_mkText(10,Color3.fromRGB(255,255,255)),
        dispname=_mkText(13,Color3.fromRGB(255,255,255)),
        username=_mkText(11,Color3.fromRGB(180,200,220)),
        dist=_mkText(11,Color3.fromRGB(160,180,210)),
        weapon=_mkText(11,Color3.fromRGB(0,200,255)),
        tracer=_mkLine(1.2,Color3.fromRGB(0,170,255)),
        masak=_mkText(13,Color3.fromRGB(0,255,120)),
        corners=_c, skeleton=_sk,
    }
    e.box.Thickness=1.5; e.box.Filled=false
    e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
    e.hpbar.Thickness=1; e.hpbar.Filled=true
    ESP[p]=e
end

local function removeESP(p)
    if not ESP[p] then return end
    local _e=ESP[p]
    if _e.corners then for _,c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
    if _e.skeleton then for _,s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
    for k,d in pairs(_e) do
        if k~="corners" and k~="skeleton" then pcall(function() d:Remove() end) end
    end
    ESP[p]=nil
end

-- ================================================================
-- VEHICLE TELEPORT (logic preserved)
-- ================================================================
local function doVehicleTP(targetCFrame)
    local char = plr.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat then return false end
    local vehicle = seat:FindFirstAncestorOfClass("Model")
    if not vehicle then return false end
    local vRoot = vehicle.PrimaryPart or seat
    vRoot.AssemblyLinearVelocity = Vector3.new(0,0,0)
    vRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
    vehicle:PivotTo(targetCFrame * CFrame.new(0,3,0))
    task.wait(0.1)
    vRoot.AssemblyLinearVelocity = Vector3.new(0,0,0)
    vRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
    return true
end

-- ================================================================
-- TP SYSTEM (logic preserved)
-- ================================================================
local UNDERGROUND_Y = -4.00
local TP_SPEED = 16
local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)

local function _resetHumanoid()
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

local function _moveCharTo(targetPos)
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

local function _lerpChar(fromPos, toPos, speed)
    local dist = (toPos - fromPos).Magnitude
    if dist < 0.05 then return true end
    local travelT = dist / speed
    local elapsed = 0
    while elapsed < travelT and not tpCancelled do
        local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp2 then return false end
        local t = math.clamp(elapsed / travelT, 0, 1)
        _moveCharTo(fromPos:Lerp(toPos, t))
        local _, dt = RunService.Stepped:Wait()
        elapsed = elapsed + dt
    end
    if not tpCancelled then _moveCharTo(toPos) end
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

    _overlayActive = true
    FovCircle.Visible = false
    for _, e in pairs(ESP) do _hideESP(e) end

    local underPos = Vector3.new(hrp.Position.X, UNDERGROUND_Y, hrp.Position.Z)
    local ok = _lerpChar(hrp.Position, underPos, TP_SPEED)
    if ok and not tpCancelled then
        local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp2 then
            ok = _lerpChar(hrp2.Position, Vector3.new(cx, UNDERGROUND_Y, cz), TP_SPEED)
        else ok = false end
    end
    if ok and not tpCancelled then
        local hrp3 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp3 then
            _lerpChar(hrp3.Position, Vector3.new(cx, cy+3, cz), TP_SPEED)
        end
    end

    _overlayActive = false
    _resetHumanoid()
    tpActive = false
    if destName then Library:Notify({Title="Arrived: "..destName, Lifetime=2}) end
end

local function doSuicideTP(loc)
    tpBusy = true
    _overlayActive = true
    local ch = plr.Character
    local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp0 then tpBusy=false; _overlayActive=false; return end
    hrp0.CFrame = CFrame.new(RESPAWN_WARP)
    local newChar = plr.CharacterAdded:Wait()
    local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
    local hum = newChar:WaitForChild("Humanoid", 10)
    if not hrp or not hum then tpBusy=false; _overlayActive=false; return end
    local waited = 0
    while hum.Health <= 0 and waited < 5 do task.wait(0.1); waited += 0.1 end
    task.wait(0.8)
    local targetCF = CFrame.new(loc.x, loc.y+3, loc.z)
    for _ = 1, 4 do hrp.CFrame = targetCF; task.wait(0.15) end
    task.wait(0.1)
    _overlayActive = false
    tpBusy = false
    if loc.name then Library:Notify({Title="Arrived: "..loc.name, Lifetime=2}) end
end

-- ================================================================
-- ░░ MAIN TAB ░░
-- ================================================================
local MainSection = MainTab:AddSection({ Title = "Main Features", Side = "Left" })

MainSection:AddToggle({
    Text = "Blink TP", Flag = "TPNoClip", Default = false,
    Callback = function(v) Flags.TPNoClip = v; saveSettings() end
})
MainSection:AddDropdown({
    Text = "Blink Mode", Flag = "BlinkMode",
    Options = {"PC","HP"}, Default = "PC",
    Callback = function(v) BlinkMode = v end
})
MainSection:AddToggle({
    Text = "Inf Stamina", Flag = "InfStamina", Default = false,
    Callback = function(v) Flags.InfStamina = v; saveSettings() end
})
MainSection:AddToggle({
    Text = "Speed Hack", Flag = "HybridSpeed", Default = false,
    Callback = function(v) Flags.HybridSpeed = v; saveSettings() end
})
MainSection:AddToggle({
    Text = "NoClip", Flag = "AuraKill", Default = false,
    Callback = function(v) Flags.AuraKill = v; saveSettings() end
})
MainSection:AddToggle({
    Text = "Inv Scan", Flag = "InvScan", Default = false,
    Callback = function(v) Flags.InvScan = v; saveSettings() end
})
MainSection:AddToggle({
    Text = "Instant Interact", Flag = "InstantInteract", Default = false,
    Callback = function(v) Flags.InstantInteract = v; saveSettings() end
})

local RsSection = MainTab:AddSection({ Title = "Reduce Grafik (perlu rejoin)", Side = "Right" })
RsSection:AddButton({
    Text = "Reduce Grafik",
    Callback = function()
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
        local function hI(inst)
            if inst:IsA("BasePart") then
                if localChar and inst:IsDescendantOf(localChar) then return end
                pcall(function() inst.Material = Enum.Material.SmoothPlastic; inst.Reflectance = 0 end)
            end
            if inst:IsA("Texture") or inst:IsA("Decal") then
                if localChar and inst:IsDescendantOf(localChar) then return end
                pcall(function() inst.Transparency = 1 end)
            end
        end
        local all = workspace:GetDescendants()
        for i = 1, #all, 100 do
            for j = i, math.min(i+99, #all) do pcall(function() hI(all[j]) end) end
            task.wait()
        end
        pcall(function()
            local t = workspace:FindFirstChild("Terrain")
            if t then t.WaterWaveSize=0; t.WaveSpeed=0; t.WaterReflectance=0; t.WaterTransparency=1 end
            settings().Physics.AllowSleep = true
            settings().Rendering.QualityLevel = 1
            settings().Rendering.TextureQuality = Enum.TextureQuality.Low
        end)
        Library:Notify({Title="Reduce Grafik aktif — rejoin untuk restore", Lifetime=4})
    end
})

-- Wall Selector (simplified to toggle + keybind, logic preserved)
local WSSection = MainTab:AddSection({ Title = "Wall Selector", Side = "Left" })
local wsSelectMode, wsSelected, wsDisabled, wsHighlights = false, {}, {}, {}
local wsHoverBox = Instance.new("SelectionBox", workspace)
wsHoverBox.Color3 = Color3.fromRGB(0,170,255)
wsHoverBox.LineThickness = 0.05
wsHoverBox.SurfaceTransparency = 0.88
wsHoverBox.SurfaceColor3 = Color3.fromRGB(0,170,255)

local function wsGetTarget()
    local lp2 = plr
    local mouse2 = lp2:GetMouse()
    local cam2 = workspace.CurrentCamera
    local unitRay = cam2:ScreenPointToRay(mouse2.X, mouse2.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local chars = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then table.insert(chars, p.Character) end
    end
    params.FilterDescendantsInstances = chars
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction*1000, params)
    return result and result.Instance
end
local function wsAddHL(part)
    if wsHighlights[part] then return end
    local b = Instance.new("SelectionBox", workspace)
    b.Adornee = part
    b.Color3 = Color3.fromRGB(0,170,255)
    b.LineThickness = 0.07
    b.SurfaceTransparency = 0.75
    b.SurfaceColor3 = Color3.fromRGB(0,170,255)
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
    if wsSelected[part] then wsSelected[part]=nil; wsRemoveHL(part)
    else wsSelected[part]=true; wsAddHL(part) end
end
local function wsDoDisable()
    for part in pairs(wsSelected) do
        if part and part.Parent then
            wsDisabled[part] = {trans=part.Transparency, collide=part.CanCollide, shadow=part.CastShadow}
            pcall(function() part.Transparency=0.9; part.CanCollide=false; part.CastShadow=false end)
            wsRemoveHL(part)
        end
    end
    wsSelected = {}
end
local function wsDoRestore()
    for part, p in pairs(wsDisabled) do
        if part and part.Parent then
            pcall(function() part.Transparency=p.trans; part.CanCollide=p.collide; part.CastShadow=p.shadow end)
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
plr:GetMouse().Button1Down:Connect(function()
    if not wsSelectMode then return end
    local t = wsGetTarget()
    if t then wsDoSelect(t) end
end)
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.P then
        wsSelectMode = not wsSelectMode
        if not wsSelectMode then wsHoverBox.Adornee = nil end
    elseif inp.KeyCode == Enum.KeyCode.M then wsDoDisable()
    elseif inp.KeyCode == Enum.KeyCode.L then wsDoRestore()
    elseif inp.KeyCode == Enum.KeyCode.K then wsDoClr()
    end
end)

WSSection:AddToggle({
    Text = "Wall Select Mode", Flag = "WSMode", Default = false,
    Callback = function(v) wsSelectMode = v; if not v then wsHoverBox.Adornee = nil end end
})
WSSection:AddButton({Text="[M] Disable Selected", Callback=wsDoDisable})
WSSection:AddButton({Text="[L] Restore All",       Callback=wsDoRestore})
WSSection:AddButton({Text="[K] Clear Selection",   Callback=wsDoClr})

-- Fake Name
local FakeSection = MainTab:AddSection({ Title = "Fake Name", Side = "Right" })
local FN = {name1="", name2=""}
FakeSection:AddTextbox({
    Text = "In-Game Name", Placeholder = "Kosongkan jika tidak diubah",
    Callback = function(v) FN.name1 = v end
})
FakeSection:AddTextbox({
    Text = "Username", Placeholder = "Kosongkan jika tidak diubah",
    Callback = function(v) FN.name2 = v end
})
FakeSection:AddButton({
    Text = "Apply Fake Name",
    Callback = function()
        local ok = false
        pcall(function()
            local char = plr.Character
            local myChar = (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(plr.Name)) or char
            if not myChar or not myChar.Head then return end
            if FN.name1 ~= "" then
                local tag1 = myChar.Head:FindFirstChild("NameTag")
                if tag1 then
                    local lbl = tag1:FindFirstChild("MainFrame") and tag1.MainFrame:FindFirstChild("NameLabel")
                    if lbl then
                        lbl.Text = FN.name1
                        lbl.TextColor3 = Color3.fromRGB(255,255,255)
                        lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                        lbl.TextStrokeTransparency = 0.5
                        ok = true
                    end
                end
            end
            if FN.name2 ~= "" then
                local tag2 = myChar.Head:FindFirstChild("RankTag")
                if tag2 then
                    local lbl = tag2:FindFirstChild("MainFrame") and tag2.MainFrame:FindFirstChild("NameLabel")
                    if lbl then
                        lbl.Text = FN.name2
                        lbl.TextColor3 = Color3.fromRGB(255,255,255)
                        lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                        lbl.TextStrokeTransparency = 0.5
                        ok = true
                    end
                end
            end
        end)
        Library:Notify({Title = ok and "Fake name applied!" or "Tag not found", Lifetime = 2})
    end
})

-- ================================================================
-- ░░ VISUAL TAB ░░
-- ================================================================
local VisSection = VisualTab:AddSection({ Title = "ESP", Side = "Left" })
VisSection:AddToggle({Text="Box ESP",  Flag="BoxESP",   Default=false, Callback=function(v) Flags.BoxESP=v end})
VisSection:AddDropdown({Text="Box Mode", Flag="BoxESPMode", Options={"FULL","CORNER"}, Default="FULL",
    Callback=function(v) BoxESPMode=v end})
VisSection:AddToggle({Text="Tracer",   Flag="Tracer",   Default=false, Callback=function(v) Flags.Tracer=v end})
VisSection:AddToggle({Text="Name",     Flag="ESPName",  Default=true,  Callback=function(v) Flags.ESPName=v end})
VisSection:AddToggle({Text="Distance", Flag="ESPDist",  Default=true,  Callback=function(v) Flags.ESPDist=v end})
VisSection:AddToggle({Text="HP Bar",   Flag="ESPHPBar", Default=true,  Callback=function(v) Flags.ESPHPBar=v end})
VisSection:AddToggle({Text="Gun",      Flag="ESPWeapon",Default=true,  Callback=function(v) Flags.ESPWeapon=v end})
VisSection:AddToggle({Text="Skeleton", Flag="ESPSkeleton",Default=false, Callback=function(v) Flags.ESPSkeleton=v end})
VisSection:AddToggle({Text="Masak",    Flag="ESPMasak", Default=true,  Callback=function(v) Flags.ESPMasak=v end})

local VisSectionR = VisualTab:AddSection({ Title = "Range & FOV", Side = "Right" })
VisSectionR:AddSlider({Text="Tracer Distance", Min=50, Max=1000, Default=TracerMaxDist, Suffix="studs",
    Callback=function(v) TracerMaxDist=v end})
VisSectionR:AddSlider({Text="ESP Distance", Min=10, Max=5000, Default=ESPMaxDist, Suffix="studs",
    Callback=function(v) ESPMaxDist=v end})

-- Spectate
local SpecSection = VisualTab:AddSection({ Title = "Spectate", Side = "Right" })
local specTarget, specConn = nil, nil
local specOptions = {}
local function refreshSpecOptions()
    specOptions = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then table.insert(specOptions, p.Name) end
    end
end
refreshSpecOptions()

local function stopSpectate()
    if specConn then specConn:Disconnect(); specConn = nil end
    specTarget = nil
    local cam = workspace.CurrentCamera
    pcall(function()
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    end)
end

local function startSpectate(name)
    stopSpectate()
    local targetPlr = Players:FindFirstChild(name)
    if not targetPlr or not targetPlr.Character then return end
    specTarget = targetPlr
    local cam = workspace.CurrentCamera
    pcall(function()
        local hum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = hum
    end)
    specConn = RunService.RenderStepped:Connect(function()
        if not specTarget or not specTarget.Parent then stopSpectate(); return end
        local char = specTarget.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if cam.CameraType ~= Enum.CameraType.Custom then cam.CameraType = Enum.CameraType.Custom end
        if hum and cam.CameraSubject ~= hum then cam.CameraSubject = hum end
    end)
end

SpecSection:AddDropdown({
    Text = "Select Player", Flag = "SpecTarget",
    Options = specOptions, Default = "",
    Callback = function(v)
        if v and v ~= "" then startSpectate(v) end
    end
})
SpecSection:AddButton({Text="Stop Spectate", Callback=stopSpectate})
SpecSection:AddButton({Text="Refresh List", Callback=function()
    refreshSpecOptions()
    Library:Notify({Title="Refresh — reopen dropdown", Lifetime=2})
end})

-- ================================================================
-- ░░ AIM TAB ░░
-- ================================================================
local AimSection = AimTab:AddSection({ Title = "Aimbot", Side = "Left" })
AimSection:AddToggle({Text="Auto Aim", Flag="AimLock", Default=false, Callback=function(v) Flags.AimLock=v; saveSettings() end})
AimSection:AddDropdown({Text="Aim Mode", Flag="AimMode", Options={"PC","HP"}, Default="PC",
    Callback=function(v) AimMode=v; AimTarget=nil end})
AimSection:AddDropdown({Text="Target Part", Flag="AimPart", Options={"Head","Body"}, Default="Head",
    Callback=function(v) AimPart = (v=="Head") and "Head" or "Body"; AimTarget=nil end})
AimSection:AddToggle({Text="Wall Check", Flag="WallCheck", Default=false, Callback=function(v) Flags.WallCheck=v; saveSettings() end})
AimSection:AddSlider({Text="FOV Radius (Aimbot)", Min=30, Max=400, Default=AimFOV_Radius, Suffix="px",
    Callback=function(v) AimFOV_Radius=v; saveSettings() end})
AimSection:AddSlider({Text="Max Distance", Min=50, Max=1000, Default=AimMax_Dist, Suffix="studs",
    Callback=function(v) AimMax_Dist=v; saveSettings() end})
AimSection:AddSlider({Text="Smoothness", Min=1, Max=100, Default=math.floor(AimSmooth*100), Suffix="%",
    Callback=function(v) AimSmooth=math.clamp(v/100, 0.01, 0.99); saveSettings() end})

local SAimSection = AimTab:AddSection({ Title = "Silent Aim", Side = "Right" })
SAimSection:AddToggle({Text="Silent Aim", Flag="SilentAim", Default=false, Callback=function(v) SilentAim=v end})
SAimSection:AddToggle({Text="Silent Wallbang", Flag="SAWB", Default=false, Callback=function(v) SilentAimWallbang=v end})
SAimSection:AddDropdown({Text="Silent Mode", Flag="SilentMode", Options={"PC","HP"}, Default="PC",
    Callback=function(v) SilentMode=v end})
SAimSection:AddSlider({Text="FOV Radius (Silent)", Min=30, Max=400, Default=SilentFOV_Radius, Suffix="px",
    Callback=function(v) SilentFOV_Radius=v end})
SAimSection:AddToggle({Text="Show FOV Aimbot", Flag="ShowAimFOV", Default=true, Callback=function(v) ShowAimFOV=v end})
SAimSection:AddToggle({Text="Show FOV Silent", Flag="ShowSilentFOV", Default=true, Callback=function(v) ShowSilentFOV=v end})

-- Silent Aim hook (logic preserved)
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
                if not SilentAim then return OldCast(...) end
                local cam = workspace.CurrentCamera
                local vp2 = cam.ViewportSize
                local saFovCenter = SilentMode=="HP" and Vector2.new(vp2.X/2,vp2.Y/2) or UIS:GetMouseLocation()
                local Target, LowestDist = nil, math.huge
                for _, p in pairs(Players:GetPlayers()) do
                    local ch = p.Character
                    if p == plr or not ch then continue end
                    local hitPart = ch:FindFirstChild(AimPart=="Head" and "Head" or "HumanoidRootPart")
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
                    local hp = Target.Character and Target.Character:FindFirstChild(AimPart=="Head" and "Head" or "HumanoidRootPart")
                    if hp then
                        args[2] = hp.Position - args[1]
                        if SilentAimWallbang then args[3] = {Target.Character}; return cw(table.unpack(args)) end
                    end
                    return OldCast(table.unpack(args))
                end
                return OldCast(...)
            end)
            break
        end
    end
end)

-- Whitelist
local WLSet = AimTab:AddSection({ Title = "Whitelist Aim", Side = "Right" })
local wlOptions = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= plr then table.insert(wlOptions, p.Name) end end
WLSet:AddDropdown({
    Text = "Toggle Whitelist", Flag = "WLPlayer",
    Options = wlOptions, Default = "",
    Callback = function(v)
        if not v or v == "" then return end
        if AimWhitelist[v] then AimWhitelist[v] = nil
        else AimWhitelist[v] = true end
        Library:Notify({Title = (AimWhitelist[v] and "Added WL: " or "Removed WL: ")..v, Lifetime=2})
    end
})

-- ================================================================
-- ░░ FARM TAB ░░
-- ================================================================
-- (Preserve semua logic, tapi UI pakai Aether)

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
local selectedApart = nil
for _, a in ipairs(APARTMENTS) do
    if a.side == "R" and a.rx then a.cx=a.rx; a.cy=a.ry; a.cz=a.rz else a.cx=a.lx; a.cy=a.ly; a.cz=a.lz end
    if a.side == "R" and a.topRx then a.topCx=a.topRx; a.topCy=a.topRy; a.topCz=a.topRz
    elseif a.topLx then a.topCx=a.topLx; a.topCy=a.topLy; a.topCz=a.topLz end
end
local totalMasak = 0
local currentCookStep = 1
local lastCookProgressTime = 0
local COOK_WATCHDOG_SECS = 150
local cookSteps = {
    {keyword="water", baseWait=20},
    {multi={{keyword="sugar", wait=1.5},{keyword="gelatin", wait=45}}},
    {keyword="empty", baseWait=2},
}

local apartOptions = {}
for _, a in ipairs(APARTMENTS) do table.insert(apartOptions, a.name) end

local FarmSelSection = FarmTab:AddSection({ Title = "Apartment Selection", Side = "Left" })
FarmSelSection:AddDropdown({
    Text = "Select Apartment", Flag = "SelApart",
    Options = apartOptions, Default = "",
    Callback = function(v)
        for _, a in ipairs(APARTMENTS) do
            if a.name == v then selectedApart = a; break end
        end
    end
})
FarmSelSection:AddDropdown({
    Text = "Side L/R", Flag = "SelSide", Options = {"L","R"}, Default = "L",
    Callback = function(v)
        if not selectedApart then return end
        selectedApart.side = v
        if v == "R" and selectedApart.rx then
            selectedApart.cx=selectedApart.rx; selectedApart.cy=selectedApart.ry; selectedApart.cz=selectedApart.rz
            if selectedApart.topRx then selectedApart.topCx=selectedApart.topRx; selectedApart.topCy=selectedApart.topRy; selectedApart.topCz=selectedApart.topRz end
        else
            selectedApart.cx=selectedApart.lx; selectedApart.cy=selectedApart.ly; selectedApart.cz=selectedApart.lz
            if selectedApart.topLx then selectedApart.topCx=selectedApart.topLx; selectedApart.topCy=selectedApart.topLy; selectedApart.topCz=selectedApart.topLz end
        end
    end
})
FarmSelSection:AddButton({
    Text = "GO to Apartment",
    Callback = function()
        if not selectedApart then Library:Notify({Title="Pilih apartment dulu",Lifetime=2}); return end
        task.spawn(function()
            local a = selectedApart
            local tx,ty,tz = a.cx or a.x, a.cy or a.y, a.cz or a.z
            local ch = plr.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                hum.WalkSpeed = 0
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(tx, ty+3, tz)
                task.wait(0.1)
                hrp.CFrame = CFrame.new(tx, ty+3, tz)
                task.wait(0.1)
                hum.WalkSpeed = 16
            end
        end)
    end
})

-- Auto Cook
local CookSection = FarmTab:AddSection({ Title = "Auto Cook", Side = "Left" })

local function setApart56FloorCollide(state)
    local function setObj(obj)
        pcall(function()
            if obj:IsA("BasePart") then obj.CanCollide = state end
            for _, p in ipairs(obj:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = state end end
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
            local grandParent = (parent and parent.Parent and parent.Parent.Name or ""):lower()
            local parentName = parent.Name:lower()
            local actionText = obj.ActionText:lower()
            local isCook = grandParent:find("cooking pot") or grandParent:find("pot")
                or parentName:find("pot") or parentName:find("cook")
                or actionText:find("cook") or actionText:find("interact")
                or actionText:find("add") or actionText:find("place")
                or actionText:find("use") or actionText:find("put")
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
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist/10000, 0.05), Enum.EasingStyle.Linear), {CFrame = targetCF})
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

_G.HNDRIXX_RESTORE_FLOOR = function()
    local function restoreObj(obj)
        pcall(function()
            if obj:IsA("BasePart") then obj.CanCollide = true end
            for _, p in ipairs(obj:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end)
    end
    pcall(function()
        local lt1 = workspace.Map.Houses.LT1.Interior
        restoreObj(lt1.Floor); restoreObj(lt1.Stove); restoreObj(lt1.Part)
        restoreObj(lt1:GetChildren()[22]); restoreObj(lt1:GetChildren()[23]); restoreObj(lt1:GetChildren()[32])
    end)
    pcall(function()
        local bh1 = workspace.Map.Houses.BH1.Interior
        restoreObj(bh1.Floor); restoreObj(bh1.Stove); restoreObj(bh1.Part)
        restoreObj(bh1:GetChildren()[22]); restoreObj(bh1:GetChildren()[23]); restoreObj(bh1:GetChildren()[32])
    end)
end

CookSection:AddToggle({
    Text = "Auto Cook", Flag = "AutoCook", Default = false,
    Callback = function(v)
        Flags.AutoCook = v
        saveSettings()
        if v then
            if selectedApart then
                local aptName = selectedApart.name:lower()
                if aptName:find("apt 5") or aptName:find("apt5") or aptName:find("west")
                    or aptName:find("apt 6") or aptName:find("apt6") then
                    setApart56FloorCollide(false)
                end
            end
            lastCookProgressTime = tick()
            if selectedApart and not isCasinoApart() and selectedApart.cx then
                task.spawn(function()
                    local ch = plr.Character
                    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local tCF = CFrame.new(selectedApart.cx, selectedApart.cy, selectedApart.cz)
                    local dist = (hrp.Position - tCF.Position).Magnitude
                    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(dist/10000,0.05), Enum.EasingStyle.Linear), {CFrame=tCF})
                    tw:Play(); tw.Completed:Wait()
                end)
            end
        else
            setApart56FloorCollide(true)
        end
    end
})
CookSection:AddButton({Text="Reset Cook Counter", Callback=function() totalMasak=0; currentCookStep=1 end})

-- Auto Cook worker (logic preserved)
task.spawn(function()
    while Running do
        task.wait(math.random(10,20)/100)
        if Flags.AutoCook then
            if lastCookProgressTime > 0 and (tick() - lastCookProgressTime) > COOK_WATCHDOG_SECS then
                currentCookStep = 1; lastCookProgressTime = tick(); task.wait(1.5)
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
            local function doOneBahan(keyword, waitTime, needDown)
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
                local tw = 0; local hw = waitTime + (math.random(1,5)/10)
                while tw < hw and Flags.AutoCook and Running do
                    local mw = math.random(3,5)/10
                    task.wait(mw); tw = tw + mw
                end
                return true
            end
            if data.multi then
                local allOk = true
                for _, sub in ipairs(data.multi) do
                    if not Flags.AutoCook or not Running then allOk=false; break end
                    local ok = doOneBahan(sub.keyword, sub.wait, false)
                    if not ok then
                        Flags.AutoCook = false
                        if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
                        allOk = false; break
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
                            local p2 = findCookPrompt(); if p2 then triggerPrompt(p2) end
                        end
                    end
                    if isCasinoApart() and not needDown then snapToTopPos() end
                    local hw = data.baseWait + (math.random(1,5)/10)
                    local tw = 0
                    while tw < hw and Flags.AutoCook and Running do
                        local mw = math.random(3,5)/10
                        task.wait(mw); tw = tw + mw
                    end
                    if Flags.AutoCook and Running then
                        if data.keyword == "empty" then totalMasak = totalMasak + 1 end
                        currentCookStep = currentCookStep + 1
                        if currentCookStep > #cookSteps then currentCookStep = 1 end
                        lastCookProgressTime = tick()
                    end
                else
                    Flags.AutoCook = false
                    if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
                end
            end
        end
    end
end)

-- Auto Buy
local BuySection = FarmTab:AddSection({ Title = "Auto Buy (Lamont Bell)", Side = "Right" })
local ITEM_PRICE = {["Water"]=20, ["Sugar Block Bag"]=100, ["Gelatin"]=70}
local MONEY_KEYS = {"Money","Cash","Coins","Dollars","Credits","Currency","Gold","Bucks","Pat"}
local function abGetMoney()
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        for _, k in ipairs(MONEY_KEYS) do
            local v = ls:FindFirstChild(k)
            if v and (v:IsA("IntValue") or v:IsA("NumberValue")) then return v.Value, k end
        end
    end
    return nil
end
local function abCountItem(name)
    local n = 0
    for _, t in ipairs(plr.Backpack:GetChildren()) do if t.Name == name then n += 1 end end
    local ch = plr.Character
    if ch then for _, t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t.Name == name then n += 1 end end end
    return n
end
local AutoBuyAmount = 10
BuySection:AddSlider({Text="Amount", Min=1, Max=100, Default=10, Suffix="x",
    Callback=function(v) AutoBuyAmount = v end})

local function doRemoteBuy(itemNames, qty)
    task.spawn(function()
        local remEvts = RS:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then Library:Notify({Title="RemoteEvent tidak ada!",Lifetime=3}); return end
        local money = abGetMoney()
        local est = 0
        for _, n in ipairs(itemNames) do est += (ITEM_PRICE[n] or 0) * qty end
        if money ~= nil and est > 0 and money < est then
            Library:Notify({Title="Uang kurang! Butuh ~"..est, Lifetime=3}); return
        end
        local total = 0
        for _, itemName in ipairs(itemNames) do
            local before = abCountItem(itemName)
            for i = 1, qty do
                pcall(function() spRE:FireServer(itemName, 1) end)
                task.wait(0.4)
            end
            local elapsed, gained = 0, 0
            repeat
                task.wait(0.2); elapsed += 0.2
                gained = abCountItem(itemName) - before
            until gained >= qty or elapsed > 8
            total += gained
            task.wait(0.3)
        end
        Library:Notify({Title="Buy selesai: "..total.." item", Lifetime=3})
    end)
end

BuySection:AddButton({Text="Buy PACK", Callback=function() doRemoteBuy({"Water","Sugar Block Bag","Gelatin"}, AutoBuyAmount) end})
BuySection:AddButton({Text="Buy Water", Callback=function() doRemoteBuy({"Water"}, AutoBuyAmount) end})
BuySection:AddButton({Text="Buy Sugar", Callback=function() doRemoteBuy({"Sugar Block Bag"}, AutoBuyAmount) end})
BuySection:AddButton({Text="Buy Gelatin", Callback=function() doRemoteBuy({"Gelatin"}, AutoBuyAmount) end})

-- Auto Sell Marshmallow
local SellSec = FarmTab:AddSection({ Title = "Auto Sell Marshmallow", Side = "Right" })
local function findNearestPrompt()
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
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
            if not pos then continue end
            local dist = (pos - hrp.Position).Magnitude
            local actionText = obj.ActionText:lower()
            if actionText:find("interact") and dist < bestDist then bestDist = dist; best = obj end
        end
    end
    return best
end
local function getMarshmallows()
    local list = {}
    if plr.Backpack then
        for _, v in pairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") and string.lower(v.Name):find("marshmallow") then table.insert(list, v) end
        end
    end
    if plr.Character then
        for _, v in pairs(plr.Character:GetChildren()) do
            if v:IsA("Tool") and string.lower(v.Name):find("marshmallow") then table.insert(list, v) end
        end
    end
    return list
end
SellSec:AddButton({
    Text = "Sell Marshmallow",
    Callback = function()
        task.spawn(function()
            local list = getMarshmallows()
            if #list == 0 then Library:Notify({Title="Tidak ada Marshmallow",Lifetime=3}); return end
            local prompt = findNearestPrompt()
            if not prompt then Library:Notify({Title="Prompt tidak ditemukan",Lifetime=3}); return end
            pcall(function() prompt.MaxActivationDistance=9999; prompt.RequiresLineOfSight=false end)
            local sold = 0
            for _, m in ipairs(list) do
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if not hum then break end
                pcall(function() hum:EquipTool(m) end)
                task.wait(0.08)
                pcall(function() fireproximityprompt(prompt) end)
                task.wait(0.18)
                sold = sold + 1
            end
            pcall(function() prompt.MaxActivationDistance=10; prompt.RequiresLineOfSight=true end)
            Library:Notify({Title="Sold: "..sold.." marshmallow", Lifetime=3})
        end)
    end
})

-- Fully Auto Farm
local AutoFarmSec = FarmTab:AddSection({ Title = "Fully Auto Farm", Side = "Left" })
local AF = { active=false, paused=false, packQty=10 }
AutoFarmSec:AddSlider({Text="Pack per Siklus", Min=1, Max=100, Default=10, Suffix="x",
    Callback=function(v) AF.packQty = v end})
local MARSH_X, MARSH_Y, MARSH_Z = 510.38, 3.59, 603.50

local function afDoSell()
    local sellP = findNearestPrompt()
    if not sellP then task.wait(1.5); return end
    pcall(function() sellP.MaxActivationDistance=9999; sellP.RequiresLineOfSight=false end)
    local list = getMarshmallows()
    for idx, marsh in ipairs(list) do
        if not AF.active then break end
        while AF.paused and AF.active do task.wait(0.3) end
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if not hum then break end
        pcall(function() hum:EquipTool(marsh) end)
        task.wait(0.08)
        pcall(function() fireproximityprompt(sellP) end)
        task.wait(0.18)
    end
    pcall(function() if sellP and sellP.Parent then sellP.MaxActivationDistance=10; sellP.RequiresLineOfSight=true end end)
end

local function afDoBuyPack(qty)
    local remEvts = RS:FindFirstChild("RemoteEvents")
    local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
    if not spRE then task.wait(2); return end
    local packItems = {"Water","Sugar Block Bag","Gelatin"}
    for _, item in ipairs(packItems) do
        if not AF.active then break end
        for i = 1, qty do
            if not AF.active then break end
            while AF.paused and AF.active do task.wait(0.3) end
            pcall(function() spRE:FireServer(item, 1) end)
            task.wait(0.4)
        end
        task.wait(0.3)
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
            doSuicideTP({name="Buy Marshmallow", x=MARSH_X, y=MARSH_Y, z=MARSH_Z})
            isDoingKillTP = false
            needsKillTP = false
        end
        while AF.paused and AF.active do task.wait(0.3) end
        if not AF.active then break end
        if AF_died then needsKillTP = true; task.wait(1); continue end
        afDoBuyPack(AF.packQty)
        if not AF.active then break end
        if AF_died then needsKillTP = true; task.wait(1); continue end
        local apt = selectedApart
        if not apt then AF.active = false; break end
        tpToPos(apt.x, apt.y, apt.z, nil, apt.name)
        local wl = 0
        while tpActive and wl < 200 do task.wait(0.1); wl = wl + 1 end
        task.wait(0.5)
        if not AF.active then break end
        if AF_died then needsKillTP = true; task.wait(1); continue end
        snapToCookPos(); task.wait(0.5)
        local startMasak = totalMasak
        local target = startMasak + AF.packQty
        if selectedApart then
            local an = selectedApart.name:lower()
            if an:find("apt 5") or an:find("apt5") or an:find("west") or an:find("apt 6") or an:find("apt6") then
                setApart56FloorCollide(false)
            end
        end
        Flags.AutoCook = true
        lastCookProgressTime = tick()
        while AF.active and Running and totalMasak < target do
            if AF_died then break end
            if AF.paused then
                Flags.AutoCook = false
                while AF.paused and AF.active do task.wait(0.3) end
                if not AF.active then break end
                Flags.AutoCook = true
                lastCookProgressTime = tick()
                snapToCookPos()
            end
            task.wait(0.5)
        end
        Flags.AutoCook = false
        if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
        if not AF.active then break end
        if AF_died then needsKillTP = true; task.wait(1); continue end
        tpToPos(MARSH_X, MARSH_Y, MARSH_Z, nil, "Buy Marshmallow")
        wl = 0
        while tpActive and wl < 200 do task.wait(0.1); wl = wl + 1 end
        task.wait(0.5)
        if not AF.active then break end
        if AF_died then needsKillTP = true; task.wait(1); continue end
        afDoSell()
        task.wait(0.5)
        cycleCount = cycleCount + 1
    end
    if deathConn then deathConn:Disconnect() end
    AF.active = false; AF.paused = false
    Flags.AutoCook = false
    if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
end

AutoFarmSec:AddToggle({
    Text = "Fully Auto Farm", Flag = "AutoFarm", Default = false,
    Callback = function(v)
        if v then
            if not selectedApart then
                Library:Notify({Title="Pilih apartment dulu!",Lifetime=3})
                return
            end
            AF.active = true; AF.paused = false
            task.spawn(startAFLoop)
        else
            AF.active = false; AF.paused = false
            Flags.AutoCook = false
            if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
        end
    end
})
AutoFarmSec:AddButton({
    Text = "Pause / Resume",
    Callback = function()
        if not AF.active then return end
        AF.paused = not AF.paused
        Library:Notify({Title = AF.paused and "Paused" or "Resumed", Lifetime=2})
    end
})

-- Chips Auto Farm
local ChipSection = FarmTab:AddSection({ Title = "Chips Auto Farm", Side = "Right" })
local CHIPS_COORDS = {
    A={x=-478.83,y=3.86,z=-438.92,name="Station A"},
    B={x=-461.69,y=3.86,z=-461.25,name="Station B"},
    C={x=-461.69,y=3.86,z=-472.88,name="Station C"},
    D={x=-462.75,y=3.86,z=-521.94,name="Station D"},
}
local CHIPS_POTS = {
    {x=-515.28,y=3.86,z=-451.71,name="Pot 1"},
    {x=-515.24,y=3.86,z=-462.26,name="Pot 2"},
    {x=-515.28,y=3.86,z=-471.89,name="Pot 3"},
    {x=-515.28,y=3.86,z=-481.75,name="Pot 4"},
    {x=-515.24,y=3.86,z=-492.10,name="Pot 5"},
    {x=-496.99,y=3.86,z=-452.21,name="Pot 6"},
    {x=-496.95,y=3.86,z=-462.02,name="Pot 7"},
    {x=-496.98,y=3.86,z=-471.73,name="Pot 8"},
    {x=-496.99,y=3.86,z=-481.82,name="Pot 9"},
    {x=-497.04,y=3.86,z=-491.37,name="Pot 10"},
}
local CF2 = {active=false, paused=false, pot=1}
local potOptions = {}
for i = 1, 10 do table.insert(potOptions, "Pot "..i) end

ChipSection:AddDropdown({
    Text = "Select Pot", Flag = "ChipPot", Options = potOptions, Default = "Pot 1",
    Callback = function(v) CF2.pot = tonumber(v:match("%d+")) or 1 end
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
    while elapsed < travelT and CF2.active do
        local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp2 then break end
        local t = math.clamp(elapsed/travelT, 0, 1)
        cfMoveCharTo(fromPos:Lerp(toPos, t))
        local _, dt = RunService.Stepped:Wait()
        elapsed = elapsed + dt
    end
    if CF2.active then cfMoveCharTo(toPos) end
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
    pcall(function() p.MaxActivationDistance=9999; p.RequiresLineOfSight=false end)
    pcall(function() fireproximityprompt(p) end)
    pcall(function() if p and p.Parent then p.MaxActivationDistance=10; p.RequiresLineOfSight=true end end)
end
local function cfEquipTool(keyword)
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find(keyword:lower()) then
            pcall(function() hum:EquipTool(v) end); task.wait(0.2); return
        end
    end
end

local function startChipLoop()
    local cycle = 0
    while CF2.active and Running do
        while CF2.paused and CF2.active do task.wait(0.3) end
        if not CF2.active then break end
        local pot = CHIPS_POTS[CF2.pot]
        cfTPToCoord(CHIPS_COORDS.A)
        cfFirePromptAt(Vector3.new(CHIPS_COORDS.A.x, CHIPS_COORDS.A.y, CHIPS_COORDS.A.z))
        if not CF2.active then break end
        cfTPToCoord(CHIPS_COORDS.B)
        local bp = plr:FindFirstChild("Backpack")
        local char = plr.Character
        if bp and char then
            local targetTool = bp:FindFirstChild("Potato")
            local humanoid = char:FindFirstChild("Humanoid")
            if targetTool and targetTool.Name == "Potato" and humanoid then humanoid:EquipTool(targetTool) end
        end
        cfFirePromptAt(Vector3.new(CHIPS_COORDS.B.x, CHIPS_COORDS.B.y, CHIPS_COORDS.B.z))
        task.wait(2)
        if not CF2.active then break end
        cfTPToCoord(CHIPS_COORDS.C)
        cfFirePromptAt(Vector3.new(CHIPS_COORDS.C.x, CHIPS_COORDS.C.y, CHIPS_COORDS.C.z))
        task.wait(2)
        if not CF2.active then break end
        cfTPToCoord(CHIPS_COORDS.D)
        cfEquipTool("Flour")
        cfFirePromptAt(Vector3.new(CHIPS_COORDS.D.x, CHIPS_COORDS.D.y, CHIPS_COORDS.D.z))
        task.wait(2)
        if not CF2.active then break end
        cfTPToCoord(pot)
        cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
        task.wait(2)
        local waited = 0
        while CF2.active and waited < 60 do
            while CF2.paused and CF2.active do task.wait(0.3) end
            if not CF2.active then break end
            task.wait(1); waited += 1
        end
        if not CF2.active then break end
        cfTPToCoord(pot)
        cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
        task.wait(1)
        cycle += 1
    end
    CF2.active = false; CF2.paused = false
end

ChipSection:AddToggle({
    Text = "Chips Auto Farm", Flag = "ChipFarm", Default = false,
    Callback = function(v)
        if v then CF2.active = true; CF2.paused = false; task.spawn(startChipLoop)
        else CF2.active = false; CF2.paused = false end
    end
})

-- Auto Sell Chips (vehicle required)
local SChipSec = FarmTab:AddSection({ Title = "Auto Sell Chips (Vehicle)", Side = "Right" })
local SC = {active = false}
local SC_TUKAR = {x=-34.91, y=4.56, z=-24.15}
local SC_COOK  = {x=-487.11, y=3.86, z=-454.16}
local SC_HOMELESS = {
    {x=-315.35,y=3.72,z=-361.56},{x=-273.52,y=3.85,z=-211.32},{x=1102.42,y=3.36,z=527.05},
    {x=52.89,y=3.72,z=-425.36},{x=152.88,y=3.73,z=-210.08},{x=-522.75,y=-7.86,z=-165.08},
    {x=65.12,y=3.73,z=68.10},{x=26.04,y=3.73,z=217.89},{x=520.08,y=3.87,z=-295.52},
    {x=699.28,y=3.72,z=-427.05},{x=900.03,y=3.94,z=-283.12},{x=874.89,y=3.73,z=-63.02},
}
local function scCountChips(name)
    local n = 0
    pcall(function()
        for _, t in ipairs(plr.Backpack:GetChildren()) do if t.Name == name then n += 1 end end
        local ch = plr.Character
        if ch then for _, t in ipairs(ch:GetChildren()) do if t:IsA("Tool") and t.Name == name then n += 1 end end end
    end)
    return n
end
local function scFindPromptByAction(targetPos, actionKw, radius)
    radius = radius or 60
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
                local m = actionKw == nil or obj.ActionText:lower():find(actionKw:lower()) ~= nil
                if d < bestDist and m then bestDist = d; best = obj end
            end
        end
    end
    return best
end
local function scFirePrompt(targetPos, actionKw)
    local p = scFindPromptByAction(targetPos, actionKw) or scFindPromptByAction(targetPos, nil, 40)
    if not p then return false end
    local od, ol = p.MaxActivationDistance, p.RequiresLineOfSight
    pcall(function() p.MaxActivationDistance=9999; p.RequiresLineOfSight=false end)
    task.wait(0.05)
    pcall(function() fireproximityprompt(p) end)
    task.wait(0.15)
    pcall(function() if p and p.Parent then p.MaxActivationDistance=od; p.RequiresLineOfSight=ol end end)
    return true
end
local function scEquipTool(name)
    local ch = plr.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local bp = plr.Backpack
    if bp then
        local t = bp:FindFirstChild(name)
        if t then pcall(function() hum:EquipTool(t) end); task.wait(0.25); return true end
    end
    if ch then
        local t = ch:FindFirstChild(name)
        if t and t:IsA("Tool") then return true end
    end
    return false
end

local function startSellChipsLoop()
    while SC.active and Running do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then Library:Notify({Title="Harus naik vehicle dulu!",Lifetime=3}); SC.active=false; return end
        local hotCount = scCountChips("Hot Chips")
        local potatoCount = scCountChips("Potato Chips")
        if hotCount == 0 and potatoCount == 0 then
            Library:Notify({Title="Tidak ada chips!",Lifetime=3}); SC.active=false; return
        end
        local visitCount
        if hotCount > 0 then
            visitCount = math.min(hotCount, 12)
        else
            visitCount = math.min(potatoCount, 12)
            local okTP = doVehicleTP(CFrame.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z))
            if not okTP then SC.active=false; return end
            task.wait(0.3)
            if not SC.active then break end
            scFirePrompt(Vector3.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z), nil)
            task.wait(0.4)
            if not SC.active then break end
        end
        scEquipTool("Hot Chips")
        if not SC.active then break end
        for i = 1, visitCount do
            if not SC.active then break end
            local h = SC_HOMELESS[i]
            doVehicleTP(CFrame.new(h.x, h.y, h.z))
            task.wait(0.25)
            if not SC.active then break end
            scEquipTool("Hot Chips")
            scFirePrompt(Vector3.new(h.x, h.y, h.z), nil)
            task.wait(0.2)
        end
        if not SC.active then break end
        local remaining = scCountChips("Hot Chips")
        if remaining > 0 then doVehicleTP(CFrame.new(SC_COOK.x, SC_COOK.y, SC_COOK.z)) end
        SC.active = false
    end
    SC.active = false
end

SChipSec:AddToggle({
    Text = "Auto Sell Chips (needs vehicle)", Flag = "SellChips", Default = false,
    Callback = function(v)
        if v then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            if not seat then Library:Notify({Title="Naik vehicle dulu!",Lifetime=3}); return end
            SC.active = true; task.spawn(startSellChipsLoop)
        else SC.active = false end
    end
})

-- Auto Farm Box
local BoxSec = FarmTab:AddSection({ Title = "Auto Farm Box", Side = "Left" })
local BOX_POS_A = CFrame.new(-551.47, 3.54, -84.97)
local BOX_POS_B = CFrame.new(-401.96, 3.36, -70.98)
local BOX_TWEEN_SPEED = 20
local boxActive = false
local function boxTweenTo(targetCF)
    local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp2 then return end
    local dist = (hrp2.Position - targetCF.Position).Magnitude
    local tw = TweenService:Create(hrp2, TweenInfo.new(math.max(dist/BOX_TWEEN_SPEED, 0.05), Enum.EasingStyle.Linear), {CFrame=targetCF})
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
        local od, ol = prompt.MaxActivationDistance, prompt.RequiresLineOfSight
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
            local nc = plr.CharacterAdded:Wait()
            nc:WaitForChild("HumanoidRootPart", 10)
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
BoxSec:AddToggle({
    Text = "Auto Farm Box", Flag = "AutoBox", Default = false,
    Callback = function(v)
        boxActive = v
        if v then task.spawn(boxLoop) end
    end
})

-- ================================================================
-- ░░ TP TAB ░░
-- ================================================================
local TPCats = {
    {name="ATM", locs={
        {n="ATM 1",x=-651.92,y=3.73,z=156.71},{n="ATM 2",x=-378.48,y=3.72,z=-360},{n="ATM 3",x=-265.71,y=3.85,z=-212.04},
        {n="ATM 4",x=-536.51,y=3.73,z=-20.06},{n="ATM 5",x=-33.15,y=3.72,z=-300.05},{n="ATM 6",x=525.03,y=-7.77,z=-96.41},
        {n="ATM 7",x=-10.79,y=3.73,z=234.15},{n="ATM 8",x=-455.03,y=3.73,z=370.77},{n="ATM 9",x=236.67,y=3.72,z=-163.25},
        {n="ATM 10",x=538.89,y=3.73,z=-349.09},{n="ATM 11",x=360.74,y=3.72,z=-359.25},{n="ATM 12",x=701.47,y=3.73,z=-241.29},
        {n="ATM 13",x=875.01,y=3.36,z=-346.32},{n="ATM 14",x=894.71,y=3.73,z=145.68},{n="ATM 15",x=716.74,y=3.81,z=413.77},
        {n="ATM 16",x=497.89,y=3.78,z=405.70},{n="ATM 17",x=1016.72,y=3.36,z=-229.20},{n="ATM 18",x=1054.08,y=3.72,z=589.36},
        {n="ATM 19",x=1097.58,y=3.36,z=178.35},
    }},
    {name="Homeless", locs={
        {n="Homeless 1",x=-315.35,y=3.72,z=-361.56},{n="Homeless 2",x=-273.52,y=3.85,z=-211.32},
        {n="Homeless 3",x=1102.42,y=3.36,z=527.05},{n="Homeless 4",x=52.89,y=3.72,z=-425.36},
        {n="Homeless 5",x=152.88,y=3.73,z=-210.08},{n="Homeless 6",x=-522.75,y=-7.86,z=-165.08},
        {n="Homeless 7",x=65.12,y=3.73,z=68.10},{n="Homeless 8",x=26.04,y=3.73,z=217.89},
        {n="Homeless 9",x=520.08,y=3.87,z=-295.52},{n="Homeless 10",x=699.28,y=3.72,z=-427.05},
        {n="Homeless 11",x=900.03,y=3.94,z=-283.12},{n="Homeless 12",x=874.89,y=3.73,z=-63.02},
    }},
    {name="Apartment", locs={
        {n="Apt 1 Main",x=1142.93,y=10.10,z=453.42},{n="Apt 2 Main",x=1142.9,y=10.10,z=424.9},
        {n="Apt 3 Mid",x=984.06,y=10.10,z=245.47},{n="Apt 4 Mid",x=984.02,y=10.10,z=216.83},
        {n="Apt 5 West",x=928.82,y=10.10,z=38.43},{n="Apt 6 West",x=900.62,y=10.10,z=38.39},
        {n="Apt 7 Casino",x=1180.46,y=3.71,z=-193.92},{n="Apt 8 Casino",x=1202.21,y=3.71,z=-189.78},
        {n="Apt 9 Casino",x=1180.47,y=3.71,z=-222.41},{n="Apt 10 Casino",x=1202.08,y=3.71,z=-222.91},
    }},
    {name="Others", locs={
        {n="Bag Store",x=992.77,y=3.78,z=422.53},{n="Bank",x=-48.64,y=3.73,z=-320.46},
        {n="Binary Store",x=-281.06,y=3.74,z=251.23},{n="Boutique Store",x=992.60,y=3.78,z=453.07},
        {n="Box Job",x=-578.48,y=3.53,z=-74.82},{n="Buy Marshmellow",x=510.38,y=3.59,z=603.50},
        {n="Cap Store",x=-270.15,y=3.88,z=-331.36},{n="Casino",x=1152.53,y=20.32,z=-26.31},
        {n="Chips Cook",x=-487.11,y=3.86,z=-454.16},{n="Chips Store",x=-773.72,y=3.66,z=-187.54},
        {n="Chips Tukar",x=-34.91,y=4.56,z=-24.15},{n="Clothes Store 1",x=-202.62,y=3.48,z=-58.82},
        {n="Clothes Store 2",x=-747.62,y=3.76,z=571.96},{n="Dealer",x=730.24,y=3.7,z=449.47},
        {n="Deli Grocery",x=-364.30,y=3.61,z=-325.87},{n="Fake Card",x=216.28,y=3.73,z=-331.79},
        {n="Food Corp",x=365.69,y=3.48,z=-349.23},{n="Glasses Store",x=-697.77,y=4.21,z=-336.85},
        {n="Gun Sell",x=75.09,y=3.76,z=26.53},{n="Gun Store 1",x=215.77,y=3.73,z=-179.89},
        {n="Gun Store 2",x=-468.37,y=3.86,z=349.56},{n="Gun Tier",x=1114.80,y=3.78,z=167.36},
        {n="Haircut",x=52.73,y=3.73,z=-71.39},{n="Jewerely Store",x=-75.48,y=4.29,z=-176.28},
        {n="Shoes Store",x=524.48,y=3.75,z=-196.93},{n="Store 1",x=904.05,y=3.53,z=-87.44},
        {n="Store 2",x=530.13,y=3.46,z=430.07},{n="Tattoo Shop",x=951.72,y=3.83,z=-72.93},
        {n="The Deli 2",x=-662.23,y=3.98,z=159.33},
    }},
}

for _, cat in ipairs(TPCats) do
    local sec = TPTab:AddSection({ Title = cat.name, Side = "Left" })
    local opts = {}
    for _, l in ipairs(cat.locs) do table.insert(opts, l.n) end
    sec:AddDropdown({
        Text = "Select Location", Flag = "TP_"..cat.name,
        Options = opts, Default = "",
        Callback = function(v) end
    })
    sec:AddButton({
        Text = "GO (Normal TP)",
        Callback = function()
            local target = sec.SelectedValue or ""
            for _, l in ipairs(cat.locs) do
                if l.n == target then
                    task.spawn(function() tpToPos(l.x, l.y, l.z, nil, l.n) end)
                    return
                end
            end
            Library:Notify({Title="Pilih lokasi dulu", Lifetime=2})
        end
    })
    sec:AddButton({
        Text = "VEH TP",
        Callback = function()
            local target = sec.SelectedValue or ""
            for _, l in ipairs(cat.locs) do
                if l.n == target then
                    local ok = doVehicleTP(CFrame.new(l.x, l.y, l.z))
                    Library:Notify({Title = ok and "Vehicle TP → "..l.n or "Tidak di kendaraan!", Lifetime=2})
                    return
                end
            end
        end
    })
    sec:AddButton({
        Text = "KILL TP (Respawn)",
        Callback = function()
            local target = sec.SelectedValue or ""
            for _, l in ipairs(cat.locs) do
                if l.n == target then
                    task.spawn(function() doSuicideTP({name=l.n, x=l.x, y=l.y, z=l.z}) end)
                    return
                end
            end
        end
    })
end

-- TP to Player
local TPPlrSec = TPTab:AddSection({ Title = "TP to Player", Side = "Right" })
local plrOptions = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= plr then table.insert(plrOptions, p.Name) end end
TPPlrSec:AddDropdown({
    Text = "Select Player", Flag = "TPPlr",
    Options = plrOptions, Default = "",
    Callback = function(v) end
})
TPPlrSec:AddButton({
    Text = "GO to Player",
    Callback = function()
        local target = TPPlrSec.SelectedValue or ""
        local tp = Players:FindFirstChild(target)
        if not tp then return end
        local ch = tp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        task.spawn(function() tpToPos(hrp.Position.X, hrp.Position.Y, hrp.Position.Z, nil, tp.Name) end)
    end
})
TPPlrSec:AddButton({
    Text = "VEH to Player",
    Callback = function()
        local target = TPPlrSec.SelectedValue or ""
        local tp = Players:FindFirstChild(target)
        if not tp then return end
        local ch = tp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        doVehicleTP(CFrame.new(hrp.Position))
    end
})
TPPlrSec:AddButton({
    Text = "KILL TP to Player",
    Callback = function()
        local target = TPPlrSec.SelectedValue or ""
        local tp = Players:FindFirstChild(target)
        if not tp then return end
        local ch = tp.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local x, y, z = hrp.Position.X, hrp.Position.Y, hrp.Position.Z
        task.spawn(function() doSuicideTP({name=tp.Name, x=x, y=y, z=z}) end)
    end
})

-- ================================================================
-- ░░ INFO TAB ░░
-- ================================================================
local InfoSec = InfoTab:AddSection({ Title = "Contact", Side = "Left" })
InfoSec:AddButton({
    Text = "Copy TikTok: @darkhub",
    Callback = function() pcall(function() setclipboard("@darkhub") end); Library:Notify({Title="TikTok copied!",Lifetime=2}) end
})
InfoSec:AddButton({
    Text = "Copy Discord link",
    Callback = function() pcall(function() setclipboard("https://discord.gg/pDEyArQ5B") end); Library:Notify({Title="Discord copied!",Lifetime=2}) end
})

local WarnSec = InfoTab:AddSection({ Title = "Warning", Side = "Right" })
WarnSec:AddLabel({ Text = "USE AT YOUR OWN RISK" })
WarnSec:AddLabel({ Text = "We are not responsible for any bans." })
WarnSec:AddLabel({ Text = "DILARANG KERAS SHARING!!!" })
WarnSec:AddLabel({ Text = "DILARANG MENJUAL KEMBALI SCRIPT INI!!!" })

-- Instant Interact (ProximityPromptService hook — preserved)
local _ic
_ic = ProximityPS.PromptShown:Connect(function(prompt)
    if not Running then if _ic then _ic:Disconnect() end; return end
    if Flags.InstantInteract then pcall(function() if prompt.HoldDuration > 0 then prompt.HoldDuration = 0.05 end end) end
end)

-- Inv Scan (BillboardGui — preserved)
local Inv_Tags = {}
local function createInvTag(p)
    if Inv_Tags[p] or p == plr then return end
    local it = Instance.new("BillboardGui")
    it.Size = UDim2.new(0,250,0,150)
    it.StudsOffset = Vector3.new(0,4,0)
    it.AlwaysOnTop = true
    it.Enabled = false
    it.Parent = game:GetService("CoreGui")
    local lbl = Instance.new("TextLabel", it)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
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
local function removeInvTag(p) if Inv_Tags[p] then Inv_Tags[p]:Destroy(); Inv_Tags[p]=nil end end
for _, p in pairs(Players:GetPlayers()) do createInvTag(p) end
Players.PlayerAdded:Connect(function(p) task.wait(1); createInvTag(p) end)
Players.PlayerRemoving:Connect(removeInvTag)

task.spawn(function()
    while Running do
        task.wait(2)
        for _, p in pairs(Players:GetPlayers()) do
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
            else it.Enabled = false end
        end
    end
end)

-- ================================================================
-- ░░ CFG TAB ░░
-- ================================================================
local CFGDIR = "darkhub_configs"
pcall(function() if not isfolder(CFGDIR) then makefolder(CFGDIR) end end)

local CfgSection = CfgTab:AddSection({ Title = "Config Save/Load", Side = "Left" })
local cfgName = ""
CfgSection:AddTextbox({
    Text = "Config Name", Placeholder = "Nama config...",
    Callback = function(v) cfgName = v end
})
CfgSection:AddButton({
    Text = "SAVE Current Settings",
    Callback = function()
        if cfgName == "" then Library:Notify({Title="Isi nama dulu!",Lifetime=2}); return end
        pcall(function()
            if not isfolder(CFGDIR) then makefolder(CFGDIR) end
            writefile(CFGDIR.."/"..cfgName..".json", Http:JSONEncode({Flags=Flags,AimFOV_Radius=AimFOV_Radius,AimMax_Dist=AimMax_Dist}))
            Library:Notify({Title="Saved: "..cfgName, Lifetime=2})
        end)
    end
})
local cfgList = {}
pcall(function()
    if isfolder(CFGDIR) then
        for _, f in ipairs(listfiles(CFGDIR)) do
            local n = f:match("([^/\\]+)$") or f
            n = n:gsub("%.json$","")
            if n ~= "" then table.insert(cfgList, n) end
        end
    end
end)
CfgSection:AddDropdown({
    Text = "Saved Configs", Flag = "CfgList",
    Options = cfgList, Default = "",
    Callback = function(v) end
})
CfgSection:AddButton({
    Text = "LOAD Selected",
    Callback = function()
        local t = CfgSection.SelectedValue or ""
        if t == "" then Library:Notify({Title="Pilih config",Lifetime=2}); return end
        pcall(function()
            local d = Http:JSONDecode(readfile(CFGDIR.."/"..t..".json"))
            if d.Flags then for k, v in pairs(d.Flags) do if Flags[k] ~= nil then Flags[k] = v end end end
            if d.AimFOV_Radius then AimFOV_Radius = d.AimFOV_Radius end
            if d.AimMax_Dist then AimMax_Dist = d.AimMax_Dist end
            Library:Notify({Title="Loaded: "..t, Lifetime=2})
        end)
    end
})
CfgSection:AddButton({
    Text = "DELETE Selected",
    Callback = function()
        local t = CfgSection.SelectedValue or ""
        if t == "" then return end
        pcall(function() delfile(CFGDIR.."/"..t..".json"); Library:Notify({Title="Deleted: "..t, Lifetime=2}) end)
    end
})

-- ================================================================
-- ░░ VEH TAB ░░
-- ================================================================
local VehSection = VehTab:AddSection({ Title = "Vehicle Fly", Side = "Left" })
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
    if hum then vCam.CameraSubject = hum; vCam.CameraType = Enum.CameraType.Custom end
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

VehSection:AddToggle({
    Text = "Vehicle Fly (WASD + E/Q)", Flag = "VehicleFly", Default = false,
    Callback = function(v)
        vFlyActive = v
        if v then vStartFly() else vStopFly() end
    end
})
VehSection:AddSlider({
    Text = "Fly Speed", Min = 10, Max = 500, Default = 50, Suffix = "",
    Callback = function(v) vFlySpeed = v end
})

local VehInfoSec = VehTab:AddSection({ Title = "Vehicle TP Info", Side = "Right" })
VehInfoSec:AddLabel({Text = "Tombol VEH ada di tab TP."})
VehInfoSec:AddLabel({Text = "Klik VEH saat duduk di kendaraan"})
VehInfoSec:AddLabel({Text = "untuk teleport kendaraan ke tujuan."})

-- ================================================================
-- RENDER LOOP (ESP + Aimbot + Silent FOV)
-- ================================================================
local SKEL_BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"RightUpperLeg","LeftUpperLeg"},
}
local wpRayParams = RaycastParams.new()
wpRayParams.FilterType = Enum.RaycastFilterType.Blacklist

local espCache = {}
local espConns = {}
local function isKW(n)
    n = n:lower()
    for _, kw in ipairs({"water","sugar","gelatin","marshmallow"}) do
        if n:find(kw) then return true end
    end
    return false
end
local function rebuildCache(p)
    if not p or not p.Parent then return end
    local hb, wn = false, nil
    pcall(function()
        if p.Backpack then
            for _, v in ipairs(p.Backpack:GetChildren()) do
                if v:IsA("Tool") and isKW(v.Name) then hb = true end
            end
        end
        if p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("Tool") then
                    if isKW(v.Name) then hb = true else wn = v.Name end
                end
            end
        end
    end)
    espCache[p] = {hasBahan = hb, wName = wn}
end
local function connectESPPlayer(p)
    if p == plr or espConns[p] then return end
    local conns = {}
    espConns[p] = conns
    rebuildCache(p)
    if p.Backpack then
        table.insert(conns, p.Backpack.ChildAdded:Connect(function() rebuildCache(p) end))
        table.insert(conns, p.Backpack.ChildRemoved:Connect(function() rebuildCache(p) end))
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
for _, p in ipairs(Players:GetPlayers()) do createESP(p); connectESPPlayer(p) end
Players.PlayerAdded:Connect(function(p) createESP(p); connectESPPlayer(p) end)
Players.PlayerRemoving:Connect(function(p) removeESP(p); 
    if espConns[p] then for _, c in ipairs(espConns[p]) do pcall(function() c:Disconnect() end) end; espConns[p]=nil end
    espCache[p]=nil
end)

-- Aimbot RMB
local RMB = false
UIS.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=true end end)
UIS.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=false; AimTarget=nil end end)

-- Blink TP [T]
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode == Enum.KeyCode.T then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame * CFrame.new(0,0,-6)}):Play()
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not Running then return end
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
    local localChar = plr.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    local fovCenter = AimMode == "HP" and Vector2.new(vp.X/2, vp.Y/2) or mousePos
    FovCircle.Radius = AimFOV_Radius
    FovCircle.Visible = Flags.AimLock and ShowAimFOV

    if SilentAim then
        local saOrigin = SilentMode == "HP" and Vector2.new(vp.X/2, vp.Y/2) or mousePos
        local bestScreenPos, bestWorldD = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p == plr then continue end
            local ch = p.Character
            if not ch then continue end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local part = ch:FindFirstChild(AimPart=="Head" and "Head" or "HumanoidRootPart")
            if not part or not hum or hum.Health <= 0 then continue end
            local sp, on = cam:WorldToViewportPoint(part.Position)
            if not on or sp.Z <= 0 then continue end
            local screenPos = Vector2.new(sp.X, sp.Y)
            if (saOrigin - screenPos).Magnitude > SilentFOV_Radius then continue end
            local wd = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
            if wd < bestWorldD then bestWorldD = wd; bestScreenPos = screenPos end
        end
        if bestScreenPos then
            SilentFovCircle.Position = SilentMode=="HP" and bestScreenPos or saOrigin
            SilentFovCircle.Radius = SilentFOV_Radius
            SilentFovCircle.Visible = ShowSilentFOV
            SilentLine.From = saOrigin
            SilentLine.To = bestScreenPos
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

    if AimTarget then
        local tHum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not tHum or tHum.Health <= 0 then AimTarget = nil end
    end
    if AimTarget and AimMode == "PC" then
        local sp, on = cam:WorldToScreenPoint(AimTarget.Position)
        if not on then AimTarget = nil
        else
            local d = math.sqrt((sp.X-fovCenter.X)^2 + (sp.Y-fovCenter.Y)^2)
            if d > AimFOV_Radius then AimTarget = nil end
        end
    end

    local shouldAim = Flags.AimLock and localRoot and (AimMode=="HP" or RMB)
    if shouldAim then
        if AimMode == "HP" or not AimTarget then
            local bestD, bestPart = math.huge, nil
            for _, p in pairs(Players:GetPlayers()) do
                if p == plr or AimWhitelist[p.Name] then continue end
                local ch = p.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local tPart = ch and ch:FindFirstChild(AimPart=="Head" and "Head" or "HumanoidRootPart")
                if not tPart or not hum or hum.Health <= 0 then continue end
                if (tPart.Position - localRoot.Position).Magnitude > AimMax_Dist then continue end
                local sp, on = cam:WorldToScreenPoint(tPart.Position)
                if not on then continue end
                if Flags.WallCheck then
                    local camPos = cam.CFrame.Position
                    local dir = tPart.Position - camPos
                    wpRayParams.FilterDescendantsInstances = {cam, plr.Character}
                    local hit = workspace:Raycast(camPos, dir.Unit*dir.Magnitude, wpRayParams)
                    if hit and not hit.Instance:IsDescendantOf(ch) then continue end
                end
                local d = math.sqrt((sp.X-fovCenter.X)^2 + (sp.Y-fovCenter.Y)^2)
                if d <= AimFOV_Radius and d < bestD then bestD = d; bestPart = tPart end
            end
            AimTarget = bestPart
        end
        if AimTarget then
            local tCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
            cam.CFrame = cam.CFrame:Lerp(tCF, AimSmooth)
            FovCircle.Color = Color3.fromRGB(255,80,80)
        else FovCircle.Color = Color3.fromRGB(0,170,255) end
    else
        if AimMode == "PC" and not RMB then AimTarget = nil end
        FovCircle.Color = Color3.fromRGB(0,170,255)
    end

    if AimMode == "HP" and AimTarget then
        local sp2, v2 = cam:WorldToViewportPoint(AimTarget.Position)
        FovCircle.Position = (v2 and sp2.Z > 0) and Vector2.new(sp2.X, sp2.Y) or fovCenter
    else FovCircle.Position = fovCenter end

    local anyESP = Flags.BoxESP or Flags.Tracer or Flags.ESPName or Flags.ESPDist or Flags.ESPHPBar or Flags.ESPWeapon or Flags.ESPSkeleton or Flags.ESPMasak
    for p, e in pairs(ESP) do
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not anyESP or not ch or not hum or not root then _hideESP(e); continue end
        local pos3, on = cam:WorldToViewportPoint(root.Position)
        if not on or pos3.Z <= 0 then _hideESP(e); continue end
        local isDead = hum.Health <= 0
        if localRoot and (root.Position - localRoot.Position).Magnitude > ESPMaxDist then _hideESP(e); continue end

        if Flags.ESPSkeleton then
            local W2 = isDead and Color3.fromRGB(255,80,100) or Color3.fromRGB(0,170,255)
            for si, bone in ipairs(SKEL_BONES) do
                local p1 = ch:FindFirstChild(bone[1])
                local p2 = ch:FindFirstChild(bone[2])
                local sk = e.skeleton[si]
                if p1 and p2 then
                    local s1, v1 = cam:WorldToViewportPoint(p1.Position)
                    local s2, v2 = cam:WorldToViewportPoint(p2.Position)
                    if v1 and v2 and s1.Z>0 and s2.Z>0 then
                        sk.From=Vector2.new(s1.X,s1.Y); sk.To=Vector2.new(s2.X,s2.Y); sk.Color=W2; sk.Visible=true
                    else sk.Visible=false end
                else sk.Visible=false end
            end
        else
            for _, s in ipairs(e.skeleton) do s.Visible = false end
        end

        local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0,3.2,0))
        local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0,3.5,0))
        local sY = math.abs(botPos.Y - topPos.Y)
        local sX = sY * 0.6
        local bx = pos3.X - sX/2
        local by = math.min(topPos.Y, botPos.Y)

        local cache = espCache[p] or {hasBahan=false, wName=nil}
        local W = isDead and Color3.fromRGB(255,80,100) or Color3.fromRGB(0,170,255)
        if Flags.BoxESP then
            e.box.Color=W; e.box.Size=Vector2.new(sX,sY); e.box.Position=Vector2.new(bx,by)
            e.box.Visible=(BoxESPMode=="FULL")
            local showC = BoxESPMode=="CORNER"
            local cL = math.min(sX,sY)*0.25
            local cx = e.corners
            cx[1].From=Vector2.new(bx,by); cx[1].To=Vector2.new(bx+cL,by)
            cx[2].From=Vector2.new(bx,by); cx[2].To=Vector2.new(bx,by+cL)
            cx[3].From=Vector2.new(bx+sX,by); cx[3].To=Vector2.new(bx+sX-cL,by)
            cx[4].From=Vector2.new(bx+sX,by); cx[4].To=Vector2.new(bx+sX,by+cL)
            cx[5].From=Vector2.new(bx,by+sY); cx[5].To=Vector2.new(bx+cL,by+sY)
            cx[6].From=Vector2.new(bx,by+sY); cx[6].To=Vector2.new(bx,by+sY-cL)
            cx[7].From=Vector2.new(bx+sX,by+sY); cx[7].To=Vector2.new(bx+sX-cL,by+sY)
            cx[8].From=Vector2.new(bx+sX,by+sY); cx[8].To=Vector2.new(bx+sX,by+sY-cL)
            for i = 1, 8 do cx[i].Color=W; cx[i].Visible=showC end
        else
            e.box.Visible=false
            for i = 1, 8 do e.corners[i].Visible = false end
        end

        local hp = math.clamp(hum.Health/math.max(hum.MaxHealth,1), 0, 1)
        local barH = math.max(1, sY*hp)
        local barX = bx-7
        local hpCol = hp>0.5 and Color3.fromRGB(0,220,0) or hp>0.2 and Color3.fromRGB(255,165,0) or Color3.fromRGB(255,0,0)
        if Flags.ESPHPBar then
            e.hpbg.Size=Vector2.new(4,sY); e.hpbg.Position=Vector2.new(barX,by)
            e.hpbg.Color=Color3.fromRGB(0,0,0); e.hpbg.Filled=false; e.hpbg.Thickness=1; e.hpbg.Visible=true
            e.hpbar.Color=hpCol; e.hpbar.Size=Vector2.new(4,barH)
            e.hpbar.Position=Vector2.new(barX,by+(sY-barH)); e.hpbar.Filled=true; e.hpbar.Visible=true
            e.hpnum.Text=math.floor(hum.Health).."HP"; e.hpnum.Size=11
            e.hpnum.Position=Vector2.new(barX+2,by-1); e.hpnum.Center=false; e.hpnum.Color=hpCol; e.hpnum.Visible=true
        else
            e.hpbg.Visible=false; e.hpbar.Visible=false; e.hpnum.Visible=false
        end

        local distNow = localRoot and (root.Position-localRoot.Position).Magnitude or 100
        local tSize = math.clamp(math.floor(14 - distNow/40), 8, 14)
        if Flags.ESPName then
            e.dispname.Text = (p.DisplayName or p.Name).."(@"..p.Name..")"
            e.dispname.Size=tSize; e.dispname.Color=W
            e.dispname.Position=Vector2.new(pos3.X, by-14)
            e.dispname.Visible=true
            e.username.Visible=false
        else e.dispname.Visible=false; e.username.Visible=false end

        local dist = localRoot and math.floor((root.Position-localRoot.Position).Magnitude) or 0
        local nY = by+sY+3
        if Flags.ESPDist then
            e.dist.Text=dist.."m"; e.dist.Size=tSize; e.dist.Color=W
            e.dist.Position=Vector2.new(pos3.X, nY); e.dist.Visible=true
            nY = nY+13
        else e.dist.Visible=false end
        if Flags.ESPWeapon and cache.wName then
            e.weapon.Text=cache.wName; e.weapon.Color=Color3.fromRGB(0,170,255)
            e.weapon.Position=Vector2.new(pos3.X, nY); e.weapon.Visible=true
        else e.weapon.Visible=false end
        if Flags.ESPMasak and cache.hasBahan then
            e.masak.Text="MASAK"; e.masak.Position=Vector2.new(bx+sX+4, by+sY/2-6)
            e.masak.Center=false; e.masak.Visible=true
        else e.masak.Visible=false end
        local tracerDist = localRoot and (root.Position-localRoot.Position).Magnitude or 999
        if Flags.Tracer and tracerDist < TracerMaxDist then
            e.tracer.From=Vector2.new(vp.X/2, vp.Y); e.tracer.To=Vector2.new(pos3.X, by+sY)
            e.tracer.Color=W; e.tracer.Visible=true
        else e.tracer.Visible=false end
    end
end)

-- ================================================================
-- STARTUP
-- ================================================================
do
    local VirtualUser = game:GetService("VirtualUser")
    plr.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

Library:Notify({Title = "DARK HUB V3.0 Loaded", Lifetime = 3})