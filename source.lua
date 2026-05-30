-- [[ NomNom UI Library V3: Ultra Premium Edition ]]
-- Fitur: Draggable Window, Live Theme Changer, RGB Dynamic Island, Smooth Sliders, Tabs, Sidebar, Dropdowns, Keybinds, Config, Key System

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Global Dragging Logic
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition = nil, nil, nil, nil
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

-- ================= FITUR KEY SYSTEM =================
function NomNom.KeySystem(config)
    local keyWindow = Instance.new("ScreenGui")
    keyWindow.Name = "NomNomKeySystem"
    keyWindow.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame", keyWindow)
    frame.Size = UDim2.new(0, 350, 0, 200)
    frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    frame.BackgroundTransparency = 0.05
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", frame).Color = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = config.Title .. " - Key System"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.BackgroundTransparency = 1
    
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0, 40)
    input.Position = UDim2.new(0.1, 0, 0.4, 0)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    input.PlaceholderText = "Enter Key Here..."
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.GothamMedium
    input.TextSize = 14
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
    
    local checkBtn = Instance.new("TextButton", frame)
    checkBtn.Size = UDim2.new(0.8, 0, 0, 40)
    checkBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    checkBtn.BackgroundColor3 = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    checkBtn.Text = "Verify Key"
    checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextSize = 14
    Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0, 8)
    
    checkBtn.MouseButton1Click:Connect(function()
        if input.Text == config.ExpectedKey then
            keyWindow:Destroy()
            config.Callback()
        else
            checkBtn.Text = "Invalid Key!"
            checkBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(1.5)
            checkBtn.Text = "Verify Key"
            checkBtn.BackgroundColor3 = config.ThemeColor or Color3.fromRGB(0, 170, 255)
        end
    end)
end

-- ================= CORE UI =================
function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    self.Title = config.Title or "NomNom Premium"
    self.Subtitle = config.Subtitle or "V3 Upgrade"
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.ThemeObjects = {} 
    self.Tabs = {}
    self.ConfigFolder = config.SaveConfigFolder or "NomNomConfigs"
    
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V3_Premium"
    sgui.ResetOnSpawn = false
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui
    
    -- Loading Screen (Existing)
    local loadingFrame = Instance.new("Frame", sgui)
    loadingFrame.Size = UDim2.new(0, 320, 0, 160)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    loadingFrame.BackgroundTransparency = 1
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 14)
    local lStroke = Instance.new("UIStroke", loadingFrame)
    lStroke.Color = self.CurrentThemeColor
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
    loadStatus.Text = "Initializing Systems..."
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
    
    TweenService:Create(barProgress, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.5, 0, 1, 0)}):Play()
    task.wait(0.8)
    loadStatus.Text = "Loading V3 Modules..."
    TweenService:Create(barProgress, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1.3)
    
    TweenService:Create(loadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(lStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(loadStatus, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(barProgress, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barBackground, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    loadingFrame:Destroy()

    -- Main Frame with Sidebar
    local mainFrame = Instance.new("Frame", sgui)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.ClipsDescendants = true
    self.MainFrame = mainFrame
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 1.5
    
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 650, 0, 420),
        Position = UDim2.new(0.5, -325, 0.5, -210)
    }):Play()
    
    -- Dynamic Island
    local island = Instance.new("TextButton", sgui)
    island.Text = ""
    island.Size = UDim2.new(0, 200, 0, 35)
    island.Position = UDim2.new(0.5, -100, 0, 20)
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    island.Visible = false
    island.AutoButtonColor = false
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
    
    -- Header & Sidebar Setup
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    MakeDraggable(header, mainFrame)
    
    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0, 200, 0, 25)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    local subTitleLabel = Instance.new("TextLabel", header)
    subTitleLabel.Size = UDim2.new(0, 200, 0, 15)
    subTitleLabel.Position = UDim2.new(0, 20, 0, 30)
    subTitleLabel.Text = self.Subtitle
    subTitleLabel.TextColor3 = self.CurrentThemeColor
    subTitleLabel.Font = Enum.Font.GothamMedium
    subTitleLabel.TextSize = 11
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subTitleLabel.BackgroundTransparency = 1
    table.insert(self.ThemeObjects, {Obj = subTitleLabel, Prop = "TextColor3"})
    
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0, 10)
    closeBtn.Text = "—"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundTransparency = 1
    
    local sidebar = Instance.new("ScrollingFrame", mainFrame)
    sidebar.Size = UDim2.new(0, 150, 1, -60)
    sidebar.Position = UDim2.new(0, 15, 0, 60)
    sidebar.BackgroundTransparency = 1
    sidebar.ScrollBarThickness = 0
    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0, 8)
    self.Sidebar = sidebar

    local contentArea = Instance.new("Frame", mainFrame)
    contentArea.Size = UDim2.new(1, -190, 1, -70)
    contentArea.Position = UDim2.new(0, 175, 0, 60)
    contentArea.BackgroundTransparency = 1
    self.ContentArea = contentArea
    
    -- Dynamic Island Toggle Logic
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
                Size = UDim2.new(0, 200, 0, 35), Position = UDim2.new(0.5, -100, 0, 20)
            }):Play()
        else
            island.Visible = false
            mainFrame.Visible = true
            mainFrame.BackgroundTransparency = 0.05
            for _, v in pairs(mainFrame:GetChildren()) do
                if v:IsA("GuiObject") then v.Visible = true end
            end
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 650, 0, 420), Position = UDim2.new(0.5, -325, 0.5, -210)
            }):Play()
        end
    end
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.MouseButton1Click:Connect(toggleUI)
    
    -- Toggle Keybind GUI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == (config.ToggleKey or Enum.KeyCode.RightControl) then
            toggleUI()
        end
    end)
    
    return self
