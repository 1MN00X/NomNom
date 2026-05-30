-- [[ NomNom UI V3: The Obsidian Future ]]
-- Created by 1MN00X & Gemini AI
-- Features: Dynamic Island RGB, Futuristic Glassmorphism, Advanced Logic

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Helper: Create Smooth RGB
local function GetRGB()
	local t = tick()
	return Color3.fromHSV(t % 5 / 5, 0.8, 1)
end

function NomNom.new(config)
	local self = setmetatable({}, NomNom)

	self.Title = config.Title or "NOMNOM OBSIDIAN"
	self.LogoId = config.LogoId or "rbxassetid://0"
	self.ThemeColor = config.ThemeColor or Color3.fromRGB(0, 255, 255)

	-- Create ScreenGui
	local sgui = Instance.new("ScreenGui")
	sgui.Name = "NomNom_Obsidian_V3"
	sgui.DisplayOrder = 100
	sgui.ResetOnSpawn = false
	sgui.Parent = CoreGui or Player:WaitForChild("PlayerGui")
	self.ScreenGui = sgui

	-- ==========================================
	-- 1. CYBER LOADING INTRO
	-- ==========================================
	local intro = Instance.new("Frame", sgui)
	intro.Size = UDim2.new(1, 0, 1, 0)
	intro.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	intro.ZIndex = 1000

	local loadLogo = Instance.new("TextLabel", intro)
	loadLogo.Size = UDim2.new(0, 400, 0, 50)
	loadLogo.Position = UDim2.new(0.5, -200, 0.5, -50)
	loadLogo.BackgroundTransparency = 1
	loadLogo.Text = "INITIALIZING NOMNOM..."
	loadLogo.Font = Enum.Font.GothamBold
	loadLogo.TextSize = 30
	loadLogo.TextColor3 = Color3.fromRGB(255, 255, 255)

	local scanLine = Instance.new("Frame", intro)
	scanLine.Size = UDim2.new(0, 2, 0, 100)
	scanLine.Position = UDim2.new(0, 0, 0.5, -50)
	scanLine.BackgroundColor3 = self.ThemeColor
	scanLine.BorderSizePixel = 0

	-- Intro Animation
	TweenService:Create(scanLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(1, 0, 0.5, -50)}):Play()
	task.wait(1.5)
	TweenService:Create(intro, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
	TweenService:Create(loadLogo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
	TweenService:Create(scanLine, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	intro:Destroy()

	-- ==========================================
	-- 2. MAIN FRAME DESIGN
	-- ==========================================
	local main = Instance.new("Frame", sgui)
	main.Name = "Main"
	main.Size = UDim2.new(0, 600, 0, 400)
	main.Position = UDim2.new(0.5, -300, 0.5, -200)
	main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	self.MainFrame = main

	local mCorner = Instance.new("UICorner", main)
	mCorner.CornerRadius = UDim.new(0, 20)

	local mStroke = Instance.new("UIStroke", main)
	mStroke.Color = Color3.fromRGB(40, 40, 40)
	mStroke.Thickness = 1.8
	mStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	-- Gradient Background Effect
	local grad = Instance.new("UIGradient", main)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
	})
	grad.Rotation = 45

	-- ==========================================
	-- 3. DYNAMIC ISLAND RGB PRO
	-- ==========================================
	local island = Instance.new("Frame", sgui)
	island.Name = "DynamicIsland"
	island.Size = UDim2.new(0, 200, 0, 40)
	island.Position = UDim2.new(0.5, -100, 0, -50) -- Hide at start
	island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	island.BackgroundTransparency = 0.1
	island.Visible = false
	island.ZIndex = 500
	self.Island = island

	Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
	
	local iStroke = Instance.new("UIStroke", island)
	iStroke.Thickness = 2
	iStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
	-- RGB Border Loop for Island
	RunService.RenderStepped:Connect(function()
		if island.Visible then
			iStroke.Color = GetRGB()
		end
	end)

	local iText = Instance.new("TextLabel", island)
	iText.Size = UDim2.new(1, 0, 1, 0)
	iText.BackgroundTransparency = 1
	iText.Text = self.Title .. " • ACTIVE"
	iText.Font = Enum.Font.GothamBold
	iText.TextSize = 12
	iText.TextColor3 = Color3.fromRGB(255, 255, 255)

	local islandTrigger = Instance.new("TextButton", island)
	islandTrigger.Size = UDim2.new(1, 0, 1, 0)
	islandTrigger.BackgroundTransparency = 1
	islandTrigger.Text = ""
	islandTrigger.ZIndex = 510

	-- ==========================================
	-- 4. SIDEBAR & NAVIGATION
	-- ==========================================
	local side = Instance.new("Frame", main)
	side.Size = UDim2.new(0, 160, 1, 0)
	side.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	side.BorderSizePixel = 0

	local sCorner = Instance.new("UICorner", side)
	sCorner.CornerRadius = UDim.new(0, 20)

	local sideTitle = Instance.new("TextLabel", side)
	sideTitle.Size = UDim2.new(1, 0, 0, 60)
	sideTitle.Text = "   " .. self.Title
	sideTitle.Font = Enum.Font.GothamBold
	sideTitle.TextSize = 16
	sideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	sideTitle.TextXAlignment = Enum.TextXAlignment.Left
	sideTitle.BackgroundTransparency = 1

	local container = Instance.new("ScrollingFrame", main)
	container.Size = UDim2.new(1, -180, 1, -80)
	container.Position = UDim2.new(0, 170, 0, 70)
	container.BackgroundTransparency = 1
	container.ScrollBarThickness = 2
	container.ScrollBarImageColor3 = self.ThemeColor
	self.Container = container

	local layout = Instance.new("UIListLayout", container)
	layout.Padding = UDim.new(0, 10)

	-- ==========================================
	-- 5. TOGGLE LOGIC & BUGS FIXES
	-- ==========================================
	self.IsOpen = true
	
	local function toggleUI()
		self.IsOpen = not self.IsOpen
		if not self.IsOpen then
			-- Shrink to Island
			TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0, 20),
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.4)
			main.Visible = false
			island.Visible = true
			island.Position = UDim2.new(0.5, -100, 0, -50)
			TweenService:Create(island, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, -100, 0, 20)
			}):Play()
		else
			-- Grow from Island
			TweenService:Create(island, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, -100, 0, -50)
			}):Play()
			task.wait(0.2)
			island.Visible = false
			main.Visible = true
			main.BackgroundTransparency = 0
			TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 600, 0, 400),
				Position = UDim2.new(0.5, -300, 0.5, -200)
			}):Play()
		end
	end

	islandTrigger.MouseButton1Click:Connect(toggleUI)

	-- Minimize Button
	local minBtn = Instance.new("TextButton", main)
	minBtn.Size = UDim2.new(0, 30, 0, 30)
	minBtn.Position = UDim2.new(1, -45, 0, 15)
	minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	minBtn.Text = "-"
	minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Parent = main
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
	minBtn.MouseButton1Click:Connect(toggleUI)

	return self
