-- ================================================================
-- DARK HUB V3.0 — OBSIDIAN UI EDITION
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
    Footer = "version: V3.0",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    Visual = Window:AddTab("Visual", "eye"),
    Aim = Window:AddTab("Aim", "crosshair"),
    Farm = Window:AddTab("Farm", "wheat"),
    TP = Window:AddTab("TP", "map-pin"),
    Vehicle = Window:AddTab("Vehicle", "car"),
    Info = Window:AddTab("Info", "info"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- Groupboxes
local MainGroup   = Tabs.Main:AddLeftGroupbox("Main")
local MainGroupR  = Tabs.Main:AddRightGroupbox("Misc")
local VisualGroup = Tabs.Visual:AddLeftGroupbox("ESP")
local VisualGroupR= Tabs.Visual:AddRightGroupbox("Extra ESP")
local AimGroup    = Tabs.Aim:AddLeftGroupbox("Aimbot")
local AimGroupR   = Tabs.Aim:AddRightGroupbox("Silent Aim")
local FarmGroup   = Tabs.Farm:AddLeftGroupbox("Auto Farm")
local FarmGroupR  = Tabs.Farm:AddRightGroupbox("Auto Buy")
local TPGroup     = Tabs.TP:AddLeftGroupbox("Teleport")
local VehicleGroup= Tabs.Vehicle:AddLeftGroupbox("Vehicle")
local InfoGroup   = Tabs.Info:AddLeftGroupbox("Contact")
local InfoGroupR  = Tabs.Info:AddRightGroupbox("Warning")

-- ══════════════════════════════════════════════════════════════
-- FLAGS
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

local AimFOV_Radius = 120
local SilentFOV_Radius = 120
local AimMax_Dist = 300
local TracerMaxDist = 300
local ESPMaxDist = 500
local AimSmooth = 0.85
local AimTarget = nil
local AimPart = "Head"
local AimMode = "PC"
local BoxESPMode = "FULL"
local AimWhitelist = {}
local BlinkMode = "PC"
local SilentAim = false
local SilentAimWallbang = false
local ShowAimFOV = true
local ShowSilentFOV = true
local SilentMode = "PC"

-- ══════════════════════════════════════════════════════════════
-- CORE SERVICES
-- ══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Http = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
-- THANK YOU POPUP — OBSIDIAN STYLE
-- ══════════════════════════════════════════════════════════════
task.spawn(function()
    Library:Notify({
        Title = "DARK HUB V3.0",
        Description = "TikTok: @drakhub\nDiscord: discord.gg/AbHhEACZC",
        Time = 5,
    })
end)

-- ══════════════════════════════════════════════════════════════
-- TELEPORT LOADING OVERLAY — "WAIT" ANIMATION
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
ovCenter.Size = UDim2.new(0, 320, 0, 130)
ovCenter.AnchorPoint = Vector2.new(0.5, 0.5)
ovCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
ovCenter.BackgroundTransparency = 1
ovCenter.ZIndex = 10000

-- Logo: "WAIT" dengan animasi loading dots
local logoFrame = Instance.new("Frame", ovCenter)
logoFrame.Size = UDim2.new(1, 0, 0, 72)
logoFrame.AnchorPoint = Vector2.new(0.5, 0)
logoFrame.Position = UDim2.new(0.5, 0, 0, 0)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex = 10001

local ovTitle = Instance.new("TextLabel", logoFrame)
ovTitle.Size = UDim2.new(1, 0, 1, 0)
ovTitle.BackgroundTransparency = 1
ovTitle.Text = "WAIT"
ovTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ovTitle.Font = Enum.Font.GothamBlack
ovTitle.TextSize = 64
ovTitle.ZIndex = 10001
local ovTitleStroke = Instance.new("UIStroke", ovTitle)
ovTitleStroke.Color = Color3.fromRGB(0, 210, 65)
ovTitleStroke.Thickness = 2.5

local ovLabel = Instance.new("TextLabel", ovCenter)
ovLabel.Size = UDim2.new(1, 0, 0, 20)
ovLabel.Position = UDim2.new(0, 0, 0, 80)
ovLabel.BackgroundTransparency = 1
ovLabel.Text = "Teleporting, please wait"
ovLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
ovLabel.Font = Enum.Font.Gotham
ovLabel.TextSize = 13
ovLabel.TextXAlignment = Enum.TextXAlignment.Center
ovLabel.ZIndex = 10001

-- Animasi dots
local dotConn = nil
task.spawn(function()
    while true do
        if TPOverlay.Enabled then
            for i = 1, 3 do
                ovTitle.Text = "WAIT" .. string.rep(".", i)
                task.wait(0.3)
            end
        else
            task.wait(0.3)
        end
    end
end)

local _panelWasVisible = false
local _overlayActive = false

local function showTPOverlay(destName)
    _panelWasVisible = true
    _overlayActive = true
    OvBG.BackgroundTransparency = 0
    TPOverlay.Enabled = true
    ovLabel.Text = "Teleporting to " .. (destName or "destination") .. "..."
end

local function hideTPOverlay()
    TPOverlay.Enabled = false
    OvBG.BackgroundTransparency = 1
    _overlayActive = false
end

-- ══════════════════════════════════════════════════════════════
-- ESP SYSTEM
-- ══════════════════════════════════════════════════════════════
local ESP = {}

local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1.5
FovCircle.Color = Color3.fromRGB(210,210,210)
FovCircle.Filled = false
FovCircle.NumSides = 64
FovCircle.Visible = false

local SilentFovCircle = Drawing.new("Circle")
SilentFovCircle.Thickness = 1.5
SilentFovCircle.Color = Color3.fromRGB(255, 100, 0)
SilentFovCircle.Filled = false
SilentFovCircle.NumSides = 64
SilentFovCircle.Visible = false

local SilentLine = Drawing.new("Line")
SilentLine.Thickness = 1.5
SilentLine.Color = Color3.fromRGB(255, 100, 0)
SilentLine.Visible = false

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
    e.box.Visible = false; e.hpbg.Visible = false; e.hpbar.Visible = false
    e.hpnum.Visible = false; e.dispname.Visible = false; e.username.Visible = false
    e.dist.Visible = false; e.weapon.Visible = false; e.masak.Visible = false; e.tracer.Visible = false
    for _, c in ipairs(e.corners) do c.Visible = false end
    for _, s in ipairs(e.skeleton) do s.Visible = false end
end

local function createESP(p)
    if ESP[p] or p == plr then return end
    local _c = {}
    for ci = 1, 8 do
        local cl = Drawing.new("Line")
        cl.Thickness = 2; cl.Color = Color3.fromRGB(255,255,255); cl.Visible = false
        _c[ci] = cl
    end
    local _sk = {}
    for si = 1, 15 do
        local sl = Drawing.new("Line")
        sl.Thickness = 1.2; sl.Color = Color3.fromRGB(255,255,255); sl.Visible = false
        _sk[si] = sl
    end
    local e = {
        box     = Drawing.new("Square"),
        hpbg    = Drawing.new("Square"),
        hpbar   = Drawing.new("Square"),
        hpnum   = _mkText(10, Color3.fromRGB(255,255,255)),
        dispname= _mkText(13, Color3.fromRGB(255,255,255)),
        username= _mkText(11, Color3.fromRGB(200,200,200)),
        dist    = _mkText(11, Color3.fromRGB(180,180,180)),
        weapon  = _mkText(11, Color3.fromRGB(255,220,80)),
        tracer  = _mkLine(1.2, Color3.fromRGB(255,255,255)),
        masak   = _mkText(13, Color3.fromRGB(0,255,80)),
        corners = _c,
        skeleton= _sk,
    }
    e.box.Thickness = 1.5; e.box.Filled = false
    e.hpbg.Thickness = 1; e.hpbg.Filled = true; e.hpbg.Color = Color3.fromRGB(0,0,0)
    e.hpbar.Thickness = 1; e.hpbar.Filled = true
    ESP[p] = e
end

local function removeESP(p)
    if not ESP[p] then return end
    local _e = ESP[p]
    if _e.corners then for _, c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
    if _e.skeleton then for _, s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
    for k, d in pairs(_e) do if k ~= "corners" and k ~= "skeleton" then pcall(function() d:Remove() end) end end
    ESP[p] = nil
end

for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(removeESP)

-- ══════════════════════════════════════════════════════════════
-- VEHICLE TELEPORT HELPER
-- ══════════════════════════════════════════════════════════════
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
        }))
    end)
