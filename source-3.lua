local NomNom = {}
NomNom.__index = NomNom

local TabUI = {}
TabUI.__index = TabUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Kumpulan Asset ID (Rayfield & Custom)
local Assets = {
    Logo = "rbxassetid://116003568092644",
    TabDefault = "rbxassetid://4483362458",
    Notification = "rbxassetid://77891951053543",
    Search = "rbxassetid://18458939117",
    Hide = "rbxassetid://10137832201",
    Resize = "rbxassetid://10137941941",
    Settings = "rbxassetid://80503127983237",
    NomnomIcon = "rbxassetid://116003568092644",
    ShadowMain = "rbxassetid://5587865193",
    ShadowNotif = "rbxassetid://3523728077",
    ColorPickerBg = "rbxassetid://11413591840",
    Pointer = "rbxassetid://3259050989"
}

-- Global Dragging Logic
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition

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

function NomNom:CreateWindow(config)
    local self = setmetatable({}, NomNom)
    
    self.Title = config.Name or "NomNom Premium"
    self.LogoId = (config.Icon and "rbxassetid://"..tostring(config.Icon)) or Assets.Logo
    self.LoadingTitle = config.LoadingTitle or self.Title
    self.LoadingSubtitle = config.LoadingSubtitle or "by Isco 76"
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(255, 85, 0)
    self.ToggleKeybind = config.ToggleUIKeybind or Enum.KeyCode.RightControl
    self.ThemeObjects = {} 
    
    task.wait(0.2)
    
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V4_Titanium"
    sgui.ResetOnSpawn = false
    sgui.IgnoreGuiInset = true
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui

    local notifContainer = Instance.new("Frame", sgui)
    notifContainer.Name = "NotifContainer"
    notifContainer.Size = UDim2.new(0, 320, 1, 0)
    notifContainer.Position = UDim2.new(1, -340, 0, 0)
    notifContainer.BackgroundTransparency = 1
    
    local notifLayout = Instance.new("UIListLayout", notifContainer)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 10)
    self.NotifContainer = notifContainer
    
    -- ==========================================
    -- 1. CINEMATIC LOADING SCREEN DENGAN PROGRESS BAR
    -- ==========================================
    local introFrame = Instance.new("Frame", sgui)
    introFrame.Size = UDim2.new(1, 0, 1, 0)
    introFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10) 
    introFrame.ZIndex = 999
    
    local introLogo = Instance.new("ImageLabel", introFrame)
    introLogo.Size = UDim2.new(0, 100, 0, 100)
    introLogo.Position = UDim2.new(0.5, -50, 0.5, -120)
    introLogo.BackgroundTransparency = 1
    introLogo.Image = self.LogoId
    introLogo.ImageTransparency = 1
    introLogo.ZIndex = 1000

    local introText = Instance.new("TextLabel", introFrame)
    introText.Size = UDim2.new(1, 0, 0, 50)
    introText.Position = UDim2.new(0, 0, 0.5, -10)
    introText.Font = Enum.Font.GothamBlack
    introText.TextSize = 35
    introText.TextColor3 = self.CurrentThemeColor
    introText.BackgroundTransparency = 1
    introText.TextTransparency = 1
    introText.Text = "Welcome To " .. self.LoadingTitle
    introText.ZIndex = 1000

    local subText = Instance.new("TextLabel", introFrame)
    subText.Size = UDim2.new(1, 0, 0, 30)
    subText.Position = UDim2.new(0, 0, 0.5, 30)
    subText.Font = Enum.Font.GothamMedium
    subText.TextSize = 16
    subText.TextColor3 = Color3.fromRGB(200, 200, 200)
    subText.BackgroundTransparency = 1
    subText.TextTransparency = 1
    subText.Text = self.LoadingSubtitle
    subText.ZIndex = 1000

    local barBg = Instance.new("Frame", introFrame)
    barBg.Size = UDim2.new(0, 300, 0, 8)
    barBg.Position = UDim2.new(0.5, -150, 0.5, 80)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    barBg.BackgroundTransparency = 1
    barBg.ZIndex = 1000
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = self.CurrentThemeColor
    barFill.ZIndex = 1000
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    -- Loading Animation Sequence
    task.spawn(function()
        task.wait(0.5)
        TweenService:Create(introLogo, TweenInfo.new(1), {ImageTransparency = 0}):Play()
        TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0}):Play()
        TweenService:Create(subText, TweenInfo.new(1), {TextTransparency = 0}):Play()
        TweenService:Create(barBg, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
        task.wait(1)

        -- Progress bar animation
        TweenService:Create(barFill, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(2.2)
        
        TweenService:Create(introLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(subText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(barFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        
        TweenService:Create(introFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        task.wait(0.8)
        introFrame:Destroy()
    end)

    -- ==========================================
    -- 2. MAIN FRAME & DYNAMIC ISLAND
    -- ==========================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    self.MainFrame = mainFrame
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 1.5

    -- Drop Shadow
    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = Assets.ShadowMain
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    
    task.spawn(function()
        task.wait(4) -- Sesuaikan dengan durasi loading bar
        TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 650, 0, 450),
            Position = UDim2.new(0.5, -325, 0.5, -225)
        }):Play()
    end)
    
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1
    MakeDraggable(header, mainFrame)

    local headerLogo = Instance.new("ImageLabel", header)
    headerLogo.Size = UDim2.new(0, 25, 0, 25)
    headerLogo.Position = UDim2.new(0, 15, 0.5, -12.5)
    headerLogo.BackgroundTransparency = 1
    headerLogo.Image = self.LogoId
    
    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0, 300, 1, 0)
    titleLabel.Position = UDim2.new(0, 50, 0, 0)
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Size = UDim2.new(1, -40, 0, 35)
    tabBar.Position = UDim2.new(0, 20, 0, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
    end)

    local tabContentArea = Instance.new("Frame", mainFrame)
    tabContentArea.Size = UDim2.new(1, -40, 1, -105)
    tabContentArea.Position = UDim2.new(0, 20, 0, 95)
    tabContentArea.BackgroundTransparency = 1

    self.TabBar = tabBar
    self.TabContentArea = tabContentArea
    self.Tabs = {}
    self.CurrentTab = nil

    -- Keybind Listener for toggling UI
    if typeof(self.ToggleKeybind) == "string" then
        self.ToggleKeybind = Enum.KeyCode[self.ToggleKeybind] or Enum.KeyCode.RightControl
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleKeybind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    return self
end

local function parseIcon(icon)
    if type(icon) == "number" then return "rbxassetid://" .. icon end
    if type(icon) == "string" and not string.find(icon, "rbxassetid://") then return "rbxassetid://" .. icon end
    return icon
end

-- ================= FITUR NOTIFIKASI RAYFIELD STYLE =================
function NomNom:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or "Notification Content"
    local duration = config.Duration or 6.5
    local imageId = parseIcon(config.Image) or Assets.Notification

    local notifFrame = Instance.new("Frame", self.NotifContainer)
    notifFrame.Size = UDim2.new(1, 0, 0, 80)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notifFrame.BackgroundTransparency = 1
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = self.CurrentThemeColor
    stroke.Thickness = 1.5
    stroke.Transparency = 1
    table.insert(self.ThemeObjects, {Obj = stroke, Prop = "Color"})
    
    local icon = Instance.new("ImageLabel", notifFrame)
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = imageId
    icon.ImageTransparency = 1
    icon.ImageColor3 = self.CurrentThemeColor
    table.insert(self.ThemeObjects, {Obj = icon, Prop = "ImageColor3"})

    local titleLbl = Instance.new("TextLabel", notifFrame)
    titleLbl.Size = UDim2.new(1, -65, 0, 20)
    titleLbl.Position = UDim2.new(0, 55, 0, 15)
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextTransparency = 1

    local descLbl = Instance.new("TextLabel", notifFrame)
    descLbl.Size = UDim2.new(1, -65, 0, 30)
    descLbl.Position = UDim2.new(0, 55, 0, 35)
    descLbl.Text = content
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 12
    descLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.BackgroundTransparency = 1
    descLbl.TextTransparency = 1

    -- Animation In
    TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(icon, TweenInfo.new(0.4), {ImageTransparency = 0}):Play()
    TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    task.spawn(function()
        task.wait(duration)
        -- Animation Out
        TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(icon, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
        TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        notifFrame:Destroy()
    end)
end

function NomNom:ChangeTheme(newColor)
    self.CurrentThemeColor = newColor
    for _, item in pairs(self.ThemeObjects) do
        if item.Obj and item.Obj.Parent then
            item.Obj[item.Prop] = newColor
        end
    end
end

-- ================= TAB SYSTEM =================
function NomNom:CreateTab(name, iconId)
    iconId = parseIcon(iconId) or Assets.TabDefault
    
    local tabBtn = Instance.new("TextButton", self.TabBar)
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    stroke.Thickness = 1

    local img = Instance.new("ImageLabel", tabBtn)
    img.Size = UDim2.new(0, 16, 0, 16)
    img.Position = UDim2.new(0, 10, 0.5, -8)
    img.BackgroundTransparency = 1
    img.Image = iconId

    local tabTxt = Instance.new("TextLabel", tabBtn)
    tabTxt.Size = UDim2.new(1, -35, 1, 0)
    tabTxt.Position = UDim2.new(0, 30, 0, 0)
    tabTxt.BackgroundTransparency = 1
    tabTxt.Text = name
    tabTxt.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabTxt.Font = Enum.Font.GothamBold
    tabTxt.TextSize = 13
    tabTxt.TextXAlignment = Enum.TextXAlignment.Left

    local textBounds = game:GetService("TextService"):GetTextSize(name, 13, Enum.Font.GothamBold, Vector2.new(999, 35))
    tabBtn.Size = UDim2.new(0, textBounds.X + 45, 1, 0)

    local container = Instance.new("ScrollingFrame", self.TabContentArea)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = self.CurrentThemeColor
    container.BorderSizePixel = 0
    container.Visible = false
    table.insert(self.ThemeObjects, {Obj = container, Prop = "ScrollBarImageColor3"})
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    local function ActivateTab()
        if self.CurrentTab then
            TweenService:Create(self.CurrentTab.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
            TweenService:Create(self.CurrentTab.Txt, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            TweenService:Create(self.CurrentTab.Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play()
            self.CurrentTab.Container.Visible = false
        end
        
        self.CurrentTab = {Btn = tabBtn, Txt = tabTxt, Stroke = stroke, Container = container}
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        TweenService:Create(tabTxt, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.CurrentThemeColor}):Play()
        container.Visible = true
    end

    tabBtn.MouseButton1Click:Connect(ActivateTab)
    
    if #self.TabBar:GetChildren() == 2 then ActivateTab() end
    return setmetatable({Container = container, Library = self}, TabUI)
end

-- ================= KOMPONEN UI DI DALAM TAB =================

function TabUI:CreateSection(name)
    local sectionLbl = Instance.new("TextLabel", self.Container)
    sectionLbl.Size = UDim2.new(1, 0, 0, 25)
    sectionLbl.Text = name
    sectionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLbl.Font = Enum.Font.GothamBlack
    sectionLbl.TextSize = 14
    sectionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sectionLbl.BackgroundTransparency = 1
end

function TabUI:CreateDivider()
    local div = Instance.new("Frame", self.Container)
    div.Size = UDim2.new(1, 0, 0, 1)
    div.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    div.BorderSizePixel = 0
end

function TabUI:CreateParagraph(config)
    local title = config.Title or "Paragraph"
    local content = config.Content or "Content here"

    local paraFrame = Instance.new("Frame", self.Container)
    paraFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", paraFrame).Color = Color3.fromRGB(35, 35, 40)

    local titleLbl = Instance.new("TextLabel", paraFrame)
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.Text = title
    titleLbl.TextColor3 = self.Library.CurrentThemeColor
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    table.insert(self.Library.ThemeObjects, {Obj = titleLbl, Prop = "TextColor3"})

    local descLbl = Instance.new("TextLabel", paraFrame)
    descLbl.Size = UDim2.new(1, -20, 0, 0)
    descLbl.Position = UDim2.new(0, 10, 0, 30)
    descLbl.Text = content
    descLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 13
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.BackgroundTransparency = 1

    local bounds = game:GetService("TextService"):GetTextSize(content, 13, Enum.Font.GothamMedium, Vector2.new(self.Container.AbsoluteSize.X - 20, 9999))
    descLbl.Size = UDim2.new(1, -20, 0, bounds.Y)
    paraFrame.Size = UDim2.new(1, 0, 0, bounds.Y + 40)
end

function TabUI:CreateButton(config)
    local name = config.Name or "Button"
    local callback = config.Callback or function() end
    
    local btn = Instance.new("TextButton", self.Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 40, 45)

    local img = Instance.new("ImageLabel", btn)
    img.Size = UDim2.new(0, 18, 0, 18)
    img.Position = UDim2.new(1, -30, 0.5, -9)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://15088523363" -- Mouse Pointer Icon

    local titleLbl = Instance.new("TextLabel", btn)
    titleLbl.Size = UDim2.new(1, -40, 1, 0)
    titleLbl.Position = UDim2.new(0, 15, 0, 0)
    titleLbl.Text = name
    titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = self.Library.CurrentThemeColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36), Position = UDim2.new(0, 2, 0, 2)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 0)}):Play()
        callback()
    end)
