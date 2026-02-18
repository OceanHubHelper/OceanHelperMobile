local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VxMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Intro splash
do
	local intro = Instance.new("Frame")
	intro.Size = UDim2.fromScale(1,1)
	intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
	intro.BackgroundTransparency = 1
	intro.ZIndex = 50
	intro.Parent = gui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromScale(1,1)
	title.BackgroundTransparency = 1
	title.Text = "VxMenu"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 64
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextTransparency = 1
	title.TextStrokeTransparency = 1
	title.ZIndex = 51
	title.Parent = intro

	TweenService:Create(intro, TweenInfo.new(0.4), {BackgroundTransparency = 0.35}):Play()
	TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0, TextStrokeTransparency = 0.6}):Play()
	task.wait(1)
	TweenService:Create(intro, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	task.wait(0.5)
	intro:Destroy()
end

local cam = workspace.CurrentCamera
local screen = cam.ViewportSize

local SIZE = 64
local GAP = 8
local WIDE_W = (SIZE * 2) + GAP

-- Hotbar indicator
local hotbar = Instance.new("TextLabel")
hotbar.Size = UDim2.fromOffset(300,36)
hotbar.AnchorPoint = Vector2.new(0.5,1)
hotbar.Position = UDim2.fromScale(0.5,1) - UDim2.fromOffset(0,90)
hotbar.BackgroundTransparency = 1
hotbar.Text = "Idle"
hotbar.Font = Enum.Font.GothamBold
hotbar.TextSize = 18
hotbar.TextColor3 = Color3.new(1,1,1)
hotbar.TextStrokeTransparency = 0.6
hotbar.Parent = gui

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

	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0, 14)

	local stroke = Instance.new("UIStroke", b)
	stroke.Color = Color3.fromRGB(160, 170, 190)
	stroke.Thickness = 1
	stroke.Transparency = 0.5

	local shadow = Instance.new("Frame", b)
	shadow.Size = UDim2.fromScale(1,1)
	shadow.Position = UDim2.fromOffset(2, 2)
	shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
	shadow.BackgroundTransparency = 0.7
	shadow.ZIndex = b.ZIndex - 1
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

	local l = Instance.new("TextLabel", b)
	l.Size = UDim2.fromScale(1,1)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.Font = Enum.Font.GothamBold
	l.TextSize = 14
	l.TextWrapped = true
	l.TextColor3 = Color3.fromRGB(240,240,240)
	l.TextXAlignment = Enum.TextXAlignment.Center
	l.TextYAlignment = Enum.TextYAlignment.Center

	b.MouseButton1Down:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {Size = UDim2.fromOffset(w - 6, h - 6)}):Play()
	end)
	b.MouseButton1Up:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {Size = UDim2.fromOffset(w, h)}):Play()
	end)

	return b
end

-- Cluster placement (moved left + up)
local jumpX = screen.X - 300
local jumpY = screen.Y - 300

local Z = makeBtn("Left\nBase", SIZE, SIZE)
local C = makeBtn("Right\nBase", SIZE, SIZE)
local X = makeBtn("Bat Aimbot", WIDE_W, SIZE)
local N = makeBtn("Rotater", WIDE_W, SIZE)

X.Position = UDim2.fromOffset(jumpX - WIDE_W/2, jumpY - SIZE - GAP)
Z.Position = UDim2.fromOffset(jumpX - SIZE - GAP/2, jumpY)
C.Position = UDim2.fromOffset(jumpX + GAP/2, jumpY)
N.Position = UDim2.fromOffset(jumpX - WIDE_W/2, jumpY + SIZE + GAP)

local function press(k) pcall(function() keypress(k) end) end
local function release(k) pcall(function() keyrelease(k) end) end

Z.MouseButton1Down:Connect(function()
	hotbar.Text = "Left Base (Z)"
	press(Enum.KeyCode.Z)
end)
Z.MouseButton1Up:Connect(function() release(Enum.KeyCode.Z) end)

local aimbotOn = false
X.MouseButton1Down:Connect(function()
	aimbotOn = not aimbotOn
	if aimbotOn then
		hotbar.Text = "Bat Aimbot: ON (X)"
		X.BackgroundTransparency = 0.05
	else
		hotbar.Text = "Bat Aimbot: OFF (X)"
		X.BackgroundTransparency = 0.15
	end
	press(Enum.KeyCode.X)
end)
X.MouseButton1Up:Connect(function() release(Enum.KeyCode.X) end)

C.MouseButton1Down:Connect(function()
	hotbar.Text = "Right Base (C)"
	press(Enum.KeyCode.C)
end)
C.MouseButton1Up:Connect(function() release(Enum.KeyCode.C) end)

N.MouseButton1Down:Connect(function()
	hotbar.Text = "Rotater (N)"
	press(Enum.KeyCode.N)
end)
N.MouseButton1Up:Connect(function() release(Enum.KeyCode.N) end)