end

-- ══════════════════════════════════════════════════════════════
-- MAIN TAB — WAR
-- ══════════════════════════════════════════════════════════════
MainGroup:AddToggle("InstantInteract", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Interact instantly with proximity prompts",
    Callback = function(v) Flags.InstantInteract = v end,
})

MainGroup:AddToggle("InvScan", {
    Text = "Inv Scan",
    Default = false,
    Tooltip = "Show player inventory above head",
    Callback = function(v) Flags.InvScan = v end,
})

MainGroup:AddToggle("TPNoClip", {
    Text = "Blink TP",
    Default = false,
    Tooltip = "TP forward with T key (PC mode)",
    Callback = function(v) Flags.TPNoClip = v end,
})

MainGroup:AddToggle("InfStamina", {
    Text = "Inf Stamina",
    Default = false,
    Callback = function(v) Flags.InfStamina = v end,
})

MainGroup:AddToggle("HybridSpeed", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(v) Flags.HybridSpeed = v end,
})

MainGroup:AddToggle("AuraKill", {
    Text = "NoClip",
    Default = false,
    Tooltip = "Walk through walls",
    Callback = function(v) Flags.AuraKill = v end,
})

-- ══════════════════════════════════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════════════════════════════════
VisualGroup:AddToggle("BoxESP", {
    Text = "Box ESP",
    Default = false,
    Callback = function(v) Flags.BoxESP = v end,
})

