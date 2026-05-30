-- [[ NomNom UI Library V3: Grand Ultra Premium Edition ]]
-- Premium Aesthetics: Glassmorphism, Neon Gradients, Active Sidebar, Search Filter, Auto Config, Secure Key System

local NomNom = {}
NomNom.__index = NomNom

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Themes Configuration
local Themes = {
    Dark = {
        Background = Color3.fromRGB(15, 15, 20),
        Sidebar = Color3.fromRGB(20, 20, 28),
        Element = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(160, 160, 170),
        Stroke = Color3.fromRGB(45, 45, 60),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Sidebar = Color3.fromRGB(225, 225, 235),
        Element = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(25, 25, 30),
        SubText = Color3.fromRGB(100, 100, 110),
        Stroke = Color3.fromRGB(210, 210, 220),
    }
}

-- Utility: Draggable Window
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
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
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    -- Configs
    self.Title = config.Title or "NomNom Hub"
    self.Subtitle = config.Subtitle or "Premium Edition"
    self.Width = config.Width or 650
    self.Height = config.Height or 420
    self.ThemeMode = "Dark"
    self.Theme = Themes[self.ThemeMode]
    self.NeonColor = config.NeonColor or Color3.fromRGB(0, 210, 255)
    
    self.Tabs = {}
    self.ActiveTab = nil
    self.Registry = {} -- For config saving
    self.AllElements = {} -- For Search Bar feature
    
    -- Key System Check Configuration
    self.KeySystemEnabled = config.KeySystem or false
    self.CorrectKey = config.Key or ""
    self.KeyLink = config.KeyLink or ""
    
    -- ScreenGui Setup
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NomNom_V3_Ultimate"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    
    -- Setup Notifications Container
    self.NotifContainer = Instance.new("Frame", self.ScreenGui)
    self.NotifContainer.Size = UDim2.new(0, 300, 1, -40)
    self.NotifContainer.Position = UDim2.new(1, -320, 0, 20)
    self.NotifContainer.BackgroundTransparency = 1
    local notifLayout = Instance.new("UIListLayout", self.NotifContainer)
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 10)

    if self.KeySystemEnabled then
        self:CreateKeySystem()
    else
        self:StartUI()
    end
    
    return self
end

-- ================= CONFIGURATION & SAVING SYSTEM =================
function NomNom:SaveConfig()
    if not isfolder or not writefile then return end
    if not isfolder("NomNom_Configs") then makefolder("NomNom_Configs") end
    
    local data = {}
    for flag, target in pairs(self.Registry) do
        data[flag] = target.Value
    end
    writefile("NomNom_Configs/" .. game.PlaceId .. ".json", HttpService:JSONEncode(data))
end

function NomNom:LoadConfig()
    if not isfolder or not readfile then return end
    local path = "NomNom_Configs/" .. game.PlaceId .. ".json"
    if not isfile(path) then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    
    if success and type(data) == "table" then
        for flag, value in pairs(data) do
            if self.Registry[flag] then
                self.Registry[flag].Update(value)
            end
        end
    end
end

-- ================= NOTIFICATION SYSTEM =================
function NomNom:CreateNotification(title, message, duration)
    duration = duration or 4
    local card = Instance.new("Frame", self.NotifContainer)
    card.Size = UDim2.new(1, 0, 0, 70)
    card.BackgroundColor3 = self.Theme.Background
    card.BackgroundTransparency = 0.1
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = self.NeonColor
    stroke.Thickness = 1.5
    
    local tLabel = Instance.new("TextLabel", card)
    tLabel.Size = UDim2.new(1, -20, 0, 25)
    tLabel.Position = UDim2.new(0, 10, 0, 5)
    tLabel.Text = title
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextColor3 = self.Theme.Text
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.BackgroundTransparency = 1
    
    local mLabel = Instance.new("TextLabel", card)
    mLabel.Size = UDim2.new(1, -20, 0, 35)
    mLabel.Position = UDim2.new(0, 10, 0, 25)
    mLabel.Text = message
    mLabel.Font = Enum.Font.GothamMedium
    mLabel.TextColor3 = self.Theme.SubText
    mLabel.TextSize = 11
    mLabel.TextWrapped = true
    mLabel.TextXAlignment = Enum.TextXAlignment.Left
    mLabel.BackgroundTransparency = 1
    
    card.Size = UDim2.new(0, 0, 0, 70)
    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 70)}):Play()
    
    task.delay(duration, function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1, Transparency = 1}):Play()
        TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(mLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        task.wait(0.3)
        card:Destroy()
    end)
