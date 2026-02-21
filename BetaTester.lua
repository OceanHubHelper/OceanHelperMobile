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

-- ===== Key emulation helpers =====
local function pressKey(key)
	pcall(function()
		if keypress then keypress(key)
		elseif keypress2 then keypress2(key) end
	end)
end
local function releaseKey(key)
	pcall(function()
		if keyrelease then keyrelease(key)
		elseif keyrelease2 then keyrelease2(key) end
	end)
end

-- ===== FPS Counter (toggleable) =====
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.fromOffset(110, 28)
fpsLabel.Position = UDim2.fromScale(1, 0) - UDim2.fromOffset(120, -8)
fpsLabel.BackgroundTransparency = 0.35
fpsLabel.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
fpsLabel.BorderSizePixel = 0
fpsLabel.Text = "FPS: --"
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
fpsLabel.Visible = false
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 8)

do
	local frames, last = 0, tick()
	RunService.RenderStepped:Connect(function()
		frames += 1
		local now = tick()
		if now - last >= 1 then
			local fps = math.floor(frames / (now - last))
			frames, last = 0, now
			fpsLabel.Text = "FPS: " .. fps
			fpsLabel.TextColor3 = (fps < 10) and Color3.fromRGB(255,90,90) or Color3.fromRGB(120,255,140)
		end
	end)
end

-- ===== Layout helpers =====
local cam = workspace.CurrentCamera
local screen = cam.ViewportSize
local isPhone = UIS.TouchEnabled and math.min(screen.X, screen.Y) < 900
local SIZE = isPhone and 56 or 64
local GAP = isPhone and 10 or 8
local WIDE_W = (SIZE * 2) + GAP

-- ===== Button factory =====
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

-- ===== Buttons =====
local ZCard, Z = makeCardButton("Left\nBase", SIZE, SIZE)
local CCard, C = makeCardButton("Right\nBase", SIZE, SIZE)
local XCard, X = makeCardButton("Bat Aimbot", WIDE_W, SIZE)
local NCard, N = makeCardButton("Rotater", WIDE_W, SIZE)

-- ===== Positions =====
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

-- ===== Key bindings =====
Z.MouseButton1Down:Connect(function() pressKey(Enum.KeyCode.Z) end)
Z.MouseButton1Up:Connect(function() releaseKey(Enum.KeyCode.Z) end)
C.MouseButton1Down:Connect(function() pressKey(Enum.KeyCode.C) end)
C.MouseButton1Up:Connect(function() releaseKey(Enum.KeyCode.C) end)
X.MouseButton1Click:Connect(function() pressKey(Enum.KeyCode.X); releaseKey(Enum.KeyCode.X) end)
N.MouseButton1Click:Connect(function() pressKey(Enum.KeyCode.N); releaseKey(Enum.KeyCode.N) end)

-- ===== Menu (+ / -) =====
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.fromScale(1,1)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BackgroundTransparency = 0.35
menu.Visible = false

local panel = Instance.new("Frame", menu)
panel.Size = UDim2.fromOffset(340, 360)
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
credit.Text = "H2o"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.TextColor3 = Color3.fromRGB(160, 170, 190)

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

-- ===== State + Toggles =====
local state = { Z=false, C=false, X=false, N=false, FPS=false }

local function makeToggle(name, y, key)
	local row = Instance.new("Frame", panel)
	row.Size = UDim2.fromOffset(300, 36)
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

	btn.MouseButton1Click:Connect(function()
		state[key] = not state[key]
		btn.Text = state[key] and "ON" or "OFF"
		btn.TextColor3 = state[key] and Color3.fromRGB(120,255,140) or Color3.fromRGB(255,120,120)
		btn.BackgroundColor3 = state[key] and Color3.fromRGB(35,60,45) or Color3.fromRGB(40,40,55)
		if key=="Z" then ZCard.Visible = state[key] end
		if key=="C" then CCard.Visible = state[key] end
		if key=="X" then XCard.Visible = state[key] end
		if key=="N" then NCard.Visible = state[key] end
		if key=="FPS" then fpsLabel.Visible = state[key] end
	end)
end

makeToggle("Left Base Button", 64, "Z")
makeToggle("Right Base Button", 104, "C")
makeToggle("Bat Aimbot Button", 144, "X")
makeToggle("Rotater Button", 184, "N")
makeToggle("FPS Counter", 224, "FPS")