VisualGroup:AddDropdown("BoxESPMode", {
    Values = {"FULL", "CORNER"},
    Default = "FULL",
    Text = "Box Style",
    Callback = function(v) BoxESPMode = v end,
})

VisualGroup:AddToggle("Tracer", {
    Text = "Tracer",
    Default = false,
    Callback = function(v) Flags.Tracer = v end,
})

VisualGroupR:AddToggle("ESPName", {
    Text = "Name",
    Default = true,
    Callback = function(v) Flags.ESPName = v end,
})

VisualGroupR:AddToggle("ESPDist", {
    Text = "Distance",
    Default = true,
    Callback = function(v) Flags.ESPDist = v end,
})

VisualGroupR:AddToggle("ESPHPBar", {
    Text = "HP Bar",
    Default = true,
    Callback = function(v) Flags.ESPHPBar = v end,
})

VisualGroupR:AddToggle("ESPWeapon", {
    Text = "Weapon",
    Default = true,
    Callback = function(v) Flags.ESPWeapon = v end,
})

VisualGroupR:AddToggle("ESPSkeleton", {
    Text = "Skeleton",
    Default = false,
    Callback = function(v) Flags.ESPSkeleton = v end,
})

VisualGroupR:AddToggle("ESPMasak", {
    Text = "Masak Tag",
    Default = true,
    Callback = function(v) Flags.ESPMasak = v end,
})

VisualGroup:AddSlider("TracerMaxDist", {
    Text = "Tracer Distance",
    Default = 300, Min = 50, Max = 1000, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) TracerMaxDist = v end,
})

VisualGroup:AddSlider("ESPMaxDist", {
    Text = "ESP Distance",
    Default = 500, Min = 10, Max = 5000, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) ESPMaxDist = v end,
})

-- ══════════════════════════════════════════════════════════════
-- AIM TAB
-- ══════════════════════════════════════════════════════════════
AimGroup:AddToggle("AimLock", {
    Text = "Auto Aim",
    Default = false,
    Callback = function(v) Flags.AimLock = v end,
})

