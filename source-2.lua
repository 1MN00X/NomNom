-- [[ NomNom UI Library V2: Ultra Premium Edition + V3 Expansion ]]
-- Fitur: Draggable Window, Live Theme Changer, RGB Dynamic Island, Smooth Sliders, Ultra Animations
-- NEW: Tab System, Notifications, Progress Bar, Status Indicator, Text Box, Label, Search Bar

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService") [cite: 1]
local UserInputService = game:GetService("UserInputService") [cite: 1]
local RunService = game:GetService("RunService") [cite: 1]
local CoreGui = game:GetService("CoreGui") [cite: 1]
local Players = game:GetService("Players") [cite: 1]

-- Global Dragging Logic
local function MakeDraggable(topbarobject, object) [cite: 1]
    local Dragging = nil [cite: 1]
    local DragInput = nil [cite: 1]
    local DragStart = nil [cite: 1]
    local StartPosition = nil [cite: 1]

    local function Update(input) [cite: 1]
        local Delta = input.Position - DragStart [cite: 1]
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y) [cite: 2]
        local Tween = TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}) [cite: 2]
        Tween:Play() [cite: 2]
    end [cite: 2]

    topbarobject.InputBegan:Connect(function(input) [cite: 2]
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then [cite: 2]
            Dragging = true [cite: 2]
            DragStart = input.Position [cite: 2]
            StartPosition = object.Position [cite: 3]

            input.Changed:Connect(function() [cite: 3]
                if input.UserInputState == Enum.UserInputState.End then [cite: 3]
                    Dragging = false [cite: 3]
                end [cite: 3]
            end) [cite: 3]
        end [cite: 3]
    end) [cite: 3]

    topbarobject.InputChanged:Connect(function(input) [cite: 4]
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then [cite: 4]
            DragInput = input [cite: 4]
        end [cite: 4]
    end) [cite: 4]

    UserInputService.InputChanged:Connect(function(input) [cite: 4]
        if input == DragInput and Dragging then [cite: 4]
            Update(input) [cite: 4]
        end [cite: 4]
    end) [cite: 4]
end [cite: 4]