end

function TabUI:CreateToggle(config)
    local name = config.Name or "Toggle"
    local state = config.CurrentValue or false
    local callback = config.Callback or function() end
    
    local tf = Instance.new("Frame", self.Container)
    tf.Size = UDim2.new(1, 0, 0, 40)
    tf.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", tf).Color = Color3.fromRGB(40, 40, 45)

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
    switchBG.Size = UDim2.new(0, 40, 0, 20)
    switchBG.Position = UDim2.new(1, -55, 0.5, -10)
    switchBG.BackgroundColor3 = state and self.Library.CurrentThemeColor or Color3.fromRGB(40, 40, 45)
    switchBG.Text = ""
    switchBG.AutoButtonColor = false
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)
    table.insert(self.Library.ThemeObjects, {Obj = switchBG, Prop = "BackgroundColor3"})
    
    local circle = Instance.new("Frame", switchBG)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switchBG.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and self.Library.CurrentThemeColor or Color3.fromRGB(40, 40, 45)
        local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        callback(state)
    end)
end

function TabUI:CreateSlider(config)
    local name = config.Name or "Slider"
    local min = config.Range and config.Range[1] or 0
    local max = config.Range and config.Range[2] or 100
    local sliderVal = config.CurrentValue or min
    local suffix = config.Suffix or ""
    local callback = config.Callback or function() end
    
    local sf = Instance.new("Frame", self.Container)
    sf.Size = UDim2.new(1, 0, 0, 55)
    sf.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", sf).Color = Color3.fromRGB(40, 40, 45)

    local label = Instance.new("TextLabel", sf)
    label.Size = UDim2.new(1, -70, 0, 25)
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
    valLabel.Text = tostring(sliderVal) .. suffix
    valLabel.TextColor3 = self.Library.CurrentThemeColor
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 14
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.BackgroundTransparency = 1
    table.insert(self.Library.ThemeObjects, {Obj = valLabel, Prop = "TextColor3"})
    
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
    sliderFill.BackgroundColor3 = self.Library.CurrentThemeColor
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    table.insert(self.Library.ThemeObjects, {Obj = sliderFill, Prop = "BackgroundColor3"})
    
    local sliderKnob = Instance.new("Frame", sliderFill)
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        valLabel.Text = tostring(value) .. suffix
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        callback(value)
    end
    
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