AimGroup:AddDropdown("AimMode", {
    Values = {"PC", "HP"},
    Default = "PC",
    Text = "Aim Mode",
    Callback = function(v) AimMode = v end,
})

AimGroup:AddDropdown("AimPart", {
    Values = {"Head", "Body"},
    Default = "Head",
    Text = "Aim Part",
    Callback = function(v) AimPart = v == "Head" and "Head" or "HumanoidRootPart" end,
})

AimGroup:AddToggle("WallCheck", {
    Text = "Wall Check",
    Default = false,
    Callback = function(v) Flags.WallCheck = v end,
})

AimGroup:AddSlider("AimFOV", {
    Text = "FOV Radius (Aimbot)",
    Default = 120, Min = 30, Max = 400, Rounding = 0,
    Suffix = "px",
    Callback = function(v) AimFOV_Radius = v end,
})

AimGroup:AddSlider("AimMaxDist", {
    Text = "Max Distance",
    Default = 300, Min = 50, Max = 1000, Rounding = 0,
    Suffix = " studs",
    Callback = function(v) AimMax_Dist = v end,
})

AimGroup:AddSlider("AimSmooth", {
    Text = "Smoothness",
    Default = 85, Min = 1, Max = 100, Rounding = 0,
    Suffix = "%",
    Callback = function(v) AimSmooth = math.clamp(v / 100, 0.01, 0.99) end,
})

AimGroupR:AddToggle("SilentAim", {
    Text = "Silent Aim",
    Default = false,
    Callback = function(v) SilentAim = v end,
})

AimGroupR:AddToggle("SilentAimWallbang", {
    Text = "Silent Wallbang",
    Default = false,
    Callback = function(v) SilentAimWallbang = v end,
})

AimGroupR:AddSlider("SilentFOV", {
    Text = "FOV Radius (Silent)",
    Default = 120, Min = 30, Max = 400, Rounding = 0,
    Suffix = "px",
    Callback = function(v) SilentFOV_Radius = v end,
})

AimGroupR:AddToggle("ShowAimFOV", {
    Text = "Show FOV (Aimbot)",
    Default = true,
    Callback = function(v) ShowAimFOV = v end,
})

AimGroupR:AddToggle("ShowSilentFOV", {
    Text = "Show FOV (Silent)",
    Default = true,
    Callback = function(v) ShowSilentFOV = v end,
})

-- ══════════════════════════════════════════════════════════════
-- FARM TAB
-- ══════════════════════════════════════════════════════════════
FarmGroup:AddToggle("AutoCook", {
    Text = "Auto Cook",
    Default = false,
    Tooltip = "Auto cook marshmallow",
    Callback = function(v)
        Flags.AutoCook = v
    end,
})

FarmGroup:AddButton({
    Text = "Reset Counter",
    Func = function()
        Library:Notify({Title = "Counter", Description = "Counter direset!", Time = 2})
    end,
})

-- Auto Buy Section
FarmGroupR:AddSlider("BuyAmount", {
    Text = "Jumlah Beli",
    Default = 10, Min = 1, Max = 100, Rounding = 0,
    Suffix = "x",
    Callback = function(v) AutoBuySettings.Amount = v end,
})

FarmGroupR:AddButton({
    Text = "Buy PACK (Water+Sugar+Gelatin)",
    Func = function()
        local RS2 = game:GetService("ReplicatedStorage")
        local remEvts = RS2:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then
            Library:Notify({Title = "Error", Description = "RemoteEvent tidak ditemukan!", Time = 3})
            return
        end
        task.spawn(function()
            for _, item in ipairs({"Water", "Sugar Block Bag", "Gelatin"}) do
                for i = 1, AutoBuySettings.Amount do
                    pcall(function() spRE:FireServer(item, 1) end)
                    task.wait(0.4)
                end
            end
            Library:Notify({Title = "Auto Buy", Description = "PACK selesai dibeli!", Time = 3})
        end)
    end,
})

