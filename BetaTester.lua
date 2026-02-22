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
-- Anti-Lag / Potato Mode (client-side)
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
	elseif d:IsA("BasePart") then
		d.CastShadow = false
		d.Reflectance = 0
		d.Material = Enum.Material.Plastic
	elseif d:IsA("Decal") or d:IsA("Texture") then
		d.Transparency = 1
	end
end

--------------------------------------------------
-- Key emulation helpers (executor required)
--------------------------------------------------
local function pressKey(key)
	pcall(function() if keypress then keypress(key) end end)
end
local function releaseKey(key)
	pcall(function() if keyrelease then keyrelease(key) end end)
end

--------------------------------------------------
-- Buttons (phone / iPad layout)
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
		local cy = (screen.Y * 0.55) - 110 -- higher on phone
		XCard.Position = UDim2.fromOffset(cx, cy - SIZE - GAP)
		ZCard.Position = UDim2.fromOffset(cx, cy)
		CCard.Position = UDim2.fromOffset(cx + SIZE + GAP, cy)
		NCard.Position = UDim2.fromOffset(cx, cy + SIZE + GAP)
	else
		local bx = screen.X - 360
		local by = screen.Y - 360
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
-- FPS Counter (toggleable)
--------------------------------------------------
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.fromOffset(80, 28)
fpsLabel.Position = UDim2.fromOffset(screen.X - 92, 10)
fpsLabel.BackgroundTransparency = 0.25
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,28)
fpsLabel.TextColor3 = Color3.fromRGB(180,220,255)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.Text = "FPS: --"
fpsLabel.Visible = true
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0,10)

local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		local fps = frames
		frames = 0
		last = tick()
		fpsLabel.Text = "FPS: "..fps
		fpsLabel.TextColor3 = (fps < 10) and Color3.fromRGB(255,90,90) or Color3.fromRGB(180,220,255)
	end
end)

--------------------------------------------------
-- Floating Discord text (fixed size, always faces camera)
--------------------------------------------------
local function attachBillboardText(char)
	local head = char:WaitForChild("Head", 10)
	if not head then return end
	if head:FindFirstChild("VxDiscordTag") then head.VxDiscordTag:Destroy() end

	local bb = Instance.new("BillboardGui")
	bb.Name = "VxDiscordTag"
	bb.Adornee = head
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.MaxDistance = 1e6
	bb.Size = UDim2.fromOffset(320, 40)
	bb.SizeConstraint = Enum.SizeConstraint.RelativeXY
	bb.Parent = head

	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "https://discord.gg/qUGMR2FpHZ"
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.TextWrapped = true
	label.TextScaled = false
	label.TextColor3 = Color3.fromRGB(160, 200, 255)
	label.TextStrokeTransparency = 0.4
end

if player.Character then attachBillboardText(player.Character) end
player.CharacterAdded:Connect(attachBillboardText)
