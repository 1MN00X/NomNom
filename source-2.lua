-- [[ NomNom UI Library V2: Ultra Premium Edition ]]
-- Fitur: Draggable Window, Live Theme Changer, RGB Dynamic Island, Smooth Sliders, Ultra Animations
-- Update: Tab System, Section System, Label, Textbox, Dropdown, Keybind

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Global Dragging Logic
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- ================= SECTION CLASS =================
local Section = {}
Section.__index = Section

function Section.new(parentContainer, name)
    local self = setmetatable({}, Section)
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
    sectionFrame.BackgroundTransparency = 0
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.Parent = parentContainer
    
    Instance.new("UICorner", sectionFrame).CornerRadius = UDim.new(0, 8)
    
    local sectionStroke = Instance.new("UIStroke", sectionFrame)
    sectionStroke.Color = Color3.fromRGB(35, 35, 40)
    sectionStroke.Thickness = 1
    
    local headerFrame = Instance.new("Frame", sectionFrame)
    headerFrame.Size = UDim2.new(1, 0, 0, 35)
    headerFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    headerFrame.BackgroundTransparency = 0
    
    local headerCorner = Instance.new("UICorner", headerFrame)
    headerCorner.CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel", headerFrame)
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    local contentFrame = Instance.new("Frame", sectionFrame)
    contentFrame.Size = UDim2.new(1, -20, 0, 0)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local uiList = Instance.new("UIListLayout", contentFrame)
    uiList.Padding = UDim.new(0, 8)
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    self.Frame = sectionFrame
    self.Content = contentFrame
    self.UIList = uiList
    self.Components = {}
    
    return self
end

function Section:AddComponent(component)
    table.insert(self.Components, component)
    component.Parent = self.Content
    return component
end

-- ================= TAB CLASS =================
local Tab = {}
Tab.__index = Tab

function Tab.new(parentContainer, name, themeColor)
    local self = setmetatable({}, Tab)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = themeColor
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = parentContainer
    page.Visible = false
    
    local uiList = Instance.new("UIListLayout", page)
    uiList.Padding = UDim.new(0, 10)
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    self.Page = page
    self.UIList = uiList
    self.Name = name
    self.Sections = {}
    
    return self
end

function Tab:CreateSection(name)
    local section = Section.new(self.Page, name)
    table.insert(self.Sections, section)
    return section
end