FarmGroupR:AddButton({
    Text = "Buy WATER",
    Func = function()
        local RS2 = game:GetService("ReplicatedStorage")
        local remEvts = RS2:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then
            Library:Notify({Title = "Error", Description = "RemoteEvent tidak ditemukan!", Time = 3})
            return
        end
        task.spawn(function()
            for i = 1, AutoBuySettings.Amount do
                pcall(function() spRE:FireServer("Water", 1) end)
                task.wait(0.4)
            end
            Library:Notify({Title = "Auto Buy", Description = "Water selesai dibeli!", Time = 3})
        end)
    end,
})

FarmGroupR:AddButton({
    Text = "Buy SUGAR",
    Func = function()
        local RS2 = game:GetService("ReplicatedStorage")
        local remEvts = RS2:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then
            Library:Notify({Title = "Error", Description = "RemoteEvent tidak ditemukan!", Time = 3})
            return
        end
        task.spawn(function()
            for i = 1, AutoBuySettings.Amount do
                pcall(function() spRE:FireServer("Sugar Block Bag", 1) end)
                task.wait(0.4)
            end
            Library:Notify({Title = "Auto Buy", Description = "Sugar selesai dibeli!", Time = 3})
        end)
    end,
})

FarmGroupR:AddButton({
    Text = "Buy GELATIN",
    Func = function()
        local RS2 = game:GetService("ReplicatedStorage")
        local remEvts = RS2:FindFirstChild("RemoteEvents")
        local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
        if not spRE then
            Library:Notify({Title = "Error", Description = "RemoteEvent tidak ditemukan!", Time = 3})
            return
        end
        task.spawn(function()
            for i = 1, AutoBuySettings.Amount do
                pcall(function() spRE:FireServer("Gelatin", 1) end)
                task.wait(0.4)
            end
            Library:Notify({Title = "Auto Buy", Description = "Gelatin selesai dibeli!", Time = 3})
        end)
    end,
})

-- ══════════════════════════════════════════════════════════════
-- TP TAB
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
        {name="Bank", x=-48.64, y=3.73, z=-320.46},
        {name="Box Job", x=-578.48, y=3.53, z=-74.82},
        {name="Buy Marshmellow", x=510.38, y=3.59, z=603.50},
        {name="Casino", x=1152.53, y=20.32, z=-26.31},
        {name="Chips Cook", x=-487.11, y=3.86, z=-454.16},
        {name="Chips Store", x=-773.72, y=3.66, z=-187.54},
        {name="Chips Tukar", x=-34.91, y=4.56, z=-24.15},
        {name="Dealer", x=730.24, y=3.7, z=449.47},
        {name="Fake Card", x=216.28, y=3.73, z=-331.79},
        {name="Gun Sell", x=75.09, y=3.76, z=26.53},
        {name="Gun Store 1", x=215.77, y=3.73, z=-179.89},
        {name="Gun Store 2", x=-468.37, y=3.86, z=349.56},
        {name="Haircut", x=52.73, y=3.73, z=-71.39},
        {name="Tattoo Shop", x=951.72, y=3.83, z=-72.93},
    }},
}

local function tpToPos(cx, cy, cz, destName)
    task.spawn(function()
        local ch = plr.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        showTPOverlay(destName or "destination")
        task.wait(0.3)

        hrp.CFrame = CFrame.new(cx, cy + 3, cz)
        task.wait(0.5)

        hideTPOverlay()
        Library:Notify({Title = "Teleport", Description = "Arrived: " .. (destName or "destination"), Time = 2})
    end)
end

for _, cat in ipairs(TP_CATEGORIES) do
    local section = TPGroup:AddSection(cat.name)
    for _, loc in ipairs(cat.locs) do
        section:AddButton({
            Text = loc.name,
            Func = function()
                tpToPos(loc.x, loc.y, loc.z, loc.name)
            end,
        })
    end
