-- ================================================================
-- HNDRIXX PREMIUM V2.0 — GREY EDITION (SQUARE)
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
	PopGui.Name = "HNDRIXX_Popup"
	PopGui.ResetOnSpawn = false
	PopGui.Parent = CoreGui

	local Card = Instance.new("Frame", PopGui)
	Card.Size = UDim2.new(0, 320, 0, 64)
	Card.AnchorPoint = Vector2.new(0.5, 0)
	Card.Position = UDim2.new(0.5, 0, 0, -80)
	Card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
	local cs = Instance.new("UIStroke", Card)
	cs.Color = Color3.fromRGB(50, 50, 50)
	cs.Thickness = 1

	local accent = Instance.new("Frame", Card)
	accent.Size = UDim2.new(0, 2, 0, 32)
	accent.Position = UDim2.new(0, 0, 0.5, -16)
	accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	accent.BorderSizePixel = 0
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local badge = Instance.new("Frame", Card)
	badge.Size = UDim2.new(0, 50, 0, 18)
	badge.Position = UDim2.new(0, 14, 0, 11)
	badge.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
	local bdgLbl = Instance.new("TextLabel", badge)
	bdgLbl.Size = UDim2.new(1, 0, 1, 0)
	bdgLbl.BackgroundTransparency = 1
	bdgLbl.Text = "V3.0"
	bdgLbl.TextColor3 = Color3.fromRGB(140, 140, 140)
	bdgLbl.Font = Enum.Font.GothamBlack
	bdgLbl.TextSize = 11

	local Ttl = Instance.new("TextLabel", Card)
	Ttl.Size = UDim2.new(1, -76, 0, 20)
	Ttl.Position = UDim2.new(0, 72, 0, 9)
	Ttl.BackgroundTransparency = 1
	Ttl.Text = "LENGER STORE"
	Ttl.TextColor3 = Color3.fromRGB(255, 255, 255)
	Ttl.Font = Enum.Font.GothamBlack
	Ttl.TextSize = 13
	Ttl.TextXAlignment = Enum.TextXAlignment.Left

	local Msg = Instance.new("TextLabel", Card)
	Msg.Size = UDim2.new(1, -76, 0, 16)
	Msg.Position = UDim2.new(0, 72, 0, 32)
	Msg.BackgroundTransparency = 1
	Msg.Text = "TikTok · @lenger_store"
	Msg.TextColor3 = Color3.fromRGB(90, 90, 90)
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
	local T = {
		BG = Color3.fromRGB(6, 6, 6),
		Card = Color3.fromRGB(12, 12, 12),
		CardHov = Color3.fromRGB(22, 22, 22),
		TopBar = Color3.fromRGB(16, 16, 16),
		Accent = Color3.fromRGB(210, 210, 210),
		AccOn = Color3.fromRGB(255, 255, 255),
		Stroke = Color3.fromRGB(30, 30, 30),
		StrokeOn = Color3.fromRGB(75, 75, 75),
		Text = Color3.fromRGB(255, 255, 255),
		TextDim = Color3.fromRGB(85, 85, 85),
		Red = Color3.fromRGB(220, 50, 50),
		Green = Color3.fromRGB(0, 200, 100),
	}

	local PANEL_W = 500
	local PANEL_H = 540
	local MF_MIN_W,MF_MAX_W=280,620
	local MF_MIN_H,MF_MAX_H=350,720

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "HNDRIXX_Grey"
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 20  -- di atas overlay (5) biar panel tetap keliatan pas loading
	Gui.Parent = CoreGui

	local LogoBtn = Instance.new("TextButton", Gui)
	LogoBtn.Size = UDim2.new(0, 0, 0, 0)
	LogoBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
	LogoBtn.BackgroundColor3 = T.TopBar
	LogoBtn.Text = "▣"
	LogoBtn.TextColor3 = T.AccOn
	LogoBtn.Font = Enum.Font.GothamBlack
	LogoBtn.TextSize = 20
	LogoBtn.Visible = false
	LogoBtn.Draggable = true
	Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
	local lbStr = Instance.new("UIStroke", LogoBtn)
	lbStr.Color = T.Stroke
	lbStr.Thickness = 1

	local MF = Instance.new("Frame", Gui)
	MF.Size = UDim2.new(0, 0, 0, 0)
	MF.Position = UDim2.new(0.38, 0, 0.25, 0)
	MF.BackgroundColor3 = T.BG
	MF.Active = true
	MF.Draggable = false
	MF.ClipsDescendants = true
	Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)
	local mfStr = Instance.new("UIStroke", MF)
	mfStr.Color = T.Stroke
	mfStr.Thickness = 1

	TweenService:Create(MF, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
	{Size = UDim2.new(0, PANEL_W, 0, PANEL_H)}):Play()
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

	local TitleBar = Instance.new("Frame", MF)
	TitleBar.Size = UDim2.new(1, 0, 0, 42)
	TitleBar.BackgroundColor3 = T.TopBar
	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
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
	LogoMark.Text = "▣"
	LogoMark.TextColor3 = T.AccOn
	LogoMark.Font = Enum.Font.GothamBlack
	LogoMark.TextSize = 20

	local TitleLbl = Instance.new("TextLabel", TitleBar)
	TitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
	TitleLbl.Position = UDim2.new(0, 42, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = "LENGER STORE"
	TitleLbl.TextColor3 = T.Text
	TitleLbl.Font = Enum.Font.GothamBlack
	TitleLbl.TextSize = 14
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

	local VerBadge = Instance.new("Frame", TitleBar)
	VerBadge.Size = UDim2.new(0, 46, 0, 20)
	VerBadge.AnchorPoint = Vector2.new(1, 0.5)
	VerBadge.Position = UDim2.new(1, -68, 0.5, 0)
	VerBadge.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(1, 0)
	Instance.new("UIStroke", VerBadge).Color = T.Stroke
	local VerLbl = Instance.new("TextLabel", VerBadge)
	VerLbl.Size = UDim2.new(1, 0, 1, 0)
	VerLbl.BackgroundTransparency = 1
	VerLbl.Text = "V3.0"
	VerLbl.TextColor3 = T.TextDim
	VerLbl.Font = Enum.Font.GothamBlack
	VerLbl.TextSize = 11

	local MinBtn = Instance.new("TextButton", TitleBar)
	MinBtn.Size = UDim2.new(0, 24, 0, 24)
	MinBtn.Position = UDim2.new(1, -54, 0.5, -12)
	MinBtn.Text = "—"
	MinBtn.TextColor3 = T.TextDim
	MinBtn.Font = Enum.Font.GothamBlack
	MinBtn.TextSize = 13
	MinBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
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
	CloseBtn.BackgroundColor3 = Color3.fromRGB(38, 10, 10)
	CloseBtn.AutoButtonColor = false
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", CloseBtn).Color = Color3.fromRGB(70, 20, 20)

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

	local TabBar = Instance.new("Frame", MF)
	TabBar.Position = UDim2.new(0, 8, 0, 48)
	TabBar.Size = UDim2.new(1, -16, 0, 28)
	TabBar.BackgroundTransparency = 1

	local function makeTab(lbl, x, w)
		local tb = Instance.new("TextButton", TabBar)
		tb.Size = UDim2.new(w, 0, 1, 0)
		tb.Position = UDim2.new(x, 0, 0, 0)
		tb.BackgroundColor3 = T.Card
		tb.Text = lbl
		tb.TextColor3 = T.TextDim
		tb.Font = Enum.Font.GothamBlack
		tb.TextSize = 12
		tb.AutoButtonColor = false
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
		return tb
	end

	local gap = 0.007
	local w = (1 - gap*7) / 8
	local BtnWar = makeTab("MAIN", 0, w)
	local BtnVisual = makeTab("VISUAL", (w+gap)*1, w)
	local BtnAim = makeTab("AIM", (w+gap)*2, w)
	local BtnFarm = makeTab("FARM", (w+gap)*3, w)
	local BtnTP = makeTab("TP", (w+gap)*4, w)
	local BtnInfo = makeTab("INFO", (w+gap)*5, w)
	local BtnConfig = makeTab("CFG", (w+gap)*6, w)
	local BtnVehicle = makeTab("VEH", (w+gap)*7, w)

	local allTabs = {BtnWar, BtnVisual, BtnAim, BtnFarm, BtnTP, BtnInfo, BtnConfig, BtnVehicle}

	local function setActiveTab(btn)
		for _, b in ipairs(allTabs) do
			b.BackgroundColor3 = T.Card
			b.TextColor3 = T.TextDim
		end
		btn.BackgroundColor3 = T.AccOn
		btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	end
	setActiveTab(BtnWar)

	local function makePage()
		local pg = Instance.new("ScrollingFrame", MF)
		pg.Position = UDim2.new(0, 8, 0, 82)
		pg.Size = UDim2.new(1, -16, 1, -90)
		pg.BackgroundTransparency = 1
		pg.ScrollBarThickness = 2
		pg.ScrollBarImageColor3 = T.StrokeOn
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
	local _overlayActive = false  -- true saat loading screen aktif → semua visual di-hide
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
	local SilentFOV_Radius = 120  -- radius FOV silent aim (pisah dari aimbot)
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
	-- Silent Aim
	local SilentAim = false
	local SilentAimWallbang = false
	local ShowAimFOV    = true   -- toggle tampil/sembunyi FOV aimbot
	local ShowSilentFOV = true   -- toggle tampil/sembunyi FOV silent aim
	local SilentMode = "PC" -- "PC" = ngikutin mouse | "HP" = center screen diem
	local Gc = getgc and getgc() or {}

	-- Sub-function declarations (harus di dalam launchMainScript biar bisa akses upvalues)
	local _buildMain, _buildAim, _buildTP, _buildFarm, _buildInfo, _buildVehicle, _startLogic

	local tpCancelBtn -- forward declare biar accessible dari _buildFarm
	local doSuicideTP -- forward declare biar accessible dari _buildFarm (fully auto farm)

	-- ================================================================
	-- HELPER: INSTANT VEHICLE TELEPORT (PivotTo — full model)
	-- ================================================================
	local function doVehicleTP(targetCFrame)
		local char = plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local seat = hum and hum.SeatPart
		if not seat then return false end
		local vehicle = seat:FindFirstAncestorOfClass("Model")
		if not vehicle then return false end
		local vRoot = vehicle.PrimaryPart or seat
		-- Bunuh momentum sebelum TP
		vRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		vRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		-- Teleport seluruh model sekaligus (+3 Y biar ban gak nyangkut)
		vehicle:PivotTo(targetCFrame * CFrame.new(0, 3, 0))
		-- Bunuh momentum lagi setelah mendarat
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
	-- loadSettings() -- disabled: semua mulai dari OFF

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

	-- FOV circle khusus Silent Aim (terpisah dari aimbot)
	local SilentFovCircle = Drawing.new("Circle")
	SilentFovCircle.Thickness = 1.5
	SilentFovCircle.Color = Color3.fromRGB(255, 100, 0)  -- orange
	SilentFovCircle.Filled = false
	SilentFovCircle.NumSides = 64
	SilentFovCircle.Visible = false

	local SilentLine = Drawing.new("Line")
	SilentLine.Thickness = 1.5
	SilentLine.Color = Color3.fromRGB(255, 100, 0)  -- orange, sesuai circle
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

	-- ================================================================
	-- ESP OBJECT POOL — helper functions (dipakai createESP & render loop)
	-- ================================================================
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

	-- Bikin semua Drawing object SEKALI pas player join
	local function createESP(p)
		if ESP[p] or p == game.Players.LocalPlayer then return end
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
		e.box.Thickness=1.5; e.box.Filled=false
		e.hpbg.Thickness=1; e.hpbg.Filled=true; e.hpbg.Color=Color3.fromRGB(0,0,0)
		e.hpbar.Thickness=1; e.hpbar.Filled=true
		ESP[p] = e
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Running = false
		for p in pairs(ESP) do removeESP(p) end
		FovCircle:Remove()
		Gui:Destroy()
	end)

	-- ================================================================
	-- TOGGLE BAR — FIX: support accentColor parameter

	-- Expose shared vars ke sub-functions via upvalue (closure magic)
	-- Sub-functions di-declare di atas, di-define di sini setelah vars ready

	-- ================================================================
	local TOGGLE_LABELS = {
		BoxESP="Box ESP", Tracer="Tracer",
		TPNoClip="Blink TP", AimLock="Auto Aim",
		WallCheck="Wall Check",
		InvScan="Inv Scan", InstantInteract="Instant Interact",
		InfStamina="Inf Stamina", HybridSpeed="Speed Hack", AuraKill="NoClip",
	}

	local function AddToggleBar(parent, flagName, accentColor)
		local ACCENT = accentColor or T.AccOn
		local isOn = Flags[flagName]

		local bar = Instance.new("TextButton", parent)
		bar.Name = "HNDRIXX_TOGGLE_"..flagName
		bar.Size = UDim2.new(1, 0, 0, 36)
		bar.BackgroundColor3 = isOn and Color3.fromRGB(16, 16, 16) or T.Card
		bar.Text = ""
		bar.AutoButtonColor = false
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
		local bStr = Instance.new("UIStroke", bar)
		bStr.Color = isOn and T.StrokeOn or T.Stroke
		bStr.Thickness = 1

		local dot = Instance.new("Frame", bar)
		dot.Size = UDim2.new(0, 5, 0, 5)
		dot.Position = UDim2.new(0, 12, 0.5, -2.5)
		dot.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(38, 38, 38)
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local nameLbl = Instance.new("TextLabel", bar)
		nameLbl.Size = UDim2.new(1, -76, 1, 0)
		nameLbl.Position = UDim2.new(0, 24, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = TOGGLE_LABELS[flagName] or flagName
		nameLbl.TextColor3 = isOn and T.Text or T.TextDim
		nameLbl.Font = Enum.Font.Gotham
		nameLbl.TextSize = 14
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local statusPill = Instance.new("Frame", bar)
		statusPill.Size = UDim2.new(0, 46, 0, 22)
		statusPill.Position = UDim2.new(1, -52, 0.5, -11)
		statusPill.BackgroundColor3 = isOn and ACCENT or Color3.fromRGB(20, 20, 20)
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
			bar.BackgroundColor3 = on and Color3.fromRGB(16, 16, 16) or T.Card
			bStr.Color = on and T.StrokeOn or T.Stroke
			dot.BackgroundColor3 = on and ACCENT or Color3.fromRGB(38, 38, 38)
			nameLbl.TextColor3 = on and T.Text or T.TextDim
			statusPill.BackgroundColor3 = on and ACCENT or Color3.fromRGB(20, 20, 20)
			statusLbl.Text = on and "ON" or "OFF"
			statusLbl.TextColor3 = on and Color3.fromRGB(0, 0, 0) or T.TextDim
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
		lbl.TextColor3=T.Accent
		lbl.Text=label..": "..defV..suffix

		local track = Instance.new("Frame", c)
		track.Size = UDim2.new(1, -20, 0, 4)
		track.Position = UDim2.new(0, 10, 0, 34)
		track.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
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

	-- ================================================================
	-- WAR PAGE

	_buildMain = function()
		-- ================================================================

		local HPPanel = Instance.new("Frame", Gui)
		HPPanel.Name = "HNDRIXX_HPPanel"
		HPPanel.Size = UDim2.new(0, 58, 0, 58)
		HPPanel.Position = UDim2.new(0, 16, 0.5, -29)
		HPPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		HPPanel.Active = true
		HPPanel.Visible = false
		HPPanel.ZIndex = 100
		Instance.new("UICorner", HPPanel).CornerRadius = UDim.new(0, 14)
		local hpStr = Instance.new("UIStroke", HPPanel)
		hpStr.Color = Color3.fromRGB(60, 60, 60)
		hpStr.Thickness = 1.5

		local HPTBtn = Instance.new("TextButton", HPPanel)
		HPTBtn.Size = UDim2.new(1, -10, 1, -10)
		HPTBtn.Position = UDim2.new(0, 5, 0, 5)
		HPTBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		HPTBtn.Text = "T"
		HPTBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		HPTBtn.Font = Enum.Font.GothamBlack
		HPTBtn.TextSize = 22
		HPTBtn.AutoButtonColor = false
		HPTBtn.ZIndex = 101
		Instance.new("UICorner", HPTBtn).CornerRadius = UDim.new(0, 10)
		Instance.new("UIStroke", HPTBtn).Color = Color3.fromRGB(50, 50, 50)

		local HPTLabel = Instance.new("TextLabel", HPPanel)
		HPTLabel.Size = UDim2.new(1, 0, 0, 12)
		HPTLabel.Position = UDim2.new(0, 0, 1, -13)
		HPTLabel.BackgroundTransparency = 1
		HPTLabel.Text = "BLINK"
		HPTLabel.TextColor3 = Color3.fromRGB(70, 70, 70)
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
				HPTBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				TweenService:Create(HPTBtn,
				TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
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
				mp.Size=UDim2.new(0,52,0,22)
				mp.Position=UDim2.new(1,-108,0.5,-11)
				mp.BackgroundColor3=Color3.fromRGB(22,22,22)
				mp.Text=BoxESPMode
				mp.TextColor3=Color3.fromRGB(200,200,200)
				mp.Font=Enum.Font.GothamBlack
				mp.TextSize=11
				mp.AutoButtonColor=false
				mp.ZIndex=2
				Instance.new("UICorner",mp).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp).Color=Color3.fromRGB(40,40,40)
				mp.MouseButton1Click:Connect(function()
					local idx=1
					for i2,m in ipairs(modes) do if m==BoxESPMode then idx=i2
							break end end
					BoxESPMode=modes[(idx%#modes)+1]
					mp.Text=BoxESPMode
				end)
			end
			if flag == "TPNoClip" then
				local statusPill = nil
				for _, c in pairs(b:GetChildren()) do
					if c:IsA("Frame") and c.Size == UDim2.new(0, 46, 0, 22) then
						statusPill = c
						break
					end
				end

				local modeBtn = Instance.new("TextButton", b)
				modeBtn.Size = UDim2.new(0, 38, 0, 22)
				modeBtn.Position = UDim2.new(1, -102, 0.5, -11)
				modeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				modeBtn.Text = BlinkMode
				modeBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
				modeBtn.Font = Enum.Font.GothamBlack
				modeBtn.TextSize = 12
				modeBtn.AutoButtonColor = false
				modeBtn.ZIndex = 2
				Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(1, 0)
				Instance.new("UIStroke", modeBtn).Color = Color3.fromRGB(40, 40, 40)

				modeBtn.MouseButton1Click:Connect(function()
					BlinkMode = BlinkMode == "PC" and "HP" or "PC"
					modeBtn.Text = BlinkMode
					modeBtn.TextColor3 = BlinkMode == "HP"
					and Color3.fromRGB(255, 255, 255)
					or Color3.fromRGB(140, 140, 140)
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

		-- ================================================================
		-- SPECTATE — VISUAL PAGE
		-- ================================================================
		do
			local specTarget = nil -- player yang lagi di-spectate
			local specConn = nil -- RenderStepped connection
			local specRows = {}
			local specListOpen = false

			-- Header tombol
			local specHdr = Instance.new("TextButton", PageVisual)
			specHdr.Size = UDim2.new(1, 0, 0, 34)
			specHdr.BackgroundColor3 = T.Card
			specHdr.Text = ""
			specHdr.AutoButtonColor = false
			specHdr.LayoutOrder = 110
			Instance.new("UICorner", specHdr).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", specHdr).Color = T.Stroke

			local specIcon = Instance.new("TextLabel", specHdr)
			specIcon.Size = UDim2.new(0, 26, 1, 0)
			specIcon.Position = UDim2.new(0, 6, 0, 0)
			specIcon.BackgroundTransparency = 1
			specIcon.Text = ""
			specIcon.Font = Enum.Font.GothamBlack
			specIcon.TextSize = 15

			local specTitleLbl = Instance.new("TextLabel", specHdr)
			specTitleLbl.Size = UDim2.new(1, -110, 1, 0)
			specTitleLbl.Position = UDim2.new(0, 34, 0, 0)
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

			-- Status bar (nama yang lagi di-spectate)
			local specStatusBar = Instance.new("Frame", PageVisual)
			specStatusBar.Size = UDim2.new(1, 0, 0, 28)
			specStatusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
			specStatusBar.Visible = false
			specStatusBar.LayoutOrder = 111
			Instance.new("UICorner", specStatusBar).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", specStatusBar).Color = Color3.fromRGB(40, 40, 80)

			local specNowLbl = Instance.new("TextLabel", specStatusBar)
			specNowLbl.Size = UDim2.new(1, -80, 1, 0)
			specNowLbl.Position = UDim2.new(0, 10, 0, 0)
			specNowLbl.BackgroundTransparency = 1
			specNowLbl.Text = "Spectating: —"
			specNowLbl.TextColor3 = Color3.fromRGB(120, 140, 255)
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

			-- Container list player
			local specCont = Instance.new("Frame", PageVisual)
			specCont.Size = UDim2.new(1, 0, 0, 0)
			specCont.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
			specCont.ClipsDescendants = true
			specCont.LayoutOrder = 112
			Instance.new("UICorner", specCont).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", specCont).Color = T.Stroke

			local specLayout = Instance.new("UIListLayout", specCont)
			specLayout.Padding = UDim.new(0, 2)
			specLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local specPad = Instance.new("UIPadding", specCont)
			specPad.PaddingTop = UDim.new(0, 4)
			specPad.PaddingBottom = UDim.new(0, 4)
			specPad.PaddingLeft = UDim.new(0, 4)
			specPad.PaddingRight = UDim.new(0, 4)

			-- ── Core spectate logic ─────────────────────────────
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
				-- Reset semua row highlight
				for _, row in ipairs(specRows) do
					if row and row.Parent then
						row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
						local str = row:FindFirstChildOfClass("UIStroke")
						if str then str.Color = T.Stroke end
						local pill = row:FindFirstChild("SpecPill")
						if pill then
							pill.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
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

				-- ikut karakter secara realtime
				specConn = RunService.RenderStepped:Connect(function()
					if not specTarget or not specTarget.Parent then stopSpectate()
						return end
					local char = specTarget.Character
					if not char then return end
					local hrp = char:FindFirstChild("HumanoidRootPart")
					if not hrp then return end
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

				-- Highlight row yang aktif
				if row then
					row.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
					local str = row:FindFirstChildOfClass("UIStroke")
					if str then str.Color = Color3.fromRGB(80, 80, 200) end
					local pill = row:FindFirstChild("SpecPill")
					if pill then
						pill.BackgroundColor3 = Color3.fromRGB(60, 60, 180)
						local lbl = pill:FindFirstChildOfClass("TextLabel")
						if lbl then lbl.Text = "ON"
							lbl.TextColor3 = Color3.fromRGB(255,255,255) end
					end
				end
			end

			specStopBtn.MouseButton1Click:Connect(stopSpectate)

			-- ── Build player list ────────────────────────────────
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
					row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					row.Text = ""
					row.AutoButtonColor = false
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
					local rowStr = Instance.new("UIStroke", row)
					rowStr.Color = T.Stroke
					rowStr.Thickness = 1

					-- Avatar placeholder
					local avatarBox = Instance.new("Frame", row)
					avatarBox.Size = UDim2.new(0, 22, 0, 22)
					avatarBox.Position = UDim2.new(0, 4, 0.5, -11)
					avatarBox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
					Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(1, 0)
					local avatarLbl = Instance.new("TextLabel", avatarBox)
					avatarLbl.Size = UDim2.new(1,0,1,0)
					avatarLbl.BackgroundTransparency = 1
					avatarLbl.Text = string.sub(p.Name, 1, 1):upper()
					avatarLbl.TextColor3 = T.TextDim
					avatarLbl.Font = Enum.Font.GothamBlack
					avatarLbl.TextSize = 12

					-- Nama
					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(1, -90, 0, 14)
					nameLbl.Position = UDim2.new(0, 30, 0, 4)
					nameLbl.BackgroundTransparency = 1
					nameLbl.Text = p.Name
					nameLbl.TextColor3 = T.TextDim
					nameLbl.Font = Enum.Font.GothamBlack
					nameLbl.TextSize = 12
					nameLbl.TextXAlignment = Enum.TextXAlignment.Left
					nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

					-- HP bar kecil
					local hpTrack = Instance.new("Frame", row)
					hpTrack.Size = UDim2.new(1, -94, 0, 3)
					hpTrack.Position = UDim2.new(0, 30, 0, 22)
					hpTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					Instance.new("UICorner", hpTrack).CornerRadius = UDim.new(1, 0)
					local hpFill = Instance.new("Frame", hpTrack)
					hpFill.Size = UDim2.new(1, 0, 1, 0)
					hpFill.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
					Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

					-- Update HP fill realtime
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

					-- SPEC pill
					local pill = Instance.new("Frame", row)
					pill.Name = "SpecPill"
					pill.Size = UDim2.new(0, 46, 0, 20)
					pill.AnchorPoint = Vector2.new(1, 0.5)
					pill.Position = UDim2.new(1, -4, 0.5, 0)
					pill.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
					Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
					Instance.new("UIStroke", pill).Color = Color3.fromRGB(50, 50, 50)
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

				-- Tombol refresh di bawah list
				local refRow = Instance.new("TextButton", specCont)
				refRow.Size = UDim2.new(1, 0, 0, 26)
				refRow.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
				refRow.Text = "↻ Refresh List"
				refRow.TextColor3 = T.TextDim
				refRow.Font = Enum.Font.GothamBlack
				refRow.TextSize = 11
				refRow.AutoButtonColor = false
				Instance.new("UICorner", refRow).CornerRadius = UDim.new(0, 6)
				refRow.MouseButton1Click:Connect(function()
					buildSpecList()
					local count = math.max(#specRows, 0)
					if specListOpen then
						local newH = count * (ROW_H + 2) + 36
						TweenService:Create(specCont, TweenInfo.new(0.15), {Size=UDim2.new(1,0,0,newH)}):Play()
					end
				end)
				table.insert(specRows, refRow)

				-- Update title count
				local pCount = #game.Players:GetPlayers() - 1
				specTitleLbl.Text = "Spectate Player (" .. pCount .. ")"
			end

			-- Toggle buka/tutup list
			specHdr.MouseButton1Click:Connect(function()
				specListOpen = not specListOpen
				if specListOpen then
					buildSpecList()
					local count = math.max(#specRows - 1, 0) -- exclude refresh btn
					local newH = count * (ROW_H + 2) + 36
					TweenService:Create(specCont, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{Size = UDim2.new(1, 0, 0, newH)}):Play()
					specArrow.Text = "^"
					specTitleLbl.TextColor3 = T.Text
					specHdr.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
					specHdr:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(60, 60, 120)
				else
					TweenService:Create(specCont, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{Size = UDim2.new(1, 0, 0, 0)}):Play()
					specArrow.Text = "v"
					specTitleLbl.TextColor3 = T.TextDim
					specHdr.BackgroundColor3 = T.Card
					specHdr:FindFirstChildOfClass("UIStroke").Color = T.Stroke
				end
			end)

			-- Auto-stop kalau player leave
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

		-- ================================================================
		-- MAIN PAGE toggles
		-- ================================================================
		local WAR_ORDER = {
			"InstantInteract","InvScan","TPNoClip",
			"InfStamina","HybridSpeed","AuraKill",
		}
		for i, flag in ipairs(WAR_ORDER) do
			local b = AddToggleBar(PageWar, flag)
			b.LayoutOrder = i

			-- Warning strip (pisah) udah ga diperlukan karena udah inline di card

			if flag=="TPNoClip" then
				local mp2=Instance.new("TextButton",b)
				mp2.Size=UDim2.new(0,38,0,22)
				mp2.Position=UDim2.new(1,-102,0.5,-11)
				mp2.BackgroundColor3=Color3.fromRGB(22,22,22)
				mp2.Text=BlinkMode
				mp2.TextColor3=Color3.fromRGB(140,140,140)
				mp2.Font=Enum.Font.GothamBlack
				mp2.TextSize=12
				mp2.AutoButtonColor=false
				mp2.ZIndex=2
				Instance.new("UICorner",mp2).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke",mp2).Color=Color3.fromRGB(40,40,40)

				-- Tombol LOCK posisi HPPanel — hanya muncul saat BlinkMode HP
				local panelLocked = false
				local lockBtn = Instance.new("TextButton", b)
				lockBtn.Size = UDim2.new(0, 38, 0, 22)
				lockBtn.Position = UDim2.new(1, -148, 0.5, -11)
				lockBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				lockBtn.Text = "LOCK"
				lockBtn.TextColor3 = Color3.fromRGB(85, 85, 85)
				lockBtn.Font = Enum.Font.GothamBlack
				lockBtn.TextSize = 11
				lockBtn.AutoButtonColor = false
				lockBtn.ZIndex = 2
				lockBtn.Visible = (BlinkMode == "HP")
				Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
				local lockBtnStr = Instance.new("UIStroke", lockBtn)
				lockBtnStr.Color = Color3.fromRGB(40, 40, 40)

				lockBtn.MouseButton1Click:Connect(function()
					panelLocked = not panelLocked
					if panelLocked then
						lockBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
						lockBtn.TextColor3 = Color3.fromRGB(80, 220, 80)
						lockBtnStr.Color = Color3.fromRGB(40, 100, 40)
						lockBtn.Text = "LOCKED"
						-- Disable drag HPPanel
						HPPanel.Active = false
					else
						lockBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
						lockBtn.TextColor3 = Color3.fromRGB(85, 85, 85)
						lockBtnStr.Color = Color3.fromRGB(40, 40, 40)
						lockBtn.Text = "LOCK"
						-- Enable drag HPPanel kembali
						HPPanel.Active = true
					end
				end)

				mp2.MouseButton1Click:Connect(function()
					BlinkMode=BlinkMode=="PC" and "HP" or "PC"
					mp2.Text=BlinkMode
					mp2.TextColor3=BlinkMode=="HP" and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,140)
					-- LOCK cuma muncul di HP mode
					lockBtn.Visible = (BlinkMode == "HP")
					-- Reset lock kalau switch ke PC
					if BlinkMode == "PC" and panelLocked then
						panelLocked = false
						lockBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
						lockBtn.TextColor3 = Color3.fromRGB(85, 85, 85)
						lockBtnStr.Color = Color3.fromRGB(40, 40, 40)
						lockBtn.Text = "LOCK"
						HPPanel.Active = true
					end
					updateHPPanel()
				end)
				b.MouseButton1Click:Connect(function() task.defer(updateHPPanel) end)
			end
		end

		-- Reduce Grafik toggle (MAIN page, merah, one-way) — LayoutOrder 50
		do
			local rgBar = Instance.new("TextButton", PageWar)
			rgBar.Size = UDim2.new(1, 0, 0, 54)
			rgBar.BackgroundColor3 = Color3.fromRGB(38, 10, 10)
			rgBar.Text = ""
			rgBar.AutoButtonColor = false
			rgBar.LayoutOrder = 50
			Instance.new("UICorner", rgBar).CornerRadius = UDim.new(0, 8)
			local rgStr = Instance.new("UIStroke", rgBar)
			rgStr.Color = Color3.fromRGB(100, 25, 25)
			rgStr.Thickness = 1

			local rgDot = Instance.new("Frame", rgBar)
			rgDot.Size=UDim2.new(0,5,0,5)
			rgDot.Position=UDim2.new(0,12,0.3,-2.5)
			rgDot.BackgroundColor3=Color3.fromRGB(220,50,50)
			Instance.new("UICorner",rgDot).CornerRadius=UDim.new(1,0)

			local rgName = Instance.new("TextLabel", rgBar)
			rgName.Size=UDim2.new(1,-76,0,20)
			rgName.Position=UDim2.new(0,24,0,6)
			rgName.BackgroundTransparency=1
			rgName.Text="Reduce Grafik"
			rgName.TextColor3=Color3.fromRGB(220,80,80)
			rgName.Font=Enum.Font.GothamBlack
			rgName.TextSize=14
			rgName.TextXAlignment=Enum.TextXAlignment.Left

			local rgWarn = Instance.new("TextLabel", rgBar)
			rgWarn.Size=UDim2.new(1,-76,0,16)
			rgWarn.Position=UDim2.new(0,24,0,28)
			rgWarn.BackgroundTransparency=1
			rgWarn.Text="Perlu rejoin untuk mengembalikan"
			rgWarn.TextColor3=Color3.fromRGB(140,40,40)
			rgWarn.Font=Enum.Font.Gotham
			rgWarn.TextSize=11
			rgWarn.TextXAlignment=Enum.TextXAlignment.Left

			local rgPill = Instance.new("Frame", rgBar)
			rgPill.Size=UDim2.new(0,46,0,22)
			rgPill.Position=UDim2.new(1,-52,0.5,-11)
			rgPill.BackgroundColor3=Color3.fromRGB(60,15,15)
			Instance.new("UICorner",rgPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke",rgPill).Color=Color3.fromRGB(100,25,25)
			local rgPillLbl=Instance.new("TextLabel",rgPill)
			rgPillLbl.Size=UDim2.new(1,0,1,0)
			rgPillLbl.BackgroundTransparency=1
			rgPillLbl.Text="OFF"
			rgPillLbl.TextColor3=Color3.fromRGB(150,50,50)
			rgPillLbl.Font=Enum.Font.GothamBlack
			rgPillLbl.TextSize=12

			local rgActive = false
			rgBar.MouseButton1Click:Connect(function()
				if rgActive then return end
				rgActive = true
				rgPill.BackgroundColor3=Color3.fromRGB(180,30,30)
				rgPillLbl.Text="ON"
				rgPillLbl.TextColor3=Color3.fromRGB(255,255,255)
				rgStr.Color=Color3.fromRGB(180,50,50)
				rgBar.BackgroundColor3=Color3.fromRGB(60,15,15)
				task.spawn(function()
					local Lighting = game:GetService("Lighting")
					local Players = game:GetService("Players")

					-- Hapus semua PostEffect
					for _, v in ipairs(Lighting:GetChildren()) do
						if v:IsA("PostEffect") then
							pcall(function() v:Destroy() end)
						end
					end

					-- Lighting settings
					pcall(function()
						Lighting.GlobalShadows = false
						Lighting.FogEnd = 9e9
						Lighting.Brightness = 2
					end)

					-- Handle setiap instance di workspace
					local localChar = Players.LocalPlayer and Players.LocalPlayer.Character
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

					-- Terrain water
					pcall(function()
						local terrain = workspace:FindFirstChild("Terrain")
						if terrain then
							terrain.WaterWaveSize = 0
							terrain.WaterWaveSpeed = 0
							terrain.WaterReflectance = 0
							terrain.WaterTransparency = 1
						end
					end)

					-- Quality settings
					pcall(function()
						settings().Physics.AllowSleep = true
						settings().Rendering.QualityLevel = 1
						settings().Rendering.EagerBulkExecution = false
						settings().Rendering.TextureQuality = Enum.TextureQuality.Low
					end)
				end)
			end)
		end

		-- ================================================================
		-- WALL SELECTOR — WAR PAGE
		-- ================================================================
		do
			local wsSelectMode = false
			local wsSelected = {}
			local wsDisabled = {}
			local wsHighlights = {}

			local lp2 = game.Players.LocalPlayer
			local mouse2 = lp2:GetMouse()
			local cam2 = workspace.CurrentCamera

			-- Hover outline (dibuat di workspace)
			local wsHoverBox = Instance.new("SelectionBox", workspace)
			wsHoverBox.Color3 = Color3.fromRGB(255, 255, 255)
			wsHoverBox.LineThickness = 0.05
			wsHoverBox.SurfaceTransparency = 0.88
			wsHoverBox.SurfaceColor3 = Color3.fromRGB(255, 255, 255)

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
				b.Color3 = Color3.fromRGB(255, 55, 55)
				b.LineThickness = 0.07
				b.SurfaceTransparency = 0.75
				b.SurfaceColor3 = Color3.fromRGB(255, 30, 30)
				wsHighlights[part] = b
			end

			local function wsRemoveHL(part)
				if wsHighlights[part] then
					wsHighlights[part]:Destroy()
					wsHighlights[part] = nil
				end
			end

			local wsCountLbl -- forward ref buat updateUI
			local wsStatusDot
			local wsStatusLbl
			local wsGuideCard

			local function wsUpdateUI()
				local s, d = 0, 0
				for _ in pairs(wsSelected) do s += 1 end
				for _ in pairs(wsDisabled) do d += 1 end
				if wsCountLbl then
					wsCountLbl.Text = "Selected: " .. s .. "Disabled: " .. d
				end
				if wsSelectMode then
					if wsStatusDot then wsStatusDot.BackgroundColor3 = Color3.fromRGB(100, 180, 255) end
					if wsStatusLbl then
						wsStatusLbl.Text = "Klik part untuk di-select"
						wsStatusLbl.TextColor3 = Color3.fromRGB(160, 200, 255)
					end
					if wsGuideCard then wsGuideCard.Visible = true end
				else
					if wsStatusDot then wsStatusDot.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end
					if wsStatusLbl then
						wsStatusLbl.Text = "Tekan [P] atau toggle ON"
						wsStatusLbl.TextColor3 = Color3.fromRGB(85, 85, 85)
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
				local n = 0
				for part in pairs(wsSelected) do
					if part and part.Parent then
						-- Simpan props SEBELUM diubah
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
						n += 1
					end
				end
				wsSelected = {}
				wsUpdateUI()
			end

			local function wsDoRestore()
				local n = 0
				for part, p in pairs(wsDisabled) do
					if part and part.Parent then
						pcall(function()
							part.Transparency = p.trans
							part.CanCollide = p.collide
							part.CastShadow = p.shadow
						end)
						n += 1
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

			-- ── Hover loop ────────────────────────────────────
			RunService.RenderStepped:Connect(function()
				if not wsSelectMode then wsHoverBox.Adornee = nil
					return end
				local t = wsGetTarget()
				wsHoverBox.Adornee = (t and not wsSelected[t]) and t or nil
			end)

			-- ── Click handler ─────────────────────────────────
			mouse2.Button1Down:Connect(function()
				if not wsSelectMode then return end
				local t = wsGetTarget()
				if t then wsDoSelect(t) end
			end)

			-- ── Hotkeys ───────────────────────────────────────
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

			-- ── UI di PageWar ─────────────────────────────────
			local wsHdr = Instance.new("TextLabel", PageWar)
			wsHdr.Size = UDim2.new(1, 0, 0, 20)
			wsHdr.BackgroundTransparency = 1
			wsHdr.Text = "WALL SELECTOR"
			wsHdr.TextColor3 = T.TextDim
			wsHdr.Font = Enum.Font.GothamBlack
			wsHdr.TextSize = 11
			wsHdr.LayoutOrder = 60

			-- Main toggle bar
			local wsBar = Instance.new("TextButton", PageWar)
			wsBar.Size = UDim2.new(1, 0, 0, 36)
			wsBar.BackgroundColor3 = T.Card
			wsBar.Text = ""
			wsBar.AutoButtonColor = false
			wsBar.LayoutOrder = 61
			Instance.new("UICorner", wsBar).CornerRadius = UDim.new(0, 8)
			local wsBarStr = Instance.new("UIStroke", wsBar)
			wsBarStr.Color = T.Stroke

			wsStatusDot = Instance.new("Frame", wsBar)
			wsStatusDot.Size = UDim2.new(0, 7, 0, 7)
			wsStatusDot.Position = UDim2.new(0, 12, 0.5, -3.5)
			wsStatusDot.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Instance.new("UICorner", wsStatusDot).CornerRadius = UDim.new(1, 0)

			local wsBarName = Instance.new("TextLabel", wsBar)
			wsBarName.Size = UDim2.new(1, -120, 1, 0)
			wsBarName.Position = UDim2.new(0, 26, 0, 0)
			wsBarName.BackgroundTransparency = 1
			wsBarName.Text = "Wall Selector"
			wsBarName.TextColor3 = T.TextDim
			wsBarName.Font = Enum.Font.GothamBlack
			wsBarName.TextSize = 14
			wsBarName.TextXAlignment = Enum.TextXAlignment.Left

			local wsPill = Instance.new("Frame", wsBar)
			wsPill.Size = UDim2.new(0, 46, 0, 22)
			wsPill.AnchorPoint = Vector2.new(1, 0.5)
			wsPill.Position = UDim2.new(1, -6, 0.5, 0)
			wsPill.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
				-- Update pill style
				local on = wsSelectMode
				wsBar.BackgroundColor3 = on and Color3.fromRGB(14, 18, 26) or T.Card
				wsBarStr.Color = on and Color3.fromRGB(60, 90, 180) or T.Stroke
				wsBarName.TextColor3 = on and T.Text or T.TextDim
				wsPill.BackgroundColor3 = on and Color3.fromRGB(60, 90, 200) or Color3.fromRGB(20, 20, 20)
				wsPillLbl.Text = on and "ON" or "OFF"
				wsPillLbl.TextColor3 = on and Color3.fromRGB(255, 255, 255) or T.TextDim
				wsUpdateUI()
			end)

			-- Status / counter bar
			local wsInfoBar = Instance.new("Frame", PageWar)
			wsInfoBar.Size = UDim2.new(1, 0, 0, 24)
			wsInfoBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
			wsInfoBar.LayoutOrder = 62
			Instance.new("UICorner", wsInfoBar).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", wsInfoBar).Color = Color3.fromRGB(28, 28, 28)

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
			wsCountLbl.TextColor3 = T.TextDim
			wsCountLbl.Font = Enum.Font.GothamBlack
			wsCountLbl.TextSize = 10
			wsCountLbl.TextXAlignment = Enum.TextXAlignment.Right

			-- Action buttons row (Disable / Restore / Clear)
			local wsActRow = Instance.new("Frame", PageWar)
			wsActRow.Size = UDim2.new(1, 0, 0, 28)
			wsActRow.BackgroundTransparency = 1
			wsActRow.LayoutOrder = 63

			local WS_ACTS = {
				{ label="[M] Disable", col=Color3.fromRGB(220,60,60), bg=Color3.fromRGB(30,10,10), fn=wsDoDisable },
				{ label="[L] Restore", col=Color3.fromRGB(60,210,100), bg=Color3.fromRGB(8,22,12), fn=wsDoRestore },
				{ label="[K] Clear", col=Color3.fromRGB(210,200,60), bg=Color3.fromRGB(20,18,5), fn=wsDoClr },
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
				Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 6)
				local abStr = Instance.new("UIStroke", ab)
				abStr.Color = act.col
				abStr.Transparency = 0.7
				ab.MouseButton1Click:Connect(function()
					act.fn()
					-- Flash button
					local orig = ab.BackgroundColor3
					ab.BackgroundColor3 = act.col
					task.delay(0.12, function() ab.BackgroundColor3 = orig end)
				end)
			end

			-- Guide card (panduan cara pakai — muncul saat ON)
			wsGuideCard = Instance.new("Frame", PageWar)
			wsGuideCard.Size = UDim2.new(1, 0, 0, 90)
			wsGuideCard.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
			wsGuideCard.Visible = false
			wsGuideCard.LayoutOrder = 64
			Instance.new("UICorner", wsGuideCard).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", wsGuideCard).Color = Color3.fromRGB(40, 50, 80)

			local guideTitle = Instance.new("TextLabel", wsGuideCard)
			guideTitle.Size = UDim2.new(1, -12, 0, 20)
			guideTitle.Position = UDim2.new(0, 8, 0, 2)
			guideTitle.BackgroundTransparency = 1
			guideTitle.Text = "Cara Pakai"
			guideTitle.TextColor3 = Color3.fromRGB(120, 150, 255)
			guideTitle.Font = Enum.Font.GothamBlack
			guideTitle.TextSize = 11
			guideTitle.TextXAlignment = Enum.TextXAlignment.Left

			local GUIDE_LINES = {
				{ key="[P] / Toggle", desc="Aktifkan / nonaktifkan select mode", col=Color3.fromRGB(100,180,255) },
				{ key="[Klik Part]", desc="Select/deselect part yang ditunjuk", col=Color3.fromRGB(255,255,255) },
				{ key="[M] Disable", desc="Sembunyikan semua part yang diselect", col=Color3.fromRGB(220,60,60) },
				{ key="[L] Restore", desc="Kembalikan semua part yang disembunyikan", col=Color3.fromRGB(60,210,100) },
				{ key="[K] Clear", desc="Bersihkan selection (gak restore)", col=Color3.fromRGB(210,200,60) },
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
				gv.TextColor3 = Color3.fromRGB(65, 65, 65)
				gv.Font = Enum.Font.Gotham
				gv.TextSize = 10
				gv.TextXAlignment = Enum.TextXAlignment.Left
			end

			wsUpdateUI()
		end

		-- ================================================================
		-- FAKE NAME — MAIN TAB
		-- ================================================================
		do
			-- Header card
			local fnCard = Instance.new("TextButton", PageWar)
			fnCard.Size = UDim2.new(1, 0, 0, 120)
			fnCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
			fnCard.Text = ""
			fnCard.AutoButtonColor = false
			fnCard.LayoutOrder = 70
			Instance.new("UICorner", fnCard).CornerRadius = UDim.new(0, 8)
			local fnStr = Instance.new("UIStroke", fnCard)
			fnStr.Color = Color3.fromRGB(40, 40, 40)
			fnStr.Thickness = 1

			-- Dot aksen
			local fnDot = Instance.new("Frame", fnCard)
			fnDot.Size = UDim2.new(0, 5, 0, 5)
			fnDot.Position = UDim2.new(0, 12, 0, 12)
			fnDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			Instance.new("UICorner", fnDot).CornerRadius = UDim.new(1, 0)

			local fnTitle = Instance.new("TextLabel", fnCard)
			fnTitle.Size = UDim2.new(1, -80, 0, 18)
			fnTitle.Position = UDim2.new(0, 24, 0, 4)
			fnTitle.BackgroundTransparency = 1
			fnTitle.Text = "Fake Name"
			fnTitle.TextColor3 = Color3.fromRGB(210, 210, 210)
			fnTitle.Font = Enum.Font.GothamBlack
			fnTitle.TextSize = 13
			fnTitle.TextXAlignment = Enum.TextXAlignment.Left

			local fnSub = Instance.new("TextLabel", fnCard)
			fnSub.Size = UDim2.new(1, -80, 0, 14)
			fnSub.Position = UDim2.new(0, 24, 0, 22)
			fnSub.BackgroundTransparency = 1
			fnSub.Text = "Ganti nametag in-game"
			fnSub.TextColor3 = Color3.fromRGB(60, 60, 60)
			fnSub.Font = Enum.Font.Gotham
			fnSub.TextSize = 11
			fnSub.TextXAlignment = Enum.TextXAlignment.Left

			-- Status label (feedback)
			local fnStatus = Instance.new("TextLabel", fnCard)
			fnStatus.Size = UDim2.new(1, -24, 0, 13)
			fnStatus.Position = UDim2.new(0, 12, 1, -17)
			fnStatus.BackgroundTransparency = 1
			fnStatus.Text = ""
			fnStatus.TextColor3 = Color3.fromRGB(0, 200, 100)
			fnStatus.Font = Enum.Font.GothamBlack
			fnStatus.TextSize = 11
			fnStatus.TextXAlignment = Enum.TextXAlignment.Left

			-- Input: In-Game Name (NameTag)
			local fnInput1 = Instance.new("TextBox", fnCard)
			fnInput1.Size = UDim2.new(0, 130, 0, 24)
			fnInput1.Position = UDim2.new(0, 12, 0, 42)
			fnInput1.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			fnInput1.PlaceholderText = "In-Game Name..."
			fnInput1.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
			fnInput1.Text = ""
			fnInput1.TextColor3 = Color3.fromRGB(255, 255, 255)
			fnInput1.Font = Enum.Font.Gotham
			fnInput1.TextSize = 12
			fnInput1.ClearTextOnFocus = false
			Instance.new("UICorner", fnInput1).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", fnInput1).Color = Color3.fromRGB(45, 45, 45)

			-- Input: Username (RankTag)
			local fnInput2 = Instance.new("TextBox", fnCard)
			fnInput2.Size = UDim2.new(0, 130, 0, 24)
			fnInput2.Position = UDim2.new(0, 12, 0, 72)
			fnInput2.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			fnInput2.PlaceholderText = "Username..."
			fnInput2.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
			fnInput2.Text = ""
			fnInput2.TextColor3 = Color3.fromRGB(255, 255, 255)
			fnInput2.Font = Enum.Font.Gotham
			fnInput2.TextSize = 12
			fnInput2.ClearTextOnFocus = false
			Instance.new("UICorner", fnInput2).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", fnInput2).Color = Color3.fromRGB(45, 45, 45)

			-- Apply button
			local fnApply = Instance.new("TextButton", fnCard)
			fnApply.Size = UDim2.new(0, 60, 0, 52)
			fnApply.Position = UDim2.new(1, -76, 0, 42)
			fnApply.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			fnApply.Text = "APPLY"
			fnApply.TextColor3 = Color3.fromRGB(200, 200, 200)
			fnApply.Font = Enum.Font.GothamBlack
			fnApply.TextSize = 12
			fnApply.AutoButtonColor = false
			Instance.new("UICorner", fnApply).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", fnApply).Color = Color3.fromRGB(55, 55, 55)

			local function setFnStatus(txt, col)
				fnStatus.Text = txt
				fnStatus.TextColor3 = col or Color3.fromRGB(0, 200, 100)
				task.delay(3, function() if fnStatus.Text == txt then fnStatus.Text = "" end end)
			end

			fnApply.MouseButton1Click:Connect(function()
				local ok = false
				pcall(function()
					local char = game.Players.LocalPlayer.Character
					-- Support folder Characters atau langsung di workspace
					local myChar = (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(game.Players.LocalPlayer.Name)) or char
					if not myChar then return end

					local name1 = fnInput1.Text
					local name2 = fnInput2.Text

					-- NameTag (In-Game Name)
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

					-- RankTag (Username)
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
					setFnStatus("Applied!", Color3.fromRGB(0, 200, 100))
					-- Flash button hijau sebentar
					fnApply.BackgroundColor3 = Color3.fromRGB(0, 60, 20)
					task.delay(0.3, function() fnApply.BackgroundColor3 = Color3.fromRGB(22, 22, 22) end)
				else
					setFnStatus("Tag not found", Color3.fromRGB(220, 80, 80))
				end
			end)
		end

		-- ================================================================
		-- AIM PAGE
	end

	_buildAim = function()
		-- ================================================================
		do
			local flagName = "AimLock"
			local isOn = Flags[flagName]

			local bar = Instance.new("TextButton", PageAim)
			bar.Size = UDim2.new(1, 0, 0, 36)
			bar.BackgroundColor3 = isOn and Color3.fromRGB(16,16,16) or T.Card
			bar.Text = ""
			bar.AutoButtonColor = false
			bar.LayoutOrder = 1
			Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
			local bStr = Instance.new("UIStroke", bar)
			bStr.Color = isOn and T.StrokeOn or T.Stroke
			bStr.Thickness = 1

			local nameLbl = Instance.new("TextLabel", bar)
			nameLbl.Size = UDim2.new(1,-190,1,0)
			nameLbl.Position = UDim2.new(0,24,0,0)
			nameLbl.BackgroundTransparency=1
			nameLbl.Text="Auto Aim"
			nameLbl.TextColor3 = isOn and T.Text or T.TextDim
			nameLbl.Font=Enum.Font.Gotham
			nameLbl.TextSize=14
			nameLbl.TextXAlignment=Enum.TextXAlignment.Left

			local modeBtn = Instance.new("TextButton", bar)
			modeBtn.Size = UDim2.new(0,38,0,22)
			modeBtn.Position = UDim2.new(1,-148,0.5,-11)
			modeBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
			modeBtn.Text = AimMode
			modeBtn.TextColor3 = T.TextDim
			modeBtn.Font = Enum.Font.GothamBlack
			modeBtn.TextSize = 12
			modeBtn.AutoButtonColor = false
			Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(1,0)
			Instance.new("UIStroke", modeBtn).Color = T.Stroke

			local partBtn = Instance.new("TextButton", bar)
			partBtn.Size = UDim2.new(0,44,0,22)
			partBtn.Position = UDim2.new(1,-98,0.5,-11)
			partBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
			partBtn.Text = AimPart=="Head" and "HEAD" or "BODY"
			partBtn.TextColor3 = T.Accent
			partBtn.Font = Enum.Font.GothamBlack
			partBtn.TextSize = 12
			partBtn.AutoButtonColor = false
			Instance.new("UICorner", partBtn).CornerRadius = UDim.new(1,0)
			Instance.new("UIStroke", partBtn).Color = T.Stroke

			local statusPill = Instance.new("Frame", bar)
			statusPill.Size = UDim2.new(0,46,0,22)
			statusPill.Position = UDim2.new(1,-52,0.5,-11)
			statusPill.BackgroundColor3 = isOn and T.AccOn or Color3.fromRGB(20,20,20)
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
				bar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
				bStr.Color = on and T.StrokeOn or T.Stroke
				nameLbl.TextColor3 = on and T.Text or T.TextDim
				statusPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(20,20,20)
				statusLbl.Text = on and "ON" or "OFF"
				statusLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
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
				modeBtn.TextColor3 = AimMode=="HP" and T.AccOn or Color3.fromRGB(200,200,200)
				AimTarget = nil
			end)
		end

		do
			local b = AddToggleBar(PageAim, "WallCheck")
			b.LayoutOrder = 2
		end

		-- ================================================================
		-- SILENT AIM
		-- ================================================================
		do
			local saBar = Instance.new("TextButton", PageAim)
			saBar.Size = UDim2.new(1, 0, 0, 36)
			saBar.BackgroundColor3 = SilentAim and Color3.fromRGB(16,16,16) or T.Card
			saBar.Text = ""
			saBar.AutoButtonColor = false
			saBar.LayoutOrder = 3
			Instance.new("UICorner", saBar).CornerRadius = UDim.new(0, 8)
			local saStr = Instance.new("UIStroke", saBar)
			saStr.Color = SilentAim and T.StrokeOn or T.Stroke
			saStr.Thickness = 1

			local saLbl = Instance.new("TextLabel", saBar)
			saLbl.Size = UDim2.new(1, -130, 1, 0)
			saLbl.Position = UDim2.new(0, 24, 0, 0)
			saLbl.BackgroundTransparency = 1
			saLbl.Text = "Silent Aim"
			saLbl.TextColor3 = SilentAim and T.Text or T.TextDim
			saLbl.Font = Enum.Font.Gotham
			saLbl.TextSize = 14
			saLbl.TextXAlignment = Enum.TextXAlignment.Left

			-- Toggle HEAD / BODY untuk silent aim
			local saPartBtn = Instance.new("TextButton", saBar)
			saPartBtn.Size = UDim2.new(0, 44, 0, 22)
			saPartBtn.Position = UDim2.new(1, -150, 0.5, -11)
			saPartBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
			saPartBtn.Text = "HEAD"
			saPartBtn.TextColor3 = T.Accent
			saPartBtn.Font = Enum.Font.GothamBlack
			saPartBtn.TextSize = 12
			saPartBtn.AutoButtonColor = false
			Instance.new("UICorner", saPartBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", saPartBtn).Color = T.Stroke

			-- Mode button: PC (mouse) atau HP (center screen)
			local saModeBtn = Instance.new("TextButton", saBar)
			saModeBtn.Size = UDim2.new(0, 38, 0, 22)
			saModeBtn.Position = UDim2.new(1, -102, 0.5, -11)
			saModeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			saModeBtn.Text = SilentMode
			saModeBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
			saModeBtn.Font = Enum.Font.GothamBlack
			saModeBtn.TextSize = 12
			saModeBtn.AutoButtonColor = false
			saModeBtn.ZIndex = 2
			Instance.new("UICorner", saModeBtn).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", saModeBtn).Color = Color3.fromRGB(40, 40, 40)

			saModeBtn.MouseButton1Click:Connect(function()
				SilentMode = SilentMode == "PC" and "HP" or "PC"
				saModeBtn.Text = SilentMode
				saModeBtn.TextColor3 = SilentMode == "HP"
					and Color3.fromRGB(255, 255, 255)
					or Color3.fromRGB(140, 140, 140)
			end)

			local saPill = Instance.new("Frame", saBar)
			saPill.Size = UDim2.new(0, 46, 0, 22)
			saPill.Position = UDim2.new(1, -52, 0.5, -11)
			saPill.BackgroundColor3 = SilentAim and T.AccOn or Color3.fromRGB(20,20,20)
			Instance.new("UICorner", saPill).CornerRadius = UDim.new(1, 0)
			if not SilentAim then Instance.new("UIStroke", saPill).Color = T.Stroke end
			local saPillLbl = Instance.new("TextLabel", saPill)
			saPillLbl.Size = UDim2.new(1, 0, 1, 0)
			saPillLbl.BackgroundTransparency = 1
			saPillLbl.Text = SilentAim and "ON" or "OFF"
			saPillLbl.TextColor3 = SilentAim and Color3.fromRGB(0,0,0) or T.TextDim
			saPillLbl.Font = Enum.Font.GothamBlack
			saPillLbl.TextSize = 12

			local saPart = "Head"

			local function refreshSABar()
				saBar.BackgroundColor3 = SilentAim and Color3.fromRGB(16,16,16) or T.Card
				saStr.Color = SilentAim and T.StrokeOn or T.Stroke
				saLbl.TextColor3 = SilentAim and T.Text or T.TextDim
				saPill.BackgroundColor3 = SilentAim and T.AccOn or Color3.fromRGB(20,20,20)
				saPillLbl.Text = SilentAim and "ON" or "OFF"
				saPillLbl.TextColor3 = SilentAim and Color3.fromRGB(0,0,0) or T.TextDim
			end

			saBar.MouseButton1Click:Connect(function()
				SilentAim = not SilentAim
				refreshSABar()
			end)

			saPartBtn.MouseButton1Click:Connect(function()
				saPart = saPart == "Head" and "Body" or "Head"
				saPartBtn.Text = saPart == "Head" and "HEAD" or "BODY"
			end)

			-- Wallbang toggle untuk silent aim
			local wbBar = Instance.new("TextButton", PageAim)
			wbBar.Size = UDim2.new(1, 0, 0, 36)
			wbBar.BackgroundColor3 = T.Card
			wbBar.Text = ""
			wbBar.AutoButtonColor = false
			wbBar.LayoutOrder = 4
			Instance.new("UICorner", wbBar).CornerRadius = UDim.new(0, 8)
			local wbStr = Instance.new("UIStroke", wbBar)
			wbStr.Color = T.Stroke
			wbStr.Thickness = 1

			local wbLbl = Instance.new("TextLabel", wbBar)
			wbLbl.Size = UDim2.new(1, -60, 1, 0)
			wbLbl.Position = UDim2.new(0, 24, 0, 0)
			wbLbl.BackgroundTransparency = 1
			wbLbl.Text = "Silent Wallbang"
			wbLbl.TextColor3 = T.TextDim
			wbLbl.Font = Enum.Font.Gotham
			wbLbl.TextSize = 14
			wbLbl.TextXAlignment = Enum.TextXAlignment.Left

			local wbPill = Instance.new("Frame", wbBar)
			wbPill.Size = UDim2.new(0, 46, 0, 22)
			wbPill.Position = UDim2.new(1, -52, 0.5, -11)
			wbPill.BackgroundColor3 = Color3.fromRGB(20,20,20)
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
				wbBar.BackgroundColor3 = SilentAimWallbang and Color3.fromRGB(16,16,16) or T.Card
				wbStr.Color = SilentAimWallbang and T.StrokeOn or T.Stroke
				wbLbl.TextColor3 = SilentAimWallbang and T.Text or T.TextDim
				wbPill.BackgroundColor3 = SilentAimWallbang and T.AccOn or Color3.fromRGB(20,20,20)
				wbPillLbl.Text = SilentAimWallbang and "ON" or "OFF"
				wbPillLbl.TextColor3 = SilentAimWallbang and Color3.fromRGB(0,0,0) or T.TextDim
			end

			wbBar.MouseButton1Click:Connect(function()
				SilentAimWallbang = not SilentAimWallbang
				refreshWBBar()
			end)

			-- Hook CastBlacklist & CastWhitelist via getgc (lazy init sekali)
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
							-- Cari target terdekat di FOV
							local cam = workspace.CurrentCamera
							-- HP mode: pakai tengah layar (diem); PC mode: ikutin mouse
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

		-- ── Baris Hide FOV ──────────────────────────────────────────────
		do
			local function makeFovToggle(label, layoutOrder, getVal, setVal)
				local row = Instance.new("Frame", PageAim)
				row.Size = UDim2.new(1, 0, 0, 32)
				row.BackgroundColor3 = T.Card
				row.LayoutOrder = layoutOrder
				Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
				local rowStr = Instance.new("UIStroke", row)
				rowStr.Color = T.Stroke
				rowStr.Thickness = 1

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
					pill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(20, 20, 20)
					pillLbl.Text = on and "ON" or "OFF"
					pillLbl.TextColor3 = on and Color3.fromRGB(0, 0, 0) or T.TextDim
					lbl.TextColor3 = on and T.Text or T.TextDim
					row.BackgroundColor3 = on and Color3.fromRGB(16, 16, 16) or T.Card
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

		-- ================================================================
		-- WHITELIST
		-- ================================================================
		do
			local wlOpen = false

			local wlHeader = Instance.new("TextButton", PageAim)
			wlHeader.Size = UDim2.new(1, 0, 0, 34)
			wlHeader.BackgroundColor3 = T.Card
			wlHeader.Text = ""
			wlHeader.AutoButtonColor = false
			wlHeader.LayoutOrder = 11
			Instance.new("UICorner", wlHeader).CornerRadius = UDim.new(0, 8)
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
			wlContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
			wlContainer.ClipsDescendants = true
			wlContainer.LayoutOrder = 12
			Instance.new("UICorner", wlContainer).CornerRadius = UDim.new(0, 2)
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
					row.BackgroundColor3 = isWL and Color3.fromRGB(22,22,22) or Color3.fromRGB(14,14,14)
					row.LayoutOrder = idx
					Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

					local nameL = Instance.new("TextLabel", row)
					nameL.Size = UDim2.new(1,-60,1,0)
					nameL.Position = UDim2.new(0,8,0,0)
					nameL.BackgroundTransparency=1
					nameL.Text=p.Name
					nameL.TextColor3 = isWL and T.AccOn or T.TextDim
					nameL.Font=Enum.Font.GothamBlack
					nameL.TextSize=15
					nameL.TextXAlignment=Enum.TextXAlignment.Left
					nameL.TextTruncate=Enum.TextTruncate.AtEnd

					local wlPill = Instance.new("TextButton", row)
					wlPill.Size = UDim2.new(0,48,0,18)
					wlPill.Position = UDim2.new(1,-52,0.5,-9)
					wlPill.BackgroundColor3 = isWL and Color3.fromRGB(60,60,60) or Color3.fromRGB(35,35,35)
					wlPill.Text = isWL and "WL" or "NO"
					wlPill.TextColor3 = isWL and T.AccOn or T.TextDim
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
			wlRefreshRow.BackgroundColor3 = Color3.fromRGB(35,35,35)
			wlRefreshRow.Text = "Refresh List"
			wlRefreshRow.TextColor3 = T.Accent
			wlRefreshRow.Font=Enum.Font.GothamBlack
			wlRefreshRow.TextSize=15
			wlRefreshRow.AutoButtonColor=false
			wlRefreshRow.LayoutOrder=0
			Instance.new("UICorner", wlRefreshRow).CornerRadius = UDim.new(0, 2)

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

		-- ================================================================
		-- TP PAGE — STATE & HELPERS
	end

	_buildTP = function()
		-- ================================================================
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

		local function lerpCharForce(fromPos, toPos, speed)
			local dist = (toPos - fromPos).Magnitude
			if dist < 0.05 then return end
			local travelT = dist / speed
			local elapsed = 0
			while elapsed < travelT do
				local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if not hrp2 then return end
				local t = math.clamp(elapsed / travelT, 0, 1)
				moveCharTo(fromPos:Lerp(toPos, t))
				local _, dt = RunService.Stepped:Wait()
				elapsed = elapsed + dt
			end
			moveCharTo(toPos)
		end

		-- ================================================================
		-- TP LOADING OVERLAY — Redesigned
		-- ================================================================
		local TPOverlay = Instance.new("ScreenGui")
		TPOverlay.Name = "HNDRIXX_TPOverlay"
		TPOverlay.ResetOnSpawn = false
		TPOverlay.DisplayOrder = 5  -- di BAWAH panel (20), di atas game world
		TPOverlay.IgnoreGuiInset = true
		TPOverlay.Enabled = false
		TPOverlay.Parent = CoreGui  -- HARUS CoreGui biar nutup semua UI termasuk ESP

		-- Full-cover black background
		local OvBG = Instance.new("Frame", TPOverlay)
		OvBG.Size = UDim2.new(1, 0, 1, 0)
		OvBG.Position = UDim2.new(0, 0, 0, 0)
		OvBG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		OvBG.BackgroundTransparency = 1
		OvBG.BorderSizePixel = 0
		OvBG.ZIndex = 9999

		-- Center container
		local ovCenter = Instance.new("Frame", OvBG)
		ovCenter.Size = UDim2.new(0, 320, 0, 130)
		ovCenter.AnchorPoint = Vector2.new(0.5, 0.5)
		ovCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
		ovCenter.BackgroundTransparency = 1
		ovCenter.ZIndex = 10000

		-- ── Logo: "TH" hijau + "33" putih dengan outline hijau ─────────
		-- Pakai AutomaticSize + UIListLayout biar rapet sempurna, gak perlu spasi manual
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
		ovTitleGreen.Text = "THR"
		ovTitleGreen.TextColor3 = Color3.fromRGB(0, 230, 80)
		ovTitleGreen.Font = Enum.Font.GothamBlack
		ovTitleGreen.TextSize = 64
		ovTitleGreen.LayoutOrder = 1
		ovTitleGreen.ZIndex = 10001

		local ovTitleWhite = Instance.new("TextLabel", logoFrame)
		ovTitleWhite.Size = UDim2.new(0, 0, 1, 0)
		ovTitleWhite.AutomaticSize = Enum.AutomaticSize.X
		ovTitleWhite.BackgroundTransparency = 1
		ovTitleWhite.Text = "33"
		ovTitleWhite.TextColor3 = Color3.fromRGB(255, 255, 255)
		ovTitleWhite.Font = Enum.Font.GothamBlack
		ovTitleWhite.TextSize = 64
		ovTitleWhite.LayoutOrder = 2
		ovTitleWhite.ZIndex = 10002
		local ovWhiteStroke = Instance.new("UIStroke", ovTitleWhite)
		ovWhiteStroke.Color = Color3.fromRGB(0, 210, 65)
		ovWhiteStroke.Thickness = 2.5

		-- Status label
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

		-- dummy vars buat kompatibilitas kode lain
		local ovDestLbl = Instance.new("TextLabel", OvBG)
		ovDestLbl.Visible = false; ovDestLbl.Text = ""; ovDestLbl.BackgroundTransparency = 1
		local ovTimerLbl = Instance.new("TextLabel", OvBG)
		ovTimerLbl.Visible = false; ovTimerLbl.Text = ""; ovTimerLbl.BackgroundTransparency = 1

		local ovAnimConn = nil
		local ovTimerConn = nil

		-- Track panel state sebelum loading screen
		local _panelWasVisible = false

		local function showTPOverlay(destName, totalDist)
			-- Catat state panel sebelum disembunyiin
			_panelWasVisible = MF.Visible
			-- Sembunyiin panel langsung (tanpa animasi biar overlay langsung nutup method)
			if MF.Visible then
				MF.Visible = false
				LogoBtn.Visible = false
			end
			-- Tandai overlay aktif → ESP render loop akan hide semua visual
			_overlayActive = true
			-- Langsung hide SEKARANG (ga nunggu RenderStepped next frame)
			FovCircle.Visible = false
			for _, e in pairs(ESP) do _hideESP(e) end
			-- Tampilkan overlay SEKETIKA tanpa tween/fade
			OvBG.BackgroundTransparency = 0
			TPOverlay.Enabled = true
		end

		_htpo.fn = function()
			if ovAnimConn then ovAnimConn:Disconnect(); ovAnimConn = nil end
			if ovTimerConn then ovTimerConn:Disconnect(); ovTimerConn = nil end
			-- Tutup overlay seketika
			TPOverlay.Enabled = false
			OvBG.BackgroundTransparency = 1
			-- Tandai overlay non-aktif → ESP visual boleh tampil lagi
			_overlayActive = false
			-- Kembaliin panel hanya kalau sebelumnya lagi keliatan
			if _panelWasVisible then
				MF.Visible = true
			end
			_panelWasVisible = false
		end

		-- ================================================================
		-- BONUS TELEPORT METHOD — Kill Respawn Overlay Helper
		-- Force respawn via CFrame warp → CharacterAdded → teleport ke tujuan
		-- Loading screen nutupin layar selama proses, buka setelah nyampe
		-- ================================================================
		local RESPAWN_WARP = Vector3.new(999999, 9999999, 999999)
		local KILL_TP_ESTIMATED = TP_SPEED * 3

		-- Buka overlay SEKALI di awal, jangan dipanggil lagi sampai hide
		local function openBonusTPOverlay(destName)
			ovLabel.Text = "RESPAWNING \226\134\146"
			ovLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
			ovDestLbl.Text = destName
			showTPOverlay(destName, KILL_TP_ESTIMATED)
		end

		-- Update label aja, overlay TETAP nutup (tidak sentuh transparency)
		local function updateBonusTPLabel(destName)
			ovLabel.Text = "TELEPORTING TO"
			ovLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
			ovDestLbl.Text = destName
		end

		-- Tutup overlay — dipanggil HANYA setelah CFrame tujuan di-set + wait
		local function closeBonusTPOverlay()
			ovLabel.Text = "TELEPORTING TO"
			ovLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
			hideTPOverlay()
		end


		-- ================================================================
		-- UNDERGROUND TELEPORT — tpToPos (underground only, no casino)
		-- 3 Step: turun ke Y=-4 → geser ke X,Z tujuan → naik ke Y tujuan
		-- ================================================================
		tpToPos = function(cx, cy, cz, _unused, destName)
			if tpActive then return end
			tpActive = true
			tpCancelled = false

			local ch = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			local hum = ch and ch:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then tpActive=false return end

			-- Show overlay + cancel btn
			local startPos = hrp.Position
			local totalDist = (startPos - Vector3.new(cx, cy, cz)).Magnitude
			showTPOverlay(destName or "Destination", totalDist)
			tpCancelBtn.Visible = true

			-- death handler — kalau mati saat TP, cancel
			local diedDuringTP = false
			local deathConn
			deathConn = plr.CharacterAdded:Connect(function()
				diedDuringTP = true
				tpCancelled = true
			end)

			-- Step 1: turun ke underground
			local underPos = Vector3.new(hrp.Position.X, UNDERGROUND_Y, hrp.Position.Z)
			local ok = lerpChar(hrp.Position, underPos, TP_SPEED)

			-- Step 2: geser ke X,Z tujuan (masih underground)
			if ok and not tpCancelled then
				local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp2 then
					local slideTarget = Vector3.new(cx, UNDERGROUND_Y, cz)
					ok = lerpChar(hrp2.Position, slideTarget, TP_SPEED)
				else ok = false end
			end

			-- Step 3: naik ke Y tujuan
			if ok and not tpCancelled then
				local hrp3 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp3 then
					local riseTarget = Vector3.new(cx, cy + 3, cz)
					ok = lerpChar(hrp3.Position, riseTarget, TP_SPEED)
				end
			end

			-- cleanup
			if deathConn then deathConn:Disconnect() end
			tpCancelBtn.Visible = false
			hideTPOverlay()

			-- reset humanoid setelah TP
			resetHumanoid()

			tpActive = false
		end

		-- ================================================================
		-- TP PAGE — UI
		-- ================================================================
		local ConfirmModal = Instance.new("Frame", MF)
		ConfirmModal.Size = UDim2.new(1,0,1,0)
		ConfirmModal.BackgroundColor3 = Color3.fromRGB(0,0,0)
		ConfirmModal.BackgroundTransparency = 0.5
		ConfirmModal.ZIndex = 20
		ConfirmModal.Visible = false
		Instance.new("UICorner", ConfirmModal).CornerRadius = UDim.new(0, 2)

		local ConfirmCard = Instance.new("Frame", ConfirmModal)
		ConfirmCard.Size = UDim2.new(0.85,0,0,118)
		ConfirmCard.AnchorPoint = Vector2.new(0.5,0.5)
		ConfirmCard.Position = UDim2.new(0.5,0,0.5,0)
		ConfirmCard.BackgroundColor3 = Color3.fromRGB(14,14,14)
		ConfirmCard.ZIndex = 21
		Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 10)
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
		ConfirmBtn.BackgroundColor3 = Color3.fromRGB(38,10,10)
		ConfirmBtn.Text = "Confirm"
		ConfirmBtn.TextColor3 = Color3.fromRGB(220,80,80)
		ConfirmBtn.Font = Enum.Font.GothamBlack
		ConfirmBtn.TextSize = 13
		ConfirmBtn.AutoButtonColor = false
		ConfirmBtn.ZIndex = 22
		Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", ConfirmBtn).Color = Color3.fromRGB(80,25,25)
		ConfirmBtn.ZIndex = 22

		local CancelBtn = Instance.new("TextButton", ConfirmCard)
		CancelBtn.Size = UDim2.new(0.45,0,0,30)
		CancelBtn.Position = UDim2.new(0.03,0,1,-36)
		CancelBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
		CancelBtn.Text = "Cancel"
		CancelBtn.TextColor3 = T.TextDim
		CancelBtn.Font = Enum.Font.GothamBlack
		CancelBtn.TextSize = 13
		CancelBtn.AutoButtonColor = false
		CancelBtn.ZIndex = 22
		Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 6)
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
		tpPageStatusLbl.TextColor3 = T.Accent
		tpPageStatusLbl.Font = Enum.Font.Gotham
		tpPageStatusLbl.TextSize = 13
		tpPageStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

		tpCancelBtn = Instance.new("TextButton", PageTP)
		tpCancelBtn.Size = UDim2.new(0.26,0,0,26)
		tpCancelBtn.AnchorPoint = Vector2.new(1,0)
		tpCancelBtn.Position = UDim2.new(1,0,0,0)
		tpCancelBtn.BackgroundColor3 = Color3.fromRGB(38,10,10)
		tpCancelBtn.Text = "Cancel"
		tpCancelBtn.TextColor3 = Color3.fromRGB(200,70,70)
		tpCancelBtn.Font = Enum.Font.Gotham
		tpCancelBtn.TextSize = 13
		tpCancelBtn.AutoButtonColor = false
		tpCancelBtn.Visible = false
		Instance.new("UICorner", tpCancelBtn).CornerRadius = UDim.new(0,6)
		Instance.new("UIStroke", tpCancelBtn).Color = Color3.fromRGB(80,25,25)

		local function setTPStatus(msg, col)
			tpPageStatusLbl.Text = msg
			tpPageStatusLbl.TextColor3 = col or T.Accent
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
			-- ── BONUS TELEPORT METHOD ─────────────────────────────────────
			-- open SEKALI — layar nutup dari sini sampai beneran nyampe
			openBonusTPOverlay(loc.name)
			setTPStatus("Warp → "..loc.name.."...", T.Accent)
			local ch = plr.Character
			local hrp0 = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp0 then tpBusy=false
				closeBonusTPOverlay()
				return end

			-- Warp ke void buat kill
			hrp0.CFrame = CFrame.new(RESPAWN_WARP)

			-- Tunggu respawn
			local newChar = plr.CharacterAdded:Wait()

			-- Tunggu HRP dan Humanoid exist
			local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
			local hum = newChar:WaitForChild("Humanoid", 10)
			if not hrp or not hum then tpBusy=false
				closeBonusTPOverlay()
				return end

			-- Tunggu humanoid benar-benar hidup & physics aktif
			-- (kalau langsung set CFrame, game reset posisi ke spawn)
			local waited = 0
			while hum.Health <= 0 and waited < 5 do
				task.wait(0.1)
				waited += 0.1
			end
			-- Tunggu extra biar physics server acknowledge posisi spawn dulu
			task.wait(0.8)

			-- update label aja, NO fade in/out
			updateBonusTPLabel(loc.name)

			-- Set CFrame berkali-kali biar dipastikan keapply
			-- (server/client bisa override 1x set di awal respawn)
			local targetCF = CFrame.new(loc.x, loc.y + 3, loc.z)
			for _ = 1, 4 do
				hrp.CFrame = targetCF
				task.wait(0.15)
			end

			task.wait(0.1) -- render dulu baru buka
			-- close SEKALI — baru dibuka setelah CFrame di-set
			closeBonusTPOverlay()
			setTPStatus("Arrived: "..loc.name, T.AccOn)
			-- ─────────────────────────────────────────────────────────────
			tpBusy = false
		end

		-- ================================================================
		-- TP CATEGORIES — FIX: ALL list urutan benar (Apt 1-10, ATM 1-19)
		-- ================================================================
		local TP_CATEGORIES = {
			{
				name = "ATM",
				locs = {
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
				}
			},
			{
				name = "Homeless",
				locs = {
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
				}
			},
			{
				name = "Apartment",
				locs = {
					{name="Apt 1 — Main", x=1142.93, y=10.10, z=453.42},
					{name="Apt 2 — Main", x=1142.9, y=10.10, z=424.9},
					{name="Apt 3 — Mid", x=984.06, y=10.10, z=245.47},
					{name="Apt 4 — Mid", x=984.02, y=10.10, z=216.83},
					{name="Apt 5 — West", x=928.82, y=10.10, z=38.43},
					{name="Apt 6 — West", x=900.62, y=10.10, z=38.39},
					{name="Apt 7 — Casino", x=1180.46, y=3.71, z=-193.920},
					{name="Apt 8 — Casino", x=1202.21, y=3.71, z=-189.78},
					{name="Apt 9 — Casino", x=1180.47, y=3.71, z=-222.41},
					{name="Apt 10 — Casino", x=1202.08, y=3.71, z=-222.910},
				}
			},
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
			hdr.Size = UDim2.new(1,0,0,34)
			hdr.BackgroundColor3 = T.Card
			hdr.Text = ""
			hdr.AutoButtonColor = false
			hdr.LayoutOrder = layoutOrder
			Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8)
			Instance.new("UIStroke", hdr).Color = T.Stroke

			local titleL = Instance.new("TextLabel", hdr)
			titleL.Size=UDim2.new(1,-70,1,0)
			titleL.Position=UDim2.new(0,10,0,0)
			titleL.BackgroundTransparency=1
			titleL.Text=cat.name
			titleL.TextColor3=T.TextDim
			titleL.Font=Enum.Font.GothamBlack
			titleL.TextSize=16
			titleL.TextXAlignment=Enum.TextXAlignment.Left

			local countL = Instance.new("TextLabel", hdr)
			countL.Size=UDim2.new(0,36,1,0)
			countL.Position=UDim2.new(1,-66,0,0)
			countL.BackgroundTransparency=1
			countL.Text=#cat.locs.."loc"
			countL.TextColor3=T.TextDim
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
			cont.BackgroundColor3=Color3.fromRGB(18,18,18)
			cont.ClipsDescendants=true
			cont.LayoutOrder = layoutOrder + 1
			Instance.new("UICorner", cont).CornerRadius=UDim.new(0,8)
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
				row.BackgroundColor3=Color3.fromRGB(16,16,16)
				row.LayoutOrder=i
				Instance.new("UICorner", row).CornerRadius=UDim.new(0,6)
				Instance.new("UIStroke", row).Color=T.Stroke

				local nameL = Instance.new("TextLabel", row)
				nameL.Size=UDim2.new(1,-200,1,0)
				nameL.Position=UDim2.new(0,8,0,0)
				nameL.BackgroundTransparency=1
				nameL.Text=loc.name
				nameL.TextColor3=T.TextDim
				nameL.Font=Enum.Font.GothamBlack
				nameL.TextSize=15
				nameL.TextXAlignment=Enum.TextXAlignment.Left
				nameL.TextTruncate=Enum.TextTruncate.AtEnd

				local vehTPBtn = Instance.new("TextButton", row)
				vehTPBtn.Size=UDim2.new(0,44,0,20)
				vehTPBtn.Position=UDim2.new(1,-142,0.5,-10)
				vehTPBtn.BackgroundColor3=Color3.fromRGB(15,25,55)
				vehTPBtn.Text="VEH"
				vehTPBtn.TextColor3=Color3.fromRGB(80,160,255)
				vehTPBtn.Font=Enum.Font.GothamBlack
				vehTPBtn.TextSize=12
				vehTPBtn.AutoButtonColor=false
				Instance.new("UICorner", vehTPBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", vehTPBtn).Color=Color3.fromRGB(40,80,180)

				local suicideBtn = Instance.new("TextButton", row)
				suicideBtn.Size=UDim2.new(0,56,0,20)
				suicideBtn.Position=UDim2.new(1,-94,0.5,-10)
				suicideBtn.BackgroundColor3=Color3.fromRGB(60,20,20)
				suicideBtn.Text="KILL TP"
				suicideBtn.TextColor3=Color3.fromRGB(220,80,80)
				suicideBtn.Font=Enum.Font.GothamBlack
				suicideBtn.TextSize=12
				suicideBtn.AutoButtonColor=false
				Instance.new("UICorner", suicideBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", suicideBtn).Color=Color3.fromRGB(120,40,40)

				local normalBtn = Instance.new("TextButton", row)
				normalBtn.Size=UDim2.new(0,36,0,20)
				normalBtn.Position=UDim2.new(1,-34,0.5,-10)
				normalBtn.BackgroundColor3=Color3.fromRGB(30,50,30)
				normalBtn.Text="GO"
				normalBtn.TextColor3=Color3.fromRGB(100,220,100)
				normalBtn.Font=Enum.Font.GothamBlack
				normalBtn.TextSize=13
				normalBtn.AutoButtonColor=false
				Instance.new("UICorner", normalBtn).CornerRadius=UDim.new(1,0)
				Instance.new("UIStroke", normalBtn).Color=Color3.fromRGB(60,140,60)


				vehTPBtn.MouseButton1Click:Connect(function()
					local ok = doVehicleTP(CFrame.new(capturedLocN.x, capturedLocN.y, capturedLocN.z))
					if ok then
						setTPStatus("Vehicle → "..capturedLocN.name, Color3.fromRGB(80,160,255))
					else
						setTPStatus("Tidak di kendaraan!", Color3.fromRGB(255,160,0))
					end
				end)

				local capturedLoc = loc

				normalBtn.MouseButton1Click:Connect(function()
					if tpActive then setTPStatus("Sedang proses TP...", T.TextDim)
						return end
					task.spawn(function()
						tpToPos(capturedLoc.x, capturedLoc.y, capturedLoc.z, nil, capturedLoc.name)
						setTPStatus("Arrived: "..capturedLoc.name, T.AccOn)
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

		-- ================================================================
		-- TP TO PLAYER
		-- ================================================================
		do
			local plrTPOpen = false
			local plrTPRows = {}

			local plrHdr = Instance.new("TextButton", PageTP)
			plrHdr.Size = UDim2.new(1,0,0,34)
			plrHdr.BackgroundColor3 = T.Card
			plrHdr.Text = ""
			plrHdr.AutoButtonColor = false
			plrHdr.LayoutOrder = 999
			Instance.new("UICorner", plrHdr).CornerRadius = UDim.new(0,8)
			Instance.new("UIStroke", plrHdr).Color = T.Stroke

			local plrTitle = Instance.new("TextLabel", plrHdr)
			plrTitle.Size = UDim2.new(1,-90,1,0)
			plrTitle.Position = UDim2.new(0,10,0,0)
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
			plrCont.BackgroundColor3 = Color3.fromRGB(18,18,18)
			plrCont.ClipsDescendants = true
			plrCont.LayoutOrder = 1000
			Instance.new("UICorner", plrCont).CornerRadius = UDim.new(0,6)
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
					row.BackgroundColor3 = Color3.fromRGB(16,16,16)
					row.LayoutOrder = idx
					Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
					Instance.new("UIStroke", row).Color = T.Stroke

					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(1,-200,1,0)
					nameLbl.Position = UDim2.new(0,8,0,0)
					nameLbl.BackgroundTransparency=1
					nameLbl.Text=p.DisplayName.."("..p.Name..")"
					nameLbl.TextColor3=T.TextDim
					nameLbl.Font=Enum.Font.GothamBlack
					nameLbl.TextSize=15
					nameLbl.TextXAlignment=Enum.TextXAlignment.Left
					nameLbl.TextTruncate=Enum.TextTruncate.AtEnd

					local goBtn = Instance.new("TextButton", row)
					goBtn.Size=UDim2.new(0,36,0,20)
					goBtn.Position=UDim2.new(1,-200,0.5,-10)
					goBtn.BackgroundColor3=Color3.fromRGB(30,50,30)
					goBtn.Text="GO"
					goBtn.TextColor3=Color3.fromRGB(100,220,100)
					goBtn.Font=Enum.Font.GothamBlack
					goBtn.TextSize=13
					goBtn.AutoButtonColor=false
					Instance.new("UICorner", goBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", goBtn).Color=Color3.fromRGB(60,140,60)

					local vehKillBtn = Instance.new("TextButton", row)
					vehKillBtn.Size=UDim2.new(0,44,0,20)
					vehKillBtn.Position=UDim2.new(1,-160,0.5,-10)
					vehKillBtn.BackgroundColor3=Color3.fromRGB(15,25,55)
					vehKillBtn.Text="VEH"
					vehKillBtn.TextColor3=Color3.fromRGB(80,160,255)
					vehKillBtn.Font=Enum.Font.GothamBlack
					vehKillBtn.TextSize=12
					vehKillBtn.AutoButtonColor=false
					Instance.new("UICorner", vehKillBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", vehKillBtn).Color=Color3.fromRGB(40,80,180)

					local killBtn = Instance.new("TextButton", row)
					killBtn.Size=UDim2.new(0,54,0,20)
					killBtn.Position=UDim2.new(1,-112,0.5,-10)
					killBtn.BackgroundColor3=Color3.fromRGB(60,20,20)
					killBtn.Text="KILL TP"
					killBtn.TextColor3=Color3.fromRGB(220,80,80)
					killBtn.Font=Enum.Font.GothamBlack
					killBtn.TextSize=14
					killBtn.AutoButtonColor=false
					Instance.new("UICorner", killBtn).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", killBtn).Color=Color3.fromRGB(120,40,40)

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
							setTPStatus("Arrived: "..captured.Name, T.AccOn)
						end)
					end)

					vehKillBtn.MouseButton1Click:Connect(function()
						local ch2 = captured.Character
						local hrp2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
						if not hrp2 then setTPStatus("Player tidak ditemukan!", T.TextDim)
							return end
						local ok = doVehicleTP(CFrame.new(hrp2.Position.X, hrp2.Position.Y, hrp2.Position.Z))
						if ok then
							setTPStatus("Vehicle → "..captured.Name, Color3.fromRGB(80,160,255))
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
								-- ── BONUS TELEPORT METHOD ─────────────────────────────
								-- open SEKALI — nutup sampai beneran nyampe
								openBonusTPOverlay(captured.Name)
								setTPStatus("Warp → "..captured.Name.."...", T.Accent)
								local selfCh = plr.Character
								local selfHrp = selfCh and selfCh:FindFirstChild("HumanoidRootPart")
								if not selfHrp then tpBusy=false
									closeBonusTPOverlay()
									return end
								selfHrp.CFrame = CFrame.new(RESPAWN_WARP)
								-- tunggu respawn — overlay TIDAK disentuh, tetap nutup
								local newChar = plr.CharacterAdded:Wait()
								local newHrp = newChar:WaitForChild("HumanoidRootPart", 8)
								if not newHrp then tpBusy=false
									closeBonusTPOverlay()
									return end
								-- update label aja, NO fade in/out
								updateBonusTPLabel(captured.Name)
								task.wait(0.6)
								newHrp.CFrame = CFrame.new(tx, ty + 3, tz)
								task.wait(0.2)
								-- close SEKALI — baru dibuka setelah CFrame di-set
								closeBonusTPOverlay()
								setTPStatus("Arrived: "..captured.Name, T.AccOn)
								-- ─────────────────────────────────────────────────────
								tpBusy = false
							end)
						end)
					end)


					table.insert(plrTPRows, row)
				end

				local refreshRow = Instance.new("TextButton", plrCont)
				refreshRow.Size=UDim2.new(1,0,0,24)
				refreshRow.BackgroundColor3=Color3.fromRGB(35,35,35)
				refreshRow.Text="Refresh List"
				refreshRow.TextColor3=T.Accent
				refreshRow.Font=Enum.Font.GothamBlack
				refreshRow.TextSize=15
				refreshRow.AutoButtonColor=false
				refreshRow.LayoutOrder=0
				Instance.new("UICorner", refreshRow).CornerRadius=UDim.new(0,4)
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

		-- ================================================================
		-- FARM PAGE
	end

	_buildVehicle = function()
		-- ================================================================
		-- VEHICLE PAGE — FLY + VEHICLE TP INFO
		-- ================================================================
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
						-- update UI pill
						local pg = PageVehicle
						local tgl = pg:FindFirstChild("VEH_FlyToggle")
						if tgl then
							local pill = tgl:FindFirstChildOfClass("Frame")
							if pill then
								pill.BackgroundColor3 = Color3.fromRGB(20,20,20)
								local lbl = pill:FindFirstChildOfClass("TextLabel")
								if lbl then lbl.Text="OFF"
									lbl.TextColor3=Color3.fromRGB(85,85,85) end
							end
							tgl.BackgroundColor3 = Color3.fromRGB(12,12,12)
						end
					end
				end
			end)
		end

		-- ── Header ──────────────────────────────────────────────────────
		local secHdr = Instance.new("TextLabel", PageVehicle)
		secHdr.Size = UDim2.new(1,0,0,22)
		secHdr.BackgroundTransparency = 1
		secHdr.Text = "VEHICLE FLY"
		secHdr.TextColor3 = Color3.fromRGB(80,160,255)
		secHdr.Font = Enum.Font.GothamBlack
		secHdr.TextSize = 13
		secHdr.TextXAlignment = Enum.TextXAlignment.Left

		-- ── Fly Toggle Card ─────────────────────────────────────────────
		local function makeToggleBar(parent, flag, label, accent, warning)
			local bar = Instance.new("TextButton", parent)
			bar.Name = "VEH_FlyToggle"
			bar.Size = UDim2.new(1,0,0,46)
			bar.BackgroundColor3 = Color3.fromRGB(12,12,12)
			bar.Text = ""
			bar.AutoButtonColor = false
			Instance.new("UICorner", bar).CornerRadius = UDim.new(0,8)
			Instance.new("UIStroke", bar).Color = Color3.fromRGB(30,30,30)

			local lbl = Instance.new("TextLabel", bar)
			lbl.Size = UDim2.new(1,-70,1,0)
			lbl.Position = UDim2.new(0,12,0,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = label
			lbl.TextColor3 = Color3.fromRGB(200,200,200)
			lbl.Font = Enum.Font.GothamBlack
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local pill = Instance.new("Frame", bar)
			pill.Size = UDim2.new(0,46,0,22)
			pill.Position = UDim2.new(1,-58,0.5,-11)
			pill.BackgroundColor3 = Color3.fromRGB(20,20,20)
			Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
			local pillLbl = Instance.new("TextLabel", pill)
			pillLbl.Size = UDim2.new(1,0,1,0)
			pillLbl.BackgroundTransparency = 1
			pillLbl.Text = "OFF"
			pillLbl.TextColor3 = Color3.fromRGB(85,85,85)
			pillLbl.Font = Enum.Font.GothamBlack
			pillLbl.TextSize = 12

			bar.MouseButton1Click:Connect(function()
				vFlyActive = not vFlyActive
				if vFlyActive then
					vStartFly()
					bar.BackgroundColor3 = Color3.fromRGB(16,16,16)
					pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
					pillLbl.Text = "ON"
					pillLbl.TextColor3 = Color3.fromRGB(0,0,0)
				else
					vStopFly()
					bar.BackgroundColor3 = Color3.fromRGB(12,12,12)
					pill.BackgroundColor3 = Color3.fromRGB(20,20,20)
					pillLbl.Text = "OFF"
					pillLbl.TextColor3 = Color3.fromRGB(85,85,85)
				end
			end)
			return bar
		end
		makeToggleBar(PageVehicle, "VehicleFly", "Vehicle Fly (WASD + E naik / Q turun)", Color3.fromRGB(80,160,255))

		-- ── Speed Slider Card ────────────────────────────────────────────
		local sCard = Instance.new("Frame", PageVehicle)
		sCard.Size = UDim2.new(1,0,0,58)
		sCard.BackgroundColor3 = Color3.fromRGB(12,12,12)
		Instance.new("UICorner", sCard).CornerRadius = UDim.new(0,8)
		Instance.new("UIStroke", sCard).Color = Color3.fromRGB(30,30,30)

		local sLbl = Instance.new("TextLabel", sCard)
		sLbl.Size = UDim2.new(1,-16,0,22)
		sLbl.Position = UDim2.new(0,12,0,4)
		sLbl.BackgroundTransparency = 1
		sLbl.Text = "Fly Speed: "..vFlySpeed
		sLbl.TextColor3 = Color3.fromRGB(200,200,200)
		sLbl.Font = Enum.Font.GothamSemibold
		sLbl.TextSize = 12
		sLbl.TextXAlignment = Enum.TextXAlignment.Left

		local sTrack = Instance.new("Frame", sCard)
		sTrack.Size = UDim2.new(1,-24,0,6)
		sTrack.Position = UDim2.new(0,12,0,36)
		sTrack.BackgroundColor3 = Color3.fromRGB(35,35,35)
		Instance.new("UICorner", sTrack).CornerRadius = UDim.new(1,0)

		local sFill = Instance.new("Frame", sTrack)
		sFill.Size = UDim2.new((vFlySpeed-10)/490,0,1,0)
		sFill.BackgroundColor3 = Color3.fromRGB(80,160,255)
		Instance.new("UICorner", sFill).CornerRadius = UDim.new(1,0)

		local sKnob = Instance.new("Frame", sTrack)
		sKnob.Size = UDim2.new(0,12,0,12)
		sKnob.Position = UDim2.new((vFlySpeed-10)/490,-6,0.5,-6)
		sKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
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

		-- ── Info Card ────────────────────────────────────────────────────
		local infoCard = Instance.new("Frame", PageVehicle)
		infoCard.Size = UDim2.new(1,0,0,80)
		infoCard.BackgroundColor3 = Color3.fromRGB(10,18,30)
		Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0,8)
		Instance.new("UIStroke", infoCard).Color = Color3.fromRGB(30,60,100)

		local infoTxt = Instance.new("TextLabel", infoCard)
		infoTxt.Size = UDim2.new(1,-16,1,-8)
		infoTxt.Position = UDim2.new(0,8,0,4)
		infoTxt.BackgroundTransparency = 1
		infoTxt.Text = "ℹ Duduk di kendaraan dulu sebelum ON\n• W/A/S/D = gerak ngikutin kamera\n• E = naik | Q = turun\n• Auto OFF kalau keluar kendaraan"
		infoTxt.TextColor3 = Color3.fromRGB(80,130,200)
		infoTxt.Font = Enum.Font.Gotham
		infoTxt.TextSize = 12
		infoTxt.TextXAlignment = Enum.TextXAlignment.Left
		infoTxt.TextYAlignment = Enum.TextYAlignment.Top

		-- ── Vehicle TP Info ──────────────────────────────────────────────
		local secHdr2 = Instance.new("TextLabel", PageVehicle)
		secHdr2.Size = UDim2.new(1,0,0,22)
		secHdr2.BackgroundTransparency = 1
		secHdr2.Text = "VEHICLE TELEPORT"
		secHdr2.TextColor3 = Color3.fromRGB(80,160,255)
		secHdr2.Font = Enum.Font.GothamBlack
		secHdr2.TextSize = 13
		secHdr2.TextXAlignment = Enum.TextXAlignment.Left

		local vehTPInfo = Instance.new("Frame", PageVehicle)
		vehTPInfo.Size = UDim2.new(1,0,0,70)
		vehTPInfo.BackgroundColor3 = Color3.fromRGB(10,18,30)
		Instance.new("UICorner", vehTPInfo).CornerRadius = UDim.new(0,8)
		Instance.new("UIStroke", vehTPInfo).Color = Color3.fromRGB(30,60,100)

		local vehTPTxt = Instance.new("TextLabel", vehTPInfo)
		vehTPTxt.Size = UDim2.new(1,-16,1,-8)
		vehTPTxt.Position = UDim2.new(0,8,0,4)
		vehTPTxt.BackgroundTransparency = 1
		vehTPTxt.Text = "Tombol [VEH] ada di tab TP — di setiap\nlokasi dan setiap player.\nKlik [VEH] saat duduk di kendaraan untuk\ntp kendaraan langsung ke tujuan."
		vehTPTxt.TextColor3 = Color3.fromRGB(80,130,200)
		vehTPTxt.Font = Enum.Font.Gotham
		vehTPTxt.TextSize = 12
		vehTPTxt.TextXAlignment = Enum.TextXAlignment.Left
		vehTPTxt.TextYAlignment = Enum.TextYAlignment.Top

	end -- end _buildVehicle

	_buildFarm = function()
		-- ================================================================
		local APARTMENTS = {
			-- lx,ly,lz = posisi kiri (cook spot kiri)
			-- rx,ry,rz = posisi kanan (cook spot kanan)
			-- cx,cy,cz = posisi aktif (otomatis ikut pilihan L/R)
			{name="Farm — Apt 1 Main", x=1142.93, y=10.10, z=453.42, cx=nil, cy=nil, cz=nil, lx=1144.22, ly=4.81, lz=443.35, rx=1145.58, ry=4.81, rz=453.44, side="L"},
			{name="Farm — Apt 2 Main", x=1142.9, y=10.10, z=424.90, cx=nil, cy=nil, cz=nil, lx=1145.47, ly=3.36, lz=421.24, rx=1145.58, ry=4.81, rz=425.46, side="L"},
			{name="Farm — Apt 3 Mid", x=984.06, y=10.10, z=245.47, cx=nil, cy=nil, cz=nil, lx=980.83, ly=3.36, lz=249.26, rx=981.39, ry=4.81, rz=244.9, side="L"},
			{name="Farm — Apt 4 Mid", x=984.02, y=10.10, z=216.83, cx=nil, cy=nil, cz=nil, lx=981.20, ly=3.36, lz=220.62, rx=981.97, ry=4.81, rz=219.16, side="L"},
			{name="Farm — Apt 5 West", x=928.82, y=10.10, z=38.43, cx=nil, cy=nil, cz=nil, lx=924.15, ly=3.36, lz=36.13, rx=928.6, ry=3.36, rz=35.91, side="L"},
			{name="Farm — Apt 6 West", x=900.62, y=10.10, z=38.39, cx=nil, cy=nil, cz=nil, lx=893.63, ly=3.36, lz=36.9, rx=900.79, ry=3.36, rz=37.24, side="L"},
			{name="Farm — Apt 7 Casino", x=1180.46, y=3.71, z=-193.92, cx=nil, cy=nil, cz=nil, lx=1182.30, ly=7.45, lz=-191.07, rx=1182.42, ry=7.56, rz=-188.66, side="L", topLx=1182.51, topLy=15.96, topLz=-191.75, topRx=1182.54, topRy=15.96, topRz=-188.08},
			{name="Farm — Apt 8 Casino", x=1202.21, y=3.71, z=-189.78, cx=nil, cy=nil, cz=nil, lx=1200.61, ly=7.80, lz=-179.03, rx=1200.42, ry=7.80, rz=-180.42, side="L", topLx=1200.27, topLy=15.96, topLz=-178.01, topRx=1200.29, topRy=15.96, topRz=-181.31},
			{name="Farm — Apt 9 Casino", x=1180.47, y=3.71, z=-222.41, cx=nil, cy=nil, cz=nil, lx=1182.72, ly=7.56, lz=-229.21, rx=1182.84, ry=7.56, rz=-226.89, side="L", topLx=1182.76, topLy=15.96, topLz=-229.35, topRx=1182.65, topRy=15.96, topRz=-227.35},
			{name="Farm — Apt 10 Casino", x=1202.08, y=3.71, z=-222.91, cx=nil, cy=nil, cz=nil, lx=1200.68, ly=7.53, lz=-217.65, rx=1200.72, ry=7.53, rz=-219.78, side="L", topLx=1200.00, topLy=15.96, topLz=-217.06, topRx=1199.99, topRy=15.96, topRz=-220.03},
		}

		local selectedApart = nil
		local apartRows = {}
		local apartOpen = false

		-- Update cx,cy,cz berdasarkan side L/R
		local function updateApartCook(apart)
			if apart.side == "R" and apart.rx then
				apart.cx=apart.rx
				apart.cy=apart.ry
				apart.cz=apart.rz
			elseif apart.lx then
				apart.cx=apart.lx
				apart.cy=apart.ly
				apart.cz=apart.lz
			else
				apart.cx=nil
				apart.cy=nil
				apart.cz=nil
			end
			-- Koordinat atap (untuk casino: posisi pasti saat masukin bahan)
			if apart.side == "R" and apart.topRx then
				apart.topCx=apart.topRx
				apart.topCy=apart.topRy
				apart.topCz=apart.topRz
			elseif apart.topLx then
				apart.topCx=apart.topLx
				apart.topCy=apart.topLy
				apart.topCz=apart.topLz
			else
				apart.topCx=nil
				apart.topCy=nil
				apart.topCz=nil
			end
		end
		-- Init semua
		for _,a in ipairs(APARTMENTS) do updateApartCook(a) end

		local apartHdr = Instance.new("TextButton", PageFarm)
		apartHdr.Size = UDim2.new(1,0,0,34)
		apartHdr.BackgroundColor3 = T.Card
		apartHdr.Text = ""
		apartHdr.AutoButtonColor = false
		Instance.new("UICorner", apartHdr).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", apartHdr).Color = T.Stroke

		local apartHdrLbl = Instance.new("TextLabel", apartHdr)
		apartHdrLbl.Size=UDim2.new(1,-60,1,0)
		apartHdrLbl.Position=UDim2.new(0,10,0,0)
		apartHdrLbl.BackgroundTransparency=1
		apartHdrLbl.Text="Pilih Apartment"
		apartHdrLbl.TextColor3=T.TextDim
		apartHdrLbl.Font=Enum.Font.GothamBlack
		apartHdrLbl.TextSize=16
		apartHdrLbl.TextXAlignment=Enum.TextXAlignment.Left

		local apartCountLbl = Instance.new("TextLabel", apartHdr)
		apartCountLbl.Size=UDim2.new(0,40,1,0)
		apartCountLbl.Position=UDim2.new(1,-74,0,0)
		apartCountLbl.BackgroundTransparency=1
		apartCountLbl.Text=#APARTMENTS.."apt"
		apartCountLbl.TextColor3=T.TextDim
		apartCountLbl.Font=Enum.Font.GothamBlack
		apartCountLbl.TextSize=14

		local apartArrow = Instance.new("TextLabel", apartHdr)
		apartArrow.Size=UDim2.new(0,26,1,0)
		apartArrow.Position=UDim2.new(1,-30,0,0)
		apartArrow.BackgroundTransparency=1
		apartArrow.Text="v"
		apartArrow.TextColor3=T.TextDim
		apartArrow.Font=Enum.Font.GothamBlack
		apartArrow.TextSize=16

		local apartStatusLbl = Instance.new("TextLabel", PageFarm)
		apartStatusLbl.Size=UDim2.new(1,0,0,16)
		apartStatusLbl.BackgroundTransparency=1
		apartStatusLbl.Text=""
		apartStatusLbl.TextColor3=T.Accent
		apartStatusLbl.Font=Enum.Font.GothamBlack
		apartStatusLbl.TextSize=15

		local apartContainer = Instance.new("Frame", PageFarm)
		apartContainer.Size=UDim2.new(1,0,0,0)
		apartContainer.BackgroundColor3=Color3.fromRGB(20,20,20)
		apartContainer.ClipsDescendants=true
		Instance.new("UICorner", apartContainer).CornerRadius=UDim.new(0,8)
		Instance.new("UIStroke", apartContainer).Color=T.Stroke

		local apartLayout = Instance.new("UIListLayout", apartContainer)
		apartLayout.Padding=UDim.new(0,3)
		apartLayout.SortOrder=Enum.SortOrder.LayoutOrder
		local apartPad = Instance.new("UIPadding", apartContainer)
		apartPad.PaddingTop=UDim.new(0,5)
		apartPad.PaddingBottom=UDim.new(0,5)
		apartPad.PaddingLeft=UDim.new(0,5)
		apartPad.PaddingRight=UDim.new(0,5)

		local APART_ITEM_H = 33
		local APART_TOTAL_H = #APARTMENTS * APART_ITEM_H + 12

		local function setApartStatus(msg, col)
			apartStatusLbl.Text = msg
			apartStatusLbl.TextColor3 = col or T.Accent
			task.delay(3, function()
				if apartStatusLbl.Text == msg then apartStatusLbl.Text = "" end
			end)
		end

		local refreshCookBar

		local function refreshApartRows()
			for i, data in ipairs(APARTMENTS) do
				local row = apartRows[i]
				if not row then continue end
				local isSelected = selectedApart and selectedApart.name == data.name
				row.BackgroundColor3 = isSelected and Color3.fromRGB(50,50,50) or Color3.fromRGB(28,28,28)
				local str = row:FindFirstChildOfClass("UIStroke")
				if str then str.Color = isSelected and T.Accent or T.Stroke end
				local nameLbl = row:FindFirstChild("NameLbl")
				if nameLbl then nameLbl.TextColor3 = isSelected and T.Text or T.TextDim end
				local pill = row:FindFirstChild("StatusPill")
				if pill then
					pill.BackgroundColor3 = isSelected and T.AccOn or Color3.fromRGB(20,20,20)
					local pillLbl = pill:FindFirstChildOfClass("TextLabel")
					if pillLbl then
						pillLbl.Text = isSelected and "ACTIVE" or "OFF"
						pillLbl.TextColor3 = isSelected and Color3.fromRGB(0,0,0) or T.TextDim
					end
				end
				if isSelected then
					apartHdrLbl.Text = data.name
					apartHdrLbl.TextColor3 = T.Text
				end
			end
			if not selectedApart then
				apartHdrLbl.Text = "Pilih Apartment"
				apartHdrLbl.TextColor3 = T.TextDim
			end
		end

		apartHdr.MouseButton1Click:Connect(function()
			apartOpen = not apartOpen
			if apartOpen then
				TweenService:Create(apartContainer, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{Size=UDim2.new(1,0,0,APART_TOTAL_H)}):Play()
				apartArrow.Text="^"
			else
				TweenService:Create(apartContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
				{Size=UDim2.new(1,0,0,0)}):Play()
				apartArrow.Text="v"
			end
		end)

		for i, apart in ipairs(APARTMENTS) do
			local row = Instance.new("TextButton", apartContainer)
			row.Name = "ApartRow_"..i
			row.Size = UDim2.new(1,0,0,30)
			row.BackgroundColor3 = Color3.fromRGB(18,18,18)
			row.Text = ""
			row.AutoButtonColor = false
			row.LayoutOrder = i
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
			local rowStr = Instance.new("UIStroke", row)
			rowStr.Color = T.Stroke
			rowStr.Thickness = 0.8

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Name="NameLbl"
			nameLbl.Size=UDim2.new(1,-165,1,0)
			nameLbl.Position=UDim2.new(0,10,0,0)
			nameLbl.BackgroundTransparency=1
			nameLbl.Text=apart.name
			nameLbl.TextColor3=T.TextDim
			nameLbl.Font=Enum.Font.GothamBlack
			nameLbl.TextSize=15
			nameLbl.TextXAlignment=Enum.TextXAlignment.Left

			-- L/R capsule
			local cap=Instance.new("Frame",row)
			cap.Name="LRCap"
			cap.Size=UDim2.new(0,46,0,20)
			cap.Position=UDim2.new(1,-148,0.5,-10)
			cap.BackgroundColor3=Color3.fromRGB(22,22,22)
			Instance.new("UICorner",cap).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke",cap).Color=T.Stroke

			local lB=Instance.new("TextButton",cap)
			lB.Size=UDim2.new(0.5,0,1,0)
			lB.BackgroundColor3=Color3.fromRGB(255,255,255)
			lB.Text="L"
			lB.TextColor3=Color3.fromRGB(0,0,0)
			lB.Font=Enum.Font.GothamBlack
			lB.TextSize=11
			lB.AutoButtonColor=false
			Instance.new("UICorner",lB).CornerRadius=UDim.new(1,0)

			local rB=Instance.new("TextButton",cap)
			rB.Size=UDim2.new(0.5,0,1,0)
			rB.Position=UDim2.new(0.5,0,0,0)
			rB.BackgroundColor3=Color3.fromRGB(30,30,30)
			rB.Text="R"
			rB.TextColor3=Color3.fromRGB(85,85,85)
			rB.Font=Enum.Font.GothamBlack
			rB.TextSize=11
			rB.AutoButtonColor=false
			Instance.new("UICorner",rB).CornerRadius=UDim.new(1,0)

			local captApart=apart
			local function doRefreshLR()
				local isL=captApart.side~="R"
				lB.BackgroundColor3=isL and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
				lB.TextColor3=isL and Color3.fromRGB(0,0,0) or Color3.fromRGB(85,85,85)
				rB.BackgroundColor3=(not isL) and Color3.fromRGB(255,255,255) or Color3.fromRGB(30,30,30)
				rB.TextColor3=(not isL) and Color3.fromRGB(0,0,0) or Color3.fromRGB(85,85,85)
			end
			doRefreshLR()
			lB.MouseButton1Click:Connect(function()
				captApart.side="L"
				updateApartCook(captApart)
				doRefreshLR()
			end)
			rB.MouseButton1Click:Connect(function()
				captApart.side="R"
				updateApartCook(captApart)
				doRefreshLR()
			end)

			local goBtn = Instance.new("TextButton", row)
			goBtn.Size=UDim2.new(0,36,0,20)
			goBtn.Position=UDim2.new(1,-98,0.5,-10)
			goBtn.BackgroundColor3=Color3.fromRGB(30,50,30)
			goBtn.Text="GO"
			goBtn.TextColor3=Color3.fromRGB(100,220,100)
			goBtn.Font=Enum.Font.GothamBlack
			goBtn.TextSize=13
			goBtn.AutoButtonColor=false
			Instance.new("UICorner", goBtn).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke", goBtn).Color=Color3.fromRGB(60,140,60)

			local statusPill = Instance.new("Frame", row)
			statusPill.Name="StatusPill"
			statusPill.Size=UDim2.new(0,54,0,18)
			statusPill.Position=UDim2.new(1,-58,0.5,-9)
			statusPill.BackgroundColor3=Color3.fromRGB(20,20,20)
			Instance.new("UICorner", statusPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke", statusPill).Color = T.Stroke
			local statusPillLbl = Instance.new("TextLabel", statusPill)
			statusPillLbl.Size=UDim2.new(1,0,1,0)
			statusPillLbl.BackgroundTransparency=1
			statusPillLbl.Text="OFF"
			statusPillLbl.TextColor3=T.TextDim
			statusPillLbl.Font=Enum.Font.GothamBlack
			statusPillLbl.TextSize=14

			apartRows[i] = row

			local capturedApart = apart

			row.MouseButton1Click:Connect(function()
				local mp = UIS:GetMouseLocation()
				local ga = goBtn.AbsolutePosition
				local gs = goBtn.AbsoluteSize
				if mp.X >= ga.X and mp.X <= ga.X+gs.X and mp.Y >= ga.Y and mp.Y <= ga.Y+gs.Y then return end
				if selectedApart and selectedApart.name == capturedApart.name then
					selectedApart = nil
					Flags.AutoCook = false
					if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
					if refreshCookBar then refreshCookBar() end
					refreshApartRows()
					setApartStatus("Stopped — "..capturedApart.name, T.TextDim)
				else
					selectedApart = capturedApart
					refreshApartRows()
					setApartStatus("Selected: "..capturedApart.name, T.Accent)
				end
			end)

			goBtn.MouseButton1Click:Connect(function()
				selectedApart = capturedApart
				refreshApartRows()
				setApartStatus("TP -> "..capturedApart.name.."...", T.Accent)

				apartOpen = false
				TweenService:Create(apartContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
				{Size=UDim2.new(1,0,0,0)}):Play()
				apartArrow.Text = "v"

				task.spawn(function()
					local tx = capturedApart.cx or capturedApart.x
					local ty = capturedApart.cy or capturedApart.y
					local tz = capturedApart.cz or capturedApart.z

					-- Direct CFrame TP (bypass lerp underground yg bikin gagal)
					local ch = plr.Character
					local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					if hrp and hum then
						hum.WalkSpeed = 0
						hrp.AssemblyLinearVelocity = Vector3.zero
						hrp.AssemblyAngularVelocity = Vector3.zero
						hrp.CFrame = CFrame.new(tx, ty + 3, tz)
						task.wait(0.1)
						hrp.AssemblyLinearVelocity = Vector3.zero
						hrp.AssemblyAngularVelocity = Vector3.zero
						hrp.CFrame = CFrame.new(tx, ty + 3, tz)
						task.wait(0.1)
						hum.WalkSpeed = 16
					end
					setApartStatus("Arrived: "..capturedApart.name, T.AccOn)
				end)
			end)
		end

		local StatsCard = Instance.new("Frame", PageFarm)
		StatsCard.Size = UDim2.new(1, 0, 0, 40)
		StatsCard.BackgroundColor3 = T.Card
		Instance.new("UICorner", StatsCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", StatsCard).Color = T.Stroke

		local CounterLbl = Instance.new("TextLabel", StatsCard)
		CounterLbl.Size = UDim2.new(0.5, -4, 1, 0)
		CounterLbl.Position = UDim2.new(0, 6, 0, 0)
		CounterLbl.BackgroundTransparency = 1
		CounterLbl.Text = "Cooked: 0"
		CounterLbl.TextColor3 = T.Accent
		CounterLbl.Font = Enum.Font.GothamBlack
		CounterLbl.TextSize = 17
		CounterLbl.TextXAlignment = Enum.TextXAlignment.Left

		local TimerLbl = Instance.new("TextLabel", StatsCard)
		TimerLbl.Size = UDim2.new(0.5, -4, 1, 0)
		TimerLbl.Position = UDim2.new(0.5, 0, 0, 0)
		TimerLbl.BackgroundTransparency = 1
		TimerLbl.Text = "Step: —"
		TimerLbl.TextColor3 = T.TextDim
		TimerLbl.Font = Enum.Font.GothamBlack
		TimerLbl.TextSize = 16
		TimerLbl.TextXAlignment = Enum.TextXAlignment.Right

		local ResetBtn = Instance.new("TextButton", PageFarm)
		ResetBtn.Size = UDim2.new(1, 0, 0, 28)
		ResetBtn.BackgroundColor3 = Color3.fromRGB(32, 10, 10)
		ResetBtn.Text = "Reset Counter"
		ResetBtn.TextColor3 = Color3.fromRGB(180, 60, 60)
		ResetBtn.Font = Enum.Font.GothamBlack
		ResetBtn.TextSize = 13
		ResetBtn.AutoButtonColor = false
		Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", ResetBtn).Color = Color3.fromRGB(60, 20, 20)

		local totalMasak = 0
		local currentCookStep = 1
		local lastCookProgressTime = 0   -- tick() terakhir kali step berhasil maju
		local COOK_WATCHDOG_SECS = 150   -- 2.5 menit timeout sebelum reset ke water
		local cookSteps = {
			{keyword="water", baseWait=20},
			{
				multi = {
					{keyword="sugar", wait=1.5},
					{keyword="gelatin", wait=45},
				}
			},
			{keyword="empty", baseWait=2},
		}

		ResetBtn.MouseButton1Click:Connect(function()
			totalMasak=0
			CounterLbl.Text="Cooked: 0"
			currentCookStep=1
		end)

		local CookBar = Instance.new("TextButton", PageFarm)
		CookBar.Size = UDim2.new(1, 0, 0, 36)
		CookBar.BackgroundColor3 = T.Card
		CookBar.Text = ""
		CookBar.AutoButtonColor = false
		Instance.new("UICorner", CookBar).CornerRadius = UDim.new(0, 8)
		local cbStr = Instance.new("UIStroke", CookBar)
		cbStr.Color = T.Stroke
		cbStr.Thickness = 1

		local cookNameLbl = Instance.new("TextLabel", CookBar)
		cookNameLbl.Size = UDim2.new(1,-60,1,0)
		cookNameLbl.Position = UDim2.new(0,10,0,0)
		cookNameLbl.BackgroundTransparency=1
		cookNameLbl.Text="Auto Cook"
		cookNameLbl.TextColor3=T.TextDim
		cookNameLbl.Font=Enum.Font.GothamBlack
		cookNameLbl.TextSize=16
		cookNameLbl.TextXAlignment=Enum.TextXAlignment.Left

		local cookStatusPill = Instance.new("Frame", CookBar)
		cookStatusPill.Size = UDim2.new(0,46,0,22)
		cookStatusPill.Position=UDim2.new(1,-52,0.5,-11)
		cookStatusPill.BackgroundColor3=Color3.fromRGB(20,20,20)
		Instance.new("UICorner", cookStatusPill).CornerRadius=UDim.new(1,0)
		Instance.new("UIStroke", cookStatusPill).Color = T.Stroke
		local cookStatusLbl = Instance.new("TextLabel", cookStatusPill)
		cookStatusLbl.Size=UDim2.new(1,0,1,0)
		cookStatusLbl.BackgroundTransparency=1
		cookStatusLbl.Text="OFF"
		cookStatusLbl.TextColor3=T.TextDim
		cookStatusLbl.Font=Enum.Font.GothamBlack
		cookStatusLbl.TextSize=15

		-- Helper: set CanCollide apart 5 (LT1) dan apart 6 (BH1)
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
				setObj(lt1.Floor)
				setObj(lt1.Stove)
				setObj(lt1.Part)
				setObj(lt1:GetChildren()[22])
				setObj(lt1:GetChildren()[23])
				setObj(lt1:GetChildren()[32])
			end)
			pcall(function()
				local bh1 = workspace.Map.Houses.BH1.Interior
				setObj(bh1.Floor)
				setObj(bh1.Stove)
				setObj(bh1.Part)
				setObj(bh1:GetChildren()[22])
				setObj(bh1:GetChildren()[23])
				setObj(bh1:GetChildren()[32])
			end)
		end

		refreshCookBar = function()
			local on = Flags.AutoCook
			CookBar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
			cbStr.Color = on and T.StrokeOn or T.Stroke
			cookNameLbl.TextColor3 = on and T.Text or T.TextDim
			cookStatusPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(20,20,20)
			cookStatusLbl.Text = on and "ON" or "OFF"
			cookStatusLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
		end

		CookBar.MouseButton1Click:Connect(function()
			Flags.AutoCook = not Flags.AutoCook
			refreshCookBar()
			saveSettings()


			-- Kalau AutoCook nyala dan apart yang dipilih adalah apart 5 atau 6, matiin CanCollide floor
			if Flags.AutoCook then
				if selectedApart then
					local aptName = selectedApart.name:lower()
					if aptName:find("apt 5") or aptName:find("apt5") or aptName:find("west") then
						setApart56FloorCollide(false)
					elseif aptName:find("apt 6") or aptName:find("apt6") then
						setApart56FloorCollide(false)
					end
				end
			else
				-- AutoCook dimatiin, kembaliin CanCollide floor
				setApart56FloorCollide(true)
			end

			if Flags.AutoCook then
				lastCookProgressTime = tick() -- mulai watchdog dari sekarang
				if selectedApart then
				local apt = selectedApart
				local isCasino = apt.name:lower():find("casino") ~= nil
				if not isCasino and apt.cx and apt.cy and apt.cz then
					task.spawn(function()
						local ch = plr.Character
						local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
						if not hrp then return end
						local targetCF = CFrame.new(apt.cx, apt.cy, apt.cz)
						local dist = (hrp.Position - targetCF.Position).Magnitude
						local tw = TweenService:Create(hrp,
							TweenInfo.new(math.max(dist / 10000, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{CFrame = targetCF}
						)
						tw:Play()
						tw.Completed:Wait()
					end)
				end
			end
		end
		end)

		local function getPromptPosition(prompt)
			local part = prompt.Parent
			if part:IsA("Attachment") then
				return part.WorldPosition, part.Parent
			elseif part:IsA("BasePart") then
				return part.Position, part
			elseif part:IsA("Model") then
				local rp = part.PrimaryPart or part:FindFirstChildOfClass("BasePart")
				if rp then return rp.Position, rp end
			end
			return nil, nil
		end

		local function findCookPrompt()
			local ch  = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp then return nil end

			local best, bestDist = nil, math.huge
			local fallback, fallbackDist = nil, math.huge

			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("ProximityPrompt") then
					local pos, _ = getPromptPosition(obj)
					if not pos then continue end

					local dist = (pos - hrp.Position).Magnitude
					if dist > 30 then continue end -- ignore yang jauh banget

					local parent      = obj.Parent
					local grandParent = (parent and parent.Parent and parent.Parent.Name or ""):lower()
					local parentName  = parent.Name:lower()
					local actionText  = obj.ActionText:lower()

					local isCook = grandParent:find("cooking pot") or grandParent:find("pot")
						or parentName:find("pot") or parentName:find("cook")
						or actionText:find("cook") or actionText:find("interact")
						or actionText:find("add") or actionText:find("place")
						or actionText:find("use") or actionText:find("put")

					if isCook and dist < bestDist then
						bestDist = dist
						best = obj
					end

					-- fallback: prompt terdekat apapun dalam radius 10 studs
					if dist < 10 and dist < fallbackDist then
						fallbackDist = dist
						fallback = obj
					end
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

		local CASINO_FLOAT_STUDS = 15

		local function isCasinoApart()
			return selectedApart and selectedApart.name:lower():find("casino") ~= nil
		end

		local function snapToCookPos()
			if not selectedApart or not selectedApart.cx then return end
			local ch  = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local targetCF = CFrame.new(selectedApart.cx, selectedApart.cy, selectedApart.cz)
			local dist = (hrp.Position - targetCF.Position).Magnitude
			if dist < 0.5 then return end
			local tw = TweenService:Create(hrp,
				TweenInfo.new(math.max(dist / 10000, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
				{CFrame = targetCF}
			)
			tw:Play()
			tw.Completed:Wait()
		end

		-- Teleport ke koordinat atap (posisi pasti saat masukin bahan di kasino)
		local function snapToTopPos()
			if not selectedApart or not selectedApart.topCx then return end
			local ch  = plr.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			hrp.CFrame = CFrame.new(selectedApart.topCx, selectedApart.topCy, selectedApart.topCz)
			task.wait(0.1)
		end

		-- startFloat/stopFloat dihapus — diganti snapToTopPos/snapToCookPos yg pakai koordinat pasti

		-- Helper restore CanCollide (dipanggil tiap AutoCook dimatiin)
		_G.HNDRIXX_RESTORE_FLOOR = function()
			local function restoreObj(obj)
				pcall(function()
					if obj:IsA("BasePart") then obj.CanCollide = true end
					for _, part in ipairs(obj:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = true end
					end
				end)
			end
			pcall(function()
				local lt1 = workspace.Map.Houses.LT1.Interior
				restoreObj(lt1.Floor)
				restoreObj(lt1.Stove)
				restoreObj(lt1.Part)
				restoreObj(lt1:GetChildren()[22])
				restoreObj(lt1:GetChildren()[23])
				restoreObj(lt1:GetChildren()[32])
			end)
			pcall(function()
				local bh1 = workspace.Map.Houses.BH1.Interior
				restoreObj(bh1.Floor)
				restoreObj(bh1.Stove)
				restoreObj(bh1.Part)
				restoreObj(bh1:GetChildren()[22])
				restoreObj(bh1:GetChildren()[23])
				restoreObj(bh1:GetChildren()[32])
			end)
		end

		task.spawn(function()
			while Running do
				task.wait(math.random(10,20)/100)
				if Flags.AutoCook then

					-- ── WATCHDOG: reset ke water kalau lag/stuck terlalu lama ──
					if lastCookProgressTime > 0 and (tick() - lastCookProgressTime) > COOK_WATCHDOG_SECS then
						currentCookStep = 1
						lastCookProgressTime = tick()
						cookNameLbl.Text = "⚠ Stuck! Reset ke water..."
						TimerLbl.Text = "RESET"
						task.wait(1.5)
						if Flags.AutoCook then cookNameLbl.Text = "Auto Cook" end
						TimerLbl.Text = "—"
					end
					-- ──────────────────────────────────────────────────────────

					local data = cookSteps[currentCookStep]
					local ch = plr.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")

					local function findTool(keyword)
						local t = nil
						for i = 1, 6 do
							if not Flags.AutoCook or not Running then break end
							if plr.Backpack then
								for _, v in pairs(plr.Backpack:GetChildren()) do
									if string.find(string.lower(v.Name), keyword) then t = v
										break end
								end
							end
							if not t and plr.Character then
								for _, v in pairs(plr.Character:GetChildren()) do
									if v:IsA("Tool") and string.find(string.lower(v.Name), keyword) then t = v
										break end
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

						if isCasinoApart() then
							-- Selalu ke bawah dulu (cx/cy/cz) untuk equip + fire prompt
							snapToCookPos()
							task.wait(0.2)
						elseif selectedApart and selectedApart.cx then
							snapToCookPos()
							task.wait(0.15)
						end

						task.wait(math.random(1,2)/10)
						hm:EquipTool(tool)
						task.wait(math.random(1,2)/10)

						local prompt = findCookPrompt()
						if prompt then
							triggerPrompt(prompt)
							task.wait(math.random(1,2)/10)
						end

						-- Setelah prompt ke-fire, baru naik ke atas (khusus kasino, bukan empty)
						if isCasinoApart() and not needDown then
							snapToTopPos()
						end

						local tw = 0
						local hw = waitTime + (math.random(1,5)/10)
						TimerLbl.Text = string.upper(keyword)..": "..string.format("%.0fs", hw)
						while tw < hw and Flags.AutoCook and Running do
							local mw = math.random(3,5)/10
							task.wait(mw)
							tw = tw + mw
							TimerLbl.Text = string.upper(keyword)..": "..string.format("%.0fs", math.max(hw-tw, 0))
						end
						TimerLbl.Text = "—"
						return true
					end

					if data.multi then
						local allOk = true
						for idx, sub in ipairs(data.multi) do
							if not Flags.AutoCook or not Running then allOk = false
								break end
							local ok = doOneBahan(sub.keyword, sub.wait, false)
							if not ok then
								Flags.AutoCook = false
								if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
								refreshCookBar()
								cookNameLbl.Text = "Out of stock: "..string.upper(sub.keyword)
								task.wait(3)
								if not Flags.AutoCook then cookNameLbl.Text = "Auto Cook" end
								allOk = false
								break
							end
						end
						if allOk and Flags.AutoCook and Running then
							currentCookStep = currentCookStep + 1
							if currentCookStep > #cookSteps then currentCookStep = 1 end
							lastCookProgressTime = tick() -- progress berhasil, reset timer
						end
					else
						local needDown = (data.keyword == "empty")

						if isCasinoApart() then
							-- Selalu ke bawah dulu untuk equip + fire prompt
							snapToCookPos()
							task.wait(0.2)
						elseif selectedApart and selectedApart.cx then
							snapToCookPos()
							task.wait(0.15)
						end

						local tool = findTool(data.keyword)
						if tool and hum then
							task.wait(math.random(1,2)/10)
							hum:EquipTool(tool)
							task.wait(math.random(1,2)/10)

							local prompt = findCookPrompt()
							if prompt then
								triggerPrompt(prompt)
								task.wait(math.random(1,2)/10)
								if data.keyword == "empty" then
									task.wait(math.random(1,2)/10)
									local prompt2 = findCookPrompt()
									if prompt2 then triggerPrompt(prompt2) end
								end
							end

							-- Setelah prompt ke-fire, baru naik ke atas (khusus kasino, bukan empty)
							if isCasinoApart() and not needDown then
								snapToTopPos()
							end

							local hw = data.baseWait + (math.random(1,5)/10)
							local tw = 0
							TimerLbl.Text = string.upper(data.keyword)..": "..string.format("%.0fs", hw)
							while tw < hw and Flags.AutoCook and Running do
								local mw = math.random(3,5)/10
								task.wait(mw)
								tw = tw + mw
								TimerLbl.Text = string.upper(data.keyword)..": "..string.format("%.0fs", math.max(hw-tw, 0))
							end
							TimerLbl.Text = "—"

							if Flags.AutoCook and Running then
								if data.keyword == "empty" then
									totalMasak = totalMasak + 1
									CounterLbl.Text = "Cooked: "..totalMasak
								end
								currentCookStep = currentCookStep + 1
								if currentCookStep > #cookSteps then currentCookStep = 1 end
								lastCookProgressTime = tick() -- progress berhasil, reset timer
							end
						else
							Flags.AutoCook = false
							if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
							refreshCookBar()
							cookNameLbl.Text = "Out of stock: "..string.upper(data.keyword)
							task.wait(3)
							if not Flags.AutoCook then cookNameLbl.Text = "Auto Cook" end
						end
					end
				end
			end
		end)


		-- Cam Lock toggle (di bawah Auto Cook)
		do
			local camLocked = false
			local camLockConn = nil
			local lockedCF = nil

			local camBar = Instance.new("TextButton", PageFarm)
			camBar.Size = UDim2.new(1,0,0,36)
			camBar.BackgroundColor3 = T.Card
			camBar.Text = ""
			camBar.AutoButtonColor = false
			Instance.new("UICorner", camBar).CornerRadius = UDim.new(0,8)
			local camStr = Instance.new("UIStroke", camBar)
			camStr.Color = T.Stroke
			camStr.Thickness = 1

			local camDot = Instance.new("Frame", camBar)
			camDot.Size=UDim2.new(0,5,0,5)
			camDot.Position=UDim2.new(0,12,0.5,-2.5)
			camDot.BackgroundColor3=Color3.fromRGB(38,38,38)
			Instance.new("UICorner",camDot).CornerRadius=UDim.new(1,0)

			local camName = Instance.new("TextLabel", camBar)
			camName.Size=UDim2.new(1,-76,1,0)
			camName.Position=UDim2.new(0,24,0,0)
			camName.BackgroundTransparency=1
			camName.Text="Cam Lock"
			camName.TextColor3=T.TextDim
			camName.Font=Enum.Font.Gotham
			camName.TextSize=14
			camName.TextXAlignment=Enum.TextXAlignment.Left

			local camPill = Instance.new("Frame", camBar)
			camPill.Size=UDim2.new(0,46,0,22)
			camPill.Position=UDim2.new(1,-52,0.5,-11)
			camPill.BackgroundColor3=Color3.fromRGB(20,20,20)
			Instance.new("UICorner",camPill).CornerRadius=UDim.new(1,0)
			Instance.new("UIStroke",camPill).Color=T.Stroke
			local camPillLbl=Instance.new("TextLabel",camPill)
			camPillLbl.Size=UDim2.new(1,0,1,0)
			camPillLbl.BackgroundTransparency=1
			camPillLbl.Text="OFF"
			camPillLbl.TextColor3=T.TextDim
			camPillLbl.Font=Enum.Font.GothamBlack
			camPillLbl.TextSize=12

			local function setCamLock(on)
				camLocked = on
				camBar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
				camStr.Color = on and T.StrokeOn or T.Stroke
				camDot.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(38,38,38)
				camName.TextColor3 = on and T.Text or T.TextDim
				camPill.BackgroundColor3 = on and T.AccOn or Color3.fromRGB(20,20,20)
				camPillLbl.Text = on and "ON" or "OFF"
				camPillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
				local st = camPill:FindFirstChildOfClass("UIStroke")
				if on then if st then st:Destroy() end
				else if not st then Instance.new("UIStroke",camPill).Color=T.Stroke end end

				if on then
					local cam = workspace.CurrentCamera
					lockedCF = cam.CFrame
					cam.CameraType = Enum.CameraType.Scriptable
					if camLockConn then camLockConn:Disconnect() end
					camLockConn = RunService.RenderStepped:Connect(function()
						if not camLocked then return end
						workspace.CurrentCamera.CFrame = lockedCF
					end)
				else
					if camLockConn then camLockConn:Disconnect()
						camLockConn=nil end
					workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
					lockedCF = nil
				end
			end

			camBar.MouseButton1Click:Connect(function()
				setCamLock(not camLocked)
			end)
		end

		local INGREDIENTS = {
			{ label="Water", key="water" },
			{ label="Sugar", key="sugar" },
			{ label="Gelatin", key="gelatin" },
			{ label="Marshmallow", key="marshmallow" },
			{ label="Small", key="small" },
			{ label="Medium", key="medium" },
			{ label="Large", key="large" },
		}

		local InvHeader = Instance.new("Frame", PageFarm)
		InvHeader.Size = UDim2.new(1, 0, 0, 28)
		InvHeader.BackgroundColor3 = T.TopBar
		Instance.new("UICorner", InvHeader).CornerRadius = UDim.new(0, 8)
		local invHdrLbl = Instance.new("TextLabel", InvHeader)
		invHdrLbl.Size=UDim2.new(1,-10,1,0)
		invHdrLbl.Position=UDim2.new(0,8,0,0)
		invHdrLbl.BackgroundTransparency=1
		invHdrLbl.Text="INGREDIENTS"
		invHdrLbl.TextColor3=T.Text
		invHdrLbl.Font=Enum.Font.GothamBlack
		invHdrLbl.TextSize=16
		invHdrLbl.TextXAlignment=Enum.TextXAlignment.Left

		local InvCard = Instance.new("Frame", PageFarm)
		InvCard.Size = UDim2.new(1, 0, 0, #INGREDIENTS * 24 + 12)
		InvCard.BackgroundColor3 = T.Card
		Instance.new("UICorner", InvCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", InvCard).Color = T.Stroke

		local invLabels = {}
		for i, item in ipairs(INGREDIENTS) do
			local row = Instance.new("Frame", InvCard)
			row.Size = UDim2.new(1, -12, 0, 20)
			row.Position = UDim2.new(0, 6, 0, (i-1)*24 + 5)
			row.BackgroundTransparency = 1

			if i > 1 then
				local sep = Instance.new("Frame", row)
				sep.Size=UDim2.new(1,0,0,1)
				sep.BackgroundColor3=T.Stroke
				sep.BorderSizePixel=0
			end

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size=UDim2.new(0.7,0,1,0)
			nameLbl.BackgroundTransparency=1
			nameLbl.Text=item.label
			nameLbl.TextColor3=T.TextDim
			nameLbl.Font=Enum.Font.GothamBlack
			nameLbl.TextSize=15
			nameLbl.TextXAlignment=Enum.TextXAlignment.Left

			local countLbl = Instance.new("TextLabel", row)
			countLbl.Size=UDim2.new(0.3,0,1,0)
			countLbl.Position=UDim2.new(0.7,0,0,0)
			countLbl.BackgroundTransparency=1
			countLbl.Text="0"
			countLbl.TextColor3=T.Accent
			countLbl.Font=Enum.Font.GothamBlack
			countLbl.TextSize=15
			countLbl.TextXAlignment=Enum.TextXAlignment.Right

			invLabels[item.key] = countLbl
		end

		local RefreshBtn = Instance.new("TextButton", PageFarm)
		RefreshBtn.Size=UDim2.new(1,0,0,30)
		RefreshBtn.BackgroundColor3=T.Card
		RefreshBtn.Text="↻ Refresh Inventory"
		RefreshBtn.TextColor3=T.Accent
		RefreshBtn.Font=Enum.Font.Gotham
		RefreshBtn.TextSize=13
		RefreshBtn.AutoButtonColor=false
		Instance.new("UICorner", RefreshBtn).CornerRadius=UDim.new(0,8)
		Instance.new("UIStroke", RefreshBtn).Color=T.Stroke

		local function refreshInventory()
			local p = game.Players.LocalPlayer
			local counts = {}
			for _, item in ipairs(INGREDIENTS) do counts[item.key] = 0 end
			local function scanContainer(container)
				if not container then return end
				pcall(function()
					for _, v in pairs(container:GetChildren()) do
						if v:IsA("Tool") then
							local lower = string.lower(v.Name)
							for _, item in ipairs(INGREDIENTS) do
								if lower:find(item.key) then counts[item.key]=counts[item.key]+1 end
							end
						end
					end
				end)
			end
			scanContainer(p.Backpack)
			if p.Character then scanContainer(p.Character) end
			for key, lbl in pairs(invLabels) do
				local n = counts[key] or 0
				lbl.Text = tostring(n)
				lbl.TextColor3 = n>0 and T.AccOn or T.TextDim
			end
			RefreshBtn.Text="Updated"
			task.delay(1.5, function() if Running then RefreshBtn.Text="Refresh Counts" end end)
		end

		RefreshBtn.MouseButton1Click:Connect(refreshInventory)
		task.spawn(function()
			while Running do task.wait(3)
				if PageFarm.Visible then refreshInventory() end end
		end)
		task.delay(1, refreshInventory)

		local abHdr = Instance.new("TextLabel", PageFarm)
		abHdr.Size = UDim2.new(1, 0, 0, 20)
		abHdr.BackgroundTransparency = 1
		abHdr.Text = "AUTO BUY — Lamont Bell"
		abHdr.TextColor3 = T.TextDim
		abHdr.Font = Enum.Font.GothamBlack
		abHdr.TextSize = 11

		-- ── COST PREVIEW CARD ────────────────────────────────
		local ITEM_PRICE_DISP = {
			["Water"] = 20,
			["Sugar Block Bag"] = 100,
			["Gelatin"] = 70,
		}

		local costCard = Instance.new("Frame", PageFarm)
		costCard.Size = UDim2.new(1, 0, 0, 70)
		costCard.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		Instance.new("UICorner", costCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", costCard).Color = Color3.fromRGB(35, 35, 35)

		local costHdrLbl = Instance.new("TextLabel", costCard)
		costHdrLbl.Size = UDim2.new(1, -12, 0, 20)
		costHdrLbl.Position = UDim2.new(0, 8, 0, 2)
		costHdrLbl.BackgroundTransparency = 1
		costHdrLbl.Text = "Estimasi Harga Beli"
		costHdrLbl.TextColor3 = T.TextDim
		costHdrLbl.Font = Enum.Font.GothamBlack
		costHdrLbl.TextSize = 11
		costHdrLbl.TextXAlignment = Enum.TextXAlignment.Left

		local COST_DEFS = {
			{ key="PACK", label="PACK", items={"Water","Sugar Block Bag","Gelatin"} },
			{ key="WATER", label="Water", items={"Water"} },
			{ key="SUGAR", label="Sugar", items={"Sugar Block Bag"} },
			{ key="GELATIN", label="Gelatin", items={"Gelatin"} },
		}
		local costValLabels = {}

		-- 2×2 grid layout
		local GRID_POS = {
			{xs=0, xo=8, yo=24},
			{xs=0.5, xo=4, yo=24},
			{xs=0, xo=8, yo=46},
			{xs=0.5, xo=4, yo=46},
		}
		for idx, def in ipairs(COST_DEFS) do
			local g = GRID_POS[idx]
			local rowF = Instance.new("Frame", costCard)
			rowF.Size = UDim2.new(0.5, -12, 0, 18)
			rowF.Position = UDim2.new(g.xs, g.xo, 0, g.yo)
			rowF.BackgroundTransparency = 1

			local namL = Instance.new("TextLabel", rowF)
			namL.Size = UDim2.new(0.6, 0, 1, 0)
			namL.BackgroundTransparency = 1
			namL.Text = def.label
			namL.TextColor3 = T.TextDim
			namL.Font = Enum.Font.Gotham
			namL.TextSize = 11
			namL.TextXAlignment = Enum.TextXAlignment.Left

			local valL = Instance.new("TextLabel", rowF)
			valL.Size = UDim2.new(0.4, 0, 1, 0)
			valL.Position = UDim2.new(0.6, 0, 0, 0)
			valL.BackgroundTransparency = 1
			valL.Text = "$0"
			valL.TextColor3 = T.AccOn
			valL.Font = Enum.Font.GothamBlack
			valL.TextSize = 11
			valL.TextXAlignment = Enum.TextXAlignment.Right

			costValLabels[def.key] = { lbl = valL, items = def.items }
		end

		local function updateCostPreview(qty)
			local money = abGetMoney and abGetMoney() or nil
			for key, data in pairs(costValLabels) do
				local total = 0
				for _, itemName in ipairs(data.items) do
					total += (ITEM_PRICE_DISP[itemName] or 0) * qty
				end
				data.lbl.Text = "$" .. tostring(total)
				if money and total > 0 then
					data.lbl.TextColor3 = money >= total
					and Color3.fromRGB(0, 220, 100)
					or Color3.fromRGB(255, 80, 80)
				else
					data.lbl.TextColor3 = T.AccOn
				end
			end
		end

		AddSlider(PageFarm, "Jumlah Beli", 1, 100, AutoBuySettings.Amount, "x", function(v)
			AutoBuySettings.Amount = v
			updateCostPreview(v)
		end)
		task.delay(0.5, function() updateCostPreview(AutoBuySettings.Amount) end)

		local abStatusLbl = Instance.new("TextLabel", PageFarm)
		abStatusLbl.Size = UDim2.new(1, 0, 0, 20)
		abStatusLbl.BackgroundTransparency = 1
		abStatusLbl.Text = ""
		abStatusLbl.TextColor3 = T.Accent
		abStatusLbl.Font = Enum.Font.GothamBlack
		abStatusLbl.TextSize = 15
		_G.HNDRIXX_AUTOBUY_STATUSLBL = abStatusLbl

		-- ================================================================
		-- AUTO BUY BUTTONS — WORKING via StorePurchase RemoteEvent
		-- + Money Detector + Cancel
		-- ================================================================
		local _RS2 = game:GetService("ReplicatedStorage")

		local abBuyDefs = {
			{label="Buy PACK", mode="PACK", items={"Water","Sugar Block Bag","Gelatin"}},
			{label="Buy WATER", mode="WATER", items={"Water"}},
			{label="Buy SUGAR", mode="SUGAR", items={"Sugar Block Bag"}},
			{label="Buy GELATIN", mode="GELATIN", items={"Gelatin"}},
		}

		-- ── MONEY DETECTOR ──────────────────────────────────
		-- Coba cari uang di leaderstats / CurrencyValues / dsb
		local MONEY_KEYS = {"Money","Cash","Coins","Dollars","Credits","Currency","Gold","Bucks","Pat"}
		local function abGetMoney()
			local lp = game.Players.LocalPlayer
			local ls = lp:FindFirstChild("leaderstats")
			if ls then
				for _, key in ipairs(MONEY_KEYS) do
					local v = ls:FindFirstChild(key)
					if v and (v:IsA("IntValue") or v:IsA("NumberValue")) then
						return v.Value, key
					end
				end
				-- fallback: ambil value pertama apapun namanya
				for _, v in pairs(ls:GetChildren()) do
					if v:IsA("IntValue") or v:IsA("NumberValue") then
						return v.Value, v.Name
					end
				end
			end
			return nil, nil
		end

		local function abEstimateCost(itemNames, qty)
			local total = 0
			for _, name in ipairs(itemNames) do
				total += (ITEM_PRICE_DISP[name] or 0) * qty
			end
			return total
		end

		-- ── MONEY DISPLAY (mini bar di bawah slider) ─────────
		local moneyBar = Instance.new("Frame", PageFarm)
		moneyBar.Size = UDim2.new(1, 0, 0, 26)
		moneyBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		moneyBar.LayoutOrder = 0
		Instance.new("UICorner", moneyBar).CornerRadius = UDim.new(0, 6)
		Instance.new("UIStroke", moneyBar).Color = Color3.fromRGB(35, 35, 35)

		local moneyIcon = Instance.new("TextLabel", moneyBar)
		moneyIcon.Size = UDim2.new(0, 22, 1, 0)
		moneyIcon.Position = UDim2.new(0, 4, 0, 0)
		moneyIcon.BackgroundTransparency = 1
		moneyIcon.Text = ""
		moneyIcon.Font = Enum.Font.Gotham
		moneyIcon.TextSize = 13

		local moneyKeyLbl = Instance.new("TextLabel", moneyBar)
		moneyKeyLbl.Size = UDim2.new(0, 80, 1, 0)
		moneyKeyLbl.Position = UDim2.new(0, 28, 0, 0)
		moneyKeyLbl.BackgroundTransparency = 1
		moneyKeyLbl.Text = "Balance:"
		moneyKeyLbl.TextColor3 = T.TextDim
		moneyKeyLbl.Font = Enum.Font.GothamBlack
		moneyKeyLbl.TextSize = 11
		moneyKeyLbl.TextXAlignment = Enum.TextXAlignment.Left

		local moneyValLbl = Instance.new("TextLabel", moneyBar)
		moneyValLbl.Size = UDim2.new(1, -110, 1, 0)
		moneyValLbl.Position = UDim2.new(0, 108, 0, 0)
		moneyValLbl.BackgroundTransparency = 1
		moneyValLbl.Text = "—"
		moneyValLbl.TextColor3 = T.AccOn
		moneyValLbl.Font = Enum.Font.GothamBlack
		moneyValLbl.TextSize = 12
		moneyValLbl.TextXAlignment = Enum.TextXAlignment.Left

		local moneyRefBtn = Instance.new("TextButton", moneyBar)
		moneyRefBtn.Size = UDim2.new(0, 42, 0, 18)
		moneyRefBtn.AnchorPoint = Vector2.new(1, 0.5)
		moneyRefBtn.Position = UDim2.new(1, -4, 0.5, 0)
		moneyRefBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		moneyRefBtn.Text = "↻ Cek"
		moneyRefBtn.TextColor3 = T.TextDim
		moneyRefBtn.Font = Enum.Font.GothamBlack
		moneyRefBtn.TextSize = 10
		moneyRefBtn.AutoButtonColor = false
		Instance.new("UICorner", moneyRefBtn).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", moneyRefBtn).Color = Color3.fromRGB(40, 40, 40)

		local function abRefreshMoney()
			local val, key = abGetMoney()
			if val ~= nil then
				moneyKeyLbl.Text = (key or "Balance") .. ":"
				moneyValLbl.Text = tostring(val)
				moneyValLbl.TextColor3 = val > 0 and T.AccOn or Color3.fromRGB(255, 80, 80)
			else
				moneyValLbl.Text = "N/A"
				moneyValLbl.TextColor3 = T.TextDim
			end
			-- refresh warna cost card juga tiap uang berubah
			updateCostPreview(AutoBuySettings.Amount)
		end

		moneyRefBtn.MouseButton1Click:Connect(abRefreshMoney)
		task.spawn(function()
			while Running do
				if PageFarm.Visible then abRefreshMoney() end
				task.wait(2)
			end
		end)
		task.delay(1.2, abRefreshMoney)

		-- ── CANCEL BUTTON (muncul saat busy) ─────────────────
		local abCancelBtn = Instance.new("TextButton", PageFarm)
		abCancelBtn.Size = UDim2.new(1, 0, 0, 30)
		abCancelBtn.BackgroundColor3 = Color3.fromRGB(38, 10, 10)
		abCancelBtn.Text = "CANCEL BUY"
		abCancelBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
		abCancelBtn.Font = Enum.Font.GothamBlack
		abCancelBtn.TextSize = 13
		abCancelBtn.AutoButtonColor = false
		abCancelBtn.Visible = false
		Instance.new("UICorner", abCancelBtn).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", abCancelBtn).Color = Color3.fromRGB(90, 20, 20)

		-- ── CORE LOGIC ────────────────────────────────────────
		local function abCountItem(name)
			local n = 0
			local lp = game.Players.LocalPlayer
			for _, t in ipairs(lp.Backpack:GetChildren()) do
				if t.Name == name then n += 1 end
			end
			local ch = lp.Character
			if ch then
				for _, t in ipairs(ch:GetChildren()) do
					if t:IsA("Tool") and t.Name == name then n += 1 end
				end
			end
			return n
		end

		local abBusy = false
		local abCancelled = false

		local function abSetStatus(txt, col)
			abStatusLbl.Text = txt
			abStatusLbl.TextColor3 = col or T.Accent
		end

		local function abFinish(allBuyLabels)
			abBusy = false
			abCancelled = false
			abCancelBtn.Visible = false
			for _, pair in ipairs(allBuyLabels) do
				pair.lbl.Text = "BUY"
				pair.pill.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
				pair.name.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
			abRefreshMoney()
		end

		-- Referensi label semua tombol buat reset setelah selesai/cancel
		local allBuyLabelRefs = {}

		local function doRemoteBuy(itemNames, qty)
			task.spawn(function()
				local remEvts = _RS2:FindFirstChild("RemoteEvents")
				local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
				if not spRE then
					abSetStatus("RemoteEvent tidak ada!", Color3.fromRGB(255, 80, 80))
					task.wait(3)
					abStatusLbl.Text = ""
					abFinish(allBuyLabelRefs)
					return
				end

				-- ── CEK UANG SEBELUM MULAI ────────────────────
				local money, moneyKey = abGetMoney()
				if money ~= nil then
					local estimasi = abEstimateCost(itemNames, qty)
					if estimasi > 0 and money < estimasi then
						abSetStatus(
						string.format("Uang kurang! Butuh ~%d, punya %d", estimasi, money),
						Color3.fromRGB(255, 80, 80)
						)
						task.wait(3.5)
						abStatusLbl.Text = ""
						abFinish(allBuyLabelRefs)
						return
					end
				end

				local totalBought = 0

				for _, itemName in ipairs(itemNames) do
					if abCancelled then break end

					local moneyNow = abGetMoney()
					if moneyNow ~= nil and moneyNow <= 0 then
						abSetStatus("Uang habis! Beli dihentikan.", Color3.fromRGB(255, 80, 80))
						task.wait(2.5)
						abStatusLbl.Text = ""
						abFinish(allBuyLabelRefs)
						return
					end

					local before = abCountItem(itemName)
					abSetStatus("Beli " .. itemName .. "×" .. qty .. "...", Color3.fromRGB(100, 180, 255))

					for i = 1, qty do
						if abCancelled then break end
						-- Cek uang per-iterasi
						local mNow = abGetMoney()
						if mNow ~= nil and mNow <= 0 then
							abSetStatus("Uang habis di tengah jalan!", Color3.fromRGB(255, 80, 80))
							task.wait(2.5)
							abStatusLbl.Text = ""
							abFinish(allBuyLabelRefs)
							return
						end
						pcall(function() spRE:FireServer(itemName, 1) end)
						task.wait(0.4)
					end

					if abCancelled then break end

					-- tunggu item masuk, timeout 8s
					local elapsed = 0
					local gained = 0
					repeat
						if abCancelled then break end
						task.wait(0.2)
						elapsed += 0.2
						gained = abCountItem(itemName) - before
					until gained >= qty or elapsed > 8

					if abCancelled then break end

					-- retry sisa yang kurang
					local missing = qty - gained
					if missing > 0 then
						abSetStatus("Retry " .. missing .. "× " .. itemName, Color3.fromRGB(255, 160, 40))
						for i = 1, missing do
							if abCancelled then break end
							pcall(function() spRE:FireServer(itemName, 1) end)
							task.wait(0.5)
						end
						elapsed = 0
						repeat
							if abCancelled then break end
							task.wait(0.2)
							elapsed += 0.2
							gained = abCountItem(itemName) - before
						until gained >= qty or elapsed > 5
					end

					if abCancelled then break end

					totalBought += gained
					abSetStatus("" .. itemName .. "×" .. gained, Color3.fromRGB(0, 220, 100))
					task.wait(0.3)
				end

				if abCancelled then
					abSetStatus("Dibatalkan! " .. totalBought .. "item sudah dibeli.", Color3.fromRGB(255, 160, 40))
				else
					abSetStatus("Selesai! " .. totalBought .. "item dibeli.", Color3.fromRGB(0, 220, 100))
				end

				task.delay(3.5, function()
					if abStatusLbl and abStatusLbl.Parent then abStatusLbl.Text = "" end
				end)
				abFinish(allBuyLabelRefs)
			end)
		end

		abCancelBtn.MouseButton1Click:Connect(function()
			if not abBusy then return end
			abCancelled = true
			abCancelBtn.Text = "Cancelling..."
			abCancelBtn.TextColor3 = Color3.fromRGB(150, 40, 40)
		end)

		for _, def in ipairs(abBuyDefs) do
			local btnWrap = Instance.new("TextButton", PageFarm)
			btnWrap.Size = UDim2.new(1, 0, 0, 34)
			btnWrap.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
			btnWrap.Text = ""
			btnWrap.AutoButtonColor = false
			Instance.new("UICorner", btnWrap).CornerRadius = UDim.new(0, 8)
			local bws = Instance.new("UIStroke", btnWrap)
			bws.Color = Color3.fromRGB(38, 38, 38)
			bws.Thickness = 1

			local nameL = Instance.new("TextLabel", btnWrap)
			nameL.Size = UDim2.new(1, -80, 1, 0)
			nameL.Position = UDim2.new(0, 10, 0, 0)
			nameL.BackgroundTransparency = 1
			nameL.Text = def.label
			nameL.TextColor3 = Color3.fromRGB(200, 200, 200)
			nameL.Font = Enum.Font.GothamBlack
			nameL.TextSize = 13
			nameL.TextXAlignment = Enum.TextXAlignment.Left

			local buyPill = Instance.new("Frame", btnWrap)
			buyPill.Size = UDim2.new(0, 60, 0, 22)
			buyPill.AnchorPoint = Vector2.new(1, 0.5)
			buyPill.Position = UDim2.new(1, -6, 0.5, 0)
			buyPill.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Instance.new("UICorner", buyPill).CornerRadius = UDim.new(1, 0)
			Instance.new("UIStroke", buyPill).Color = Color3.fromRGB(60, 60, 60)
			local buyLbl = Instance.new("TextLabel", buyPill)
			buyLbl.Size = UDim2.new(1, 0, 1, 0)
			buyLbl.BackgroundTransparency = 1
			buyLbl.Text = "BUY"
			buyLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
			buyLbl.Font = Enum.Font.GothamBlack
			buyLbl.TextSize = 11

			-- simpan referensi buat reset
			table.insert(allBuyLabelRefs, {lbl=buyLbl, pill=buyPill, name=nameL})

			btnWrap.MouseButton1Click:Connect(function()
				if abBusy then return end
				abBusy = true
				abCancelled = false
				buyLbl.Text = ""
				buyPill.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				nameL.TextColor3 = T.TextDim
				abCancelBtn.Text = "CANCEL BUY"
				abCancelBtn.TextColor3 = Color3.fromRGB(220, 60, 60)
				abCancelBtn.Visible = true

				local qty = math.clamp(AutoBuySettings.Amount, 1, 100)
				doRemoteBuy(def.items, qty)
			end)
		end

		-- ================================================================
		-- AUTO SELL MARSHMALLOW
		-- ================================================================
		local sellHdr = Instance.new("TextLabel", PageFarm)
		sellHdr.Size = UDim2.new(1, 0, 0, 20)
		sellHdr.BackgroundTransparency = 1
		sellHdr.Text = "AUTO SELL — Marshmallow"
		sellHdr.TextColor3 = T.TextDim
		sellHdr.Font = Enum.Font.GothamBlack
		sellHdr.TextSize = 11

		local sellStatusLbl = Instance.new("TextLabel", PageFarm)
		sellStatusLbl.Size = UDim2.new(1, 0, 0, 18)
		sellStatusLbl.BackgroundTransparency = 1
		sellStatusLbl.Text = ""
		sellStatusLbl.TextColor3 = T.Accent
		sellStatusLbl.Font = Enum.Font.GothamBlack
		sellStatusLbl.TextSize = 15

		local sellBtn = Instance.new("TextButton", PageFarm)
		sellBtn.Size = UDim2.new(1, 0, 0, 32)
		sellBtn.BackgroundColor3 = T.Card
		sellBtn.Text = "Sell Marshmallow"
		sellBtn.TextColor3 = T.Text
		sellBtn.Font = Enum.Font.Gotham
		sellBtn.TextSize = 13
		sellBtn.AutoButtonColor = false
		Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", sellBtn).Color = T.Stroke

		local isSelling = false

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
					if actionText:find("interact") and dist < bestDist then
						bestDist = dist
						best = obj
					end
				end
			end
			return best
		end

		sellBtn.MouseButton1Click:Connect(function()
			if isSelling then return end
			isSelling = true
			sellBtn.Text = "Selling..."
			sellBtn.TextColor3 = T.TextDim

			task.spawn(function()
				local function setStatus(txt, col)
					sellStatusLbl.Text = txt
					sellStatusLbl.TextColor3 = col or T.Accent
				end

				local function getMarshmallows()
					local list = {}
					if plr.Backpack then
						for _, v in pairs(plr.Backpack:GetChildren()) do
							if v:IsA("Tool") and string.lower(v.Name):find("marshmallow") then
								table.insert(list, v)
							end
						end
					end
					if plr.Character then
						for _, v in pairs(plr.Character:GetChildren()) do
							if v:IsA("Tool") and string.lower(v.Name):find("marshmallow") then
								table.insert(list, v)
							end
						end
					end
					return list
				end

				local marshmallows = getMarshmallows()
				if #marshmallows == 0 then
					setStatus("Ga ada Marshmallow!", Color3.fromRGB(255,80,80))
					task.wait(2)
					sellStatusLbl.Text = ""
					isSelling = false
					sellBtn.Text = "Sell Marshmallow"
					sellBtn.TextColor3 = T.Text
					return
				end

				local total = #marshmallows
				local sold = 0

				-- Cari prompt SEKALI sebelum loop — ini yang bikin lag kalau dicari tiap iterasi
				local sellPrompt = findNearestPrompt()
				if not sellPrompt then
					setStatus("Prompt tidak ditemukan!", Color3.fromRGB(255,80,80))
					task.wait(2)
					sellStatusLbl.Text = ""
					isSelling = false
					sellBtn.Text = "Sell Marshmallow"
					sellBtn.TextColor3 = T.Text
					return
				end
				-- Override MaxActivationDistance sekali saja
				pcall(function()
					sellPrompt.MaxActivationDistance = 9999
					sellPrompt.RequiresLineOfSight = false
				end)

				for _, marsh in ipairs(marshmallows) do
					if not isSelling then break end
					local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					if not hum then break end

					pcall(function() hum:EquipTool(marsh) end)
					task.wait(0.08) -- dikurangi dari 0.25

					pcall(function() fireproximityprompt(sellPrompt) end)
					task.wait(0.18) -- dikurangi dari 0.5+random, cukup tunggu animasi sell

					sold = sold + 1
					setStatus(string.format("Selling %d/%d", sold, total), Color3.fromRGB(255,210,120))
				end

				-- Restore prompt setelah selesai
				pcall(function()
					if sellPrompt and sellPrompt.Parent then
						sellPrompt.MaxActivationDistance = 10
						sellPrompt.RequiresLineOfSight = true
					end
				end)

				setStatus(string.format("Done! %d terjual", sold), Color3.fromRGB(0,220,120))
				task.wait(3)
				sellStatusLbl.Text = ""
				isSelling = false
				sellBtn.Text = "Sell Marshmallow"
				sellBtn.TextColor3 = T.Text
			end)
		end)

		-- ================================================================
		-- TP MARSHMALLOW — shortcut di FARM tab
		-- ================================================================
		local marshHdr = Instance.new("TextLabel", PageFarm)
		marshHdr.Size = UDim2.new(1, 0, 0, 20)
		marshHdr.BackgroundTransparency = 1
		marshHdr.Text = "SHORTCUT TP"
		marshHdr.TextColor3 = T.TextDim
		marshHdr.Font = Enum.Font.GothamBlack
		marshHdr.TextSize = 11

		local marshTPCard = Instance.new("Frame", PageFarm)
		marshTPCard.Size = UDim2.new(1, 0, 0, 40)
		marshTPCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
		Instance.new("UICorner", marshTPCard).CornerRadius = UDim.new(0, 8)
		local mcs = Instance.new("UIStroke", marshTPCard)
		mcs.Color = Color3.fromRGB(40, 80, 40)
		mcs.Thickness = 1

		local MARSH_X, MARSH_Y, MARSH_Z = 510.38, 3.59, 603.50

		local marshIcon = Instance.new("TextLabel", marshTPCard)
		marshIcon.Size = UDim2.new(0, 32, 1, 0)
		marshIcon.Position = UDim2.new(0, 6, 0, 0)
		marshIcon.BackgroundTransparency = 1
		marshIcon.Text = ""
		marshIcon.Font = Enum.Font.GothamBlack
		marshIcon.TextSize = 18

		local marshNameLbl = Instance.new("TextLabel", marshTPCard)
		marshNameLbl.Size = UDim2.new(1, -162, 0, 18)
		marshNameLbl.Position = UDim2.new(0, 40, 0, 4)
		marshNameLbl.BackgroundTransparency = 1
		marshNameLbl.Text = "Buy Marshmallow"
		marshNameLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
		marshNameLbl.Font = Enum.Font.GothamBlack
		marshNameLbl.TextSize = 14
		marshNameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local marshSubLbl = Instance.new("TextLabel", marshTPCard)
		marshSubLbl.Size = UDim2.new(1, -162, 0, 14)
		marshSubLbl.Position = UDim2.new(0, 40, 0, 23)
		marshSubLbl.BackgroundTransparency = 1
		marshSubLbl.Text = "Normal TP · Lamont Bell Area"
		marshSubLbl.TextColor3 = Color3.fromRGB(50, 90, 50)
		marshSubLbl.Font = Enum.Font.Gotham
		marshSubLbl.TextSize = 11
		marshSubLbl.TextXAlignment = Enum.TextXAlignment.Left

		-- Tombol VEH
		local marshVehBtn = Instance.new("TextButton", marshTPCard)
		marshVehBtn.Size = UDim2.new(0, 44, 0, 24)
		marshVehBtn.AnchorPoint = Vector2.new(1, 0.5)
		marshVehBtn.Position = UDim2.new(1, -126, 0.5, 0)
		marshVehBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		marshVehBtn.Text = "VEH"
		marshVehBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		marshVehBtn.Font = Enum.Font.GothamBlack
		marshVehBtn.TextSize = 12
		marshVehBtn.AutoButtonColor = false
		Instance.new("UICorner", marshVehBtn).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", marshVehBtn).Color = Color3.fromRGB(55, 55, 55)

		local marshKillBtn = Instance.new("TextButton", marshTPCard)
		marshKillBtn.Size = UDim2.new(0, 64, 0, 24)
		marshKillBtn.AnchorPoint = Vector2.new(1, 0.5)
		marshKillBtn.Position = UDim2.new(1, -70, 0.5, 0)
		marshKillBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		marshKillBtn.Text = "KILL TP"
		marshKillBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		marshKillBtn.Font = Enum.Font.GothamBlack
		marshKillBtn.TextSize = 12
		marshKillBtn.AutoButtonColor = false
		Instance.new("UICorner", marshKillBtn).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", marshKillBtn).Color = Color3.fromRGB(120, 40, 40)



		marshVehBtn.MouseButton1Click:Connect(function()
			local ok = doVehicleTP(CFrame.new(MARSH_X, MARSH_Y, MARSH_Z))
			if ok then
				marshSubLbl.Text = "Vehicle TP done!"
			else
				marshSubLbl.Text = "Tidak di kendaraan!"
			end
			task.delay(2, function() marshSubLbl.Text = "Normal TP · Lamont Bell Area" end)
		end)

		marshKillBtn.MouseButton1Click:Connect(function()
			if tpBusy then return end
			marshKillBtn.Text = "..."
			marshSubLbl.Text = "Respawning..."
			task.spawn(function()
				tpBusy = true
				-- ── BONUS TELEPORT METHOD ─────────────────────────────────
				-- open SEKALI — nutup sampai beneran nyampe
				openBonusTPOverlay("Buy Marshmallow")
				local selfCh = plr.Character
				local selfHrp = selfCh and selfCh:FindFirstChild("HumanoidRootPart")
				if not selfHrp then
					tpBusy=false
					closeBonusTPOverlay()
					marshKillBtn.Text = "KILL TP"
					marshSubLbl.Text = "Normal TP · Lamont Bell Area"
					return
				end
				selfHrp.CFrame = CFrame.new(RESPAWN_WARP)
				-- tunggu respawn — overlay TIDAK disentuh, tetap nutup
				local newChar = plr.CharacterAdded:Wait()
				local hrp = newChar:WaitForChild("HumanoidRootPart", 8)
				if hrp then
					-- update label aja, NO fade in/out
					updateBonusTPLabel("Buy Marshmallow")
					task.wait(0.6)
					hrp.CFrame = CFrame.new(MARSH_X, MARSH_Y + 3, MARSH_Z)
					task.wait(0.2)
				end
				-- close SEKALI — baru dibuka setelah CFrame di-set
				closeBonusTPOverlay()
				-- ─────────────────────────────────────────────────────────
				marshKillBtn.Text = "KILL TP"
				marshSubLbl.Text = "Normal TP · Lamont Bell Area"
				tpBusy = false
			end)
		end)



		-- ================================================================
		-- FULLY AUTO FARM
		-- Flow: kill TP → buy pack → tpToPos ke apart → cook qty kali
		-- → tpToPos ke marshmallow → sell all → loop
		-- ================================================================

		local AF = {
			active = false,
			paused = false,
			packQty = 10,
			phase = "", -- teks status phase sekarang
		}

		-- ── UI HELPERS ────────────────────────────────────────────────
		local afDivider = Instance.new("Frame", PageFarm)
		afDivider.Size = UDim2.new(1, 0, 0, 1)
		afDivider.BackgroundColor3 = Color3.fromRGB(30,30,30)
		afDivider.BorderSizePixel = 0

		local afHeader = Instance.new("TextLabel", PageFarm)
		afHeader.Size = UDim2.new(1, 0, 0, 20)
		afHeader.BackgroundTransparency = 1
		afHeader.Text = "FULLY AUTO FARM — Loop Non-Stop"
		afHeader.TextColor3 = Color3.fromRGB(200, 200, 200)
		afHeader.Font = Enum.Font.GothamBlack
		afHeader.TextSize = 11

		-- slider jumlah pack per siklus
		local afPackQtyValue = AF.packQty
		local afSliderCard = Instance.new("Frame", PageFarm)
		afSliderCard.Size = UDim2.new(1, 0, 0, 50)
		afSliderCard.BackgroundColor3 = T.Card
		Instance.new("UICorner", afSliderCard).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", afSliderCard).Color = T.Stroke

		local afSliderLbl = Instance.new("TextLabel", afSliderCard)
		afSliderLbl.Size = UDim2.new(1, -12, 0, 18)
		afSliderLbl.Position = UDim2.new(0, 10, 0, 6)
		afSliderLbl.BackgroundTransparency = 1
		afSliderLbl.TextXAlignment = Enum.TextXAlignment.Left
		afSliderLbl.Font = Enum.Font.Gotham
		afSliderLbl.TextSize = 13
		afSliderLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
		afSliderLbl.Text = "Jumlah Pack per Siklus: " .. afPackQtyValue .. "x"

		local afTrack = Instance.new("Frame", afSliderCard)
		afTrack.Size = UDim2.new(1, -20, 0, 4)
		afTrack.Position = UDim2.new(0, 10, 0, 34)
		afTrack.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
		Instance.new("UICorner", afTrack).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", afTrack).Color = T.Stroke

		local afFill = Instance.new("Frame", afTrack)
		afFill.Size = UDim2.new((afPackQtyValue-1)/99, 0, 1, 0)
		afFill.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
		Instance.new("UICorner", afFill).CornerRadius = UDim.new(1, 0)

		local afKnob = Instance.new("Frame", afTrack)
		afKnob.Size = UDim2.new(0, 14, 0, 14)
		afKnob.Position = UDim2.new((afPackQtyValue-1)/99, -7, 0.5, -7)
		afKnob.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
		Instance.new("UICorner", afKnob).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", afKnob).Color = T.Stroke

		do
			local dragging = false
			local function afUpdateSlider(inputPos)
				local rel = math.clamp((inputPos.X - afTrack.AbsolutePosition.X) / afTrack.AbsoluteSize.X, 0, 1)
				afPackQtyValue = math.floor(1 + rel * 99)
				AF.packQty = afPackQtyValue
				afFill.Size = UDim2.new(rel, 0, 1, 0)
				afKnob.Position = UDim2.new(rel, -6, 0.5, -6)
				afSliderLbl.Text = "Jumlah Pack per Siklus: " .. afPackQtyValue .. "x"
			end
			afTrack.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					afUpdateSlider(i.Position)
				end
			end)
			UIS.InputChanged:Connect(function(i)
				if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
				or i.UserInputType == Enum.UserInputType.Touch) then afUpdateSlider(i.Position) end
			end)
			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1
				or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
			end)
		end

		-- label hint "pilih apartment dulu"
		local afHintLbl = Instance.new("TextLabel", PageFarm)
		afHintLbl.Size = UDim2.new(1, 0, 0, 16)
		afHintLbl.BackgroundTransparency = 1
		afHintLbl.Text = "Pilih apartment dulu sebelum ON"
		afHintLbl.TextColor3 = Color3.fromRGB(130, 130, 130)
		afHintLbl.Font = Enum.Font.Gotham
		afHintLbl.TextSize = 12

		-- status label (phase sekarang)
		local afStatusLbl = Instance.new("TextLabel", PageFarm)
		afStatusLbl.Size = UDim2.new(1, 0, 0, 18)
		afStatusLbl.BackgroundTransparency = 1
		afStatusLbl.Text = ""
		afStatusLbl.TextColor3 = T.Accent
		afStatusLbl.Font = Enum.Font.GothamBlack
		afStatusLbl.TextSize = 13

		local function afSetStatus(txt, col)
			afStatusLbl.Text = txt
			afStatusLbl.TextColor3 = col or T.Accent
		end

		-- main toggle bar
		local AfBar = Instance.new("TextButton", PageFarm)
		AfBar.Size = UDim2.new(1, 0, 0, 40)
		AfBar.BackgroundColor3 = T.Card
		AfBar.Text = ""
		AfBar.AutoButtonColor = false
		Instance.new("UICorner", AfBar).CornerRadius = UDim.new(0, 8)
		local afBarStr = Instance.new("UIStroke", AfBar)
		afBarStr.Color = T.Stroke
		afBarStr.Thickness = 1

		local afDot = Instance.new("Frame", AfBar)
		afDot.Size = UDim2.new(0, 5, 0, 5)
		afDot.Position = UDim2.new(0, 12, 0.5, -2.5)
		afDot.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		Instance.new("UICorner", afDot).CornerRadius = UDim.new(1, 0)

		local afNameLbl = Instance.new("TextLabel", AfBar)
		afNameLbl.Size = UDim2.new(1, -76, 1, 0)
		afNameLbl.Position = UDim2.new(0, 24, 0, 0)
		afNameLbl.BackgroundTransparency = 1
		afNameLbl.Text = "Fully Auto Farm"
		afNameLbl.TextColor3 = T.TextDim
		afNameLbl.Font = Enum.Font.GothamBlack
		afNameLbl.TextSize = 14
		afNameLbl.TextXAlignment = Enum.TextXAlignment.Left

		local afPill = Instance.new("Frame", AfBar)
		afPill.Size = UDim2.new(0, 46, 0, 22)
		afPill.Position = UDim2.new(1, -52, 0.5, -11)
		afPill.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Instance.new("UICorner", afPill).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", afPill).Color = T.Stroke
		local afPillLbl = Instance.new("TextLabel", afPill)
		afPillLbl.Size = UDim2.new(1, 0, 1, 0)
		afPillLbl.BackgroundTransparency = 1
		afPillLbl.Text = "OFF"
		afPillLbl.TextColor3 = T.TextDim
		afPillLbl.Font = Enum.Font.GothamBlack
		afPillLbl.TextSize = 12

		-- pause button (muncul saat active)
		local afPauseBtn = Instance.new("TextButton", PageFarm)
		afPauseBtn.Size = UDim2.new(1, 0, 0, 32)
		afPauseBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		afPauseBtn.Text = "PAUSE"
		afPauseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		afPauseBtn.Font = Enum.Font.GothamBlack
		afPauseBtn.TextSize = 13
		afPauseBtn.AutoButtonColor = false
		afPauseBtn.Visible = false
		Instance.new("UICorner", afPauseBtn).CornerRadius = UDim.new(0, 8)
		Instance.new("UIStroke", afPauseBtn).Color = Color3.fromRGB(80, 70, 10)

		-- cycle info label
		local afCycleInfoLbl = Instance.new("TextLabel", PageFarm)
		afCycleInfoLbl.Size = UDim2.new(1, 0, 0, 16)
		afCycleInfoLbl.BackgroundTransparency = 1
		afCycleInfoLbl.Text = ""
		afCycleInfoLbl.TextColor3 = T.TextDim
		afCycleInfoLbl.Font = Enum.Font.Gotham
		afCycleInfoLbl.TextSize = 12

		-- ── REFRESH UI ────────────────────────────────────────────────
		local function refreshAfBar()
			local on = AF.active
			AfBar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
			afBarStr.Color = on and Color3.fromRGB(180,140,0) or T.Stroke
			afDot.BackgroundColor3 = on and Color3.fromRGB(255,200,80) or Color3.fromRGB(38,38,38)
			afNameLbl.TextColor3 = on and T.Text or T.TextDim
			afPill.BackgroundColor3 = on and Color3.fromRGB(255,200,80) or Color3.fromRGB(20,20,20)
			afPillLbl.Text = on and "ON" or "OFF"
			afPillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
			local st = afPill:FindFirstChildOfClass("UIStroke")
			if on then if st then st:Destroy() end else if not st then Instance.new("UIStroke",afPill).Color=T.Stroke end end
				afPauseBtn.Visible = on
				afHintLbl.Visible = not on
				-- slider & hint lock
				afTrack.Active = not on
			end
			refreshAfBar()

			-- ── PAUSE BUTTON ──────────────────────────────────────────────
			afPauseBtn.MouseButton1Click:Connect(function()
				if not AF.active then return end
				AF.paused = not AF.paused
				if AF.paused then
					afPauseBtn.Text = "▶ RESUME"
					afPauseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
					afPauseBtn.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
					afPauseBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(30, 80, 30)
					afSetStatus("Paused — tekan RESUME untuk lanjut", Color3.fromRGB(255, 220, 50))
					-- suspend autocook jika sedang cook
					if Flags.AutoCook then
						Flags.AutoCook = false
						refreshCookBar()
					end
				else
					afPauseBtn.Text = "PAUSE"
					afPauseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
					afPauseBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
					afPauseBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(80, 70, 10)
					afSetStatus("▶ Resumed — melanjutkan...", T.Accent)
				end
			end)

			-- ── SELL HELPER (dipake di loop) ──────────────────────────────
			local function afDoSell()
				local sellP = findNearestPrompt()
				if not sellP then task.wait(1.5)
					return end
				pcall(function()
					sellP.MaxActivationDistance = 9999
					sellP.RequiresLineOfSight = false
				end)
				local function getMarsh()
					local list = {}
					if plr.Backpack then
						for _, v in pairs(plr.Backpack:GetChildren()) do
							if v:IsA("Tool") and v.Name:lower():find("marshmallow") then
								table.insert(list, v)
							end
						end
					end
					if plr.Character then
						for _, v in pairs(plr.Character:GetChildren()) do
							if v:IsA("Tool") and v.Name:lower():find("marshmallow") then
								table.insert(list, v)
							end
						end
					end
					return list
				end
				local list = getMarsh()
				local total = #list
				for idx, marsh in ipairs(list) do
					if not AF.active then break end
					while AF.paused and AF.active do task.wait(0.3) end
					local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					if not hum then break end
					pcall(function() hum:EquipTool(marsh) end)
					task.wait(0.08)
					pcall(function() fireproximityprompt(sellP) end)
					task.wait(0.18)
					afSetStatus(("Sell Marshmallow %d/%d"):format(idx, total), Color3.fromRGB(0,220,120))
				end
				pcall(function()
					if sellP and sellP.Parent then
						sellP.MaxActivationDistance = 10
						sellP.RequiresLineOfSight = true
					end
				end)
			end

			-- ── BUY PACK HELPER (sync, awaitable) ─────────────────────────
			local function afDoBuyPack(qty)
				local RS2 = game:GetService("ReplicatedStorage")
				local remEvts = RS2:FindFirstChild("RemoteEvents")
				local spRE = remEvts and remEvts:FindFirstChild("StorePurchase")
				if not spRE then
					afSetStatus("RemoteEvent tidak ada!", Color3.fromRGB(255,80,80))
					task.wait(2)
					return
				end

				local function countItem(name)
					local n = 0
					for _, t in ipairs(plr.Backpack:GetChildren()) do
						if t.Name == name then n += 1 end
					end
					local ch = plr.Character
					if ch then
						for _, t in ipairs(ch:GetChildren()) do
							if t:IsA("Tool") and t.Name == name then n += 1 end
						end
					end
					return n
				end

				local packItems = {"Water", "Sugar Block Bag", "Gelatin"}
				for _, item in ipairs(packItems) do
					if not AF.active then break end

					local before = countItem(item)
					local needed = qty
					afSetStatus(("Beli %s ×%d..."):format(item, needed), Color3.fromRGB(100,180,255))

					-- Fire sejumlah yang dibutuhkan
					for i = 1, needed do
						if not AF.active then break end
						while AF.paused and AF.active do task.wait(0.3) end
						pcall(function() spRE:FireServer(item, 1) end)
						task.wait(0.4)
					end

					-- Tunggu item masuk inventory, timeout 8s
					local elapsed = 0
					local gained = 0
					repeat
						if not AF.active then break end
						task.wait(0.2)
						elapsed += 0.2
						gained = countItem(item) - before
					until gained >= needed or elapsed > 8

					-- Retry sisa yang kurang
					local missing = needed - gained
					if missing > 0 and AF.active then
						afSetStatus(("Retry %s ×%d..."):format(item, missing), Color3.fromRGB(255,160,40))
						for i = 1, missing do
							if not AF.active then break end
							pcall(function() spRE:FireServer(item, 1) end)
							task.wait(0.5)
						end
						elapsed = 0
						repeat
							if not AF.active then break end
							task.wait(0.2)
							elapsed += 0.2
							gained = countItem(item) - before
						until gained >= needed or elapsed > 5
					end

					afSetStatus(("%s ×%d masuk"):format(item, math.min(gained, needed)), Color3.fromRGB(0,220,100))
					task.wait(0.3)
				end
				-- buffer kecil biar semua item settle
				task.wait(1)
			end

			-- ── MAIN LOOP ─────────────────────────────────────────────────
			local function startAFLoop()
				local cycleCount = 0
				local needsKillTP = true -- true hanya di awal & setelah mati
				local AF_died = false -- flag: mati di luar fase Kill TP
				local isDoingKillTP = false -- flag: sedang eksekusi Kill TP (biar CharacterAdded tdk trigger reset)

				-- ── Death detector ────────────────────────────────────────
				-- CharacterAdded = player respawn setelah mati.
				-- Kalau BUKAN dari Kill TP kita sendiri → tandai mati, reset ke awal
				local deathConn
				deathConn = plr.CharacterAdded:Connect(function()
					if not isDoingKillTP and AF.active then
						AF_died = true
					end
				end)

				while AF.active and Running do
					AF_died = false -- reset flag tiap awal siklus

					-- ─── PHASE 1: KILL TP → MARSHMALLOW ──────────────────
					-- Hanya dilakukan di iterasi pertama ATAU setelah mati
					if needsKillTP then
						isDoingKillTP = true
						afSetStatus("Phase 1 · Kill TP → Buy Marshmallow...", Color3.fromRGB(220,80,80))
						doSuicideTP({name="Buy Marshmallow", x=MARSH_X, y=MARSH_Y, z=MARSH_Z})
						isDoingKillTP = false
						needsKillTP = false
					end

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- ─── PHASE 2: BUY PACK ───────────────────────────────
					afSetStatus("Phase 2 · Buy Pack ×" .. AF.packQty .. "...", Color3.fromRGB(100,180,255))
					afDoBuyPack(AF.packQty)

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati saat beli! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- ─── PHASE 3: TP GO → APARTMENT ─────────────────────
					local apt = selectedApart
					if not apt then AF.active=false
						break end
					afSetStatus("Phase 3 · TP → " .. apt.name .. "...", T.Accent)
					tpToPos(apt.x, apt.y, apt.z, nil, apt.name)
					local waitLimit3 = 0
					while tpActive and waitLimit3 < 200 do
						task.wait(0.1)
						waitLimit3 = waitLimit3 + 1
					end
					task.wait(0.5)

					-- tunggu tpActive bener2 selesai
					local waitLimit = 0
					while tpActive and waitLimit < 100 do
						task.wait(0.1)
						waitLimit = waitLimit + 1
					end
					task.wait(0.5)

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati saat ke Apartment! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- snap ke cook spot setelah TP
					snapToCookPos()
					task.wait(0.5)

					-- ─── PHASE 4: AUTO COOK sampai qty selesai ───────────
					local startMasak = totalMasak
					local target = startMasak + AF.packQty
					local afLastMasak = totalMasak        -- watchdog: cek progress masak
					local afLastMasakTime = tick()        -- waktu terakhir totalMasak nambah
					-- Matiin CanCollide Apart 5 & 6 kalau AutoFarm jalan di sana
					if selectedApart then
						local aptName = selectedApart.name:lower()
						if aptName:find("apt 5") or aptName:find("apt5") or aptName:find("west")
							or aptName:find("apt 6") or aptName:find("apt6") then
							setApart56FloorCollide(false)
						end
					end
					Flags.AutoCook = true
					lastCookProgressTime = tick()         -- sync watchdog autocook
					refreshCookBar()
					afSetStatus(("Phase 4 · Cook 0/%d..."):format(AF.packQty), Color3.fromRGB(255,160,60))

					while AF.active and Running and totalMasak < target do
						if AF_died then break end
						-- pause: stop cook, tunggu resume
						if AF.paused then
							if Flags.AutoCook then Flags.AutoCook = false
								refreshCookBar() end
							while AF.paused and AF.active do task.wait(0.3) end
							if not AF.active then break end
							Flags.AutoCook = true
							lastCookProgressTime = tick()
							refreshCookBar()
							snapToCookPos()
						end

						-- ── Watchdog Phase 4: kalau masak stuck > 2.5 menit reset step ──
						if totalMasak > afLastMasak then
							afLastMasak = totalMasak
							afLastMasakTime = tick()
						elseif (tick() - afLastMasakTime) > COOK_WATCHDOG_SECS then
							-- Stuck! paksa reset ke water dan coba lagi
							currentCookStep = 1
							lastCookProgressTime = tick()
							afLastMasakTime = tick()
							afSetStatus("Phase 4 · ⚠ Stuck! Reset masak...", Color3.fromRGB(255,100,30))
							snapToCookPos()
							task.wait(1)
						end
						-- ────────────────────────────────────────────────────────────────

						local done = totalMasak - startMasak
						afSetStatus(("Phase 4 · Cook %d/%d..."):format(done, AF.packQty), Color3.fromRGB(255,160,60))
						afCycleInfoLbl.Text = ("Siklus #%d · %d/%d pack selesai"):format(cycleCount+1, done, AF.packQty)
						task.wait(0.5)
					end

					Flags.AutoCook = false
					if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
					refreshCookBar()

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati saat masak! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- ─── PHASE 5: TP GO → MARSHMALLOW (underground) ──────
					afSetStatus("Phase 5 · TP → Buy Marshmallow (sell)...", Color3.fromRGB(100,220,100))
					tpToPos(MARSH_X, MARSH_Y, MARSH_Z, nil, "Buy Marshmallow")
					local waitLimit5 = 0
					while tpActive and waitLimit5 < 200 do
						task.wait(0.1)
						waitLimit5 = waitLimit5 + 1
					end
					task.wait(0.5)

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati saat ke toko! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- ─── PHASE 6: SELL ALL MARSHMALLOW ───────────────────
					afSetStatus("Phase 6 · Sell Marshmallow...", Color3.fromRGB(0,220,120))
					afDoSell()
					task.wait(0.5)

					while AF.paused and AF.active do task.wait(0.3) end
					if not AF.active then break end
					if AF_died then
						needsKillTP = true
						afSetStatus("Mati saat jual! Restart dari awal...", Color3.fromRGB(220,80,80))
						task.wait(1)
						continue
					end

					-- ─── SIKLUS SELESAI ───────────────────────────────────
					cycleCount = cycleCount + 1
					afCycleInfoLbl.Text = ("Siklus #%d selesai! Mulai lagi..."):format(cycleCount)
					afSetStatus(("Siklus #%d selesai! Looping..."):format(cycleCount), Color3.fromRGB(0,220,100))
					task.wait(0.8)
				end

				-- cleanup
				if deathConn then deathConn:Disconnect() end
				AF.active = false
				AF.paused = false
				Flags.AutoCook = false
				if _G.HNDRIXX_RESTORE_FLOOR then _G.HNDRIXX_RESTORE_FLOOR() end
				refreshCookBar()
				refreshAfBar()
				afSetStatus("Fully Auto Farm dihentikan.", Color3.fromRGB(180,60,60))
				afCycleInfoLbl.Text = ""
				task.delay(3, function()
					if afStatusLbl.Text:find("dihentikan") then afStatusLbl.Text = "" end
				end)
			end

			-- ── TOGGLE BUTTON ─────────────────────────────────────────────
			AfBar.MouseButton1Click:Connect(function()
				if not AF.active then
					-- validasi: harus pilih apartment dulu
					if not selectedApart then
						afSetStatus("Pilih apartment dulu!", Color3.fromRGB(255,140,0))
						-- flash hint
						afHintLbl.TextColor3 = Color3.fromRGB(255,80,80)
						task.delay(1.5, function() afHintLbl.TextColor3 = Color3.fromRGB(255,140,0) end)
						return
					end
					AF.active = true
					AF.paused = false
					refreshAfBar()
					afCycleInfoLbl.Text = "Memulai siklus pertama..."
					task.spawn(startAFLoop)
				else
					-- OFF: hentikan semua
					AF.active = false
					AF.paused = false
					Flags.AutoCook = false
					refreshCookBar()
					refreshAfBar()
					afSetStatus("Dihentikan manual.", Color3.fromRGB(180,60,60))
					afCycleInfoLbl.Text = ""
				end
			end)

			-- ================================================================
			-- AUTO BUY CHIPS — Potato & Flour
			-- ================================================================
			local chipBuyDiv = Instance.new("Frame", PageFarm)
			chipBuyDiv.Size = UDim2.new(1,0,0,1)
			chipBuyDiv.BackgroundColor3 = Color3.fromRGB(30,30,30)
			chipBuyDiv.BorderSizePixel = 0

			local chipBuyHdr = Instance.new("TextLabel", PageFarm)
			chipBuyHdr.Size = UDim2.new(1,0,0,20)
			chipBuyHdr.BackgroundTransparency = 1
			chipBuyHdr.Text = "AUTO BUY — Chips (Potato & Flour)"
			chipBuyHdr.TextColor3 = T.TextDim
			chipBuyHdr.Font = Enum.Font.GothamBlack
			chipBuyHdr.TextSize = 11

			local chipBuyAmtSettings = { Amount = 10 }

			local chipBuyStatusLbl = Instance.new("TextLabel", PageFarm)
			chipBuyStatusLbl.Size = UDim2.new(1,0,0,18)
			chipBuyStatusLbl.BackgroundTransparency = 1
			chipBuyStatusLbl.Text = ""
			chipBuyStatusLbl.TextColor3 = T.Accent
			chipBuyStatusLbl.Font = Enum.Font.GothamBlack
			chipBuyStatusLbl.TextSize = 13

			AddSlider(PageFarm, "Jumlah Beli Chips", 1, 100, chipBuyAmtSettings.Amount, "x", function(v)
				chipBuyAmtSettings.Amount = v
			end)

			local chipBuyDefs = {
				{label="Buy POTATO", items={"Potato"}},
				{label="Buy FLOUR", items={"Flour"}},
				{label="Buy PACK (Potato+Flour)", items={"Potato","Flour"}},
			}

			local chipBuyBusy = false
			local chipBuyCancelled = false
			local chipBuyAllRefs = {}

			local function chipBuySetStatus(txt, col)
				chipBuyStatusLbl.Text = txt
				chipBuyStatusLbl.TextColor3 = col or T.Accent
			end

			local function chipBuyFinish()
				chipBuyBusy = false
				chipBuyCancelled = false
				for _, ref in ipairs(chipBuyAllRefs) do
					ref.lbl.Text = "BUY"
					ref.pill.BackgroundColor3 = Color3.fromRGB(24,24,24)
					ref.name.TextColor3 = Color3.fromRGB(200,200,200)
				end
			end

			local function doChipRemoteBuy(itemNames, qty)
				task.spawn(function()
					local remEvts2 = _RS2:FindFirstChild("RemoteEvents")
					local spRE2 = remEvts2 and remEvts2:FindFirstChild("StorePurchase")
					if not spRE2 then
						chipBuySetStatus("RemoteEvent tidak ada!", Color3.fromRGB(255,80,80))
						task.wait(3)
						chipBuyFinish()
						return
					end
					for _, itemName in ipairs(itemNames) do
						if chipBuyCancelled then break end
						chipBuySetStatus("Beli " .. itemName .. "×" .. qty .. "...", Color3.fromRGB(100,180,255))
						for _ = 1, qty do
							if chipBuyCancelled then break end
							pcall(function() spRE2:FireServer(itemName, 1) end)
							task.wait(0.4)
						end
						if not chipBuyCancelled then
							chipBuySetStatus("" .. itemName .. "selesai!", Color3.fromRGB(0,220,100))
							task.wait(0.3)
						end
					end
					if chipBuyCancelled then
						chipBuySetStatus("Dibatalkan!", Color3.fromRGB(255,160,40))
					else
						chipBuySetStatus("Selesai beli!", Color3.fromRGB(0,220,100))
					end
					task.delay(3, function()
						if chipBuyStatusLbl.Text:find("Selesai") or chipBuyStatusLbl.Text:find("Dibatalkan") then
							chipBuyStatusLbl.Text = ""
						end
					end)
					chipBuyFinish()
				end)
			end

			for _, def in ipairs(chipBuyDefs) do
				local bWrap = Instance.new("TextButton", PageFarm)
				bWrap.Size = UDim2.new(1,0,0,34)
				bWrap.BackgroundColor3 = Color3.fromRGB(14,14,14)
				bWrap.Text = ""
				bWrap.AutoButtonColor = false
				Instance.new("UICorner", bWrap).CornerRadius = UDim.new(0,8)
				Instance.new("UIStroke", bWrap).Color = Color3.fromRGB(38,38,38)

				local nm3 = Instance.new("TextLabel", bWrap)
				nm3.Size = UDim2.new(1,-80,1,0)
				nm3.Position = UDim2.new(0,10,0,0)
				nm3.BackgroundTransparency = 1
				nm3.Text = def.label
				nm3.TextColor3 = Color3.fromRGB(200,200,200)
				nm3.Font = Enum.Font.GothamBlack
				nm3.TextSize = 13
				nm3.TextXAlignment = Enum.TextXAlignment.Left

				local bp3 = Instance.new("Frame", bWrap)
				bp3.Size = UDim2.new(0,60,0,22)
				bp3.AnchorPoint = Vector2.new(1,0.5)
				bp3.Position = UDim2.new(1,-6,0.5,0)
				bp3.BackgroundColor3 = Color3.fromRGB(24,24,24)
				Instance.new("UICorner", bp3).CornerRadius = UDim.new(1,0)
				Instance.new("UIStroke", bp3).Color = Color3.fromRGB(60,60,60)
				local bl3 = Instance.new("TextLabel", bp3)
				bl3.Size = UDim2.new(1,0,1,0)
				bl3.BackgroundTransparency = 1
				bl3.Text = "BUY"
				bl3.TextColor3 = Color3.fromRGB(180,180,180)
				bl3.Font = Enum.Font.GothamBlack
				bl3.TextSize = 11

				table.insert(chipBuyAllRefs, {lbl=bl3, pill=bp3, name=nm3})
				local capItems3 = def.items

				bWrap.MouseButton1Click:Connect(function()
					if chipBuyBusy then return end
					chipBuyBusy = true
					chipBuyCancelled = false
					bl3.Text = ""
					bp3.BackgroundColor3 = Color3.fromRGB(35,35,35)
					nm3.TextColor3 = T.TextDim
					doChipRemoteBuy(capItems3, chipBuyAmtSettings.Amount)
				end)
			end

			-- ================================================================
			-- CHIPS AUTO FARM
			-- Flow: A (prox) → B (Potato+prox, 2s) → C (prox, 2s)
			-- → D (Flour+prox, 2s) → E/pot (prox, tunggu 60s, claim)
			-- ================================================================

			-- ── KOORDINAT — isi sesuai game ──────────────────────────────
			-- (ganti nilai x,y,z ini sesuai posisi di game)
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

			local CF2 = { active=false, paused=false, pot=1 }

			-- ── UI ────────────────────────────────────────────────────────
			local cfDiv = Instance.new("Frame", PageFarm)
			cfDiv.Size = UDim2.new(1,0,0,1)
			cfDiv.BackgroundColor3 = Color3.fromRGB(30,30,30)
			cfDiv.BorderSizePixel = 0

			local cfHdr = Instance.new("TextLabel", PageFarm)
			cfHdr.Size = UDim2.new(1,0,0,20)
			cfHdr.BackgroundTransparency = 1
			cfHdr.Text = "CHIPS AUTO FARM — Loop Non-Stop"
			cfHdr.TextColor3 = Color3.fromRGB(80,200,255)
			cfHdr.Font = Enum.Font.GothamBlack
			cfHdr.TextSize = 11

			-- Pot selector header
			local potSelectorHdr = Instance.new("TextLabel", PageFarm)
			potSelectorHdr.Size = UDim2.new(1,0,0,16)
			potSelectorHdr.BackgroundTransparency = 1
			potSelectorHdr.Text = "Pilih Pot Masak (Koordinat E):"
			potSelectorHdr.TextColor3 = T.TextDim
			potSelectorHdr.Font = Enum.Font.Gotham
			potSelectorHdr.TextSize = 12

			-- Pot 1-10 grid
			local potGrid = Instance.new("Frame", PageFarm)
			potGrid.Size = UDim2.new(1,0,0,66)
			potGrid.BackgroundColor3 = T.Card
			Instance.new("UICorner", potGrid).CornerRadius = UDim.new(0,8)
			Instance.new("UIStroke", potGrid).Color = T.Stroke

			local potBtns = {}
			local function refreshPotBtns()
				for i, btn in ipairs(potBtns) do
					local sel = CF2.pot == i
					btn.BackgroundColor3 = sel and Color3.fromRGB(20,70,130) or Color3.fromRGB(22,22,22)
					local s = btn:FindFirstChildOfClass("UIStroke")
					if s then s.Color = sel and Color3.fromRGB(80,180,255) or Color3.fromRGB(50,50,50) end
					local lbl = btn:FindFirstChildOfClass("TextLabel")
					if lbl then lbl.TextColor3 = sel and Color3.fromRGB(255,255,255) or T.TextDim end
				end
			end

			for i = 1, 10 do
				local col = (i-1) % 5
				local row = math.floor((i-1) / 5)
				local pw = 1/5
				local pBtn = Instance.new("TextButton", potGrid)
				pBtn.Size = UDim2.new(pw - 0.02, 0, 0, 24)
				pBtn.Position = UDim2.new(col*pw + 0.01, 0, 0, 8 + row*30)
				pBtn.BackgroundColor3 = Color3.fromRGB(22,22,22)
				pBtn.Text = ""
				pBtn.AutoButtonColor = false
				Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0,6)
				local pbs = Instance.new("UIStroke", pBtn)
				pbs.Color = Color3.fromRGB(50,50,50)
				local pbl = Instance.new("TextLabel", pBtn)
				pbl.Size = UDim2.new(1,0,1,0)
				pbl.BackgroundTransparency = 1
				pbl.Text = tostring(i)
				pbl.TextColor3 = T.TextDim
				pbl.Font = Enum.Font.GothamBlack
				pbl.TextSize = 12
				table.insert(potBtns, pBtn)
				local capI = i
				pBtn.MouseButton1Click:Connect(function()
					CF2.pot = capI
					refreshPotBtns()
				end)
			end
			refreshPotBtns()

			-- Status & info labels
			local cfStatusLbl2 = Instance.new("TextLabel", PageFarm)
			cfStatusLbl2.Size = UDim2.new(1,0,0,18)
			cfStatusLbl2.BackgroundTransparency = 1
			cfStatusLbl2.Text = ""
			cfStatusLbl2.TextColor3 = T.Accent
			cfStatusLbl2.Font = Enum.Font.GothamBlack
			cfStatusLbl2.TextSize = 13

			local cfCycleInfoLbl2 = Instance.new("TextLabel", PageFarm)
			cfCycleInfoLbl2.Size = UDim2.new(1,0,0,16)
			cfCycleInfoLbl2.BackgroundTransparency = 1
			cfCycleInfoLbl2.Text = ""
			cfCycleInfoLbl2.TextColor3 = T.TextDim
			cfCycleInfoLbl2.Font = Enum.Font.Gotham
			cfCycleInfoLbl2.TextSize = 12

			local function cfSetStatus2(txt, col)
				cfStatusLbl2.Text = txt
				cfStatusLbl2.TextColor3 = col or T.Accent
			end

			-- Main toggle bar
			local CfBar = Instance.new("TextButton", PageFarm)
			CfBar.Size = UDim2.new(1,0,0,40)
			CfBar.BackgroundColor3 = T.Card
			CfBar.Text = ""
			CfBar.AutoButtonColor = false
			Instance.new("UICorner", CfBar).CornerRadius = UDim.new(0,8)
			local cfBarStr2 = Instance.new("UIStroke", CfBar)
			cfBarStr2.Color = T.Stroke
			cfBarStr2.Thickness = 1

			local cfDot2 = Instance.new("Frame", CfBar)
			cfDot2.Size = UDim2.new(0,5,0,5)
			cfDot2.Position = UDim2.new(0,12,0.5,-2.5)
			cfDot2.BackgroundColor3 = Color3.fromRGB(38,38,38)
			Instance.new("UICorner", cfDot2).CornerRadius = UDim.new(1,0)

			local cfNameLbl2 = Instance.new("TextLabel", CfBar)
			cfNameLbl2.Size = UDim2.new(1,-76,1,0)
			cfNameLbl2.Position = UDim2.new(0,24,0,0)
			cfNameLbl2.BackgroundTransparency = 1
			cfNameLbl2.Text = "Chips Auto Farm"
			cfNameLbl2.TextColor3 = T.TextDim
			cfNameLbl2.Font = Enum.Font.GothamBlack
			cfNameLbl2.TextSize = 14
			cfNameLbl2.TextXAlignment = Enum.TextXAlignment.Left

			local cfPill2 = Instance.new("Frame", CfBar)
			cfPill2.Size = UDim2.new(0,46,0,22)
			cfPill2.Position = UDim2.new(1,-52,0.5,-11)
			cfPill2.BackgroundColor3 = Color3.fromRGB(20,20,20)
			Instance.new("UICorner", cfPill2).CornerRadius = UDim.new(1,0)
			Instance.new("UIStroke", cfPill2).Color = T.Stroke
			local cfPillLbl2 = Instance.new("TextLabel", cfPill2)
			cfPillLbl2.Size = UDim2.new(1,0,1,0)
			cfPillLbl2.BackgroundTransparency = 1
			cfPillLbl2.Text = "OFF"
			cfPillLbl2.TextColor3 = T.TextDim
			cfPillLbl2.Font = Enum.Font.GothamBlack
			cfPillLbl2.TextSize = 12

			local cfPauseBtn2 = Instance.new("TextButton", PageFarm)
			cfPauseBtn2.Size = UDim2.new(1,0,0,32)
			cfPauseBtn2.BackgroundColor3 = Color3.fromRGB(30,30,10)
			cfPauseBtn2.Text = "PAUSE"
			cfPauseBtn2.TextColor3 = Color3.fromRGB(255,220,50)
			cfPauseBtn2.Font = Enum.Font.GothamBlack
			cfPauseBtn2.TextSize = 13
			cfPauseBtn2.AutoButtonColor = false
			cfPauseBtn2.Visible = false
			Instance.new("UICorner", cfPauseBtn2).CornerRadius = UDim.new(0,8)
			Instance.new("UIStroke", cfPauseBtn2).Color = Color3.fromRGB(80,70,10)

			local function refreshCfBar2()
				local on = CF2.active
				CfBar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
				cfBarStr2.Color = on and Color3.fromRGB(40,140,220) or T.Stroke
				cfDot2.BackgroundColor3 = on and Color3.fromRGB(80,200,255) or Color3.fromRGB(38,38,38)
				cfNameLbl2.TextColor3 = on and T.Text or T.TextDim
				cfPill2.BackgroundColor3 = on and Color3.fromRGB(80,200,255) or Color3.fromRGB(20,20,20)
				cfPillLbl2.Text = on and "ON" or "OFF"
				cfPillLbl2.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
				local st2 = cfPill2:FindFirstChildOfClass("UIStroke")
				if on then if st2 then st2:Destroy() end else if not st2 then Instance.new("UIStroke",cfPill2).Color=T.Stroke end end
					cfPauseBtn2.Visible = on
				end
				refreshCfBar2()

				cfPauseBtn2.MouseButton1Click:Connect(function()
					if not CF2.active then return end
					CF2.paused = not CF2.paused
					if CF2.paused then
						cfPauseBtn2.Text = "▶ RESUME"
						cfPauseBtn2.TextColor3 = Color3.fromRGB(100,220,100)
						cfPauseBtn2.BackgroundColor3 = Color3.fromRGB(10,30,10)
						cfPauseBtn2.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(30,80,30)
						cfSetStatus2("Paused — tekan RESUME untuk lanjut", Color3.fromRGB(255,220,50))
					else
						cfPauseBtn2.Text = "PAUSE"
						cfPauseBtn2.TextColor3 = Color3.fromRGB(255,220,50)
						cfPauseBtn2.BackgroundColor3 = Color3.fromRGB(30,30,10)
						cfPauseBtn2.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(80,70,10)
						cfSetStatus2("▶ Resumed...", T.Accent)
					end
				end)

				-- ── STOCK PANEL ──────────────────────────────────────────────
				local CF_STOCK_DEFS = {
					{label="Potato",       name="Potato"},
					{label="Flour",        name="Flour"},
					{label="Potato Chips", name="Potato Chips"},
					{label="Hot Chips",    name="Hot Chips"},
				}

				local cfStockHeader = Instance.new("Frame", PageFarm)
				cfStockHeader.Size = UDim2.new(1, 0, 0, 28)
				cfStockHeader.BackgroundColor3 = T.TopBar
				Instance.new("UICorner", cfStockHeader).CornerRadius = UDim.new(0, 8)
				local cfStockHdrLbl = Instance.new("TextLabel", cfStockHeader)
				cfStockHdrLbl.Size = UDim2.new(1,-10,1,0)
				cfStockHdrLbl.Position = UDim2.new(0,8,0,0)
				cfStockHdrLbl.BackgroundTransparency = 1
				cfStockHdrLbl.Text = "INVENTORY STOCK"
				cfStockHdrLbl.TextColor3 = T.Text
				cfStockHdrLbl.Font = Enum.Font.GothamBlack
				cfStockHdrLbl.TextSize = 16
				cfStockHdrLbl.TextXAlignment = Enum.TextXAlignment.Left

				local cfStockCard = Instance.new("Frame", PageFarm)
				cfStockCard.Size = UDim2.new(1, 0, 0, #CF_STOCK_DEFS * 24 + 12)
				cfStockCard.BackgroundColor3 = T.Card
				Instance.new("UICorner", cfStockCard).CornerRadius = UDim.new(0, 8)
				Instance.new("UIStroke", cfStockCard).Color = T.Stroke

				local cfStockItems = {}
				for i, def in ipairs(CF_STOCK_DEFS) do
					local row = Instance.new("Frame", cfStockCard)
					row.Size = UDim2.new(1, -12, 0, 20)
					row.Position = UDim2.new(0, 6, 0, (i-1)*24 + 5)
					row.BackgroundTransparency = 1

					if i > 1 then
						local sep = Instance.new("Frame", row)
						sep.Size = UDim2.new(1,0,0,1)
						sep.BackgroundColor3 = T.Stroke
						sep.BorderSizePixel = 0
					end

					local nameLbl = Instance.new("TextLabel", row)
					nameLbl.Size = UDim2.new(0.7,0,1,0)
					nameLbl.BackgroundTransparency = 1
					nameLbl.Text = def.label
					nameLbl.TextColor3 = T.TextDim
					nameLbl.Font = Enum.Font.GothamBlack
					nameLbl.TextSize = 15
					nameLbl.TextXAlignment = Enum.TextXAlignment.Left

					local countLbl = Instance.new("TextLabel", row)
					countLbl.Size = UDim2.new(0.3,0,1,0)
					countLbl.Position = UDim2.new(0.7,0,0,0)
					countLbl.BackgroundTransparency = 1
					countLbl.Text = "0"
					countLbl.TextColor3 = T.Accent
					countLbl.Font = Enum.Font.GothamBlack
					countLbl.TextSize = 15
					countLbl.TextXAlignment = Enum.TextXAlignment.Right

					table.insert(cfStockItems, {name=def.name, lbl=countLbl})
				end

				-- Hitung jumlah item di Backpack + Character
				local function cfCountItem(itemName)
					local n = 0
					pcall(function()
						for _, t in ipairs(plr.Backpack:GetChildren()) do
							if t.Name == itemName then n += 1 end
						end
						local ch = plr.Character
						if ch then
							for _, t in ipairs(ch:GetChildren()) do
								if t:IsA("Tool") and t.Name == itemName then n += 1 end
							end
						end
					end)
					return n
				end

				-- Refresh semua label stock
				local function cfRefreshStock()
					for _, item in ipairs(cfStockItems) do
						item.lbl.Text = tostring(cfCountItem(item.name))
					end
				end

				-- ── CHIPS HELPERS ─────────────────────────────────────────────
				-- Cari ProximityPrompt terdekat dari koordinat tertentu
				local function findPromptNear(targetPos, radius)
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
								if d < bestDist then bestDist = d
									best = obj end
							end
						end
					end
					return best
				end

				local function cfFirePromptAt(targetPos)
					local p = findPromptNear(targetPos)
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

				local function cfEquipTool(keyword)
					local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
					if not hum then return end
					for _, v in pairs(plr.Backpack:GetChildren()) do
						if v:IsA("Tool") and v.Name:lower():find(keyword:lower()) then
							pcall(function() hum:EquipTool(v) end)
							task.wait(0.2)
							return
						end
					end
				end

				-- Definisi ulang moveCharTo di dalam scope _buildFarm
				-- agar bisa diakses oleh cfTPToCoord (upvalue dari launchMainScript kadang nil)
				local function cfMoveCharTo(targetPos)
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
						local t = math.clamp(elapsed / travelT, 0, 1)
						cfMoveCharTo(fromPos:Lerp(toPos, t))
						local _, dt = RunService.Stepped:Wait()
						elapsed = elapsed + dt
					end
					if CF2.active then cfMoveCharTo(toPos) end
				end

				-- ── MAIN CHIP LOOP ────────────────────────────────────────────
				local function startChipLoop()
					local cycle = 0
					while CF2.active and Running do
						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						local pot = CHIPS_POTS[CF2.pot]
						cfRefreshStock()

						-- ─── STEP A: TP→A, prox (tanpa jeda setelah) ─────────
						cfSetStatus2("Step A · " .. CHIPS_COORDS.A.name, Color3.fromRGB(80,200,255))
						cfTPToCoord(CHIPS_COORDS.A)
						cfFirePromptAt(Vector3.new(CHIPS_COORDS.A.x, CHIPS_COORDS.A.y, CHIPS_COORDS.A.z))
						-- Step pertama: TIDAK ada jeda setelah prompt

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- ─── STEP B: TP→B, equip Potato, prox, 2s ─────────
						cfSetStatus2("Step B · " .. CHIPS_COORDS.B.name .. "(Potato)", Color3.fromRGB(255,200,80))
						cfTPToCoord(CHIPS_COORDS.B)
						local plr = game:GetService("Players").LocalPlayer
						local char = plr.Character
						local bp = plr:FindFirstChild("Backpack")

						if bp and char then
							local targetTool = bp:FindFirstChild("Potato")
							local humanoid = char:FindFirstChild("Humanoid")

							-- Validasi mutlak: pastikan tool ada, namanya persis "Potato", dan humanoid siap
							if targetTool and targetTool.Name == "Potato" and humanoid then
								humanoid:EquipTool(targetTool)
							end
						end
						cfFirePromptAt(Vector3.new(CHIPS_COORDS.B.x, CHIPS_COORDS.B.y, CHIPS_COORDS.B.z))
						task.wait(2)
						cfRefreshStock()

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- ─── STEP C: TP→C, prox (tanpa item), 2s ────────────
						cfSetStatus2("Step C · " .. CHIPS_COORDS.C.name, Color3.fromRGB(200,200,200))
						cfTPToCoord(CHIPS_COORDS.C)
						cfFirePromptAt(Vector3.new(CHIPS_COORDS.C.x, CHIPS_COORDS.C.y, CHIPS_COORDS.C.z))
						task.wait(2)

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- ─── STEP D: TP→D, equip Flour, prox, 2s ─────────────
						cfSetStatus2("Step D · " .. CHIPS_COORDS.D.name .. "(Flour)", Color3.fromRGB(220,180,100))
						cfTPToCoord(CHIPS_COORDS.D)
						cfEquipTool("Flour")
						cfFirePromptAt(Vector3.new(CHIPS_COORDS.D.x, CHIPS_COORDS.D.y, CHIPS_COORDS.D.z))
						task.wait(2)
						cfRefreshStock()

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- ─── STEP E: TP→Pot, prox, tunggu 60s, claim ─────────
						cfSetStatus2(("Step E · TP ke %s..."):format(pot.name), Color3.fromRGB(255,160,60))
						cfTPToCoord(pot)
						cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
						task.wait(2)

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- Countdown 60 detik masak
						local waited = 0
						while CF2.active and waited < 60 do
							while CF2.paused and CF2.active do task.wait(0.3) end
							if not CF2.active then break end
							local remaining = 60 - math.floor(waited)
							cfSetStatus2(("Masak Chips... %ds"):format(remaining), Color3.fromRGB(255,160,60))
							cfCycleInfoLbl2.Text = ("Siklus #%d · %s"):format(cycle+1, pot.name)
							task.wait(1)
							waited += 1
						end

						while CF2.paused and CF2.active do task.wait(0.3) end
						if not CF2.active then break end

						-- Claim chips: TP balik ke pot, pencet prox lagi
						cfSetStatus2("Claim Chips!", Color3.fromRGB(0,220,100))
						cfTPToCoord(pot)
						cfFirePromptAt(Vector3.new(pot.x, pot.y, pot.z))
						task.wait(1)
						cfRefreshStock()

						-- ─── SIKLUS SELESAI ───────────────────────────────────
						cycle += 1
						cfCycleInfoLbl2.Text = ("Siklus #%d selesai!"):format(cycle)
						cfSetStatus2(("Siklus #%d selesai! Looping..."):format(cycle), Color3.fromRGB(0,220,100))
						task.wait(0.8)
					end

					CF2.active = false
					CF2.paused = false
					refreshCfBar2()
					cfSetStatus2("Chips Auto Farm dihentikan.", Color3.fromRGB(180,60,60))
					cfCycleInfoLbl2.Text = ""
					task.delay(3, function()
						if cfStatusLbl2.Text:find("dihentikan") then cfStatusLbl2.Text = "" end
					end)
				end

				CfBar.MouseButton1Click:Connect(function()
					if not CF2.active then
						CF2.active = true
						CF2.paused = false
						refreshCfBar2()
						cfCycleInfoLbl2.Text = "Memulai siklus pertama..."
						task.spawn(startChipLoop)
					else
						CF2.active = false
						CF2.paused = false
						refreshCfBar2()
						cfSetStatus2("Dihentikan manual.", Color3.fromRGB(180,60,60))
						cfCycleInfoLbl2.Text = ""
					end
				end)


				-- ================================================================
				-- AUTO SELL CHIPS
				-- ================================================================

				local scDiv = Instance.new("Frame", PageFarm)
				scDiv.Size = UDim2.new(1,0,0,1); scDiv.BackgroundColor3 = Color3.fromRGB(30,30,30)
				scDiv.BorderSizePixel = 0

				local scHdr = Instance.new("TextLabel", PageFarm)
				scHdr.Size = UDim2.new(1,0,0,20); scHdr.BackgroundTransparency = 1
				scHdr.Text = "AUTO SELL CHIPS — Vehicle Required"
				scHdr.TextColor3 = T.TextDim
				scHdr.Font = Enum.Font.GothamBlack; scHdr.TextSize = 11

				local scStatusLbl = Instance.new("TextLabel", PageFarm)
				scStatusLbl.Size = UDim2.new(1,0,0,18); scStatusLbl.BackgroundTransparency = 1
				scStatusLbl.Text = ""; scStatusLbl.TextColor3 = T.Accent
				scStatusLbl.Font = Enum.Font.GothamBlack; scStatusLbl.TextSize = 13

				local ScBar = Instance.new("TextButton", PageFarm)
				ScBar.Size = UDim2.new(1,0,0,42)
				ScBar.BackgroundColor3 = T.Card
				ScBar.Text = ""; ScBar.AutoButtonColor = false
				Instance.new("UICorner", ScBar).CornerRadius = UDim.new(0,8)
				local scBarStr = Instance.new("UIStroke", ScBar)
				scBarStr.Color = T.Stroke; scBarStr.Thickness = 1

				local scDot = Instance.new("Frame", ScBar)
				scDot.Size = UDim2.new(0,8,0,8)
				scDot.Position = UDim2.new(0,10,0.5,-4)
				scDot.BackgroundColor3 = Color3.fromRGB(38,38,38)
				Instance.new("UICorner", scDot).CornerRadius = UDim.new(1,0)

				local scNameLbl = Instance.new("TextLabel", ScBar)
				scNameLbl.Size = UDim2.new(1,-80,1,0)
				scNameLbl.Position = UDim2.new(0,24,0,0)
				scNameLbl.BackgroundTransparency = 1
				scNameLbl.Text = "Auto Sell Chips"
				scNameLbl.TextColor3 = T.TextDim
				scNameLbl.Font = Enum.Font.GothamBlack; scNameLbl.TextSize = 14
				scNameLbl.TextXAlignment = Enum.TextXAlignment.Left

				local scPill = Instance.new("Frame", ScBar)
				scPill.Size = UDim2.new(0,46,0,22)
				scPill.Position = UDim2.new(1,-54,0.5,-11)
				scPill.BackgroundColor3 = Color3.fromRGB(20,20,20)
				Instance.new("UICorner", scPill).CornerRadius = UDim.new(1,0)
				Instance.new("UIStroke", scPill).Color = T.Stroke

				local scPillLbl = Instance.new("TextLabel", scPill)
				scPillLbl.Size = UDim2.new(1,0,1,0)
				scPillLbl.BackgroundTransparency = 1
				scPillLbl.Text = "OFF"
				scPillLbl.TextColor3 = T.TextDim
				scPillLbl.Font = Enum.Font.GothamBlack; scPillLbl.TextSize = 12

				local scInfoLbl = Instance.new("TextLabel", PageFarm)
				scInfoLbl.Size = UDim2.new(1,0,0,16); scInfoLbl.BackgroundTransparency = 1
				scInfoLbl.Text = ""; scInfoLbl.TextColor3 = T.TextDim
				scInfoLbl.Font = Enum.Font.Gotham; scInfoLbl.TextSize = 12

				local SC = { active = false }

				local function refreshScBar()
					local on = SC.active
					ScBar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or T.Card
					scBarStr.Color = on and T.StrokeOn or T.Stroke
					scNameLbl.TextColor3 = on and T.Text or T.TextDim
					scDot.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(38,38,38)
					scPill.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,20)
					scPillLbl.Text = on and "ON" or "OFF"
					scPillLbl.TextColor3 = on and Color3.fromRGB(0,0,0) or T.TextDim
				end

				local function scSetStatus(txt, col)
					scStatusLbl.Text = txt
					scStatusLbl.TextColor3 = col or T.Accent
				end

				-- Koordinat Chips Tukar dan Chips Cook
				local SC_TUKAR = {x=-34.91, y=4.56, z=-24.15}
				local SC_COOK  = {x=-487.11, y=3.86, z=-454.16}

				-- Koordinat 12 Homeless
				local SC_HOMELESS = {
					{x=-315.35, y=3.72, z=-361.56},
					{x=-273.52, y=3.85, z=-211.32},
					{x=1102.42, y=3.36, z=527.05},
					{x=52.89,   y=3.72, z=-425.36},
					{x=152.88,  y=3.73, z=-210.08},
					{x=-522.75, y=-7.86, z=-165.08},
					{x=65.12,   y=3.73, z=68.10},
					{x=26.04,   y=3.73, z=217.89},
					{x=520.08,  y=3.87, z=-295.52},
					{x=699.28,  y=3.72, z=-427.05},
					{x=900.03,  y=3.94, z=-283.12},
					{x=874.89,  y=3.73, z=-63.02},
				}

				-- Hitung Potato Chips di inventory
				local function scCountChips(itemName)
					local n = 0
					pcall(function()
						for _, t in ipairs(plr.Backpack:GetChildren()) do
							if t.Name == itemName then n += 1 end
						end
						local ch = plr.Character
						if ch then
							for _, t in ipairs(ch:GetChildren()) do
								if t:IsA("Tool") and t.Name == itemName then n += 1 end
							end
						end
					end)
					return n
				end

				-- Cari prompt by ActionText keyword + jarak dari targetPos
				local function scFindPromptByAction(targetPos, actionKeyword, radius)
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
								local matchAction = actionKeyword == nil
									or obj.ActionText:lower():find(actionKeyword:lower()) ~= nil
								if d < bestDist and matchAction then
									bestDist = d; best = obj
								end
							end
						end
					end
					return best
				end

				-- Fire prompt: disable distance check dulu, fire, restore
				local function scFirePrompt(targetPos, actionKeyword)
					local p = scFindPromptByAction(targetPos, actionKeyword)
					if not p then
						-- fallback: cari prompt terdekat tanpa filter
						p = scFindPromptByAction(targetPos, nil, 40)
					end
					if not p then return false end
					local origDist = p.MaxActivationDistance
					local origLOS  = p.RequiresLineOfSight
					pcall(function()
						p.MaxActivationDistance = 9999
						p.RequiresLineOfSight = false
					end)
					task.wait(0.05)
					pcall(function() fireproximityprompt(p) end)
					task.wait(0.15)
					pcall(function()
						if p and p.Parent then
							p.MaxActivationDistance = origDist
							p.RequiresLineOfSight = origLOS
						end
					end)
					return true
				end

				-- Equip tool dari backpack by name
				local function scEquipTool(toolName)
					local ch = plr.Character
					local hum = ch and ch:FindFirstChildOfClass("Humanoid")
					if not hum then return false end
					-- cek di backpack
					local bp = plr.Backpack
					if bp then
						local tool = bp:FindFirstChild(toolName)
						if tool then
							pcall(function() hum:EquipTool(tool) end)
							task.wait(0.25)
							return true
						end
					end
					-- cek di character (sudah equipped)
					if ch then
						local tool = ch:FindFirstChild(toolName)
						if tool and tool:IsA("Tool") then return true end
					end
					return false
				end

				-- Main loop Auto Sell Chips
				local function startSellChipsLoop()
					while SC.active and Running do
						-- Cek vehicle
						local char = plr.Character
						local hum = char and char:FindFirstChildOfClass("Humanoid")
						local seat = hum and hum.SeatPart
						if not seat then
							scSetStatus("Harus naik vehicle dulu!", Color3.fromRGB(180,180,180))
							SC.active = false; refreshScBar(); return
						end

						-- Cek inventory: Hot Chips dulu, kalau ada langsung skip ke sell
						local hotCount    = scCountChips("Hot Chips")
						local potatoCount = scCountChips("Potato Chips")

						if hotCount == 0 and potatoCount == 0 then
							scSetStatus("Tidak ada Potato Chips maupun Hot Chips.", Color3.fromRGB(140,140,140))
							SC.active = false; refreshScBar(); return
						end

						local visitCount

						if hotCount > 0 then
							-- Sudah punya Hot Chips, langsung sell
							visitCount = math.min(hotCount, 12)
							scInfoLbl.Text = ("Hot Chips: %d → Visit %d Homeless"):format(hotCount, visitCount)
						else
							-- Punya Potato Chips → tukar dulu
							visitCount = math.min(potatoCount, 12)
							scInfoLbl.Text = ("Potato Chips: %d → Visit %d Homeless"):format(potatoCount, visitCount)

							-- Step 1: TP ke Chips Tukar
							scSetStatus("Step 1 · TP ke Chips Tukar...", Color3.fromRGB(200,200,200))
							local okTP = doVehicleTP(CFrame.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z))
							if not okTP then
								scSetStatus("Vehicle tidak ditemukan!", Color3.fromRGB(180,180,180))
								SC.active = false; refreshScBar(); return
							end
							task.wait(0.3)
							if not SC.active then break end

							-- Step 2: Fire prompt tukar
							scSetStatus("Step 2 · Tukar Potato -> Hot Chips...", Color3.fromRGB(200,200,200))
							scFirePrompt(Vector3.new(SC_TUKAR.x, SC_TUKAR.y, SC_TUKAR.z), nil)
							task.wait(0.4)
							if not SC.active then break end
						end

						-- Step 3: Equip Hot Chips
						scSetStatus("Step 3 · Equip Hot Chips...", Color3.fromRGB(200,200,200))
						scEquipTool("Hot Chips")
						if not SC.active then break end

						-- Step 4: Loop ke tiap Homeless
						for i = 1, visitCount do
							if not SC.active then break end

							local h = SC_HOMELESS[i]
							scSetStatus(("Jual · Homeless %d/%d"):format(i, visitCount), Color3.fromRGB(200,200,200))
							scInfoLbl.Text = ("Hot Chips: %d | %d/%d"):format(scCountChips("Hot Chips"), i, visitCount)

							doVehicleTP(CFrame.new(h.x, h.y, h.z))
							task.wait(0.25)
							if not SC.active then break end

							scEquipTool("Hot Chips")
							scFirePrompt(Vector3.new(h.x, h.y, h.z), nil)
							task.wait(0.2)
						end

						if not SC.active then break end

						-- Step 5: Cek sisa
						local remaining = scCountChips("Hot Chips")
						if remaining > 0 then
							scSetStatus(("Selesai %d homeless. Sisa %d Hot Chips → Chips Cook"):format(visitCount, remaining), Color3.fromRGB(200,200,200))
							scInfoLbl.Text = ("Sisa: %d Hot Chips"):format(remaining)
							doVehicleTP(CFrame.new(SC_COOK.x, SC_COOK.y, SC_COOK.z))
						else
							scSetStatus("Semua Hot Chips terjual!", Color3.fromRGB(200,200,200))
							scInfoLbl.Text = ""
						end

						SC.active = false
						refreshScBar()
					end

					SC.active = false
					refreshScBar()
					scInfoLbl.Text = ""
				end

				ScBar.MouseButton1Click:Connect(function()
					if SC.active then
						SC.active = false
						refreshScBar()
						scSetStatus("Dihentikan.", Color3.fromRGB(140,140,140))
						scInfoLbl.Text = ""
					else
						-- Validasi: harus naik vehicle
						local char = plr.Character
						local hum = char and char:FindFirstChildOfClass("Humanoid")
						local seat = hum and hum.SeatPart
						if not seat then
							scSetStatus("Naik vehicle dulu sebelum mulai!", Color3.fromRGB(180,180,180))
							return
						end
						SC.active = true
						refreshScBar()
						task.spawn(startSellChipsLoop)
					end
				end)


				-- ── INFO PAGE — FIX: tambah larangan jual + warning card diperbesar

				-- ================================================================
				-- AUTO FARM BOX
				-- ================================================================

				local boxDiv = Instance.new("Frame", PageFarm)
				boxDiv.Size = UDim2.new(1,0,0,1); boxDiv.BackgroundColor3 = Color3.fromRGB(30,30,30)
				boxDiv.BorderSizePixel = 0

				local boxHdr = Instance.new("TextLabel", PageFarm)
				boxHdr.Size = UDim2.new(1,0,0,20); boxHdr.BackgroundTransparency = 1
				boxHdr.Text = "AUTO FARM BOX — Loop Non-Stop"
				boxHdr.TextColor3 = T.TextDim
				boxHdr.Font = Enum.Font.GothamBlack; boxHdr.TextSize = 11

				local boxStatusLbl = Instance.new("TextLabel", PageFarm)
				boxStatusLbl.Size = UDim2.new(1,0,0,18); boxStatusLbl.BackgroundTransparency = 1
				boxStatusLbl.Text = ""; boxStatusLbl.TextColor3 = T.Accent
				boxStatusLbl.Font = Enum.Font.GothamBlack; boxStatusLbl.TextSize = 13

				local BoxBar = Instance.new("TextButton", PageFarm)
				BoxBar.Size = UDim2.new(1,0,0,36); BoxBar.BackgroundColor3 = T.Card
				BoxBar.Text = ""; BoxBar.AutoButtonColor = false
				Instance.new("UICorner", BoxBar).CornerRadius = UDim.new(0,8)
				local bbStr = Instance.new("UIStroke", BoxBar); bbStr.Color = T.Stroke; bbStr.Thickness = 1

				local boxNameLbl = Instance.new("TextLabel", BoxBar)
				boxNameLbl.Size = UDim2.new(1,-60,1,0); boxNameLbl.Position = UDim2.new(0,10,0,0)
				boxNameLbl.BackgroundTransparency = 1; boxNameLbl.Text = "Auto Farm Box"
				boxNameLbl.TextColor3 = T.TextDim; boxNameLbl.Font = Enum.Font.GothamBlack; boxNameLbl.TextSize = 16
				boxNameLbl.TextXAlignment = Enum.TextXAlignment.Left

				local boxPill = Instance.new("Frame", BoxBar)
				boxPill.Size = UDim2.new(0,46,0,22); boxPill.Position = UDim2.new(1,-52,0.5,-11)
				boxPill.BackgroundColor3 = Color3.fromRGB(20,20,20)
				Instance.new("UICorner", boxPill).CornerRadius = UDim.new(1,0)
				Instance.new("UIStroke", boxPill).Color = T.Stroke
				local boxPillLbl = Instance.new("TextLabel", boxPill)
				boxPillLbl.Size = UDim2.new(1,0,1,0); boxPillLbl.BackgroundTransparency = 1
				boxPillLbl.Text = "OFF"; boxPillLbl.TextColor3 = T.TextDim
				boxPillLbl.Font = Enum.Font.GothamBlack; boxPillLbl.TextSize = 15

				-- !! Ganti koordinat ini sesuai game !!
				local BOX_POS_A = CFrame.new(-551.47, 3.54, -84.97) -- titik A: posisi prompt ambil box
				local BOX_POS_B = CFrame.new(-401.96, 3.36, -70.98) -- titik B: posisi prompt deposit/kumpul
				local BOX_TWEEN_SPEED = 20

				local boxActive = false

				local function boxSetStatus(txt, col)
					boxStatusLbl.Text = txt; boxStatusLbl.TextColor3 = col or T.Accent
				end

				local function refreshBoxBar()
					local on = boxActive
					BoxBar.BackgroundColor3        = on and Color3.fromRGB(16,16,16) or T.Card
					boxNameLbl.TextColor3          = on and T.Text or T.TextDim
					boxPill.BackgroundColor3       = on and T.AccOn or Color3.fromRGB(20,20,20)
					boxPillLbl.Text                = on and "ON" or "OFF"
					boxPillLbl.TextColor3          = on and Color3.fromRGB(0,0,0) or T.TextDim
				end

				local function boxTweenTo(targetCF)
					local hrp2 = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
					if not hrp2 then return end
					local dist = (hrp2.Position - targetCF.Position).Magnitude
					local tw = TweenService:Create(hrp2,
						TweenInfo.new(math.max(dist / BOX_TWEEN_SPEED, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
						{CFrame = targetCF}
					)
					tw:Play()
					tw.Completed:Wait()
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
						local origDist = prompt.MaxActivationDistance
						local origLOS  = prompt.RequiresLineOfSight
						prompt.MaxActivationDistance = 9999
						prompt.RequiresLineOfSight   = false
						task.wait(0.05)
						fireproximityprompt(prompt)
						task.wait(0.1)
						prompt.MaxActivationDistance = origDist
						prompt.RequiresLineOfSight   = origLOS
					end)
				end

				local function boxLoop()
					while boxActive and Running do
						-- Tunggu respawn kalau mati
						local ch  = plr.Character
						local hum = ch and ch:FindFirstChildOfClass("Humanoid")
						if not ch or not hum or hum.Health <= 0 then
							boxSetStatus("Mati, menunggu respawn...", T.TextDim)
							local newChar = plr.CharacterAdded:Wait()
							newChar:WaitForChild("HumanoidRootPart", 10)
							task.wait(1)
							if not boxActive then break end
						end

						-- Step 1: tween ke A
						boxSetStatus("Menuju titik A...", T.Accent)
						boxTweenTo(BOX_POS_A)
						if not boxActive then break end
						task.wait(0.3)

						-- Step 2: fire prompt di A
						boxSetStatus("Interaksi di A...", T.Accent)
						local promptA = boxFindPromptNear(BOX_POS_A)
						if promptA then boxFirePrompt(promptA) end
						task.wait(0.5)
						if not boxActive then break end

						-- Step 3: tween ke B
						boxSetStatus("Menuju titik B...", T.Accent)
						boxTweenTo(BOX_POS_B)
						if not boxActive then break end
						task.wait(0.3)

						-- Step 4: equip Crate dari backpack
						boxSetStatus("Equip Crate...", T.Accent)
						local hum2 = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
						if hum2 then
							local crate = plr.Backpack:FindFirstChild("Crate") or plr.Backpack:FindFirstChild("crate")
							if crate then pcall(function() hum2:EquipTool(crate) end) end
						end
						task.wait(0.3)
						if not boxActive then break end

						-- Step 5: fire prompt di B
						boxSetStatus("Interaksi di B...", T.Accent)
						local promptB = boxFindPromptNear(BOX_POS_B)
						if promptB then boxFirePrompt(promptB) end
						task.wait(0.5)
					end

					boxSetStatus("Auto Farm Box dihentikan.", T.TextDim)
					task.delay(3, function()
						if boxStatusLbl.Text == "Auto Farm Box dihentikan." then
							boxStatusLbl.Text = ""
						end
					end)
				end

				BoxBar.MouseButton1Click:Connect(function()
					boxActive = not boxActive
					refreshBoxBar()
					if boxActive then
						task.spawn(boxLoop)
					end
				end)

				refreshBoxBar()
			end

			_buildInfo = function()
				-- ================================================================
				-- ================================================================
				-- COPY TOAST POPUP
				-- ================================================================
				local copyToast = Instance.new("Frame", Gui)
				copyToast.Size = UDim2.new(0, 220, 0, 36)
				copyToast.AnchorPoint = Vector2.new(0.5, 1)
				copyToast.Position = UDim2.new(0.5, 0, 1, 80)
				copyToast.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				copyToast.ZIndex = 200
				Instance.new("UICorner", copyToast).CornerRadius = UDim.new(0, 10)
				local cts = Instance.new("UIStroke", copyToast)
				cts.Color = Color3.fromRGB(60,60,60)
				cts.Thickness = 1
				local ctLbl = Instance.new("TextLabel", copyToast)
				ctLbl.Size = UDim2.new(1,0,1,0)
				ctLbl.BackgroundTransparency = 1
				ctLbl.Text = "Tersalin!"
				ctLbl.TextColor3 = Color3.fromRGB(0,220,100)
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
					Instance.new("UICorner", f).CornerRadius=UDim.new(0,8)
					local fStr = Instance.new("UIStroke", f)
					fStr.Color=T.Stroke

					local acc = Instance.new("Frame", f)
					acc.Size=UDim2.new(0,2,0,16)
					acc.Position=UDim2.new(0,0,0.5,-8)
					acc.BackgroundColor3=T.AccOn
					acc.BorderSizePixel=0
					Instance.new("UICorner", acc).CornerRadius=UDim.new(1,0)

					local iconLbl = Instance.new("TextLabel", f)
					iconLbl.Size=UDim2.new(0,22,1,0)
					iconLbl.Position=UDim2.new(0,10,0,0)
					iconLbl.BackgroundTransparency=1
					iconLbl.Text=icon
					iconLbl.TextColor3=T.TextDim
					iconLbl.Font=Enum.Font.GothamBlack
					iconLbl.TextSize=14

					local mainLbl = Instance.new("TextLabel", f)
					mainLbl.Size=UDim2.new(1,-100,0,18)
					mainLbl.Position=UDim2.new(0,34,0,4)
					mainLbl.BackgroundTransparency=1
					mainLbl.Text=label
					mainLbl.TextColor3=T.Text
					mainLbl.Font=Enum.Font.GothamBlack
					mainLbl.TextSize=13
					mainLbl.TextXAlignment=Enum.TextXAlignment.Left

					local subLbl = Instance.new("TextLabel", f)
					subLbl.Size=UDim2.new(1,-100,0,14)
					subLbl.Position=UDim2.new(0,34,0,22)
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
					copyPill.BackgroundColor3=Color3.fromRGB(22,22,22)
					Instance.new("UICorner", copyPill).CornerRadius=UDim.new(1,0)
					Instance.new("UIStroke", copyPill).Color=T.Stroke
					local copyLbl = Instance.new("TextLabel", copyPill)
					copyLbl.Size=UDim2.new(1,0,1,0)
					copyLbl.BackgroundTransparency=1
					copyLbl.Text="COPY"
					copyLbl.TextColor3=T.TextDim
					copyLbl.Font=Enum.Font.GothamBlack
					copyLbl.TextSize=11

					f.MouseButton1Click:Connect(function()
						pcall(function() setclipboard(copyValue) end)
						copyLbl.Text=""
						copyLbl.TextColor3=Color3.fromRGB(0,220,100)
						copyPill.BackgroundColor3=Color3.fromRGB(10,30,15)
						fStr.Color=Color3.fromRGB(0,120,60)
						showCopyToast(label)
						task.delay(2, function()
							copyLbl.Text="COPY"
							copyLbl.TextColor3=T.TextDim
							copyPill.BackgroundColor3=Color3.fromRGB(22,22,22)
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

				infoCard(PageInfo, "", "TikTok", "@lenger_store")
				infoCard(PageInfo, "", "Discord", "https://discord.gg/bfZb57QAk")

				-- Warning card — diperbesar jadi 116px untuk 3 baris
				local warn = Instance.new("Frame", PageInfo)
				warn.Size=UDim2.new(1,0,0,116)
				warn.BackgroundColor3=Color3.fromRGB(22,5,5)
				Instance.new("UICorner", warn).CornerRadius=UDim.new(0,10)
				local ws = Instance.new("UIStroke", warn)
				ws.Color=Color3.fromRGB(80,20,20)
				ws.Thickness=1

				local wl=Instance.new("TextLabel", warn)
				wl.Size=UDim2.new(1,-12,0,30)
				wl.Position=UDim2.new(0,6,0,4)
				wl.BackgroundTransparency=1
				wl.TextWrapped=true
				wl.Text="USE AT YOUR OWN RISK\nWe are not responsible for any bans."
				wl.TextColor3=Color3.fromRGB(255,100,100)
				wl.Font=Enum.Font.GothamBlack
				wl.TextSize=16

				local wl2 = Instance.new("TextLabel", warn)
				wl2.Size=UDim2.new(1,-12,0,22)
				wl2.Position=UDim2.new(0,6,0,42)
				wl2.BackgroundTransparency=1
				wl2.TextWrapped=true
				wl2.Text="DILARANG KERAS SHARING!!!"
				wl2.TextColor3=Color3.fromRGB(255,50,50)
				wl2.Font=Enum.Font.GothamBlack
				wl2.TextSize=17

				-- BARU: larangan jual kembali
				local wl3 = Instance.new("TextLabel", warn)
				wl3.Size=UDim2.new(1,-12,0,26)
				wl3.Position=UDim2.new(0,6,0,72)
				wl3.BackgroundTransparency=1
				wl3.TextWrapped=true
				wl3.Text="DILARANG MENJUAL KEMBALI SCRIPT INI!!!"
				wl3.TextColor3=Color3.fromRGB(255,180,0)
				wl3.Font=Enum.Font.GothamBlack
				wl3.TextSize=14

				-- ================================================================
				-- INSTANT INTERACT
				-- ================================================================
				local ic
				ic = game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
					if not Running then if ic then ic:Disconnect() end return end
					if Flags.InstantInteract then pcall(function() if prompt.HoldDuration>0 then prompt.HoldDuration=0.05 end end) end
				end)

				-- ================================================================
				-- INV SCAN — Object Pooling
				-- BillboardGui dibuat SEKALI per player, cuma ganti .Enabled + text di loop
				-- ================================================================
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
					-- update adornee tiap kali karakter respawn
					p.CharacterAdded:Connect(function(char)
						task.wait(0.1)
						local h = char:FindFirstChild("Head")
						if h and Inv_Tags[p] then Inv_Tags[p].Adornee = h end
					end)
					-- set adornee sekarang kalau karakter sudah ada
					local ch = p.Character
					if ch then
						local h = ch:FindFirstChild("Head")
						if h then it.Adornee = h end
					end
				end

				local function removeInvTag(p)
					if Inv_Tags[p] then Inv_Tags[p]:Destroy(); Inv_Tags[p] = nil end
				end

				-- Pre-create untuk player yang sudah ada
				for _, p in pairs(game.Players:GetPlayers()) do createInvTag(p) end
				game.Players.PlayerAdded:Connect(function(p)
					task.wait(1) -- tunggu karakter load
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
							-- Hide semua pas loading screen aktif
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

				-- ================================================================
				-- INFINITE STAMINA
			end

			_startLogic = function()

				local staminaConns = {} -- kept for cleanup compat
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

					-- ================================================================
					-- SPEED HACK (Hybrid Speed)
					-- ================================================================
					local HS_ANIM_SPEED  = 22   -- WalkSpeed nyata (animasi kaki wajar)
					local HS_FINAL_SPEED = 25   -- Target speed total
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

					-- Restore WalkSpeed ke 16 saat Speed Hack dimatiin
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
					-- ================================================================
					-- ── NoClip — logic HNDRIXX ─────────────────────────────────
					-- Cache GetChildren (direct parts), bypass getrawmetatable
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

					-- Metatable bypass (HNDRIXX style)
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

					-- Reset saat respawn
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

						-- ================================================================
						-- BLINK TP [T]
						-- ================================================================
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

						-- ================================================================
						-- RMB AIMLOCK
						-- ================================================================
						local RMB = false
						UIS.InputBegan:Connect(function(inp)
							if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=true end
						end)
						UIS.InputEnded:Connect(function(inp)
							if inp.UserInputType==Enum.UserInputType.MouseButton2 then RMB=false
								AimTarget=nil end
						end)

						-- ================================================================
						-- ESP OBJECT POOL — wiring PlayerAdded/Removing + pre-create
						-- ================================================================
						local ESP_MASAK_KW = {"water","sugar","gelatin","marshmallow"}
						local ESP_GUN_KW   = {"gun","pistol","rifle","ak","m4","uzi","revolver","shotgun","sniper","smg","weapon","knife","sword","blade"}

						-- Pre-create semua player yang sudah ada di server
						for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end
						game.Players.PlayerAdded:Connect(createESP)
						game.Players.PlayerRemoving:Connect(removeESP)

						-- Cache inventory/senjata — diupdate tiap 0.5s via Heartbeat (global lastScan, bukan per-player)
						-- ── ESP Cache (event-driven, hndrixx-style) ─────────────────
						-- Gak ada Heartbeat polling — semua update via ChildAdded/ChildRemoved
						local espCache = {}   -- [player] = {hasBahan, wName}
						local espConns = {}   -- [player] = {conn1, conn2, ...}

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
								-- Scan backpack
								local bp = p.Backpack
								if bp then
									for _, v in ipairs(bp:GetChildren()) do
										if v:IsA("Tool") then
											if isKW(v.Name) then hb = true end
										end
									end
								end
								-- Scan character children (bukan descendants)
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
							-- Build cache sekali saat connect
							rebuildCache(p)
							-- Watch backpack
							local bp = p.Backpack
							if bp then
								table.insert(conns, bp.ChildAdded:Connect(function() rebuildCache(p) end))
								table.insert(conns, bp.ChildRemoved:Connect(function() rebuildCache(p) end))
							end
							-- Watch character
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

						-- Init semua player yang sudah ada
						for _, p in ipairs(game.Players:GetPlayers()) do
							connectESPPlayer(p)
						end
						game.Players.PlayerAdded:Connect(connectESPPlayer)
						game.Players.PlayerRemoving:Connect(disconnectESPPlayer)

						-- ================================================================
						-- RENDER LOOP
						-- ================================================================
						local SKEL_BONES = {
							{"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
							{"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
							{"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
							{"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
							{"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
							{"RightUpperLeg","LeftUpperLeg"},
						}
						-- RaycastParams dibuat SEKALI, direuse tiap frame (bukan new tiap frame)
						local wpRayParams = RaycastParams.new()
						wpRayParams.FilterType = Enum.RaycastFilterType.Blacklist
						local renderConn
						renderConn = RunService.RenderStepped:Connect(function()
							if not Running then renderConn:Disconnect()
								FovCircle:Remove()
								SilentFovCircle:Remove()
								SilentLine:Remove()
								return end

							-- Saat loading screen aktif: sembunyiin semua visual
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

							-- ── Aimbot FOV Circle (putih) ─────────────────────────────
							FovCircle.Radius = AimFOV_Radius
							FovCircle.Visible = Flags.AimLock and ShowAimFOV
							-- posisi aimbot FOV diset nanti di bawah setelah aimbot logic

							-- ── Silent Aim FOV Circle (orange) + Tracer ────────────────
							do
								if SilentAim then
									-- PC mode: origin dari mouse. HP mode: origin dari tengah screen
									local saOrigin = SilentMode == "HP"
										and Vector2.new(vp.X / 2, vp.Y / 2)
										or mousePos

									-- Cari target TERDEKAT secara jarak dunia ke karakter kita
									local localRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
									local bestWorldD = math.huge
									local bestScreenPos = nil
									for _, p in pairs(game.Players:GetPlayers()) do
										if p == plr then continue end
										local ch = p.Character
										if not ch then continue end
										local hum = ch:FindFirstChildOfClass("Humanoid")
										local part = ch:FindFirstChild(saPart == "Head" and "Head" or "HumanoidRootPart")
										if not part or not hum or hum.Health <= 0 then continue end
										local sp, onScreen = cam:WorldToViewportPoint(part.Position)
										if not onScreen or sp.Z <= 0 then continue end
										local screenPos = Vector2.new(sp.X, sp.Y)
										-- Cek masih dalam FOV radius di layar
										if (saOrigin - screenPos).Magnitude > SilentFOV_Radius then continue end
										-- Sort by world distance ke kita
										local worldD = localRoot and (part.Position - localRoot.Position).Magnitude or math.huge
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
										-- Tracer ikut ShowSilentFOV
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
										local sp2 = cam:WorldToViewportPoint(AimTarget.Position)
										local cx, cy = vp.X/2, vp.Y/2
										local dx = (sp2.X - cx) / vp.X
										local dy = (sp2.Y - cy) / vp.Y
										targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
									else
										targetCF = CFrame.lookAt(cam.CFrame.Position, AimTarget.Position)
									end
									cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
									FovCircle.Color = Color3.fromRGB(220,50,50)
								else
									FovCircle.Color = Color3.fromRGB(255,255,255)
								end
							else
								if AimMode=="PC" and not RMB then AimTarget = nil end
								FovCircle.Color = Color3.fromRGB(255,255,255)
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
							-- Iter langsung dari ESP pool bukan GetPlayers() tiap frame
							for p, e in pairs(ESP) do
								local ch = p.Character
								local hum = ch and ch:FindFirstChildOfClass("Humanoid")
								local root = ch and ch:FindFirstChild("HumanoidRootPart")

								-- Early exit: validasi dasar
								if not anyESP or not ch or not hum or not root then _hideESP(e)
									continue end

								-- Z-CULLING: langsung skip kalau di belakang kamera — paling murah
								local pos3, onScreen = cam:WorldToViewportPoint(root.Position)
								if not onScreen or pos3.Z <= 0 then _hideESP(e)
									continue end

								-- DISTANCE CULLING
								local isDead = hum.Health <= 0
								if localRoot and (root.Position - localRoot.Position).Magnitude > ESPMaxDist then _hideESP(e)
									continue end

								-- Skeleton update tiap frame (no throttle) biar ga kedip
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

								-- Kalkulasi dimensi box 2D: reuse pos3 dari WorldToViewportPoint di atas
								local topPos = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
								local botPos = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
								local sY = math.abs(botPos.Y - topPos.Y)
								local sX = sY * 0.6
								local bx = pos3.X - sX / 2
								local by = math.min(topPos.Y, botPos.Y)

								-- Ambil dari cache (event-driven, bukan scan per-frame)
								local cache = espCache[p] or {hasBahan=false, wName=nil}
								local hasBahan = cache.hasBahan
								local wName    = cache.wName

								local W = isDead and Color3.fromRGB(220,50,50) or Color3.fromRGB(255,255,255)
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
					end


					-- expose ke _G untuk CONFIG tab
					_G.HNDRIXX_FLAGS = Flags
					_G.HNDRIXX_APARTMENTS = APARTMENTS
					_G.HNDRIXX_UPD_COOK = updateApartCook
					_G.HNDRIXX_APT_CONT = apartContainer
					_G.HNDRIXX_APT_ROWS = apartRows
					_G.HNDRIXX_APT_REFRESH= refreshApartRows
					_G.HNDRIXX_GETSTATE = function()
						return {Flags={BoxESP=Flags.BoxESP,Tracer=Flags.Tracer,ESPName=Flags.ESPName,ESPDist=Flags.ESPDist,ESPHPBar=Flags.ESPHPBar,ESPWeapon=Flags.ESPWeapon,ESPSkeleton=Flags.ESPSkeleton,ESPMasak=Flags.ESPMasak,TPNoClip=Flags.TPNoClip,AimLock=Flags.AimLock,WallCheck=Flags.WallCheck,InvScan=Flags.InvScan,InstantInteract=Flags.InstantInteract,InfStamina=Flags.InfStamina,HybridSpeed=Flags.HybridSpeed,AuraKill=Flags.AuraKill},AimFOV_Radius=AimFOV_Radius,AimMax_Dist=AimMax_Dist,TracerMaxDist=TracerMaxDist,ESPMaxDist=ESPMaxDist,AimSmooth=AimSmooth,AimPart=AimPart,AimMode=AimMode,BoxESPMode=BoxESPMode,BlinkMode=BlinkMode}
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

					-- Run semua
					_buildMain()
					_buildAim()
					_buildTP()
					_buildFarm()
					_buildInfo()
					_buildVehicle()
					_startLogic()

				end -- end launchMainScript

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
				-- L/R CAPSULE untuk apartment rows (jalan di luar launchMainScript)
				-- ================================================================
				task.defer(function()
					task.wait(2) -- tunggu UI + _G selesai
					local APTS = _G.HNDRIXX_APARTMENTS
					local updCook= _G.HNDRIXX_UPD_COOK
					local aptCont= _G.HNDRIXX_APT_CONT
					if not APTS or not aptCont then warn('[LR] aptCont nil!')
						return end
					warn('[LR] building capsules for '..#APTS..' apts')

					local W = Color3.fromRGB(255,255,255)
					local DG = Color3.fromRGB(28,28,28)
					local BK = Color3.fromRGB(0,0,0)
					local DM = Color3.fromRGB(85,85,85)

					-- Cari setiap ApartRow_ frame di aptCont
					for i, apart in ipairs(APTS) do
						local row = aptCont:FindFirstChild("ApartRow_"..i)
						if not row then continue end

						-- Skip kalau sudah ada capsule
						if row:FindFirstChild("LRCap") then continue end

						local cap = Instance.new("Frame", row)
						cap.Name = "LRCap"
						cap.Size = UDim2.new(0,50,0,20)
						cap.Position = UDim2.new(1,-148,0.5,-10)
						cap.BackgroundColor3 = Color3.fromRGB(18,18,18)
						Instance.new("UICorner",cap).CornerRadius = UDim.new(1,0)
						local capStr = Instance.new("UIStroke",cap)
						capStr.Color = Color3.fromRGB(30,30,30)

						local lB = Instance.new("TextButton",cap)
						lB.Name="LBtn"
						lB.Size=UDim2.new(0.5,0,1,0)
						lB.BackgroundColor3=DG
						lB.Text="L"
						lB.TextColor3=DM
						lB.Font=Enum.Font.GothamBlack
						lB.TextSize=12
						lB.AutoButtonColor=false
						Instance.new("UICorner",lB).CornerRadius=UDim.new(1,0)

						local rB = Instance.new("TextButton",cap)
						rB.Name="RBtn"
						rB.Size=UDim2.new(0.5,0,1,0)
						rB.Position=UDim2.new(0.5,0,0,0)
						rB.BackgroundColor3=DG
						rB.Text="R"
						rB.TextColor3=DM
						rB.Font=Enum.Font.GothamBlack
						rB.TextSize=12
						rB.AutoButtonColor=false
						Instance.new("UICorner",rB).CornerRadius=UDim.new(1,0)

						local function refreshLR(ap)
							local isL = ap.side ~= "R"
							lB.BackgroundColor3 = isL and W or DG
							lB.TextColor3 = isL and BK or DM
							rB.BackgroundColor3 = (not isL) and W or DG
							rB.TextColor3 = (not isL) and BK or DM
						end
						refreshLR(apart)

						local cap_apart = apart
						lB.MouseButton1Click:Connect(function()
							cap_apart.side="L"
							if updCook then updCook(cap_apart) end
							refreshLR(cap_apart)
						end)
						rB.MouseButton1Click:Connect(function()
							cap_apart.side="R"
							if updCook then updCook(cap_apart) end
							refreshLR(cap_apart)
						end)
					end
				end)


				-- ================================================================
				-- CONFIG TAB (jalan di luar launchMainScript biar ga exceed locals)
				-- ================================================================
				do
					local Http2 = game:GetService("HttpService")
					local CFG = "hndrixx_configs"
					local Page = _G.HNDRIXX_CONFIGPAGE
					local BtnCfg = _G.HNDRIXX_BTNCFG
					if not Page or not BtnCfg then return end
					pcall(function() if not isfolder(CFG) then makefolder(CFG) end end)

					local T2 = {
						Card = Color3.fromRGB(12,12,12),
						Stroke = Color3.fromRGB(30,30,30),
						TextDim = Color3.fromRGB(85,85,85),
						Text = Color3.fromRGB(255,255,255),
						AccOn = Color3.fromRGB(255,255,255),
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
					Instance.new("UICorner",iCard).CornerRadius=UDim.new(0,8)
					Instance.new("UIStroke",iCard).Color=T2.Stroke

					local inp=Instance.new("TextBox",iCard)
					inp.Size=UDim2.new(1,-100,1,-10)
					inp.Position=UDim2.new(0,8,0,5)
					inp.BackgroundColor3=Color3.fromRGB(20,20,20)
					inp.PlaceholderText="Nama config..."
					inp.PlaceholderColor3=Color3.fromRGB(70,70,70)
					inp.Text=""
					inp.TextColor3=Color3.fromRGB(255,255,255)
					inp.Font=Enum.Font.Gotham
					inp.TextSize=13
					inp.ClearTextOnFocus=false
					Instance.new("UICorner",inp).CornerRadius=UDim.new(0,6)
					Instance.new("UIStroke",inp).Color=Color3.fromRGB(50,50,50)

					local sBtn=Instance.new("TextButton",iCard)
					sBtn.Size=UDim2.new(0,80,1,-10)
					sBtn.Position=UDim2.new(1,-88,0,5)
					sBtn.BackgroundColor3=Color3.fromRGB(20,50,20)
					sBtn.Text="SAVE"
					sBtn.TextColor3=Color3.fromRGB(0,220,100)
					sBtn.Font=Enum.Font.GothamBlack
					sBtn.TextSize=13
					sBtn.AutoButtonColor=false
					Instance.new("UICorner",sBtn).CornerRadius=UDim.new(0,6)
					Instance.new("UIStroke",sBtn).Color=Color3.fromRGB(40,120,40)

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
							Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
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
							lb.BackgroundColor3=Color3.fromRGB(20,40,20)
							lb.Text="LOAD"
							lb.TextColor3=Color3.fromRGB(0,200,80)
							lb.Font=Enum.Font.GothamBlack
							lb.TextSize=12
							lb.AutoButtonColor=false
							Instance.new("UICorner",lb).CornerRadius=UDim.new(1,0)
							Instance.new("UIStroke",lb).Color=Color3.fromRGB(40,100,40)

							local db=Instance.new("TextButton",row)
							db.Size=UDim2.new(0,42,0,22)
							db.Position=UDim2.new(1,-52,0.5,-11)
							db.BackgroundColor3=Color3.fromRGB(40,10,10)
							db.Text="DEL"
							db.TextColor3=Color3.fromRGB(220,60,60)
							db.Font=Enum.Font.GothamBlack
							db.TextSize=12
							db.AutoButtonColor=false
							Instance.new("UICorner",db).CornerRadius=UDim.new(1,0)
							Instance.new("UIStroke",db).Color=Color3.fromRGB(100,30,30)

							local cap=name
							lb.MouseButton1Click:Connect(function()
								pcall(function()
									local d=Http2:JSONDecode(readfile(CFG.."/"..cap..".json"))
									if _G.HNDRIXX_SETSTATE then _G.HNDRIXX_SETSTATE(d) end
									-- Refresh UI: scan semua toggle bar dan update pill
									pcall(function()
										local Fl = _G.HNDRIXX_FLAGS
										if not Fl then return end
										local cg = game:GetService("CoreGui")
										for _, gui in ipairs(cg:GetChildren()) do
											if gui.Name == "HNDRIXX_Grey" then
												for _, bar in ipairs(gui:GetDescendants()) do
													if bar:IsA("TextButton") and bar.Name:sub(1,13) == "HNDRIXX_TOGGLE_" then
														local fName = bar.Name:sub(14)
														local on = Fl[fName]
														if on == nil then continue end
														bar.BackgroundColor3 = on and Color3.fromRGB(16,16,16) or Color3.fromRGB(12,12,12)
														local pill = bar:FindFirstChild("Frame")
														for _, c in ipairs(bar:GetChildren()) do
															if c:IsA("Frame") and c.Size == UDim2.new(0,46,0,22) then
																c.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(20,20,20)
																local lbl = c:FindFirstChildOfClass("TextLabel")
																if lbl then
																	lbl.Text = on and "ON" or "OFF"
																	lbl.TextColor3 = on and Color3.fromRGB(0,0,0) or Color3.fromRGB(85,85,85)
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
									setStatus("Deleted: "..cap,Color3.fromRGB(220,100,100))
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
				end


				-- [AutoBuySettings.DoBuy() dihapus — diganti doRemoteBuy via StorePurchase RemoteEvent]