-- ================= WINDOW CLASS =================
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "NomNom Premium"
    self.LogoId = config.LogoId or ""
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.ThemeObjects = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V2_Premium"
    sgui.ResetOnSpawn = false
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui
    
    -- ==========================================
    -- 1. ULTRA PREMIUM LOADING SCREEN
    -- ==========================================
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 320, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    loadingFrame.BackgroundTransparency = 1
    loadingFrame.Parent = sgui
    
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 14)
    local lStroke = Instance.new("UIStroke", loadingFrame)
    lStroke.Color = self.CurrentThemeColor
    lStroke.Thickness = 0
    lStroke.Transparency = 1
    
    local loadTitle = Instance.new("TextLabel", loadingFrame)
    loadTitle.Size = UDim2.new(1, 0, 0, 40)
    loadTitle.Position = UDim2.new(0, 0, 0, 30)
    loadTitle.Text = self.Title
    loadTitle.Font = Enum.Font.GothamBlack
    loadTitle.TextSize = 24
    loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadTitle.BackgroundTransparency = 1
    loadTitle.TextTransparency = 1
    
    local barBackground = Instance.new("Frame", loadingFrame)
    barBackground.Size = UDim2.new(0, 260, 0, 4)
    barBackground.Position = UDim2.new(0.5, -130, 0, 95)
    barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    barBackground.BackgroundTransparency = 1
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0)
    
    local barProgress = Instance.new("Frame", barBackground)
    barProgress.Size = UDim2.new(0, 0, 1, 0)
    barProgress.BackgroundColor3 = self.CurrentThemeColor
    Instance.new("UICorner", barProgress).CornerRadius = UDim.new(1, 0)
    
    local loadStatus = Instance.new("TextLabel", loadingFrame)
    loadStatus.Size = UDim2.new(1, 0, 0, 20)
    loadStatus.Position = UDim2.new(0, 0, 0, 110)
    loadStatus.Text = "Initializing Core Systems..."
    loadStatus.Font = Enum.Font.GothamMedium
    loadStatus.TextSize = 12
    loadStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    loadStatus.BackgroundTransparency = 1
    loadStatus.TextTransparency = 1

    TweenService:Create(loadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(lStroke, TweenInfo.new(0.5), {Thickness = 1.5, Transparency = 0}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(loadStatus, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(barBackground, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    task.wait(0.6)
    
    TweenService:Create(barProgress, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.3, 0, 1, 0)}):Play()
    task.wait(0.8)
    loadStatus.Text = "Fetching UI Elements..."
    TweenService:Create(barProgress, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.75, 0, 1, 0)}):Play()
    task.wait(1.3)
    loadStatus.Text = "Welcome to the Future."
    TweenService:Create(barProgress, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.6)
    
    TweenService:Create(loadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(lStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(loadStatus, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(barProgress, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    loadingFrame:Destroy()

    -- ==========================================
    -- 2. MAIN PREMIUM FRAME & DYNAMIC ISLAND
    -- ==========================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    self.MainFrame = mainFrame
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 1.5
    
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 450),
        Position = UDim2.new(0.5, -300, 0.5, -225)
    }):Play()
    
    -- Dynamic Island
    local island = Instance.new("TextButton")
    island.Text = ""
    island.Size = UDim2.new(0, 200, 0, 35)
    island.Position = UDim2.new(0.5, -100, 0, 20)
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    island.Visible = false
    island.AutoButtonColor = false
    island.Parent = sgui
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
    
    local islandStroke = Instance.new("UIStroke", island)
    islandStroke.Color = self.CurrentThemeColor
    islandStroke.Thickness = 1.5
    table.insert(self.ThemeObjects, {Obj = islandStroke, Prop = "Color"})
    
    local islandText = Instance.new("TextLabel", island)
    islandText.Size = UDim2.new(1, -40, 1, 0)
    islandText.Position = UDim2.new(0, 20, 0, 0)
    islandText.BackgroundTransparency = 1
    islandText.Text = self.Title
    islandText.TextColor3 = Color3.fromRGB(255, 255, 255)
    islandText.Font = Enum.Font.GothamBold
    islandText.TextSize = 13
    islandText.TextXAlignment = Enum.TextXAlignment.Left
    
    local rgbLight = Instance.new("Frame", island)
    rgbLight.Size = UDim2.new(0, 8, 0, 8)
    rgbLight.Position = UDim2.new(1, -20, 0.5, -4)
    rgbLight.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", rgbLight).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        local hue = 0
        while task.wait() do
            hue = hue + 0.005
            if hue >= 1 then hue = 0 end
            rgbLight.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
    end)
    
    self.Island = island
    self.IsOpen = true
    
    -- Header UI Utama (Draggable Area)
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    MakeDraggable(header, mainFrame)
    
    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0, 300, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
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
    
    -- Tab Bar
    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 50)
    tabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    tabBar.BackgroundTransparency = 0
    
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Container untuk Pages
    local pageContainer = Instance.new("Frame", mainFrame)
    pageContainer.Size = UDim2.new(1, -40, 1, -100)
    pageContainer.Position = UDim2.new(0, 20, 0, 95)
    pageContainer.BackgroundTransparency = 1
    self.PageContainer = pageContainer
    
    -- Fungsi Transisi Dynamic Island
    local function toggleUI()
        self.IsOpen = not self.IsOpen
        if not self.IsOpen then
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 35),
                Position = UDim2.new(0.5, -100, 0, 20),
                BackgroundTransparency = 1
            }):Play()
            
            for _, v in pairs(mainFrame:GetChildren()) do
                if v:IsA("GuiObject") then v.Visible = false end
            end
            
            task.wait(0.3)
            mainFrame.Visible = false
            island.Visible = true
            
            island.Size = UDim2.new(0, 150, 0, 25)
            island.Position = UDim2.new(0.5, -75, 0, 25)
            TweenService:Create(island, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 35),
                Position = UDim2.new(0.5, -100, 0, 20)
            }):Play()
        else
            island.Visible = false
            mainFrame.Visible = true
            mainFrame.BackgroundTransparency = 0.05
            
            for _, v in pairs(mainFrame:GetChildren()) do
                if v:IsA("GuiObject") then v.Visible = true end
            end
            
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 450),
                Position = UDim2.new(0.5, -300, 0.5, -225)
            }):Play()
        end
    end
    
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.MouseButton1Click:Connect(toggleUI)
    
    self.TabBar = tabBar
    self.TabButtons = {}
    
    return self
end