end

-- ================= FITUR NOTIFIKASI =================
function NomNom:Notify(title, text, duration)
    local notifFrame = Instance.new("Frame", self.ScreenGui)
    notifFrame.Size = UDim2.new(0, 250, 0, 70)
    notifFrame.Position = UDim2.new(1, 50, 1, -100) -- Mulai di luar layar
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = self.CurrentThemeColor
    stroke.Thickness = 1.5
    
    local nTitle = Instance.new("TextLabel", notifFrame)
    nTitle.Size = UDim2.new(1, -20, 0, 25)
    nTitle.Position = UDim2.new(0, 10, 0, 5)
    nTitle.Text = title
    nTitle.Font = Enum.Font.GothamBold
    nTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    nTitle.TextSize = 14
    nTitle.TextXAlignment = Enum.TextXAlignment.Left
    nTitle.BackgroundTransparency = 1
    
    local nText = Instance.new("TextLabel", notifFrame)
    nText.Size = UDim2.new(1, -20, 0, 30)
    nText.Position = UDim2.new(0, 10, 0, 30)
    nText.Text = text
    nText.Font = Enum.Font.GothamMedium
    nText.TextColor3 = Color3.fromRGB(180, 180, 180)
    nText.TextSize = 12
    nText.TextWrapped = true
    nText.TextXAlignment = Enum.TextXAlignment.Left
    nText.BackgroundTransparency = 1
    
    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, -100)}):Play()
    task.delay(duration or 3, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 1, -100)}):Play()
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

-- ================= FITUR LIVE THEME CHANGER =================
function NomNom:ChangeTheme(newColor)
    self.CurrentThemeColor = newColor
    for _, item in pairs(self.ThemeObjects) do
        if item.Obj and item.Obj.Parent then
            if item.IsToggle then
                if item.StateObj() then TweenService:Create(item.Obj, TweenInfo.new(0.5), {[item.Prop] = newColor}):Play() end
            else
                TweenService:Create(item.Obj, TweenInfo.new(0.5), {[item.Prop] = newColor}):Play()
            end
        end
    end
end

