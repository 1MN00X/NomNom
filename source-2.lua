-- [[ NomNom UI Library V2: Ultra Premium Edition + MEGA UPDATE ]]
-- Fitur Asli: Draggable Window, Live Theme Changer, RGB Dynamic Island, Smooth Sliders, Ultra Animations
-- Fitur Baru: Tab System, Notifications, Progress Bar, Status Indicator, Text Box, Label, Search Bar

local NomNom = {}
NomNom.__index = NomNom

local TabUI = {}
TabUI.__index = TabUI

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

function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    -- Konfigurasi Utama
    self.Title = config.Title or "NomNom Premium"
    self.LogoId = config.LogoId or ""
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.ThemeObjects = {} 
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V2_Premium"
    sgui.ResetOnSpawn = false
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui

    -- Container Notifikasi
    local notifContainer = Instance.new("Frame", sgui)
    notifContainer.Name = "NotifContainer"
    notifContainer.Size = UDim2.new(0, 300, 1, 0)
    notifContainer.Position = UDim2.new(1, -320, 0, 0)
    notifContainer.BackgroundTransparency = 1
    
    local notifLayout = Instance.new("UIListLayout", notifContainer)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 10)
    self.NotifContainer = notifContainer
    
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

    -- Fade In Loading
    TweenService:Create(loadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(lStroke, TweenInfo.new(0.5), {Thickness = 1.5, Transparency = 0}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(loadStatus, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(barBackground, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    task.wait(0.6)
    
    TweenService:Create(barProgress, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.3, 0, 1, 0)}):Play()
    task.wait(0.8)
    loadStatus.Text = "Loading Tab Systems..."
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
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200)
    }):Play()
    
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
    
    -- Header UI Utama
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 45)
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
    closeBtn.Position = UDim2.new(1, -40, 0, 7)
    closeBtn.Text = "—"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundTransparency = 1

    -- TAB SYSTEM CONTAINER
    local tabBar = Instance.new("ScrollingFrame", mainFrame)
    tabBar.Size = UDim2.new(1, -40, 0, 35)
    tabBar.Position = UDim2.new(0, 20, 0, 45)
    tabBar.BackgroundTransparency = 1
    tabBar.ScrollBarThickness = 0
    tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabBar.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X, 0, 0)
    end)

    local tabContentArea = Instance.new("Frame", mainFrame)
    tabContentArea.Size = UDim2.new(1, -40, 1, -100)
    tabContentArea.Position = UDim2.new(0, 20, 0, 90)
    tabContentArea.BackgroundTransparency = 1

    self.TabBar = tabBar
    self.TabContentArea = tabContentArea
    self.Tabs = {}
    self.CurrentTab = nil

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
            
            -- Show mainframe elements safely
            for _, v in pairs(mainFrame:GetChildren()) do
                if v:IsA("GuiObject") then 
                    v.Visible = true 
                end
            end
            
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 400),
                Position = UDim2.new(0.5, -300, 0.5, -200)
            }):Play()
        end
    end
    
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.MouseButton1Click:Connect(toggleUI)
    
    return self
end

