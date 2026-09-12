local Zolar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Da7mu/Ui-Collection/refs/heads/main/Zolar%20Ui/Library.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local plr = Players.LocalPlayer

-- State
local State = {
    -- Aimbot
    AimEnabled = true,
    AimTeamCheck = true,
    AimVisibleCheck = false,
    AimPart = "Head",
    AimFOV = 120,
    AimSmooth = 45,
    AimRangeMin = 50,
    AimRangeMax = 600,
    AimKey = Enum.KeyCode.E,
    AimPred = true,
    AimPredFactor = 1.2,
    AimResolver = false,
    AimMode = "PC",  -- PC (mouse/RMB) or HP (always)
    
    -- ESP
    EspBoxes = true,
    EspNames = true,
    EspTracers = false,
    EspBoxColor = Color3.fromRGB(255, 110, 120),
    EspTextSize = 14,
    EspStyle = "Corner",
    EspDistance = 1500,
    EspBoxMode = "CORNER", -- "FULL" or "CORNER"
    
    -- TP
    OthersSelected = nil,
    
    -- Flags
    Flags = {
        AimLock = false,
        WallCheck = false,
        BoxESP = false,
        Tracer = false,
        ESPName = true,
        ESPDist = true,
        ESPHPBar = true,
        ESPWeapon = true,
        ESPSkeleton = false,
        ESPMasak = true,
    },
    TracerMaxDist = 300,
    ESPMaxDist = 500,
    AimMax_Dist = 300,
    AimFOV_Radius = 120,
    AimSmooth = 0.85,
    AimWhitelist = {},
}

-- RMB state for aim
local RMB = false
UIS.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then RMB = true end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then RMB = false end
end)