end

-- ==========================================
-- PREMIUM COMPONENTS API
-- ==========================================

-- 1. Premium Button
function NomNom:CreateButton(name, callback)
	local btn = Instance.new("TextButton", self.Container)
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.Text = "     " .. name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	
	local bCorner = Instance.new("UICorner", btn)
	local bStroke = Instance.new("UIStroke", btn)
	bStroke.Color = Color3.fromRGB(40, 40, 40)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.3), {Color = self.ThemeColor}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
		TweenService:Create(bStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
	end)
	
	btn.MouseButton1Click:Connect(callback)
end

-- 2. Premium Toggle
function NomNom:CreateToggle(name, default, callback)
	local state = default or false
	local tFrame = Instance.new("Frame", self.Container)
	tFrame.Size = UDim2.new(1, 0, 0, 45)
	tFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Instance.new("UICorner", tFrame)
	
	local label = Instance.new("TextLabel", tFrame)
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.Text = name
	label.Font = Enum.Font.GothamMedium
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	local switch = Instance.new("TextButton", tFrame)
	switch.Size = UDim2.new(0, 40, 0, 22)
	switch.Position = UDim2.new(1, -55, 0.5, -11)
	switch.BackgroundColor3 = state and self.ThemeColor or Color3.fromRGB(50, 50, 50)
	switch.Text = ""
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", switch)
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	switch.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3 = state and self.ThemeColor or Color3.fromRGB(50, 50, 50)}):Play()
		TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)}):Play()
		callback(state)
	end)
end

-- 3. Premium Slider
function NomNom:CreateSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", self.Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", sliderFrame)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name .. " : " .. default
    label.Font = Enum.Font.GothamMedium
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", sliderFrame)
    bar.Size = UDim2.new(1, -40, 0, 6)
    bar.Position = UDim2.new(0, 20, 0, 40)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = self.ThemeColor
    Instance.new("UICorner", fill)

    local trigger = Instance.new("TextButton", bar)
    trigger.Size = UDim2.new(1, 0, 1, 0)
    trigger.BackgroundTransparency = 1
    trigger.Text = ""

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        label.Text = name .. " : " .. val
        callback(val)
    end

    local dragging = false
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
end

return NomNom