function Window:CreateTab(name)
    local tab = Tab.new(self.PageContainer, name, self.CurrentThemeColor)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 0, 30)
    tabButton.Position = UDim2.new(0, 0, 0, 5)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(170, 170, 170)
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.TextSize = 13
    tabButton.BackgroundTransparency = 1
    tabButton.Parent = self.TabBar
    
    local activeLine = Instance.new("Frame", tabButton)
    activeLine.Size = UDim2.new(1, -10, 0, 2)
    activeLine.Position = UDim2.new(0.5, -5, 1, -2)
    activeLine.BackgroundColor3 = self.CurrentThemeColor
    activeLine.BackgroundTransparency = 1
    Instance.new("UICorner", activeLine).CornerRadius = UDim.new(1, 0)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
        end
        for _, btn in pairs(self.TabButtons) do
            btn.TextColor3 = Color3.fromRGB(170, 170, 170)
            for _, line in pairs(btn:GetChildren()) do
                if line:IsA("Frame") then
                    TweenService:Create(line, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
        end
        tab.Page.Visible = true
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(activeLine, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    if #self.Tabs == 0 then
        tab.Page.Visible = true
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeLine.BackgroundTransparency = 0
    end
    
    table.insert(self.Tabs, tab)
    table.insert(self.TabButtons, tabButton)
    
    return tab
end

function Window:ChangeTheme(newColor)
    self.CurrentThemeColor = newColor
    for _, item in pairs(self.ThemeObjects) do
        if item.Obj and item.Obj.Parent then
            TweenService:Create(item.Obj, TweenInfo.new(0.5), {[item.Prop] = newColor}):Play()
        end
    end
    for _, btn in pairs(self.TabButtons) do
        for _, line in pairs(btn:GetChildren()) do
            if line:IsA("Frame") then
                TweenService:Create(line, TweenInfo.new(0.5), {BackgroundColor3 = newColor}):Play()
            end
        end
    end
    for _, tab in pairs(self.Tabs) do
        tab.Page.ScrollBarImageColor3 = newColor
    end
end

-- ================= KOMPONEN UI =================

function Section:CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    stroke.Thickness = 1
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.WindowTheme or Color3.fromRGB(0, 170, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36), Position = UDim2.new(0, 2, 0, 2)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 0)}):Play()
        if callback then callback() end
    end)
    
    return self:AddComponent(btn)
end

function Section:CreateToggle(name, default, callback)
    local state = default or false
    local WindowTheme = self.WindowTheme or Color3.fromRGB(0, 170, 255)
    
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 45)
    tf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", tf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", tf)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local switchBG = Instance.new("TextButton", tf)
    switchBG.Size = UDim2.new(0, 40, 0, 22)
    switchBG.Position = UDim2.new(1, -55, 0.5, -11)
    switchBG.BackgroundColor3 = state and WindowTheme or Color3.fromRGB(50, 50, 55)
    switchBG.Text = ""
    switchBG.AutoButtonColor = false
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switchBG)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switchBG.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and WindowTheme or Color3.fromRGB(50, 50, 55)
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        
        TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        if callback then callback(state) end
    end)
    
    return self:AddComponent(tf)
end

function Section:CreateSlider(name, min, max, default, callback)
    local sliderVal = default or min
    
    local sf = Instance.new("Frame")
    sf.Size = UDim2.new(1, 0, 0, 70)
    sf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", sf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", sf)
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local valLabel = Instance.new("TextLabel", sf)
    valLabel.Size = UDim2.new(0, 50, 0, 25)
    valLabel.Position = UDim2.new(1, -65, 0, 5)
    valLabel.Text = tostring(sliderVal)
    valLabel.TextColor3 = self.WindowTheme or Color3.fromRGB(0, 170, 255)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 14
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.BackgroundTransparency = 1
    
    local sliderBG = Instance.new("TextButton", sf)
    sliderBG.Size = UDim2.new(1, -30, 0, 6)
    sliderBG.Position = UDim2.new(0, 15, 0, 50)
    sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sliderBG.Text = ""
    sliderBG.AutoButtonColor = false
    Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1, 0)
    
    local fillScale = (sliderVal - min) / (max - min)
    local sliderFill = Instance.new("Frame", sliderBG)
    sliderFill.Size = UDim2.new(fillScale, 0, 1, 0)
    sliderFill.BackgroundColor3 = self.WindowTheme or Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local sliderKnob = Instance.new("Frame", sliderFill)
    sliderKnob.Size = UDim2.new(0, 14, 0, 14)
    sliderKnob.Position = UDim2.new(1, -7, 0.5, -7)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        
        valLabel.Text = tostring(value)
        TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        if callback then callback(value) end
    end
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
            TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -9, 0.5, -9)}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return self:AddComponent(sf)
end

function Section:CreateLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    label.Text = "   " .. text
    label.TextColor3 = Color3.fromRGB(180, 180, 190)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
    
    return self:AddComponent(label)
end