end

-- ================= SECURITY KEY SYSTEM =================
function NomNom:CreateKeySystem()
    local frame = Instance.new("Frame", self.ScreenGui)
    frame.Size = UDim2.new(0, 340, 0, 200)
    frame.Position = UDim2.new(0.5, -170, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = self.NeonColor
    stroke.Thickness = 1.5
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Verification Required"
    title.Font = Enum.Font.GothamBlack
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.BackgroundTransparency = 1
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -40, 0, 36)
    box.Position = UDim2.new(0, 20, 0, 60)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.PlaceholderText = "Enter Activation Key..."
    box.Text = ""
    box.Font = Enum.Font.GothamMedium
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", box).Color = Color3.fromRGB(45, 45, 60)
    
    local verifyBtn = Instance.new("TextButton", frame)
    verifyBtn.Size = UDim2.new(0, 140, 0, 36)
    verifyBtn.Position = UDim2.new(0, 20, 0, 115)
    verifyBtn.BackgroundColor3 = self.NeonColor
    verifyBtn.Text = "Verify Key"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 13
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 6)
    
    local getBtn = Instance.new("TextButton", frame)
    getBtn.Size = UDim2.new(0, 140, 0, 36)
    getBtn.Position = UDim2.new(1, -160, 0, 115)
    getBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    getBtn.Text = "Get Key Link"
    getBtn.Font = Enum.Font.GothamBold
    getBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    getBtn.TextSize = 13
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0, 6)
    
    getBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(self.KeyLink) end
        self:CreateNotification("System", "Key link copied to clipboard!", 3)
    end)
    
    verifyBtn.MouseButton1Click:Connect(function()
        if box.Text == self.CorrectKey then
            TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
            task.wait(0.4)
            frame:Destroy()
            self:StartUI()
        else
            self:CreateNotification("Error", "Invalid activation key try again.", 3)
        end
    end)
end

