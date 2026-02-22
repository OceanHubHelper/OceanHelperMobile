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
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- Startup Intro
--------------------------------------------------
local intro = Instance.new("Frame", gui)
intro.Size = UDim2.fromScale(1,1)
intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
intro.BackgroundTransparency = 1
intro.ZIndex = 100

local function introLabel(text, y, size, color)
	local t = Instance.new("TextLabel", intro)
	t.Size = UDim2.fromScale(1,0.12)
	t.Position = UDim2.fromScale(0.5,y)
	t.AnchorPoint = Vector2.new(0.5,0.5)
	t.BackgroundTransparency = 1
	t.Text = text
	t.Font = Enum.Font.GothamBlack
	t.TextSize = size
	t.TextTransparency = 1
	t.TextColor3 = color
	t.ZIndex = 101
	return t
end

local vx = introLabel("Vx", 0.44, 48, Color3.new(1,1,1))
local h2o = introLabel("H2o", 0.52, 20, Color3.fromRGB(160,180,255))
local ver = introLabel("v1.7", 0.59, 14, Color3.fromRGB(180,180,200))
local lagOn = introLabel("Anti-Lag: ON", 0.66, 14, Color3.fromRGB(120,255,140))

for _,l in ipairs({vx,h2o,ver,lagOn}) do
	TweenService:Create(l, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
end

task.delay(1.3, function()
	for _,l in ipairs({vx,h2o,ver,lagOn}) do
		TweenService:Create(l, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	end
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
-- Create Buttons (ALWAYS parented + high ZIndex)
--------------------------------------------------
local cam = workspace.CurrentCamera
local screen = cam.ViewportSize
local isPhone = UIS.TouchEnabled and math.min(screen.X, screen.Y) < 900
local SIZE = isPhone and 56 or 64
local GAP = isPhone and 10 or 8
local WIDE_W = (SIZE * 2) + GAP

local function makeBtn(txt, w, h)
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.fromOffset(w+10, h+10)
	frame.BackgroundColor3 = Color3.fromRGB(18,20,28)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.ZIndex = 50
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.fromOffset(w,h)
	btn.Position = UDim2.fromOffset(5,5)
	btn.BackgroundColor3 = Color3.fromRGB(28,30,40)
	btn.BorderSizePixel = 0
	btn.Text = txt
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.ZIndex = 51
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)

	return frame, btn
end

local ZCard, Z = makeBtn("Left Base", SIZE, SIZE)
local CCard, C = makeBtn("Right Base", SIZE, SIZE)
local XCard, X = makeBtn("Bat Aimbot", WIDE_W, SIZE)
local NCard, N = makeBtn("Rotater", WIDE_W, SIZE)

local function setPositions()
	if isPhone then
		local cx = screen.X - WIDE_W - 12
		local cy = screen.Y * 0.55
		XCard.Position = UDim2.fromOffset(cx, cy - SIZE - GAP)
		ZCard.Position = UDim2.fromOffset(cx, cy)
		CCard.Position = UDim2.fromOffset(cx + SIZE + GAP, cy)
		NCard.Position = UDim2.fromOffset(cx, cy + SIZE + GAP)
	else
		local bx = screen.X - 360
		local by = screen.Y - 260
		XCard.Position = UDim2.fromOffset(bx, by - SIZE - GAP)
		ZCard.Position = UDim2.fromOffset(bx, by)
		CCard.Position = UDim2.fromOffset(bx + SIZE + GAP, by)
		NCard.Position = UDim2.fromOffset(bx, by + SIZE + GAP)
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
-- Menu (+ / -) + Toggles (guaranteed)
--------------------------------------------------
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromScale(1,1)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 0.35
menu.Visible = false
menu.ZIndex = 10

local panel = Instance.new("Frame", menu)
panel.Size = UDim2.fromOffset(340, 360)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(20,22,30)
panel.BorderSizePixel = 0
panel.ZIndex = 11
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.fromOffset(260, 30)
title.Position = UDim2.fromOffset(16, 8)
title.BackgroundTransparency = 1
title.Text = "Ocean Hub Mobile Helper"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 12

local credit = Instance.new("TextLabel", panel)
credit.Size = UDim2.fromOffset(260, 18)
credit.Position = UDim2.fromOffset(16, 36)
credit.BackgroundTransparency = 1
credit.Text = "H2o · v1.7"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(160,170,190)
credit.ZIndex = 12

local function toggleRow(name, y, card)
	local row = Instance.new("Frame", panel)
	row.Size = UDim2.fromOffset(300, 36)
	row.Position = UDim2.fromOffset(20, y)
	row.BackgroundTransparency = 1
	row.ZIndex = 12

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.fromScale(0.6,1)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.ZIndex = 12

	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.fromOffset(64, 26)
	btn.Position = UDim2.fromScale(1,0.5)
	btn.AnchorPoint = Vector2.new(1,0.5)
	btn.Text = "OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
	btn.TextColor3 = Color3.fromRGB(255,120,120)
	btn.ZIndex = 12
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

	btn.MouseButton1Click:Connect(function()
		local on = not card.Visible
		card.Visible = on
		btn.Text = on and "ON" or "OFF"
		btn.TextColor3 = on and Color3.fromRGB(120,255,140) or Color3.fromRGB(255,120,120)
	end)
end

toggleRow("Left Base (Z)", 70, ZCard)
toggleRow("Right Base (C)", 110, CCard)
toggleRow("Bat Aimbot (X)", 150, XCard)
toggleRow("Rotater (N)", 190, NCard)

local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.fromOffset(32, 32)
reopen.Position = UDim2.fromOffset(12, screen.Y - 44)
reopen.Text = "+"
reopen.Font = Enum.Font.GothamBlack
reopen.TextSize = 18
reopen.BackgroundColor3 = Color3.fromRGB(40,40,55)
reopen.TextColor3 = Color3.fromRGB(200,200,200)
reopen.ZIndex = 60
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0,10)

reopen.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)
