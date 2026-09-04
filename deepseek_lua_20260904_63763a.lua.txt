-- Cleaned & Rebranded as DARK HUB
-- Removed all anti-deobfuscation layers
-- Rebranded from "STR HUB" to "DARK HUB"
-- Discord invite changed to: https://discord.gg/MbPfardKP

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local TARGET_PLACE_ID = 73771248610396
local TARGET_KEY = "gunz.cali-streets"
local DISCORD_INVITE = "https://discord.gg/MbPfardKP"
local SCRIPT_URL = "https://gist.githubusercontent.com/strixwashere-s9/0ee465ded5222548d1a38f65f5264d79/raw/46a59ea69a30b7011106d2f4c2093e2f5404107a/gistfile1.txt"
local KEY_FILE = "StrixSecureKeyCache.json"  -- biarkan saja, tidak perlu diganti

local function saveKey(key, remember)
    if not writefile then return end
    pcall(function()
        writefile(KEY_FILE, HttpService:JSONEncode({
            Key = key,
            Remember = remember
        }))
    end)
end

local function deleteKeyFile()
    if not delfile or not isfile then return end
    if isfile(KEY_FILE) then
        pcall(delfile, KEY_FILE)
    end
end

local function loadSavedKey()
    if not (writefile and readfile and isfile) then return nil end
    if not isfile(KEY_FILE) then return nil end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(KEY_FILE))
    end)
    if success and type(data) == "table" then
        return data
    end
    return nil
end