function NomNom.new(config) [cite: 4]
    local self = setmetatable({}, NomNom) [cite: 4]
    
    -- Konfigurasi Utama
    self.Title = config.Title or "NomNom Premium" [cite: 5]
    self.LogoId = config.LogoId or "" [cite: 5]
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255) [cite: 5]
    self.ThemeObjects = {} [cite: 5]
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui") [cite: 5]
    sgui.Name = "NomNom_V2_Premium" [cite: 5]
    sgui.ResetOnSpawn = false [cite: 5]
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui") [cite: 5]
    self.ScreenGui = sgui [cite: 5]
    
    -- ==========================================
    -- 1. ULTRA PREMIUM LOADING SCREEN
    -- ==========================================
    local loadingFrame = Instance.new("Frame") [cite: 6]
    loadingFrame.Size = UDim2.new(0, 320, 0, 160) [cite: 6]
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80) [cite: 6]
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14) [cite: 6]
    loadingFrame.BackgroundTransparency = 1 [cite: 6]
    loadingFrame.Parent = sgui [cite: 6]
    
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 14) [cite: 6]
    local lStroke = Instance.new("UIStroke", loadingFrame) [cite: 6]
    lStroke.Color = self.CurrentThemeColor [cite: 6]
    lStroke.Thickness = 0 [cite: 6]
    lStroke.Transparency = 1 [cite: 6]
    
    local loadTitle = Instance.new("TextLabel", loadingFrame) [cite: 7]
    loadTitle.Size = UDim2.new(1, 0, 0, 40) [cite: 7]
    loadTitle.Position = UDim2.new(0, 0, 0, 30) [cite: 7]
    loadTitle.Text = self.Title [cite: 7]
    loadTitle.Font = Enum.Font.GothamBlack [cite: 7]
    loadTitle.TextSize = 24 [cite: 7]
    loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 7]
    loadTitle.BackgroundTransparency = 1 [cite: 7]
    loadTitle.TextTransparency = 1 [cite: 7]
    
    local barBackground = Instance.new("Frame", loadingFrame) [cite: 7]
    barBackground.Size = UDim2.new(0, 260, 0, 4) [cite: 7]
    barBackground.Position = UDim2.new(0.5, -130, 0, 95) [cite: 7]
    barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35) [cite: 8]
    barBackground.BackgroundTransparency = 1 [cite: 8]
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0) [cite: 8]
    
    local barProgress = Instance.new("Frame", barBackground) [cite: 8]
    barProgress.Size = UDim2.new(0, 0, 1, 0) [cite: 8]
    barProgress.BackgroundColor3 = self.CurrentThemeColor [cite: 8]
    Instance.new("UICorner", barProgress).CornerRadius = UDim.new(1, 0) [cite: 8]
    
    local loadStatus = Instance.new("TextLabel", loadingFrame) [cite: 8]
    loadStatus.Size = UDim2.new(1, 0, 0, 20) [cite: 8]
    loadStatus.Position = UDim2.new(0, 0, 0, 110) [cite: 8]
    loadStatus.Text = "Initializing Core Systems..." [cite: 8]
    loadStatus.Font = Enum.Font.GothamMedium [cite: 8]
    loadStatus.TextSize = 12 [cite: 9]
    loadStatus.TextColor3 = Color3.fromRGB(150, 150, 150) [cite: 9]
    loadStatus.BackgroundTransparency = 1 [cite: 9]
    loadStatus.TextTransparency = 1 [cite: 9]

    -- Fade In Loading
    TweenService:Create(loadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play() [cite: 9]
    TweenService:Create(lStroke, TweenInfo.new(0.5), {Thickness = 1.5, Transparency = 0}):Play() [cite: 9]
    TweenService:Create(loadTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play() [cite: 9]
    TweenService:Create(loadStatus, TweenInfo.new(0.5), {TextTransparency = 0}):Play() [cite: 9]
    TweenService:Create(barBackground, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play() [cite: 9]
    task.wait(0.6) [cite: 9]
    
    -- Animasi Loading Mulus
    TweenService:Create(barProgress, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.3, 0, 1, 0)}):Play() [cite: 9, 10]
    task.wait(0.8) [cite: 10]
    loadStatus.Text = "Fetching UI Elements..." [cite: 10]
    TweenService:Create(barProgress, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.75, 0, 1, 0)}):Play() [cite: 10]
    task.wait(1.3) [cite: 10]
    loadStatus.Text = "Welcome to the Future." [cite: 10]
    TweenService:Create(barProgress, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play() [cite: 11]
    task.wait(0.6) [cite: 11]
    
    -- Fade Out Loading
    TweenService:Create(loadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() [cite: 11]
    TweenService:Create(lStroke, TweenInfo.new(0.4), {Transparency = 1}):Play() [cite: 11]
    TweenService:Create(loadTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play() [cite: 11]
    TweenService:Create(loadStatus, TweenInfo.new(0.4), {TextTransparency = 1}):Play() [cite: 11]
    TweenService:Create(barProgress, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() [cite: 11]
    TweenService:Create(barBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() [cite: 11]
    task.wait(0.4) [cite: 11]
    loadingFrame:Destroy() [cite: 11]

    -- CONTAINER NOTIFIKASI (NEW)
    local notifyContainer = Instance.new("Frame", sgui)
    notifyContainer.Size = UDim2.new(0, 300, 1, -20)
    notifyContainer.Position = UDim2.new(1, -320, 0, 10)
    notifyContainer.BackgroundTransparency = 1
    local notifLayout = Instance.new("UIListLayout", notifyContainer)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 10)
    self.NotifyContainer = notifyContainer

    -- ==========================================
    -- 2. MAIN PREMIUM FRAME & DYNAMIC ISLAND
    -- ==========================================
    local mainFrame = Instance.new("Frame") [cite: 12]
    mainFrame.Size = UDim2.new(0, 0, 0, 0) [cite: 12]
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) [cite: 12]
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18) [cite: 12]
    mainFrame.BackgroundTransparency = 0.05 [cite: 12]
    mainFrame.ClipsDescendants = true [cite: 12]
    mainFrame.Parent = sgui [cite: 12]
    self.MainFrame = mainFrame [cite: 12]
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12) [cite: 12]
    local mainStroke = Instance.new("UIStroke", mainFrame) [cite: 12]
    mainStroke.Color = Color3.fromRGB(40, 40, 45) [cite: 12]
    mainStroke.Thickness = 1.5 [cite: 12, 13]
    
    -- Pop-up Animasi Menu Utama
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { [cite: 13]
        Size = UDim2.new(0, 600, 0, 400), [cite: 13]
        Position = UDim2.new(0.5, -300, 0.5, -200) [cite: 13]
    }):Play() [cite: 13]
    
    -- Pembuatan Komponen Dynamic Island
    local island = Instance.new("TextButton") [cite: 13]
    island.Text = "" [cite: 13]
    island.Size = UDim2.new(0, 200, 0, 35) [cite: 13]
    island.Position = UDim2.new(0.5, -100, 0, 20) [cite: 13, 14]
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 12) [cite: 14]
    island.Visible = false [cite: 14]
    island.AutoButtonColor = false [cite: 14]
    island.Parent = sgui [cite: 14]
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0) [cite: 14]
    
    local islandStroke = Instance.new("UIStroke", island) [cite: 14]
    islandStroke.Color = self.CurrentThemeColor [cite: 14]
    islandStroke.Thickness = 1.5 [cite: 14]
    table.insert(self.ThemeObjects, {Obj = islandStroke, Prop = "Color"}) [cite: 14]
    
    local islandText = Instance.new("TextLabel", island) [cite: 14]
    islandText.Size = UDim2.new(1, -40, 1, 0) [cite: 14]
    islandText.Position = UDim2.new(0, 20, 0, 0) [cite: 14, 15]
    islandText.BackgroundTransparency = 1 [cite: 15]
    islandText.Text = self.Title [cite: 15]
    islandText.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 15]
    islandText.Font = Enum.Font.GothamBold [cite: 15]
    islandText.TextSize = 13 [cite: 15]
    islandText.TextXAlignment = Enum.TextXAlignment.Left [cite: 15]
    
    -- RGB Light Indicator
    local rgbLight = Instance.new("Frame", island) [cite: 15]
    rgbLight.Size = UDim2.new(0, 8, 0, 8) [cite: 15]
    rgbLight.Position = UDim2.new(1, -20, 0.5, -4) [cite: 15]
    rgbLight.BackgroundColor3 = Color3.fromRGB(255, 0, 0) [cite: 15]
    Instance.new("UICorner", rgbLight).CornerRadius = UDim.new(1, 0) [cite: 15]
    
    -- RGB Loop Animation
    task.spawn(function() [cite: 16]
        local hue = 0 [cite: 16]
        while task.wait() do [cite: 16]
            hue = hue + 0.005 [cite: 16]
            if hue >= 1 then hue = 0 end [cite: 16]
            rgbLight.BackgroundColor3 = Color3.fromHSV(hue, 1, 1) [cite: 16]
        end [cite: 16]
    end) [cite: 16]
    
    self.Island = island [cite: 17]
    self.IsOpen = true [cite: 17]
    
    -- Header UI Utama
    local header = Instance.new("Frame", mainFrame) [cite: 17]
    header.Size = UDim2.new(1, 0, 0, 50) [cite: 17]
    header.BackgroundTransparency = 1 [cite: 17]
    MakeDraggable(header, mainFrame) [cite: 17]
    
    local titleLabel = Instance.new("TextLabel", header) [cite: 17]
    titleLabel.Size = UDim2.new(0, 300, 1, 0) [cite: 17]
    titleLabel.Position = UDim2.new(0, 20, 0, 0) [cite: 17]
    titleLabel.Text = self.Title [cite: 17]
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 17, 18]
    titleLabel.Font = Enum.Font.GothamBlack [cite: 18]
    titleLabel.TextSize = 18 [cite: 18]
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 18]
    titleLabel.BackgroundTransparency = 1 [cite: 18]
    
    local closeBtn = Instance.new("TextButton", header) [cite: 18]
    closeBtn.Size = UDim2.new(0, 30, 0, 30) [cite: 18]
    closeBtn.Position = UDim2.new(1, -45, 0, 10) [cite: 18]
    closeBtn.Text = "—" [cite: 18]
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150) [cite: 18]
    closeBtn.Font = Enum.Font.GothamBold [cite: 18]
    closeBtn.TextSize = 14 [cite: 18]
    closeBtn.BackgroundTransparency = 1 [cite: 18]
    
    -- TAB SYSTEM CONTAINER (NEW)
    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Size = UDim2.new(1, -40, 0, 35)
    tabBar.Position = UDim2.new(0, 20, 0, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabBar = tabBar
    self.TabLayout = tabLayout

    local tabContentContainer = Instance.new("Frame", mainFrame)
    tabContentContainer.Size = UDim2.new(1, -40, 1, -100)
    tabContentContainer.Position = UDim2.new(0, 20, 0, 90)
    tabContentContainer.BackgroundTransparency = 1
    self.TabContentContainer = tabContentContainer
    self.Tabs = {}
    self.FirstTab = true
    
    -- Fungsi Transisi Dynamic Island
    local function toggleUI() [cite: 19]
        self.IsOpen = not self.IsOpen [cite: 20]
        if not self.IsOpen then [cite: 20]
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { [cite: 20]
                Size = UDim2.new(0, 200, 0, 35), [cite: 20]
                Position = UDim2.new(0.5, -100, 0, 20), [cite: 20]
                BackgroundTransparency = 1 [cite: 20, 21]
            }):Play() [cite: 21]
            
            for _, v in pairs(mainFrame:GetChildren()) do [cite: 21]
                if v:IsA("GuiObject") then v.Visible = false end [cite: 21]
            end [cite: 21]
            
            task.wait(0.3) [cite: 22]
            mainFrame.Visible = false [cite: 22]
            island.Visible = true [cite: 22]
            
            island.Size = UDim2.new(0, 150, 0, 25) [cite: 22]
            island.Position = UDim2.new(0.5, -75, 0, 25) [cite: 22]
            TweenService:Create(island, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { [cite: 22, 23]
                Size = UDim2.new(0, 200, 0, 35), [cite: 23]
                Position = UDim2.new(0.5, -100, 0, 20) [cite: 23]
            }):Play() [cite: 23]
        else [cite: 23]
            island.Visible = false [cite: 23, 24]
            mainFrame.Visible = true [cite: 24]
            mainFrame.BackgroundTransparency = 0.05 [cite: 24]
            
            for _, v in pairs(mainFrame:GetChildren()) do [cite: 24]
                if v:IsA("GuiObject") then v.Visible = true end [cite: 24]
            end [cite: 24]
            
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { [cite: 24, 25]
                Size = UDim2.new(0, 600, 0, 400), [cite: 25]
                Position = UDim2.new(0.5, -300, 0.5, -200) [cite: 25]
            }):Play() [cite: 25]
        end [cite: 25]
    end [cite: 25]
    
    closeBtn.MouseButton1Click:Connect(toggleUI) [cite: 25]
    island.MouseButton1Click:Connect(toggleUI) [cite: 26]
    
    return self [cite: 26]
