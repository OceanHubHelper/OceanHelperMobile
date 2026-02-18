local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VxMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Intro splash (shows Potato Mode ON)
do
	local intro = Instance.new("Frame", gui)
	intro.Size = UDim2.fromScale(1,1)
	intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
	intro.BackgroundTransparency = 1
	intro.ZIndex = 50

	local title = Instance.new("TextLabel", intro)
	title.Size = UDim2.fromScale(1,1)
	title.BackgroundTransparency = 1
	title.Text = "VxMenu\nPotato Mode: ON"
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 48
	title.TextColor3 = Color3.new(1,1,1)
	title.TextTransparency = 1
	title.TextStrokeTransparency = 1
	title.ZIndex = 51

	TweenService:Create(intro, TweenInfo.new(0.35), {BackgroundTransparency = 0.4}):Play()
	TweenService:Create(title, TweenInfo.new(0.35), {TextTransparency = 0, TextStrokeTransparency = 0.6}):Play()
	task.wait(1)
	TweenService:Create(intro, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, TweenInfo.new(0.45), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	task.wait(0.45)
	intro:Destroy()
end

-- Auto-enable Potato Mode (Anti-Lag)
local saved = {}
Lighting.GlobalShadows = false

for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("PostEffect") then
		saved[v] = v.Enabled
		v.Enabled = false
	end
end

for _,d in ipairs(workspace:GetDescendants()) do
	if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
		saved[d] = d.Enabled
		d.Enabled = false
	elseif d:IsA("Decal") or d:IsA("Texture") then
		saved[d] = d.Transparency
		d.Transparency = 1
	end
end

_G._potatoConn = RunService.Heartbeat:Connect(function()
	for _,d in ipairs(workspace:GetDescendants()) do
		if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
			d.Enabled = false
		elseif d:IsA("Decal") or d:IsA("Texture") then
			d.Transparency = 1
		end
	end
end)

-- === Your existing menu/buttons continue below ===
-- (Keep the rest of your VxMenu code exactly the same here)