end

-- ══════════════════════════════════════════════════════════════
-- VEHICLE TAB
-- ══════════════════════════════════════════════════════════════
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
            local dir = Vector3.new(0,0,0)
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
            vRoot.AssemblyLinearVelocity = Vector3.new(0,0,0)
            vRoot.AssemblyAngularVelocity = Vector3.new(0,0,0)
        else
            if vFlyActive then
                vFlyActive = false
                vStopFly()
            end
        end
    end)
end

VehicleGroup:AddToggle("VehicleFly", {
    Text = "Vehicle Fly (WASD + E/Q)",
    Default = false,
    Callback = function(v)
        vFlyActive = v
        if v then vStartFly() else vStopFly() end
    end,
})

VehicleGroup:AddSlider("VehicleFlySpeed", {
    Text = "Fly Speed",
    Default = 50, Min = 10, Max = 500, Rounding = 0,
    Suffix = "",
    Callback = function(v) vFlySpeed = v end,
})

VehicleGroup:AddLabel("ℹ Duduk di kendaraan dulu sebelum ON")
VehicleGroup:AddLabel("• W/A/S/D = gerak ngikutin kamera")
VehicleGroup:AddLabel("• E = naik | Q = turun")
VehicleGroup:AddLabel("• Auto OFF kalau keluar kendaraan")

-- ══════════════════════════════════════════════════════════════
-- INFO TAB
-- ══════════════════════════════════════════════════════════════
InfoGroup:AddLabel("TikTok: @drakhub")
InfoGroup:AddLabel("Discord: discord.gg/AbHhEACZC")
InfoGroup:AddButton({
    Text = "Copy Discord Link",
    Func = function()
        pcall(function() setclipboard("https://discord.gg/AbHhEACZC") end)
        Library:Notify({Title = "Copied!", Description = "Discord link tersalin!", Time = 2})
    end,
})

InfoGroupR:AddLabel("⚠ USE AT YOUR OWN RISK")
InfoGroupR:AddLabel("We are not responsible for any bans.")
InfoGroupR:AddLabel("🚫 DILARANG SHARING SCRIPT INI!")
InfoGroupR:AddLabel("🚫 DILARANG JUAL BELI SCRIPT INI!")

-- ══════════════════════════════════════════════════════════════
-- UI SETTINGS TAB
-- ══════════════════════════════════════════════════════════════
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value) Library.KeybindFrame.Visible = value end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value) Library.ShowCustomCursor = Value end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value) Library:SetNotifySide(Value) end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        Library:SetDPIScale(tonumber(Value))
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift", NoUI = true, Text = "Menu keybind"
})

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- ══════════════════════════════════════════════════════════════
-- ADDONS SETUP
-- ══════════════════════════════════════════════════════════════
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("DarkHub")
SaveManager:SetFolder("DarkHub/specific-game")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ══════════════════════════════════════════════════════════════
-- AUTO BUY SETTINGS
-- ══════════════════════════════════════════════════════════════
local AutoBuySettings = { Enabled = false, Amount = 10, Mode = "PACK" }
_G.DARKHUB_AUTOBUY = AutoBuySettings

-- ══════════════════════════════════════════════════════════════
-- MAIN RENDER LOOP — ESP + AIM
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

local function countItems(p)
    local hasBahan, wName = false, nil
    pcall(function()
        local bp = p.Backpack
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") then
                    local n = v.Name:lower()
                    if n:find("water") or n:find("sugar") or n:find("gelatin") or n:find("marshmallow") then
                        hasBahan = true
                    end
                end
            end
        end
        local ch = p.Character
        if ch then
            for _, v in ipairs(ch:GetChildren()) do
                if v:IsA("Tool") then
                    local n = v.Name:lower()
                    if n:find("water") or n:find("sugar") or n:find("gelatin") or n:find("marshmallow") then
                        hasBahan = true
                    else
                        wName = v.Name
                    end
                end
            end
        end
    end)
    return hasBahan, wName
