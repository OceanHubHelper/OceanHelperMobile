-- VxMenu v1.7 | Ocean Hub Mobile Helper | H2o

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "OceanHubMobileHelper"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- Startup Intro
--------------------------------------------------
local intro = Instance.new("Frame", gui)
intro.Size = UDim2.fromScale(1,1)
intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
intro.BackgroundTransparency = 1

local vx = Instance.new("TextLabel", intro)
vx.Size = UDim2.fromScale(1,0.2)
vx.Position = UDim2.fromScale(0.5,0.45)
vx.AnchorPoint = Vector2.new(0.5,0.5)
vx.BackgroundTransparency = 1
vx.Text = "Vx"
vx.Font = Enum.Font.GothamBlack
vx.TextSize = 48
vx.TextTransparency = 1
vx.TextColor3 = Color3.new(1,1,1)

local h2o = Instance.new("TextLabel", intro)
h2o.Size = UDim2.fromScale(1,0.1)
h2o.Position = UDim2.fromScale(0.5,0.53)
h2o.AnchorPoint = Vector2.new(0.5,0.5)
h2o.BackgroundTransparency = 1
h2o.Text = "H2o"
h2o.Font = Enum.Font.Gotham
h2o.TextSize = 20
h2o.TextTransparency = 1
h2o.TextColor3 = Color3.fromRGB(160,180,255)

local version = Instance.new("TextLabel", intro)
version.Size = UDim2.fromScale(1,0.08)
version.Position = UDim2.fromScale(0.5,0.61)
version.AnchorPoint = Vector2.new(0.5,0.5)
version.BackgroundTransparency = 1
version.Text = "v1.7"
version.Font = Enum.Font.GothamBold
version.TextSize = 14
version.TextTransparency = 1
version.TextColor3 = Color3.fromRGB(180,180,200)

local lagOn = Instance.new("TextLabel", intro)
lagOn.Size = UDim2.fromScale(1,0.08)
lagOn.Position = UDim2.fromScale(0.5,0.68)
lagOn.AnchorPoint = Vector2.new(0.5,0.5)
lagOn.BackgroundTransparency = 1
lagOn.Text = "Anti-Lag: ON"
lagOn.Font = Enum.Font.GothamBold
lagOn.TextSize = 14
lagOn.TextTransparency = 1
lagOn.TextColor3 = Color3.fromRGB(120,255,140)