end [cite: 26]

-- ================= GLOBAL FEATURES =================

function NomNom:ChangeTheme(newColor) [cite: 26]
    self.CurrentThemeColor = newColor [cite: 26]
    for _, item in pairs(self.ThemeObjects) do [cite: 26]
        if item.Obj and item.Obj.Parent then [cite: 26]
            TweenService:Create(item.Obj, TweenInfo.new(0.5), {[item.Prop] = newColor}):Play() [cite: 26]
        end [cite: 26]
    end [cite: 26]
end [cite: 26]

function NomNom:Notify(title, text, duration)
    duration = duration or 3
    
    local notif = Instance.new("Frame", self.NotifyContainer)
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    notif.Position = UDim2.new(1, 350, 0, 0)
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = self.CurrentThemeColor
    stroke.Thickness = 1.5
    table.insert(self.ThemeObjects, {Obj = stroke, Prop = "Color"})
    
    local titleLbl = Instance.new("TextLabel", notif)
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 15, 0, 10)
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    
    local descLbl = Instance.new("TextLabel", notif)
    descLbl.Size = UDim2.new(1, -20, 0, 20)
    descLbl.Position = UDim2.new(0, 15, 0, 35)
    descLbl.Text = text
    descLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 12
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.BackgroundTransparency = 1
    
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 0, 0)}):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ================= TAB SYSTEM & COMPONENTS =================

