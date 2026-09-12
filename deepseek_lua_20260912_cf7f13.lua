-- ================================================================
-- DARK HUB PREMIUM V3.0 — MODERN EDITION
-- ================================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Auto Buy Settings (global, dipakai UI dan logic beli)
local AutoBuySettings = {
	Enabled = false,
	Amount = 10,
	Mode = "PACK"
}
_G.HNDRIXX_AUTOBUY = AutoBuySettings

-- ================================================================
-- THANK YOU POPUP
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
	Card.BackgroundColor3 = Color3.fromRGB(14, 18, 32)
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)
	local cs = Instance.new("UIStroke", Card)
	cs.Color = Color3.fromRGB(45, 62, 110)
	cs.Thickness = 1

	local accent = Instance.new("Frame", Card)
	accent.Size = UDim2.new(0, 3, 0, 34)
	accent.Position = UDim2.new(0, 0, 0.5, -17)
	accent.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
	accent.BorderSizePixel = 0
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local badge = Instance.new("Frame", Card)
	badge.Size = UDim2.new(0, 50, 0, 18)
	badge.Position = UDim2.new(0, 14, 0, 11)
	badge.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
	Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
	local bdgLbl = Instance.new("TextLabel", badge)
	bdgLbl.Size = UDim2.new(1, 0, 1, 0)
	bdgLbl.BackgroundTransparency = 1
	bdgLbl.Text = "V3.0"
	bdgLbl.TextColor3 = Color3.fromRGB(130, 175, 255)
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
	Msg.Text = "TikTok · @darkhub"
	Msg.TextColor3 = Color3.fromRGB(130, 150, 190)
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
-- MAIN SCRIPT
-- ================================================================
local function launchMainScript()
	-- ================== MODERN COLOR THEME ==================
	local T = {
		BG        = Color3.fromRGB(10, 13, 22),
		Card      = Color3.fromRGB(19, 24, 40),
		CardHov   = Color3.fromRGB(27, 34, 55),
		TopBar    = Color3.fromRGB(14, 18, 30),
		Sidebar   = Color3.fromRGB(12, 16, 26),
		Accent    = Color3.fromRGB(90, 160, 255),
		AccOn     = Color3.fromRGB(90, 160, 255),
		Stroke    = Color3.fromRGB(38, 48, 78),
		StrokeOn  = Color3.fromRGB(90, 160, 255),
		Text      = Color3.fromRGB(238, 244, 255),
		TextDim   = Color3.fromRGB(128, 145, 180),
		Red       = Color3.fromRGB(230, 70, 90),
		Green     = Color3.fromRGB(60, 215, 130),
	}

	local PANEL_W = 640
	local PANEL_H = 520
	local SIDEBAR_W = 138
	local HEADER_H = 44
	local MF_MIN_W,MF_MAX_W=520,900
	local MF_MIN_H,MF_MAX_H=400,720

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "DARKHUB_UI"
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 20
	Gui.Parent = CoreGui

	local LogoBtn = Instance.new("TextButton", Gui)
	LogoBtn.Size = UDim2.new(0, 0, 0, 0)
	LogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
	LogoBtn.BackgroundColor3 = T.TopBar
	LogoBtn.Text = "◆"
	LogoBtn.TextColor3 = T.AccOn
	LogoBtn.Font = Enum.Font.GothamBlack
	LogoBtn.TextSize = 20
	LogoBtn.Visible = false
	LogoBtn.Draggable = true
	Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 12)
	local lbStr = Instance.new("UIStroke", LogoBtn)
	lbStr.Color = T.StrokeOn
	lbStr.Thickness = 1

	local MF = Instance.new("Frame", Gui)
	MF.Size = UDim2.new(0, 0, 0, 0)
	MF.Position = UDim2.new(0.35, 0, 0.25, 0)
	MF.BackgroundColor3 = T.BG
	MF.Active = true
	MF.Draggable = false
	MF.ClipsDescendants = true
	Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 14)
	local mfStr = Instance.new("UIStroke", MF)
	mfStr.Color = T.Stroke
	mfStr.Thickness = 1

	TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{Size = UDim2.new(0, PANEL_W, 0, PANEL_H)}):Play()

	-- Resize handles (BR & TL)
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
				rz=true
				rzS=i.Position
				rzW=MF.AbsoluteSize.X
				rzH=MF.AbsoluteSize.Y
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

		local MFTL=Instance.new("TextButton",MF)
		MFTL.Size=UDim2.new(0,14,0,14)
		MFTL.Position=UDim2.new(0,0,0,0)
		MFTL.BackgroundTransparency=1
		MFTL.Text=""
		MFTL.AutoButtonColor=false
		MFTL.ZIndex=10
		MFTL.Active=true
		local rzTL=false
		local rzTLS,rzTLW,rzTLH,rzTLPX,rzTLPY
		MFTL.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				rzTL=true
				rzTLS=i.Position
				rzTLW=MF.AbsoluteSize.X
				rzTLH=MF.AbsoluteSize.Y
				rzTLPX=MF.Position.X.Offset
				rzTLPY=MF.Position.Y.Offset
				i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then rzTL=false end end)
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if rzTL and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
				local dX = i.Position.X - rzTLS.X
				local dY = i.Position.Y - rzTLS.Y
				local nW = math.clamp(rzTLW - dX, MF_MIN_W, MF_MAX_W)
				local nH = math.clamp(rzTLH - dY, MF_MIN_H, MF_MAX_H)
				local nPX = rzTLPX + (rzTLW - nW)
				local nPY = rzTLPY + (rzTLH - nH)
				PANEL_W=nW
				PANEL_H=nH
				MF.Size=UDim2.new(0,nW,0,nH)
				MF.Position=UDim2.new(MF.Position.X.Scale,nPX,MF.Position.Y.Scale,nPY)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then rzTL=false end
		end)
	end

	-- ================================================================
	-- TOPBAR (HEADER)
	-- ================================================================
	local TitleBar = Instance.new("Frame", MF)
	TitleBar.Size = UDim2.new(1, 0, 0, HEADER_H)
	TitleBar.BackgroundColor3 = T.TopBar
	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)
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
	LogoMark.Position = UDim2.new(0, 12, 0, 0)
	LogoMark.BackgroundTransparency = 1
	LogoMark.Text = "◆"
	LogoMark.TextColor3 = T.AccOn
	LogoMark.Font = Enum.Font.GothamBlack
	LogoMark.TextSize = 20

	local TitleLbl = Instance.new("TextLabel", TitleBar)
	TitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
	TitleLbl.Position = UDim2.new(0, 44, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = "DARK HUB"
	TitleLbl.TextColor3 = T.Text
	TitleLbl.Font = Enum.Font.GothamBlack
	TitleLbl.TextSize = 15
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local VerBadge = Instance.new("Frame", TitleBar)
	VerBadge.Size = UDim2.new(0, 46, 0, 20)
	VerBadge.AnchorPoint = Vector2.new(1, 0.5)
	VerBadge.Position = UDim2.new(1, -74, 0.5, 0)
	VerBadge.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
	Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", VerBadge).Color = T.StrokeOn
	local VerLbl = Instance.new("TextLabel", VerBadge)
	VerLbl.Size = UDim2.new(1, 0, 1, 0)
	VerLbl.BackgroundTransparency = 1
	VerLbl.Text = "V3.0"
	VerLbl.TextColor3 = T.AccOn
	VerLbl.Font = Enum.Font.GothamBlack
	VerLbl.TextSize = 11

	local MinBtn = Instance.new("TextButton", TitleBar)
	MinBtn.Size = UDim2.new(0, 26, 0, 26)
	MinBtn.Position = UDim2.new(1, -58, 0.5, -13)
	MinBtn.Text = "—"
	MinBtn.TextColor3 = T.TextDim
	MinBtn.Font = Enum.Font.GothamBlack
	MinBtn.TextSize = 13
	MinBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
	MinBtn.AutoButtonColor = false
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", MinBtn).Color = T.Stroke

	local CloseBtn = Instance.new("TextButton", TitleBar)
	CloseBtn.Size = UDim2.new(0, 26, 0, 26)
	CloseBtn.Position = UDim2.new(1, -28, 0.5, -13)
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Color3.fromRGB(230, 90, 100)
	CloseBtn.Font = Enum.Font.GothamBlack
	CloseBtn.TextSize = 19
	CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 14, 20)
	CloseBtn.AutoButtonColor = false
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", CloseBtn).Color = Color3.fromRGB(80, 25, 35)

	-- Drag via TitleBar
	do
		local dragging = false
		local dragStart, startPos
		TitleBar.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = inp.Position
				startPos = MF.Position
				inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
			or inp.UserInputType == Enum.UserInputType.Touch) then
				local delta = inp.Position - dragStart
				MF.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
				)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	-- ================================================================
	-- SIDEBAR
	-- ================================================================
	local Sidebar = Instance.new("Frame", MF)
	Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -HEADER_H)
	Sidebar.Position = UDim2.new(0, 0, 0, HEADER_H)
	Sidebar.BackgroundColor3 = T.Sidebar
	Sidebar.BorderSizePixel = 0

	-- right divider
	local sbDiv = Instance.new("Frame", Sidebar)
	sbDiv.Size = UDim2.new(0, 1, 1, 0)
	sbDiv.Position = UDim2.new(1, -1, 0, 0)
	sbDiv.BackgroundColor3 = T.Stroke
	sbDiv.BorderSizePixel = 0

	local function makeSidebarBtn(icon, lbl, order)
		local tb = Instance.new("TextButton", Sidebar)
		tb.Size = UDim2.new(1, -16, 0, 36)
		tb.Position = UDim2.new(0, 8, 0, 10 + (order-1) * 40)
		tb.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
		tb.Text = ""
		tb.AutoButtonColor = false
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
		local s = Instance.new("UIStroke", tb)
		s.Color = T.Stroke
		s.Thickness = 1

		local iconLbl = Instance.new("TextLabel", tb)
		iconLbl.Name = "IconLbl"
		iconLbl.Size = UDim2.new(0, 22, 1, 0)
		iconLbl.Position = UDim2.new(0, 8, 0, 0)
		iconLbl.BackgroundTransparency = 1
		iconLbl.Text = icon
		iconLbl.TextColor3 = T.TextDim
		iconLbl.Font = Enum.Font.GothamBlack
		iconLbl.TextSize = 14

		local txtLbl = Instance.new("TextLabel", tb)
		txtLbl.Name = "TxtLbl"
		txtLbl.Size = UDim2.new(1, -34, 1, 0)
		txtLbl.Position = UDim2.new(0, 32, 0, 0)
		txtLbl.BackgroundTransparency = 1
		txtLbl.Text = lbl
		txtLbl.TextColor3 = T.TextDim
		txtLbl.Font = Enum.Font.GothamBlack
		txtLbl.TextSize = 12
		txtLbl.TextXAlignment = Enum.TextXAlignment.Left

		local ind = Instance.new("Frame", tb)
		ind.Name = "ActiveIndicator"
		ind.Size = UDim2.new(0, 3, 0, 20)
		ind.Position = UDim2.new(0, 0, 0.5, -10)
		ind.BackgroundColor3 = T.AccOn
		ind.BorderSizePixel = 0
		ind.Visible = false
		Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

		return tb, iconLbl, txtLbl
	end

	local BtnWar, icoWar,  txtWar  = makeSidebarBtn("⚔", "MAIN",   1)
	local BtnVisual, icoVis, txtVis = makeSidebarBtn("◉", "VISUAL", 2)
	local BtnAim, icoAim, txtAim  = makeSidebarBtn("⊕", "AIM",    3)
	local BtnFarm, icoFarm, txtFarm = makeSidebarBtn("✿", "FARM",  4)
	local BtnTP, icoTP, txtTP     = makeSidebarBtn("➤", "TP",     5)
	local BtnInfo, icoInfo, txtInfo = makeSidebarBtn("ⓘ", "INFO", 6)
	local BtnConfig, icoCfg, txtCfg = makeSidebarBtn("⚙", "CFG",   7)
	local BtnVehicle, icoVeh, txtVeh = makeSidebarBtn("⌘", "VEH",  8)

	local allTabs = {BtnWar, BtnVisual, BtnAim, BtnFarm, BtnTP, BtnInfo, BtnConfig, BtnVehicle}
	local allTabIcons = {
		[BtnWar]=icoWar,[BtnVisual]=icoVis,[BtnAim]=icoAim,[BtnFarm]=icoFarm,
		[BtnTP]=icoTP,[BtnInfo]=icoInfo,[BtnConfig]=icoCfg,[BtnVehicle]=icoVeh,
	}
	local allTabTexts = {
		[BtnWar]=txtWar,[BtnVisual]=txtVis,[BtnAim]=txtAim,[BtnFarm]=txtFarm,
		[BtnTP]=txtTP,[BtnInfo]=txtInfo,[BtnConfig]=txtCfg,[BtnVehicle]=txtVeh,
	}

	-- Social links bottom of sidebar
	do
		local socialCard = Instance.new("Frame", Sidebar)
		socialCard.Size = UDim2.new(1, -16, 0, 74)
		socialCard.AnchorPoint = Vector2.new(0, 1)
		socialCard.Position = UDim2.new(0, 8, 1, -8)
		socialCard.BackgroundColor3 = Color3.fromRGB(14, 18, 30)
		socialCard.BorderSizePixel = 0
		Instance.new("UICorner", socialCard).CornerRadius = UDim.new(0, 8)
		local scStr = Instance.new("UIStroke", socialCard)
		scStr.Color = T.Stroke
		scStr.Thickness = 1

		local ttHdr = Instance.new("TextLabel", socialCard)
		ttHdr.Size = UDim2.new(1, -10, 0, 14)
		ttHdr.Position = UDim2.new(0, 8, 0, 6)
		ttHdr.BackgroundTransparency = 1
		ttHdr.Text = "TikTok"
		ttHdr.TextColor3 = T.AccOn
		ttHdr.Font = Enum.Font.GothamBlack
		ttHdr.TextSize = 10
		ttHdr.TextXAlignment = Enum.TextXAlignment.Left

		local ttLbl = Instance.new("TextLabel", socialCard)
		ttLbl.Size = UDim2.new(1, -10, 0, 14)
		ttLbl.Position = UDim2.new(0, 8, 0, 20)
		ttLbl.BackgroundTransparency = 1
		ttLbl.Text = "@darkhub"
		ttLbl.TextColor3 = T.Text
		ttLbl.Font = Enum.Font.Gotham
		ttLbl.TextSize = 11
		ttLbl.TextXAlignment = Enum.TextXAlignment.Left

		local dcHdr = Instance.new("TextLabel", socialCard)
		dcHdr.Size = UDim2.new(1, -10, 0, 14)
		dcHdr.Position = UDim2.new(0, 8, 0, 38)
		dcHdr.BackgroundTransparency = 1
		dcHdr.Text = "Discord"
		dcHdr.TextColor3 = T.AccOn
		dcHdr.Font = Enum.Font.GothamBlack
		dcHdr.TextSize = 10
		dcHdr.TextXAlignment = Enum.TextXAlignment.Left

		local dcBtn = Instance.new("TextButton", socialCard)
		dcBtn.Size = UDim2.new(1, -10, 0, 20)
		dcBtn.Position = UDim2.new(0, 8, 0, 52)
		dcBtn.BackgroundTransparency = 1
		dcBtn.Text = "Tap to copy link"
		dcBtn.TextColor3 = T.TextDim
		dcBtn.Font = Enum.Font.Gotham
		dcBtn.TextSize = 10
		dcBtn.TextXAlignment = Enum.TextXAlignment.Left
		dcBtn.AutoButtonColor = false
		dcBtn.MouseButton1Click:Connect(function()
			pcall(function() setclipboard("https://discord.gg/pDEyArQ5B") end)
			dcBtn.Text = "Copied!"
			dcBtn.TextColor3 = T.AccOn
			task.delay(1.5, function()
				dcBtn.Text = "Tap to copy link"
				dcBtn.TextColor3 = T.TextDim
			end)
		end)
	end

	local function setActiveTab(btn)
		for _, b in ipairs(allTabs) do
			b.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
			local s = b:FindFirstChildOfClass("UIStroke")
			if s then s.Color = T.Stroke; s.Thickness = 1 end
			local ind = b:FindFirstChild("ActiveIndicator")
			if ind then ind.Visible = false end
			local il = b:FindFirstChild("IconLbl")
			local tl = b:FindFirstChild("TxtLbl")
			if il then il.TextColor3 = T.TextDim end
			if tl then tl.TextColor3 = T.TextDim end
		end
		btn.BackgroundColor3 = Color3.fromRGB(28, 45, 85)
		local s = btn:FindFirstChildOfClass("UIStroke")
		if s then
			s.Color = T.AccOn
			s.Thickness = 1.5
		end
		local ind = btn:FindFirstChild("ActiveIndicator")
		if ind then ind.Visible = true end
		local il = btn:FindFirstChild("IconLbl")
		local tl = btn:FindFirstChild("TxtLbl")
		if il then il.TextColor3 = T.AccOn end
		if tl then tl.TextColor3 = T.Text end
	end
	setActiveTab(BtnWar)

	-- Pages
	local function makePage()
		local pg = Instance.new("ScrollingFrame", MF)
		pg.Position = UDim2.new(0, SIDEBAR_W + 10, 0, HEADER_H + 10)
		pg.Size = UDim2.new(1, -(SIDEBAR_W + 20), 1, -(HEADER_H + 20))
		pg.BackgroundTransparency = 1
		pg.ScrollBarThickness = 3
		pg.ScrollBarImageColor3 = T.AccOn
		pg.Visible = false
		pg.CanvasSize = UDim2.new(0, 0, 0, 0)
		local layout = Instance.new("UIListLayout", pg)
		layout.Padding = UDim.new(0, 7)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			pg.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)
		return pg
	end
	local PageWar = makePage()
	PageWar.Visible = true
	local PageVisual = makePage()
	local PageAim = makePage()
	local PageFarm = makePage()
	local PageTP = makePage()
	local PageInfo = makePage()
	local PageConfig = makePage()
	local PageVehicle = makePage()

	local Running = true
	local tpBusy=false
	local tpCancelled=false
	local tpActive=false
	local _htpo={fn=function()end}
	local function hideTPOverlay() _htpo.fn() end
	local _overlayActive = false
	local plr = game.Players.LocalPlayer

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
	local Gc = getgc and getgc() or {}

	local _buildMain, _buildAim, _buildTP, _buildFarm, _buildInfo, _buildVehicle, _startLogic
	local tpCancelBtn
	local doSuicideTP

	-- INSTANT VEHICLE TELEPORT
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

	local Http = game:GetService("HttpService")
	local SAVEFILE = "hndrixx_settings.json"

	local function saveSettings()
		pcall(function()
			local toSave = {
				BoxESP = Flags.BoxESP,
				Tracer = Flags.Tracer,
				TPNoClip = Flags.TPNoClip,
				AimLock = Flags.AimLock,
				WallCheck = Flags.WallCheck,
				InvScan = Flags.InvScan,
				InstantInteract = Flags.InstantInteract,
				InfStamina = Flags.InfStamina,
				AuraKill = Flags.AuraKill,
			}
			writefile(SAVEFILE, Http:JSONEncode({
				Flags = toSave,
				AimFOV_Radius = AimFOV_Radius,
				AimMax_Dist = AimMax_Dist,
			}))
		end)
	end
	local function loadSettings()
		pcall(function()
			if isfile and isfile(SAVEFILE) then
				local d = Http:JSONDecode(readfile(SAVEFILE))
				if d.Flags then for k,v in pairs(d.Flags) do if Flags[k]~=nil then Flags[k]=v end end end
				if d.AimFOV_Radius then AimFOV_Radius=d.AimFOV_Radius end
				if d.AimMax_Dist then AimMax_Dist=d.AimMax_Dist end
			end
		end)
	end

	local function switchPage(btn, page)
		PageWar.Visible=false
		PageVisual.Visible=false
		PageAim.Visible=false
		PageFarm.Visible=false
		PageTP.Visible=false
		PageInfo.Visible=false
		PageConfig.Visible=false
		PageVehicle.Visible=false
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

	MinBtn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(MF, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0)})
		t:Play()
		t.Completed:Wait()
		MF.Visible=false
		LogoBtn.Visible=true
		TweenService:Create(LogoBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(0,48,0,48)}):Play()
	end)
	LogoBtn.MouseButton1Click:Connect(function()
		local t = TweenService:Create(LogoBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size=UDim2.new(0,0,0,0)})
		t:Play()
		t.Completed:Wait()
		LogoBtn.Visible=false
		MF.Visible=true
		TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(0,PANEL_W,0,PANEL_H)}):Play()
	end)

	local ESP = {}

	local FovCircle = Drawing.new("Circle")
	FovCircle.Thickness=1.5
	FovCircle.Color=T.Accent
	FovCircle.Filled=false
	FovCircle.NumSides=64
	FovCircle.Visible=false

	local SilentFovCircle = Drawing.new("Circle")
	SilentFovCircle.Thickness = 1.5
	SilentFovCircle.Color = Color3.fromRGB(90, 160, 255)
	SilentFovCircle.Filled = false
	SilentFovCircle.NumSides = 64
	SilentFovCircle.Visible = false

	local SilentLine = Drawing.new("Line")
	SilentLine.Thickness = 1.5
	SilentLine.Color = Color3.fromRGB(90, 160, 255)
	SilentLine.Transparency = 1
	SilentLine.Visible = false

	local function removeESP(p)
		if not ESP[p] then return end
		local _e=ESP[p]
		if _e.corners then for _,c in ipairs(_e.corners) do pcall(function() c:Remove() end) end end
		if _e.skeleton then for _,s in ipairs(_e.skeleton) do pcall(function() s:Remove() end) end end
		for k,d in pairs(_e) do if k~="corners" and k~="skeleton" then pcall(function() d:Remove() end) end end
		ESP[p]=nil
	end

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
		for _,c in ipairs(e.corners) do c.Visible=false end
		for _,s in ipairs(e.skeleton) do s.Visible=false end
	end

	local function createESP(p)
		if ESP[p] or p == game.Players.LocalPlayer then return end
		local _c = {}
		for ci = 1, 8 do
			local cl = Drawing.new("Line")
			cl.Thickness=2; cl.Color=Color3.fromRGB(90, 160, 255); cl.Visible=false
			_c[ci] = cl
		end
		local _sk = {}
		for si = 1, 15 do
			local sl = Drawing.new("Line")
			sl.Thickness=1.2; sl.Color=Color3.fromRGB(90, 160, 255); sl.Visible=false
			_sk[si] = sl
		end
		local e = {
			box     = Drawing.new("Square"),
			hpbg    = Drawing.new("Square"),
			hpbar   = Drawing.new("Square"),
			hpnum   = _mkText(10, Color3.fromRGB(255,255,255)),
			dispname= _mkText(13, Color3.fromRGB(255,255,255)),
			username= _mkText(11, Color3.fromRGB(180,200,220)),
			dist    = _mkText(11, Color3.fromRGB(160,180,210)),
			weapon  = _mkText(11, Color3.fromRGB(90, 160, 255)),
			tracer  = _mkLine(1.2, Color3.fromRGB(90, 160, 255)),
			masak   = _mkText(13, Color3.fromRGB(0,255,120)),
			corners = _c,
			skeleton= _sk,
		}
		e.box.Thickness=1.5; e.box.Filled=false
		e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
		e.hpbar.Thickness=1; e.hpbar.Filled=true
		ESP[p] = e
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Running = false
		for p in pairs(ESP) do removeESP(p) end
		FovCircle:Remove()
		SilentFovCircle:Remove()
		SilentLine:Remove()
		Gui:Destroy()
	end)

	local TOGGLE_LABELS = {
		BoxESP="Box ESP", Tracer="Tracer",
		TPNoClip="Blink TP", AimLock="Auto Aim",
		WallCheck="Wall Check",
		InvScan="Inv Scan", InstantInteract="Instant Interact",
		InfStamina="Inf Stamina", HybridSpeed="Speed Hack", AuraKill="NoClip",
	}

	-- TOGGLE BAR (modern pill style)
	local function AddToggleBar(parent, flagName, accentColor)
		local ACCENT = accentColor or T.AccOn
		local isOn = Flags[flagName]

		local bar = Instance.new("TextButton", parent)
		bar.Name = "HNDRIXX_TOGGLE_"..flagName
		bar.Size = UDim2.new(1, 0, 0, 38)
		bar.BackgroundColor3 = isOn and Color3.fromRGB(24, 34, 58) or T.Card
		bar.Text = ""
		bar.AutoButtonColor = false
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)
		local bStr = Instance.new("UIStroke", bar)
		bStr.Color = isOn and T.StrokeOn or T.Stroke
		bStr.Thickness = 1

		local dot = Instance.new("Frame", bar)
		dot.Size = UDim2.new(0, 6, 0, 6)
		dot.Position = UDim2.new(0, 14, 0.5, -3)
		dot.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(55, 65, 90)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local nameLbl = Instance.new("TextLabel", bar)
		nameLbl.Size = UDim2.new(1, -80, 1, 0)
		nameLbl.Position = UDim2.new(0, 28, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = TOGGLE_LABELS[flagName] or flagName
		nameLbl.TextColor3 = isOn and T.Text or T.TextDim
		nameLbl.Font = Enum.Font.Gotham
		nameLbl.TextSize = 14
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local statusPill = Instance.new("Frame", bar)
		statusPill.Size = UDim2.new(0, 48, 0, 22)
		statusPill.Position = UDim2.new(1, -54, 0.5, -11)
		statusPill.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(24, 32, 52)
		Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
		if not isOn then Instance.new("UIStroke", statusPill).Color = T.Stroke end

		local statusLbl = Instance.new("TextLabel", statusPill)
		statusLbl.Size = UDim2.new(1, 0, 1, 0)
		statusLbl.BackgroundTransparency = 1
		statusLbl.Text = isOn and "ON" or "OFF"
		statusLbl.TextColor3 = isOn and Color3.fromRGB(255, 255, 255) or T.TextDim
		statusLbl.Font = Enum.Font.GothamBlack
		statusLbl.TextSize = 12

		local function refresh()
			local on = Flags[flagName]
			bar.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or T.Card
			bStr.Color = on and T.StrokeOn or T.Stroke
			dot.BackgroundColor3 = on and ACCENT or Color3.fromRGB(55, 65, 90)
			nameLbl.TextColor3 = on and T.Text or T.TextDim
			statusPill.BackgroundColor3 = on and ACCENT or Color3.fromRGB(24, 32, 52)
			statusLbl.Text = on and "ON" or "OFF"
			statusLbl.TextColor3 = on and Color3.fromRGB(255, 255, 255) or T.TextDim
			local st = statusPill:FindFirstChildOfClass("UIStroke")
			if on then if st then st:Destroy() end
			else if not st then Instance.new("UIStroke", statusPill).Color = T.Stroke end end
		end

		bar.MouseButton1Click:Connect(function()
			Flags[flagName] = not Flags[flagName]
			refresh()
			saveSettings()
		end)

		return bar
	end

	-- SLIDER (modern)
	local function AddSlider(parent, label, minV, maxV, defV, suffix, onChange)
		local c = Instance.new("Frame", parent)
		c.Size = UDim2.new(1, 0, 0, 52)
		c.BackgroundColor3 = T.Card
		Instance.new("UICorner", c).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", c).Color = T.Stroke

		local lbl = Instance.new("TextLabel", c)
		lbl.Size = UDim2.new(1, -12, 0, 18)
		lbl.Position = UDim2.new(0, 12, 0, 8)
		lbl.BackgroundTransparency=1
		lbl.TextXAlignment=Enum.TextXAlignment.Left
		lbl.Font=Enum.Font.Gotham
		lbl.TextSize=13
		lbl.TextColor3=T.TextDim
		lbl.Text=label..": "..defV..suffix

		local track = Instance.new("Frame", c)
		track.Size = UDim2.new(1, -24, 0, 5)
		track.Position = UDim2.new(0, 12, 0, 36)
		track.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", track).Color = T.Stroke

		local fill = Instance.new("Frame", track)
		fill.Size = UDim2.new((defV-minV)/(maxV-minV), 0, 1, 0)
		fill.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame", track)
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.Position = UDim2.new((defV-minV)/(maxV-minV), -7, 0.5, -7)
		knob.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", knob).Color = T.StrokeOn

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
			if inp.UserInputType==Enum.UserInputType.MouseButton1
			or inp.UserInputType==Enum.UserInputType.Touch then
				dragging=true
				update(inp.Position)
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement
			or inp.UserInputType==Enum.UserInputType.Touch) then
				update(inp.Position)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton1
			or inp.UserInputType==Enum.UserInputType.Touch then
				dragging=false
			end
		end)
		return c
	end

	-- ============================================================
	-- MAIN PAGE BUILDER
	-- ============================================================
	_buildMain = function()
		local HPPanel = Instance.new("Frame", Gui)
		HPPanel.Name = "DARKHUB_HPPanel"
		HPPanel.Size = UDim2.new(0, 58, 0, 58)
		HPPanel.Position = UDim2.new(0, 16, 0.5, -29)
		HPPanel.BackgroundColor3 = Color3.fromRGB(14, 18, 30)
		HPPanel.Active = true
		HPPanel.Visible = false
		HPPanel.ZIndex = 100
		Instance.new("UICorner", HPPanel).CornerRadius = UDim.new(0, 14)
		local hpStr = Instance.new("UIStroke", HPPanel)
		hpStr.Color = T.StrokeOn
		hpStr.Thickness = 1.5

		local HPTBtn = Instance.new("TextButton", HPPanel)
		HPTBtn.Size = UDim2.new(1, -10, 1, -10)
		HPTBtn.Position = UDim2.new(0, 5, 0, 5)
		HPTBtn.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
		HPTBtn.Text = "T"
		HPTBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		HPTBtn.Font = Enum.Font.GothamBlack
		HPTBtn.TextSize = 22
		HPTBtn.AutoButtonColor = false
		HPTBtn.ZIndex = 101
		Instance.new("UICorner", HPTBtn).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", HPTBtn).Color = T.Stroke

		local HPTLabel = Instance.new("TextLabel", HPPanel)
		HPTLabel.Size = UDim2.new(1, 0, 0, 12)
		HPTLabel.Position = UDim2.new(0, 0, 1, -13)
		HPTLabel.BackgroundTransparency = 1
		HPTLabel.Text = "BLINK"
		HPTLabel.TextColor3 = T.AccOn
		HPTLabel.Font = Enum.Font.GothamBlack
		HPTLabel.TextSize = 9
		HPTLabel.ZIndex = 102

		do
			local hpDragging = false
			local hpDragStart, hpStartPos
			HPPanel.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1
				or inp.UserInputType == Enum.UserInputType.Touch then
					hpDragging = true
					hpDragStart = inp.Position
					hpStartPos = HPPanel.Position
					inp.Changed:Connect(function()
						if inp.UserInputState == Enum.UserInputState.End then
							hpDragging = false
						end
					end)
				end
			end)
			UIS.InputChanged:Connect(function(inp)
				if hpDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
				or inp.UserInputType == Enum.UserInputType.Touch) then
					local delta = inp.Position - hpDragStart
					HPPanel.Position = UDim2.new(
					hpStartPos.X.Scale, hpStartPos.X.Offset + delta.X,
					hpStartPos.Y.Scale, hpStartPos.Y.Offset + delta.Y
					)
				end
			end)
			UIS.InputEnded:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1
				or inp.UserInputType == Enum.UserInputType.Touch then
					hpDragging = false
				end
			end)
		end

		HPTBtn.MouseButton1Click:Connect(function()
			if not Flags.TPNoClip then return end
			local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				HPTBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 140)
				TweenService:Create(HPTBtn,
				TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(19, 24, 40)}):Play()
				TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
				{CFrame = hrp.CFrame * CFrame.new(0, 0, -6)}):Play()
			end
		end)

		local function updateHPPanel()
			HPPanel.Visible = (BlinkMode == "HP" and Flags.TPNoClip)
		end

		-- VISUAL PAGE toggles
		local VISUAL_ORDER = {
			"BoxESP","Tracer",
			"ESPName","ESPDist","ESPHPBar","ESPWeapon","ESPSkeleton","ESPMasak",
		}
		TOGGLE_LABELS.ESPName="Name"
		TOGGLE_LABELS.ESPDist="Distance"
		TOGGLE_LABELS.ESPHPBar="HP Bar"
		TOGGLE_LABELS.ESPWeapon="GUN"
		TOGGLE_LABELS.ESPSkeleton="Skeleton"
		TOGGLE_LABELS.ESPMasak="Masak"
		for i, flag in ipairs(VISUAL_ORDER) do
			local b=AddToggleBar(PageVisual,flag)
			b.LayoutOrder=i
			if flag=="BoxESP" then
				local modes={"FULL","CORNER"}
				local mp=Instance.new("TextButton",b)
				mp.Size=UDim2.new(0,60,0,22)
				mp.Position=UDim2.new(1,-116,0.5,-11)
				mp.BackgroundColor3=Color3.fromRGB(24, 32, 52)
				mp.Text=BoxESPMode
				mp.TextColor3=T.AccOn
				mp.Font=Enum.Font.GothamBlack
				mp.TextSize=11
				mp.AutoButtonColor=false
				mp.ZIndex=2
				Instance.new("UICorner",mp).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp).Color=T.Stroke
				mp.MouseButton1Click:Connect(function()
					local idx=1
					for i2,m in ipairs(modes) do if m==BoxESPMode then idx=i2
							break end end
					BoxESPMode=modes[(idx%#modes)+1]
					mp.Text=BoxESPMode
				end)
			end
			if flag == "TPNoClip" then
				local modeBtn = Instance.new("TextButton", b)
				modeBtn.Size = UDim2.new(0, 42, 0, 22)
				modeBtn.Position = UDim2.new(1, -108, 0.5, -11)
				modeBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
				modeBtn.Text = BlinkMode
				modeBtn.TextColor3 = T.AccOn
				modeBtn.Font = Enum.Font.GothamBlack
				modeBtn.TextSize = 12
				modeBtn.AutoButtonColor = false
				modeBtn.ZIndex = 2
				Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(1, 0)
				Instance.new("UIStroke", modeBtn).Color = T.Stroke

				modeBtn.MouseButton1Click:Connect(function()
					BlinkMode = BlinkMode == "PC" and "HP" or "PC"
					modeBtn.Text = BlinkMode
					modeBtn.TextColor3 = BlinkMode == "HP" and T.Text or T.TextDim
					updateHPPanel()
				end)

				b.MouseButton1Click:Connect(function()
					task.defer(updateHPPanel)
				end)
			end
		end

		do
			local s = AddSlider(PageVisual, "Tracer Distance", 50, 1000, TracerMaxDist, "studs", function(v)
				TracerMaxDist = v
			end)
			s.LayoutOrder = 99
		end
		do
			local s2 = AddSlider(PageVisual, "ESP Distance", 10, 5000, ESPMaxDist, "studs", function(v)
				ESPMaxDist = v
			end)
			s2.LayoutOrder = 100
		end

		-- ============================================================
		-- SPECTATE — VISUAL PAGE
		-- ============================================================
		do
			local specTarget = nil
			local specConn = nil
			local specRows = {}
			local specListOpen = false

			local specHdr = Instance.new("TextButton", PageVisual)
			specHdr.Size = UDim2.new(1, 0, 0, 36)
			specHdr.BackgroundColor3 = T.Card
			specHdr.Text = ""
			specHdr.AutoButtonColor = false
			specHdr.LayoutOrder = 110
			Instance.new("UICorner", specHdr).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", specHdr).Color = T.Stroke

			local specTitleLbl = Instance.new("TextLabel", specHdr)
			specTitleLbl.Size = UDim2.new(1, -110, 1, 0)
			specTitleLbl.Position = UDim2.new(0, 14, 0, 0)
			specTitleLbl.BackgroundTransparency = 1
			specTitleLbl.Text = "Spectate Player"
			specTitleLbl.TextColor3 = T.TextDim
			specTitleLbl.Font = Enum.Font.GothamBlack
			specTitleLbl.TextSize = 14
			specTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local specArrow = Instance.new("TextLabel", specHdr)
			specArrow.Size = UDim2.new(0, 24, 1, 0)
			specArrow.Position = UDim2.new(1, -28, 0, 0)
			specArrow.BackgroundTransparency = 1
			specArrow.Text = "v"
			specArrow.TextColor3 = T.TextDim
			specArrow.Font = Enum.Font.GothamBlack
			specArrow.TextSize = 14

			local specStatusBar = Instance.new("Frame", PageVisual)
			specStatusBar.Size = UDim2.new(1, 0, 0, 28)
			specStatusBar.BackgroundColor3 = Color3.fromRGB(20, 30, 52)
			specStatusBar.Visible = false
			specStatusBar.LayoutOrder = 111
			Instance.new("UICorner", specStatusBar).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", specStatusBar).Color = T.StrokeOn

			local specNowLbl = Instance.new("TextLabel", specStatusBar)
			specNowLbl.Size = UDim2.new(1, -80, 1, 0)
			specNowLbl.Position = UDim2.new(0, 10, 0, 0)
			specNowLbl.BackgroundTransparency = 1
			specNowLbl.Text = "Spectating: —"
			specNowLbl.TextColor3 = T.AccOn
			specNowLbl.Font = Enum.Font.GothamBlack
			specNowLbl.TextSize = 12
			specNowLbl.TextXAlignment = Enum.TextXAlignment.Left

			local specStopBtn = Instance.new("TextButton", specStatusBar)
			specStopBtn.Size = UDim2.new(0, 60, 0, 20)
			specStopBtn.AnchorPoint = Vector2.new(1, 0.5)
			specStopBtn.Position = UDim2.new(1, -4, 0.5, 0)
			specStopBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
			specStopBtn.Text = "Stop"
			specStopBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
			specStopBtn.Font = Enum.Font.GothamBlack
			specStopBtn.TextSize = 11
			specStopBtn.AutoButtonColor = false
			Instance.new("UICorner", specStopBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", specStopBtn).Color = Color3.fromRGB(100, 25, 25)

			local specCont = Instance.new("Frame", PageVisual)
			specCont.Size = UDim2.new(1, 0, 0, 0)
			specCont.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
			specCont.ClipsDescendants = true
			specCont.LayoutOrder = 112
			Instance.new("UICorner", specCont).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", specCont).Color = T.Stroke

			local specLayout = Instance.new("UIListLayout", specCont)
			specLayout.Padding = UDim.new(0, 2)
			specLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local specPad = Instance.new("UIPadding", specCont)
			specPad.PaddingTop = UDim.new(0, 4)
			specPad.PaddingBottom = UDim.new(0, 4)
			specPad.PaddingLeft = UDim.new(0, 4)
			specPad.PaddingRight = UDim.new(0, 4)

			local function stopSpectate()
				if specConn then specConn:Disconnect()
					specConn = nil end
				specTarget = nil
				local cam = workspace.CurrentCamera
				pcall(function()
					cam.CameraType = Enum.CameraType.Custom
					cam.CameraSubject = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				end)
				specStatusBar.Visible = false
				specNowLbl.Text = "Spectating: —"
				for _, row in ipairs(specRows) do
					if row and row.Parent then
						row.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
						local str = row:FindFirstChildOfClass("UIStroke")
						if str then str.Color = T.Stroke end
						local pill = row:FindFirstChild("SpecPill")
						if pill then
							pill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
							local lbl = pill:FindFirstChildOfClass("TextLabel")
							if lbl then lbl.Text = "SPEC"
								lbl.TextColor3 = T.TextDim end
						end
					end
				end
			end

			local function startSpectate(targetPlr, row)
				stopSpectate()
				if not targetPlr or not targetPlr.Character then return end
				specTarget = targetPlr
				local cam = workspace.CurrentCamera
				pcall(function()
					local hum = targetPlr.Character:FindFirstChildOfClass("Humanoid")
					cam.CameraType = Enum.CameraType.Custom
					cam.CameraSubject = hum
				end)
				specConn = RunService.RenderStepped:Connect(function()
					if not specTarget or not specTarget.Parent then stopSpectate()
						return end
					local char = specTarget.Character
					if not char then return end
					local hum = char:FindFirstChildOfClass("Humanoid")
					if cam.CameraType ~= Enum.CameraType.Custom then
						cam.CameraType = Enum.CameraType.Custom
					end
					if hum and cam.CameraSubject ~= hum then
						cam.CameraSubject = hum
					end
				end)
				specNowLbl.Text = "Spectating: " .. targetPlr.Name
				specStatusBar.Visible = true
				if row then
					row.BackgroundColor3 = Color3.fromRGB(20, 40, 70)
					local str = row:FindFirstChildOfClass("UIStroke")
					if str then str.Color = T.AccOn end
					local pill = row:FindFirstChild("SpecPill")
					if pill then
						pill.BackgroundColor3 = T.AccOn
						local lbl = pill:FindFirstChildOfClass("TextLabel")
						if lbl then lbl.Text = "ON"
							lbl.TextColor3 = Color3.fromRGB(255,255,255) end
					end
				end
			end

			specStopBtn.MouseButton1Click:Connect(stopSpectate)

			local ROW_H = 32
			local function buildSpecList()
				for _, r in ipairs(specRows) do
					if r and r.Parent then r:Destroy() end
				end
				specRows = {}
				local allPlrs = game.Players:GetPlayers()
				for _, p in ipairs(allPlrs) do
					if p == plr then continue end
					local row = Instance.new("TextButton", specCont)
					row.Name = "SpecRow_" .. p.Name
					row.Size = UDim2.new(1, 0, 0, ROW_H)
					row.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
					row.Text = ""
					row.AutoButtonColor = false
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
					local rowStr = Instance.new("UIStroke", row)
					rowStr.Color = T.Stroke

					local avatarBox = Instance.new("Frame", row)
					avatarBox.Size = UDim2.new(0, 22, 0, 22)
					avatarBox.Position = UDim2.new(0, 4, 0.5, -11)
					avatarBox.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
					Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(1, 0)
					local avatarLbl = Instance.new("TextLabel", avatarBox)
					avatarLbl.Size = UDim2.new(1,0,1,0)
					avatarLbl.BackgroundTransparency = 1
					avatarLbl.Text = string.sub(p.Name, 1, 1):upper()
					avatarLbl.TextColor3 = T.AccOn
					avatarLbl.Font = Enum.Font.GothamBlack
					avatarLbl.TextSize = 12

					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(1, -90, 0, 14)
					nameLbl.Position = UDim2.new(0, 30, 0, 4)
					nameLbl.BackgroundTransparency = 1
					nameLbl.Text = p.Name
					nameLbl.TextColor3 = T.Text
					nameLbl.Font = Enum.Font.GothamBlack
					nameLbl.TextSize = 12
					nameLbl.TextXAlignment = Enum.TextXAlignment.Left
					nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

					local hpTrack = Instance.new("Frame", row)
					hpTrack.Size = UDim2.new(1, -94, 0, 3)
					hpTrack.Position = UDim2.new(0, 30, 0, 22)
					hpTrack.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
					Instance.new("UICorner", hpTrack).CornerRadius = UDim.new(1, 0)
					local hpFill = Instance.new("Frame", hpTrack)
					hpFill.Size = UDim2.new(1, 0, 1, 0)
					hpFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
					Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

					task.spawn(function()
						while row and row.Parent do
							pcall(function()
								local ch = p.Character
								local hum = ch and ch:FindFirstChildOfClass("Humanoid")
								if hum and hum.MaxHealth > 0 then
									local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
									hpFill.Size = UDim2.new(ratio, 0, 1, 0)
									hpFill.BackgroundColor3 = Color3.fromRGB(
									math.floor(255 * (1 - ratio)),
									math.floor(200 * ratio), 30)
								end
							end)
							task.wait(0.5)
						end
					end)

					local pill = Instance.new("Frame", row)
					pill.Name = "SpecPill"
					pill.Size = UDim2.new(0, 46, 0, 20)
					pill.AnchorPoint = Vector2.new(1, 0.5)
					pill.Position = UDim2.new(1, -4, 0.5, 0)
					pill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
					Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
					Instance.new("UIStroke", pill).Color = T.Stroke
					local pillLbl = Instance.new("TextLabel", pill)
					pillLbl.Size = UDim2.new(1,0,1,0)
					pillLbl.BackgroundTransparency = 1
					pillLbl.Text = "SPEC"
					pillLbl.TextColor3 = T.TextDim
					pillLbl.Font = Enum.Font.GothamBlack
					pillLbl.TextSize = 10

					local capturedP = p
					local capturedRow = row
					row.MouseButton1Click:Connect(function()
						if specTarget == capturedP then
							stopSpectate()
						else
							startSpectate(capturedP, capturedRow)
						end
					end)
					table.insert(specRows, row)
				end

				local refRow = Instance.new("TextButton", specCont)
				refRow.Size = UDim2.new(1, 0, 0, 26)
				refRow.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
				refRow.Text = "↻ Refresh List"
				refRow.TextColor3 = T.AccOn
				refRow.Font = Enum.Font.GothamBlack
				refRow.TextSize = 11
				refRow.AutoButtonColor = false
				Instance.new("UICorner", refRow).CornerRadius = UDim.new(0, 8)
				refRow.MouseButton1Click:Connect(function()
					buildSpecList()
					local count = math.max(#specRows, 0)
					if specListOpen then
						local newH = count * (ROW_H + 2) + 36
						TweenService:Create(specCont, TweenInfo.new(0.15), {Size=UDim2.new(1,0,0,newH)}):Play()
					end
				end)
				table.insert(specRows, refRow)

				local pCount = #game.Players:GetPlayers() - 1
				specTitleLbl.Text = "Spectate Player (" .. pCount .. ")"
			end

			specHdr.MouseButton1Click:Connect(function()
				specListOpen = not specListOpen
				if specListOpen then
					buildSpecList()
					local count = math.max(#specRows - 1, 0)
					local newH = count * (ROW_H + 2) + 36
					TweenService:Create(specCont, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Size = UDim2.new(1, 0, 0, newH)}):Play()
					specArrow.Text = "^"
					specTitleLbl.TextColor3 = T.Text
					specHdr.BackgroundColor3 = Color3.fromRGB(24, 34, 58)
					specHdr:FindFirstChildOfClass("UIStroke").Color = T.AccOn
				else
					TweenService:Create(specCont, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{Size = UDim2.new(1, 0, 0, 0)}):Play()
					specArrow.Text = "v"
					specTitleLbl.TextColor3 = T.TextDim
					specHdr.BackgroundColor3 = T.Card
					specHdr:FindFirstChildOfClass("UIStroke").Color = T.Stroke
				end
			end)

			game.Players.PlayerRemoving:Connect(function(p)
				if specTarget == p then stopSpectate() end
				if specListOpen then
					task.wait(0.1)
					buildSpecList()
					local count = math.max(#specRows - 1, 0)
					local newH = count * (ROW_H + 2) + 36
					TweenService:Create(specCont, TweenInfo.new(0.1), {Size=UDim2.new(1,0,0,newH)}):Play()
				end
			end)
			game.Players.PlayerAdded:Connect(function()
				if specListOpen then
					task.wait(0.5)
					buildSpecList()
					local count = math.max(#specRows - 1, 0)
					local newH = count * (ROW_H + 2) + 36
					TweenService:Create(specCont, TweenInfo.new(0.1), {Size=UDim2.new(1,0,0,newH)}):Play()
				end
			end)
		end

		-- ============================================================
		-- MAIN PAGE toggles
		-- ============================================================
		local WAR_ORDER = {
			"InstantInteract","InvScan","TPNoClip",
			"InfStamina","HybridSpeed","AuraKill",
		}
		for i, flag in ipairs(WAR_ORDER) do
			local b = AddToggleBar(PageWar, flag)
			b.LayoutOrder = i
			if flag=="TPNoClip" then
				local mp2=Instance.new("TextButton",b)
				mp2.Size=UDim2.new(0,42,0,22)
				mp2.Position=UDim2.new(1,-108,0.5,-11)
				mp2.BackgroundColor3=Color3.fromRGB(24, 32, 52)
				mp2.Text=BlinkMode
				mp2.TextColor3=T.AccOn
				mp2.Font=Enum.Font.GothamBlack
				mp2.TextSize=12
				mp2.AutoButtonColor=false
				mp2.ZIndex=2
				Instance.new("UICorner",mp2).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp2).Color=T.Stroke

				local panelLocked = false
				local lockBtn = Instance.new("TextButton", b)
				lockBtn.Size = UDim2.new(0, 42, 0, 22)
				lockBtn.Position = UDim2.new(1, -156, 0.5, -11)
				lockBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
				lockBtn.Text = "LOCK"
				lockBtn.TextColor3 = T.TextDim
				lockBtn.Font = Enum.Font.GothamBlack
				lockBtn.TextSize = 11
				lockBtn.AutoButtonColor = false
				lockBtn.ZIndex = 2
				lockBtn.Visible = (BlinkMode == "HP")
				Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
				local lockBtnStr = Instance.new("UIStroke", lockBtn)
				lockBtnStr.Color = T.Stroke

				lockBtn.MouseButton1Click:Connect(function()
					panelLocked = not panelLocked
					if panelLocked then
						lockBtn.BackgroundColor3 = Color3.fromRGB(15, 40, 20)
						lockBtn.TextColor3 = Color3.fromRGB(80, 220, 80)
						lockBtnStr.Color = Color3.fromRGB(40, 100, 40)
						lockBtn.Text = "LOCKED"
						HPPanel.Active = false
					else
						lockBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
						lockBtn.TextColor3 = T.TextDim
						lockBtnStr.Color = T.Stroke
						lockBtn.Text = "LOCK"
						HPPanel.Active = true
					end
				end)

				mp2.MouseButton1Click:Connect(function()
					BlinkMode=BlinkMode=="PC" and "HP" or "PC"
					mp2.Text=BlinkMode
					mp2.TextColor3=BlinkMode=="HP" and T.Text or T.TextDim
					lockBtn.Visible = (BlinkMode == "HP")
					if BlinkMode == "PC" and panelLocked then
						panelLocked = false
						lockBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
						lockBtn.TextColor3 = T.TextDim
						lockBtnStr.Color = T.Stroke
						lockBtn.Text = "LOCK"
						HPPanel.Active = true
					end
					updateHPPanel()
				end)
				b.MouseButton1Click:Connect(function() task.defer(updateHPPanel) end)
			end
		end

		-- Reduce Grafik toggle
		do
			local rgBar = Instance.new("TextButton", PageWar)
			rgBar.Size = UDim2.new(1, 0, 0, 56)
			rgBar.BackgroundColor3 = Color3.fromRGB(30, 12, 20)
			rgBar.Text = ""
			rgBar.AutoButtonColor = false
			rgBar.LayoutOrder = 50
			Instance.new("UICorner", rgBar).CornerRadius = UDim.new(0, 10)
			local rgStr = Instance.new("UIStroke", rgBar)
			rgStr.Color = Color3.fromRGB(90, 30, 45)
			rgStr.Thickness = 1

			local rgDot = Instance.new("Frame", rgBar)
			rgDot.Size=UDim2.new(0,5,0,5)
			rgDot.Position=UDim2.new(0,14,0.35,-2.5)
			rgDot.BackgroundColor3=Color3.fromRGB(220,50,80)
			Instance.new("UICorner",rgDot).CornerRadius=UDim.new(1,0)

			local rgName = Instance.new("TextLabel", rgBar)
			rgName.Size=UDim2.new(1,-80,0,20)
			rgName.Position=UDim2.new(0,28,0,6)
			rgName.BackgroundTransparency=1
			rgName.Text="Reduce Grafik"
			rgName.TextColor3=Color3.fromRGB(230,90,120)
			rgName.Font=Enum.Font.GothamBlack
			rgName.TextSize=14
			rgName.TextXAlignment=Enum.TextXAlignment.Left

			local rgWarn = Instance.new("TextLabel", rgBar)
			rgWarn.Size=UDim2.new(1,-80,0,16)
			rgWarn.Position=UDim2.new(0,28,0,28)
			rgWarn.BackgroundTransparency=1
			rgWarn.Text="Perlu rejoin untuk mengembalikan"
			rgWarn.TextColor3=Color3.fromRGB(150,50,70)
			rgWarn.Font=Enum.Font.Gotham
			rgWarn.TextSize=11
			rgWarn.TextXAlignment=Enum.TextXAlignment.Left

			local rgPill = Instance.new("Frame", rgBar)
			rgPill.Size=UDim2.new(0,48,0,22)
			rgPill.Position=UDim2.new(1,-54,0.5,-11)
			rgPill.BackgroundColor3=Color3.fromRGB(50,15,25)
			Instance.new("UICorner",rgPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke",rgPill).Color=Color3.fromRGB(90,25,40)
			local rgPillLbl=Instance.new("TextLabel",rgPill)
			rgPillLbl.Size=UDim2.new(1,0,1,0)
			rgPillLbl.BackgroundTransparency=1
			rgPillLbl.Text="OFF"
			rgPillLbl.TextColor3=Color3.fromRGB(150,50,70)
			rgPillLbl.Font=Enum.Font.GothamBlack
			rgPillLbl.TextSize=12

			local rgActive = false
			rgBar.MouseButton1Click:Connect(function()
				if rgActive then return end
				rgActive = true
				rgPill.BackgroundColor3=Color3.fromRGB(180,30,60)
				rgPillLbl.Text="ON"
				rgPillLbl.TextColor3=Color3.fromRGB(255,255,255)
				rgStr.Color=Color3.fromRGB(180,50,80)
				rgBar.BackgroundColor3=Color3.fromRGB(50,15,25)
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
					local localChar = game.Players.LocalPlayer and game.Players.LocalPlayer.Character
					local function handleInstance(instance)
						if instance:IsA("BasePart") then
							if localChar and instance:IsDescendantOf(localChar) then return end
							pcall(function()
								instance.Material = Enum.Material.SmoothPlastic
								instance.Reflectance = 0
							end)
						end
						if instance:IsA("Texture") or instance:IsA("Decal") then
							if localChar and instance:IsDescendantOf(localChar) then return end
							pcall(function() instance.Transparency = 1 end)
						end
					end
					local all = workspace:GetDescendants()
					local chunk = 100
					for i = 1, #all, chunk do
						for j = i, math.min(i + chunk - 1, #all) do
							pcall(function() handleInstance(all[j]) end)
						end
						task.wait()
					end
					pcall(function()
						local terrain = workspace:FindFirstChild("Terrain")
						if terrain then
							terrain.WaterWaveSize = 0
							terrain.WaveSpeed = 0
							terrain.WaterReflectance = 0
							terrain.WaterTransparency = 1
						end
					end)
					pcall(function()
						settings().Physics.AllowSleep = true
						settings().Rendering.QualityLevel = 1
						settings().Rendering.EagerBulkExecution = false
						settings().Rendering.TextureQuality = Enum.TextureQuality.Low
					end)
				end)
			end)
		end

		-- ============================================================
		-- WALL SELECTOR
		-- ============================================================
		do
			local wsSelectMode = false
			local wsSelected = {}
			local wsDisabled = {}
			local wsHighlights = {}

			local lp2 = game.Players.LocalPlayer
			local mouse2 = lp2:GetMouse()
			local cam2 = workspace.CurrentCamera

			local wsHoverBox = Instance.new("SelectionBox", workspace)
			wsHoverBox.Color3 = Color3.fromRGB(90, 160, 255)
			wsHoverBox.LineThickness = 0.05
			wsHoverBox.SurfaceTransparency = 0.88
			wsHoverBox.SurfaceColor3 = Color3.fromRGB(90, 160, 255)

			local function wsGetTarget()
				local unitRay = cam2:ScreenPointToRay(mouse2.X, mouse2.Y)
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				local chars = {}
				for _, p in ipairs(game.Players:GetPlayers()) do
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
				b.Color3 = Color3.fromRGB(90, 160, 255)
				b.LineThickness = 0.07
				b.SurfaceTransparency = 0.75
				b.SurfaceColor3 = Color3.fromRGB(90, 160, 255)
				wsHighlights[part] = b
			end

			local function wsRemoveHL(part)
				if wsHighlights[part] then
					wsHighlights[part]:Destroy()
					wsHighlights[part] = nil
				end
			end

			local wsCountLbl, wsStatusDot, wsStatusLbl, wsGuideCard

			local function wsUpdateUI()
				local s, d = 0, 0
				for _ in pairs(wsSelected) do s += 1 end
				for _ in pairs(wsDisabled) do d += 1 end
				if wsCountLbl then
					wsCountLbl.Text = "Selected: " .. s .. "Disabled: " .. d
				end
				if wsSelectMode then
					if wsStatusDot then wsStatusDot.BackgroundColor3 = T.AccOn end
					if wsStatusLbl then
						wsStatusLbl.Text = "Klik part untuk di-select"
						wsStatusLbl.TextColor3 = T.AccOn
					end
					if wsGuideCard then wsGuideCard.Visible = true end
				else
					if wsStatusDot then wsStatusDot.BackgroundColor3 = T.TextDim end
					if wsStatusLbl then
						wsStatusLbl.Text = "Tekan [P] atau toggle ON"
						wsStatusLbl.TextColor3 = T.TextDim
					end
					if wsGuideCard then wsGuideCard.Visible = false end
				end
			end

			local function wsDoSelect(part)
				if not part or not part:IsA("BasePart") then return end
				local anc = part.Parent
				while anc do
					if anc:IsA("Model") and anc:FindFirstChildOfClass("Humanoid") then return end
					anc = anc.Parent
				end
				if wsSelected[part] then
					wsSelected[part] = nil
					wsRemoveHL(part)
				else
					wsSelected[part] = true
					wsAddHL(part)
				end
				wsUpdateUI()
			end

			local function wsDoDisable()
				for part in pairs(wsSelected) do
					if part and part.Parent then
						wsDisabled[part] = {
							trans = part.Transparency,
							collide = part.CanCollide,
							shadow = part.CastShadow,
						}
						pcall(function()
							part.Transparency = 0.9
							part.CanCollide = false
							part.CastShadow = false
						end)
						wsRemoveHL(part)
					end
				end
				wsSelected = {}
				wsUpdateUI()
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
				wsUpdateUI()
			end

			local function wsDoClr()
				for part in pairs(wsSelected) do wsRemoveHL(part) end
				wsSelected = {}
				wsHoverBox.Adornee = nil
				wsUpdateUI()
			end

			RunService.RenderStepped:Connect(function()
				if not wsSelectMode then wsHoverBox.Adornee = nil
					return end
				local t = wsGetTarget()
				wsHoverBox.Adornee = (t and not wsSelected[t]) and t or nil
			end)

			mouse2.Button1Down:Connect(function()
				if not wsSelectMode then return end
				local t = wsGetTarget()
				if t then wsDoSelect(t) end
			end)

			UIS.InputBegan:Connect(function(inp, gpe)
				if gpe then return end
				if inp.KeyCode == Enum.KeyCode.P then
					wsSelectMode = not wsSelectMode
					if not wsSelectMode then wsHoverBox.Adornee = nil end
					wsUpdateUI()
				elseif inp.KeyCode == Enum.KeyCode.M then
					wsDoDisable()
				elseif inp.KeyCode == Enum.KeyCode.L then
					wsDoRestore()
				elseif inp.KeyCode == Enum.KeyCode.K then
					wsDoClr()
				end
			end)

			local wsHdr = Instance.new("TextLabel", PageWar)
			wsHdr.Size = UDim2.new(1, 0, 0, 20)
			wsHdr.BackgroundTransparency = 1
			wsHdr.Text = "WALL SELECTOR"
			wsHdr.TextColor3 = T.TextDim
			wsHdr.Font = Enum.Font.GothamBlack
			wsHdr.TextSize = 11
			wsHdr.LayoutOrder = 60

			local wsBar = Instance.new("TextButton", PageWar)
			wsBar.Size = UDim2.new(1, 0, 0, 38)
			wsBar.BackgroundColor3 = T.Card
			wsBar.Text = ""
			wsBar.AutoButtonColor = false
			wsBar.LayoutOrder = 61
			Instance.new("UICorner", wsBar).CornerRadius = UDim.new(0, 10)
			local wsBarStr = Instance.new("UIStroke", wsBar)
			wsBarStr.Color = T.Stroke

			wsStatusDot = Instance.new("Frame", wsBar)
			wsStatusDot.Size = UDim2.new(0, 7, 0, 7)
			wsStatusDot.Position = UDim2.new(0, 14, 0.5, -3.5)
			wsStatusDot.BackgroundColor3 = T.TextDim
			Instance.new("UICorner", wsStatusDot).CornerRadius = UDim.new(1, 0)

			local wsBarName = Instance.new("TextLabel", wsBar)
			wsBarName.Size = UDim2.new(1, -120, 1, 0)
			wsBarName.Position = UDim2.new(0, 28, 0, 0)
			wsBarName.BackgroundTransparency = 1
			wsBarName.Text = "Wall Selector"
			wsBarName.TextColor3 = T.TextDim
			wsBarName.Font = Enum.Font.GothamBlack
			wsBarName.TextSize = 14
			wsBarName.TextXAlignment = Enum.TextXAlignment.Left

			local wsPill = Instance.new("Frame", wsBar)
			wsPill.Size = UDim2.new(0, 48, 0, 22)
			wsPill.AnchorPoint = Vector2.new(1, 0.5)
			wsPill.Position = UDim2.new(1, -8, 0.5, 0)
			wsPill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", wsPill).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", wsPill).Color = T.Stroke
			local wsPillLbl = Instance.new("TextLabel", wsPill)
			wsPillLbl.Size = UDim2.new(1, 0, 1, 0)
			wsPillLbl.BackgroundTransparency = 1
			wsPillLbl.Text = "OFF"
			wsPillLbl.TextColor3 = T.TextDim
			wsPillLbl.Font = Enum.Font.GothamBlack
			wsPillLbl.TextSize = 11

			wsBar.MouseButton1Click:Connect(function()
				wsSelectMode = not wsSelectMode
				if not wsSelectMode then wsHoverBox.Adornee = nil end
				local on = wsSelectMode
				wsBar.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or T.Card
				wsBarStr.Color = on and T.AccOn or T.Stroke
				wsBarName.TextColor3 = on and T.Text or T.TextDim
				wsPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(24, 32, 52)
				wsPillLbl.Text = on and "ON" or "OFF"
				wsPillLbl.TextColor3 = on and Color3.fromRGB(255,255,255) or T.TextDim
				wsUpdateUI()
			end)

			local wsInfoBar = Instance.new("Frame", PageWar)
			wsInfoBar.Size = UDim2.new(1, 0, 0, 24)
			wsInfoBar.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
			wsInfoBar.LayoutOrder = 62
			Instance.new("UICorner", wsInfoBar).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", wsInfoBar).Color = T.Stroke

			wsStatusLbl = Instance.new("TextLabel", wsInfoBar)
			wsStatusLbl.Size = UDim2.new(0.5, -4, 1, 0)
			wsStatusLbl.Position = UDim2.new(0, 8, 0, 0)
			wsStatusLbl.BackgroundTransparency = 1
			wsStatusLbl.Text = "Tekan [P] atau toggle ON"
			wsStatusLbl.TextColor3 = T.TextDim
			wsStatusLbl.Font = Enum.Font.Gotham
			wsStatusLbl.TextSize = 11
			wsStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

			wsCountLbl = Instance.new("TextLabel", wsInfoBar)
			wsCountLbl.Size = UDim2.new(0.5, -4, 1, 0)
			wsCountLbl.Position = UDim2.new(0.5, 0, 0, 0)
			wsCountLbl.BackgroundTransparency = 1
			wsCountLbl.Text = "Selected: 0 Disabled: 0"
			wsCountLbl.TextColor3 = T.AccOn
			wsCountLbl.Font = Enum.Font.GothamBlack
			wsCountLbl.TextSize = 10
			wsCountLbl.TextXAlignment = Enum.TextXAlignment.Right

			local wsActRow = Instance.new("Frame", PageWar)
			wsActRow.Size = UDim2.new(1, 0, 0, 28)
			wsActRow.BackgroundTransparency = 1
			wsActRow.LayoutOrder = 63

			local WS_ACTS = {
				{ label="[M] Disable", col=Color3.fromRGB(220,60,80), bg=Color3.fromRGB(30,10,20), fn=wsDoDisable },
				{ label="[L] Restore", col=Color3.fromRGB(60,210,140), bg=Color3.fromRGB(8,22,15), fn=wsDoRestore },
				{ label="[K] Clear", col=Color3.fromRGB(90, 160, 255), bg=Color3.fromRGB(8,20,35), fn=wsDoClr },
			}
			local btnW = 1/#WS_ACTS
			local gap = 0.008
			for i, act in ipairs(WS_ACTS) do
				local ab = Instance.new("TextButton", wsActRow)
				ab.Size = UDim2.new(btnW - gap, 0, 1, 0)
				ab.Position = UDim2.new((i-1)*btnW + gap/2, 0, 0, 0)
				ab.BackgroundColor3 = act.bg
				ab.Text = act.label
				ab.TextColor3 = act.col
				ab.Font = Enum.Font.GothamBlack
				ab.TextSize = 11
				ab.AutoButtonColor = false
				Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 8)
				local abStr = Instance.new("UIStroke", ab)
				abStr.Color = act.col
				abStr.Transparency = 0.7
				ab.MouseButton1Click:Connect(function()
					act.fn()
					local orig = ab.BackgroundColor3
					ab.BackgroundColor3 = act.col
					task.delay(0.12, function() ab.BackgroundColor3 = orig end)
				end)
			end

			wsGuideCard = Instance.new("Frame", PageWar)
			wsGuideCard.Size = UDim2.new(1, 0, 0, 90)
			wsGuideCard.BackgroundColor3 = Color3.fromRGB(14, 20, 36)
			wsGuideCard.Visible = false
			wsGuideCard.LayoutOrder = 64
			Instance.new("UICorner", wsGuideCard).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", wsGuideCard).Color = T.StrokeOn

			local guideTitle = Instance.new("TextLabel", wsGuideCard)
			guideTitle.Size = UDim2.new(1, -12, 0, 20)
			guideTitle.Position = UDim2.new(0, 8, 0, 2)
			guideTitle.BackgroundTransparency = 1
			guideTitle.Text = "Cara Pakai"
			guideTitle.TextColor3 = T.AccOn
			guideTitle.Font = Enum.Font.GothamBlack
			guideTitle.TextSize = 11
			guideTitle.TextXAlignment = Enum.TextXAlignment.Left

			local GUIDE_LINES = {
				{ key="[P] / Toggle", desc="Aktifkan / nonaktifkan select mode", col=T.AccOn },
				{ key="[Klik Part]", desc="Select/deselect part yang ditunjuk", col=T.Text },
				{ key="[M] Disable", desc="Sembunyikan semua part yang diselect", col=Color3.fromRGB(220,60,80) },
				{ key="[L] Restore", desc="Kembalikan semua part yang disembunyikan", col=Color3.fromRGB(60,210,140) },
				{ key="[K] Clear", desc="Bersihkan selection (gak restore)", col=Color3.fromRGB(90, 160, 255) },
			}
			for i, gl in ipairs(GUIDE_LINES) do
				local gr = Instance.new("Frame", wsGuideCard)
				gr.Size = UDim2.new(1, -12, 0, 13)
				gr.Position = UDim2.new(0, 8, 0, 18 + (i-1)*14)
				gr.BackgroundTransparency = 1

				local gk = Instance.new("TextLabel", gr)
				gk.Size = UDim2.new(0, 80, 1, 0)
				gk.BackgroundTransparency = 1
				gk.Text = gl.key
				gk.TextColor3 = gl.col
				gk.Font = Enum.Font.GothamBlack
				gk.TextSize = 10
				gk.TextXAlignment = Enum.TextXAlignment.Left

				local gv = Instance.new("TextLabel", gr)
				gv.Size = UDim2.new(1, -84, 1, 0)
				gv.Position = UDim2.new(0, 84, 0, 0)
				gv.BackgroundTransparency = 1
				gv.Text = gl.desc
				gv.TextColor3 = T.TextDim
				gv.Font = Enum.Font.Gotham
				gv.TextSize = 10
				gv.TextXAlignment = Enum.TextXAlignment.Left
			end

			wsUpdateUI()
		end

		-- ============================================================
		-- FAKE NAME
		-- ============================================================
		do
			local fnCard = Instance.new("TextButton", PageWar)
			fnCard.Size = UDim2.new(1, 0, 0, 120)
			fnCard.BackgroundColor3 = T.Card
			fnCard.Text = ""
			fnCard.AutoButtonColor = false
			fnCard.LayoutOrder = 70
			Instance.new("UICorner", fnCard).CornerRadius = UDim.new(0, 10)
			local fnStr = Instance.new("UIStroke", fnCard)
			fnStr.Color = T.Stroke

			local fnDot = Instance.new("Frame", fnCard)
			fnDot.Size = UDim2.new(0, 5, 0, 5)
			fnDot.Position = UDim2.new(0, 14, 0, 12)
			fnDot.BackgroundColor3 = T.AccOn
			Instance.new("UICorner", fnDot).CornerRadius = UDim.new(1, 0)

			local fnTitle = Instance.new("TextLabel", fnCard)
			fnTitle.Size = UDim2.new(1, -80, 0, 18)
			fnTitle.Position = UDim2.new(0, 28, 0, 4)
			fnTitle.BackgroundTransparency = 1
			fnTitle.Text = "Fake Name"
			fnTitle.TextColor3 = T.Text
			fnTitle.Font = Enum.Font.GothamBlack
			fnTitle.TextSize = 13
			fnTitle.TextXAlignment = Enum.TextXAlignment.Left

			local fnSub = Instance.new("TextLabel", fnCard)
			fnSub.Size = UDim2.new(1, -80, 0, 14)
			fnSub.Position = UDim2.new(0, 28, 0, 22)
			fnSub.BackgroundTransparency = 1
			fnSub.Text = "Ganti nametag in-game"
			fnSub.TextColor3 = T.TextDim
			fnSub.Font = Enum.Font.Gotham
			fnSub.TextSize = 11
			fnSub.TextXAlignment = Enum.TextXAlignment.Left

			local fnStatus = Instance.new("TextLabel", fnCard)
			fnStatus.Size = UDim2.new(1, -24, 0, 13)
			fnStatus.Position = UDim2.new(0, 12, 1, -17)
			fnStatus.BackgroundTransparency = 1
			fnStatus.Text = ""
			fnStatus.TextColor3 = T.Green
			fnStatus.Font = Enum.Font.GothamBlack
			fnStatus.TextSize = 11
			fnStatus.TextXAlignment = Enum.TextXAlignment.Left

			local fnInput1 = Instance.new("TextBox", fnCard)
			fnInput1.Size = UDim2.new(0, 130, 0, 24)
			fnInput1.Position = UDim2.new(0, 12, 0, 42)
			fnInput1.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			fnInput1.PlaceholderText = "In-Game Name..."
			fnInput1.PlaceholderColor3 = T.TextDim
			fnInput1.Text = ""
			fnInput1.TextColor3 = T.Text
			fnInput1.Font = Enum.Font.Gotham
			fnInput1.TextSize = 12
			fnInput1.ClearTextOnFocus = false
			Instance.new("UICorner", fnInput1).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", fnInput1).Color = T.Stroke

			local fnInput2 = Instance.new("TextBox", fnCard)
			fnInput2.Size = UDim2.new(0, 130, 0, 24)
			fnInput2.Position = UDim2.new(0, 12, 0, 72)
			fnInput2.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			fnInput2.PlaceholderText = "Username..."
			fnInput2.PlaceholderColor3 = T.TextDim
			fnInput2.Text = ""
			fnInput2.TextColor3 = T.Text
			fnInput2.Font = Enum.Font.Gotham
			fnInput2.TextSize = 12
			fnInput2.ClearTextOnFocus = false
			Instance.new("UICorner", fnInput2).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", fnInput2).Color = T.Stroke

			local fnApply = Instance.new("TextButton", fnCard)
			fnApply.Size = UDim2.new(0, 60, 0, 52)
			fnApply.Position = UDim2.new(1, -76, 0, 42)
			fnApply.BackgroundColor3 = Color3.fromRGB(28, 45, 85)
			fnApply.Text = "APPLY"
			fnApply.TextColor3 = T.AccOn
			fnApply.Font = Enum.Font.GothamBlack
			fnApply.TextSize = 12
			fnApply.AutoButtonColor = false
			Instance.new("UICorner", fnApply).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", fnApply).Color = T.StrokeOn

			local function setFnStatus(txt, col)
				fnStatus.Text = txt
				fnStatus.TextColor3 = col or T.Green
				task.delay(3, function() if fnStatus.Text == txt then fnStatus.Text = "" end end)
			end

			fnApply.MouseButton1Click:Connect(function()
				local ok = false
				pcall(function()
					local char = game.Players.LocalPlayer.Character
					local myChar = (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)) or char
					if not myChar then return end

					local name1 = fnInput1.Text
					local name2 = fnInput2.Text

					if name1 ~= "" then
						local tag1 = myChar.Head:FindFirstChild("NameTag")
						if tag1 then
							local lbl = tag1:FindFirstChild("MainFrame") and tag1.MainFrame:FindFirstChild("NameLabel")
							if lbl then
								lbl.Text = name1
								lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
								lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
								lbl.TextStrokeTransparency = 0.5
								ok = true
							end
						end
					end

					if name2 ~= "" then
						local tag2 = myChar.Head:FindFirstChild("RankTag")
						if tag2 then
							local lbl = tag2:FindFirstChild("MainFrame") and tag2.MainFrame:FindFirstChild("NameLabel")
							if lbl then
								lbl.Text = name2
								lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
								lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
								lbl.TextStrokeTransparency = 0.5
								ok = true
							end
						end
					end
				end)

				if ok then
					setFnStatus("Applied!", T.Green)
					fnApply.BackgroundColor3 = Color3.fromRGB(0, 80, 40)
					task.delay(0.3, function() fnApply.BackgroundColor3 = Color3.fromRGB(28, 45, 85) end)
				else
					setFnStatus("Tag not found", Color3.fromRGB(220, 80, 80))
				end
			end)
		end
	end

	-- ============================================================
	-- AIM PAGE
	-- ============================================================
	_buildAim = function()
		do
			local flagName = "AimLock"
			local isOn = Flags[flagName]

			local bar = Instance.new("TextButton", PageAim)
			bar.Size = UDim2.new(1, 0, 0, 38)
			bar.BackgroundColor3 = isOn and Color3.fromRGB(24, 34, 58) or T.Card
			bar.Text = ""
			bar.AutoButtonColor = false
			bar.LayoutOrder = 1
			Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)
			local bStr = Instance.new("UIStroke", bar)
			bStr.Color = isOn and T.StrokeOn or T.Stroke

			local nameLbl = Instance.new("TextLabel", bar)
			nameLbl.Size = UDim2.new(1,-190,1,0)
			nameLbl.Position = UDim2.new(0,28,0,0)
			nameLbl.BackgroundTransparency=1
			nameLbl.Text="Auto Aim"
			nameLbl.TextColor3 = isOn and T.Text or T.TextDim
			nameLbl.Font=Enum.Font.Gotham
			nameLbl.TextSize=14
			nameLbl.TextXAlignment=Enum.TextXAlignment.Left

			local modeBtn = Instance.new("TextButton", bar)
			modeBtn.Size = UDim2.new(0,42,0,22)
			modeBtn.Position = UDim2.new(1,-156,0.5,-11)
			modeBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			modeBtn.Text = AimMode
			modeBtn.TextColor3 = T.AccOn
			modeBtn.Font = Enum.Font.GothamBlack
			modeBtn.TextSize = 12
			modeBtn.AutoButtonColor = false
			Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(1,0)
			Instance.new("UIStroke", modeBtn).Color = T.Stroke

			local partBtn = Instance.new("TextButton", bar)
			partBtn.Size = UDim2.new(0,48,0,22)
			partBtn.Position = UDim2.new(1,-106,0.5,-11)
			partBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			partBtn.Text = AimPart=="Head" and "HEAD" or "BODY"
			partBtn.TextColor3 = T.AccOn
			partBtn.Font = Enum.Font.GothamBlack
			partBtn.TextSize = 12
			partBtn.AutoButtonColor = false
			Instance.new("UICorner", partBtn).CornerRadius = UDim.new(1,0)
			Instance.new("UIStroke", partBtn).Color = T.Stroke

			local statusPill = Instance.new("Frame", bar)
			statusPill.Size = UDim2.new(0,48,0,22)
			statusPill.Position = UDim2.new(1,-54,0.5,-11)
			statusPill.BackgroundColor3 = isOn and T.AccOn or Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1,0)
			if not isOn then Instance.new("UIStroke", statusPill).Color = T.Stroke end
			local statusLbl = Instance.new("TextLabel", statusPill)
			statusLbl.Size=UDim2.new(1,0,1,0)
			statusLbl.BackgroundTransparency=1
			statusLbl.Text = isOn and "ON" or "OFF"
			statusLbl.TextColor3 = isOn and Color3.fromRGB(255,255,255) or T.TextDim
			statusLbl.Font=Enum.Font.GothamBlack
			statusLbl.TextSize=12

			local function refreshBar()
				local on = Flags[flagName]
				bar.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or T.Card
				bStr.Color = on and T.StrokeOn or T.Stroke
				nameLbl.TextColor3 = on and T.Text or T.TextDim
				statusPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(24, 32, 52)
				statusLbl.Text = on and "ON" or "OFF"
				statusLbl.TextColor3 = on and Color3.fromRGB(255,255,255) or T.TextDim
			end

			bar.MouseButton1Click:Connect(function()
				Flags[flagName] = not Flags[flagName]
				refreshBar()
				saveSettings()
			end)
			partBtn.MouseButton1Click:Connect(function()
				AimPart = AimPart=="Head" and "Body" or "Head"
				partBtn.Text = AimPart=="Head" and "HEAD" or "BODY"
				AimTarget = nil
			end)
			modeBtn.MouseButton1Click:Connect(function()
				AimMode = AimMode=="PC" and "HP" or "PC"
				modeBtn.Text = AimMode
				modeBtn.TextColor3 = AimMode=="HP" and T.AccOn or T.TextDim
				AimTarget = nil
			end)
		end

		do
			local b = AddToggleBar(PageAim, "WallCheck")
			b.LayoutOrder = 2
		end

		-- SILENT AIM
		do
			local saBar = Instance.new("TextButton", PageAim)
			saBar.Size = UDim2.new(1, 0, 0, 38)
			saBar.BackgroundColor3 = SilentAim and Color3.fromRGB(24, 34, 58) or T.Card
			saBar.Text = ""
			saBar.AutoButtonColor = false
			saBar.LayoutOrder = 3
			Instance.new("UICorner", saBar).CornerRadius = UDim.new(0, 10)
			local saStr = Instance.new("UIStroke", saBar)
			saStr.Color = SilentAim and T.StrokeOn or T.Stroke

			local saLbl = Instance.new("TextLabel", saBar)
			saLbl.Size = UDim2.new(1, -130, 1, 0)
			saLbl.Position = UDim2.new(0, 28, 0, 0)
			saLbl.BackgroundTransparency = 1
			saLbl.Text = "Silent Aim"
			saLbl.TextColor3 = SilentAim and T.Text or T.TextDim
			saLbl.Font = Enum.Font.Gotham
			saLbl.TextSize = 14
			saLbl.TextXAlignment = Enum.TextXAlignment.Left

			local saPartBtn = Instance.new("TextButton", saBar)
			saPartBtn.Size = UDim2.new(0, 48, 0, 22)
			saPartBtn.Position = UDim2.new(1, -158, 0.5, -11)
			saPartBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			saPartBtn.Text = "HEAD"
			saPartBtn.TextColor3 = T.AccOn
			saPartBtn.Font = Enum.Font.GothamBlack
			saPartBtn.TextSize = 12
			saPartBtn.AutoButtonColor = false
			Instance.new("UICorner", saPartBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", saPartBtn).Color = T.Stroke

			local saModeBtn = Instance.new("TextButton", saBar)
			saModeBtn.Size = UDim2.new(0, 42, 0, 22)
			saModeBtn.Position = UDim2.new(1, -106, 0.5, -11)
			saModeBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			saModeBtn.Text = SilentMode
			saModeBtn.TextColor3 = T.AccOn
			saModeBtn.Font = Enum.Font.GothamBlack
			saModeBtn.TextSize = 12
			saModeBtn.AutoButtonColor = false
			saModeBtn.ZIndex = 2
			Instance.new("UICorner", saModeBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", saModeBtn).Color = T.Stroke

			saModeBtn.MouseButton1Click:Connect(function()
				SilentMode = SilentMode == "PC" and "HP" or "PC"
				saModeBtn.Text = SilentMode
				saModeBtn.TextColor3 = SilentMode == "HP" and T.Text or T.TextDim
			end)

			local saPill = Instance.new("Frame", saBar)
			saPill.Size = UDim2.new(0, 48, 0, 22)
			saPill.Position = UDim2.new(1, -54, 0.5, -11)
			saPill.BackgroundColor3 = SilentAim and T.AccOn or Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", saPill).CornerRadius = UDim.new(1, 0)
			if not SilentAim then Instance.new("UIStroke", saPill).Color = T.Stroke end
			local saPillLbl = Instance.new("TextLabel", saPill)
			saPillLbl.Size = UDim2.new(1, 0, 1, 0)
			saPillLbl.BackgroundTransparency = 1
			saPillLbl.Text = SilentAim and "ON" or "OFF"
			saPillLbl.TextColor3 = SilentAim and Color3.fromRGB(255,255,255) or T.TextDim
			saPillLbl.Font = Enum.Font.GothamBlack
			saPillLbl.TextSize = 12

			local saPart = "Head"

			local function refreshSABar()
				saBar.BackgroundColor3 = SilentAim and Color3.fromRGB(24, 34, 58) or T.Card
				saStr.Color = SilentAim and T.StrokeOn or T.Stroke
				saLbl.TextColor3 = SilentAim and T.Text or T.TextDim
				saPill.BackgroundColor3 = SilentAim and T.AccOn or Color3.fromRGB(24, 32, 52)
				saPillLbl.Text = SilentAim and "ON" or "OFF"
				saPillLbl.TextColor3 = SilentAim and Color3.fromRGB(255,255,255) or T.TextDim
			end

			saBar.MouseButton1Click:Connect(function()
				SilentAim = not SilentAim
				refreshSABar()
			end)

			saPartBtn.MouseButton1Click:Connect(function()
				saPart = saPart == "Head" and "Body" or "Head"
				saPartBtn.Text = saPart == "Head" and "HEAD" or "BODY"
			end)

			-- Wallbang toggle
			local wbBar = Instance.new("TextButton", PageAim)
			wbBar.Size = UDim2.new(1, 0, 0, 38)
			wbBar.BackgroundColor3 = T.Card
			wbBar.Text = ""
			wbBar.AutoButtonColor = false
			wbBar.LayoutOrder = 4
			Instance.new("UICorner", wbBar).CornerRadius = UDim.new(0, 10)
			local wbStr = Instance.new("UIStroke", wbBar)
			wbStr.Color = T.Stroke

			local wbLbl = Instance.new("TextLabel", wbBar)
			wbLbl.Size = UDim2.new(1, -60, 1, 0)
			wbLbl.Position = UDim2.new(0, 28, 0, 0)
			wbLbl.BackgroundTransparency = 1
			wbLbl.Text = "Silent Wallbang"
			wbLbl.TextColor3 = T.TextDim
			wbLbl.Font = Enum.Font.Gotham
			wbLbl.TextSize = 14
			wbLbl.TextXAlignment = Enum.TextXAlignment.Left

			local wbPill = Instance.new("Frame", wbBar)
			wbPill.Size = UDim2.new(0, 48, 0, 22)
			wbPill.Position = UDim2.new(1, -54, 0.5, -11)
			wbPill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", wbPill).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", wbPill).Color = T.Stroke
			local wbPillLbl = Instance.new("TextLabel", wbPill)
			wbPillLbl.Size = UDim2.new(1, 0, 1, 0)
			wbPillLbl.BackgroundTransparency = 1
			wbPillLbl.Text = "OFF"
			wbPillLbl.TextColor3 = T.TextDim
			wbPillLbl.Font = Enum.Font.GothamBlack
			wbPillLbl.TextSize = 12

			local function refreshWBBar()
				wbBar.BackgroundColor3 = SilentAimWallbang and Color3.fromRGB(24, 34, 58) or T.Card
				wbStr.Color = SilentAimWallbang and T.StrokeOn or T.Stroke
				wbLbl.TextColor3 = SilentAimWallbang and T.Text or T.TextDim
				wbPill.BackgroundColor3 = SilentAimWallbang and T.AccOn or Color3.fromRGB(24, 32, 52)
				wbPillLbl.Text = SilentAimWallbang and "ON" or "OFF"
				wbPillLbl.TextColor3 = SilentAimWallbang and Color3.fromRGB(255,255,255) or T.TextDim
			end

			wbBar.MouseButton1Click:Connect(function()
				SilentAimWallbang = not SilentAimWallbang
				refreshWBBar()
			end)

			task.spawn(function()
				local function searchGc(fname)
					local ok, gc = pcall(getgc)
					if not ok then return nil end
					for _, v in pairs(gc) do
						if type(v) == "function" then
							local ok2, info = pcall(debug.getinfo, v)
							if ok2 and info and info.name == fname then
								return v
							end
						end
					end
				end

				local tries = 0
				local OldCast, CastWL
				while tries < 30 do
					task.wait(1)
					tries = tries + 1
					local cb = searchGc("CastBlacklist")
					local cw = searchGc("CastWhitelist")
					if cb and cw then
						OldCast = hookfunction(cb, function(...)
							if not SilentAim then return OldCast(...) end
							local cam = workspace.CurrentCamera
							local vp2 = cam.ViewportSize
							local saFovCenter = SilentMode == "HP"
								and Vector2.new(vp2.X / 2, vp2.Y / 2)
								or UIS:GetMouseLocation()
							local Target, LowestDist = nil, math.huge
							for _, p in pairs(game.Players:GetPlayers()) do
								local ch = p.Character
								if p == plr or not ch then continue end
								local hitPart = ch:FindFirstChild(saPart == "Head" and "Head" or "HumanoidRootPart")
								local hrp = ch:FindFirstChild("HumanoidRootPart")
								local hum = ch:FindFirstChildOfClass("Humanoid")
								if not hitPart or not hrp or not hum or hum.Health <= 0 then continue end
								local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
								if not onScreen then continue end
								local d = (saFovCenter - Vector2.new(sp.X, sp.Y)).Magnitude
								if d < SilentFOV_Radius and d < LowestDist then
									Target = p
									LowestDist = d
								end
							end
							if Target then
								local args = {...}
								local hitPart = Target.Character and Target.Character:FindFirstChild(saPart == "Head" and "Head" or "HumanoidRootPart")
								if hitPart then
									args[2] = hitPart.Position - args[1]
									if SilentAimWallbang then
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
		end

		do
			local s = AddSlider(PageAim,"FOV Radius (Aimbot)",30,400,AimFOV_Radius,"px",function(v) AimFOV_Radius=v
				saveSettings() end)
			s.LayoutOrder = 5
		end
		do
			local s = AddSlider(PageAim,"FOV Radius (Silent)",30,400,SilentFOV_Radius,"px",function(v)
				SilentFOV_Radius=v end)
			s.LayoutOrder = 6
		end
		do
			local s = AddSlider(PageAim,"Max Jarak",50,1000,AimMax_Dist,"studs",function(v) AimMax_Dist=v
				saveSettings() end)
			s.LayoutOrder = 7
		end
		do
			local defSmooth = math.floor(AimSmooth * 100)
			local s = AddSlider(PageAim,"Smoothness",1,100,defSmooth,"%",function(v)
				AimSmooth = math.clamp(v / 100, 0.01, 0.99)
				saveSettings()
			end)
			s.LayoutOrder = 8
		end

		-- Hide FOV toggles
		do
			local function makeFovToggle(label, layoutOrder, getVal, setVal)
				local row = Instance.new("Frame", PageAim)
				row.Size = UDim2.new(1, 0, 0, 32)
				row.BackgroundColor3 = T.Card
				row.LayoutOrder = layoutOrder
				Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
				local rowStr = Instance.new("UIStroke", row)
				rowStr.Color = T.Stroke

				local lbl = Instance.new("TextLabel", row)
				lbl.Size = UDim2.new(1, -60, 1, 0)
				lbl.Position = UDim2.new(0, 14, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = label
				lbl.TextColor3 = T.TextDim
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 13
				lbl.TextXAlignment = Enum.TextXAlignment.Left

				local pill = Instance.new("Frame", row)
				pill.Size = UDim2.new(0, 46, 0, 22)
				pill.Position = UDim2.new(1, -54, 0.5, -11)
				Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

				local pillLbl = Instance.new("TextLabel", pill)
				pillLbl.Size = UDim2.new(1, 0, 1, 0)
				pillLbl.BackgroundTransparency = 1
				pillLbl.Font = Enum.Font.GothamBlack
				pillLbl.TextSize = 12

				local function refresh()
					local on = getVal()
					pill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(24, 32, 52)
					pillLbl.Text = on and "ON" or "OFF"
					pillLbl.TextColor3 = on and Color3.fromRGB(255, 255, 255) or T.TextDim
					lbl.TextColor3 = on and T.Text or T.TextDim
					row.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or T.Card
					rowStr.Color = on and T.StrokeOn or T.Stroke
				end
				refresh()

				row.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1
					or inp.UserInputType == Enum.UserInputType.Touch then
						setVal(not getVal())
						refresh()
					end
				end)
			end

			makeFovToggle("Show FOV (Aimbot)",  9,  function() return ShowAimFOV    end, function(v) ShowAimFOV    = v end)
			makeFovToggle("Show FOV (Silent)",  10, function() return ShowSilentFOV end, function(v) ShowSilentFOV = v end)
		end

		-- WHITELIST
		do
			local wlOpen = false

			local wlHeader = Instance.new("TextButton", PageAim)
			wlHeader.Size = UDim2.new(1, 0, 0, 36)
			wlHeader.BackgroundColor3 = T.Card
			wlHeader.Text = ""
			wlHeader.AutoButtonColor = false
			wlHeader.LayoutOrder = 11
			Instance.new("UICorner", wlHeader).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", wlHeader).Color = T.Stroke

			local wlTitle = Instance.new("TextLabel", wlHeader)
			wlTitle.Size = UDim2.new(1,-90,1,0)
			wlTitle.Position = UDim2.new(0,38,0,0)
			wlTitle.BackgroundTransparency=1
			wlTitle.Text="Whitelist Aim"
			wlTitle.TextColor3=T.TextDim
			wlTitle.Font=Enum.Font.GothamBlack
			wlTitle.TextSize=16
			wlTitle.TextXAlignment=Enum.TextXAlignment.Left

			local wlArrow = Instance.new("TextLabel", wlHeader)
			wlArrow.Size = UDim2.new(0,30,1,0)
			wlArrow.Position = UDim2.new(1,-34,0,0)
			wlArrow.BackgroundTransparency=1
			wlArrow.Text="v"
			wlArrow.TextColor3=T.TextDim
			wlArrow.Font=Enum.Font.GothamBlack
			wlArrow.TextSize=16

			local wlContainer = Instance.new("Frame", PageAim)
			wlContainer.Size = UDim2.new(1, 0, 0, 0)
			wlContainer.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
			wlContainer.ClipsDescendants = true
			wlContainer.LayoutOrder = 12
			Instance.new("UICorner", wlContainer).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", wlContainer).Color = T.Stroke

			local wlLayout = Instance.new("UIListLayout", wlContainer)
			wlLayout.Padding = UDim.new(0,3)
			wlLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local wlPadding = Instance.new("UIPadding", wlContainer)
			wlPadding.PaddingTop = UDim.new(0,5)
			wlPadding.PaddingBottom = UDim.new(0,5)
			wlPadding.PaddingLeft = UDim.new(0,5)
			wlPadding.PaddingRight = UDim.new(0,5)

			local wlRows = {}

			local function rebuildWhitelistUI()
				for _, r in pairs(wlRows) do
					pcall(function() r:Destroy() end)
				end
				wlRows = {}

				local players = game.Players:GetPlayers()
				for idx, p in ipairs(players) do
					if p == plr then continue end
					local isWL = AimWhitelist[p.Name] == true

					local row = Instance.new("Frame", wlContainer)
					row.Size = UDim2.new(1, 0, 0, 28)
					row.BackgroundColor3 = isWL and Color3.fromRGB(28, 45, 85) or Color3.fromRGB(24, 32, 52)
					row.LayoutOrder = idx
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

					local nameL = Instance.new("TextLabel", row)
					nameL.Size = UDim2.new(1,-60,1,0)
					nameL.Position = UDim2.new(0,8,0,0)
					nameL.BackgroundTransparency=1
					nameL.Text=p.Name
					nameL.TextColor3 = isWL and T.Text or T.TextDim
					nameL.Font=Enum.Font.GothamBlack
					nameL.TextSize=15
					nameL.TextXAlignment=Enum.TextXAlignment.Left
					nameL.TextTruncate=Enum.TextTruncate.AtEnd

					local wlPill = Instance.new("TextButton", row)
					wlPill.Size = UDim2.new(0,48,0,18)
					wlPill.Position = UDim2.new(1,-52,0.5,-9)
					wlPill.BackgroundColor3 = isWL and T.AccOn or Color3.fromRGB(24, 32, 52)
					wlPill.Text = isWL and "WL" or "NO"
					wlPill.TextColor3 = isWL and Color3.fromRGB(255,255,255) or T.TextDim
					wlPill.Font=Enum.Font.GothamBlack
					wlPill.TextSize=14
					wlPill.AutoButtonColor=false
					Instance.new("UICorner", wlPill).CornerRadius = UDim.new(1,0)

					local captured = p
					wlPill.MouseButton1Click:Connect(function()
						if AimWhitelist[captured.Name] then
							AimWhitelist[captured.Name] = nil
						else
							AimWhitelist[captured.Name] = true
						end
						rebuildWhitelistUI()
					end)

					table.insert(wlRows, row)
				end

				local count = #wlRows
				local newH = count > 0 and (count * 29 + 10) or 36
				if wlOpen then
					wlContainer.Size = UDim2.new(1, 0, 0, newH)
				end
			end

			local wlRefreshRow = Instance.new("TextButton", wlContainer)
			wlRefreshRow.Size = UDim2.new(1, 0, 0, 24)
			wlRefreshRow.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			wlRefreshRow.Text = "Refresh List"
			wlRefreshRow.TextColor3 = T.AccOn
			wlRefreshRow.Font=Enum.Font.GothamBlack
			wlRefreshRow.TextSize=15
			wlRefreshRow.AutoButtonColor=false
			wlRefreshRow.LayoutOrder=0
			Instance.new("UICorner", wlRefreshRow).CornerRadius = UDim.new(0, 8)

			wlRefreshRow.MouseButton1Click:Connect(rebuildWhitelistUI)

			wlHeader.MouseButton1Click:Connect(function()
				wlOpen = not wlOpen
				if wlOpen then
					rebuildWhitelistUI()
					local players = game.Players:GetPlayers()
					local realCount = 0
					for _, p in ipairs(players) do if p ~= plr then realCount = realCount + 1 end end
					local newH = realCount > 0 and (realCount * 29 + 44) or 44
					TweenService:Create(wlContainer, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(1,0,0,newH)}):Play()
					wlArrow.Text = "^"
					wlTitle.TextColor3 = T.Text
				else
					TweenService:Create(wlContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size=UDim2.new(1,0,0,0)}):Play()
					wlArrow.Text = "v"
					wlTitle.TextColor3 = T.TextDim
				end
			end)

			game.Players.PlayerAdded:Connect(function()
				if wlOpen then task.wait(0.5)
					rebuildWhitelistUI() end
			end)
			game.Players.PlayerRemoving:Connect(function(p)
				AimWhitelist[p.Name] = nil
				if wlOpen then rebuildWhitelistUI() end
			end)
		end
	end

	-- ============================================================
	-- TP PAGE
	-- ============================================================
	_buildTP = function()
		local UNDERGROUND_Y = -4.00
		local TP_SPEED = 16

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

		local function moveCharTo(targetPos)
			local ch = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local offset = targetPos - hrp.Position
			for _, p in pairs(ch:GetDescendants()) do
				if p:IsA("BasePart") and p ~= hrp then
					pcall(function()
						p.CFrame = p.CFrame + offset
					end)
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
				local nextPos = fromPos:Lerp(toPos, t)
				moveCharTo(nextPos)
				local _, dt = RunService.Stepped:Wait()
				elapsed = elapsed + dt
			end
			if not tpCancelled then moveCharTo(toPos) end
			return not tpCancelled
		end

		-- TP OVERLAY
		local TPOverlay = Instance.new("ScreenGui")
		TPOverlay.Name = "DARKHUB_TPOverlay"
		TPOverlay.ResetOnSpawn = false
		TPOverlay.DisplayOrder = 5
		TPOverlay.IgnoreGuiInset = true
		TPOverlay.Enabled = false
		TPOverlay.Parent = CoreGui

		local OvBG = Instance.new("Frame", TPOverlay)
		OvBG.Size = UDim2.new(1, 0, 1, 0)
		OvBG.Position = UDim2.new(0, 0, 0, 0)
		OvBG.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
		OvBG.BackgroundTransparency = 1
		OvBG.BorderSizePixel = 0
		OvBG.ZIndex = 9999

		local ovCenter = Instance.new("Frame", OvBG)
		ovCenter.Size = UDim2.new(0, 320, 0, 130)
		ovCenter.AnchorPoint = Vector2.new(0.5, 0.5)
		ovCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
		ovCenter.BackgroundTransparency = 1
		ovCenter.ZIndex = 10000

		local logoFrame = Instance.new("Frame", ovCenter)
		logoFrame.Size = UDim2.new(0, 0, 0, 72)
		logoFrame.AutomaticSize = Enum.AutomaticSize.X
		logoFrame.AnchorPoint = Vector2.new(0.5, 0)
		logoFrame.Position = UDim2.new(0.5, 0, 0, 0)
		logoFrame.BackgroundTransparency = 1
		logoFrame.ZIndex = 10001
		local _logoLay = Instance.new("UIListLayout", logoFrame)
		_logoLay.FillDirection = Enum.FillDirection.Horizontal
		_logoLay.SortOrder = Enum.SortOrder.LayoutOrder
		_logoLay.Padding = UDim.new(0, 0)
		_logoLay.VerticalAlignment = Enum.VerticalAlignment.Center

		local ovTitleGreen = Instance.new("TextLabel", logoFrame)
		ovTitleGreen.Size = UDim2.new(0, 0, 1, 0)
		ovTitleGreen.AutomaticSize = Enum.AutomaticSize.X
		ovTitleGreen.BackgroundTransparency = 1
		ovTitleGreen.Text = "DARK"
		ovTitleGreen.TextColor3 = Color3.fromRGB(90, 160, 255)
		ovTitleGreen.Font = Enum.Font.GothamBlack
		ovTitleGreen.TextSize = 64
		ovTitleGreen.LayoutOrder = 1
		ovTitleGreen.ZIndex = 10001

		local ovTitleWhite = Instance.new("TextLabel", logoFrame)
		ovTitleWhite.Size = UDim2.new(0, 0, 1, 0)
		ovTitleWhite.AutomaticSize = Enum.AutomaticSize.X
		ovTitleWhite.BackgroundTransparency = 1
		ovTitleWhite.Text = "HUB"
		ovTitleWhite.TextColor3 = Color3.fromRGB(255, 255, 255)
		ovTitleWhite.Font = Enum.Font.GothamBlack
		ovTitleWhite.TextSize = 64
		ovTitleWhite.LayoutOrder = 2
		ovTitleWhite.ZIndex = 10002
		local ovWhiteStroke = Instance.new("UIStroke", ovTitleWhite)
		ovWhiteStroke.Color = Color3.fromRGB(90, 160, 255)
		ovWhiteStroke.Thickness = 2.5

		local ovLabel = Instance.new("TextLabel", ovCenter)
		ovLabel.Size = UDim2.new(1, 0, 0, 20)
		ovLabel.Position = UDim2.new(0, 0, 0, 80)
		ovLabel.BackgroundTransparency = 1
		ovLabel.Text = "Teleporting, please wait"
		ovLabel.TextColor3 = Color3.fromRGB(160, 180, 210)
		ovLabel.Font = Enum.Font.Gotham
		ovLabel.TextSize = 13
		ovLabel.TextXAlignment = Enum.TextXAlignment.Center
		ovLabel.ZIndex = 10001

		local ovDestLbl = Instance.new("TextLabel", OvBG)
		ovDestLbl.Visible = false; ovDestLbl.Text = ""; ovDestLbl.BackgroundTransparency = 1
		local ovTimerLbl = Instance.new("TextLabel", OvBG)
		ovTimerLbl.Visible = false; ovTimerLbl.Text = ""; ovTimerLbl.BackgroundTransparency = 1

		local ovAnimConn = nil
		local ovTimerConn = nil
		local _panelWasVisible = false

		local function showTPOverlay(destName, totalDist)
			_panelWasVisible = MF.Visible
			if MF.Visible then
				MF.Visible = false
				LogoBtn.Visible = false
			end
			_overlayActive = true
			FovCircle.Visible = false
			for _, e in pairs(ESP) do _hideESP(e) end
			OvBG.BackgroundTransparency = 0
			TPOverlay.Enabled = true
		end

		_htpo.fn = function()
			if ovAnimConn then ovAnimConn:Disconnect(); ovAnimConn = nil end
			if ovTimerConn then ovTimerConn:Disconnect(); ovTimerConn = nil end
			TPOverlay.Enabled = false
			OvBG.BackgroundTransparency = 1
			_overlayActive = false
			if _panelWasVisible then
				MF.Visible = true
			end
			_panelWasVisible = false
		end

		local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)
		local KILL_TP_ESTIMATED = TP_SPEED * 3

		local function openBonusTPOverlay(destName)
			ovLabel.Text = "RESPAWNING \226\134\146"
			ovLabel.TextColor3 = Color3.fromRGB(220, 100, 120)
			ovDestLbl.Text = destName
			showTPOverlay(destName, KILL_TP_ESTIMATED)
		end

		local function updateBonusTPLabel(destName)
			ovLabel.Text = "TELEPORTING TO"
			ovLabel.TextColor3 = Color3.fromRGB(160, 180, 210)
			ovDestLbl.Text = destName
		end

		local function closeBonusTPOverlay()
			ovLabel.Text = "TELEPORTING TO"
			ovLabel.TextColor3 = Color3.fromRGB(160, 180, 210)
			hideTPOverlay()
		end

		tpToPos = function(cx, cy, cz, _unused, destName)
			if tpActive then return end
			tpActive = true
			tpCancelled = false

			local ch = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			local hum = ch and ch:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then tpActive=false return end

			local startPos = hrp.Position
			local totalDist = (startPos - Vector3.new(cx, cy, cz)).Magnitude
			showTPOverlay(destName or "Destination", totalDist)
			tpCancelBtn.Visible = true

			local diedDuringTP = false
			local deathConn
			deathConn = plr.CharacterAdded:Connect(function()
				diedDuringTP = true
				tpCancelled = true
			end)

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

			if deathConn then deathConn:Disconnect() end
			tpCancelBtn.Visible = false
			hideTPOverlay()
			resetHumanoid()
			tpActive = false
		end

		-- Confirm modal
		local ConfirmModal = Instance.new("Frame", MF)
		ConfirmModal.Size = UDim2.new(1,0,1,0)
		ConfirmModal.BackgroundColor3 = Color3.fromRGB(0,0,0)
		ConfirmModal.BackgroundTransparency = 0.5
		ConfirmModal.ZIndex = 20
		ConfirmModal.Visible = false
		Instance.new("UICorner", ConfirmModal).CornerRadius = UDim.new(0, 10)

		local ConfirmCard = Instance.new("Frame", ConfirmModal)
		ConfirmCard.Size = UDim2.new(0.85,0,0,118)
		ConfirmCard.AnchorPoint = Vector2.new(0.5,0.5)
		ConfirmCard.Position = UDim2.new(0.5,0,0.5,0)
		ConfirmCard.BackgroundColor3 = Color3.fromRGB(14, 18, 32)
		ConfirmCard.ZIndex = 21
		Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 12)
		local cms = Instance.new("UIStroke", ConfirmCard)
		cms.Color = T.StrokeOn
		cms.Thickness = 1
		cms.ZIndex = 21

		local ConfirmTitle = Instance.new("TextLabel", ConfirmCard)
		ConfirmTitle.Size = UDim2.new(1,-12,0,22)
		ConfirmTitle.Position = UDim2.new(0,6,0,6)
		ConfirmTitle.BackgroundTransparency = 1
		ConfirmTitle.Text = "Suicide TP"
		ConfirmTitle.TextColor3 = T.Text
		ConfirmTitle.Font = Enum.Font.GothamBlack
		ConfirmTitle.TextSize = 17
		ConfirmTitle.ZIndex = 22

		local ConfirmMsg = Instance.new("TextLabel", ConfirmCard)
		ConfirmMsg.Size = UDim2.new(1,-12,0,24)
		ConfirmMsg.Position = UDim2.new(0,6,0,30)
		ConfirmMsg.BackgroundTransparency = 1
		ConfirmMsg.Text = "TP ke lokasi ini?"
		ConfirmMsg.TextColor3 = T.TextDim
		ConfirmMsg.Font = Enum.Font.GothamBlack
		ConfirmMsg.TextSize = 15
		ConfirmMsg.TextWrapped = true
		ConfirmMsg.ZIndex = 22

		local ConfirmBtn = Instance.new("TextButton", ConfirmCard)
		ConfirmBtn.Size = UDim2.new(0.45,0,0,30)
		ConfirmBtn.Position = UDim2.new(0.52,0,1,-36)
		ConfirmBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 20)
		ConfirmBtn.Text = "Confirm"
		ConfirmBtn.TextColor3 = Color3.fromRGB(220, 80, 100)
		ConfirmBtn.Font = Enum.Font.GothamBlack
		ConfirmBtn.TextSize = 13
		ConfirmBtn.AutoButtonColor = false
		ConfirmBtn.ZIndex = 22
		Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", ConfirmBtn).Color = Color3.fromRGB(90, 25, 40)

		local CancelBtn = Instance.new("TextButton", ConfirmCard)
		CancelBtn.Size = UDim2.new(0.45,0,0,30)
		CancelBtn.Position = UDim2.new(0.03,0,1,-36)
		CancelBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
		CancelBtn.Text = "Cancel"
		CancelBtn.TextColor3 = T.TextDim
		CancelBtn.Font = Enum.Font.GothamBlack
		CancelBtn.TextSize = 13
		CancelBtn.AutoButtonColor = false
		CancelBtn.ZIndex = 22
		Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", CancelBtn).Color = T.Stroke

		local confirmCallback = nil
		local function showConfirm(locName, onConfirm)
			ConfirmMsg.Text = 'Teleport to: "'..locName..'"?'
			confirmCallback = onConfirm
			ConfirmModal.Visible = true
		end
		ConfirmBtn.MouseButton1Click:Connect(function()
			ConfirmModal.Visible = false
			if confirmCallback then confirmCallback()
				confirmCallback = nil end
		end)
		CancelBtn.MouseButton1Click:Connect(function()
			ConfirmModal.Visible = false
			confirmCallback = nil
			tpBusy = false
		end)

		local tpPageStatusLbl = Instance.new("TextLabel", PageTP)
		tpPageStatusLbl.Size = UDim2.new(0.72,0,0,26)
		tpPageStatusLbl.BackgroundTransparency = 1
		tpPageStatusLbl.Text = ""
		tpPageStatusLbl.TextColor3 = T.AccOn
		tpPageStatusLbl.Font = Enum.Font.Gotham
		tpPageStatusLbl.TextSize = 13
		tpPageStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

		tpCancelBtn = Instance.new("TextButton", PageTP)
		tpCancelBtn.Size = UDim2.new(0.26,0,0,26)
		tpCancelBtn.AnchorPoint = Vector2.new(1,0)
		tpCancelBtn.Position = UDim2.new(1,0,0,0)
		tpCancelBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 20)
		tpCancelBtn.Text = "Cancel"
		tpCancelBtn.TextColor3 = Color3.fromRGB(200, 70, 90)
		tpCancelBtn.Font = Enum.Font.Gotham
		tpCancelBtn.TextSize = 13
		tpCancelBtn.AutoButtonColor = false
		tpCancelBtn.Visible = false
		Instance.new("UICorner", tpCancelBtn).CornerRadius = UDim.new(0,8)
		Instance.new("UIStroke", tpCancelBtn).Color = Color3.fromRGB(90, 25, 40)

		local function setTPStatus(msg, col)
			tpPageStatusLbl.Text = msg
			tpPageStatusLbl.TextColor3 = col or T.AccOn
			task.delay(4, function() if tpPageStatusLbl.Text==msg then tpPageStatusLbl.Text="" end end)
		end

		tpCancelBtn.MouseButton1Click:Connect(function()
			tpCancelled = true
			tpBusy = false
			tpCancelBtn.Visible = false
			hideTPOverlay()
			setTPStatus("Cancelled — floating up...", T.TextDim)
		end)

		doSuicideTP = function(loc)
			tpBusy = true
			openBonusTPOverlay(loc.name)
			setTPStatus("Warp → "..loc.name.."...", T.AccOn)
			local ch = plr.Character
			local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp0 then tpBusy=false
				closeBonusTPOverlay()
				return end

			hrp0.CFrame = CFrame.new(RESPAWN_WARP)
			local newChar = plr.CharacterAdded:Wait()
			local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
			local hum = newChar:WaitForChild("Humanoid", 10)
			if not hrp or not hum then tpBusy=false
				closeBonusTPOverlay()
				return end

			local waited = 0
			while hum.Health <= 0 and waited < 5 do
				task.wait(0.1)
				waited += 0.1
			end
			task.wait(0.8)
			updateBonusTPLabel(loc.name)

			local targetCF = CFrame.new(loc.x, loc.y + 3, loc.z)
			for _ = 1, 4 do
				hrp.CFrame = targetCF
				task.wait(0.15)
			end

			task.wait(0.1)
			closeBonusTPOverlay()
			setTPStatus("Arrived: "..loc.name, T.Green)
			tpBusy = false
		end

		-- ============================================================
		-- TP CATEGORIES — hanya "Others" sesuai request
		-- (ATM, Homeless, Apartment dihapus)
		-- ============================================================
		local TP_CATEGORIES = {
			{
				name = "Others",
				locs = {
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
				}
			},
		}

		local function buildTPSection(cat, layoutOrder)
			local secOpen = false
			local ROW_H = 30
			local totalH = #cat.locs * (ROW_H + 3) + 12

			local hdr = Instance.new("TextButton", PageTP)
			hdr.Size = UDim2.new(1,0,0,38)
			hdr.BackgroundColor3 = T.Card
			hdr.Text = ""
			hdr.AutoButtonColor = false
			hdr.LayoutOrder = layoutOrder
			Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 10)
			Instance.new("UIStroke", hdr).Color = T.Stroke

			local titleL = Instance.new("TextLabel", hdr)
			titleL.Size=UDim2.new(1,-70,1,0)
			titleL.Position=UDim2.new(0,14,0,0)
			titleL.BackgroundTransparency=1
			titleL.Text=cat.name
			titleL.TextColor3=T.TextDim
			titleL.Font=Enum.Font.GothamBlack
			titleL.TextSize=16
			titleL.TextXAlignment=Enum.TextXAlignment.Left

			local countL = Instance.new("TextLabel", hdr)
			countL.Size=UDim2.new(0,40,1,0)
			countL.Position=UDim2.new(1,-70,0,0)
			countL.BackgroundTransparency=1
			countL.Text=#cat.locs.."loc"
			countL.TextColor3=T.AccOn
			countL.Font=Enum.Font.GothamBlack
			countL.TextSize=14

			local arrow = Instance.new("TextLabel", hdr)
			arrow.Size=UDim2.new(0,26,1,0)
			arrow.Position=UDim2.new(1,-30,0,0)
			arrow.BackgroundTransparency=1
			arrow.Text="v"
			arrow.TextColor3=T.TextDim
			arrow.Font=Enum.Font.GothamBlack
			arrow.TextSize=16

			local cont = Instance.new("Frame", PageTP)
			cont.Size=UDim2.new(1,0,0,0)
			cont.BackgroundColor3=Color3.fromRGB(19, 24, 40)
			cont.ClipsDescendants=true
			cont.LayoutOrder = layoutOrder + 1
			Instance.new("UICorner", cont).CornerRadius=UDim.new(0,10)
			Instance.new("UIStroke", cont).Color=T.Stroke

			local lay = Instance.new("UIListLayout", cont)
			lay.Padding=UDim.new(0,3)
			lay.SortOrder=Enum.SortOrder.LayoutOrder
			local pad = Instance.new("UIPadding", cont)
			pad.PaddingTop=UDim.new(0,5)
			pad.PaddingBottom=UDim.new(0,5)
			pad.PaddingLeft=UDim.new(0,5)
			pad.PaddingRight=UDim.new(0,5)

			for i, loc in ipairs(cat.locs) do
				local row = Instance.new("Frame", cont)
				row.Size=UDim2.new(1,0,0,ROW_H)
				row.BackgroundColor3=Color3.fromRGB(24, 32, 52)
				row.LayoutOrder=i
				Instance.new("UICorner", row).CornerRadius=UDim.new(0,8)
				Instance.new("UIStroke", row).Color=T.Stroke

				local nameL = Instance.new("TextLabel", row)
				nameL.Size=UDim2.new(1,-200,1,0)
				nameL.Position=UDim2.new(0,10,0,0)
				nameL.BackgroundTransparency=1
				nameL.Text=loc.name
				nameL.TextColor3=T.Text
				nameL.Font=Enum.Font.GothamBlack
				nameL.TextSize=15
				nameL.TextXAlignment=Enum.TextXAlignment.Left
				nameL.TextTruncate=Enum.TextTruncate.AtEnd

				local vehTPBtn = Instance.new("TextButton", row)
				vehTPBtn.Size=UDim2.new(0,44,0,20)
				vehTPBtn.Position=UDim2.new(1,-142,0.5,-10)
				vehTPBtn.BackgroundColor3=Color3.fromRGB(20,38,70)
				vehTPBtn.Text=""
				vehTPBtn.TextColor3=Color3.fromRGB(90,160,255)
				vehTPBtn.Font=Enum.Font.GothamBlack
				vehTPBtn.TextSize=12
				vehTPBtn.AutoButtonColor=false
				Instance.new("UICorner", vehTPBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", vehTPBtn).Color=Color3.fromRGB(50,90,160)

				local suicideBtn = Instance.new("TextButton", row)
				suicideBtn.Size=UDim2.new(0,56,0,20)
				suicideBtn.Position=UDim2.new(1,-94,0.5,-10)
				suicideBtn.BackgroundColor3=Color3.fromRGB(50,15,20)
				suicideBtn.Text="TP"
				suicideBtn.TextColor3=Color3.fromRGB(220,80,100)
				suicideBtn.Font=Enum.Font.GothamBlack
				suicideBtn.TextSize=12
				suicideBtn.AutoButtonColor=false
				Instance.new("UICorner", suicideBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", suicideBtn).Color=Color3.fromRGB(120,40,60)

				local normalBtn = Instance.new("TextButton", row)
				normalBtn.Size=UDim2.new(0,36,0,20)
				normalBtn.Position=UDim2.new(1,-34,0.5,-10)
				normalBtn.BackgroundColor3=Color3.fromRGB(15,40,25)
				normalBtn.Text=""
				normalBtn.TextColor3=Color3.fromRGB(100,220,140)
				normalBtn.Font=Enum.Font.GothamBlack
				normalBtn.TextSize=13
				normalBtn.AutoButtonColor=false
				Instance.new("UICorner", normalBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", normalBtn).Color=Color3.fromRGB(50,130,80)

				local capturedLoc = loc

				vehTPBtn.MouseButton1Click:Connect(function()
					local ok = doVehicleTP(CFrame.new(capturedLoc.x, capturedLoc.y, capturedLoc.z))
					if ok then
						setTPStatus("Vehicle → "..capturedLoc.name, T.AccOn)
					else
						setTPStatus("Tidak di kendaraan!", Color3.fromRGB(255,160,0))
					end
				end)

				normalBtn.MouseButton1Click:Connect(function()
					if tpActive then setTPStatus("Sedang proses TP...", T.TextDim)
						return end
					task.spawn(function()
						tpToPos(capturedLoc.x, capturedLoc.y, capturedLoc.z, nil, capturedLoc.name)
						setTPStatus("Arrived: "..capturedLoc.name, T.Green)
					end)
				end)

				suicideBtn.MouseButton1Click:Connect(function()
					if tpBusy then setTPStatus("Sedang proses TP...", T.TextDim)
						return end
					showConfirm(capturedLoc.name, function()
						task.spawn(function() doSuicideTP(capturedLoc) end)
					end)
				end)
			end

			hdr.MouseButton1Click:Connect(function()
				secOpen = not secOpen
				if secOpen then
					TweenService:Create(cont, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Size=UDim2.new(1,0,0,totalH)}):Play()
					arrow.Text="^"
					titleL.TextColor3=T.Text
				else
					TweenService:Create(cont, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{Size=UDim2.new(1,0,0,0)}):Play()
					arrow.Text="v"
					titleL.TextColor3=T.TextDim
				end
			end)
		end

		for i, cat in ipairs(TP_CATEGORIES) do
			buildTPSection(cat, (i-1)*2 + 1)
		end

		-- TP TO PLAYER
		do
			local plrTPOpen = false
			local plrTPRows = {}

			local plrHdr = Instance.new("TextButton", PageTP)
			plrHdr.Size = UDim2.new(1,0,0,38)
			plrHdr.BackgroundColor3 = T.Card
			plrHdr.Text = ""
			plrHdr.AutoButtonColor = false
			plrHdr.LayoutOrder = 999
			Instance.new("UICorner", plrHdr).CornerRadius = UDim.new(0,10)
			Instance.new("UIStroke", plrHdr).Color = T.Stroke

			local plrTitle = Instance.new("TextLabel", plrHdr)
			plrTitle.Size = UDim2.new(1,-90,1,0)
			plrTitle.Position = UDim2.new(0,14,0,0)
			plrTitle.BackgroundTransparency=1
			plrTitle.Text="TP to Player"
			plrTitle.TextColor3=T.TextDim
			plrTitle.Font=Enum.Font.GothamBlack
			plrTitle.TextSize=16
			plrTitle.TextXAlignment=Enum.TextXAlignment.Left

			local plrArrow = Instance.new("TextLabel", plrHdr)
			plrArrow.Size=UDim2.new(0,20,1,0)
			plrArrow.Position=UDim2.new(1,-24,0,0)
			plrArrow.BackgroundTransparency=1
			plrArrow.Text="v"
			plrArrow.TextColor3=T.TextDim
			plrArrow.Font=Enum.Font.GothamBlack
			plrArrow.TextSize=16

			local plrCont = Instance.new("Frame", PageTP)
			plrCont.Size = UDim2.new(1,0,0,0)
			plrCont.BackgroundColor3 = Color3.fromRGB(19, 24, 40)
			plrCont.ClipsDescendants = true
			plrCont.LayoutOrder = 1000
			Instance.new("UICorner", plrCont).CornerRadius = UDim.new(0,10)
			Instance.new("UIStroke", plrCont).Color = T.Stroke

			local plrLayout = Instance.new("UIListLayout", plrCont)
			plrLayout.Padding = UDim.new(0,3)
			plrLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local plrPad = Instance.new("UIPadding", plrCont)
			plrPad.PaddingTop=UDim.new(0,5)
			plrPad.PaddingBottom=UDim.new(0,5)
			plrPad.PaddingLeft=UDim.new(0,5)
			plrPad.PaddingRight=UDim.new(0,5)

			local function buildPlayerList()
				for _, r in pairs(plrTPRows) do pcall(function() r:Destroy() end) end
				plrTPRows = {}
				local players = game.Players:GetPlayers()
				for idx, p in ipairs(players) do
					if p == plr then continue end
					local row = Instance.new("Frame", plrCont)
					row.Size = UDim2.new(1,0,0,30)
					row.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
					row.LayoutOrder = idx
					Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
					Instance.new("UIStroke", row).Color = T.Stroke

					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(1,-200,1,0)
					nameLbl.Position = UDim2.new(0,10,0,0)
					nameLbl.BackgroundTransparency=1
					nameLbl.Text=p.DisplayName.."("..p.Name..")"
					nameLbl.TextColor3=T.Text
					nameLbl.Font=Enum.Font.GothamBlack
					nameLbl.TextSize=15
					nameLbl.TextXAlignment=Enum.TextXAlignment.Left
					nameLbl.TextTruncate=Enum.TextTruncate.AtEnd

					local goBtn = Instance.new("TextButton", row)
					goBtn.Size=UDim2.new(0,36,0,20)
					goBtn.Position=UDim2.new(1,-200,0.5,-10)
					goBtn.BackgroundColor3=Color3.fromRGB(15,40,25)
					goBtn.Text=""
					goBtn.TextColor3=Color3.fromRGB(100,220,140)
					goBtn.Font=Enum.Font.GothamBlack
					goBtn.TextSize=13
					goBtn.AutoButtonColor=false
					Instance.new("UICorner", goBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", goBtn).Color=Color3.fromRGB(50,130,80)

					local vehKillBtn = Instance.new("TextButton", row)
					vehKillBtn.Size=UDim2.new(0,44,0,20)
					vehKillBtn.Position=UDim2.new(1,-160,0.5,-10)
					vehKillBtn.BackgroundColor3=Color3.fromRGB(20,38,70)
					vehKillBtn.Text=""
					vehKillBtn.TextColor3=Color3.fromRGB(90,160,255)
					vehKillBtn.Font=Enum.Font.GothamBlack
					vehKillBtn.TextSize=12
					vehKillBtn.AutoButtonColor=false
					Instance.new("UICorner", vehKillBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", vehKillBtn).Color=Color3.fromRGB(50,90,160)

					local killBtn = Instance.new("TextButton", row)
					killBtn.Size=UDim2.new(0,54,0,20)
					killBtn.Position=UDim2.new(1,-112,0.5,-10)
					killBtn.BackgroundColor3=Color3.fromRGB(50,15,20)
					killBtn.Text="TP"
					killBtn.TextColor3=Color3.fromRGB(220,80,100)
					killBtn.Font=Enum.Font.GothamBlack
					killBtn.TextSize=12
					killBtn.AutoButtonColor=false
					Instance.new("UICorner", killBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", killBtn).Color=Color3.fromRGB(120,40,60)

					local captured = p

					goBtn.MouseButton1Click:Connect(function()
						if tpActive then setTPStatus("Sedang proses TP...", T.TextDim)
							return end
						local ch2 = captured.Character
						local hrp2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
						if not hrp2 then setTPStatus("Player tidak ditemukan!", T.TextDim)
							return end
						local tx, ty, tz = hrp2.Position.X, hrp2.Position.Y, hrp2.Position.Z
						task.spawn(function()
							tpToPos(tx, ty, tz, nil, captured.Name)
							setTPStatus("Arrived: "..captured.Name, T.Green)
						end)
					end)

					vehKillBtn.MouseButton1Click:Connect(function()
						local ch2 = captured.Character
						local hrp2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
						if not hrp2 then setTPStatus("Player tidak ditemukan!", T.TextDim)
							return end
						local ok = doVehicleTP(CFrame.new(hrp2.Position.X, hrp2.Position.Y, hrp2.Position.Z))
						if ok then
							setTPStatus("Vehicle → "..captured.Name, T.AccOn)
						else
							setTPStatus("Tidak di kendaraan!", Color3.fromRGB(255,160,0))
						end
					end)

					killBtn.MouseButton1Click:Connect(function()
						if tpBusy then setTPStatus("Processing...", T.TextDim)
							return end
						local ch2 = captured.Character
						local hrp2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
						if not hrp2 then setTPStatus("Player tidak ditemukan!", T.TextDim)
							return end
						local tx, ty, tz = hrp2.Position.X, hrp2.Position.Y, hrp2.Position.Z
						showConfirm(captured.Name, function()
							task.spawn(function()
								tpBusy = true
								openBonusTPOverlay(captured.Name)
								setTPStatus("Warp → "..captured.Name.."...", T.AccOn)
								local selfCh = plr.Character
								local selfHrp = selfCh and selfCh:FindFirstChild("HumanoidRootPart")
								if not selfHrp then tpBusy=false
									closeBonusTPOverlay()
									return end
								selfHrp.CFrame = CFrame.new(RESPAWN_WARP)
								local newChar = plr.CharacterAdded:Wait()
								local newHrp = newChar:WaitForChild("HumanoidRootPart", 8)
								if not newHrp then tpBusy=false
									closeBonusTPOverlay()
									return end
								updateBonusTPLabel(captured.Name)
								task.wait(0.6)
								newHrp.CFrame = CFrame.new(tx, ty + 3, tz)
								task.wait(0.2)
								closeBonusTPOverlay()
								setTPStatus("Arrived: "..captured.Name, T.Green)
								tpBusy = false
							end)
						end)
					end)

					table.insert(plrTPRows, row)
				end

				local refreshRow = Instance.new("TextButton", plrCont)
				refreshRow.Size=UDim2.new(1,0,0,24)
				refreshRow.BackgroundColor3=Color3.fromRGB(24, 32, 52)
				refreshRow.Text="Refresh List"
				refreshRow.TextColor3=T.AccOn
				refreshRow.Font=Enum.Font.GothamBlack
				refreshRow.TextSize=15
				refreshRow.AutoButtonColor=false
				refreshRow.LayoutOrder=0
				Instance.new("UICorner", refreshRow).CornerRadius=UDim.new(0,6)
				refreshRow.MouseButton1Click:Connect(function()
					buildPlayerList()
					local count = #plrTPRows
					if plrTPOpen then
						local newH = (count * 31) + 34
						TweenService:Create(plrCont, TweenInfo.new(0.15), {Size=UDim2.new(1,0,0,newH)}):Play()
					end
				end)
				table.insert(plrTPRows, refreshRow)
				return #plrTPRows - 1
			end

			plrHdr.MouseButton1Click:Connect(function()
				plrTPOpen = not plrTPOpen
				if plrTPOpen then
					buildPlayerList()
					local count = math.max(#plrTPRows - 1, 0)
					local newH = (count * 31) + 34
					TweenService:Create(plrCont, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Size=UDim2.new(1,0,0,newH)}):Play()
					plrArrow.Text="^"
					plrTitle.TextColor3=T.Text
				else
					TweenService:Create(plrCont, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{Size=UDim2.new(1,0,0,0)}):Play()
					plrArrow.Text="v"
					plrTitle.TextColor3=T.TextDim
				end
			end)

			game.Players.PlayerAdded:Connect(function()
				if plrTPOpen then task.wait(0.5)
					buildPlayerList() end
			end)
			game.Players.PlayerRemoving:Connect(function()
				if plrTPOpen then task.wait(0.1)
					buildPlayerList() end
			end)
		end
	end

	-- ============================================================
	-- VEHICLE PAGE
	-- ============================================================
	_buildVehicle = function()
		local vFlyActive = false
		local vFlySpeed = 50
		local vLockedCF = nil
		local vFlyLoop = nil
		local vCam = workspace.CurrentCamera

		local function vStopFly()
			vLockedCF = nil
			if vFlyLoop then vFlyLoop:Disconnect()
				vFlyLoop = nil end
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
						local pg = PageVehicle
						local tgl = pg:FindFirstChild("VEH_FlyToggle")
						if tgl then
							local pill = tgl:FindFirstChildOfClass("Frame")
							if pill then
								pill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
								local lbl = pill:FindFirstChildOfClass("TextLabel")
								if lbl then lbl.Text="OFF"
									lbl.TextColor3=T.TextDim end
							end
							tgl.BackgroundColor3 = T.Card
						end
					end
				end
			end)
		end

		local secHdr = Instance.new("TextLabel", PageVehicle)
		secHdr.Size = UDim2.new(1,0,0,22)
		secHdr.BackgroundTransparency = 1
		secHdr.Text = "VEHICLE FLY"
		secHdr.TextColor3 = T.AccOn
		secHdr.Font = Enum.Font.GothamBlack
		secHdr.TextSize = 13
		secHdr.TextXAlignment = Enum.TextXAlignment.Left

		local function makeToggleBar(parent, flag, label, accent)
			local bar = Instance.new("TextButton", parent)
			bar.Name = "VEH_FlyToggle"
			bar.Size = UDim2.new(1,0,0,46)
			bar.BackgroundColor3 = T.Card
			bar.Text = ""
			bar.AutoButtonColor = false
			Instance.new("UICorner", bar).CornerRadius = UDim.new(0,10)
			Instance.new("UIStroke", bar).Color = T.Stroke

			local lbl = Instance.new("TextLabel", bar)
			lbl.Size = UDim2.new(1,-70,1,0)
			lbl.Position = UDim2.new(0,14,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = label
			lbl.TextColor3 = T.Text
			lbl.Font = Enum.Font.GothamBlack
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local pill = Instance.new("Frame", bar)
			pill.Size = UDim2.new(0,48,0,22)
			pill.Position = UDim2.new(1,-58,0.5,-11)
			pill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
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
					bar.BackgroundColor3 = Color3.fromRGB(24, 34, 58)
					pill.BackgroundColor3 = T.AccOn
					pillLbl.Text = "ON"
					pillLbl.TextColor3 = Color3.fromRGB(255,255,255)
				else
					vStopFly()
					bar.BackgroundColor3 = T.Card
					pill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
					pillLbl.Text = "OFF"
					pillLbl.TextColor3 = T.TextDim
				end
			end)
			return bar
		end
		makeToggleBar(PageVehicle, "VehicleFly", "Vehicle Fly (WASD + E naik / Q turun)", T.AccOn)

		local sCard = Instance.new("Frame", PageVehicle)
		sCard.Size = UDim2.new(1,0,0,58)
		sCard.BackgroundColor3 = T.Card
		Instance.new("UICorner", sCard).CornerRadius = UDim.new(0,10)
		Instance.new("UIStroke", sCard).Color = T.Stroke

		local sLbl = Instance.new("TextLabel", sCard)
		sLbl.Size = UDim2.new(1,-16,0,22)
		sLbl.Position = UDim2.new(0,14,0,4)
		sLbl.BackgroundTransparency = 1
		sLbl.Text = "Fly Speed: "..vFlySpeed
		sLbl.TextColor3 = T.Text
		sLbl.Font = Enum.Font.GothamSemibold
		sLbl.TextSize = 12
		sLbl.TextXAlignment = Enum.TextXAlignment.Left

		local sTrack = Instance.new("Frame", sCard)
		sTrack.Size = UDim2.new(1,-24,0,6)
		sTrack.Position = UDim2.new(0,12,0,36)
		sTrack.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
		Instance.new("UICorner", sTrack).CornerRadius = UDim.new(1,0)

		local sFill = Instance.new("Frame", sTrack)
		sFill.Size = UDim2.new((vFlySpeed-10)/490,0,1,0)
		sFill.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", sFill).CornerRadius = UDim.new(1,0)

		local sKnob = Instance.new("Frame", sTrack)
		sKnob.Size = UDim2.new(0,12,0,12)
		sKnob.Position = UDim2.new((vFlySpeed-10)/490,-6,0.5,-6)
		sKnob.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", sKnob).CornerRadius = UDim.new(1,0)

		local sDragging = false
		local function updateVehSlider(pos)
			local rel = math.clamp((pos.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
			vFlySpeed = math.floor(10 + rel * 490)
			sFill.Size = UDim2.new(rel,0,1,0)
			sKnob.Position = UDim2.new(rel,-6,0.5,-6)
			sLbl.Text = "Fly Speed: "..vFlySpeed
		end
		sTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sDragging=true
				updateVehSlider(i.Position) end end)
		sKnob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sDragging=true end end)
		UIS.InputChanged:Connect(function(i) if sDragging and i.UserInputType==Enum.UserInputType.MouseMovement then updateVehSlider(i.Position) end end)
		UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sDragging=false end end)

		local infoCard = Instance.new("Frame", PageVehicle)
		infoCard.Size = UDim2.new(1,0,0,80)
		infoCard.BackgroundColor3 = Color3.fromRGB(14, 20, 36)
		Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0,10)
		Instance.new("UIStroke", infoCard).Color = T.Stroke

		local infoTxt = Instance.new("TextLabel", infoCard)
		infoTxt.Size = UDim2.new(1,-16,1,-8)
		infoTxt.Position = UDim2.new(0,8,0,4)
		infoTxt.BackgroundTransparency = 1
		infoTxt.Text = "ℹ Duduk di kendaraan dulu sebelum ON\n• W/A/S/D = gerak ngikutin kamera\n• E = naik | Q = turun\n• Auto OFF kalau keluar kendaraan"
		infoTxt.TextColor3 = T.AccOn
		infoTxt.Font = Enum.Font.Gotham
		infoTxt.TextSize = 12
		infoTxt.TextXAlignment = Enum.TextXAlignment.Left
		infoTxt.TextYAlignment = Enum.TextYAlignment.Top

		local secHdr2 = Instance.new("TextLabel", PageVehicle)
		secHdr2.Size = UDim2.new(1,0,0,22)
		secHdr2.BackgroundTransparency = 1
		secHdr2.Text = "VEHICLE TELEPORT"
		secHdr2.TextColor3 = T.AccOn
		secHdr2.Font = Enum.Font.GothamBlack
		secHdr2.TextSize = 13
		secHdr2.TextXAlignment = Enum.TextXAlignment.Left

		local vehTPInfo = Instance.new("Frame", PageVehicle)
		vehTPInfo.Size = UDim2.new(1,0,0,70)
		vehTPInfo.BackgroundColor3 = Color3.fromRGB(14, 20, 36)
		Instance.new("UICorner", vehTPInfo).CornerRadius = UDim.new(0,10)
		Instance.new("UIStroke", vehTPInfo).Color = T.Stroke

		local vehTPTxt = Instance.new("TextLabel", vehTPInfo)
		vehTPTxt.Size = UDim2.new(1,-16,1,-8)
		vehTPTxt.Position = UDim2.new(0,8,0,4)
		vehTPTxt.BackgroundTransparency = 1
		vehTPTxt.Text = "Tombol [VEH] ada di tab TP — di setiap\nlokasi dan setiap player.\nKlik [VEH] saat duduk di kendaraan untuk\ntp kendaraan langsung ke tujuan."
		vehTPTxt.TextColor3 = T.AccOn
		vehTPTxt.Font = Enum.Font.Gotham
		vehTPTxt.TextSize = 12
		vehTPTxt.TextXAlignment = Enum.TextXAlignment.Left
		vehTPTxt.TextYAlignment = Enum.TextYAlignment.Top
	end

	-- ============================================================
	-- FARM PAGE — AUTO FARM MARSHMALLOW
	-- ============================================================
	_buildFarm = function()
		local FarmActive = false
		local FarmBatchAmount = 1

		local WS  = workspace
		local RS  = game:GetService("ReplicatedStorage")
		local PPS = game:GetService("ProximityPromptService")
		local VU  = game:GetService("VirtualUser")

		local originalGravity = WS.Gravity
		local modifiedParts   = {}
		local ghostConn       = nil
		local OwnedKitchenPos = nil
		local OwnedDoorPos    = nil

		local mBags = {
			"Marshmallow", "Marshmellow", "Large Marshmallow Bag", "Large Marshmellow Bag",
			"Medium Marshmallow Bag", "Medium Marshmellow Bag", "Small Marshmallow Bag", "Small Marshmellow Bag"
		}
		local shopPos = Vector3.new(510.50, 4.5, 598.28)
		local sellPos = shopPos

		local ApartmentData = {
			{ ID = 1, BuyPos = Vector3.new(1108.82, 10.11, 453.35), DoorPos = Vector3.new(1115.17, 10.11, 456.57), KitchenPos = Vector3.new(1142.81, 4.11, 449.94) },
			{ ID = 2, BuyPos = Vector3.new(1108.79, 10.11, 424.20), DoorPos = Vector3.new(1114.19, 10.11, 428.26), KitchenPos = Vector3.new(1142.80, 4.14, 423.56) },
			{ ID = 3, BuyPos = Vector3.new(1018.19, 10.11, 246.44), DoorPos = Vector3.new(1012.79, 10.11, 242.32), KitchenPos = Vector3.new(984.11, 4.11, 247.28) },
			{ ID = 4, BuyPos = Vector3.new(1018.12, 10.11, 218.03), DoorPos = Vector3.new(1012.66, 10.08, 213.73), KitchenPos = Vector3.new(984.15, 4.11, 218.77) },
			{ ID = 5, BuyPos = Vector3.new(927.72, 10.11, 72.27),  DoorPos = Vector3.new(931.79, 10.11, 67.12),  KitchenPos = Vector3.new(926.84, 4.11, 38.49) },
			{ ID = 6, BuyPos = Vector3.new(899.17, 10.11, 72.51),  DoorPos = Vector3.new(902.99, 10.11, 67.16),  KitchenPos = Vector3.new(898.65, 4.11, 38.53) },
			{ ID = 7, BuyPos = Vector3.new(1197.11, 3.71, -237.50), DoorPos = Vector3.new(1199.14, 3.71, -243.04), KitchenPos = Vector3.new(1202.15, -2.29, -220.04) },
			{ ID = 8, BuyPos = Vector3.new(1196.79, 3.71, -201.87), DoorPos = Vector3.new(1199.00, 3.71, -207.04), KitchenPos = Vector3.new(1202.14, -2.29, -180.56) },
			{ ID = 9, BuyPos = Vector3.new(1185.65, 3.71, -207.83), DoorPos = Vector3.new(1183.52, 3.71, -202.90), KitchenPos = Vector3.new(1180.38, -2.29, -188.99) },
			{ ID = 10, BuyPos = Vector3.new(1185.42, 3.71, -243.37), DoorPos = Vector3.new(1183.58, 3.71, -238.20), KitchenPos = Vector3.new(1180.41, -2.29, -227.24) }
		}

		-- UI
		local fHdr = Instance.new("TextLabel", PageFarm)
		fHdr.Size = UDim2.new(1, 0, 0, 22)
		fHdr.BackgroundTransparency = 1
		fHdr.Text = "AUTO FARM MARSHMALLOW"
		fHdr.TextColor3 = T.AccOn
		fHdr.Font = Enum.Font.GothamBlack
		fHdr.TextSize = 13
		fHdr.TextXAlignment = Enum.TextXAlignment.Left

		local farmStatusLbl = Instance.new("TextLabel", PageFarm)
		farmStatusLbl.Size = UDim2.new(1, 0, 0, 18)
		farmStatusLbl.BackgroundTransparency = 1
		farmStatusLbl.Text = ""
		farmStatusLbl.TextColor3 = T.AccOn
		farmStatusLbl.Font = Enum.Font.GothamBlack
		farmStatusLbl.TextSize = 13
		farmStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

		local function setFarmStatus(txt, col)
			farmStatusLbl.Text = txt
			farmStatusLbl.TextColor3 = col or T.AccOn
		end

		local farmBar = Instance.new("TextButton", PageFarm)
		farmBar.Size = UDim2.new(1, 0, 0, 44)
		farmBar.BackgroundColor3 = T.Card
		farmBar.Text = ""
		farmBar.AutoButtonColor = false
		Instance.new("UICorner", farmBar).CornerRadius = UDim.new(0, 10)
		local farmBarStr = Instance.new("UIStroke", farmBar)
		farmBarStr.Color = T.Stroke

		local farmDot = Instance.new("Frame", farmBar)
		farmDot.Size = UDim2.new(0, 8, 0, 8)
		farmDot.Position = UDim2.new(0, 14, 0.5, -4)
		farmDot.BackgroundColor3 = T.TextDim
		Instance.new("UICorner", farmDot).CornerRadius = UDim.new(1, 0)

		local farmNameLbl = Instance.new("TextLabel", farmBar)
		farmNameLbl.Size = UDim2.new(1, -80, 1, 0)
		farmNameLbl.Position = UDim2.new(0, 28, 0, 0)
		farmNameLbl.BackgroundTransparency = 1
		farmNameLbl.Text = "Start Auto Farm"
		farmNameLbl.TextColor3 = T.TextDim
		farmNameLbl.Font = Enum.Font.GothamBlack
		farmNameLbl.TextSize = 14
		farmNameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local farmPill = Instance.new("Frame", farmBar)
		farmPill.Size = UDim2.new(0, 48, 0, 22)
		farmPill.Position = UDim2.new(1, -56, 0.5, -11)
		farmPill.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
		Instance.new("UICorner", farmPill).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", farmPill).Color = T.Stroke
		local farmPillLbl = Instance.new("TextLabel", farmPill)
		farmPillLbl.Size = UDim2.new(1, 0, 1, 0)
		farmPillLbl.BackgroundTransparency = 1
		farmPillLbl.Text = "OFF"
		farmPillLbl.TextColor3 = T.TextDim
		farmPillLbl.Font = Enum.Font.GothamBlack
		farmPillLbl.TextSize = 12

		local function refreshFarmBar()
			local on = FarmActive
			farmBar.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or T.Card
			farmBarStr.Color = on and T.StrokeOn or T.Stroke
			farmDot.BackgroundColor3 = on and T.AccOn or T.TextDim
			farmNameLbl.TextColor3 = on and T.Text or T.TextDim
			farmPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(24, 32, 52)
			farmPillLbl.Text = on and "ON" or "OFF"
			farmPillLbl.TextColor3 = on and Color3.fromRGB(255,255,255) or T.TextDim
			local st = farmPill:FindFirstChildOfClass("UIStroke")
			if on then
				if st then st:Destroy() end
			else
				if not st then Instance.new("UIStroke", farmPill).Color = T.Stroke end
			end
		end
		refreshFarmBar()

		local sCard = Instance.new("Frame", PageFarm)
		sCard.Size = UDim2.new(1, 0, 0, 58)
		sCard.BackgroundColor3 = T.Card
		Instance.new("UICorner", sCard).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", sCard).Color = T.Stroke

		local sLbl = Instance.new("TextLabel", sCard)
		sLbl.Size = UDim2.new(1, -16, 0, 22)
		sLbl.Position = UDim2.new(0, 14, 0, 4)
		sLbl.BackgroundTransparency = 1
		sLbl.Text = "Mau Masak Berapa: " .. FarmBatchAmount .. "x"
		sLbl.TextColor3 = T.Text
		sLbl.Font = Enum.Font.GothamSemibold
		sLbl.TextSize = 12
		sLbl.TextXAlignment = Enum.TextXAlignment.Left

		local sTrack = Instance.new("Frame", sCard)
		sTrack.Size = UDim2.new(1, -24, 0, 6)
		sTrack.Position = UDim2.new(0, 12, 0, 36)
		sTrack.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
		Instance.new("UICorner", sTrack).CornerRadius = UDim.new(1, 0)

		local sFill = Instance.new("Frame", sTrack)
		sFill.Size = UDim2.new((FarmBatchAmount-1)/49, 0, 1, 0)
		sFill.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)

		local sKnob = Instance.new("Frame", sTrack)
		sKnob.Size = UDim2.new(0, 12, 0, 12)
		sKnob.Position = UDim2.new((FarmBatchAmount-1)/49, -6, 0.5, -6)
		sKnob.BackgroundColor3 = T.AccOn
		Instance.new("UICorner", sKnob).CornerRadius = UDim.new(1, 0)

		local sDragging = false
		local function updateFarmSlider(pos)
			local rel = math.clamp((pos.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
			FarmBatchAmount = math.floor(1 + rel * 49)
			sFill.Size = UDim2.new(rel, 0, 1, 0)
			sKnob.Position = UDim2.new(rel, -6, 0.5, -6)
			sLbl.Text = "Mau Masak Berapa: " .. FarmBatchAmount .. "x"
		end
		sTrack.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
				sDragging = true
				updateFarmSlider(i.Position)
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if sDragging and (i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch) then
				updateFarmSlider(i.Position)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
				sDragging = false
			end
		end)

		local infoCard = Instance.new("Frame", PageFarm)
		infoCard.Size = UDim2.new(1, 0, 0, 76)
		infoCard.BackgroundColor3 = Color3.fromRGB(14, 20, 36)
		Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", infoCard).Color = T.Stroke

		local infoTxt = Instance.new("TextLabel", infoCard)
		infoTxt.Size = UDim2.new(1, -16, 1, -8)
		infoTxt.Position = UDim2.new(0, 8, 0, 4)
		infoTxt.BackgroundTransparency = 1
		infoTxt.Text = "• Auto beli bahan → masak → jual\n• Cari apartment kosong otomatis\n• Noclip + Anti-AFK saat farm jalan"
		infoTxt.TextColor3 = T.AccOn
		infoTxt.Font = Enum.Font.Gotham
		infoTxt.TextSize = 12
		infoTxt.TextXAlignment = Enum.TextXAlignment.Left
		infoTxt.TextYAlignment = Enum.TextYAlignment.Top

		-- FARM LOGIC (unchanged)
		local function checkDeathStatus()
			if not FarmActive then return true end
			local char = plr.Character
			if not char then return true end
			local hum = char:FindFirstChild("Humanoid")
			if hum and hum.Health <= 0 then return true end
			return false
		end

		local function startGhostMode()
			if ghostConn then return end
			ghostConn = RunService.Heartbeat:Connect(function()
				local char = plr.Character
				if not char or not char:FindFirstChild("HumanoidRootPart") then return end
				local hum = char:FindFirstChild("Humanoid")
				if hum and hum.Sit then return end
				local hrp = char.HumanoidRootPart

				local function processNoclipPart(part)
					if not part or not part:IsA("BasePart") or part:IsA("Terrain") then return end
					if part:IsDescendantOf(char) then return end
					if part:IsA("Seat") or part:IsA("VehicleSeat") or part.Name:lower():find("seat") then return end
					local model = part:FindFirstAncestorOfClass("Model")
					if model and (model:FindFirstChildOfClass("VehicleSeat", true) or model:FindFirstChildOfClass("Seat", true)) then return end
					if not modifiedParts[part] then
						modifiedParts[part] = { CanCollide = part.CanCollide, CanTouch = part.CanTouch }
					end
					part.CanCollide = false
					part.CanTouch = false
				end

				for _, part in ipairs(hrp:GetTouchingParts()) do
					processNoclipPart(part)
				end

				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.FilterDescendantsInstances = {char}

				local checkDirs = {
					Vector3.new(0, -4, 0),
					hrp.CFrame.LookVector * 3.5,
					-hrp.CFrame.LookVector * 3.5,
					hrp.CFrame.RightVector * 3.5,
					-hrp.CFrame.RightVector * 3.5
				}
				for _, dir in ipairs(checkDirs) do
					local res = workspace:Raycast(hrp.Position, dir, params)
					if res and res.Instance then processNoclipPart(res.Instance) end
				end
			end)
		end

		local function stopGhostMode()
			if ghostConn then ghostConn:Disconnect(); ghostConn = nil end
			for part, state in pairs(modifiedParts) do
				if part and part.Parent then
					part.CanCollide = state.CanCollide
					part.CanTouch = state.CanTouch
				end
			end
			modifiedParts = {}
		end

		local function discreteStepTP(startP, endP)
			local stepDistance = 0.8
			local char = plr.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
			local hrp = char.HumanoidRootPart
			while FarmActive do
				if checkDeathStatus() then return false end
				local dist = (endP - hrp.Position).Magnitude
				if dist <= stepDistance then
					hrp.CFrame = CFrame.new(endP)
					hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					return true
				else
					hrp.CFrame = CFrame.new(hrp.Position + ((endP - hrp.Position).Unit * stepDistance))
					hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				end
				task.wait(0.08)
			end
			return false
		end

		local function blinkTeleport(targetPos, isUnderground)
			local char = plr.Character
			if not char or not char:FindFirstChild('HumanoidRootPart') then return end
			startGhostMode()
			local hrp = char.HumanoidRootPart
			local humanoid = char:FindFirstChild('Humanoid')
			if humanoid then humanoid.PlatformStand = true end
			Workspace.Gravity = 0
			if isUnderground then
				local underY = -4
				discreteStepTP(hrp.Position, Vector3.new(hrp.Position.X, underY, hrp.Position.Z))
				discreteStepTP(hrp.Position, Vector3.new(targetPos.X, underY, targetPos.Z))
				discreteStepTP(hrp.Position, targetPos)
			else
				discreteStepTP(hrp.Position, targetPos)
			end
			Workspace.Gravity = originalGravity
			if humanoid then humanoid.PlatformStand = false end
			stopGhostMode()
		end

		local function BypassTP(targetPos)
			setFarmStatus("Respawn TP...", T.AccOn)
			local char = plr.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local hrp = char.HumanoidRootPart
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				bv.Velocity = Vector3.new(0, 9e9, 0)
				bv.Parent = hrp
			end
			local newChar = plr.CharacterAdded:Wait()
			local newHrp = newChar:WaitForChild("HumanoidRootPart", 10)
			if newHrp then
				task.wait(0.5)
				newHrp.CFrame = CFrame.new(targetPos)
			end
			task.wait(1.2)
		end

		local function lockPosition(targetPos)
			local char = plr.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChild("Humanoid")
			if not hrp or not humanoid then return end
			startGhostMode()
			Workspace.Gravity = 0
			humanoid.PlatformStand = true
			local oldBv = hrp:FindFirstChild("FarmLock")
			if oldBv then oldBv:Destroy() end
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FarmLock"
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Velocity = Vector3.new(0, 0, 0)
			bv.Parent = hrp
			hrp.CFrame = CFrame.new(targetPos)
			hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
			hrp.Anchored = true
		end

		local function unlockPosition()
			Workspace.Gravity = originalGravity
			local char = plr.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChild("Humanoid")
			if hrp then
				local bv = hrp:FindFirstChild("FarmLock")
				if bv then bv:Destroy() end
				hrp.Anchored = false
			end
			if humanoid then humanoid.PlatformStand = false end
			stopGhostMode()
		end

		local function countTool(nameOrList)
			local count = 0
			local char = plr.Character
			local backpack = plr:FindFirstChild("Backpack")
			local function checkContainer(container)
				if not container then return end
				for _, item in ipairs(container:GetChildren()) do
					if item:IsA("Tool") then
						if type(nameOrList) == "table" then
							for _, name in ipairs(nameOrList) do
								if item.Name == name then count = count + 1 end
							end
						elseif item.Name == nameOrList then
							count = count + 1
						end
					end
				end
			end
			checkContainer(char)
			checkContainer(backpack)
			return count
		end

		local function hasTool(toolName) return countTool(toolName) > 0 end

		local function equipTool(toolName)
			local char = plr.Character
			if not char then return false end
			local humanoid = char:FindFirstChild("Humanoid")
			if not humanoid then return false end
			if char:FindFirstChild(toolName) then return true end
			humanoid:UnequipTools()
			task.wait(0.05)
			local backpack = plr:FindFirstChild("Backpack")
			local targetTool = backpack and backpack:FindFirstChild(toolName)
			if targetTool then
				humanoid:EquipTool(targetTool)
				task.wait(0.1)
				return true
			end
			return false
		end

		local function matchPromptText(actionText, keyword)
			if not keyword then return true end
			local text = string.lower(actionText or "")
			keyword = string.lower(keyword)
			if keyword == "lock" and string.find(text, "unlock") then return false end
			return string.find(text, keyword) ~= nil
		end

		local function firePromptAt(pos, maxDist, keyword)
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj:IsA("ProximityPrompt") and obj.Enabled then
					local pPos = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent.Position
						or (obj.Parent:IsA("Attachment") and obj.Parent.WorldPosition))
					if pPos and (pos - pPos).Magnitude <= maxDist then
						if matchPromptText(obj.ActionText, keyword) then
							obj.RequiresLineOfSight = false
							obj.HoldDuration = 0
							if fireproximityprompt then
								fireproximityprompt(obj, 0)
							else
								obj:InputHoldBegin(); task.wait(0.05); obj:InputHoldEnd()
							end
							return true
						end
					end
				end
			end
			return false
		end

		local function checkPromptExistsAt(pos, maxDist, keyword)
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj:IsA("ProximityPrompt") and obj.Enabled then
					local pPos = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent.Position
						or (obj.Parent:IsA("Attachment") and obj.Parent.WorldPosition))
					if pPos and (pos - pPos).Magnitude <= maxDist then
						if matchPromptText(obj.ActionText, keyword) then return true end
					end
				end
			end
			return false
		end

		local function secureDoor(doorPos)
			local maxAttempts = 10
			for i = 1, maxAttempts do
				if not FarmActive then return false end
				if checkPromptExistsAt(doorPos, 8, "unlock") then return true end
				if checkPromptExistsAt(doorPos, 8, "lock") then
					firePromptAt(doorPos, 8, "lock")
					task.wait(0.5)
					if checkPromptExistsAt(doorPos, 8, "unlock") then
						return true
					else
						firePromptAt(doorPos, 8, "open")
						task.wait(0.7)
					end
				else
					firePromptAt(doorPos, 8, "open")
					task.wait(0.5)
				end
			end
			return false
		end

		local function SetupApartment()
			local targetData = nil
			for _, data in ipairs(ApartmentData) do
				if not FarmActive then return end
				local isVacant = false
				for _, obj in ipairs(Workspace:GetDescendants()) do
					if obj:IsA("TextLabel") and string.find(string.upper(obj.Text), "VACANT") then
						local gui = obj:FindFirstAncestorOfClass("SurfaceGui") or obj:FindFirstAncestorOfClass("BillboardGui")
						local uiPart = gui and (gui.Adornee or gui.Parent)
						if uiPart and uiPart:IsA("BasePart") and (uiPart.Position - data.BuyPos).Magnitude <= 5 then
							isVacant = true; break
						end
					end
				end
				if isVacant then targetData = data; break end
			end
			if targetData then
				BypassTP(targetData.BuyPos)
				firePromptAt(targetData.BuyPos, 5, "purchase"); task.wait(1)
				OwnedKitchenPos = targetData.KitchenPos
				OwnedDoorPos = targetData.DoorPos
				blinkTeleport(targetData.DoorPos, false)
				task.wait(0.8)
				secureDoor(targetData.DoorPos)
				return true
			end
			return false
		end

		local function robustBuy()
			local target = FarmBatchAmount
			while FarmActive do
				if checkDeathStatus() then return end
				local wCount = countTool({"Water", "Water23"})
				local sCount = countTool("Sugar Block Bag")
				local gCount = countTool("Gelatin")
				if wCount >= target and sCount >= target and gCount >= target then break end
				setFarmStatus(("Beli bahan W:%d S:%d G:%d / %d"):format(wCount, sCount, gCount, target), T.AccOn)
				local rs = RS:FindFirstChild("RemoteEvents")
				if rs and rs:FindFirstChild("ReliableRemoteEvent") then
					local remote = rs.ReliableRemoteEvent
					if gCount < target then
						local buf = buffer.create(3)
						buffer.writeu8(buf, 0, 24); buffer.writeu8(buf, 1, 19); buffer.writeu8(buf, 2, 1)
						remote:FireServer(buf); task.wait(0.35)
					end
					if sCount < target then
						local buf = buffer.create(3)
						buffer.writeu8(buf, 0, 24); buffer.writeu8(buf, 1, 19); buffer.writeu8(buf, 2, 2)
						remote:FireServer(buf); task.wait(0.35)
					end
					if wCount < target then
						local buf = buffer.create(3)
						buffer.writeu8(buf, 0, 24); buffer.writeu8(buf, 1, 19); buffer.writeu8(buf, 2, 3)
						remote:FireServer(buf); task.wait(0.35)
					end
				end
				task.wait(0.4)
			end
		end

		local function robustPutIngredient(toolNameOrList, waitTimeAfter)
			if not FarmActive then return false end
			local initialCount = countTool(toolNameOrList)
			if initialCount == 0 then return false end
			local attempts = 0
			local maxAttempts = 30
			while FarmActive and countTool(toolNameOrList) >= initialCount and attempts < maxAttempts do
				if checkDeathStatus() then return false end
				if type(toolNameOrList) == "table" then
					for _, name in ipairs(toolNameOrList) do
						if countTool(name) > 0 then equipTool(name); break end
					end
				else
					equipTool(toolNameOrList)
				end
				task.wait(0.2)
				firePromptAt(OwnedKitchenPos, 8)
				task.wait(1.2)
				attempts = attempts + 1
			end
			if countTool(toolNameOrList) < initialCount then
				if waitTimeAfter and waitTimeAfter > 0 then
					local waitStart = os.clock()
					while FarmActive and (os.clock() - waitStart) < waitTimeAfter do
						if checkDeathStatus() then return false end
						task.wait(0.5)
					end
				end
				return true
			end
			return false
		end

		local function CookAndPackRobust(batchNum)
			if not FarmActive then return end
			setFarmStatus(("Masak #%d — Water..."):format(batchNum), Color3.fromRGB(90,160,255))
			local wSuccess = robustPutIngredient({"Water", "Water23"}, 23)
			if not wSuccess then return end
			setFarmStatus(("Masak #%d — Sugar..."):format(batchNum), Color3.fromRGB(90,160,255))
			robustPutIngredient("Sugar Block Bag", 0)
			setFarmStatus(("Masak #%d — Gelatin..."):format(batchNum), Color3.fromRGB(90,160,255))
			robustPutIngredient("Gelatin", 47)
			if not FarmActive then return end
			local initialMarshmallows = countTool(mBags)
			local timeout = 0
			setFarmStatus(("Masak #%d — Packing..."):format(batchNum), Color3.fromRGB(255,160,60))
			while FarmActive and countTool(mBags) <= initialMarshmallows and timeout < 100 do
				if checkDeathStatus() then return end
				equipTool("Empty Bag")
				firePromptAt(OwnedKitchenPos, 10)
				task.wait(0.3)
				timeout = timeout + 1
			end
			if FarmActive and countTool({"Water", "Water23"}) > 0 then equipTool("Water") end
		end

		local function sellAllBags()
			if not FarmActive then return end
			for _, name in ipairs(mBags) do
				while hasTool(name) and FarmActive do
					if checkDeathStatus() then FarmActive = false; break end
					equipTool(name)
					task.wait(0.25)
					local char = plr.Character
					if char and char:FindFirstChild(name) then
						setFarmStatus("Jual " .. name .. "...", Color3.fromRGB(0,220,120))
						firePromptAt(sellPos, 8); task.wait(0.4)
					else
						task.wait(0.2)
					end
				end
			end
			task.wait(0.4)
		end

		local function RunFarm()
			local isFirstRun = true
			while FarmActive and Running do
				if isFirstRun then
					setFarmStatus("TP ke toko...", T.AccOn)
					BypassTP(shopPos)
					isFirstRun = false
				end
				setFarmStatus("Membeli bahan...", T.AccOn)
				robustBuy()
				if not FarmActive then break end

				setFarmStatus("TP ke dapur...", T.AccOn)
				blinkTeleport(OwnedKitchenPos, true)
				if not FarmActive then break end

				lockPosition(OwnedKitchenPos)

				local batchCounter = 1
				while FarmActive and (countTool({"Water", "Water23"}) > 0
					and countTool("Sugar Block Bag") > 0
					and countTool("Gelatin") > 0) do
					if checkDeathStatus() then FarmActive = false; break end
					CookAndPackRobust(batchCounter)
					batchCounter = batchCounter + 1
				end

				unlockPosition()
				if not FarmActive then break end

				setFarmStatus("TP ke toko jual...", T.AccOn)
				blinkTeleport(shopPos, true)
				lockPosition(shopPos)
				sellAllBags()
				unlockPosition()
				setFarmStatus("Siklus selesai! Loop lagi...", Color3.fromRGB(0,220,100))
			end
			unlockPosition()
		end

		farmBar.MouseButton1Click:Connect(function()
			if FarmActive then
				FarmActive = false
				refreshFarmBar()
				setFarmStatus("Stopping...", Color3.fromRGB(255,140,0))
				task.delay(2, function()
					if not FarmActive then setFarmStatus("Farm OFF.", T.TextDim) end
				end)
			else
				FarmActive = true
				refreshFarmBar()
				setFarmStatus("Starting...", T.AccOn)
				task.spawn(function()
					if not OwnedKitchenPos then
						setFarmStatus("Mencari apartment kosong...", T.AccOn)
						local ok = SetupApartment()
						if not ok then
							setFarmStatus("Tidak ada apartment kosong!", Color3.fromRGB(255,80,80))
							FarmActive = false
							refreshFarmBar()
							return
						end
					end
					RunFarm()
					if FarmActive then
						setFarmStatus("Farm dihentikan.", T.TextDim)
						FarmActive = false
						refreshFarmBar()
					end
				end)
			end
		end)

		task.spawn(function()
			while Running do
				task.wait(1)
				if not Running and FarmActive then
					FarmActive = false
					unlockPosition()
					break
				end
			end
		end)
	end

	-- ============================================================
	-- INFO PAGE
	-- ============================================================
	_buildInfo = function()
		local copyToast = Instance.new("Frame", Gui)
		copyToast.Size = UDim2.new(0, 220, 0, 36)
		copyToast.AnchorPoint = Vector2.new(0.5, 1)
		copyToast.Position = UDim2.new(0.5, 0, 1, 80)
		copyToast.BackgroundColor3 = Color3.fromRGB(14, 18, 32)
		copyToast.ZIndex = 200
		Instance.new("UICorner", copyToast).CornerRadius = UDim.new(0, 12)
		local cts = Instance.new("UIStroke", copyToast)
		cts.Color = T.StrokeOn
		cts.Thickness = 1
		local ctLbl = Instance.new("TextLabel", copyToast)
		ctLbl.Size = UDim2.new(1,0,1,0)
		ctLbl.BackgroundTransparency = 1
		ctLbl.Text = "Tersalin!"
		ctLbl.TextColor3 = T.AccOn
		ctLbl.Font = Enum.Font.GothamBlack
		ctLbl.TextSize = 14
		ctLbl.ZIndex = 201

		local toastAnim = nil
		local function showCopyToast(txt)
			ctLbl.Text = ""..txt.."tersalin!"
			if toastAnim then toastAnim:Cancel() end
			TweenService:Create(copyToast, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{Position = UDim2.new(0.5, 0, 1, -24)}):Play()
			task.delay(2, function()
				toastAnim = TweenService:Create(copyToast, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
				{Position = UDim2.new(0.5, 0, 1, 80)})
				toastAnim:Play()
			end)
		end

		local function infoCard(parent, icon, label, copyValue)
			local f = Instance.new("TextButton", parent)
			f.Size=UDim2.new(1,0,0,40)
			f.BackgroundColor3=T.Card
			f.Text=""
			f.AutoButtonColor=false
			Instance.new("UICorner", f).CornerRadius=UDim.new(0,10)
			local fStr = Instance.new("UIStroke", f)
			fStr.Color=T.Stroke

			local acc = Instance.new("Frame", f)
			acc.Size=UDim2.new(0,3,0,16)
			acc.Position=UDim2.new(0,0,0.5,-8)
			acc.BackgroundColor3=T.AccOn
			acc.BorderSizePixel=0
			Instance.new("UICorner", acc).CornerRadius=UDim.new(1,0)

			local iconLbl = Instance.new("TextLabel", f)
			iconLbl.Size=UDim2.new(0,22,1,0)
			iconLbl.Position=UDim2.new(0,14,0,0)
			iconLbl.BackgroundTransparency=1
			iconLbl.Text=icon
			iconLbl.TextColor3=T.AccOn
			iconLbl.Font=Enum.Font.GothamBlack
			iconLbl.TextSize=14

			local mainLbl = Instance.new("TextLabel", f)
			mainLbl.Size=UDim2.new(1,-100,0,18)
			mainLbl.Position=UDim2.new(0,38,0,4)
			mainLbl.BackgroundTransparency=1
			mainLbl.Text=label
			mainLbl.TextColor3=T.Text
			mainLbl.Font=Enum.Font.GothamBlack
			mainLbl.TextSize=13
			mainLbl.TextXAlignment=Enum.TextXAlignment.Left

			local subLbl = Instance.new("TextLabel", f)
			subLbl.Size=UDim2.new(1,-100,0,14)
			subLbl.Position=UDim2.new(0,38,0,22)
			subLbl.BackgroundTransparency=1
			subLbl.Text=copyValue
			subLbl.TextColor3=T.TextDim
			subLbl.Font=Enum.Font.Gotham
			subLbl.TextSize=11
			subLbl.TextXAlignment=Enum.TextXAlignment.Left
			subLbl.TextTruncate=Enum.TextTruncate.AtEnd

			local copyPill = Instance.new("Frame", f)
			copyPill.Size=UDim2.new(0,54,0,20)
			copyPill.AnchorPoint=Vector2.new(1,0.5)
			copyPill.Position=UDim2.new(1,-8,0.5,0)
			copyPill.BackgroundColor3=Color3.fromRGB(24, 32, 52)
			Instance.new("UICorner", copyPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke", copyPill).Color=T.Stroke
			local copyLbl = Instance.new("TextLabel", copyPill)
			copyLbl.Size=UDim2.new(1,0,1,0)
			copyLbl.BackgroundTransparency=1
			copyLbl.Text="COPY"
			copyLbl.TextColor3=T.AccOn
			copyLbl.Font=Enum.Font.GothamBlack
			copyLbl.TextSize=11

			f.MouseButton1Click:Connect(function()
				pcall(function() setclipboard(copyValue) end)
				copyLbl.Text=""
				copyLbl.TextColor3=T.AccOn
				copyPill.BackgroundColor3=Color3.fromRGB(28, 45, 85)
				fStr.Color=T.AccOn
				showCopyToast(label)
				task.delay(2, function()
					copyLbl.Text="COPY"
					copyLbl.TextColor3=T.AccOn
					copyPill.BackgroundColor3=Color3.fromRGB(24, 32, 52)
					fStr.Color=T.Stroke
				end)
			end)

			return f
		end

		local hdr = Instance.new("TextLabel", PageInfo)
		hdr.Size=UDim2.new(1,0,0,22)
		hdr.BackgroundTransparency=1
		hdr.Text="CONTACT — tap untuk copy"
		hdr.TextColor3=T.TextDim
		hdr.Font=Enum.Font.GothamBlack
		hdr.TextSize=12

		infoCard(PageInfo, "♪", "TikTok", "@darkhub")
		infoCard(PageInfo, "◈", "Discord", "https://discord.gg/pDEyArQ5B")

		local warn = Instance.new("Frame", PageInfo)
		warn.Size=UDim2.new(1,0,0,116)
		warn.BackgroundColor3=Color3.fromRGB(30, 12, 22)
		Instance.new("UICorner", warn).CornerRadius=UDim.new(0,10)
		local ws = Instance.new("UIStroke", warn)
		ws.Color=Color3.fromRGB(90, 30, 50)
		ws.Thickness=1

		local wl=Instance.new("TextLabel", warn)
		wl.Size=UDim2.new(1,-12,0,30)
		wl.Position=UDim2.new(0,6,0,4)
		wl.BackgroundTransparency=1
		wl.TextWrapped=true
		wl.Text="USE AT YOUR OWN RISK\nWe are not responsible for any bans."
		wl.TextColor3=Color3.fromRGB(255,120,140)
		wl.Font=Enum.Font.GothamBlack
		wl.TextSize=16

		local wl2 = Instance.new("TextLabel", warn)
		wl2.Size=UDim2.new(1,-12,0,22)
		wl2.Position=UDim2.new(0,6,0,42)
		wl2.BackgroundTransparency=1
		wl2.TextWrapped=true
		wl2.Text="DILARANG KERAS SHARING!!!"
		wl2.TextColor3=Color3.fromRGB(255,60,80)
		wl2.Font=Enum.Font.GothamBlack
		wl2.TextSize=17

		local wl3 = Instance.new("TextLabel", warn)
		wl3.Size=UDim2.new(1,-12,0,26)
		wl3.Position=UDim2.new(0,6,0,72)
		wl3.BackgroundTransparency=1
		wl3.TextWrapped=true
		wl3.Text="DILARANG MENJUAL KEMBALI SCRIPT INI!!!"
		wl3.TextColor3=Color3.fromRGB(255,200,0)
		wl3.Font=Enum.Font.GothamBlack
		wl3.TextSize=14

		local ic
		ic = game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
			if not Running then if ic then ic:Disconnect() end return end
			if Flags.InstantInteract then pcall(function() if prompt.HoldDuration>0 then prompt.HoldDuration=0.05 end end) end
		end)

		local Inv_Tags = {}

		local function createInvTag(p)
			if Inv_Tags[p] or p == game.Players.LocalPlayer then return end
			local it = Instance.new("BillboardGui")
			it.Size = UDim2.new(0, 250, 0, 150)
			it.StudsOffset = Vector3.new(0, 4, 0)
			it.AlwaysOnTop = true
			it.Enabled = false
			it.Parent = Gui
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
			while Running do
				task.wait(2)
				for _, p in pairs(game.Players:GetPlayers()) do
					if p == game.Players.LocalPlayer then continue end
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
	end

	-- ============================================================
	-- START LOGIC
	-- ============================================================
	_startLogic = function()
		local staminaConns = {}
		local function detachStamina()
			for _, c in ipairs(staminaConns) do pcall(function() c:Disconnect() end) end
			staminaConns = {}
			RunService:UnbindFromRenderStep("InfStamina")
		end

		RunService:BindToRenderStep("InfStamina", 0, function()
			if not Flags.InfStamina then return end
			pcall(function()
				local MovCtrl = require(plr.PlayerScripts["Client.Initializer"].Modules.MovementController)
				MovCtrl.Stamina = 100
			end)
		end)

		local HS_ANIM_SPEED  = 22
		local HS_FINAL_SPEED = 25
		local HS_PUSH        = HS_FINAL_SPEED - HS_ANIM_SPEED

		RunService.Heartbeat:Connect(function(dt)
			if not Flags.HybridSpeed then return end
			local char = plr.Character
			local hum  = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not hum or not root then return end
			if hum.WalkSpeed ~= HS_ANIM_SPEED then
				hum.WalkSpeed = HS_ANIM_SPEED
			end
			if hum.MoveDirection.Magnitude > 0 then
				root.CFrame = root.CFrame + hum.MoveDirection * HS_PUSH * dt
			end
		end)

		task.spawn(function()
			local lastHS = Flags.HybridSpeed
			while Running do
				task.wait(0.15)
				if Flags.HybridSpeed ~= lastHS then
					lastHS = Flags.HybridSpeed
					if not lastHS then
						pcall(function()
							local c = plr.Character
							local h = c and c:FindFirstChildOfClass("Humanoid")
							if h then h.WalkSpeed = 16 end
						end)
					end
				end
			end
		end)

		local NC_CollideData = {}
		local function NC_CacheCollide(char)
			NC_CollideData = {}
			for _, part in ipairs(char:GetChildren()) do
				pcall(function()
					if part:IsA("BasePart") and part.CanCollide ~= nil then
						NC_CollideData[part.Name] = part.CanCollide
					end
				end)
			end
		end
		if plr.Character then pcall(function() NC_CacheCollide(plr.Character) end) end
		plr.CharacterAdded:Connect(function(char)
			NC_CacheCollide(char)
		end)

		local _ncMetaInstalled = false
		local function NC_InstallMeta()
			if _ncMetaInstalled then return end
			_ncMetaInstalled = true
			pcall(function()
				local oldMeta  = getrawmetatable(game)
				local oldIndex = oldMeta.__index
				local oldNamecall = oldMeta.__namecall
				setreadonly(oldMeta, false)
				oldMeta.__index = function(self, index)
					if index == "CanCollide" then
						if typeof(self) == "Instance" and self.Name and NC_CollideData[self.Name] then
							return NC_CollideData[self.Name]
						end
					end
					return oldIndex(self, index)
				end
				oldMeta.__namecall = function(self, ...)
					local method = getnamecallmethod()
					return oldNamecall(self, ...)
				end
				setreadonly(oldMeta, true)
			end)
		end

		local noclipActive = false
		local function enableAura()
			if noclipActive then return end
			NC_InstallMeta()
			noclipActive = true
			RunService:BindToRenderStep("NoClip", 400, function()
				if not Flags.AuraKill then return end
				local char = plr.Character
				if not char then return end
				local hum = char:FindFirstChild("Humanoid")
				if not hum or hum.Health <= 0 then return end
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						pcall(function() part.CanCollide = false end)
					end
				end
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then pcall(function() root.CanCollide = false end) end
			end)
		end
		local function disableAura()
			if not noclipActive then return end
			noclipActive = false
			RunService:UnbindFromRenderStep("NoClip")
			local char = plr.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.Name and NC_CollideData[part.Name] ~= nil then
						pcall(function() part.CanCollide = NC_CollideData[part.Name] end)
					elseif part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
						pcall(function() part.CanCollide = true end)
					end
				end
			end
		end

		plr.CharacterAdded:Connect(function(char)
			if noclipActive then disableAura() end
			task.wait(0.5)
			NC_CacheCollide(char)
		end)
		task.spawn(function()
			local last = Flags.AuraKill
			while Running do
				task.wait(0.3)
				if Flags.AuraKill ~= last then
					last = Flags.AuraKill
					if last then enableAura() else disableAura() end
				end
			end
			disableAura()
		end)

		local blinkConn
		blinkConn = UIS.InputBegan:Connect(function(input, processed)
			if not Running then blinkConn:Disconnect()
				return end
			if Flags.TPNoClip and BlinkMode == "PC" and input.KeyCode==Enum.KeyCode.T then
				local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Linear),
					{CFrame=hrp.CFrame*CFrame.new(0,0,-6)}):Play()
				end
			end
		end)

		local RMB = false
		UIS.InputBegan:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=true end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=false
				AimTarget=nil end
		end)

		local ESP_MASAK_KW = {"water","sugar","gelatin","marshmallow"}
		local ESP_GUN_KW   = {"gun","pistol","rifle","ak","m4","uzi","revolver","shotgun","sniper","smg","weapon","knife","sword","blade"}

		for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
		game.Players.PlayerAdded:Connect(createESP)
		game.Players.PlayerRemoving:Connect(removeESP)

		local espCache = {}
		local espConns = {}

		local function isKW(name)
			local n = name:lower()
			for _, kw in ipairs(ESP_MASAK_KW) do
				if n:find(kw) then return true end
			end
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
							if isKW(v.Name) then
								hb = true
							else
								wn = v.Name
							end
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
				task.wait(0.1)
				watchChar(ch)
			end))
		end

		local function disconnectESPPlayer(p)
			local conns = espConns[p]
			if conns then
				for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
				espConns[p] = nil
			end
			espCache[p] = nil
		end

		for _, p in ipairs(game.Players:GetPlayers()) do
			connectESPPlayer(p)
		end
		game.Players.PlayerAdded:Connect(connectESPPlayer)
		game.Players.PlayerRemoving:Connect(disconnectESPPlayer)

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
			if not Running then renderConn:Disconnect()
				FovCircle:Remove()
				SilentFovCircle:Remove()
				SilentLine:Remove()
				return end

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
			if AimMode == "HP" then
				fovCenter = Vector2.new(vp.X / 2, vp.Y / 2)
			else
				fovCenter = mousePos
			end

			FovCircle.Radius = AimFOV_Radius
			FovCircle.Visible = Flags.AimLock and ShowAimFOV

			do
				if SilentAim then
					local saOrigin = SilentMode == "HP"
						and Vector2.new(vp.X / 2, vp.Y / 2)
						or mousePos

					local localRoot2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					local bestWorldD = math.huge
					local bestScreenPos = nil
					for _, p in pairs(game.Players:GetPlayers()) do
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
						local worldD = localRoot2 and (part.Position - localRoot2.Position).Magnitude or math.huge
						if worldD < bestWorldD then
							bestWorldD = worldD
							bestScreenPos = screenPos
						end
					end

					if bestScreenPos then
						local circlePos = SilentMode == "HP" and bestScreenPos or saOrigin
						SilentFovCircle.Position = circlePos
						SilentFovCircle.Radius   = SilentFOV_Radius
						SilentFovCircle.Visible  = ShowSilentFOV
						SilentLine.From    = saOrigin
						SilentLine.To      = bestScreenPos
						SilentLine.Visible = ShowSilentFOV
					else
						SilentFovCircle.Position = saOrigin
						SilentFovCircle.Radius   = SilentFOV_Radius
						SilentFovCircle.Visible  = ShowSilentFOV
						SilentLine.Visible = false
					end
				else
					SilentFovCircle.Visible = false
					SilentLine.Visible = false
				end
			end

			if AimTarget then
				local tHum = AimTarget.Parent and AimTarget.Parent:FindFirstChildOfClass("Humanoid")
				if not tHum or tHum.Health <= 0 then
					AimTarget = nil
				end
			end

			if AimTarget and AimMode == "PC" then
				local sp, onScreen = cam:WorldToScreenPoint(AimTarget.Position)
				if not onScreen then
					AimTarget = nil
				else
					local d = math.sqrt((sp.X - fovCenter.X)^2 + (sp.Y - fovCenter.Y)^2)
					if d > AimFOV_Radius then AimTarget = nil end
				end
			end

			local shouldAim = Flags.AimLock and localRoot and (AimMode=="HP" or RMB)

			if shouldAim then
				if AimMode=="HP" or not AimTarget then
					local bestDist, bestPart = math.huge, nil
					for _, p in pairs(game.Players:GetPlayers()) do
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
						if d <= AimFOV_Radius and d < bestDist then bestDist=d
							bestPart=targetPart end
					end
					AimTarget = bestPart
				end

				if AimTarget then
					local smooth = AimSmooth
					local targetCF
					if AimMode == "HP" then
						targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
					else
						targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
					end
					cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
					FovCircle.Color = Color3.fromRGB(255, 80, 80)
				else
					FovCircle.Color = T.Accent
				end
			else
				if AimMode=="PC" and not RMB then AimTarget = nil end
				FovCircle.Color = T.Accent
			end

			if AimMode == "HP" and AimTarget then
				local sp2, vis2 = cam:WorldToViewportPoint(AimTarget.Position)
				if vis2 and sp2.Z > 0 then
					FovCircle.Position = Vector2.new(sp2.X, sp2.Y)
				else
					FovCircle.Position = fovCenter
				end
			else
				FovCircle.Position = fovCenter
			end

			local anyESP = Flags.BoxESP or Flags.Tracer or Flags.ESPName or Flags.ESPDist or Flags.ESPHPBar or Flags.ESPWeapon or Flags.ESPSkeleton or Flags.ESPMasak
			for p, e in pairs(ESP) do
				local ch = p.Character
				local hum = ch and ch:FindFirstChildOfClass("Humanoid")
				local root = ch and ch:FindFirstChild("HumanoidRootPart")

				if not anyESP or not ch or not hum or not root then _hideESP(e)
					continue end

				local pos3, onScreen = cam:WorldToViewportPoint(root.Position)
				if not onScreen or pos3.Z <= 0 then _hideESP(e)
					continue end

				local isDead = hum.Health <= 0
				if localRoot and (root.Position - localRoot.Position).Magnitude > ESPMaxDist then _hideESP(e)
					continue end

				if Flags.ESPSkeleton and ch then
					local W2 = isDead and Color3.fromRGB(255, 80, 100) or Color3.fromRGB(90, 160, 255)
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
				local wName    = cache.wName

				local W = isDead and Color3.fromRGB(255, 80, 100) or Color3.fromRGB(90, 160, 255)
				if Flags.BoxESP then
					e.box.Color=W
					e.box.Size=Vector2.new(sX,sY)
					e.box.Position=Vector2.new(bx,by)
					e.box.Visible=(BoxESPMode=="FULL")
					local showC=(BoxESPMode=="CORNER")
					local cL=math.min(sX,sY)*0.25
					local cx=e.corners
					cx[1].From=Vector2.new(bx,by)
					cx[1].To=Vector2.new(bx+cL,by)
					cx[2].From=Vector2.new(bx,by)
					cx[2].To=Vector2.new(bx,by+cL)
					cx[3].From=Vector2.new(bx+sX,by)
					cx[3].To=Vector2.new(bx+sX-cL,by)
					cx[4].From=Vector2.new(bx+sX,by)
					cx[4].To=Vector2.new(bx+sX,by+cL)
					cx[5].From=Vector2.new(bx,by+sY)
					cx[5].To=Vector2.new(bx+cL,by+sY)
					cx[6].From=Vector2.new(bx,by+sY)
					cx[6].To=Vector2.new(bx,by+sY-cL)
					cx[7].From=Vector2.new(bx+sX,by+sY)
					cx[7].To=Vector2.new(bx+sX-cL,by+sY)
					cx[8].From=Vector2.new(bx+sX,by+sY)
					cx[8].To=Vector2.new(bx+sX,by+sY-cL)
					for ci=1,8 do cx[ci].Color=W
						cx[ci].Visible=showC end
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
				else e.hpbg.Visible=false
					e.hpbar.Visible=false
					e.hpnum.Visible=false end
				local distNow = localRoot and (root.Position-localRoot.Position).Magnitude or 100
				local tSize = math.clamp(math.floor(14 - distNow/40), 8, 14)
				if Flags.ESPName then
					e.dispname.Text=(p.DisplayName or p.Name).."(@"..p.Name..")"
					e.dispname.Size=tSize
					e.dispname.Color=W
					e.dispname.Position=Vector2.new(pos3.X,by-14)
					e.dispname.Visible=true
					e.username.Visible=false
				else e.dispname.Visible=false
					e.username.Visible=false end
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
					e.weapon.Color=T.AccOn
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
	end

	-- Expose untuk CONFIG tab
	_G.HNDRIXX_FLAGS = Flags
	_G.HNDRIXX_APARTMENTS = nil
	_G.HNDRIXX_UPD_COOK = nil
	_G.HNDRIXX_APT_CONT = nil
	_G.HNDRIXX_APT_ROWS = nil
	_G.HNDRIXX_APT_REFRESH = nil

	_G.HNDRIXX_GETSTATE = function()
		return {Flags={
			BoxESP=Flags.BoxESP,Tracer=Flags.Tracer,ESPName=Flags.ESPName,ESPDist=Flags.ESPDist,
			ESPHPBar=Flags.ESPHPBar,ESPWeapon=Flags.ESPWeapon,ESPSkeleton=Flags.ESPSkeleton,ESPMasak=Flags.ESPMasak,
			TPNoClip=Flags.TPNoClip,AimLock=Flags.AimLock,WallCheck=Flags.WallCheck,InvScan=Flags.InvScan,
			InstantInteract=Flags.InstantInteract,InfStamina=Flags.InfStamina,HybridSpeed=Flags.HybridSpeed,AuraKill=Flags.AuraKill
		},AimFOV_Radius=AimFOV_Radius,AimMax_Dist=AimMax_Dist,TracerMaxDist=TracerMaxDist,
		ESPMaxDist=ESPMaxDist,AimSmooth=AimSmooth,AimPart=AimPart,AimMode=AimMode,BoxESPMode=BoxESPMode,BlinkMode=BlinkMode}
	end
	_G.HNDRIXX_SETSTATE = function(d)
		if d.Flags then for k,v in pairs(d.Flags) do if Flags[k]~=nil then Flags[k]=v end end end
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
	_G.HNDRIXX_CONFIGPAGE = PageConfig
	_G.HNDRIXX_BTNCFG = BtnConfig

	_buildMain()
	_buildAim()
	_buildTP()
	_buildFarm()
	_buildInfo()
	_buildVehicle()
	_startLogic()
