-- ================================================================
-- DARK HUB V3.0 — BLUE EDITION (SIDEBAR LAYOUT)
-- ================================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local AutoBuySettings = { Enabled = false, Amount = 10, Mode = "PACK" }
_G.HNDRIXX_AUTOBUY = AutoBuySettings

-- ================================================================
-- POPUP
-- ================================================================
local function showThankYouPopup()
	local PopGui = Instance.new("ScreenGui")
	PopGui.Name = "DARKHUB_Popup"
	PopGui.ResetOnSpawn = false
	PopGui.Parent = CoreGui

	local Card = Instance.new("Frame", PopGui)
	Card.Size = UDim2.new(0, 320, 0, 64)
	Card.AnchorPoint = Vector2.new(0.5, 0)
	Card.Position = UDim2.new(0.5, 0, 0, -80)
	Card.BackgroundColor3 = Color3.fromRGB(6, 10, 22)
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
	local cs = Instance.new("UIStroke", Card)
	cs.Color = Color3.fromRGB(50, 90, 180)

	local accent = Instance.new("Frame", Card)
	accent.Size = UDim2.new(0, 2, 0, 32)
	accent.Position = UDim2.new(0, 0, 0.5, -16)
	accent.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
	accent.BorderSizePixel = 0
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local badge = Instance.new("Frame", Card)
	badge.Size = UDim2.new(0, 50, 0, 18)
	badge.Position = UDim2.new(0, 14, 0, 11)
	badge.BackgroundColor3 = Color3.fromRGB(20, 30, 55)
	Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
	local bdgLbl = Instance.new("TextLabel", badge)
	bdgLbl.Size = UDim2.new(1, 0, 1, 0)
	bdgLbl.BackgroundTransparency = 1
	bdgLbl.Text = "V3.0"
	bdgLbl.TextColor3 = Color3.fromRGB(120, 170, 255)
	bdgLbl.Font = Enum.Font.GothamBlack
	bdgLbl.TextSize = 11

	local Ttl = Instance.new("TextLabel", Card)
	Ttl.Size = UDim2.new(1, -76, 0, 20)
	Ttl.Position = UDim2.new(0, 72, 0, 9)
	Ttl.BackgroundTransparency = 1
	Ttl.Text = "DARK HUB"
	Ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
	Ttl.Font = Enum.Font.GothamBlack
	Ttl.TextSize = 13
	Ttl.TextXAlignment = Enum.TextXAlignment.Left

	local Msg = Instance.new("TextLabel", Card)
	Msg.Size = UDim2.new(1, -76, 0, 16)
	Msg.Position = UDim2.new(0, 72, 0, 32)
	Msg.BackgroundTransparency = 1
	Msg.Text = "TikTok · drakhub"
	Msg.TextColor3 = Color3.fromRGB(120, 160, 220)
	Msg.Font = Enum.Font.Gotham
	Msg.TextSize = 12
	Msg.TextXAlignment = Enum.TextXAlignment.Left

	TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{Position = UDim2.new(0.5, 0, 0, 18)}):Play()
	task.delay(3.5, function()
		local out = TweenService:Create(Card, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
			{Position = UDim2.new(0.5, 0, 0, -80)})
		out:Play()
		out.Completed:Wait()
		PopGui:Destroy()
	end)
end

