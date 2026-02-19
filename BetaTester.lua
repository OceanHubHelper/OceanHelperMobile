local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "OceanHubMobileHelper"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== Layout helpers =====
local cam = workspace.CurrentCamera
local screen = cam.ViewportSize
local isPhone = UIS.TouchEnabled and math.min(screen.X, screen.Y) < 900
local SIZE = isPhone and 56 or 64
local GAP = isPhone and 10 or 8
local WIDE_W = (SIZE * 2) + GAP

-- ===== Button wrapper (subtle background card) =====
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

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(160, 170, 190)
	stroke.Transparency = 0.5

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

-- ===== Buttons =====
local ZCard, Z = makeCardButton("Left\nBase", SIZE, SIZE)
local CCard, C = makeCardButton("Right\nBase", SIZE, SIZE)
local XCard, X = makeCardButton("Bat Aimbot", WIDE_W, SIZE)
local NCard, N = makeCardButton("Rotater", WIDE_W, SIZE)

-- ===== Positions (VxMenu config layout) =====
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

-- ===== Key emulation =====
local function press(k) pcall(function() keypress(k) end) end
local function release(k) pcall(function() keyrelease(k) end) end

Z.MouseButton1Down:Connect(function() press(Enum.KeyCode.Z) end)
Z.MouseButton1Up:Connect(function() release(Enum.KeyCode.Z) end)
C.MouseButton1Down:Connect(function() press(Enum.KeyCode.C) end)
C.MouseButton1Up:Connect(function() release(Enum.KeyCode.C) end)
X.MouseButton1Click:Connect(function() press(Enum.KeyCode.X); release(Enum.KeyCode.X) end)
N.MouseButton1Click:Connect(function() press(Enum.KeyCode.N); release(Enum.KeyCode.N) end)

-- ===== Startup Menu =====
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromScale(1,1)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 0.35

local panel = Instance.new("Frame", menu)
panel.Size = UDim2.fromOffset(320, 280)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(20,22,30)
panel.BorderSizePixel = 0
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.fromOffset(220, 36)
title.Position = UDim2.fromOffset(16, 10)
title.BackgroundTransparency = 1
title.Text = "Ocean Hub Mobile Helper"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1,1,1)

-- Minimize button (-)
local minimize = Instance.new("TextButton", panel)
minimize.Size = UDim2.fromOffset(28, 28)
minimize.Position = UDim2.fromOffset(320 - 44, 12)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBlack
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(40,40,55)
minimize.TextColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

minimize.MouseButton1Click:Connect(function()
	menu.Visible = false
end)

-- Re-open button (+)
local reopen = Instance.new("TextButton", gui)
reopen.Size = UDim2.fromOffset(32, 32)
reopen.Position = UDim2.fromOffset(12, screen.Y - 44)
reopen.Text = "+"
reopen.Font = Enum.Font.GothamBlack
reopen.TextSize = 18
reopen.BackgroundColor3 = Color3.fromRGB(40,40,55)
reopen.TextColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 10)

reopen.MouseButton1Click:Connect(function()
	menu.Visible = true
end)

-- Toggles
local function makeToggle(name, y, card)
	local row = Instance.new("Frame", panel)
	row.Size = UDim2.fromOffset(280, 36)
	row.Position = UDim2.fromOffset(20, y)
	row.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.fromScale(0.6,1)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(220,220,220)

	local btn = Instance.new("TextButton", row)
	btn.Size = UDim2.fromOffset(64, 26)
	btn.Position = UDim2.fromScale(1,0.5)
	btn.AnchorPoint = Vector2.new(1,0.5)
	btn.Text = "OFF"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
	btn.TextColor3 = Color3.fromRGB(255,120,120)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

	local on = false
	btn.MouseButton1Click:Connect(function()
		on = not on
		btn.Text = on and "ON" or "OFF"
		btn.TextColor3 = on and Color3.fromRGB(120,255,140) or Color3.fromRGB(255,120,120)
		btn.BackgroundColor3 = on and Color3.fromRGB(35,60,45) or Color3.fromRGB(40,40,55)
		card.Visible = on
	end)
end

makeToggle("Left Base Button", 64, ZCard)
makeToggle("Right Base Button", 104, CCard)
makeToggle("Bat Aimbot Button", 144, XCard)
makeToggle("Rotater Button", 184, NCard)