end

-- ================================================================
-- STARTUP
-- ================================================================
do
	local VirtualUser = game:GetService("VirtualUser")
	game:GetService("Players").LocalPlayer.Idled:Connect(function()
		VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)
end

showThankYouPopup()
launchMainScript()

-- ================================================================
-- CONFIG TAB
-- ================================================================
do
	task.defer(function()
		task.wait(2)
		local Http2 = game:GetService("HttpService")
		local CFG = "darkhub_configs"
		local Page = _G.HNDRIXX_CONFIGPAGE
		local BtnCfg = _G.HNDRIXX_BTNCFG
		if not Page or not BtnCfg then return end
		pcall(function() if not isfolder(CFG) then makefolder(CFG) end end)

		local T2 = {
			Card = Color3.fromRGB(19, 24, 40),
			Stroke = Color3.fromRGB(38, 48, 78),
			TextDim = Color3.fromRGB(128, 145, 180),
			Text = Color3.fromRGB(238, 244, 255),
			AccOn = Color3.fromRGB(90, 160, 255),
		}

		local stLbl = Instance.new("TextLabel", Page)
		stLbl.Size=UDim2.new(1,0,0,20)
		stLbl.BackgroundTransparency=1
		stLbl.Text=""
		stLbl.TextColor3=Color3.fromRGB(0,220,100)
		stLbl.Font=Enum.Font.GothamBlack
		stLbl.TextSize=13
		local function setStatus(txt,col)
			stLbl.Text=txt
			stLbl.TextColor3=col or Color3.fromRGB(0,220,100)
			task.delay(3,function() if stLbl.Text==txt then stLbl.Text="" end end)
		end

		local iCard=Instance.new("Frame",Page)
		iCard.Size=UDim2.new(1,0,0,40)
		iCard.BackgroundColor3=T2.Card
		Instance.new("UICorner",iCard).CornerRadius=UDim.new(0,10)
		Instance.new("UIStroke",iCard).Color=T2.Stroke

		local inp=Instance.new("TextBox",iCard)
		inp.Size=UDim2.new(1,-100,1,-10)
		inp.Position=UDim2.new(0,8,0,5)
		inp.BackgroundColor3=Color3.fromRGB(24, 32, 52)
		inp.PlaceholderText="Nama config..."
		inp.PlaceholderColor3=T2.TextDim
		inp.Text=""
		inp.TextColor3=T2.Text
		inp.Font=Enum.Font.Gotham
		inp.TextSize=13
		inp.ClearTextOnFocus=false
		Instance.new("UICorner",inp).CornerRadius=UDim.new(0,8)
		Instance.new("UIStroke",inp).Color=T2.Stroke

		local sBtn=Instance.new("TextButton",iCard)
		sBtn.Size=UDim2.new(0,80,1,-10)
		sBtn.Position=UDim2.new(1,-88,0,5)
		sBtn.BackgroundColor3=Color3.fromRGB(28, 45, 85)
		sBtn.Text="SAVE"
		sBtn.TextColor3=T2.AccOn
		sBtn.Font=Enum.Font.GothamBlack
		sBtn.TextSize=13
		sBtn.AutoButtonColor=false
		Instance.new("UICorner",sBtn).CornerRadius=UDim.new(0,8)
		Instance.new("UIStroke",sBtn).Color=T2.AccOn

		local hdr=Instance.new("TextLabel",Page)
		hdr.Size=UDim2.new(1,0,0,18)
		hdr.BackgroundTransparency=1
		hdr.Text="SAVED CONFIGS"
		hdr.TextColor3=T2.TextDim
		hdr.Font=Enum.Font.GothamBlack
		hdr.TextSize=12

		local lCont=Instance.new("Frame",Page)
		lCont.Size=UDim2.new(1,0,0,0)
		lCont.BackgroundTransparency=1
		local lLay=Instance.new("UIListLayout",lCont)
		lLay.Padding=UDim.new(0,5)
		lLay.SortOrder=Enum.SortOrder.LayoutOrder
		lLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			lCont.Size=UDim2.new(1,0,0,lLay.AbsoluteContentSize.Y)
		end)

		local rows={}
		local function rebuild()
			for _,r in pairs(rows) do pcall(function() r:Destroy() end) end
			rows={}
			local files={}
			pcall(function()
				if isfolder(CFG) then
					for _,fp in ipairs(listfiles(CFG)) do
						local n=fp:match("([^/\\]+)$") or fp
						n=n:gsub("%.json$","")
						if n~="" then table.insert(files,n) end
					end
				end
			end)
			if #files==0 then
				local e=Instance.new("TextLabel",lCont)
				e.Size=UDim2.new(1,0,0,30)
				e.BackgroundTransparency=1
				e.Text="Belum ada config"
				e.TextColor3=T2.TextDim
				e.Font=Enum.Font.Gotham
				e.TextSize=13
				table.insert(rows,e)
				return
			end
			for i,name in ipairs(files) do
				local row=Instance.new("Frame",lCont)
				row.Size=UDim2.new(1,0,0,36)
				row.BackgroundColor3=T2.Card
				row.LayoutOrder=i
				Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
				Instance.new("UIStroke",row).Color=T2.Stroke

				local nl=Instance.new("TextLabel",row)
				nl.Size=UDim2.new(1,-106,1,0)
				nl.Position=UDim2.new(0,10,0,0)
				nl.BackgroundTransparency=1
				nl.Text=name
				nl.TextColor3=T2.Text
				nl.Font=Enum.Font.GothamBlack
				nl.TextSize=14
				nl.TextXAlignment=Enum.TextXAlignment.Left
				nl.TextTruncate=Enum.TextTruncate.AtEnd

				local lb=Instance.new("TextButton",row)
				lb.Size=UDim2.new(0,46,0,22)
				lb.Position=UDim2.new(1,-100,0.5,-11)
				lb.BackgroundColor3=Color3.fromRGB(15,40,25)
				lb.Text="LOAD"
				lb.TextColor3=Color3.fromRGB(0,200,80)
				lb.Font=Enum.Font.GothamBlack
				lb.TextSize=12
				lb.AutoButtonColor=false
				Instance.new("UICorner",lb).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",lb).Color=Color3.fromRGB(40,100,60)

				local db=Instance.new("TextButton",row)
				db.Size=UDim2.new(0,42,0,22)
				db.Position=UDim2.new(1,-52,0.5,-11)
				db.BackgroundColor3=Color3.fromRGB(40,10,20)
				db.Text="DEL"
				db.TextColor3=Color3.fromRGB(220,60,80)
				db.Font=Enum.Font.GothamBlack
				db.TextSize=12
				db.AutoButtonColor=false
				Instance.new("UICorner",db).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",db).Color=Color3.fromRGB(100,30,50)

				local cap=name
				lb.MouseButton1Click:Connect(function()
					pcall(function()
						local d=Http2:JSONDecode(readfile(CFG.."/"..cap..".json"))
						if _G.HNDRIXX_SETSTATE then _G.HNDRIXX_SETSTATE(d) end
						pcall(function()
							local Fl = _G.HNDRIXX_FLAGS
							if not Fl then return end
							local cg = game:GetService("CoreGui")
							for _, gui in ipairs(cg:GetChildren()) do
								if gui.Name == "DARKHUB_UI" then
									for _, bar in ipairs(gui:GetDescendants()) do
										if bar:IsA("TextButton") and bar.Name:sub(1,16) == "HNDRIXX_TOGGLE_" then
											local fName = bar.Name:sub(17)
											local on = Fl[fName]
											if on == nil then continue end
											bar.BackgroundColor3 = on and Color3.fromRGB(24, 34, 58) or Color3.fromRGB(19, 24, 40)
											for _, c in ipairs(bar:GetChildren()) do
												if c:IsA("Frame") and c.Size == UDim2.new(0,48,0,22) then
													c.BackgroundColor3 = on and Color3.fromRGB(90, 160, 255) or Color3.fromRGB(24, 32, 52)
													local lbl = c:FindFirstChildOfClass("TextLabel")
													if lbl then
														lbl.Text = on and "ON" or "OFF"
														lbl.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 145, 180)
													end
												end
											end
										end
									end
								end
							end
						end)
						setStatus("Loaded: "..cap,Color3.fromRGB(0,220,100))
					end)
				end)
				db.MouseButton1Click:Connect(function()
					pcall(function()
						delfile(CFG.."/"..cap..".json")
						setStatus("Deleted: "..cap,Color3.fromRGB(220,100,120))
						rebuild()
					end)
				end)
				table.insert(rows,row)
			end
		end

		sBtn.MouseButton1Click:Connect(function()
			local name=inp.Text:gsub("[^%w%s%-_]",""):match("^%s*(.-)%s*$")
			if name=="" then setStatus("Masukkan nama!",Color3.fromRGB(255,180,0))
				return end
			pcall(function()
				if not isfolder(CFG) then makefolder(CFG) end
				local st = _G.HNDRIXX_GETSTATE and _G.HNDRIXX_GETSTATE() or {}
				writefile(CFG.."/"..name..".json", Http2:JSONEncode(st))
				setStatus("Saved: "..name,Color3.fromRGB(0,220,100))
				inp.Text=""
				rebuild()
			end)
		end)

		BtnCfg.MouseButton1Click:Connect(function() rebuild() end)
		rebuild()
	end)
end