-- Block GUI for unsupported games
local function showBlockGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DarkHubGameBlockGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui

    local fadeTween = TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.5
    })
    fadeTween:Play()

    local blockFrame = Instance.new("Frame")
    blockFrame.Name = "BlockFrame"
    blockFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    blockFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    blockFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    blockFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    blockFrame.BorderSizePixel = 0
    blockFrame.Parent = screenGui

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MaxSize = Vector2.new(380, 210)
    sizeConstraint.MinSize = Vector2.new(280, 190)
    sizeConstraint.Parent = blockFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = blockFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = blockFrame

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundTransparency = 1
    header.Parent = blockFrame

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 0, 20)
    accent.Position = UDim2.new(0, 16, 0, 12)
    accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel = 0
    accent.Parent = header

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 28, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "DARK HUB | EXECUTION BLOCKED"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -34, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeBtn.TextSize = 12
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -32, 0, 75)
    message.Position = UDim2.new(0, 16, 0, 50)
    message.BackgroundTransparency = 1
    message.Font = Enum.Font.Gotham
    message.Text = "This script is restricted strictly to Cali Streets. Please join the supported game to execute this script."
    message.TextColor3 = Color3.fromRGB(180, 180, 180)
    message.TextSize = 12
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = blockFrame

    local dismissBtn = Instance.new("TextButton")
    dismissBtn.Size = UDim2.new(1, -32, 0, 38)
    dismissBtn.Position = UDim2.new(0, 16, 0, 150)
    dismissBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dismissBtn.BorderSizePixel = 0
    dismissBtn.Font = Enum.Font.GothamBold
    dismissBtn.Text = "Dismiss"
    dismissBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    dismissBtn.TextSize = 13
    dismissBtn.AutoButtonColor = false
    dismissBtn.Parent = blockFrame

    local dismissCorner = Instance.new("UICorner")
    dismissCorner.CornerRadius = UDim.new(0, 8)
    dismissCorner.Parent = dismissBtn

    local function closeGui()
        local fadeOut = TweenService:Create(overlay, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        local shrink = TweenService:Create(blockFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        shrink:Play()
        task.wait(0.25)
        screenGui:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(closeGui)
    dismissBtn.MouseButton1Click:Connect(closeGui)
end

-- Key system GUI
local function showKeyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DarkHubSecureKeySystem"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame

    local bgTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0
    })
    bgTween:Play()

    local content = Instance.new("Frame")
    content.Name = "ContentContainer"
    content.AnchorPoint = Vector2.new(0.5, 0.5)
    content.Position = UDim2.new(0.5, 0, 0.5, 0)
    content.Size = UDim2.new(0.9, 0, 0.8, 0)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MaxSize = Vector2.new(460, 350)
    sizeConstraint.MinSize = Vector2.new(300, 330)
    sizeConstraint.Parent = content

    local bgPanel = Instance.new("Frame")
    bgPanel.Size = UDim2.new(1, 0, 1, 0)
    bgPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bgPanel.BackgroundTransparency = 0.2
    bgPanel.BorderSizePixel = 0
    bgPanel.Parent = content

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = bgPanel

    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(255, 255, 255)
    panelStroke.Transparency = 0.3
    panelStroke.Thickness = 1.5
    panelStroke.Parent = bgPanel

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundTransparency = 1
    header.Parent = content

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 0, 24)
    accent.Position = UDim2.new(0, 20, 0, 18)
    accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel = 0
    accent.Parent = header

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0, 34, 0, 18)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "DARK HUB | KEY SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 15)
    subtitle.Position = UDim2.new(0, 34, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Verify your authorization code to initialize execution."
    subtitle.TextColor3 = Color3.fromRGB(160, 160, 160)
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.88, 0, 0, 48)
    inputFrame.Position = UDim2.new(0.06, 0, 0, 78)
    inputFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = content

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(60, 60, 60)
    inputStroke.Thickness = 1
    inputStroke.Parent = inputFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -20, 1, 0)
    keyBox.Position = UDim2.new(0, 10, 0, 0)
    keyBox.BackgroundTransparency = 1
    keyBox.Font = Enum.Font.GothamMedium
    keyBox.PlaceholderText = "Paste your key from the discord server..."
    keyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 13
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = inputFrame

    keyBox.Focused:Connect(function()
        local tween = TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 255, 255)
        })
        tween:Play()
    end)

    keyBox.FocusLost:Connect(function()
        local tween = TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(60, 60, 60)
        })
        tween:Play()
    end)

    local rememberFrame = Instance.new("TextButton")
    rememberFrame.Size = UDim2.new(0.88, 0, 0, 24)
    rememberFrame.Position = UDim2.new(0.06, 0, 0, 138)
    rememberFrame.BackgroundTransparency = 1
    rememberFrame.AutoButtonColor = false
    rememberFrame.Text = ""
    rememberFrame.Parent = content

    local checkBox = Instance.new("Frame")
    checkBox.Size = UDim2.new(0, 20, 0, 20)
    checkBox.Position = UDim2.new(0, 0, 0.5, -10)
    checkBox.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    checkBox.BorderSizePixel = 0
    checkBox.Parent = rememberFrame

    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 5)
    checkCorner.Parent = checkBox

    local checkStroke = Instance.new("UIStroke")
    checkStroke.Color = Color3.fromRGB(80, 80, 80)
    checkStroke.Thickness = 1.5
    checkStroke.Parent = checkBox

    local checkMark = Instance.new("Frame")
    checkMark.Size = UDim2.new(0, 12, 0, 12)
    checkMark.Position = UDim2.new(0.5, -6, 0.5, -6)
    checkMark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    checkMark.BorderSizePixel = 0
    checkMark.BackgroundTransparency = 1
    checkMark.Parent = checkBox

    local checkMarkCorner = Instance.new("UICorner")
    checkMarkCorner.CornerRadius = UDim.new(0, 3)
    checkMarkCorner.Parent = checkMark

    local rememberLabel = Instance.new("TextLabel")
    rememberLabel.Size = UDim2.new(1, -30, 1, 0)
    rememberLabel.Position = UDim2.new(0, 30, 0, 0)
    rememberLabel.BackgroundTransparency = 1
    rememberLabel.Font = Enum.Font.GothamMedium
    rememberLabel.Text = "Remember Key (Auto-Login)"
    rememberLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rememberLabel.TextSize = 13
    rememberLabel.TextXAlignment = Enum.TextXAlignment.Left
    rememberLabel.Parent = rememberFrame

    local rememberKey = false
    rememberFrame.MouseButton1Click:Connect(function()
        rememberKey = not rememberKey
        local tween = TweenService:Create(checkMark, TweenInfo.new(0.15), {
            BackgroundTransparency = rememberKey and 0 or 1
        })
        tween:Play()
        local bgColor = rememberKey and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(22, 22, 22)
        local tween2 = TweenService:Create(checkBox, TweenInfo.new(0.15), {
            BackgroundColor3 = bgColor
        })
        tween2:Play()
    end)

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.57, -5, 0, 42)
    verifyBtn.Position = UDim2.new(0.06, 0, 0, 176)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.BorderSizePixel = 0
    verifyBtn.AutoButtonColor = false
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Text = "Verify Key"
    verifyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    verifyBtn.TextSize = 13
    verifyBtn.Parent = content

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 8)
    verifyCorner.Parent = verifyBtn

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.31, -5, 0, 42)
    getKeyBtn.Position = UDim2.new(0.63, 0, 0, 176)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    getKeyBtn.BorderSizePixel = 0
    getKeyBtn.AutoButtonColor = false
    getKeyBtn.Font = Enum.Font.GothamMedium
    getKeyBtn.Text = "Get Key"
    getKeyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    getKeyBtn.TextSize = 12
    getKeyBtn.Parent = content

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyBtn

    local getKeyStroke = Instance.new("UIStroke")
    getKeyStroke.Color = Color3.fromRGB(60, 60, 60)
    getKeyStroke.Thickness = 1
    getKeyStroke.Parent = getKeyBtn

    local howToBtn = Instance.new("TextButton")
    howToBtn.Size = UDim2.new(0.88, 0, 0, 36)
    howToBtn.Position = UDim2.new(0.06, 0, 0, 228)
    howToBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    howToBtn.BorderSizePixel = 0
    howToBtn.AutoButtonColor = false
    howToBtn.Font = Enum.Font.GothamMedium
    howToBtn.Text = "How To Get Key?"
    howToBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    howToBtn.TextSize = 12
    howToBtn.Parent = content

    local howToCorner = Instance.new("UICorner")
    howToCorner.CornerRadius = UDim.new(0, 8)
    howToCorner.Parent = howToBtn

    local howToStroke = Instance.new("UIStroke")
    howToStroke.Color = Color3.fromRGB(60, 60, 60)
    howToStroke.Thickness = 1
    howToStroke.Parent = howToBtn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.88, 0, 0, 20)
    statusLabel.Position = UDim2.new(0.06, 0, 0, 280)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Text = "Awaiting verification..."
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = content

    -- Tutorial popup
    local tutorialFrame = Instance.new("Frame")
    tutorialFrame.Name = "TutorialFrame"
    tutorialFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    tutorialFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    tutorialFrame.Size = UDim2.new(0.85, 0, 0.6, 0)
    tutorialFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tutorialFrame.BorderSizePixel = 0
    tutorialFrame.Visible = false
    tutorialFrame.ZIndex = 5
    tutorialFrame.Parent = mainFrame

    local tutorialSize = Instance.new("UISizeConstraint")
    tutorialSize.MaxSize = Vector2.new(360, 200)
    tutorialSize.MinSize = Vector2.new(270, 180)
    tutorialSize.Parent = tutorialFrame

    local tutorialCorner = Instance.new("UICorner")
    tutorialCorner.CornerRadius = UDim.new(0, 10)
    tutorialCorner.Parent = tutorialFrame

    local tutorialStroke = Instance.new("UIStroke")
    tutorialStroke.Color = Color3.fromRGB(255, 255, 255)
    tutorialStroke.Thickness = 1.5
    tutorialStroke.Parent = tutorialFrame

    local tutorialHeader = Instance.new("Frame")
    tutorialHeader.Size = UDim2.new(1, 0, 0, 40)
    tutorialHeader.BackgroundTransparency = 1
    tutorialHeader.ZIndex = 6
    tutorialHeader.Parent = tutorialFrame

    local tutorialTitle = Instance.new("TextLabel")
    tutorialTitle.Size = UDim2.new(1, -40, 1, 0)
    tutorialTitle.Position = UDim2.new(0, 15, 0, 0)
    tutorialTitle.BackgroundTransparency = 1
    tutorialTitle.Font = Enum.Font.GothamBold
    tutorialTitle.Text = "HOW TO GET KEY"
    tutorialTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tutorialTitle.TextSize = 14
    tutorialTitle.TextXAlignment = Enum.TextXAlignment.Left
    tutorialTitle.ZIndex = 6
    tutorialTitle.Parent = tutorialHeader

    local tutorialClose = Instance.new("TextButton")
    tutorialClose.Size = UDim2.new(0, 24, 0, 24)
    tutorialClose.Position = UDim2.new(1, -32, 0, 8)
    tutorialClose.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tutorialClose.BorderSizePixel = 0
    tutorialClose.Font = Enum.Font.GothamBold
    tutorialClose.Text = "X"
    tutorialClose.TextColor3 = Color3.fromRGB(255, 255, 255)
    tutorialClose.TextSize = 12
    tutorialClose.ZIndex = 6
    tutorialClose.Parent = tutorialHeader

    local tutorialCloseCorner = Instance.new("UICorner")
    tutorialCloseCorner.CornerRadius = UDim.new(0, 6)
    tutorialCloseCorner.Parent = tutorialClose

    local tutorialText = Instance.new("TextLabel")
    tutorialText.Size = UDim2.new(1, -30, 0, 120)
    tutorialText.Position = UDim2.new(0, 15, 0, 45)
    tutorialText.BackgroundTransparency = 1
    tutorialText.Font = Enum.Font.Gotham
    tutorialText.Text = "Paste the copied discord link to your browser, join the discord server then find a channel called 🔐 • get-key, copy the key from the channel then after paste the key here and then click authenticate!"
    tutorialText.TextColor3 = Color3.fromRGB(180, 180, 180)
    tutorialText.TextSize = 12
    tutorialText.TextWrapped = true
    tutorialText.TextXAlignment = Enum.TextXAlignment.Left
    tutorialText.TextYAlignment = Enum.TextYAlignment.Top
    tutorialText.ZIndex = 6
    tutorialText.Parent = tutorialFrame

    tutorialClose.MouseButton1Click:Connect(function()
        tutorialFrame.Visible = false
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            statusLabel.Text = "Discord invite link copied to clipboard!"
        else
            statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            statusLabel.Text = "Clipboard execution not supported."
        end
        tutorialFrame.Visible = true
    end)

    howToBtn.MouseButton1Click:Connect(function()
        tutorialFrame.Visible = true
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == TARGET_KEY then
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            statusLabel.Text = "Correct Key! Executing..."

            if rememberKey then
                saveKey(TARGET_KEY, true)
            else
                deleteKeyFile()
            end

            local flash = TweenService:Create(verifyBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            })
            flash:Play()

            task.wait(0.6)

            local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            tutorialFrame.Visible = false
            task.wait(0.35)
            screenGui:Destroy()

            local success, err = pcall(function()
                loadstring(game:HttpGet(SCRIPT_URL))()
            end)
            if not success then
                warn("Target script execution failed: " .. tostring(err))
            end
        else
            statusLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
            statusLabel.Text = "Invalid access key provided."
        end
    end)
end

-- Main execution
if game.PlaceId ~= TARGET_PLACE_ID then
    showBlockGui()
    return
end

local saved = loadSavedKey()
if saved and saved.Key == TARGET_KEY and saved.Remember then
    local success, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)
    if not success then
        warn("Target script execution failed: " .. tostring(err))
    end
    return
end

showKeyGui()