-- ================= INTERFACE INITIALIZATION =================
function NomNom:StartUI()
    -- PRESTIGE LOADING SCREEN
    local loadFrame = Instance.new("Frame", self.ScreenGui)
    loadFrame.Size = UDim2.new(0, 300, 0, 140)
    loadFrame.Position = UDim2.new(0.5, -150, 0.5, -70)
    loadFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0, 12)
    local lStroke = Instance.new("UIStroke", loadFrame)
    lStroke.Color = self.NeonColor
    lStroke.Thickness = 1.5
    
    local lTitle = Instance.new("TextLabel", loadFrame)
    lTitle.Size = UDim2.new(1, 0, 0, 40)
    lTitle.Position = UDim2.new(0, 0, 0, 20)
    lTitle.Text = self.Title
    lTitle.Font = Enum.Font.GothamBlack
    lTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    lTitle.TextSize = 22
    lTitle.BackgroundTransparency = 1
    
    local barBG = Instance.new("Frame", loadFrame)
    barBG.Size = UDim2.new(0, 240, 0, 4)
    barBG.Position = UDim2.new(0.5, -120, 0, 80)
    barBG.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)
    
    local barFill = Instance.new("Frame", barBG)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = self.NeonColor
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
    
    TweenService:Create(barFill, TweenInfo.new(1.5, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1.7)
    loadFrame:Destroy()
    
    -- MAIN WINDOW CREATION (GLASSMORPHISM STYLE)
    local main = Instance.new("Frame", self.ScreenGui)
    main.Size = UDim2.new(0, self.Width, 0, self.Height)
    main.Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2)
    main.BackgroundColor3 = self.Theme.Background
    main.BackgroundTransparency = 0.08
    main.ClipsDescendants = true
    self.MainFrame = main
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local mStroke = Instance.new("UIStroke", main)
    mStroke.Color = self.Theme.Stroke
    mStroke.Thickness = 1.5
    
    -- Subtle Particle Effect Layer
    local particleLayer = Instance.new("Frame", main)
    particleLayer.Size = UDim2.new(1, 0, 1, 0)
    particleLayer.BackgroundTransparency = 1
    task.spawn(function()
        while task.wait(0.8) do
            if not main or not main.Parent then break end
            if math.random(1,2) == 1 then
                local p = Instance.new("Frame", particleLayer)
                p.Size = UDim2.new(0, 4, 0, 4)
                p.Position = UDim2.new(math.random(), 0, 1, 0)
                p.BackgroundColor3 = self.NeonColor
                p.BackgroundTransparency = 0.4
                Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
                TweenService:Create(p, TweenInfo.new(3, Enum.EasingStyle.Quad), {Position = UDim2.new(p.Position.X.Scale, 0, -0.1, 0), BackgroundTransparency = 1}):Play()
                game:GetService("Debris"):AddItem(p, 3.2)
            end
        end
    end)
    
    -- DYNAMIC ISLAND COMPONENT
    local island = Instance.new("TextButton", self.ScreenGui)
    island.Size = UDim2.new(0, 220, 0, 36)
    island.Position = UDim2.new(0.5, -110, 0, 15)
    island.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    island.Visible = false
    island.Text = ""
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
    local iStroke = Instance.new("UIStroke", island)
    iStroke.Color = self.NeonColor
    iStroke.Thickness = 1.5
    
    local islText = Instance.new("TextLabel", island)
    islText.Size = UDim2.new(1, -40, 1, 0)
    islText.Position = UDim2.new(0, 15, 0, 0)
    islText.Text = self.Title .. " • minimized"
    islText.Font = Enum.Font.GothamBold
    islText.TextColor3 = Color3.fromRGB(255, 255, 255)
    islText.TextSize = 12
    islText.TextXAlignment = Enum.TextXAlignment.Left
    islText.BackgroundTransparency = 1
    
    local rIndicator = Instance.new("Frame", island)
    rIndicator.Size = UDim2.new(0, 6, 0, 6)
    rIndicator.Position = UDim2.new(1, -20, 0.5, -3)
    Instance.new("UICorner", rIndicator).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        local h = 0
        while task.wait() do
            h = h + 0.005
            rIndicator.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        end
    end)
    
    -- TOP BAR & NAVIGATION ELEMENTS
    local topbar = Instance.new("Frame", main)
    topbar.Size = UDim2.new(1, 0, 0, 50)
    topbar.BackgroundTransparency = 1
    MakeDraggable(topbar, main)
    
    local mainTitle = Instance.new("TextLabel", topbar)
    mainTitle.Size = UDim2.new(0, 200, 0, 25)
    mainTitle.Position = UDim2.new(0, 20, 0, 8)
    mainTitle.Text = self.Title
    mainTitle.Font = Enum.Font.GothamBlack
    mainTitle.TextColor3 = self.Theme.Text
    mainTitle.TextSize = 16
    mainTitle.TextXAlignment = Enum.TextXAlignment.Left
    mainTitle.BackgroundTransparency = 1
    
    local mainSub = Instance.new("TextLabel", topbar)
    mainSub.Size = UDim2.new(0, 200, 0, 15)
    mainSub.Position = UDim2.new(0, 20, 0, 28)
    mainSub.Text = self.Subtitle
    mainSub.Font = Enum.Font.GothamMedium
    mainSub.TextColor3 = self.Theme.SubText
    mainSub.TextSize = 11
    mainSub.TextXAlignment = Enum.TextXAlignment.Left
    mainSub.BackgroundTransparency = 1
    
    -- SEARCH BAR FILTER SYSTEM
    local searchBG = Instance.new("Frame", topbar)
    searchBG.Size = UDim2.new(0, 180, 0, 28)
    searchBG.Position = UDim2.new(1, -310, 0.5, -14)
    searchBG.BackgroundColor3 = self.Theme.Sidebar
    Instance.new("UICorner", searchBG).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", searchBG).Color = self.Theme.Stroke
    
    local searchBox = Instance.new("TextBox", searchBG)
    searchBox.Size = UDim2.new(1, -10, 1, 0)
    searchBox.Position = UDim2.new(0, 5, 0, 0)
    searchBox.PlaceholderText = "🔍 Search features..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextColor3 = self.Theme.Text
    searchBox.TextSize = 12
    searchBox.BackgroundTransparency = 1
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for _, elem in pairs(self.AllElements) do
            if query == "" then
                elem.Frame.Visible = true
            else
                if elem.Name:lower():find(query) then
                    elem.Frame.Visible = true
                else
                    elem.Frame.Visible = false
                end
            end
        end
    end)
    
    -- MINIMIZE BUTTON
    local minBtn = Instance.new("TextButton", topbar)
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -85, 0, 10)
    minBtn.Text = "—"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextColor3 = self.Theme.SubText
    minBtn.TextSize = 14
    minBtn.BackgroundTransparency = 1
    
    -- THEME SWITCHER
    local tBtn = Instance.new("TextButton", topbar)
    tBtn.Size = UDim2.new(0, 30, 0, 30)
    tBtn.Position = UDim2.new(1, -120, 0, 10)
    tBtn.Text = "🌓"
    tBtn.Font = Enum.Font.GothamBold
    tBtn.TextSize = 14
    tBtn.BackgroundTransparency = 1
    
    tBtn.MouseButton1Click:Connect(function()
        self.ThemeMode = (self.ThemeMode == "Dark") and "Light" or "Dark"
        self.Theme = Themes[self.ThemeMode]
        main.BackgroundColor3 = self.Theme.Background
        mStroke.Color = self.Theme.Stroke
        mainTitle.TextColor3 = self.Theme.Text
        mainSub.TextColor3 = self.Theme.SubText
        searchBG.BackgroundColor3 = self.Theme.Sidebar
        searchBox.TextColor3 = self.Theme.Text
    end)
    
    -- TOGGLE VISIBILITY GUI VIA KEYBOARD (LeftControl fallback)
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
            uiVisible = not uiVisible
            main.Visible = uiVisible
            if not uiVisible and island.Visible then island.Visible = false end
        end
    end)
    
    -- MINIMIZE & MAXIMIZE LOGIC VIA DYNAMIC ISLAND
    local function ToggleMinimize()
        if main.Visible then
            TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 220, 0, 36),
                Position = UDim2.new(0.5, -110, 0, 15),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            main.Visible = false
            island.Visible = true
        else
            island.Visible = false
            main.Visible = true
            TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, self.Width, 0, self.Height),
                Position = UDim2.new(0.5, -self.Width/2, 0.5, -self.Height/2),
                BackgroundTransparency = 0.08
            }):Play()
        end
    end
    minBtn.MouseButton1Click:Connect(ToggleMinimize)
    island.MouseButton1Click:Connect(ToggleMinimize)
    
    -- SIDEBAR AND CONTAINER
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 160, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = self.Theme.Sidebar
    sidebar.BackgroundTransparency = 0.2
    
    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0, 4)
    
    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -170, 1, -60)
    contentArea.Position = UDim2.new(0, 165, 0, 55)
    contentArea.BackgroundTransparency = 1
    self.ContentArea = contentArea
    
    self:LoadConfig()