function Section:CreateTextbox(config)
    local name = config.Name or "Input"
    local placeholder = config.Placeholder or "Type here..."
    local callback = config.Callback
    
    local tf = Instance.new("Frame")
    tf.Size = UDim2.new(1, 0, 0, 55)
    tf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", tf)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local textbox = Instance.new("TextBox", tf)
    textbox.Size = UDim2.new(1, -30, 0, 28)
    textbox.Position = UDim2.new(0, 15, 0, 25)
    textbox.PlaceholderText = placeholder
    textbox.Text = ""
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    textbox.Font = Enum.Font.GothamMedium
    textbox.TextSize = 13
    textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    textbox.BackgroundTransparency = 0
    Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", textbox)
    stroke.Color = Color3.fromRGB(45, 45, 50)
    stroke.Thickness = 1
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textbox.Text)
        end
    end)
    
    return self:AddComponent(tf)
end

function Section:CreateDropdown(config)
    local name = config.Name or "Dropdown"
    local options = config.Options or {}
    local callback = config.Callback
    
    local expanded = false
    local WindowTheme = self.WindowTheme or Color3.fromRGB(0, 170, 255)
    
    local df = Instance.new("Frame")
    df.Size = UDim2.new(1, 0, 0, 45)
    df.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", df).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", df)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local selectedLabel = Instance.new("TextLabel", df)
    selectedLabel.Size = UDim2.new(0, 120, 1, 0)
    selectedLabel.Position = UDim2.new(1, -135, 0, 0)
    selectedLabel.Text = options[1] or "None"
    selectedLabel.TextColor3 = WindowTheme
    selectedLabel.Font = Enum.Font.GothamBold
    selectedLabel.TextSize = 12
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    selectedLabel.BackgroundTransparency = 1
    
    local arrow = Instance.new("TextLabel", df)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 160)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.BackgroundTransparency = 1
    
    local dropdownList = Instance.new("Frame", df)
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 0, 45)
    dropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    dropdownList.ClipsDescendants = true
    dropdownList.Visible = false
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 8)
    
    local listLayout = Instance.new("UIListLayout", dropdownList)
    listLayout.Padding = UDim.new(0, 2)
    
    local optionButtons = {}
    
    for _, option in pairs(options) do
        local optBtn = Instance.new("TextButton", dropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 35)
        optBtn.Text = "   " .. option
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.TextSize = 13
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
        optBtn.AutoButtonColor = false
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)
        
        optBtn.MouseButton1Click:Connect(function()
            selectedLabel.Text = option
            if callback then callback(option) end
            expanded = false
            TweenService:Create(dropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(0.25)
            dropdownList.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
        end)
        
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end)
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
        end)
        
        table.insert(optionButtons, optBtn)
    end
    
    local button = Instance.new("TextButton", df)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    
    button.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local count = #optionButtons
            local totalHeight = (count * 35) + ((count - 1) * 2) + 10
            dropdownList.Visible = true
            TweenService:Create(dropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(dropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(0.25)
            dropdownList.Visible = false
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
        end
    end)
    
    return self:AddComponent(df)
end

function Section:CreateKeybind(config)
    local name = config.Name or "Keybind"
    local defaultKey = config.Default or Enum.KeyCode.F
    local callback = config.Callback
    
    local kf = Instance.new("Frame")
    kf.Size = UDim2.new(1, 0, 0, 45)
    kf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", kf).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", kf)
    label.Size = UDim2.new(1, -140, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local keyLabel = Instance.new("TextButton", kf)
    keyLabel.Size = UDim2.new(0, 100, 0, 30)
    keyLabel.Position = UDim2.new(1, -115, 0.5, -15)
    keyLabel.Text = tostring(defaultKey):gsub("Enum.KeyCode.", "")
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 12
    keyLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    keyLabel.AutoButtonColor = false
    Instance.new("UICorner", keyLabel).CornerRadius = UDim.new(0, 6)
    
    local listening = false
    local currentKey = defaultKey
    
    local function updateKeyDisplay()
        keyLabel.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
    end
    
    keyLabel.MouseButton1Click:Connect(function()
        listening = true
        keyLabel.Text = "..."
        keyLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                updateKeyDisplay()
                if callback then callback(currentKey) end
                listening = false
                keyLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                connection:Disconnect()
            end
        end)
        
        task.wait(5)
        if listening then
            listening = false
            updateKeyDisplay()
            keyLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            if connection then connection:Disconnect() end
        end
    end)
    
    return self:AddComponent(kf)
end

-- Untuk backward compatibility dengan code lama
function NomNom.new(config)
    local window = Window.new(config)
    
    -- Method lama untuk kompatibilitas
    window.CreateButton = function(_, name, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateButton(name, callback)
    end
    
    window.CreateToggle = function(_, name, default, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateToggle(name, default, callback)
    end
    
    window.CreateSlider = function(_, name, min, max, default, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateSlider(name, min, max, default, callback)
    end
    
    window.ChangeTheme = function(self, newColor)
        return window:ChangeTheme(newColor)
    end
    
    return window
end

return NomNom