function NomNom:CreateTab(name)
    -- Tab Button
    local tabBtn = Instance.new("TextButton", self.TabBar)
    tabBtn.Size = UDim2.new(0, 110, 1, -4)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    -- Tab Content Container
    local container = Instance.new("ScrollingFrame", self.TabContentContainer)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    container.ScrollBarImageColor3 = self.CurrentThemeColor
    container.BorderSizePixel = 0
    container.Visible = self.FirstTab
    
    table.insert(self.ThemeObjects, {Obj = container, Prop = "ScrollBarImageColor3"})
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    if self.FirstTab then
        tabBtn.TextColor3 = self.CurrentThemeColor
        self.FirstTab = false
    end
    table.insert(self.Tabs, {Btn = tabBtn, Container = container})

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Container.Visible = false
            TweenService:Create(t.Btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        container.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {TextColor3 = self.CurrentThemeColor}):Play()
    end)
    
    -- Auto-resize TabBar
    self.TabBar.CanvasSize = UDim2.new(0, self.TabLayout.AbsoluteContentSize.X, 0, 0)
    self.TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabBar.CanvasSize = UDim2.new(0, self.TabLayout.AbsoluteContentSize.X, 0, 0)
    end)

    -- Auto-resize Content Container
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    local TabElements = {}

    function TabElements:CreateButton(btnName, callback)
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(1, 0, 0, 45) [cite: 26, 27]
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25) [cite: 27]
        btn.Text = "   " .. btnName [cite: 27]
        btn.TextColor3 = Color3.fromRGB(240, 240, 240) [cite: 27]
        btn.Font = Enum.Font.GothamMedium [cite: 27]
        btn.TextSize = 14 [cite: 27]
        btn.TextXAlignment = Enum.TextXAlignment.Left [cite: 27]
        btn.AutoButtonColor = false [cite: 27]
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) [cite: 27]
        
        local stroke = Instance.new("UIStroke", btn) [cite: 27]
        stroke.Color = Color3.fromRGB(40, 40, 45) [cite: 27]
        stroke.Thickness = 1 [cite: 27]
        
        btn.MouseEnter:Connect(function() [cite: 27]
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() [cite: 28]
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.CurrentThemeColor}):Play() -- Ini tidak bisa pakai reference `self` tanpa re-logic, jadi kita skip warna theme hover atau assign manual.
            stroke.Color = Color3.fromRGB(80, 80, 85) -- Alternatif netral
        end) [cite: 28]
        btn.MouseLeave:Connect(function() [cite: 28]
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25)}):Play() [cite: 28]
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play() [cite: 28]
        end) [cite: 28]
        btn.MouseButton1Down:Connect(function() [cite: 28]
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 41), Position = UDim2.new(0, 2, 0, 2)}):Play() [cite: 28]
        end) [cite: 28]
        btn.MouseButton1Up:Connect(function() [cite: 28]
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, 0)}):Play() [cite: 29]
            callback() [cite: 29]
        end) [cite: 29]
    end

    function TabElements:CreateToggle(toggleName, default, callback)
        local state = default or false [cite: 29]
        local tf = Instance.new("Frame", container) [cite: 29]
        tf.Size = UDim2.new(1, 0, 0, 45) [cite: 29]
        tf.BackgroundColor3 = Color3.fromRGB(22, 22, 25) [cite: 29]
        Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8) [cite: 29]
        
        local stroke = Instance.new("UIStroke", tf) [cite: 29]
        stroke.Color = Color3.fromRGB(40, 40, 45) [cite: 29]
        
        local label = Instance.new("TextLabel", tf) [cite: 30]
        label.Size = UDim2.new(1, -60, 1, 0) [cite: 30]
        label.Position = UDim2.new(0, 15, 0, 0) [cite: 30]
        label.Text = toggleName [cite: 30]
        label.TextColor3 = Color3.fromRGB(240, 240, 240) [cite: 30]
        label.Font = Enum.Font.GothamMedium [cite: 30]
        label.TextSize = 14 [cite: 30]
        label.TextXAlignment = Enum.TextXAlignment.Left [cite: 30]
        label.BackgroundTransparency = 1 [cite: 30]
        
        local switchBG = Instance.new("TextButton", tf) [cite: 30]
        switchBG.Size = UDim2.new(0, 40, 0, 22) [cite: 30]
        switchBG.Position = UDim2.new(1, -55, 0.5, -11) [cite: 30]
        -- Warnanya statis karena tidak terhubung lgsg ke theme jika tidak global. 
        switchBG.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55) [cite: 30, 31]
        switchBG.Text = "" [cite: 31]
        switchBG.AutoButtonColor = false [cite: 31]
        Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0) [cite: 31]
        
        local circle = Instance.new("Frame", switchBG) [cite: 31]
        circle.Size = UDim2.new(0, 16, 0, 16) [cite: 31]
        circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) [cite: 31]
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255) [cite: 31]
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0) [cite: 31]
        
        switchBG.MouseButton1Click:Connect(function() [cite: 32]
            state = not state [cite: 32]
            local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55) [cite: 32]
            local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) [cite: 32]
            
            TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play() [cite: 32]
            TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play() [cite: 32]
            callback(state) [cite: 32]
        end) [cite: 32]
    end

    function TabElements:CreateSlider(sliderName, min, max, default, callback)
        local sliderVal = default or min [cite: 33]
        
        local sf = Instance.new("Frame", container) [cite: 33]
        sf.Size = UDim2.new(1, 0, 0, 60) [cite: 33]
        sf.BackgroundColor3 = Color3.fromRGB(22, 22, 25) [cite: 33]
        Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8) [cite: 33]
        
        local stroke = Instance.new("UIStroke", sf) [cite: 33]
        stroke.Color = Color3.fromRGB(40, 40, 45) [cite: 33]
        
        local label = Instance.new("TextLabel", sf) [cite: 33]
        label.Size = UDim2.new(1, -20, 0, 25) [cite: 33]
        label.Position = UDim2.new(0, 15, 0, 5) [cite: 33, 34]
        label.Text = sliderName [cite: 34]
        label.TextColor3 = Color3.fromRGB(240, 240, 240) [cite: 34]
        label.Font = Enum.Font.GothamMedium [cite: 34]
        label.TextSize = 14 [cite: 34]
        label.TextXAlignment = Enum.TextXAlignment.Left [cite: 34]
        label.BackgroundTransparency = 1 [cite: 34]
        
        local valLabel = Instance.new("TextLabel", sf) [cite: 34]
        valLabel.Size = UDim2.new(0, 50, 0, 25) [cite: 34]
        valLabel.Position = UDim2.new(1, -65, 0, 5) [cite: 34]
        valLabel.Text = tostring(sliderVal) [cite: 34]
        valLabel.TextColor3 = Color3.fromRGB(0, 170, 255) [cite: 34]
        valLabel.Font = Enum.Font.GothamBold [cite: 34]
        valLabel.TextSize = 14 [cite: 34]
        valLabel.TextXAlignment = Enum.TextXAlignment.Right [cite: 34]
        valLabel.BackgroundTransparency = 1 [cite: 35]
        
        local sliderBG = Instance.new("TextButton", sf) [cite: 35]
        sliderBG.Size = UDim2.new(1, -30, 0, 6) [cite: 35]
        sliderBG.Position = UDim2.new(0, 15, 0, 40) [cite: 35]
        sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45) [cite: 35]
        sliderBG.Text = "" [cite: 35]
        sliderBG.AutoButtonColor = false [cite: 35]
        Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1, 0) [cite: 35]
        
        local sliderFill = Instance.new("Frame", sliderBG) [cite: 35]
        local fillScale = (sliderVal - min) / (max - min) [cite: 35]
        sliderFill.Size = UDim2.new(fillScale, 0, 1, 0) [cite: 36]
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255) [cite: 36]
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0) [cite: 36]
        
        local sliderKnob = Instance.new("Frame", sliderFill) [cite: 36]
        sliderKnob.Size = UDim2.new(0, 14, 0, 14) [cite: 36]
        sliderKnob.Position = UDim2.new(1, -7, 0.5, -7) [cite: 36]
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) [cite: 36]
        Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0) [cite: 36]
        
        local dragging = false [cite: 36]
        
        local function updateSlider(input) [cite: 37]
            local pos = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1) [cite: 37]
            local value = math.floor(min + ((max - min) * pos)) [cite: 37]
            
            valLabel.Text = tostring(value) [cite: 37]
            TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)}):Play() [cite: 37]
            callback(value) [cite: 37]
        end [cite: 37]
        
        sliderBG.InputBegan:Connect(function(input) [cite: 37]
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then [cite: 38]
                dragging = true [cite: 38]
                updateSlider(input) [cite: 38]
                TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -9, 0.5, -9)}):Play() [cite: 38]
            end [cite: 38]
        end) [cite: 38]
        
        UserInputService.InputEnded:Connect(function(input) [cite: 38]
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then [cite: 38]
                dragging = false [cite: 39]
                TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}):Play() [cite: 39]
            end [cite: 39]
        end) [cite: 39]
        
        UserInputService.InputChanged:Connect(function(input) [cite: 39]
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then [cite: 39]
                updateSlider(input) [cite: 39]
            end [cite: 39]
        end) [cite: 39]
    end

    function TabElements:CreateProgressBar(name, defaultPercent)
        local val = defaultPercent or 0
        local pb = Instance.new("Frame", container)
        pb.Size = UDim2.new(1, 0, 0, 50)
        pb.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", pb)
        stroke.Color = Color3.fromRGB(40, 40, 45)

        local label = Instance.new("TextLabel", pb)
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local bgBar = Instance.new("Frame", pb)
        bgBar.Size = UDim2.new(1, -30, 0, 8)
        bgBar.Position = UDim2.new(0, 15, 0, 32)
        bgBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Instance.new("UICorner", bgBar).CornerRadius = UDim.new(1, 0)
        
        local fillBar = Instance.new("Frame", bgBar)
        fillBar.Size = UDim2.new(val / 100, 0, 1, 0)
        fillBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)

        local pbController = {}
        function pbController:Update(newPercent)
            newPercent = math.clamp(newPercent, 0, 100)
            TweenService:Create(fillBar, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(newPercent / 100, 0, 1, 0)}):Play()
        end
        return pbController
    end

    function TabElements:CreateStatus(name, defaultStatus, defaultColor)
        local statusColor = defaultColor or Color3.fromRGB(0, 255, 0)
        
        local statFrame = Instance.new("Frame", container)
        statFrame.Size = UDim2.new(1, 0, 0, 40)
        statFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 8)
        
        local label = Instance.new("TextLabel", statFrame)
        label.Size = UDim2.new(0, 150, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local statCircle = Instance.new("Frame", statFrame)
        statCircle.Size = UDim2.new(0, 10, 0, 10)
        statCircle.Position = UDim2.new(1, -120, 0.5, -5)
        statCircle.BackgroundColor3 = statusColor
        Instance.new("UICorner", statCircle).CornerRadius = UDim.new(1, 0)

        local statText = Instance.new("TextLabel", statFrame)
        statText.Size = UDim2.new(0, 90, 1, 0)
        statText.Position = UDim2.new(1, -100, 0, 0)
        statText.Text = defaultStatus or "Online"
        statText.TextColor3 = statusColor
        statText.Font = Enum.Font.GothamBold
        statText.TextSize = 12
        statText.TextXAlignment = Enum.TextXAlignment.Left
        statText.BackgroundTransparency = 1

        local statController = {}
        function statController:Update(newStatusText, newColor)
            statText.Text = newStatusText
            TweenService:Create(statCircle, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
            TweenService:Create(statText, TweenInfo.new(0.3), {TextColor3 = newColor}):Play()
        end
        return statController
    end

    function TabElements:CreateTextBox(name, placeholder, callback)
        local tbFrame = Instance.new("Frame", container)
        tbFrame.Size = UDim2.new(1, 0, 0, 45)
        tbFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", tbFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", tbFrame)
        stroke.Color = Color3.fromRGB(40, 40, 45)
        
        local label = Instance.new("TextLabel", tbFrame)
        label.Size = UDim2.new(0, 120, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local boxFrame = Instance.new("Frame", tbFrame)
        boxFrame.Size = UDim2.new(1, -145, 0, 30)
        boxFrame.Position = UDim2.new(0, 130, 0.5, -15)
        boxFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 6)

        local textBox = Instance.new("TextBox", boxFrame)
        textBox.Size = UDim2.new(1, -16, 1, 0)
        textBox.Position = UDim2.new(0, 8, 0, 0)
        textBox.BackgroundTransparency = 1
        textBox.PlaceholderText = placeholder or "Enter text..."
        textBox.Text = ""
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.Font = Enum.Font.Gotham
        textBox.TextSize = 13
        textBox.TextXAlignment = Enum.TextXAlignment.Left

        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end

    function TabElements:CreateLabel(text)
        local lbl = Instance.new("TextLabel", container)
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1

        local lblController = {}
        function lblController:Update(newText)
            lbl.Text = newText
        end
        return lblController
    end

    function TabElements:CreateSearchBar(placeholder, callback)
        local searchFrame = Instance.new("Frame", container)
        searchFrame.Size = UDim2.new(1, 0, 0, 40)
        searchFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", searchFrame)
        stroke.Color = Color3.fromRGB(50, 50, 55)

        local searchIcon = Instance.new("TextLabel", searchFrame)
        searchIcon.Size = UDim2.new(0, 30, 1, 0)
        searchIcon.Position = UDim2.new(0, 10, 0, 0)
        searchIcon.Text = "🔍"
        searchIcon.BackgroundTransparency = 1
        
        local searchBox = Instance.new("TextBox", searchFrame)
        searchBox.Size = UDim2.new(1, -50, 1, 0)
        searchBox.Position = UDim2.new(0, 40, 0, 0)
        searchBox.BackgroundTransparency = 1
        searchBox.PlaceholderText = placeholder or "Search..."
        searchBox.Text = ""
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 14
        searchBox.TextXAlignment = Enum.TextXAlignment.Left

        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            callback(searchBox.Text)
        end)
    end

    return TabElements
end

return NomNom [cite: 39, 40]