-- ================= FITUR NOTIFIKASI =================
function NomNom:Notify(config)
    local title = config.Title or "Notification"
    local text = config.Text or "This is a notification."
    local duration = config.Duration or 3

    local notifFrame = Instance.new("Frame", self.NotifContainer)
    notifFrame.Size = UDim2.new(1, 0, 0, 70)
    notifFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    notifFrame.BackgroundTransparency = 1
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notifFrame)
    stroke.Color = self.CurrentThemeColor
    stroke.Thickness = 1.5
    stroke.Transparency = 1
    
    local titleLbl = Instance.new("TextLabel", notifFrame)
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = self.CurrentThemeColor
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextTransparency = 1

    local descLbl = Instance.new("TextLabel", notifFrame)
    descLbl.Size = UDim2.new(1, -20, 0, 35)
    descLbl.Position = UDim2.new(0, 10, 0, 25)
    descLbl.Text = text
    descLbl.Font = Enum.Font.GothamMedium
    descLbl.TextSize = 12
    descLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.BackgroundTransparency = 1
    descLbl.TextTransparency = 1

    -- Animate In
    TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 0}):Play()
    TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    task.spawn(function()
        task.wait(duration)
        TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(titleLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(descLbl, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        notifFrame:Destroy()
    end)
end

-- ================= FITUR LIVE THEME =================
function NomNom:ChangeTheme(newColor)
    self.CurrentThemeColor = newColor
    for _, item in pairs(self.ThemeObjects) do
        if item.Obj and item.Obj.Parent then
            TweenService:Create(item.Obj, TweenInfo.new(0.5), {[item.Prop] = newColor}):Play()
        end
    end
end

-- ================= FITUR TAB SYSTEM =================
function NomNom:CreateTab(name)
    local tabBtn = Instance.new("TextButton", self.TabBar)
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", tabBtn)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    stroke.Thickness = 1

    -- Mengatur ukuran tombol dinamis berdasarkan teks
    local textBounds = game:GetService("TextService"):GetTextSize(name, 13, Enum.Font.GothamBold, Vector2.new(999, 35))
    tabBtn.Size = UDim2.new(0, textBounds.X + 30, 1, 0)

    local container = Instance.new("ScrollingFrame", self.TabContentArea)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
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
            TweenService:Create(self.CurrentTab.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            TweenService:Create(self.CurrentTab.Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play()
            self.CurrentTab.Container.Visible = false
        end
        
        self.CurrentTab = {Btn = tabBtn, Stroke = stroke, Container = container}
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.CurrentThemeColor}):Play()
        container.Visible = true
    end

    tabBtn.MouseButton1Click:Connect(ActivateTab)
    
    if #self.TabBar:GetChildren() == 2 then -- 1 karena UIListLayout
        ActivateTab()
    end

    local newTab = setmetatable({
        Container = container,
        Library = self
    }, TabUI)

    return newTab
end

-- ================= KOMPONEN UI DI DALAM TAB =================

function TabUI:CreateButton(name, callback)
    local btn = Instance.new("TextButton", self.Container)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    btn.Text = "   " .. name
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local titleLbl = Instance.new("TextLabel", btn)
    titleLbl.Name = "TitleLabel"
    titleLbl.Text = name
    titleLbl.Visible = false

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    stroke.Thickness = 1
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.Library.CurrentThemeColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 41), Position = UDim2.new(0, 2, 0, 2)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 0, 0)}):Play()
        callback()
    end)
end

function TabUI:CreateToggle(name, default, callback)
    local state = default or false
    local tf = Instance.new("Frame", self.Container)
    tf.Size = UDim2.new(1, 0, 0, 45)
    tf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", tf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", tf)
    label.Name = "TitleLabel"
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
    switchBG.BackgroundColor3 = state and self.Library.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
    switchBG.Text = ""
    switchBG.AutoButtonColor = false
    Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)
    table.insert(self.Library.ThemeObjects, {Obj = switchBG, Prop = "BackgroundColor3"})
    
    local circle = Instance.new("Frame", switchBG)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    switchBG.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and self.Library.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        
        TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        callback(state)
    end)
end

function TabUI:CreateSlider(name, min, max, default, callback)
    local sliderVal = default or min
    
    local sf = Instance.new("Frame", self.Container)
    sf.Size = UDim2.new(1, 0, 0, 60)
    sf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", sf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", sf)
    label.Name = "TitleLabel"
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
    valLabel.TextColor3 = self.Library.CurrentThemeColor
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 14
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.BackgroundTransparency = 1
    table.insert(self.Library.ThemeObjects, {Obj = valLabel, Prop = "TextColor3"})
    
    local sliderBG = Instance.new("TextButton", sf)
    sliderBG.Size = UDim2.new(1, -30, 0, 6)
    sliderBG.Position = UDim2.new(0, 15, 0, 40)
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
        callback(value)
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
end