-- ================= TAB SYSTEM =================
function NomNom:CreateTab(name)
    local tabBtn = Instance.new("TextButton", self.Sidebar)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    tabBtn.Text = "   " .. name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 14
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    
    local tabContainer = Instance.new("ScrollingFrame", self.ContentArea)
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = self.CurrentThemeColor
    tabContainer.Visible = false
    table.insert(self.ThemeObjects, {Obj = tabContainer, Prop = "ScrollBarImageColor3"})
    Instance.new("UIListLayout", tabContainer).Padding = UDim.new(0, 8)
    
    -- Auto show first tab
    if #self.Sidebar:GetChildren() == 2 then -- Termasuk UIListLayout
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        tabContainer.Visible = true
        self.ActiveTabContainer = tabContainer
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
        end
        for _, child in pairs(self.ContentArea:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        tabContainer.Visible = true
        
        -- Animation on switch
        tabContainer.Position = UDim2.new(0, 20, 0, 0)
        TweenService:Create(tabContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    
    local TabHandler = {}
    TabHandler.Container = tabContainer
    
    function TabHandler:CreateSection(secName)
        local secLabel = Instance.new("TextLabel", self.Container)
        secLabel.Size = UDim2.new(1, 0, 0, 30)
        secLabel.Text = "  " .. secName
        secLabel.Font = Enum.Font.GothamBold
        secLabel.TextSize = 13
        secLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        secLabel.TextXAlignment = Enum.TextXAlignment.Left
        secLabel.BackgroundTransparency = 1
        
        local line = Instance.new("Frame", secLabel)
        line.Size = UDim2.new(1, -10, 0, 1)
        line.Position = UDim2.new(0, 5, 1, 0)
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        line.BorderSizePixel = 0
    end
    
    function TabHandler:CreateButton(name, callback)
        local btn = Instance.new("TextButton", self.Container)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        btn.Text = "   " .. name
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(40, 40, 45)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = NomNom.CurrentThemeColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play()
        end)
        btn.MouseButton1Down:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36), Position = UDim2.new(0, 2, 0, 2)}):Play() end)
        btn.MouseButton1Up:Connect(function() 
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 0)}):Play()
            pcall(callback)
        end)
    end
    
    function TabHandler:CreateToggle(name, default, callback)
        local state = default or false
        local tf = Instance.new("Frame", self.Container)
        tf.Size = UDim2.new(1, 0, 0, 40)
        tf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", tf).Color = Color3.fromRGB(40, 40, 45)
        
        local label = Instance.new("TextLabel", tf)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local switchBG = Instance.new("TextButton", tf)
        switchBG.Size = UDim2.new(0, 36, 0, 20)
        switchBG.Position = UDim2.new(1, -50, 0.5, -10)
        switchBG.BackgroundColor3 = state and NomNom.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
        switchBG.Text = ""
        switchBG.AutoButtonColor = false
        Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)
        table.insert(NomNom.ThemeObjects, {Obj = switchBG, Prop = "BackgroundColor3", IsToggle = true, StateObj = function() return state end})
        
        local circle = Instance.new("Frame", switchBG)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        switchBG.MouseButton1Click:Connect(function()
            state = not state
            local targetColor = state and NomNom.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
            local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            pcall(callback, state)
        end)
    end
    
    function TabHandler:CreateSlider(name, min, max, default, callback)
        local sliderVal = default or min
        local sf = Instance.new("Frame", self.Container)
        sf.Size = UDim2.new(1, 0, 0, 55)
        sf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", sf).Color = Color3.fromRGB(40, 40, 45)
        
        local label = Instance.new("TextLabel", sf)
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local valLabel = Instance.new("TextLabel", sf)
        valLabel.Size = UDim2.new(0, 50, 0, 25)
        valLabel.Position = UDim2.new(1, -65, 0, 5)
        valLabel.Text = tostring(sliderVal)
        valLabel.TextColor3 = NomNom.CurrentThemeColor
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 13
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.BackgroundTransparency = 1
        table.insert(NomNom.ThemeObjects, {Obj = valLabel, Prop = "TextColor3"})
        
        local sliderBG = Instance.new("TextButton", sf)
        sliderBG.Size = UDim2.new(1, -30, 0, 6)
        sliderBG.Position = UDim2.new(0, 15, 0, 35)
        sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        sliderBG.Text = ""
        sliderBG.AutoButtonColor = false
        Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1, 0)
        
        local sliderFill = Instance.new("Frame", sliderBG)
        local fillScale = (sliderVal - min) / (max - min)
        sliderFill.Size = UDim2.new(fillScale, 0, 1, 0)
        sliderFill.BackgroundColor3 = NomNom.CurrentThemeColor
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
        table.insert(NomNom.ThemeObjects, {Obj = sliderFill, Prop = "BackgroundColor3"})
        
        local sliderKnob = Instance.new("Frame", sliderFill)
        sliderKnob.Size = UDim2.new(0, 12, 0, 12)
        sliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
        
        local dragging = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + ((max - min) * pos))
            valLabel.Text = tostring(value)
            TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
            pcall(callback, value)
        end
        
        sliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; updateSlider(input)
                TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}):Play()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(sliderKnob, TweenInfo.new(0.2), {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}):Play()
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
    end
    
    function TabHandler:CreateInput(name, placeholder, callback)
        local inf = Instance.new("Frame", self.Container)
        inf.Size = UDim2.new(1, 0, 0, 45)
        inf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", inf).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", inf).Color = Color3.fromRGB(40, 40, 45)
        
        local label = Instance.new("TextLabel", inf)
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local txtBox = Instance.new("TextBox", inf)
        txtBox.Size = UDim2.new(0.5, -15, 0, 30)
        txtBox.Position = UDim2.new(0.5, 0, 0.5, -15)
        txtBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        txtBox.Text = ""
        txtBox.PlaceholderText = placeholder or "Enter text..."
        txtBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        txtBox.Font = Enum.Font.GothamMedium
        txtBox.TextSize = 12
        txtBox.ClipsDescendants = true
        Instance.new("UICorner", txtBox).CornerRadius = UDim.new(0, 6)
        
        txtBox.FocusLost:Connect(function()
            pcall(callback, txtBox.Text)
        end)
    end

    function TabHandler:CreateDropdown(name, list, callback)
        local dropFrame = Instance.new("Frame", self.Container)
        dropFrame.Size = UDim2.new(1, 0, 0, 45)
        dropFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        dropFrame.ClipsDescendants = true
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", dropFrame).Color = Color3.fromRGB(40, 40, 45)
        
        local dropBtn = Instance.new("TextButton", dropFrame)
        dropBtn.Size = UDim2.new(1, 0, 0, 45)
        dropBtn.BackgroundTransparency = 1
        dropBtn.Text = "   " .. name
        dropBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        dropBtn.Font = Enum.Font.GothamMedium
        dropBtn.TextSize = 13
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local selectedText = Instance.new("TextLabel", dropBtn)
        selectedText.Size = UDim2.new(0, 100, 1, 0)
        selectedText.Position = UDim2.new(1, -120, 0, 0)
        selectedText.Text = "..."
        selectedText.TextColor3 = NomNom.CurrentThemeColor
        selectedText.Font = Enum.Font.GothamBold
        selectedText.TextSize = 12
        selectedText.TextXAlignment = Enum.TextXAlignment.Right
        selectedText.BackgroundTransparency = 1
        table.insert(NomNom.ThemeObjects, {Obj = selectedText, Prop = "TextColor3"})
        
        local listScroll = Instance.new("ScrollingFrame", dropFrame)
        listScroll.Size = UDim2.new(1, -20, 1, -55)
        listScroll.Position = UDim2.new(0, 10, 0, 45)
        listScroll.BackgroundTransparency = 1
        listScroll.ScrollBarThickness = 2
        local listLayout = Instance.new("UIListLayout", listScroll)
        listLayout.Padding = UDim.new(0, 5)
        
        local isOpen = false
        dropBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            local targetSize = isOpen and UDim2.new(1, 0, 0, 45 + (#list * 35)) or UDim2.new(1, 0, 0, 45)
            if targetSize.Y.Offset > 150 then targetSize = UDim2.new(1, 0, 0, 150) end
            TweenService:Create(dropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        end)
        
        for _, item in pairs(list) do
            local itemBtn = Instance.new("TextButton", listScroll)
            itemBtn.Size = UDim2.new(1, 0, 0, 30)
            itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            itemBtn.Text = item
            itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemBtn.Font = Enum.Font.GothamMedium
            itemBtn.TextSize = 12
            Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 6)
            
            itemBtn.MouseButton1Click:Connect(function()
                selectedText.Text = item
                isOpen = false
                TweenService:Create(dropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                pcall(callback, item)
            end)
        end
    end
    
    function TabHandler:CreateKeybind(name, defaultKey, callback)
        local key = defaultKey or Enum.KeyCode.E
        local keyf = Instance.new("Frame", self.Container)
        keyf.Size = UDim2.new(1, 0, 0, 45)
        keyf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
        Instance.new("UICorner", keyf).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", keyf).Color = Color3.fromRGB(40, 40, 45)
        
        local label = Instance.new("TextLabel", keyf)
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local keyBtn = Instance.new("TextButton", keyf)
        keyBtn.Size = UDim2.new(0, 80, 0, 30)
        keyBtn.Position = UDim2.new(1, -95, 0.5, -15)
        keyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        keyBtn.Text = key.Name
        keyBtn.TextColor3 = NomNom.CurrentThemeColor
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 12
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
        table.insert(NomNom.ThemeObjects, {Obj = keyBtn, Prop = "TextColor3"})
        
        local binding = false
        keyBtn.MouseButton1Click:Connect(function()
            binding = true
            keyBtn.Text = "..."
        end)
        
        UserInputService.InputBegan:Connect(function(input)
            if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                binding = false
                key = input.KeyCode
                keyBtn.Text = key.Name
            elseif not binding and input.KeyCode == key then
                pcall(callback)
            end
        end)
    end

    return TabHandler
end

-- ================= CONFIG SAVING =================
function NomNom:SaveConfig(filename, dataTable)
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end
    local json = HttpService:JSONEncode(dataTable)
    writefile(self.ConfigFolder .. "/" .. filename .. ".json", json)
    self:Notify("Config Saved", "Successfully saved to " .. filename, 3)
end

function NomNom:LoadConfig(filename)
    local path = self.ConfigFolder .. "/" .. filename .. ".json"
    if isfile(path) then
        local json = readfile(path)
        local data = HttpService:JSONDecode(json)
        self:Notify("Config Loaded", "Successfully loaded " .. filename, 3)
        return data
    end
    self:Notify("Error", "Config file not found!", 3)
    return nil
end

return NomNom