end

-- ================= TAB AND NAV MANAGEMENT =================
function NomNom:CreateTab(name, icon)
    icon = icon or "📁"
    local tabObj = {}
    tabObj.Sections = {}
    
    local tabBtn = Instance.new("TextButton", self.MainFrame:FindFirstChildOfClass("Frame"))
    tabBtn.Size = UDim2.new(1, -10, 0, 38)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = "  " .. icon .. "  " .. name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextColor3 = self.Theme.SubText
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local page = Instance.new("ScrollingFrame", self.ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = self.NeonColor
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 12)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = self.Theme.SubText
            t.Btn.BackgroundTransparency = 1
        end
        page.Visible = true
        tabBtn.TextColor3 = self.NeonColor
        tabBtn.BackgroundTransparency = 0.9
    end)
    
    tabObj.Btn = tabBtn
    tabObj.Page = page
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        page.Visible = true
        tabBtn.TextColor3 = self.NeonColor
        tabBtn.BackgroundTransparency = 0.9
    end
    
    -- ================= SECTION GENERATOR =================
    function tabObj:CreateSection(secName)
        local secObj = {}
        
        local secFrame = Instance.new("Frame", page)
        secFrame.Size = UDim2.new(1, -5, 0, 40)
        secFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        secFrame.BackgroundTransparency = 1
        
        local secLayout = Instance.new("UIListLayout", secFrame)
        secLayout.Padding = UDim.new(0, 8)
        
        local secTitle = Instance.new("TextLabel", secFrame)
        secTitle.Size = UDim2.new(1, 0, 0, 20)
        secTitle.Text = secName:upper()
        secTitle.Font = Enum.Font.GothamBlack
        secTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
        secTitle.TextSize = 11
        secTitle.TextXAlignment = Enum.TextXAlignment.Left
        secTitle.BackgroundTransparency = 1
        
        secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            secFrame.Size = UDim2.new(1, -5, 0, secLayout.AbsoluteContentSize.Y + 5)
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- ================= COMPONENTS IMPLEMENTATION =================
        
        -- 1. BUTTON COMPONENT
        function secObj:CreateButton(name, callback)
            local btn = Instance.new("TextButton", secFrame)
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.Text = name
            btn.Font = Enum.Font.GothamMedium
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            btn.TextSize = 13
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(callback)
            table.insert(self.AllElements, {Name = name, Frame = btn})
            
            local activeComp = {}
            function activeComp:SetText(txt) btn.Text = txt end
            return activeComp
        end
        
        -- 2. TOGGLE COMPONENT
        function secObj:CreateToggle(name, flag, default, callback)
            local state = default or false
            local toggleFrame = Instance.new("Frame", secFrame)
            toggleFrame.Size = UDim2.new(1, 0, 0, 38)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", toggleFrame)
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = name
            label.Font = Enum.Font.GothamMedium
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local switch = Instance.new("TextButton", toggleFrame)
            switch.Size = UDim2.new(0, 34, 0, 18)
            switch.Position = UDim2.new(1, -46, 0.5, -9)
            switch.BackgroundColor3 = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(50, 50, 60)
            switch.Text = ""
            Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
            
            local circle = Instance.new("Frame", switch)
            circle.Size = UDim2.new(0, 12, 0, 12)
            circle.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
            
            local function update(newState)
                state = newState
                local targetColor = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(50, 50, 60)
                local targetPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                callback(state)
            end
            
            switch.MouseButton1Click:Connect(function()
                update(not state)
            end)
            
            table.insert(self.AllElements, {Name = name, Frame = toggleFrame})
            return activeComp
        end
        
        -- 3. SLIDER COMPONENT
        function secObj:CreateSlider(name, min, max, step, default, callback)
            local val = default or min
            local sliderFrame = Instance.new("Frame", secFrame)
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", sliderFrame)
            label.Size = UDim2.new(1, -10, 0, 22)
            label.Position = UDim2.new(0, 12, 0, 4)
            label.Text = name
            label.Font = Enum.Font.GothamMedium
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local vLabel = Instance.new("TextLabel", sliderFrame)
            vLabel.Size = UDim2.new(0, 50, 0, 22)
            vLabel.Position = UDim2.new(1, -62, 0, 4)
            vLabel.Text = tostring(val)
            vLabel.Font = Enum.Font.GothamBold
            vLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
            vLabel.TextSize = 13
            vLabel.TextXAlignment = Enum.TextXAlignment.Right
            vLabel.BackgroundTransparency = 1
            
            local bar = Instance.new("TextButton", sliderFrame)
            bar.Size = UDim2.new(1, -24, 0, 6)
            bar.Position = UDim2.new(0, 12, 0, 34)
            bar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            bar.Text = ""
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            
            local active = false
            local function updateSlider(input)
                local scale = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local rawVal = min + ((max - min) * scale)
                val = math.floor(rawVal / step) * step
                vLabel.Text = tostring(val)
                fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                callback(val)
            end
            
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    active = true; updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then active = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
            end)
            
            table.insert(self.AllElements, {Name = name, Frame = sliderFrame})
        end
        
        -- 4. TEXTBOX / INPUT COMPONENT WITH VALIDATION
        function secObj:CreateTextBox(name, placeholder, numericOnly, callback)
            local boxFrame = Instance.new("Frame", secFrame)
            boxFrame.Size = UDim2.new(1, 0, 0, 42)
            boxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", boxFrame)
            label.Size = UDim2.new(0, 120, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = name
            label.Font = Enum.Font.GothamMedium
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local box = Instance.new("TextBox", boxFrame)
            box.Size = UDim2.new(1, -150, 0, 28)
            box.Position = UDim2.new(1, -142, 0.5, -14)
            box.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            box.PlaceholderText = placeholder
            box.Text = ""
            box.Font = Enum.Font.GothamMedium
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.TextSize = 12
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
            
            box.FocusLost:Connect(function()
                if numericOnly and not tonumber(box.Text) then
                    box.Text = ""
                    return
                end
                callback(box.Text)
            end)
            
            table.insert(self.AllElements, {Name = name, Frame = boxFrame})
        end
        
        -- 5. DROPDOWN COMPONENT (SINGLE & MULTI SELECT)
        function secObj:CreateDropdown(name, list, multiSelect, callback)
            local dropFrame = Instance.new("Frame", secFrame)
            dropFrame.Size = UDim2.new(1, 0, 0, 38)
            dropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            dropFrame.ClipsDescendants = true
            Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
            
            local trigger = Instance.new("TextButton", dropFrame)
            trigger.Size = UDim2.new(1, 0, 0, 38)
            trigger.BackgroundTransparency = 1
            trigger.Text = "   " .. name .. "  ▼"
            trigger.Font = Enum.Font.GothamMedium
            trigger.TextColor3 = Color3.fromRGB(230, 230, 230)
            trigger.TextSize = 13
            trigger.TextXAlignment = Enum.TextXAlignment.Left
            
            local itemsArea = Instance.new("Frame", dropFrame)
            itemsArea.Size = UDim2.new(1, -10, 0, 0)
            itemsArea.Position = UDim2.new(0, 5, 0, 38)
            itemsArea.BackgroundTransparency = 1
            local itemLayout = Instance.new("UIListLayout", itemsArea)
            itemLayout.Padding = UDim.new(0, 4)
            
            local open = false
            local selectedItems = {}
            
            local function refreshList(newList)
                for _, oldItem in pairs(itemsArea:GetChildren()) do
                    if oldItem:IsA("TextButton") then oldItem:Destroy() end
                end
                for _, item in pairs(newList) do
                    local iBtn = Instance.new("TextButton", itemsArea)
                    iBtn.Size = UDim2.new(1, 0, 0, 28)
                    iBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                    iBtn.Text = tostring(item)
                    iBtn.Font = Enum.Font.GothamMedium
                    iBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    iBtn.TextSize = 12
                    Instance.new("UICorner", iBtn).CornerRadius = UDim.new(0, 4)
                    
                    iBtn.MouseButton1Click:Connect(function()
                        if multiSelect then
                            if table.find(selectedItems, item) then
                                table.remove(selectedItems, table.find(selectedItems, item))
                                iBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                            else
                                table.insert(selectedItems, item)
                                iBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
                            end
                            callback(selectedItems)
                        else
                            trigger.Text = "   " .. name .. " [" .. tostring(item) .. "]  ▼"
                            dropFrame.Size = UDim2.new(1, 0, 0, 38)
                            open = false
                            callback(item)
                        end
                    end)
                end
            end
            
            trigger.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    dropFrame.Size = UDim2.new(1, 0, 0, 42 + itemLayout.AbsoluteContentSize.Y)
                else
                    dropFrame.Size = UDim2.new(1, 0, 0, 38)
                end
            end)
            
            refreshList(list)
            table.insert(self.AllElements, {Name = name, Frame = dropFrame})
            
            return {
                Refresh = function(_, targetList) refreshList(targetList) end
            }
        end
        
        -- 6. KEYBIND COMPONENT
        function secObj:CreateKeybind(name, defaultBind, callback)
            local currentBind = defaultBind.Name
            local bindFrame = Instance.new("Frame", secFrame)
            bindFrame.Size = UDim2.new(1, 0, 0, 38)
            bindFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Instance.new("UICorner", bindFrame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", bindFrame)
            label.Size = UDim2.new(1, -100, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.Text = name
            label.Font = Enum.Font.GothamMedium
            label.TextColor3 = Color3.fromRGB(230, 230, 230)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.BackgroundTransparency = 1
            
            local bindBtn = Instance.new("TextButton", bindFrame)
            bindBtn.Size = UDim2.new(0, 80, 0, 26)
            bindBtn.Position = UDim2.new(1, -92, 0.5, -13)
            bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            bindBtn.Text = currentBind
            bindBtn.Font = Enum.Font.GothamBold
            bindBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
            bindBtn.TextSize = 12
            Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)
            
            local listening = false
            bindBtn.MouseButton1Click:Connect(function()
                listening = true
                bindBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and not processed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentBind = input.KeyCode.Name
                        bindBtn.Text = currentBind
                        callback(input.KeyCode)
                    end
                end
            end)
            
            table.insert(self.AllElements, {Name = name, Frame = bindFrame})
        end
        
        return secObj
    end
    
    return tabObj
end

return NomNom