end

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
    local localChar = plr.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    local fovCenter = AimMode == "HP" and Vector2.new(vp.X / 2, vp.Y / 2) or mousePos

    -- FOV Circles
    FovCircle.Radius = AimFOV_Radius
    FovCircle.Visible = Flags.AimLock and ShowAimFOV
    FovCircle.Position = fovCenter

    -- Silent Aim FOV
    if SilentAim then
        local saOrigin = SilentMode == "HP" and Vector2.new(vp.X / 2, vp.Y / 2) or mousePos
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
            local worldD = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
            if worldD < bestWorldD then bestWorldD = worldD; bestScreenPos = screenPos end
        end
        if bestScreenPos then
            SilentFovCircle.Position = SilentMode == "HP" and bestScreenPos or saOrigin
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

    -- Aimbot Logic
    if AimTarget then
        local tHum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
        if not tHum or tHum.Health <= 0 then AimTarget = nil end
    end

    local shouldAim = Flags.AimLock and localRoot and (AimMode == "HP" or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))

    if shouldAim then
        if AimMode == "HP" or not AimTarget then
            local bestDist, bestPart = math.huge, nil
            for _, p in pairs(game.Players:GetPlayers()) do
                if p == plr then continue end
                if AimWhitelist[p.Name] then continue end
                local ch = p.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local targetPart = ch and ch:FindFirstChild(AimPart)
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
                local d = (Vector2.new(sp.X, sp.Y) - fovCenter).Magnitude
                if d <= AimFOV_Radius and d < bestDist then
                    bestDist = d
                    bestPart = targetPart
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

    -- ESP Render
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
        if Flags.ESPSkeleton and ch then
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
                        sk.Color = W2
                        sk.Visible = true
                    else sk.Visible = false end
                else sk.Visible = false end
            end
        else
            for _, s in ipairs(e.skeleton) do s.Visible = false end
        end

        -- Box calc
        local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
        local sY = math.abs(botPos.Y - topPos.Y)
        local sX = sY * 0.6
        local bx = pos3.X - sX / 2
        local by = math.min(topPos.Y, botPos.Y)

        local hasBahan, wName = countItems(p)
        local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)

        -- Box
        if Flags.BoxESP then
            e.box.Color = W
            e.box.Size = Vector2.new(sX, sY)
            e.box.Position = Vector2.new(bx, by)
            e.box.Visible = (BoxESPMode == "FULL")
            local showC = (BoxESPMode == "CORNER")
            local cL = math.min(sX, sY) * 0.25
            local cx = e.corners
            cx[1].From = Vector2.new(bx, by); cx[1].To = Vector2.new(bx + cL, by)
            cx[2].From = Vector2.new(bx, by); cx[2].To = Vector2.new(bx, by + cL)
            cx[3].From = Vector2.new(bx + sX, by); cx[3].To = Vector2.new(bx + sX - cL, by)
            cx[4].From = Vector2.new(bx + sX, by); cx[4].To = Vector2.new(bx + sX, by + cL)
            cx[5].From = Vector2.new(bx, by + sY); cx[5].To = Vector2.new(bx + cL, by + sY)
            cx[6].From = Vector2.new(bx, by + sY); cx[6].To = Vector2.new(bx, by + sY - cL)
            cx[7].From = Vector2.new(bx + sX, by + sY); cx[7].To = Vector2.new(bx + sX - cL, by + sY)
            cx[8].From = Vector2.new(bx + sX, by + sY); cx[8].To = Vector2.new(bx + sX, by + sY - cL)
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
            e.hpbg.Size = Vector2.new(4, sY)
            e.hpbg.Position = Vector2.new(barX, by)
            e.hpbg.Color = Color3.fromRGB(0,0,0)
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
        else
            e.hpbg.Visible = false; e.hpbar.Visible = false; e.hpnum.Visible = false
        end

        -- Name
        local distNow = localRoot and (root.Position - localRoot.Position).Magnitude or 100
        local tSize = math.clamp(math.floor(14 - distNow / 40), 8, 14)
        if Flags.ESPName then
            e.dispname.Text = (p.DisplayName or p.Name) .. "(@" .. p.Name .. ")"
            e.dispname.Size = tSize
            e.dispname.Color = W
            e.dispname.Position = Vector2.new(pos3.X, by - 14)
            e.dispname.Visible = true
        else e.dispname.Visible = false end

        -- Distance
        local dist = localRoot and math.floor((root.Position - localRoot.Position).Magnitude) or 0
        local nY = by + sY + 3
        if Flags.ESPDist then
            e.dist.Text = dist .. "m"
            e.dist.Size = tSize
            e.dist.Color = W
            e.dist.Position = Vector2.new(pos3.X, nY)
            e.dist.Visible = true
            nY = nY + 13
        else e.dist.Visible = false end

        -- Weapon
        if Flags.ESPWeapon and wName then
            e.weapon.Text = wName
            e.weapon.Color = Color3.fromRGB(255,220,80)
            e.weapon.Position = Vector2.new(pos3.X, nY)
            e.weapon.Visible = true
        else e.weapon.Visible = false end

        -- Masak
        if Flags.ESPMasak and hasBahan then
            e.masak.Text = "MASAK"
            e.masak.Position = Vector2.new(bx + sX + 4, by + sY / 2 - 6)
            e.masak.Center = false
            e.masak.Visible = true
        else e.masak.Visible = false end

        -- Tracer
        local tracerDist = localRoot and (root.Position - localRoot.Position).Magnitude or 999
        if Flags.Tracer and tracerDist < TracerMaxDist then
            e.tracer.From = Vector2.new(vp.X / 2, vp.Y)
            e.tracer.To = Vector2.new(pos3.X, by + sY)
            e.tracer.Color = W
            e.tracer.Visible = true
        else e.tracer.Visible = false end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- INF STAMINA