TweenService:Create(vx, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
TweenService:Create(h2o, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
TweenService:Create(version, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
TweenService:Create(lagOn, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

task.delay(1.3, function()
	TweenService:Create(vx, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(h2o, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(version, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(lagOn, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	task.delay(0.5, function() intro:Destroy() end)
end)

--------------------------------------------------
-- Anti-Lag (Safe)
--------------------------------------------------
pcall(function()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e6
	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("PostEffect") then v.Enabled = false end
	end
end)

for _,d in ipairs(workspace:GetDescendants()) do
	if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
		d.Enabled = false
	end
end

--------------------------------------------------
-- Key emulation helpers
--------------------------------------------------
local function pressKey(key)
	pcall(function() if keypress then keypress(key) end end)
end
local function releaseKey(key)
	pcall(function() if keyrelease then keyrelease(key) end end)
end

--------------------------------------------------
-- Layout helpers
--------------------------------------------------
local cam = workspace.CurrentCamera
local screen = cam.ViewportSize
local isPhone = UIS.TouchEnabled and math.min(screen.X, screen.Y) < 900
local SIZE = isPhone and 56 or 64
local GAP = isPhone and 10 or 8
local WIDE_W = (SIZE * 2) + GAP

local function makeCardButton(txt, w, h)
	local card = Instance.new("Frame")
	card.Size = UDim2.fromOffset(w + 10, h + 10)
	card.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	card.BackgroundTransparency = 0.15
	card.BorderSizePixel = 0
	card.Visible = false
	card.Parent = gui
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(w, h)
	btn.Position = UDim2.fromOffset(5, 5)
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
	btn.BackgroundTransparency = 0.1
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Active = true
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

	local label = Instance.new("TextLabel", btn)
	label.Size = UDim2.fromScale(1,1)
	label.BackgroundTransparency = 1
	label.Text = txt
	label.Font = Enum.Font.GothamBold
	label.TextSize = isPhone and 13 or 14
	label.TextWrapped = true
	label.TextColor3 = Color3.fromRGB(240,240,240)

	return card, btn
end

local ZCard, Z = makeCardButton("Left\nBase", SIZE, SIZE)
local CCard, C = makeCardButton("Right\nBase", SIZE, SIZE)
local XCard, X = makeCardButton("Bat Aimbot", WIDE_W, SIZE)
local NCard, N = makeCardButton("Rotater", WIDE_W, SIZE)

local function setPositions()
	if isPhone then
		local cx = screen.X - WIDE_W - 6
		local cy = (screen.Y * 0.55) - 70
		XCard.Position = UDim2.fromOffset(cx, cy - SIZE - GAP - 5)
		ZCard.Position = UDim2.fromOffset(cx - 5, cy - 5)
		CCard.Position = UDim2.fromOffset(cx + SIZE + GAP - 5, cy - 5)
		NCard.Position = UDim2.fromOffset(cx, cy + SIZE + GAP - 5)
	else
		local jumpX = screen.X - 300
		local jumpY = screen.Y - 300
		XCard.Position = UDim2.fromOffset(jumpX - WIDE_W/2 - 5, jumpY - SIZE - GAP - 5)
		ZCard.Position = UDim2.fromOffset(jumpX - SIZE - GAP/2 - 5, jumpY - 5)
		CCard.Position = UDim2.fromOffset(jumpX + GAP/2 - 5, jumpY - 5)
		NCard.Position = UDim2.fromOffset(jumpX - WIDE_W/2 - 5, jumpY + SIZE + GAP - 5)
	end
end
setPositions()

Z.MouseButton1Down:Connect(function() pressKey(Enum.KeyCode.Z) end)
Z.MouseButton1Up:Connect(function() releaseKey(Enum.KeyCode.Z) end)
C.MouseButton1Down:Connect(function() pressKey(Enum.KeyCode.C) end)
C.MouseButton1Up:Connect(function() releaseKey(Enum.KeyCode.C) end)
X.MouseButton1Click:Connect(function() pressKey(Enum.KeyCode.X); releaseKey(Enum.KeyCode.X) end)
N.MouseButton1Click:Connect(function() pressKey(Enum.KeyCode.N); releaseKey(Enum.KeyCode.N) end)

--------------------------------------------------
-- Menu (+ / -)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromScale(1,1)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 0.35
menu.Visible = false

local panel = Instance.new("Frame", menu)
panel.Size = UDim2.fromOffset(340, 340)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(20,22,30)
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.fromOffset(260, 30)
title.Position = UDim2.fromOffset(16, 8)
title.BackgroundTransparency = 1
title.Text = "Ocean Hub Mobile Helper"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1,1,1)

local credit = Instance.new("TextLabel", panel)
credit.Size = UDim2.fromOffset(260, 18)
credit.Position = UDim2.fromOffset(16, 36)
credit.BackgroundTransparency = 1
credit.Text = "H2o · v1.7"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.TextColor3 = Color3.fromRGB(160,170,190)

local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.fromOffset(28, 28)
minimize.Position = UDim2.fromOffset(340 - 44, 12)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBlack
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(40,40,55)
minimize.TextColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)
minimize.MouseButton1Click:Connect(function() menu.Visible = false end)

local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.fromOffset(32, 32)
reopen.Position = UDim2.fromOffset(12, screen.Y - 44)
reopen.Text = "+"
reopen.Font = Enum.Font.GothamBlack
reopen.TextSize = 18
reopen.BackgroundColor3 = Color3.fromRGB(40,40,55)
reopen.TextColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 10)
reopen.MouseButton1Click:Connect(function() menu.Visible = true end)

-- Toggles omitted for brevity (same as your last working version)
