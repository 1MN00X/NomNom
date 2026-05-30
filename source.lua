-- [[ NomNom UI: Million Dollar Futuristic Edition ]]
-- Version: 3.0 (Quantum Update)
-- Credits: NomNom Team

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Utility for Smooth Animations
local function Tween(obj, time, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(time, unpack(info)), goal)
    t:Play()
    return t
end

function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    self.Title = config.Title or "NOMNOM QUANTUM"
    self.AccentColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.Logo = config.LogoId or "rbxassetid://0"
    
    -- Main ScreenGui
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_Quantum"
    sgui.ResetOnSpawn = false
    sgui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui

    -- ==========================================
    -- 1. CINEMATIC LOADING SCREEN
    -- ==========================================
    local loadBG = Instance.new("Frame", sgui)
    loadBG.Size = UDim2.new(1, 0, 1, 0)
    loadBG.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    loadBG.ZIndex = 100
    
    local loadMain = Instance.new("Frame", loadBG)
    loadMain.Size = UDim2.new(0, 400, 0, 100)
    loadMain.Position = UDim2.new(0.5, -200, 0.5, -50)
    loadMain.BackgroundTransparency = 1
    
    local loadText = Instance.new("TextLabel", loadMain)
    loadText.Size = UDim2.new(1, 0, 0, 40)
    loadText.Text = "INITIALIZING QUANTUM CORE"
    loadText.Font = Enum.Font.GothamBold
    loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadText.TextSize = 20
    loadText.BackgroundTransparency = 1
    
    local barBG = Instance.new("Frame", loadMain)
    barBG.Size = UDim2.new(0, 300, 0, 4)
    barBG.Position = UDim2.new(0.5, -150, 0.7, 0)
    barBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", barBG)
    
    local barFill = Instance.new("Frame", barBG)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = self.AccentColor
    Instance.new("UICorner", barFill)
    
    -- Loading Animation
    task.wait(0.5)
    Tween(barFill, 2, {Enum.EasingStyle.Quint, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 1, 0)})
    task.wait(1.8)
    Tween(loadBG, 0.5, {Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {BackgroundTransparency = 1})
    Tween(loadText, 0.5, {Enum.EasingStyle.Quad, Enum.EasingDirection.In}, {TextTransparency = 1})
    task.wait(0.5)
    loadBG:Destroy()

    -- ==========================================
    -- 2. DYNAMIC ISLAND (iPhone Style + RGB)
    -- ==========================================
    local island = Instance.new("Frame", sgui)
    island.Size = UDim2.new(0, 200, 0, 38)
    island.Position = UDim2.new(0.5, -100, 0, -50)
    island.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    island.Visible = false
    island.ClipsDescendants = true
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
    
    local islandStroke = Instance.new("UIStroke", island)
    islandStroke.Color = self.AccentColor
    islandStroke.Thickness = 1.5
    islandStroke.Transparency = 0.5

    local islandLabel = Instance.new("TextLabel", island)
    islandLabel.Size = UDim2.new(1, -40, 1, 0)
    islandLabel.Position = UDim2.new(0, 15, 0, 0)
    islandLabel.Text = self.Title
    islandLabel.Font = Enum.Font.GothamBold
    islandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    islandLabel.TextSize = 12
    islandLabel.TextXAlignment = Enum.TextXAlignment.Left
    islandLabel.BackgroundTransparency = 1

    -- RGB Indicator Dot
    local dot = Instance.new("Frame", island)
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(1, -25, 0.5, -4)
    dot.BackgroundColor3 = self.AccentColor
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    -- Breathing RGB Effect
    task.spawn(function()
        while task.wait() do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 0.8, 1)
            dot.BackgroundColor3 = color
            islandStroke.Color = color
        end
    end)

    self.Island = island

    -- ==========================================
    -- 3. MAIN PREMIUM PANEL
    -- ==========================================
    local main = Instance.new("Frame", sgui)
    main.Size = UDim2.new(0, 600, 0, 400)
    main.Position = UDim2.new(0.5, -300, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
    
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 2
    self.MainFrame = main

    -- Header
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundTransparency = 1
    
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 25, 0, 0)
    title.Text = self.Title
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local close = Instance.new("TextButton", header)
    close.Size = UDim2.new(0, 40, 0, 40)
    close.Position = UDim2.new(1, -55, 0, 10)
    close.Text = "×"
    close.Font = Enum.Font.GothamLight
    close.TextColor3 = Color3.fromRGB(200, 200, 200)
    close.TextSize = 30
    close.BackgroundTransparency = 1

    -- Container
    local container = Instance.new("ScrollingFrame", main)
    container.Size = UDim2.new(1, -40, 1, -80)
    container.Position = UDim2.new(0, 20, 0, 70)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 0
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)
    self.Container = container

    -- Toggle Logic
    self.IsOpen = true
    local function ToggleUI()
        self.IsOpen = not self.IsOpen
        if not self.IsOpen then
            -- Hide Main, Show Island
            Tween(main, 0.5, {Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Size = UDim2.new(0, 200, 0, 38), Position = UDim2.new(0.5, -100, 0, 20), BackgroundTransparency = 1})
            task.wait(0.4)
            main.Visible = false
            island.Visible = true
            island.Position = UDim2.new(0.5, -100, 0, -50)
            Tween(island, 0.6, {Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Position = UDim2.new(0.5, -100, 0, 20)})
        else
            -- Hide Island, Show Main
            Tween(island, 0.3, {Enum.EasingStyle.Quint, Enum.EasingDirection.In}, {Position = UDim2.new(0.5, -100, 0, -50)})
            task.wait(0.2)
            island.Visible = false
            main.Visible = true
            main.BackgroundTransparency = 0
            Tween(main, 0.6, {Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200)})
        end
    end

    close.MouseButton1Click:Connect(ToggleUI)
    local islandBtn = Instance.new("TextButton", island)
    islandBtn.Size = UDim2.new(1, 0, 1, 0)
    islandBtn.BackgroundTransparency = 1
    islandBtn.Text = ""
    islandBtn.MouseButton1Click:Connect(ToggleUI)

    return self