-- ══════════════════════════════════════════════════════════════
RunService:BindToRenderStep("DarkHubInfStamina", 0, function()
    if not Flags.InfStamina then return end
    pcall(function()
        local MovCtrl = require(plr.PlayerScripts["Client.Initializer"].Modules.MovementController)
        MovCtrl.Stamina = 100
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- SPEED HACK
-- ══════════════════════════════════════════════════════════════
local HS_ANIM_SPEED = 22
local HS_FINAL_SPEED = 25
local HS_PUSH = HS_FINAL_SPEED - HS_ANIM_SPEED

RunService.Heartbeat:Connect(function(dt)
    if not Flags.HybridSpeed then return end
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if hum.WalkSpeed ~= HS_ANIM_SPEED then hum.WalkSpeed = HS_ANIM_SPEED end
    if hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + hum.MoveDirection * HS_PUSH * dt
    end
end)

-- ══════════════════════════════════════════════════════════════
-- NOCLIP
-- ══════════════════════════════════════════════════════════════
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

-- ══════════════════════════════════════════════════════════════
-- BLINK TP (T)
-- ══════════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(input, processed)
    if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode == Enum.KeyCode.T then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
                {CFrame = hrp.CFrame * CFrame.new(0, 0, -6)}):Play()
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- INV SCAN (BillboardGui)
-- ══════════════════════════════════════════════════════════════
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
game.Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    createInvTag(p)
end)
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
                    for _, v in pairs(p.Backpack:GetChildren()) do table.insert(inv, "• " .. v.Name) end
                    local lbl = it:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = "[HELD]: " .. held .. "\n\n[INV]:\n" .. table.concat(inv, "\n") end
                end)
            else
                it.Enabled = false
            end
        end
    end
end)

-- ══════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ══════════════════════════════════════════════════════════════
do
    local VirtualUser = game:GetService("VirtualUser")
    plr.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end

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
    print("[DARK HUB] Unloaded!")
end)

Library:Notify({
    Title = "DARK HUB Loaded!",
    Description = "Tekan RightShift untuk buka menu.",
    Time = 5,
})