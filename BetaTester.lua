-- Ocean Hub Mobile Helper | VxMenu v1.7 | H2o

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

-- ===== Key emulation helpers (FIXED) =====
local function _press(key)
	if typeof(key) == "EnumItem" then
		pcall(function()
			if keypress then keypress(key)
			elseif keypress2 then keypress2(key)
			elseif syn and syn.keypress then syn.keypress(key) end
		end)
	end
end

local function _release(key)
	if typeof(key) == "EnumItem" then
		pcall(function()
			if keyrelease then keyrelease(key)
			elseif keyrelease2 then keyrelease2(key)
			elseif syn and syn.keyrelease then syn.keyrelease(key) end
		end)
	end
end

-- ===== FPS Counter =====
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
	local card = Instance.new("Frame", gui)
	card.Size = UDim2.fromOffset(w + 10, h + 10)
	card.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	card.BackgroundTransparency = 0.15
	card.BorderSizePixel = 0
	card.Visible = false
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

	local btn = Instance.new("TextButton", card)
	btn.Size = UDim2.fromOffset(w, h)
	btn.Position = UDim2.fromOffset(5, 5)
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
	btn.BackgroundTransparency = 0.1
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Active = true
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

-- ===== Fixed Key Bindings =====
Z.MouseButton1Down:Connect(function() _press(Enum.KeyCode.Z) end)
Z.MouseButton1Up:Connect(function() _release(Enum.KeyCode.Z) end)

C.MouseButton1Down:Connect(function() _press(Enum.KeyCode.C) end)
C.MouseButton1Up:Connect(function() _release(Enum.KeyCode.C) end)

X.MouseButton1Down:Connect(function() _press(Enum.KeyCode.X) end)
X.MouseButton1Up:Connect(function() _release(Enum.KeyCode.X) end)

N.MouseButton1Down:Connect(function() _press(Enum.KeyCode.N) end)
N.MouseButton1Up:Connect(function() _release(Enum.KeyCode.N) end)

-- ===== Simple Menu Toggles =====
ZCard.Visible = true
CCard.Visible = true
XCard.Visible = true
NCard.Visible = true
fpsLabel.Visible = true

print("[OceanHub Mobile Helper] Loaded v1.7 | Buttons now emulate keys correctly.")