function TabUI:CreateInput(config)
    local name = config.Name or "Input"
    local placeholder = config.PlaceholderText or "Type here..."
    local callback = config.Callback or function() end
    
    local boxFrame = Instance.new("Frame", self.Container)
    boxFrame.Size = UDim2.new(1, 0, 0, 45)
    boxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", boxFrame).Color = Color3.fromRGB(40, 40, 45)

    local label = Instance.new("TextLabel", boxFrame)
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local textBoxBg = Instance.new("Frame", boxFrame)
    textBoxBg.Size = UDim2.new(1, -180, 0, 25)
    textBoxBg.Position = UDim2.new(0, 165, 0.5, -12.5)
    textBoxBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", textBoxBg).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", textBoxBg).Color = Color3.fromRGB(50, 50, 55)

    local textBox = Instance.new("TextBox", textBoxBg)
    textBox.Size = UDim2.new(1, -10, 1, 0)
    textBox.Position = UDim2.new(0, 5, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = config.CurrentValue or ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = self.Library.CurrentThemeColor
    textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 13
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(self.Library.ThemeObjects, {Obj = textBox, Prop = "TextColor3"})
    
    textBox.FocusLost:Connect(function()
        callback(textBox.Text)
    end)
end

function TabUI:CreateDropdown(config)
    local name = config.Name or "Dropdown"
    local options = config.Options or {}
    local current = config.CurrentOption or (options[1] or "")
    local callback = config.Callback or function() end

    local ddFrame = Instance.new("Frame", self.Container)
    ddFrame.Size = UDim2.new(1, 0, 0, 45)
    ddFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ddFrame.ClipsDescendants = true
    Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", ddFrame).Color = Color3.fromRGB(40, 40, 45)

    local btn = Instance.new("TextButton", ddFrame)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -150, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local selectedBg = Instance.new("Frame", btn)
    selectedBg.Size = UDim2.new(0, 120, 0, 25)
    selectedBg.Position = UDim2.new(1, -135, 0.5, -12.5)
    selectedBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", selectedBg).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", selectedBg).Color = Color3.fromRGB(50, 50, 55)

    local selectedTxt = Instance.new("TextLabel", selectedBg)
    selectedTxt.Size = UDim2.new(1, -25, 1, 0)
    selectedTxt.Position = UDim2.new(0, 5, 0, 0)
    selectedTxt.Text = typeof(current) == "table" and table.concat(current, ", ") or tostring(current)
    selectedTxt.TextColor3 = self.Library.CurrentThemeColor
    selectedTxt.Font = Enum.Font.GothamMedium
    selectedTxt.TextSize = 12
    selectedTxt.TextXAlignment = Enum.TextXAlignment.Left
    selectedTxt.BackgroundTransparency = 1
    selectedTxt.TextTruncate = Enum.TextTruncate.AtEnd
    table.insert(self.Library.ThemeObjects, {Obj = selectedTxt, Prop = "TextColor3"})

    local icon = Instance.new("ImageLabel", selectedBg)
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(1, -20, 0.5, -8)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://15088523363"
    icon.Rotation = 90

    local listContainer = Instance.new("ScrollingFrame", ddFrame)
    listContainer.Size = UDim2.new(1, -30, 0, 100)
    listContainer.Position = UDim2.new(0, 15, 0, 50)
    listContainer.BackgroundTransparency = 1
    listContainer.ScrollBarThickness = 2
    listContainer.ScrollBarImageColor3 = self.Library.CurrentThemeColor
    table.insert(self.Library.ThemeObjects, {Obj = listContainer, Prop = "ScrollBarImageColor3"})
    
    local listLayout = Instance.new("UIListLayout", listContainer)
    listLayout.Padding = UDim.new(0, 5)

    local isOpen = false
    btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetSize = isOpen and UDim2.new(1, 0, 0, 160) or UDim2.new(1, 0, 0, 45)
        local targetRot = isOpen and -90 or 90
        TweenService:Create(ddFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        TweenService:Create(icon, TweenInfo.new(0.3), {Rotation = targetRot}):Play()
    end)

    local function PopulateOptions()
        for _, child in pairs(listContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", listContainer)
            optBtn.Size = UDim2.new(1, 0, 0, 25)
            optBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.TextSize = 13
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

            optBtn.MouseButton1Click:Connect(function()
                selectedTxt.Text = opt
                isOpen = false
                TweenService:Create(ddFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                TweenService:Create(icon, TweenInfo.new(0.3), {Rotation = 90}):Play()
                callback(opt)
            end)
        end
        listContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end
    PopulateOptions()
end

function TabUI:CreateKeybind(config)
    local name = config.Name or "Keybind"
    local currentKey = config.CurrentKeybind or Enum.KeyCode.E
    local callback = config.Callback or function() end

    local kbFrame = Instance.new("Frame", self.Container)
    kbFrame.Size = UDim2.new(1, 0, 0, 40)
    kbFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", kbFrame).Color = Color3.fromRGB(40, 40, 45)

    local label = Instance.new("TextLabel", kbFrame)
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", kbFrame)
    btn.Size = UDim2.new(0, 70, 0, 25)
    btn.Position = UDim2.new(1, -85, 0.5, -12.5)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = currentKey.Name
    btn.TextColor3 = self.Library.CurrentThemeColor
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    table.insert(self.Library.ThemeObjects, {Obj = btn, Prop = "TextColor3"})

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = true
        btn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            currentKey = input.KeyCode
            btn.Text = currentKey.Name
            callback(currentKey)
        elseif not gameProcessed and input.KeyCode == currentKey then
            callback(currentKey)
        end
    end)
end

function TabUI:CreateColorPicker(config)
    local name = config.Name or "Color Picker"
    local color = config.Color or Color3.fromRGB(255, 255, 255)
    local callback = config.Callback or function() end

    -- Simplified ColorPicker layout for stability (can be expanded later)
    local cpFrame = Instance.new("Frame", self.Container)
    cpFrame.Size = UDim2.new(1, 0, 0, 40)
    cpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", cpFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", cpFrame).Color = Color3.fromRGB(40, 40, 45)

    local label = Instance.new("TextLabel", cpFrame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local display = Instance.new("TextButton", cpFrame)
    display.Size = UDim2.new(0, 30, 0, 20)
    display.Position = UDim2.new(1, -45, 0.5, -10)
    display.BackgroundColor3 = color
    display.Text = ""
    Instance.new("UICorner", display).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", display).Color = Color3.fromRGB(50, 50, 55)

    -- In a full version, clicking display would open an RGB slider menu. 
    -- For now, it passes the selected initial color to callback to maintain integrity.
    display.MouseButton1Click:Connect(function()
        callback(color)
    end)
end

return NomNom
