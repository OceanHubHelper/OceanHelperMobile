local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VxMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Intro splash
do
	local intro = Instance.new("Frame", gui)
	intro.Size = UDim2.fromScale(1,1)
	intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
	intro.BackgroundTransparency = 1
	intro.ZIndex = 50

	local title = Instance.new("TextLabel", intro)
	title.Size = UDim2.fromScale(1,1)
	title.BackgroundTransparency = 1
	title.Text = "VxMenu"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 56
	title.TextColor3 = Color3.new(1,1,1)
	title.TextTransparency = 1
	title.TextStrokeTransparency = 1
	title.ZIndex = 51

	TweenService:Create(intro, TweenInfo.new(0.35), {BackgroundTransparency = 0.4}):Play()
	TweenService:Create(title, TweenInfo.new(0.35), {TextTransparency = 0, TextStrokeTransparency = 0.6}):Play()
	task.wait(0.9)
	TweenService:Create(intro, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, TweenInfo.new(0.45), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	task.wait(0.45)
	intro:Destroy()
end

local cam = workspace.CurrentCamera
local screen = cam.ViewportSize
local isPhone = UIS.TouchEnabled and math.min(screen.X, screen.Y) < 900

local SIZE = isPhone and 56 or 64
local GAP = isPhone and 10 or 8
local WIDE_W = (SIZE * 2) + GAP

-- Hotbar indicator
local hotbar = Instance.new("TextLabel", gui)
hotbar.Size = UDim2.fromOffset(300,36)
hotbar.AnchorPoint = Vector2.new(0.5,1)
hotbar.Position = isPhone
	and (UDim2.fromScale(0.5,1) - UDim2.fromOffset(0,120))
	or  (UDim2.fromScale(0.5,1) - UDim2.fromOffset(0,90))
hotbar.BackgroundTransparency = 1
hotbar.Text = "Idle"
hotbar.Font = Enum.Font.GothamBold
hotbar.TextSize = isPhone and 16 or 18
hotbar.TextColor3 = Color3.new(1,1,1)
hotbar.TextStrokeTransparency = 0.6

local function makeBtn(txt, w, h)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(w, h)
	b.Text = ""
	b.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
	b.BackgroundTransparency = 0.15
	b.BorderSizePixel = 0
	b.AutoButtonColor = false
	b.Active = true
	b.Parent = gui

	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(160, 170, 190)
	s.Transparency = 0.5

	local l = Instance.new("TextLabel", b)
	l.Size = UDim2.fromScale(1,1)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.Font = Enum.Font.GothamBold
	l.TextSize = isPhone and 13 or 14
	l.TextWrapped = true
	l.TextColor3 = Color3.fromRGB(240,240,240)

	b.MouseButton1Down:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {Size = UDim2.fromOffset(w - 5, h - 5)}):Play()
	end)
	b.MouseButton1Up:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {Size = UDim2.fromOffset(w, h)}):Play()
	end)

	return b
end

local Z = makeBtn("Left\nBase", SIZE, SIZE)
local C = makeBtn("Right\nBase", SIZE, SIZE)
local X = makeBtn("Bat Aimbot", WIDE_W, SIZE)
local N = makeBtn("Rotater", WIDE_W, SIZE)

if isPhone then
	-- pushed to far right for phones (moved UP)
	local cx = screen.X - WIDE_W - 6
	local cy = (screen.Y * 0.55) - 40  -- moved up

	X.Position = UDim2.fromOffset(cx, cy - SIZE - GAP)
	Z.Position = UDim2.fromOffset(cx, cy)
	C.Position = UDim2.fromOffset(cx + SIZE + GAP, cy)
	N.Position = UDim2.fromOffset(cx, cy + SIZE + GAP)
else
	-- bottom-right for tablets (moved UP)
	local jumpX = screen.X - 300
	local jumpY = screen.Y - 340  -- moved up

	X.Position = UDim2.fromOffset(jumpX - WIDE_W/2, jumpY - SIZE - GAP)
	Z.Position = UDim2.fromOffset(jumpX - SIZE - GAP/2, jumpY)
	C.Position = UDim2.fromOffset(jumpX + GAP/2, jumpY)
	N.Position = UDim2.fromOffset(jumpX - WIDE_W/2, jumpY + SIZE + GAP)
end

local function press(k) pcall(function() keypress(k) end) end
local function release(k) pcall(function() keyrelease(k) end) end

Z.MouseButton1Down:Connect(function() hotbar.Text = "Left Base (Z)"; press(Enum.KeyCode.Z) end)
Z.MouseButton1Up:Connect(function() release(Enum.KeyCode.Z) end)

local aimbotOn = false
X.MouseButton1Down:Connect(function()
	aimbotOn = not aimbotOn
	hotbar.Text = aimbotOn and "Bat Aimbot: ON (X)" or "Bat Aimbot: OFF (X)"
	X.BackgroundTransparency = aimbotOn and 0.05 or 0.15
	press(Enum.KeyCode.X)
end)
X.MouseButton1Up:Connect(function() release(Enum.KeyCode.X) end)

C.MouseButton1Down:Connect(function() hotbar.Text = "Right Base (C)"; press(Enum.KeyCode.C) end)
C.MouseButton1Up:Connect(function() release(Enum.KeyCode.C) end)

N.MouseButton1Down:Connect(function() hotbar.Text = "Rotater (N)"; press(Enum.KeyCode.N) end)
N.MouseButton1Up:Connect(function() release(Enum.KeyCode.N) end)