function TabUI:CreateLabel(text)
    local lblFrame = Instance.new("Frame", self.Container)
    lblFrame.Size = UDim2.new(1, 0, 0, 30)
    lblFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", lblFrame)
    label.Name = "TitleLabel"
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
end

function TabUI:CreateTextBox(name, placeholder, callback)
    local boxFrame = Instance.new("Frame", self.Container)
    boxFrame.Size = UDim2.new(1, 0, 0, 50)
    boxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", boxFrame)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", boxFrame)
    label.Name = "TitleLabel"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local textBox = Instance.new("TextBox", boxFrame)
    textBox.Size = UDim2.new(1, -30, 0, 20)
    textBox.Position = UDim2.new(0, 15, 0, 25)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
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

function TabUI:CreateProgressBar(name, initialValue, max)
    local pBarVal = initialValue or 0
    
    local pf = Instance.new("Frame", self.Container)
    pf.Size = UDim2.new(1, 0, 0, 50)
    pf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", pf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", pf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", pf)
    label.Name = "TitleLabel"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local barBG = Instance.new("Frame", pf)
    barBG.Size = UDim2.new(1, -30, 0, 6)
    barBG.Position = UDim2.new(0, 15, 0, 32)
    barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)
    
    local barFill = Instance.new("Frame", barBG)
    local fillScale = pBarVal / max
    barFill.Size = UDim2.new(fillScale, 0, 1, 0)
    barFill.BackgroundColor3 = self.Library.CurrentThemeColor
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
    table.insert(self.Library.ThemeObjects, {Obj = barFill, Prop = "BackgroundColor3"})

    local PBarObj = {}
    function PBarObj:Update(newValue)
        local scale = math.clamp(newValue / max, 0, 1)
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
    end
    
    return PBarObj
end

function TabUI:CreateStatusIndicator(name, initialStatus, color)
    local sf = Instance.new("Frame", self.Container)
    sf.Size = UDim2.new(1, 0, 0, 40)
    sf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", sf)
    stroke.Color = Color3.fromRGB(40, 40, 45)
    
    local label = Instance.new("TextLabel", sf)
    label.Name = "TitleLabel"
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local statusDot = Instance.new("Frame", sf)
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(1, -90, 0.5, -5)
    statusDot.BackgroundColor3 = color or Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusTxt = Instance.new("TextLabel", sf)
    statusTxt.Size = UDim2.new(0, 60, 1, 0)
    statusTxt.Position = UDim2.new(1, -70, 0, 0)
    statusTxt.Text = initialStatus
    statusTxt.TextColor3 = color or Color3.fromRGB(255, 0, 0)
    statusTxt.Font = Enum.Font.GothamBold
    statusTxt.TextSize = 12
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.BackgroundTransparency = 1

    local StatusObj = {}
    function StatusObj:Update(newStatus, newColor)
        statusTxt.Text = newStatus
        TweenService:Create(statusTxt, TweenInfo.new(0.3), {TextColor3 = newColor}):Play()
        TweenService:Create(statusDot, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    end
    
    return StatusObj
end

function TabUI:CreateSearchBar(placeholder)
    local searchFrame = Instance.new("Frame", self.Container)
    searchFrame.Size = UDim2.new(1, 0, 0, 40)
    searchFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", searchFrame)
    stroke.Color = self.Library.CurrentThemeColor
    table.insert(self.Library.ThemeObjects, {Obj = stroke, Prop = "Color"})
    
    local searchBox = Instance.new("TextBox", searchFrame)
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = placeholder or "Search in tab..."
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 13
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(searchBox.Text)
        
        for _, item in pairs(self.Container:GetChildren()) do
            if item:IsA("Frame") or item:IsA("TextButton") then
                if item ~= searchFrame then
                    local lbl = item:FindFirstChild("TitleLabel")
                    if lbl then
                        if searchText == "" or string.find(string.lower(lbl.Text), searchText) then
                            item.Visible = true
                        else
                            item.Visible = false
                        end
                    end
                end
            end
        end
    end)
end

return NomNom