end

-- ==========================================
-- 4. PREMIUM COMPONENTS
-- ==========================================

-- Futuristic Button
function NomNom:CreateButton(name, callback)
    local btn = Instance.new("TextButton", self.Container)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = "    " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(35, 35, 40)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseEnter:Connect(function()
        Tween(btn, 0.3, {Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
        Tween(stroke, 0.3, {Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Color = self.AccentColor})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.3, {Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {BackgroundColor3 = Color3.fromRGB(20, 20, 25)})
        Tween(stroke, 0.3, {Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Color = Color3.fromRGB(35, 35, 40)})
    end)
    btn.MouseButton1Click:Connect(callback)
end

-- Interactive Smooth Slider
function NomNom:CreateSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", self.Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 65)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name .. " : " .. default
    label.Font = Enum.Font.GothamMedium
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local bar = Instance.new("Frame", sliderFrame)
    bar.Size = UDim2.new(1, -40, 0, 6)
    bar.Position = UDim2.new(0, 20, 0, 45)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = self.AccentColor
    Instance.new("UICorner", fill)

    local knob = Instance.new("Frame", fill)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(1, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function move(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. " : " .. val
        callback(val)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
    end)
end

-- Premium Toggle
function NomNom:CreateToggle(name, default, callback)
    local state = default
    local toggle = Instance.new("TextButton", self.Container)
    toggle.Size = UDim2.new(1, 0, 0, 45)
    toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggle.Text = "    " .. name
    toggle.Font = Enum.Font.GothamMedium
    toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggle.TextSize = 14
    toggle.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

    local switch = Instance.new("Frame", toggle)
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -55, 0.5, -10)
    switch.BackgroundColor3 = state and self.AccentColor or Color3.fromRGB(45, 45, 50)
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    toggle.MouseButton1Click:Connect(function()
        state = not state
        Tween(switch, 0.3, {Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundColor3 = state and self.AccentColor or Color3.fromRGB(45, 45, 50)})
        Tween(circle, 0.3, {Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)})
        callback(state)
    end)
end

return NomNom
