-- [[ NomNom UI Library: Full Premium Edition ]]
-- Fitur: Intro Loading, Premium Blur Stroke, Smooth Tweens, Dynamic Island

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    -- Konfigurasi Utama
    self.Title = config.Title or "NomNom Premium"
    self.LogoId = config.LogoId or "rbxassetid://0"
    local themeColor = config.ThemeColor or Color3.fromRGB(138, 43, 226) -- Ungu Premium Default
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_Premium_UI"
    sgui.ResetOnSpawn = false
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui
    
    -- ==========================================
    -- 1. INTRO / LOADING SCREEN EFFECT
    -- ==========================================
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 300, 0, 150)
    loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    loadingFrame.Parent = sgui
    
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)
    local lStroke = Instance.new("UIStroke", loadingFrame)
    lStroke.Color = themeColor
    lStroke.Thickness = 1.5
    
    local loadTitle = Instance.new("TextLabel", loadingFrame)
    loadTitle.Size = UDim2.new(1, 0, 0, 40)
    loadTitle.Position = UDim2.new(0, 0, 0, 25)
    loadTitle.Text = self.Title
    loadTitle.Font = Enum.Font.GothamBold
    loadTitle.TextSize = 22
    loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadTitle.BackgroundTransparency = 1
    
    local barBackground = Instance.new("Frame", loadingFrame)
    barBackground.Size = UDim2.new(0, 240, 0, 6)
    barBackground.Position = UDim2.new(0.5, -120, 0, 85)
    barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0)
    
    local barProgress = Instance.new("Frame", barBackground)
    barProgress.Size = UDim2.new(0, 0, 1, 0)
    barProgress.BackgroundColor3 = themeColor
    Instance.new("UICorner", barProgress).CornerRadius = UDim.new(1, 0)
    
    local loadStatus = Instance.new("TextLabel", loadingFrame)
    loadStatus.Size = UDim2.new(1, 0, 0, 20)
    loadStatus.Position = UDim2.new(0, 0, 0, 105)
    loadStatus.Text = "Connecting to NomNom Server..."
    loadStatus.Font = Enum.Font.GothamMedium
    loadStatus.TextSize = 11
    loadStatus.TextColor3 = Color3.fromRGB(120, 120, 120)
    loadStatus.BackgroundTransparency = 1
    
    -- Animasi Loading Palsu ala Premium
    task.wait(0.5)
    TweenService:Create(barProgress, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
    loadStatus.Text = "Bypassing Anticheat..."
    task.wait(1.2)
    TweenService:Create(barProgress, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    loadStatus.Text = "Injecting UI Elements..."
    task.wait(0.9)
    
    -- Hilangkan Loading Screen dengan Fade Out
    TweenService:Create(loadingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    TweenService:Create(loadStatus, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    barBackground:Destroy()
    task.wait(0.3)
    loadingFrame:Destroy()

    -- ==========================================
    -- 2. MAIN PREMIUM FRAME & DYNAMIC ISLAND
    -- ==========================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    self.MainFrame = mainFrame
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(35, 35, 35)
    mainStroke.Thickness = 1.5
    
    -- Efek Muncul Pertama Kali (Pop-up Animation)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
    
    -- Pembuatan Komponen Dynamic Island
    local island = Instance.new("Frame")
    island.Size = UDim2.new(0, 180, 0, 35)
    island.Position = UDim2.new(0.5, -90, 0, 20)
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    island.BackgroundTransparency = 0.2
    island.Visible = false
    island.Parent = sgui
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
    
    local islandStroke = Instance.new("UIStroke", island)
    islandStroke.Color = themeColor
    islandStroke.Thickness = 1
    
    local islandText = Instance.new("TextLabel", island)
    islandText.Size = UDim2.new(1, 0, 1, 0)
    islandText.BackgroundTransparency = 1
    islandText.Text = self.Title .. " 🌴"
    islandText.TextColor3 = Color3.fromRGB(255, 255, 255)
    islandText.Font = Enum.Font.GothamBold
    islandText.TextSize = 13
    
    self.Island = island
    self.IsOpen = true
    
    -- Header UI Utama
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    
    if self.LogoId ~= "rbxassetid://0" then
        local logo = Instance.new("ImageLabel", header)
        logo.Size = UDim2.new(0, 24, 0, 24)
        logo.Position = UDim2.new(0, 20, 0, 13)
        logo.Image = self.LogoId
        logo.BackgroundTransparency = 1
    end
    
    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, self.LogoId ~= "rbxassetid://0" and 55 or 20, 0, 0)
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0, 10)
    closeBtn.Text = "—"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundTransparency = 1
    
    local container = Instance.new("ScrollingFrame", mainFrame)
    container.Size = UDim2.new(1, -40, 1, -70)
    container.Position = UDim2.new(0, 20, 0, 60)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = themeColor
    
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    self.Container = container
    
    -- Fungsi Animasi Transisi ke Dynamic Island
    local function toggleUI()
        self.IsOpen = not self.IsOpen
        if not self.IsOpen then
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 180, 0, 35),
                Position = UDim2.new(0.5, -90, 0, 20),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            mainFrame.Visible = false
            island.Visible = true
        else
            island.Visible = false
            mainFrame.Visible = true
            mainFrame.BackgroundTransparency = 0
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 550, 0, 350),
                Position = UDim2.new(0.5, -275, 0.5, -175)
            }):Play()
        end
    end
    
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleUI() end
    end)
    
    return self
end

-- ================= KOMPONEN UI PREMIUM =================

function NomNom:CreateButton(name, callback)
    local btn = Instance.new("TextButton", self.Container)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
end

function NomNom:CreateToggle(name, default, callback)
    local state = default or false
    local tf = Instance.new("Frame", self.Container)
    tf.Size = UDim2.new(1, 0, 0, 42)
    tf.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", tf)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local switch = Instance.new("TextButton", tf)
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 50)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switch.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 50)
        local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        callback(state)
    end)
end

return NomNom