-- ================================================================
-- MAIN
-- ================================================================
local function launchMainScript()

	local T = {
		BG       = Color3.fromRGB(0, 0, 0),
		Card     = Color3.fromRGB(12, 16, 30),
		CardHov  = Color3.fromRGB(20, 28, 50),
		TopBar   = Color3.fromRGB(6, 10, 22),
		Accent   = Color3.fromRGB(80, 150, 255),
		AccOn    = Color3.fromRGB(80, 150, 255),
		Stroke   = Color3.fromRGB(28, 42, 78),
		StrokeOn = Color3.fromRGB(80, 130, 220),
		Text     = Color3.fromRGB(255, 255, 255),
		TextDim  = Color3.fromRGB(120, 140, 180),
		Red      = Color3.fromRGB(220, 50, 50),
		Green    = Color3.fromRGB(0, 200, 100),
		Blue     = Color3.fromRGB(80, 150, 255),
		BlueDim  = Color3.fromRGB(40, 80, 160),
		Sidebar  = Color3.fromRGB(10, 14, 26),
	}

	local PANEL_W = 620
	local PANEL_H = 500
	local SIDEBAR_W = 130
	local MF_MIN_W,MF_MAX_W=420,900
	local MF_MIN_H,MF_MAX_H=350,720

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "DARKHUB_Gui"
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 20
	Gui.Parent = CoreGui

	-- Logo minimize button
	local LogoBtn = Instance.new("TextButton", Gui)
	LogoBtn.Size = UDim2.new(0, 0, 0, 0)
	LogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
	LogoBtn.BackgroundColor3 = T.TopBar
	LogoBtn.Text = "◈"
	LogoBtn.TextColor3 = T.Blue
	LogoBtn.Font = Enum.Font.GothamBlack
	LogoBtn.TextSize = 22
	LogoBtn.Visible = false
	LogoBtn.Draggable = true
	Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
	local lbStr = Instance.new("UIStroke", LogoBtn)
	lbStr.Color = T.StrokeOn

	local MF = Instance.new("Frame", Gui)
	MF.Size = UDim2.new(0, 0, 0, 0)
	MF.Position = UDim2.new(0.3, 0, 0.25, 0)
	MF.BackgroundColor3 = T.BG
	MF.Active = true
	MF.ClipsDescendants = true
	Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 12)
	local mfStr = Instance.new("UIStroke", MF)
	mfStr.Color = T.Stroke
	mfStr.Thickness = 1

	TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, PANEL_W, 0, PANEL_H)}):Play()

	-- ── RESIZE HANDLES ────────────────────────────────
	do
		local MFR=Instance.new("TextButton",MF)
		MFR.Size=UDim2.new(0,28,0,28)
		MFR.Position=UDim2.new(1,-28,1,-28)
		MFR.BackgroundTransparency=1
		MFR.Text=""
		MFR.AutoButtonColor=false
		MFR.ZIndex=10
		MFR.Active=true
		local rz=false
		local rzS,rzW,rzH
		MFR.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				rz=true; rzS=i.Position; rzW=MF.AbsoluteSize.X; rzH=MF.AbsoluteSize.Y
				i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then rz=false end end)
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if rz and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
				PANEL_W=math.clamp(rzW+(i.Position.X-rzS.X),MF_MIN_W,MF_MAX_W)
				PANEL_H=math.clamp(rzH+(i.Position.Y-rzS.Y),MF_MIN_H,MF_MAX_H)
				MF.Size=UDim2.new(0,PANEL_W,0,PANEL_H)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then rz=false end
		end)
	end

	-- ── TITLE BAR ────────────────────────────────
	local TitleBar = Instance.new("Frame", MF)
	TitleBar.Size = UDim2.new(1, 0, 0, 42)
	TitleBar.BackgroundColor3 = T.TopBar
	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)
	local tbFix = Instance.new("Frame", TitleBar)
	tbFix.Size = UDim2.new(1, 0, 0.5, 0)
	tbFix.Position = UDim2.new(0, 0, 0.5, 0)
	tbFix.BackgroundColor3 = T.TopBar
	tbFix.BorderSizePixel = 0
	local tbSep = Instance.new("Frame", TitleBar)
	tbSep.Size = UDim2.new(1, -20, 0, 1)
	tbSep.Position = UDim2.new(0, 10, 1, -1)
	tbSep.BackgroundColor3 = T.Stroke
	tbSep.BorderSizePixel = 0

	local LogoMark = Instance.new("TextLabel", TitleBar)
	LogoMark.Size = UDim2.new(0, 28, 1, 0)
	LogoMark.Position = UDim2.new(0, 10, 0, 0)
	LogoMark.BackgroundTransparency = 1
	LogoMark.Text = "◈"
	LogoMark.TextColor3 = T.Blue
	LogoMark.Font = Enum.Font.GothamBlack
	LogoMark.TextSize = 20

	local TitleLbl = Instance.new("TextLabel", TitleBar)
	TitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
	TitleLbl.Position = UDim2.new(0, 42, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = "DARK HUB"
	TitleLbl.TextColor3 = T.Text
	TitleLbl.Font = Enum.Font.GothamBlack
	TitleLbl.TextSize = 14
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local VerBadge = Instance.new("Frame", TitleBar)
	VerBadge.Size = UDim2.new(0, 46, 0, 20)
	VerBadge.AnchorPoint = Vector2.new(1, 0.5)
	VerBadge.Position = UDim2.new(1, -68, 0.5, 0)
	VerBadge.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
	Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", VerBadge).Color = T.Stroke
	local VerLbl = Instance.new("TextLabel", VerBadge)
	VerLbl.Size = UDim2.new(1, 0, 1, 0)
	VerLbl.BackgroundTransparency = 1
	VerLbl.Text = "V3.0"
	VerLbl.TextColor3 = T.Blue
	VerLbl.Font = Enum.Font.GothamBlack
	VerLbl.TextSize = 11

	local MinBtn = Instance.new("TextButton", TitleBar)
	MinBtn.Size = UDim2.new(0, 24, 0, 24)
	MinBtn.Position = UDim2.new(1, -54, 0.5, -12)
	MinBtn.Text = "—"
	MinBtn.TextColor3 = T.TextDim
	MinBtn.Font = Enum.Font.GothamBlack
	MinBtn.TextSize = 13
	MinBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 38)
	MinBtn.AutoButtonColor = false
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", MinBtn).Color = T.Stroke

	local CloseBtn = Instance.new("TextButton", TitleBar)
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Color3.fromRGB(220, 80, 80)
	CloseBtn.Font = Enum.Font.GothamBlack
	CloseBtn.TextSize = 19
	CloseBtn.BackgroundColor3 = Color3.fromRGB(38, 10, 15)
	CloseBtn.AutoButtonColor = false
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", CloseBtn).Color = Color3.fromRGB(70, 20, 30)

	-- Drag title bar
	do
		local dragging = false
		local dragStart, startPos
		TitleBar.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = true; dragStart = inp.Position; startPos = MF.Position
				inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
			or inp.UserInputType == Enum.UserInputType.Touch) then
				local delta = inp.Position - dragStart
				MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end)
	end

	-- ================================================================
	-- SIDEBAR
	-- ================================================================
	local Sidebar = Instance.new("Frame", MF)
	Sidebar.Position = UDim2.new(0, 0, 0, 42)
	Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -42)
	Sidebar.BackgroundColor3 = T.Sidebar
	Sidebar.BorderSizePixel = 0
	local sbSep = Instance.new("Frame", Sidebar)
	sbSep.Size = UDim2.new(0, 1, 1, 0)
	sbSep.Position = UDim2.new(1, -1, 0, 0)
	sbSep.BackgroundColor3 = T.Stroke
	sbSep.BorderSizePixel = 0

	local SidebarTitle = Instance.new("TextLabel", Sidebar)
	SidebarTitle.Size = UDim2.new(1, -16, 0, 22)
	SidebarTitle.Position = UDim2.new(0, 12, 0, 8)
	SidebarTitle.BackgroundTransparency = 1
	SidebarTitle.Text = "MENU"
	SidebarTitle.TextColor3 = T.Blue
	SidebarTitle.Font = Enum.Font.GothamBlack
	SidebarTitle.TextSize = 10
	SidebarTitle.TextXAlignment = Enum.TextXAlignment.Left

	local SidebarList = Instance.new("Frame", Sidebar)
	SidebarList.Position = UDim2.new(0, 6, 0, 34)
	SidebarList.Size = UDim2.new(1, -12, 1, -86)
	SidebarList.BackgroundTransparency = 1
	local sbLay = Instance.new("UIListLayout", SidebarList)
	sbLay.Padding = UDim.new(0, 4)
	sbLay.SortOrder = Enum.SortOrder.LayoutOrder

	local function makeTab(lbl, order)
		local tb = Instance.new("TextButton", SidebarList)
		tb.Size = UDim2.new(1, 0, 0, 30)
		tb.BackgroundColor3 = Color3.fromRGB(16, 22, 40)
		tb.Text = ""
		tb.AutoButtonColor = false
		tb.LayoutOrder = order
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
		local tbStr = Instance.new("UIStroke", tb)
		tbStr.Color = Color3.fromRGB(35, 55, 100)
		tbStr.Thickness = 1

		local dot = Instance.new("Frame", tb)
		dot.Size = UDim2.new(0, 6, 0, 6)
		dot.Position = UDim2.new(0, 10, 0.5, -3)
		dot.BackgroundColor3 = Color3.fromRGB(70, 95, 150)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local lblBtn = Instance.new("TextLabel", tb)
		lblBtn.Size = UDim2.new(1, -26, 1, 0)
		lblBtn.Position = UDim2.new(0, 24, 0, 0)
		lblBtn.BackgroundTransparency = 1
		lblBtn.Text = lbl
		lblBtn.TextColor3 = Color3.fromRGB(160, 180, 220)
		lblBtn.Font = Enum.Font.GothamBlack
		lblBtn.TextSize = 12
		lblBtn.TextXAlignment = Enum.TextXAlignment.Left
		tb._dot = dot
		tb._lbl = lblBtn
		return tb
	end

	local BtnWar = makeTab("MAIN", 1)
	local BtnVisual = makeTab("VISUAL", 2)
	local BtnAim = makeTab("AIM", 3)
	local BtnFarm = makeTab("FARM", 4)
	local BtnTP = makeTab("TP", 5)
	local BtnInfo = makeTab("INFO", 6)
	local BtnConfig = makeTab("CFG", 7)
	local BtnVehicle = makeTab("VEHICLE", 8)

	local allTabs = {BtnWar, BtnVisual, BtnAim, BtnFarm, BtnTP, BtnInfo, BtnConfig, BtnVehicle}

	local function setActiveTab(btn)
		for _, b in ipairs(allTabs) do
			b.BackgroundColor3 = Color3.fromRGB(16, 22, 40)
			b._lbl.TextColor3 = Color3.fromRGB(160, 180, 220)
			b._dot.BackgroundColor3 = Color3.fromRGB(70, 95, 150)
			local st = b:FindFirstChildOfClass("UIStroke")
			if st then st.Color = Color3.fromRGB(35, 55, 100) end
		end
		btn.BackgroundColor3 = Color3.fromRGB(30, 60, 130)
		btn._lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn._dot.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
		local st = btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = Color3.fromRGB(80, 150, 255) end
	end
	setActiveTab(BtnWar)

	-- User panel
	local UserPanel = Instance.new("Frame", Sidebar)
	UserPanel.AnchorPoint = Vector2.new(0, 1)
	UserPanel.Position = UDim2.new(0, 6, 1, -6)
	UserPanel.Size = UDim2.new(1, -12, 0, 48)
	UserPanel.BackgroundColor3 = Color3.fromRGB(16, 22, 40)
	Instance.new("UICorner", UserPanel).CornerRadius = UDim.new(0, 8)
	local upStr = Instance.new("UIStroke", UserPanel)
	upStr.Color = Color3.fromRGB(35, 55, 100)

	local Avatar = Instance.new("Frame", UserPanel)
	Avatar.Size = UDim2.new(0, 30, 0, 30)
	Avatar.Position = UDim2.new(0, 6, 0.5, -15)
	Avatar.BackgroundColor3 = Color3.fromRGB(30, 60, 130)
	Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", Avatar).Color = T.BlueDim
	local avLbl = Instance.new("TextLabel", Avatar)
	avLbl.Size = UDim2.new(1, 0, 1, 0)
	avLbl.BackgroundTransparency = 1
	avLbl.Text = "D"
	avLbl.TextColor3 = T.Blue
	avLbl.Font = Enum.Font.GothamBlack
	avLbl.TextSize = 14

	local unameLbl = Instance.new("TextLabel", UserPanel)
	unameLbl.Size = UDim2.new(1, -46, 0, 14)
	unameLbl.Position = UDim2.new(0, 40, 0, 8)
	unameLbl.BackgroundTransparency = 1
	unameLbl.Text = "User"
	unameLbl.TextColor3 = T.Text
	unameLbl.Font = Enum.Font.GothamBlack
	unameLbl.TextSize = 11
	unameLbl.TextXAlignment = Enum.TextXAlignment.Left

	local ustatLbl = Instance.new("TextLabel", UserPanel)
	ustatLbl.Size = UDim2.new(1, -46, 0, 12)
	ustatLbl.Position = UDim2.new(0, 40, 0, 24)
	ustatLbl.BackgroundTransparency = 1
	ustatLbl.Text = "● Connected"
	ustatLbl.TextColor3 = Color3.fromRGB(0, 200, 100)
	ustatLbl.Font = Enum.Font.Gotham
	ustatLbl.TextSize = 10
	ustatLbl.TextXAlignment = Enum.TextXAlignment.Left

	local plr = Players.LocalPlayer
	if plr then
		unameLbl.Text = plr.DisplayName or plr.Name
		avLbl.Text = string.sub(plr.Name, 1, 1):upper()
	end

	-- ================================================================
	-- PAGES
	-- ================================================================
	local CONTENT_X = SIDEBAR_W + 8
	local CONTENT_Y = 48

	local function makePage()
		local pg = Instance.new("ScrollingFrame", MF)
		pg.Position = UDim2.new(0, CONTENT_X, 0, CONTENT_Y)
		pg.Size = UDim2.new(1, -(SIDEBAR_W + 16), 1, -(CONTENT_Y + 8))
		pg.BackgroundTransparency = 1
		pg.ScrollBarThickness = 3
		pg.ScrollBarImageColor3 = T.BlueDim
		pg.Visible = false
		pg.CanvasSize = UDim2.new(0, 0, 0, 0)
		local layout = Instance.new("UIListLayout", pg)
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)
		return pg
	end

	local PageWar = makePage(); PageWar.Visible = true
	local PageVisual = makePage()
	local PageAim = makePage()
	local PageFarm = makePage()
	local PageTP = makePage()
	local PageInfo = makePage()
	local PageConfig = makePage()
	local PageVehicle = makePage()

	local function addPageHeader(page, title, subtitle)
		local hdr = Instance.new("Frame", page)
		hdr.Size = UDim2.new(1, 0, 0, 44)
		hdr.BackgroundColor3 = T.Card
		hdr.LayoutOrder = -100
		Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", hdr).Color = T.Stroke

		local bar = Instance.new("Frame", hdr)
		bar.Size = UDim2.new(0, 3, 0, 26)
		bar.Position = UDim2.new(0, 8, 0.5, -13)
		bar.BackgroundColor3 = T.Blue
		bar.BorderSizePixel = 0
		Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

		local tLbl = Instance.new("TextLabel", hdr)
		tLbl.Size = UDim2.new(1, -32, 0, 18)
		tLbl.Position = UDim2.new(0, 20, 0, 6)
		tLbl.BackgroundTransparency = 1
		tLbl.Text = title
		tLbl.TextColor3 = T.Text
		tLbl.Font = Enum.Font.GothamBlack
		tLbl.TextSize = 14
		tLbl.TextXAlignment = Enum.TextXAlignment.Left

		local sLbl = Instance.new("TextLabel", hdr)
		sLbl.Size = UDim2.new(1, -32, 0, 14)
		sLbl.Position = UDim2.new(0, 20, 0, 24)
		sLbl.BackgroundTransparency = 1
		sLbl.Text = subtitle
		sLbl.TextColor3 = T.TextDim
		sLbl.Font = Enum.Font.Gotham
		sLbl.TextSize = 11
		sLbl.TextXAlignment = Enum.TextXAlignment.Left
	end

	addPageHeader(PageWar,    "Main Settings",     "Core gameplay & utility tools")
	addPageHeader(PageVisual, "Visual Settings",   "ESP · Tracer · Spectate")
	addPageHeader(PageAim,    "Aim Settings",      "Aimbot · Silent aim · FOV")
	addPageHeader(PageFarm,   "Farm Settings",     "Auto cook · Auto buy · Auto farm")
	addPageHeader(PageTP,     "Teleport",          "Location & player teleport")
	addPageHeader(PageInfo,   "Info & Contact",    "About DARK HUB")
	addPageHeader(PageConfig, "Configuration",     "Save · Load · Manage configs")
	addPageHeader(PageVehicle, "Vehicle",          "Fly & vehicle teleport")

	-- Running state
	local Running = true
	local tpBusy = false
	local tpCancelled = false
	local tpActive = false
	local _htpo = {fn=function()end}
	local function hideTPOverlay() _htpo.fn() end
	local _overlayActive = false

	-- Flags
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
	local ShowAimFOV    = true
	local ShowSilentFOV = true
	local SilentMode = "PC"

	-- Vehicle TP helper
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

	-- Page switch
	local function switchPage(btn, page)
		for _, p in ipairs({PageWar,PageVisual,PageAim,PageFarm,PageTP,PageInfo,PageConfig,PageVehicle}) do
			p.Visible = false
		end
		page.Visible = true
		setActiveTab(btn)
	end
	BtnWar.MouseButton1Click:Connect(function() switchPage(BtnWar, PageWar) end)
	BtnVisual.MouseButton1Click:Connect(function() switchPage(BtnVisual, PageVisual) end)
	BtnAim.MouseButton1Click:Connect(function() switchPage(BtnAim, PageAim) end)
	BtnFarm.MouseButton1Click:Connect(function() switchPage(BtnFarm, PageFarm) end)
	BtnTP.MouseButton1Click:Connect(function() switchPage(BtnTP, PageTP) end)
	BtnInfo.MouseButton1Click:Connect(function() switchPage(BtnInfo, PageInfo) end)
	BtnConfig.MouseButton1Click:Connect(function() switchPage(BtnConfig, PageConfig) end)
	BtnVehicle.MouseButton1Click:Connect(function() switchPage(BtnVehicle, PageVehicle) end)

	-- Minimize / Restore
	MinBtn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(MF, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0)})
		t:Play(); t.Completed:Wait(); MF.Visible=false; LogoBtn.Visible=true
		TweenService:Create(LogoBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(0,48,0,48)}):Play()
	end)
	LogoBtn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(LogoBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0)})
		t:Play(); t.Completed:Wait(); LogoBtn.Visible=false; MF.Visible=true
		TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(0,PANEL_W,0,PANEL_H)}):Play()
	end)

	-- ================================================================
	-- ESP
	-- ================================================================
	local ESP = {}
	local FovCircle = Drawing.new("Circle")
	FovCircle.Thickness=1.5; FovCircle.Color=T.Blue; FovCircle.Filled=false; FovCircle.NumSides=64; FovCircle.Visible=false

	local SilentFovCircle = Drawing.new("Circle")
	SilentFovCircle.Thickness = 1.5; SilentFovCircle.Color = Color3.fromRGB(255, 100, 0)
	SilentFovCircle.Filled = false; SilentFovCircle.NumSides = 64; SilentFovCircle.Visible = false

	local SilentLine = Drawing.new("Line")
	SilentLine.Thickness = 1.5; SilentLine.Color = Color3.fromRGB(255, 100, 0)
	SilentLine.Transparency = 1; SilentLine.Visible = false

	local function removeESP(p)
		if not ESP[p] then return end
		local _e=ESP[p]
		if _e.corners then for _,c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
		if _e.skeleton then for _,s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
		for k,d in pairs(_e) do if k~="corners" and k~="skeleton" then pcall(function() d:Remove() end) end end
		ESP[p]=nil
	end

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
			corners = _c, skeleton= _sk,
		}
		e.box.Thickness=1.5; e.box.Filled=false
		e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
		e.hpbar.Thickness=1; e.hpbar.Filled=true
		ESP[p] = e
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Running = false
		for p in pairs(ESP) do removeESP(p) end
		FovCircle:Remove(); SilentFovCircle:Remove(); SilentLine:Remove()
		Gui:Destroy()
	end)

	-- Toggle labels
	local TOGGLE_LABELS = {
		BoxESP="Box ESP", Tracer="Tracer",
		TPNoClip="Blink TP", AimLock="Auto Aim",
		WallCheck="Wall Check",
		InvScan="Inv Scan", InstantInteract="Instant Interact",
		InfStamina="Inf Stamina", HybridSpeed="Speed Hack", AuraKill="NoClip",
	}

	local function AddToggleBar(parent, flagName, accentColor)
		local ACCENT = accentColor or T.Blue
		local isOn = Flags[flagName]
		local bar = Instance.new("TextButton", parent)
		bar.Name = "DARKHUB_TOGGLE_"..flagName
		bar.Size = UDim2.new(1, 0, 0, 36)
		bar.BackgroundColor3 = isOn and Color3.fromRGB(18, 28, 55) or T.Card
		bar.Text = ""
		bar.AutoButtonColor = false
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
		local bStr = Instance.new("UIStroke", bar)
		bStr.Color = isOn and T.StrokeOn or T.Stroke
		bStr.Thickness = 1

		local dot = Instance.new("Frame", bar)
		dot.Size = UDim2.new(0, 5, 0, 5)
		dot.Position = UDim2.new(0, 12, 0.5, -2.5)
		dot.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(60, 80, 130)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local nameLbl = Instance.new("TextLabel", bar)
		nameLbl.Size = UDim2.new(1, -76, 1, 0)
		nameLbl.Position = UDim2.new(0, 24, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = TOGGLE_LABELS[flagName] or flagName
		nameLbl.TextColor3 = isOn and T.Text or T.TextDim
		nameLbl.Font = Enum.Font.GothamBlack
		nameLbl.TextSize = 13
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local statusPill = Instance.new("Frame", bar)
		statusPill.Size = UDim2.new(0, 46, 0, 22)
		statusPill.Position = UDim2.new(1, -52, 0.5, -11)
		statusPill.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(20, 28, 48)
		Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
		if not isOn then Instance.new("UIStroke", statusPill).Color = T.Stroke end

		local statusLbl = Instance.new("TextLabel", statusPill)
		statusLbl.Size = UDim2.new(1, 0, 1, 0)
		statusLbl.BackgroundTransparency = 1
		statusLbl.Text = isOn and "ON" or "OFF"
		statusLbl.TextColor3 = isOn and Color3.fromRGB(0, 0, 0) or T.TextDim
		statusLbl.Font = Enum.Font.GothamBlack
		statusLbl.TextSize = 12

		local function refresh()
			local on = Flags[flagName]
			bar.BackgroundColor3 = on and Color3.fromRGB(18, 28, 55) or T.Card
			bStr.Color = on and T.StrokeOn or T.Stroke
			dot.BackgroundColor3 = on and ACCENT or Color3.fromRGB(60, 80, 130)
			nameLbl.TextColor3 = on and T.Text or T.TextDim
			statusPill.BackgroundColor3 = on and ACCENT or Color3.fromRGB(20, 28, 48)
			statusLbl.Text = on and "ON" or "OFF"
			statusLbl.TextColor3 = on and Color3.fromRGB(0, 0, 0) or T.TextDim
			local st = statusPill:FindFirstChildOfClass("UIStroke")
			if on then if st then st:Destroy() end
			else if not st then Instance.new("UIStroke", statusPill).Color = T.Stroke end end
		end

		bar.MouseButton1Click:Connect(function()
			Flags[flagName] = not Flags[flagName]; refresh()
		end)
		return bar
	end

	local function AddSlider(parent, label, minV, maxV, defV, suffix, onChange)
		local c = Instance.new("Frame", parent)
		c.Size = UDim2.new(1, 0, 0, 50)
		c.BackgroundColor3 = T.Card
		Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", c).Color = T.Stroke

		local lbl = Instance.new("TextLabel", c)
		lbl.Size = UDim2.new(1, -12, 0, 18)
		lbl.Position = UDim2.new(0, 10, 0, 6)
		lbl.BackgroundTransparency=1
		lbl.TextXAlignment=Enum.TextXAlignment.Left
		lbl.Font=Enum.Font.Gotham
		lbl.TextSize=13
		lbl.TextColor3=T.Text
		lbl.Text=label..": "..defV..suffix

		local track = Instance.new("Frame", c)
		track.Size = UDim2.new(1, -20, 0, 4)
		track.Position = UDim2.new(0, 10, 0, 34)
		track.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", track).Color = T.Stroke

		local fill = Instance.new("Frame", track)
		fill.Size = UDim2.new((defV-minV)/(maxV-minV), 0, 1, 0)
		fill.BackgroundColor3 = T.Blue
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame", track)
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.Position = UDim2.new((defV-minV)/(maxV-minV), -7, 0.5, -7)
		knob.BackgroundColor3 = T.Blue
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", knob).Color = T.Stroke

		local dragging = false
		local function update(inputPos)
			local rel = math.clamp((inputPos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local val = math.floor(minV + rel*(maxV-minV))
			fill.Size = UDim2.new(rel, 0, 1, 0)
			knob.Position = UDim2.new(rel, -6, 0.5, -6)
			lbl.Text = label..": "..val..suffix
			onChange(val)
		end
		track.InputBegan:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
				dragging=true; update(inp.Position)
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
				update(inp.Position)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
				dragging=false
			end
		end)
		return c
	end

	-- ================================================================
	-- BUILD MAIN PAGE
	-- ================================================================
	local function buildMain()
		-- Section: Quick Toggles
		local secLbl = Instance.new("TextLabel", PageWar)
		secLbl.Size = UDim2.new(1, 0, 0, 18)
		secLbl.BackgroundTransparency = 1
		secLbl.Text = "⚡ QUICK TOGGLES"
		secLbl.TextColor3 = T.Blue
		secLbl.Font = Enum.Font.GothamBlack
		secLbl.TextSize = 11
		secLbl.TextXAlignment = Enum.TextXAlignment.Left
		secLbl.LayoutOrder = 1

		local MAIN_TOGGLES = {"AuraKill","InfStamina","HybridSpeed","InstantInteract","InvScan","TPNoClip"}
		for i, f in ipairs(MAIN_TOGGLES) do
			local b = AddToggleBar(PageWar, f, T.Blue)
			b.LayoutOrder = 10 + i
			if f == "TPNoClip" then
				local mp2=Instance.new("TextButton",b)
				mp2.Size=UDim2.new(0,38,0,22)
				mp2.Position=UDim2.new(1,-102,0.5,-11)
				mp2.BackgroundColor3=Color3.fromRGB(20,28,48)
				mp2.Text=BlinkMode
				mp2.TextColor3=T.Blue
				mp2.Font=Enum.Font.GothamBlack
				mp2.TextSize=12
				mp2.AutoButtonColor=false
				mp2.ZIndex=2
				Instance.new("UICorner",mp2).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp2).Color=T.StrokeOn
				mp2.MouseButton1Click:Connect(function()
					BlinkMode = BlinkMode=="PC" and "HP" or "PC"
					mp2.Text = BlinkMode
				end)
			end
		end

		-- Info Card
		local infoCard = Instance.new("Frame", PageWar)
		infoCard.Size = UDim2.new(1, 0, 0, 70)
		infoCard.BackgroundColor3 = Color3.fromRGB(12, 18, 35)
		infoCard.LayoutOrder = 90
		Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", infoCard).Color = Color3.fromRGB(40, 70, 140)

		local icIcon = Instance.new("TextLabel", infoCard)
		icIcon.Size = UDim2.new(0, 40, 0, 40)
		icIcon.Position = UDim2.new(0, 12, 0.5, -20)
		icIcon.BackgroundColor3 = Color3.fromRGB(20, 35, 70)
		icIcon.Text = "◈"
		icIcon.TextColor3 = T.Blue
		icIcon.Font = Enum.Font.GothamBlack
		icIcon.TextSize = 22
		Instance.new("UICorner", icIcon).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", icIcon).Color = Color3.fromRGB(60, 100, 200)

		local icTitle = Instance.new("TextLabel", infoCard)
		icTitle.Size = UDim2.new(1, -70, 0, 20)
		icTitle.Position = UDim2.new(0, 62, 0, 14)
		icTitle.BackgroundTransparency = 1
		icTitle.Text = "DARK HUB V3.0"
		icTitle.TextColor3 = T.Text
		icTitle.Font = Enum.Font.GothamBlack
		icTitle.TextSize = 14
		icTitle.TextXAlignment = Enum.TextXAlignment.Left

		local icSub = Instance.new("TextLabel", infoCard)
		icSub.Size = UDim2.new(1, -70, 0, 16)
		icSub.Position = UDim2.new(0, 62, 0, 34)
		icSub.BackgroundTransparency = 1
		icSub.Text = "Select a tab from sidebar to configure"
		icSub.TextColor3 = T.TextDim
		icSub.Font = Enum.Font.Gotham
		icSub.TextSize = 11
		icSub.TextXAlignment = Enum.TextXAlignment.Left

		-- Fake Name Card
		local fnCard = Instance.new("TextButton", PageWar)
		fnCard.Size = UDim2.new(1, 0, 0, 120)
		fnCard.BackgroundColor3 = T.Card
		fnCard.Text = ""
		fnCard.AutoButtonColor = false
		fnCard.LayoutOrder = 100
		Instance.new("UICorner", fnCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", fnCard).Color = T.Stroke

		local fnDot = Instance.new("Frame", fnCard)
		fnDot.Size = UDim2.new(0, 5, 0, 5)
		fnDot.Position = UDim2.new(0, 12, 0, 12)
		fnDot.BackgroundColor3 = T.Blue
		Instance.new("UICorner", fnDot).CornerRadius = UDim.new(1, 0)

		local fnTitle = Instance.new("TextLabel", fnCard)
		fnTitle.Size = UDim2.new(1, -80, 0, 18)
		fnTitle.Position = UDim2.new(0, 24, 0, 4)
		fnTitle.BackgroundTransparency = 1
		fnTitle.Text = "Fake Name"
		fnTitle.TextColor3 = T.Text
		fnTitle.Font = Enum.Font.GothamBlack
		fnTitle.TextSize = 13
		fnTitle.TextXAlignment = Enum.TextXAlignment.Left

		local fnSub = Instance.new("TextLabel", fnCard)
		fnSub.Size = UDim2.new(1, -80, 0, 14)
		fnSub.Position = UDim2.new(0, 24, 0, 22)
		fnSub.BackgroundTransparency = 1
		fnSub.Text = "Ganti nametag in-game"
		fnSub.TextColor3 = T.TextDim
		fnSub.Font = Enum.Font.Gotham
		fnSub.TextSize = 11
		fnSub.TextXAlignment = Enum.TextXAlignment.Left

		local fnInput1 = Instance.new("TextBox", fnCard)
		fnInput1.Size = UDim2.new(0, 130, 0, 24)
		fnInput1.Position = UDim2.new(0, 12, 0, 42)
		fnInput1.BackgroundColor3 = Color3.fromRGB(18, 22, 38)
		fnInput1.PlaceholderText = "In-Game Name..."
		fnInput1.PlaceholderColor3 = T.TextDim
		fnInput1.Text = ""
		fnInput1.TextColor3 = T.Text
		fnInput1.Font = Enum.Font.Gotham
		fnInput1.TextSize = 12
		fnInput1.ClearTextOnFocus = false
		Instance.new("UICorner", fnInput1).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", fnInput1).Color = T.Stroke

		local fnInput2 = Instance.new("TextBox", fnCard)
		fnInput2.Size = UDim2.new(0, 130, 0, 24)
		fnInput2.Position = UDim2.new(0, 12, 0, 72)
		fnInput2.BackgroundColor3 = Color3.fromRGB(18, 22, 38)
		fnInput2.PlaceholderText = "Username..."
		fnInput2.PlaceholderColor3 = T.TextDim
		fnInput2.Text = ""
		fnInput2.TextColor3 = T.Text
		fnInput2.Font = Enum.Font.Gotham
		fnInput2.TextSize = 12
		fnInput2.ClearTextOnFocus = false
		Instance.new("UICorner", fnInput2).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", fnInput2).Color = T.Stroke

		local fnApply = Instance.new("TextButton", fnCard)
		fnApply.Size = UDim2.new(0, 80, 0, 54)
		fnApply.Position = UDim2.new(1, -92, 0, 42)
		fnApply.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
		fnApply.Text = "APPLY"
		fnApply.TextColor3 = T.Blue
		fnApply.Font = Enum.Font.GothamBlack
		fnApply.TextSize = 12
		fnApply.AutoButtonColor = false
		Instance.new("UICorner", fnApply).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", fnApply).Color = T.StrokeOn

		local fnStatus = Instance.new("TextLabel", fnCard)
		fnStatus.Size = UDim2.new(1, -100, 0, 14)
		fnStatus.Position = UDim2.new(0, 12, 0, 100)
		fnStatus.BackgroundTransparency = 1
		fnStatus.Text = ""
		fnStatus.TextColor3 = T.Green
		fnStatus.Font = Enum.Font.GothamBlack
		fnStatus.TextSize = 11
		fnStatus.TextXAlignment = Enum.TextXAlignment.Left

		fnApply.MouseButton1Click:Connect(function()
			local ok = false
			pcall(function()
				local char = plr.Character
				local myChar = (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(plr.Name)) or char
				if not myChar then return end
				if fnInput1.Text ~= "" then
					local tag1 = myChar.Head:FindFirstChild("NameTag")
					if tag1 then
						local lbl = tag1:FindFirstChild("MainFrame") and tag1.MainFrame:FindFirstChild("NameLabel")
						if lbl then
							lbl.Text = fnInput1.Text
							lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
							lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							lbl.TextStrokeTransparency = 0.5
							ok = true
						end
					end
				end
				if fnInput2.Text ~= "" then
					local tag2 = myChar.Head:FindFirstChild("RankTag")
					if tag2 then
						local lbl = tag2:FindFirstChild("MainFrame") and tag2.MainFrame:FindFirstChild("NameLabel")
						if lbl then
							lbl.Text = fnInput2.Text
							lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
							lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
							lbl.TextStrokeTransparency = 0.5
							ok = true
						end
					end
				end
			end)
			if ok then
				fnStatus.Text = "✓ Applied!"
				fnStatus.TextColor3 = T.Green
				fnApply.BackgroundColor3 = Color3.fromRGB(0, 60, 20)
				task.delay(0.4, function() fnApply.BackgroundColor3 = Color3.fromRGB(20, 40, 80) end)
			else
				fnStatus.Text = "✗ Tag not found"
				fnStatus.TextColor3 = T.Red
			end
			task.delay(3, function() fnStatus.Text = "" end)
		end)

		-- Reduce Grafik
		local rgBar = Instance.new("TextButton", PageWar)
		rgBar.Size = UDim2.new(1, 0, 0, 54)
		rgBar.BackgroundColor3 = Color3.fromRGB(38, 10, 15)
		rgBar.Text = ""
		rgBar.AutoButtonColor = false
		rgBar.LayoutOrder = 110
		Instance.new("UICorner", rgBar).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", rgBar).Color = Color3.fromRGB(100, 25, 35)

		local rgName = Instance.new("TextLabel", rgBar)
		rgName.Size=UDim2.new(1,-76,0,20)
		rgName.Position=UDim2.new(0,24,0,6)
		rgName.BackgroundTransparency=1
		rgName.Text="⚠ Reduce Grafik"
		rgName.TextColor3=T.Red
		rgName.Font=Enum.Font.GothamBlack
		rgName.TextSize=14
		rgName.TextXAlignment=Enum.TextXAlignment.Left

		local rgWarn = Instance.new("TextLabel", rgBar)
		rgWarn.Size=UDim2.new(1,-76,0,16)
		rgWarn.Position=UDim2.new(0,24,0,28)
		rgWarn.BackgroundTransparency=1
		rgWarn.Text="Perlu rejoin untuk restore"
		rgWarn.TextColor3=Color3.fromRGB(160,60,60)
		rgWarn.Font=Enum.Font.Gotham
		rgWarn.TextSize=11
		rgWarn.TextXAlignment=Enum.TextXAlignment.Left

		local rgPill = Instance.new("Frame", rgBar)
		rgPill.Size=UDim2.new(0,46,0,22)
		rgPill.Position=UDim2.new(1,-52,0.5,-11)
		rgPill.BackgroundColor3=Color3.fromRGB(60,15,20)
		Instance.new("UICorner",rgPill).CornerRadius=UDim.new(1,0)
		Instance.new("UIStroke",rgPill).Color=Color3.fromRGB(100,25,35)
		local rgPillLbl=Instance.new("TextLabel",rgPill)
		rgPillLbl.Size=UDim2.new(1,0,1,0)
		rgPillLbl.BackgroundTransparency=1
		rgPillLbl.Text="OFF"
		rgPillLbl.TextColor3=Color3.fromRGB(180,80,80)
		rgPillLbl.Font=Enum.Font.GothamBlack
		rgPillLbl.TextSize=12

		local rgActive = false
		rgBar.MouseButton1Click:Connect(function()
			if rgActive then return end
			rgActive = true
			rgPill.BackgroundColor3=Color3.fromRGB(180,30,30)
			rgPillLbl.Text="ON"
			rgPillLbl.TextColor3=Color3.fromRGB(255,255,255)
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
				for _, v in ipairs(workspace:GetDescendants()) do
					pcall(function()
						if v:IsA("BasePart") then
							if not (localChar and v:IsDescendantOf(localChar)) then
								v.Material = Enum.Material.SmoothPlastic
								v.Reflectance = 0
							end
						end
						if v:IsA("Texture") or v:IsA("Decal") then
							if not (localChar and v:IsDescendantOf(localChar)) then
								v.Transparency = 1
							end
						end
					end)
				end
				pcall(function()
					local terrain = workspace:FindFirstChild("Terrain")
					if terrain then
						terrain.WaterWaveSize = 0
						terrain.WaterWaveSpeed = 0
						terrain.WaterReflectance = 0
						terrain.WaterTransparency = 1
					end
				end)
				pcall(function()
					settings().Rendering.QualityLevel = 1
					settings().Rendering.TextureQuality = Enum.TextureQuality.Low
				end)
			end)
		end)
	end

	-- ================================================================
	-- BUILD VISUAL PAGE
	-- ================================================================
	local function buildVisual()
		local VISUAL_ORDER = {"BoxESP","Tracer","ESPName","ESPDist","ESPHPBar","ESPWeapon","ESPSkeleton","ESPMasak"}
		TOGGLE_LABELS.ESPName="Name"
		TOGGLE_LABELS.ESPDist="Distance"
		TOGGLE_LABELS.ESPHPBar="HP Bar"
		TOGGLE_LABELS.ESPWeapon="GUN"
		TOGGLE_LABELS.ESPSkeleton="Skeleton"
		TOGGLE_LABELS.ESPMasak="Masak"

		for i, flag in ipairs(VISUAL_ORDER) do
			local b = AddToggleBar(PageVisual, flag)
			b.LayoutOrder = i
			if flag=="BoxESP" then
				local modes={"FULL","CORNER"}
				local mp=Instance.new("TextButton",b)
				mp.Size=UDim2.new(0,52,0,22)
				mp.Position=UDim2.new(1,-108,0.5,-11)
				mp.BackgroundColor3=Color3.fromRGB(20,28,48)
				mp.Text=BoxESPMode
				mp.TextColor3=T.Blue
				mp.Font=Enum.Font.GothamBlack
				mp.TextSize=11
				mp.AutoButtonColor=false
				mp.ZIndex=2
				Instance.new("UICorner",mp).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp).Color=T.StrokeOn
				mp.MouseButton1Click:Connect(function()
					local idx=1
					for i2,m in ipairs(modes) do if m==BoxESPMode then idx=i2 break end end
					BoxESPMode=modes[(idx%#modes)+1]
					mp.Text=BoxESPMode
				end)
			end
		end

		local s1 = AddSlider(PageVisual, "Tracer Distance", 50, 1000, TracerMaxDist, " studs", function(v) TracerMaxDist = v end)
		s1.LayoutOrder = 99
		local s2 = AddSlider(PageVisual, "ESP Distance", 10, 5000, ESPMaxDist, " studs", function(v) ESPMaxDist = v end)
		s2.LayoutOrder = 100
	end

	-- ================================================================
	-- BUILD AIM PAGE
	-- ================================================================
	local function buildAim()
		-- Auto Aim toggle
		local flagName = "AimLock"
		local isOn = Flags[flagName]
		local bar = Instance.new("TextButton", PageAim)
		bar.Size = UDim2.new(1, 0, 0, 36)
		bar.BackgroundColor3 = isOn and Color3.fromRGB(18, 28, 55) or T.Card
		bar.Text = ""
		bar.AutoButtonColor = false
		bar.LayoutOrder = 1
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
		local bStr = Instance.new("UIStroke", bar)
		bStr.Color = isOn and T.StrokeOn or T.Stroke

		local nameLbl = Instance.new("TextLabel", bar)
		nameLbl.Size = UDim2.new(1,-190,1,0)
		nameLbl.Position = UDim2.new(0,24,0,0)
		nameLbl.BackgroundTransparency=1
		nameLbl.Text="Auto Aim"
		nameLbl.TextColor3 = isOn and T.Text or T.TextDim
		nameLbl.Font=Enum.Font.GothamBlack
		nameLbl.TextSize=14
		nameLbl.TextXAlignment=Enum.TextXAlignment.Left

		local modeBtn = Instance.new("TextButton", bar)
		modeBtn.Size = UDim2.new(0,38,0,22)
		modeBtn.Position = UDim2.new(1,-148,0.5,-11)
		modeBtn.BackgroundColor3 = Color3.fromRGB(20,28,48)
		modeBtn.Text = AimMode
		modeBtn.TextColor3 = T.Blue
		modeBtn.Font = Enum.Font.GothamBlack
		modeBtn.TextSize = 12
		modeBtn.AutoButtonColor = false
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(1,0)
		Instance.new("UIStroke", modeBtn).Color = T.StrokeOn

		local partBtn = Instance.new("TextButton", bar)
		partBtn.Size = UDim2.new(0,44,0,22)
		partBtn.Position = UDim2.new(1,-98,0.5,-11)
		partBtn.BackgroundColor3 = Color3.fromRGB(20,28,48)
		partBtn.Text = AimPart=="Head" and "HEAD" or "BODY"
		partBtn.TextColor3 = T.Blue
		partBtn.Font = Enum.Font.GothamBlack
		partBtn.TextSize = 12
		partBtn.AutoButtonColor = false
		Instance.new("UICorner", partBtn).CornerRadius = UDim.new(1,0)
		Instance.new("UIStroke", partBtn).Color = T.StrokeOn

		local statusPill = Instance.new("Frame", bar)
		statusPill.Size = UDim2.new(0,46,0,22)
		statusPill.Position = UDim2.new(1,-52,0.5,-11)
		statusPill.BackgroundColor3 = isOn and T.Blue or Color3.fromRGB(20,28,48)
		Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1,0)
		if not isOn then Instance.new("UIStroke", statusPill).Color = T.Stroke end
		local statusLbl = Instance.new("TextLabel", statusPill)
		statusLbl.Size=UDim2.new(1,0,1,0)
		statusLbl.BackgroundTransparency=1
		statusLbl.Text = isOn and "ON" or "OFF"
		statusLbl.TextColor3 = isOn and Color3.fromRGB(0,0,0) or T.TextDim
		statusLbl.Font=Enum.Font.GothamBlack
		statusLbl.TextSize=12

		local function refreshBar()
			local on = Flags[flagName]
			bar.BackgroundColor3 = on and Color3.fromRGB(18,28,55) or T.Card
			bStr.Color = on and T.StrokeOn or T.Stroke
			nameLbl.TextColor3 = on and T.Text or T.TextDim
			statusPill.BackgroundColor3 = on and T.Blue or Color3.fromRGB(20,28,48)
			statusLbl.Text = on and "ON" or "OFF"
			statusLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
		end

		bar.MouseButton1Click:Connect(function()
			Flags[flagName] = not Flags[flagName]; refreshBar()
		end)
		partBtn.MouseButton1Click:Connect(function()
			AimPart = AimPart=="Head" and "Body" or "Head"
			partBtn.Text = AimPart=="Head" and "HEAD" or "BODY"
			AimTarget = nil
		end)
		modeBtn.MouseButton1Click:Connect(function()
			AimMode = AimMode=="PC" and "HP" or "PC"
			modeBtn.Text = AimMode
		end)

		local b = AddToggleBar(PageAim, "WallCheck")
		b.LayoutOrder = 2

		-- Silent Aim
		local saBar = Instance.new("TextButton", PageAim)
		saBar.Size = UDim2.new(1, 0, 0, 36)
		saBar.BackgroundColor3 = T.Card
		saBar.Text = ""
		saBar.AutoButtonColor = false
		saBar.LayoutOrder = 3
		Instance.new("UICorner", saBar).CornerRadius = UDim.new(0, 8)
		local saStr = Instance.new("UIStroke", saBar)
		saStr.Color = T.Stroke

		local saLbl = Instance.new("TextLabel", saBar)
		saLbl.Size = UDim2.new(1, -130, 1, 0)
		saLbl.Position = UDim2.new(0, 24, 0, 0)
		saLbl.BackgroundTransparency = 1
		saLbl.Text = "Silent Aim"
		saLbl.TextColor3 = T.TextDim
		saLbl.Font = Enum.Font.GothamBlack
		saLbl.TextSize = 13
		saLbl.TextXAlignment = Enum.TextXAlignment.Left

		local saPartBtn = Instance.new("TextButton", saBar)
		saPartBtn.Size = UDim2.new(0, 44, 0, 22)
		saPartBtn.Position = UDim2.new(1, -150, 0.5, -11)
		saPartBtn.BackgroundColor3 = Color3.fromRGB(20,28,48)
		saPartBtn.Text = "HEAD"
		saPartBtn.TextColor3 = T.Blue
		saPartBtn.Font = Enum.Font.GothamBlack
		saPartBtn.TextSize = 12
		saPartBtn.AutoButtonColor = false
		Instance.new("UICorner", saPartBtn).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", saPartBtn).Color = T.StrokeOn

		local saModeBtn = Instance.new("TextButton", saBar)
		saModeBtn.Size = UDim2.new(0, 38, 0, 22)
		saModeBtn.Position = UDim2.new(1, -102, 0.5, -11)
		saModeBtn.BackgroundColor3 = Color3.fromRGB(20,28,48)
		saModeBtn.Text = SilentMode
		saModeBtn.TextColor3 = T.Blue
		saModeBtn.Font = Enum.Font.GothamBlack
		saModeBtn.TextSize = 12
		saModeBtn.AutoButtonColor = false
		Instance.new("UICorner", saModeBtn).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", saModeBtn).Color = T.StrokeOn
		saModeBtn.MouseButton1Click:Connect(function()
			SilentMode = SilentMode == "PC" and "HP" or "PC"
			saModeBtn.Text = SilentMode
		end)

		local saPill = Instance.new("Frame", saBar)
		saPill.Size = UDim2.new(0, 46, 0, 22)
		saPill.Position = UDim2.new(1, -52, 0.5, -11)
		saPill.BackgroundColor3 = Color3.fromRGB(20,28,48)
		Instance.new("UICorner", saPill).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", saPill).Color = T.Stroke
		local saPillLbl = Instance.new("TextLabel", saPill)
		saPillLbl.Size = UDim2.new(1, 0, 1, 0)
		saPillLbl.BackgroundTransparency = 1
		saPillLbl.Text = "OFF"
		saPillLbl.TextColor3 = T.TextDim
		saPillLbl.Font = Enum.Font.GothamBlack
		saPillLbl.TextSize = 12

		local saPart = "Head"
		local function refreshSABar()
			local on = SilentAim
			saBar.BackgroundColor3 = on and Color3.fromRGB(18,28,55) or T.Card
			saStr.Color = on and T.StrokeOn or T.Stroke
			saLbl.TextColor3 = on and T.Text or T.TextDim
			saPill.BackgroundColor3 = on and T.Blue or Color3.fromRGB(20,28,48)
			saPillLbl.Text = on and "ON" or "OFF"
			saPillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
		end
		saBar.MouseButton1Click:Connect(function() SilentAim = not SilentAim; refreshSABar() end)
		saPartBtn.MouseButton1Click:Connect(function()
			saPart = saPart == "Head" and "Body" or "Head"
			saPartBtn.Text = saPart == "Head" and "HEAD" or "BODY"
		end)

		-- Wallbang
		local wbBar = Instance.new("TextButton", PageAim)
		wbBar.Size = UDim2.new(1, 0, 0, 36)
		wbBar.BackgroundColor3 = T.Card
		wbBar.Text = ""
		wbBar.AutoButtonColor = false
		wbBar.LayoutOrder = 4
		Instance.new("UICorner", wbBar).CornerRadius = UDim.new(0, 8)
		local wbStr = Instance.new("UIStroke", wbBar)
		wbStr.Color = T.Stroke

		local wbLbl = Instance.new("TextLabel", wbBar)
		wbLbl.Size = UDim2.new(1, -60, 1, 0)
		wbLbl.Position = UDim2.new(0, 24, 0, 0)
		wbLbl.BackgroundTransparency = 1
		wbLbl.Text = "Silent Wallbang"
		wbLbl.TextColor3 = T.TextDim
		wbLbl.Font = Enum.Font.GothamBlack
		wbLbl.TextSize = 13
		wbLbl.TextXAlignment = Enum.TextXAlignment.Left

		local wbPill = Instance.new("Frame", wbBar)
		wbPill.Size = UDim2.new(0, 46, 0, 22)
		wbPill.Position = UDim2.new(1, -52, 0.5, -11)
		wbPill.BackgroundColor3 = Color3.fromRGB(20,28,48)
		Instance.new("UICorner", wbPill).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", wbPill).Color = T.Stroke
		local wbPillLbl = Instance.new("TextLabel", wbPill)
		wbPillLbl.Size = UDim2.new(1, 0, 1, 0)
		wbPillLbl.BackgroundTransparency = 1
		wbPillLbl.Text = "OFF"
		wbPillLbl.TextColor3 = T.TextDim
		wbPillLbl.Font = Enum.Font.GothamBlack
		wbPillLbl.TextSize = 12

		wbBar.MouseButton1Click:Connect(function()
			SilentAimWallbang = not SilentAimWallbang
			local on = SilentAimWallbang
			wbBar.BackgroundColor3 = on and Color3.fromRGB(18,28,55) or T.Card
			wbStr.Color = on and T.StrokeOn or T.Stroke
			wbLbl.TextColor3 = on and T.Text or T.TextDim
			wbPill.BackgroundColor3 = on and T.Blue or Color3.fromRGB(20,28,48)
			wbPillLbl.Text = on and "ON" or "OFF"
			wbPillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
		end)

		-- FOV Sliders
		local s1 = AddSlider(PageAim,"FOV Radius (Aimbot)",30,400,AimFOV_Radius," px",function(v) AimFOV_Radius=v end)
		s1.LayoutOrder = 5
		local s2 = AddSlider(PageAim,"FOV Radius (Silent)",30,400,SilentFOV_Radius," px",function(v) SilentFOV_Radius=v end)
		s2.LayoutOrder = 6
		local s3 = AddSlider(PageAim,"Max Jarak",50,1000,AimMax_Dist," studs",function(v) AimMax_Dist=v end)
		s3.LayoutOrder = 7
		local defSmooth = math.floor(AimSmooth * 100)
		local s4 = AddSlider(PageAim,"Smoothness",1,100,defSmooth,"%",function(v)
			AimSmooth = math.clamp(v / 100, 0.01, 0.99)
		end)
		s4.LayoutOrder = 8

		-- FOV toggles
		local function makeFovToggle(label, layoutOrder, getVal, setVal)
			local row = Instance.new("Frame", PageAim)
			row.Size = UDim2.new(1, 0, 0, 32)
			row.BackgroundColor3 = T.Card
			row.LayoutOrder = layoutOrder
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
			local rowStr = Instance.new("UIStroke", row)
			rowStr.Color = T.Stroke

			local lbl = Instance.new("TextLabel", row)
			lbl.Size = UDim2.new(1, -60, 1, 0)
			lbl.Position = UDim2.new(0, 14, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = label
			lbl.TextColor3 = T.TextDim
			lbl.Font = Enum.Font.GothamBlack
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local pill = Instance.new("Frame", row)
			pill.Size = UDim2.new(0, 44, 0, 22)
			pill.Position = UDim2.new(1, -52, 0.5, -11)
			Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
			local pillLbl = Instance.new("TextLabel", pill)
			pillLbl.Size = UDim2.new(1, 0, 1, 0)
			pillLbl.BackgroundTransparency = 1
			pillLbl.Font = Enum.Font.GothamBlack
			pillLbl.TextSize = 12

			local function refresh()
				local on = getVal()
				pill.BackgroundColor3 = on and T.Blue or Color3.fromRGB(20,28,48)
				pillLbl.Text = on and "ON" or "OFF"
				pillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
				lbl.TextColor3 = on and T.Text or T.TextDim
				row.BackgroundColor3 = on and Color3.fromRGB(18,28,55) or T.Card
				rowStr.Color = on and T.StrokeOn or T.Stroke
			end
			refresh()
			row.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1
				or inp.UserInputType == Enum.UserInputType.Touch then
					setVal(not getVal()); refresh()
				end
			end)
		end
		makeFovToggle("Show FOV (Aimbot)",  9,  function() return ShowAimFOV    end, function(v) ShowAimFOV    = v end)
		makeFovToggle("Show FOV (Silent)",  10, function() return ShowSilentFOV end, function(v) ShowSilentFOV = v end)
	end

	-- ================================================================
	-- BUILD FARM PAGE
	-- ================================================================
	local function buildFarm()
		local lbl = Instance.new("TextLabel", PageFarm)
		lbl.Size = UDim2.new(1, 0, 0, 30)
		lbl.BackgroundColor3 = Color3.fromRGB(12, 18, 35)
		lbl.Text = "Farm features akan ditambahkan di update berikutnya"
		lbl.TextColor3 = T.Blue
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextSize = 12
		Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)

		-- Simple AutoCook toggle
		local acBar = AddToggleBar(PageFarm, "AutoCook")
		acBar.LayoutOrder = 2
		TOGGLE_LABELS.AutoCook = "Auto Cook"
		local acLbl = acBar:FindFirstChild("TextLabel")
		-- Fallback: rename via find
		for _, c in pairs(acBar:GetChildren()) do
			if c:IsA("TextLabel") then c.Text = "Auto Cook" end
		end
	end

	-- ================================================================
	-- BUILD TP PAGE
	-- ================================================================
	local function buildTP()
		local TP_LOCS = {
			{name="Bank",        x=-48.64,   y=3.73, z=-320.46},
			{name="Casino",      x=1152.53,  y=20.32, z=-26.31},
			{name="Gun Store",   x=215.77,   y=3.73, z=-179.89},
			{name="Chips Store", x=-773.72,  y=3.66, z=-187.54},
			{name="Marshmallow", x=510.38,   y=3.59, z=603.50},
		}

		-- Status label
		local statusLbl = Instance.new("TextLabel", PageTP)
		statusLbl.Size = UDim2.new(1, 0, 0, 20)
		statusLbl.BackgroundTransparency = 1
		statusLbl.Text = ""
		statusLbl.TextColor3 = T.Blue
		statusLbl.Font = Enum.Font.GothamBlack
		statusLbl.TextSize = 12
		statusLbl.LayoutOrder = 1

		for i, loc in ipairs(TP_LOCS) do
			local btn = Instance.new("TextButton", PageTP)
			btn.Size = UDim2.new(1, 0, 0, 36)
			btn.BackgroundColor3 = T.Card
			btn.Text = ""
			btn.AutoButtonColor = false
			btn.LayoutOrder = 10 + i
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
			local btnStr = Instance.new("UIStroke", btn)
			btnStr.Color = T.Stroke

			local dot = Instance.new("Frame", btn)
			dot.Size = UDim2.new(0, 5, 0, 5)
			dot.Position = UDim2.new(0, 12, 0.5, -2.5)
			dot.BackgroundColor3 = T.Blue
			Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

			local nameLbl = Instance.new("TextLabel", btn)
			nameLbl.Size = UDim2.new(1, -80, 1, 0)
			nameLbl.Position = UDim2.new(0, 24, 0, 0)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = loc.name
			nameLbl.TextColor3 = T.Text
			nameLbl.Font = Enum.Font.GothamBlack
			nameLbl.TextSize = 13
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left

			local goPill = Instance.new("Frame", btn)
			goPill.Size = UDim2.new(0, 46, 0, 22)
			goPill.Position = UDim2.new(1, -52, 0.5, -11)
			goPill.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
			Instance.new("UICorner", goPill).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", goPill).Color = T.StrokeOn
			local goLbl = Instance.new("TextLabel", goPill)
			goLbl.Size = UDim2.new(1, 0, 1, 0)
			goLbl.BackgroundTransparency = 1
			goLbl.Text = "GO"
			goLbl.TextColor3 = T.Blue
			goLbl.Font = Enum.Font.GothamBlack
			goLbl.TextSize = 12

			btn.MouseButton1Click:Connect(function()
				local ch = plr.Character
				local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.CFrame = CFrame.new(loc.x, loc.y + 3, loc.z)
					statusLbl.Text = "TP → " .. loc.name
					task.delay(2, function()
						if statusLbl.Text == "TP → " .. loc.name then
							statusLbl.Text = ""
						end
					end)
				end
			end)
		end
	end

	-- ================================================================
	-- BUILD INFO PAGE
	-- ================================================================
	local function buildInfo()
		local function infoCard(parent, icon, label, copyValue, order)
			local f = Instance.new("TextButton", parent)
			f.Size=UDim2.new(1,0,0,44)
			f.BackgroundColor3=T.Card
			f.Text=""
			f.AutoButtonColor=false
			f.LayoutOrder = order
			Instance.new("UICorner", f).CornerRadius=UDim.new(0,8)
			local fStr = Instance.new("UIStroke", f)
			fStr.Color=T.Stroke

			local acc = Instance.new("Frame", f)
			acc.Size=UDim2.new(0,3,0,20)
			acc.Position=UDim2.new(0,0,0.5,-10)
			acc.BackgroundColor3=T.Blue
			acc.BorderSizePixel=0
			Instance.new("UICorner", acc).CornerRadius=UDim.new(1,0)

			local iconLbl = Instance.new("TextLabel", f)
			iconLbl.Size=UDim2.new(0,22,1,0)
			iconLbl.Position=UDim2.new(0,12,0,0)
			iconLbl.BackgroundTransparency=1
			iconLbl.Text=icon
			iconLbl.TextColor3=T.Blue
			iconLbl.Font=Enum.Font.GothamBlack
			iconLbl.TextSize=16

			local mainLbl = Instance.new("TextLabel", f)
			mainLbl.Size=UDim2.new(1,-100,0,18)
			mainLbl.Position=UDim2.new(0,36,0,4)
			mainLbl.BackgroundTransparency=1
			mainLbl.Text=label
			mainLbl.TextColor3=T.Text
			mainLbl.Font=Enum.Font.GothamBlack
			mainLbl.TextSize=13
			mainLbl.TextXAlignment=Enum.TextXAlignment.Left

			local subLbl = Instance.new("TextLabel", f)
			subLbl.Size=UDim2.new(1,-100,0,14)
			subLbl.Position=UDim2.new(0,36,0,22)
			subLbl.BackgroundTransparency=1
			subLbl.Text=copyValue
			subLbl.TextColor3=T.TextDim
			subLbl.Font=Enum.Font.Gotham
			subLbl.TextSize=11
			subLbl.TextXAlignment=Enum.TextXAlignment.Left
			subLbl.TextTruncate=Enum.TextTruncate.AtEnd

			local copyPill = Instance.new("Frame", f)
			copyPill.Size=UDim2.new(0,54,0,22)
			copyPill.AnchorPoint=Vector2.new(1,0.5)
			copyPill.Position=UDim2.new(1,-8,0.5,0)
			copyPill.BackgroundColor3=Color3.fromRGB(20,28,48)
			Instance.new("UICorner", copyPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke", copyPill).Color=T.Stroke
			local copyLbl = Instance.new("TextLabel", copyPill)
			copyLbl.Size=UDim2.new(1,0,1,0)
			copyLbl.BackgroundTransparency=1
			copyLbl.Text="COPY"
			copyLbl.TextColor3=T.Blue
			copyLbl.Font=Enum.Font.GothamBlack
			copyLbl.TextSize=11

			f.MouseButton1Click:Connect(function()
				pcall(function() setclipboard(copyValue) end)
				copyLbl.Text="✓"
				copyLbl.TextColor3=T.Green
				copyPill.BackgroundColor3=Color3.fromRGB(10,30,15)
				fStr.Color=Color3.fromRGB(0,120,60)
				task.delay(1.5, function()
					copyLbl.Text="COPY"
					copyLbl.TextColor3=T.Blue
					copyPill.BackgroundColor3=Color3.fromRGB(20,28,48)
					fStr.Color=T.Stroke
				end)
			end)
		end

		-- Header
		local hdr = Instance.new("TextLabel", PageInfo)
		hdr.Size=UDim2.new(1,0,0,20)
		hdr.BackgroundTransparency=1
		hdr.Text="CONTACT — tap untuk copy"
		hdr.TextColor3=T.TextDim
		hdr.Font=Enum.Font.GothamBlack
		hdr.TextSize=11
		hdr.TextXAlignment = Enum.TextXAlignment.Left
		hdr.LayoutOrder = 1

		infoCard(PageInfo, "♪", "TikTok", "drakhub", 2)
		infoCard(PageInfo, "◆", "Discord", "https://discord.gg/pDEyArQ5B", 3)

		-- Warning
		local warn = Instance.new("Frame", PageInfo)
		warn.Size=UDim2.new(1,0,0,130)
		warn.BackgroundColor3=Color3.fromRGB(18,6,6)
		warn.LayoutOrder = 4
		Instance.new("UICorner", warn).CornerRadius=UDim.new(0,10)
		Instance.new("UIStroke", warn).Color=Color3.fromRGB(80,20,20)

		local wl=Instance.new("TextLabel", warn)
		wl.Size=UDim2.new(1,-12,0,30)
		wl.Position=UDim2.new(0,6,0,6)
		wl.BackgroundTransparency=1
		wl.TextWrapped=true
		wl.Text="USE AT YOUR OWN RISK\nWe are not responsible for any bans."
		wl.TextColor3=Color3.fromRGB(255,100,100)
		wl.Font=Enum.Font.GothamBlack
		wl.TextSize=15

		local wl2 = Instance.new("TextLabel", warn)
		wl2.Size=UDim2.new(1,-12,0,22)
		wl2.Position=UDim2.new(0,6,0,46)
		wl2.BackgroundTransparency=1
		wl2.TextWrapped=true
		wl2.Text="DILARANG KERAS SHARING!!!"
		wl2.TextColor3=Color3.fromRGB(255,50,50)
		wl2.Font=Enum.Font.GothamBlack
		wl2.TextSize=16

		local wl3 = Instance.new("TextLabel", warn)
		wl3.Size=UDim2.new(1,-12,0,26)
		wl3.Position=UDim2.new(0,6,0,80)
		wl3.BackgroundTransparency=1
		wl3.TextWrapped=true
		wl3.Text="DILARANG MENJUAL KEMBALI SCRIPT INI!!!"
		wl3.TextColor3=Color3.fromRGB(255,180,0)
		wl3.Font=Enum.Font.GothamBlack
		wl3.TextSize=14
	end

	-- ================================================================
	-- BUILD CONFIG PAGE
	-- ================================================================
	local function buildConfig()
		local lbl = Instance.new("TextLabel", PageConfig)
		lbl.Size = UDim2.new(1, 0, 0, 40)
		lbl.BackgroundColor3 = T.Card
		lbl.Text = "CFG — Save / Load settings"
		lbl.TextColor3 = T.Blue
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextSize = 12
		Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", lbl).Color = T.Stroke
	end

	-- ================================================================
	-- BUILD VEHICLE PAGE
	-- ================================================================
	local function buildVehicle()
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
					if vFlyActive then
						vFlyActive = false
						vStopFly()
					end
				end
			end)
		end

		local bar = Instance.new("TextButton", PageVehicle)
		bar.Size = UDim2.new(1,0,0,46)
		bar.BackgroundColor3 = T.Card
		bar.Text = ""
		bar.AutoButtonColor = false
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0,8)
		local bStr = Instance.new("UIStroke", bar)
		bStr.Color = T.Stroke

		local lbl = Instance.new("TextLabel", bar)
		lbl.Size = UDim2.new(1,-70,1,0)
		lbl.Position = UDim2.new(0,14,0,0)
		lbl.BackgroundTransparency = 1
		lbl.Text = "Vehicle Fly  (WASD + E/Q)"
		lbl.TextColor3 = T.Text
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextSize = 13
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local pill = Instance.new("Frame", bar)
		pill.Size = UDim2.new(0,46,0,22)
		pill.Position = UDim2.new(1,-58,0.5,-11)
		pill.BackgroundColor3 = Color3.fromRGB(20,28,48)
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
		Instance.new("UIStroke", pill).Color = T.Stroke
		local pillLbl = Instance.new("TextLabel", pill)
		pillLbl.Size = UDim2.new(1,0,1,0)
		pillLbl.BackgroundTransparency = 1
		pillLbl.Text = "OFF"
		pillLbl.TextColor3 = T.TextDim
		pillLbl.Font = Enum.Font.GothamBlack
		pillLbl.TextSize = 12

		bar.MouseButton1Click:Connect(function()
			vFlyActive = not vFlyActive
			if vFlyActive then
				vStartFly()
				bar.BackgroundColor3 = Color3.fromRGB(18,28,55)
				bStr.Color = T.StrokeOn
				pill.BackgroundColor3 = T.Blue
				pillLbl.Text = "ON"
				pillLbl.TextColor3 = Color3.fromRGB(0,0,0)
			else
				vStopFly()
				bar.BackgroundColor3 = T.Card
				bStr.Color = T.Stroke
				pill.BackgroundColor3 = Color3.fromRGB(20,28,48)
				pillLbl.Text = "OFF"
				pillLbl.TextColor3 = T.TextDim
			end
		end)

		-- Info card
		local infoCard = Instance.new("Frame", PageVehicle)
		infoCard.Size = UDim2.new(1,0,0,80)
		infoCard.BackgroundColor3 = Color3.fromRGB(12, 18, 35)
		Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0,8)
		Instance.new("UIStroke", infoCard).Color = Color3.fromRGB(40, 70, 140)

		local infoTxt = Instance.new("TextLabel", infoCard)
		infoTxt.Size = UDim2.new(1,-16,1,-8)
		infoTxt.Position = UDim2.new(0,8,0,4)
		infoTxt.BackgroundTransparency = 1
		infoTxt.Text = "ℹ Duduk di kendaraan dulu sebelum ON\n• W/A/S/D = gerak ngikutin kamera\n• E = naik | Q = turun\n• Auto OFF kalau keluar kendaraan"
		infoTxt.TextColor3 = Color3.fromRGB(100, 150, 220)
		infoTxt.Font = Enum.Font.Gotham
		infoTxt.TextSize = 12
		infoTxt.TextXAlignment = Enum.TextXAlignment.Left
		infoTxt.TextYAlignment = Enum.TextYAlignment.Top
	end

	-- ================================================================
	-- BUILD ALL PAGES
	-- ================================================================
	buildMain()
	buildVisual()
	buildAim()
	buildFarm()
	buildTP()
	buildInfo()
	buildConfig()
	buildVehicle()

	-- ================================================================
	-- LOGIC: ESP + AIMBOT
	-- ================================================================
	local ESP_MASAK_KW = {"water","sugar","gelatin","marshmallow"}
	local ESP_GUN_KW   = {"gun","pistol","rifle","ak","m4","uzi","revolver","shotgun","sniper","smg","weapon","knife","sword","blade"}

	for _, p in pairs(Players:GetPlayers()) do createESP(p) end
	Players.PlayerAdded:Connect(createESP)
	Players.PlayerRemoving:Connect(removeESP)

	-- ESP Cache (event-driven)
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
					if v:IsA("Tool") then
						if isKW(v.Name) then hb = true end
					end
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
		espCache[p] = {hasBahan = hb, wName = wn}
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
			table.insert(conns, ch.ChildAdded:Connect(function(v)
				if v:IsA("Tool") then rebuildCache(p) end
			end))
			table.insert(conns, ch.ChildRemoved:Connect(function(v)
				if v:IsA("Tool") then rebuildCache(p) end
			end))
			rebuildCache(p)
		end
		if p.Character then watchChar(p.Character) end
		table.insert(conns, p.CharacterAdded:Connect(function(ch)
			task.wait(0.1); watchChar(ch)
		end))
	end

	for _, p in ipairs(Players:GetPlayers()) do connectESPPlayer(p) end
	Players.PlayerAdded:Connect(connectESPPlayer)

	-- RMB aimlock
	local RMB = false
	UIS.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=true end
	end)
	UIS.InputEnded:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=false; AimTarget=nil end
	end)

	-- Render loop
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

	local renderConn
	renderConn = RunService.RenderStepped:Connect(function()
		if not Running then renderConn:Disconnect(); return end
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

		local fovCenter
		if AimMode == "HP" then fovCenter = Vector2.new(vp.X / 2, vp.Y / 2)
		else fovCenter = mousePos end

		FovCircle.Radius = AimFOV_Radius
		FovCircle.Visible = Flags.AimLock and ShowAimFOV

		-- Silent aim circle
		if SilentAim then
			local saOrigin = SilentMode == "HP" and Vector2.new(vp.X / 2, vp.Y / 2) or mousePos
			local bestWorldD = math.huge
			local bestScreenPos = nil
			for _, p in pairs(Players:GetPlayers()) do
				if p == plr then continue end
				local ch = p.Character
				if not ch then continue end
				local hum = ch:FindFirstChildOfClass("Humanoid")
				local part = ch:FindFirstChild(AimPart == "Head" and "Head" or "HumanoidRootPart")
				if not part or not hum or hum.Health <= 0 then continue end
				local sp, onScreen = cam:WorldToViewportPoint(part.Position)
				if not onScreen or sp.Z <= 0 then continue end
				local screenPos = Vector2.new(sp.X, sp.Y)
				if (saOrigin - screenPos).Magnitude > SilentFOV_Radius then continue end
				local worldD = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
				if worldD < bestWorldD then
					bestWorldD = worldD
					bestScreenPos = screenPos
				end
			end
			if bestScreenPos then
				local circlePos = SilentMode == "HP" and bestScreenPos or saOrigin
				SilentFovCircle.Position = circlePos
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
			local sp, onScreen = cam:WorldToScreenPoint(AimTarget.Position)
			if not onScreen then AimTarget = nil
			else
				local d = math.sqrt((sp.X - fovCenter.X)^2 + (sp.Y - fovCenter.Y)^2)
				if d > AimFOV_Radius then AimTarget = nil end
			end
		end

		local shouldAim = Flags.AimLock and localRoot and (AimMode=="HP" or RMB)
		if shouldAim then
			if AimMode=="HP" or not AimTarget then
				local bestDist, bestPart = math.huge, nil
				for _, p in pairs(Players:GetPlayers()) do
					if p == plr then continue end
					if AimWhitelist[p.Name] then continue end
					local ch = p.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					local targetPart = ch and ch:FindFirstChild(AimPart=="Head" and "Head" or "HumanoidRootPart")
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
					local d = math.sqrt((sp.X-fovCenter.X)^2 + (sp.Y-fovCenter.Y)^2)
					if d <= AimFOV_Radius and d < bestDist then bestDist=d; bestPart=targetPart end
				end
				AimTarget = bestPart
			end

			if AimTarget then
				local smooth = AimSmooth
				local targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
				cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
				FovCircle.Color = Color3.fromRGB(220,50,50)
			else
				FovCircle.Color = T.Blue
			end
		else
			if AimMode=="PC" and not RMB then AimTarget = nil end
			FovCircle.Color = T.Blue
		end

		if AimMode == "HP" and AimTarget then
			local sp2, vis2 = cam:WorldToViewportPoint(AimTarget.Position)
			if vis2 and sp2.Z > 0 then FovCircle.Position = Vector2.new(sp2.X, sp2.Y)
			else FovCircle.Position = fovCenter end
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
						if v1 and v2 and s1.Z>0 and s2.Z>0 then
							sk.From=Vector2.new(s1.X,s1.Y)
							sk.To=Vector2.new(s2.X,s2.Y)
							sk.Color=W2
							sk.Visible=true
						else sk.Visible=false end
					else sk.Visible=false end
				end
			else
				for _,s in ipairs(e.skeleton) do s.Visible=false end
			end

			local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
			local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
			local sY = math.abs(botPos.Y - topPos.Y)
			local sX = sY * 0.6
			local bx = pos3.X - sX / 2
			local by = math.min(topPos.Y, botPos.Y)

			local cache = espCache[p] or {hasBahan=false, wName=nil}
			local hasBahan = cache.hasBahan
			local wName = cache.wName
			local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)

			if Flags.BoxESP then
				e.box.Color=W
				e.box.Size=Vector2.new(sX,sY)
				e.box.Position=Vector2.new(bx,by)
				e.box.Visible=(BoxESPMode=="FULL")
				local showC=(BoxESPMode=="CORNER")
				local cL=math.min(sX,sY)*0.25
				local cx=e.corners
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

			local hp=math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
			local barH=math.max(1,sY*hp)
			local barX=bx-7
			local hpCol=hp>0.5 and Color3.fromRGB(0,220,0) or hp>0.2 and Color3.fromRGB(255,165,0) or Color3.fromRGB(255,0,0)
			if Flags.ESPHPBar then
				e.hpbg.Size=Vector2.new(4,sY)
				e.hpbg.Position=Vector2.new(barX,by)
				e.hpbg.Color=Color3.fromRGB(0,0,0)
				e.hpbg.Filled=false
				e.hpbg.Thickness=1
				e.hpbg.Visible=true
				e.hpbar.Color=hpCol
				e.hpbar.Size=Vector2.new(4,barH)
				e.hpbar.Position=Vector2.new(barX,by+(sY-barH))
				e.hpbar.Filled=true
				e.hpbar.Visible=true
				e.hpnum.Text=math.floor(hum.Health).."HP"
				e.hpnum.Size=11
				e.hpnum.Position=Vector2.new(barX+2,by-1)
				e.hpnum.Center=false
				e.hpnum.Color=hpCol
				e.hpnum.Visible=true
			else e.hpbg.Visible=false; e.hpbar.Visible=false; e.hpnum.Visible=false end

			local distNow = localRoot and (root.Position-localRoot.Position).Magnitude or 100
			local tSize = math.clamp(math.floor(14 - distNow/40), 8, 14)

			if Flags.ESPName then
				e.dispname.Text=(p.DisplayName or p.Name).."(@"..p.Name..")"
				e.dispname.Size=tSize
				e.dispname.Color=W
				e.dispname.Position=Vector2.new(pos3.X,by-14)
				e.dispname.Visible=true
				e.username.Visible=false
			else e.dispname.Visible=false; e.username.Visible=false end

			local dist=localRoot and math.floor((root.Position-localRoot.Position).Magnitude) or 0
			local nY=by+sY+3
			if Flags.ESPDist then
				e.dist.Text=dist.."m"
				e.dist.Size=tSize
				e.dist.Color=W
				e.dist.Position=Vector2.new(pos3.X,nY)
				e.dist.Visible=true
				nY=nY+13
			else e.dist.Visible=false end

			if Flags.ESPWeapon and wName then
				e.weapon.Text=wName
				e.weapon.Color=Color3.fromRGB(255,220,80)
				e.weapon.Position=Vector2.new(pos3.X,nY)
				e.weapon.Visible=true
			else e.weapon.Visible=false end

			if Flags.ESPMasak and hasBahan then
				e.masak.Text="MASAK"
				e.masak.Position=Vector2.new(bx+sX+4,by+sY/2-6)
				e.masak.Center=false
				e.masak.Visible=true
			else e.masak.Visible=false end

			local tracerDist=localRoot and (root.Position-localRoot.Position).Magnitude or 999
			if Flags.Tracer and tracerDist<TracerMaxDist then
				local vp2=cam.ViewportSize
				e.tracer.From=Vector2.new(vp2.X/2,vp2.Y)
				e.tracer.To=Vector2.new(pos3.X,by+sY)
				e.tracer.Color=W
				e.tracer.Visible=true
			else e.tracer.Visible=false end
		end
	end)

	-- ================================================================
	-- INFINITE STAMINA + SPEED HACK + NOCLIP
	-- ================================================================
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

	-- NoClip
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

	-- Blink TP
	UIS.InputBegan:Connect(function(input, processed)
		if processed then return end
		if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode==Enum.KeyCode.T then
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
					{CFrame=hrp.CFrame*CFrame.new(0,0,-6)}):Play()
			end
		end
	end)

	-- Instant Interact
	game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
		if Flags.InstantInteract then
			pcall(function() if prompt.HoldDuration>0 then prompt.HoldDuration=0.05 end end)
		end
	end)

end -- end launchMainScript

-- ================================================================
-- STARTUP
-- ================================================================
do
	local VirtualUser = game:GetService("VirtualUser")
	Players.LocalPlayer.Idled:Connect(function()
		VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)
end

showThankYouPopup()
launchMainScript()