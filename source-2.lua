-- [[ NomNom UI Library V2: Ultra Premium Edition ]]
-- Fix: Window visibility, Tooltip bug, Size adjustments

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

-- ================= TOOLTIP MANAGER =================
local TooltipManager = {}
TooltipManager.__index = TooltipManager

function TooltipManager.new(parentGui, themeColor)
    local self = setmetatable({}, TooltipManager)
    
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 0, 0, 0)
    tooltip.Position = UDim2.new(0, 0, 0, 0)
    tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    tooltip.BackgroundTransparency = 0.1
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = parentGui
    Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", tooltip)
    stroke.Color = themeColor
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    
    local label = Instance.new("TextLabel", tooltip)
    label.Size = UDim2.new(1, -20, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 11
    label.TextWrapped = true
    label.AutomaticSize = Enum.AutomaticSize.Y
    
    self.Frame = tooltip
    self.Label = label
    self.Stroke = stroke
    self.Active = false
    
    return self
end

function TooltipManager:Show(text, mousePos)
    if not text or text == "" then return end
    self.Label.Text = text
    self.Frame.Visible = true
    self.Active = true
    
    task.wait(0.02)
    local textSize = self.Label.TextBounds
    local width = math.max(textSize.X + 20, 100)
    local height = textSize.Y + 10
    
    self.Frame.Size = UDim2.new(0, width, 0, height)
    
    local posX = mousePos.X + 15
    local posY = mousePos.Y + 20
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    if posX + width > viewportSize.X then
        posX = mousePos.X - width - 15
    end
    if posY + height > viewportSize.Y then
        posY = mousePos.Y - height - 15
    end
    
    self.Frame.Position = UDim2.new(0, posX, 0, posY)
    self.Frame.BackgroundTransparency = 0.1
end

function TooltipManager:Hide()
    if not self.Active then return end
    self.Active = false
    self.Frame.Visible = false
end

-- ================= SECTION CLASS =================
local Section = {}
Section.__index = Section

function Section.new(parentContainer, name, windowRef)
    local self = setmetatable({}, Section)
    
    self.WindowRef = windowRef
    self.FlagObjects = {}
    
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

function Section:RegisterFlag(flagName, component, value)
    if flagName and self.WindowRef then
        self.WindowRef.Flags[flagName] = value
        self.WindowRef.FlagObjects[flagName] = component
        component.FlagName = flagName
    end
end

-- ================= TAB CLASS =================
local Tab = {}
Tab.__index = Tab

function Tab.new(parentContainer, name, themeColor, windowRef)
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
    self.WindowRef = windowRef
    
    return self
end

function Tab:CreateSection(name)
    local section = Section.new(self.Page, name, self.WindowRef)
    table.insert(self.Sections, section)
    return section
end

-- ================= NOTIFICATION HOLDER =================
local NotificationHolder = {}
NotificationHolder.__index = NotificationHolder

function NotificationHolder.new(parentGui)
    local self = setmetatable({}, NotificationHolder)
    
    local holder = Instance.new("Frame")
    holder.Name = "NotificationHolder"
    holder.Size = UDim2.new(0, 300, 0, 0)
    holder.Position = UDim2.new(1, -20, 1, -20)
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.BackgroundTransparency = 1
    holder.Parent = parentGui
    
    local uiList = Instance.new("UIListLayout", holder)
    uiList.Padding = UDim.new(0, 8)
    uiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    
    self.Holder = holder
    self.UIList = uiList
    self.Notifications = {}
    
    return self
end

function NotificationHolder:Notify(data)
    local title = data.Title or "Notification"
    local content = data.Content or ""
    local duration = data.Duration or 3
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    notif.BackgroundTransparency = 0.05
    notif.AutomaticSize = Enum.AutomaticSize.Y
    notif.ClipsDescendants = true
    notif.Parent = self.Holder
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 1.5
    
    local titleLabel = Instance.new("TextLabel", notif)
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    
    local contentLabel = Instance.new("TextLabel", notif)
    contentLabel.Size = UDim2.new(1, -30, 0, 0)
    contentLabel.Position = UDim2.new(0, 15, 0, 35)
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    contentLabel.Font = Enum.Font.GothamMedium
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.BackgroundTransparency = 1
    contentLabel.AutomaticSize = Enum.AutomaticSize.Y
    
    local closeBtn = Instance.new("TextButton", notif)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.BackgroundTransparency = 1
    
    task.wait(0.05)
    local finalHeight = titleLabel.AbsoluteSize.Y + contentLabel.AbsoluteSize.Y + 20
    notif.Size = UDim2.new(0, 280, 0, finalHeight)
    
    notif.Position = UDim2.new(0, 300, 0, 0)
    notif.BackgroundTransparency = 1
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.05
    }):Play()
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 300, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        if notif and notif.Parent then notif:Destroy() end
    end)
    
    task.wait(duration)
    if notif and notif.Parent then
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 300, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        if notif and notif.Parent then notif:Destroy() end
    end
    
    return notif
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
    self.Flags = {}
    self.FlagObjects = {}
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V2_Premium"
    sgui.ResetOnSpawn = false
    sgui.Parent = game:GetService("CoreGui")
    
    -- Fallback jika CoreGui tidak bisa
    pcall(function()
        sgui.Parent = CoreGui
    end)
    if not sgui.Parent then
        sgui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    self.ScreenGui = sgui
    
    -- Notification Holder
    self.NotificationHolder = NotificationHolder.new(sgui)
    
    -- Tooltip Manager
    self.Tooltip = TooltipManager.new(sgui, self.CurrentThemeColor)
    
    -- ==========================================
    -- 1. MAIN PREMIUM FRAME (LANGSUNG TAMPIL)
    -- ==========================================
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 550, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    self.MainFrame = mainFrame
    
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 1.5
    
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
                Size = UDim2.new(0, 550, 0, 450),
                Position = UDim2.new(0.5, -275, 0.5, -225)
            }):Play()
        end
    end
    
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.MouseButton1Click:Connect(toggleUI)
    
    self.TabBar = tabBar
    self.TabButtons = {}
    
    -- Animasi fade in
    mainFrame.BackgroundTransparency = 0.1
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.05}):Play()
    
    return self
end

function Window:CreateTab(name)
    local tab = Tab.new(self.PageContainer, name, self.CurrentThemeColor, self)
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
    if self.Tooltip and self.Tooltip.Stroke then
        TweenService:Create(self.Tooltip.Stroke, TweenInfo.new(0.5), {Color = newColor}):Play()
    end
end

function Window:Notify(data)
    if self.NotificationHolder then
        return self.NotificationHolder:Notify(data)
    end
end

function Window:SaveConfig(configName)
    local name = configName or "NomNom_Config"
    local data = self.Flags
    local success, err = pcall(function()
        writefile(name .. ".json", game:GetService("HttpService"):JSONEncode(data))
    end)
    if success then
        self:Notify({Title = "Config Saved", Content = "Saved to " .. name .. ".json", Duration = 2})
    else
        self:Notify({Title = "Save Failed", Content = tostring(err), Duration = 3})
    end
    return success
end

function Window:LoadConfig(configName)
    local name = configName or "NomNom_Config"
    local success, data = pcall(function()
        local content = readfile(name .. ".json")
        return game:GetService("HttpService"):JSONDecode(content)
    end)
    if success and data then
        for flag, value in pairs(data) do
            if self.FlagObjects[flag] then
                self.FlagObjects[flag]:SetValue(value)
            end
        end
        self:Notify({Title = "Config Loaded", Content = "Loaded from " .. name .. ".json", Duration = 2})
    else
        self:Notify({Title = "Load Failed", Content = "File not found or corrupted", Duration = 3})
    end
    return success
end

-- ================= KOMPONEN UI =================

function Section:CreateButton(config)
    local name = config.Name or config
    local callback = config.Callback or (type(config) == "function" and config) or nil
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    btn.Text = "   " .. (type(name) == "string" and name or name)
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
        TweenService:Create(stroke, TweenInfo.new(0.3), {Color = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)}):Play()
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

function Section:CreateToggle(config)
    local name = config.Name
    local flag = config.Flag
    local default = config.Default or false
    local callback = config.Callback
    local tooltip = config.Tooltip
    
    local state = default
    local WindowTheme = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
    
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
    
    local function setValue(value)
        state = value
        local targetColor = state and WindowTheme or Color3.fromRGB(50, 50, 55)
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(switchBG, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        if callback then callback(state) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = state
        end
    end
    
    switchBG.MouseButton1Click:Connect(function()
        setValue(not state)
    end)
    
    -- Tooltip
    if tooltip and self.WindowRef and self.WindowRef.Tooltip then
        local hoverConnection
        label.MouseEnter:Connect(function()
            self.WindowRef.Tooltip:Show(tooltip, UserInputService:GetMouseLocation())
        end)
        label.MouseLeave:Connect(function()
            self.WindowRef.Tooltip:Hide()
        end)
    end
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "Toggle"}, state)
    end
    
    return self:AddComponent(tf)
end

function Section:CreateSlider(config)
    local name = config.Name
    local flag = config.Flag
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback
    local tooltip = config.Tooltip
    
    local sliderVal = default
    
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
    valLabel.TextColor3 = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
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
    sliderFill.BackgroundColor3 = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
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
        sliderVal = value
        TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        if callback then callback(value) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = value
        end
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
    
    if tooltip and self.WindowRef and self.WindowRef.Tooltip then
        label.MouseEnter:Connect(function()
            self.WindowRef.Tooltip:Show(tooltip, UserInputService:GetMouseLocation())
        end)
        label.MouseLeave:Connect(function()
            self.WindowRef.Tooltip:Hide()
        end)
    end
    
    if flag then
        self:RegisterFlag(flag, {SetValue = function(v) 
            local pos = (v - min) / (max - min)
            sliderVal = v
            valLabel.Text = tostring(v)
            TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        end, Type = "Slider"}, sliderVal)
    end
    
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
    local flag = config.Flag
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
    
    local function setValue(value)
        textbox.Text = value
        if callback then callback(value) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = value
        end
    end
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textbox.Text)
        end
    end)
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "Textbox"}, "")
    end
    
    return self:AddComponent(tf)
end

function Section:CreateDropdown(config)
    local name = config.Name or "Dropdown"
    local options = config.Options or {}
    local flag = config.Flag
    local callback = config.Callback
    
    local expanded = false
    local selected = options[1] or "None"
    local WindowTheme = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
    
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
    selectedLabel.Text = selected
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
    
    local function setValue(option)
        selected = option
        selectedLabel.Text = option
        if callback then callback(option) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = option
        end
        expanded = false
        TweenService:Create(dropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.25)
        dropdownList.Visible = false
        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
    end
    
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
            setValue(option)
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
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "Dropdown"}, selected)
    end
    
    return self:AddComponent(df)
end

function Section:CreateMultiDropdown(config)
    local name = config.Name or "Multi Dropdown"
    local options = config.Options or {}
    local flag = config.Flag
    local callback = config.Callback
    
    local expanded = false
    local selected = {}
    for _, opt in pairs(options) do
        selected[opt] = false
    end
    local WindowTheme = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
    
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
    selectedLabel.Text = "None"
    selectedLabel.TextColor3 = WindowTheme
    selectedLabel.Font = Enum.Font.GothamBold
    selectedLabel.TextSize = 10
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
    
    local updateSelectedDisplay = function()
        local selectedList = {}
        for opt, val in pairs(selected) do
            if val then table.insert(selectedList, opt) end
        end
        if #selectedList == 0 then
            selectedLabel.Text = "None"
        elseif #selectedList <= 2 then
            selectedLabel.Text = table.concat(selectedList, ", ")
        else
            selectedLabel.Text = #selectedList .. " selected"
        end
        
        local result = {}
        for opt, val in pairs(selected) do
            if val then table.insert(result, opt) end
        end
        if callback then callback(result) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = result
        end
    end
    
    local optionButtons = {}
    
    for _, option in pairs(options) do
        local optFrame = Instance.new("Frame", dropdownList)
        optFrame.Size = UDim2.new(1, 0, 0, 35)
        optFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
        Instance.new("UICorner", optFrame).CornerRadius = UDim.new(0, 6)
        
        local checkBox = Instance.new("Frame", optFrame)
        checkBox.Size = UDim2.new(0, 18, 0, 18)
        checkBox.Position = UDim2.new(0, 10, 0.5, -9)
        checkBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Instance.new("UICorner", checkBox).CornerRadius = UDim.new(0, 4)
        
        local checkMark = Instance.new("TextLabel", checkBox)
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.Text = "✓"
        checkMark.TextColor3 = WindowTheme
        checkMark.Font = Enum.Font.GothamBold
        checkMark.TextSize = 12
        checkMark.BackgroundTransparency = 1
        checkMark.Visible = false
        
        local optLabel = Instance.new("TextLabel", optFrame)
        optLabel.Size = UDim2.new(1, -40, 1, 0)
        optLabel.Position = UDim2.new(0, 35, 0, 0)
        optLabel.Text = option
        optLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
        optLabel.Font = Enum.Font.GothamMedium
        optLabel.TextSize = 13
        optLabel.TextXAlignment = Enum.TextXAlignment.Left
        optLabel.BackgroundTransparency = 1
        
        local optBtn = Instance.new("TextButton", optFrame)
        optBtn.Size = UDim2.new(1, 0, 1, 0)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = ""
        
        optBtn.MouseButton1Click:Connect(function()
            selected[option] = not selected[option]
            checkMark.Visible = selected[option]
            updateSelectedDisplay()
        end)
        
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        end)
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
        end)
        
        table.insert(optionButtons, {Frame = optFrame, Check = checkMark, Option = option})
    end
    
    local button = Instance.new("TextButton", df)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    
    button.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            local count = #options
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
    
    local function setValue(valueTable)
        for opt, val in pairs(selected) do
            selected[opt] = false
        end
        for _, opt in pairs(valueTable) do
            if selected[opt] ~= nil then
                selected[opt] = true
            end
        end
        for _, item in pairs(optionButtons) do
            item.Check.Visible = selected[item.Option]
        end
        updateSelectedDisplay()
    end
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "MultiDropdown"}, {})
    end
    
    updateSelectedDisplay()
    return self:AddComponent(df)
end

function Section:CreateKeybind(config)
    local name = config.Name or "Keybind"
    local defaultKey = config.Default or Enum.KeyCode.F
    local flag = config.Flag
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
    
    local function setValue(newKey)
        currentKey = newKey
        updateKeyDisplay()
        if callback then callback(currentKey) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = currentKey
        end
    end
    
    keyLabel.MouseButton1Click:Connect(function()
        listening = true
        keyLabel.Text = "..."
        keyLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                setValue(input.KeyCode)
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
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "Keybind"}, currentKey)
    end
    
    return self:AddComponent(kf)
end

function Section:CreateColorPicker(config)
    local name = config.Name or "Color Picker"
    local flag = config.Flag
    local defaultColor = config.Default or Color3.fromRGB(255, 0, 0)
    local callback = config.Callback
    
    local expanded = false
    local currentColor = defaultColor
    local hue = 0
    local sat = 1
    local val = 1
    local WindowTheme = self.WindowRef and self.WindowRef.CurrentThemeColor or Color3.fromRGB(0, 170, 255)
    
    local function rgbToHsv(color)
        local r, g, b = color.R, color.G, color.B
        local max, min = math.max(r, g, b), math.min(r, g, b)
        local h, s, v = max, max, max
        local d = max - min
        s = max == 0 and 0 or d / max
        if max == min then
            h = 0
        else
            if max == r then
                h = (g - b) / d
                if g < b then h = h + 6 end
            elseif max == g then
                h = (b - r) / d + 2
            elseif max == b then
                h = (r - g) / d + 4
            end
            h = h / 6
        end
        return h, s, v
    end
    
    hue, sat, val = rgbToHsv(defaultColor)
    
    local cf = Instance.new("Frame")
    cf.Size = UDim2.new(1, 0, 0, 45)
    cf.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", cf)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local colorPreview = Instance.new("Frame", cf)
    colorPreview.Size = UDim2.new(0, 30, 0, 30)
    colorPreview.Position = UDim2.new(1, -45, 0.5, -15)
    colorPreview.BackgroundColor3 = currentColor
    colorPreview.BorderSizePixel = 0
    Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(0, 6)
    
    local arrow = Instance.new("TextLabel", cf)
    arrow.Size = UDim2.new(0, 30, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 160)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.BackgroundTransparency = 1
    
    local pickerFrame = Instance.new("Frame", cf)
    pickerFrame.Size = UDim2.new(1, -20, 0, 0)
    pickerFrame.Position = UDim2.new(0, 10, 0, 45)
    pickerFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    pickerFrame.ClipsDescendants = true
    pickerFrame.Visible = false
    Instance.new("UICorner", pickerFrame).CornerRadius = UDim.new(0, 8)
    
    local svSquare = Instance.new("ImageButton", pickerFrame)
    svSquare.Size = UDim2.new(0, 180, 0, 180)
    svSquare.Position = UDim2.new(0, 10, 0, 10)
    svSquare.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svSquare.Image = "rbxassetid://4155801252"
    svSquare.ScaleType = Enum.ScaleType.Slice
    Instance.new("UICorner", svSquare).CornerRadius = UDim.new(0, 6)
    
    local svCursor = Instance.new("Frame", svSquare)
    svCursor.Size = UDim2.new(0, 10, 0, 10)
    svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svCursor.BorderSizePixel = 0
    Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
    
    local hueBar = Instance.new("ImageButton", pickerFrame)
    hueBar.Size = UDim2.new(0, 20, 0, 180)
    hueBar.Position = UDim2.new(0, 200, 0, 10)
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueBar.Image = "rbxassetid://4155801252"
    Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 6)
    
    local hueCursor = Instance.new("Frame", hueBar)
    hueCursor.Size = UDim2.new(1, 0, 0, 4)
    hueCursor.Position = UDim2.new(0, 0, hue, -2)
    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueCursor.BorderSizePixel = 0
    
    local rBox, gBox, bBox
    
    local function updateColor()
        currentColor = Color3.fromHSV(hue, sat, val)
        colorPreview.BackgroundColor3 = currentColor
        svSquare.ImageColor3 = Color3.fromHSV(hue, 1, 1)
        if callback then callback(currentColor) end
        if flag and self.WindowRef then
            self.WindowRef.Flags[flag] = currentColor
        end
        
        if rBox then
            rBox.Text = math.floor(currentColor.R * 255)
            gBox.Text = math.floor(currentColor.G * 255)
            bBox.Text = math.floor(currentColor.B * 255)
        end
    end
    
    local draggingSV = false
    svSquare.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = true
            local pos = input.Position - svSquare.AbsolutePosition
            sat = math.clamp(pos.X / svSquare.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp(pos.Y / svSquare.AbsoluteSize.Y, 0, 1)
            svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
            updateColor()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position - svSquare.AbsolutePosition
            sat = math.clamp(pos.X / svSquare.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp(pos.Y / svSquare.AbsoluteSize.Y, 0, 1)
            svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
            updateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSV = false
        end
    end)
    
    local draggingHue = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = true
            local posY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            hue = posY
            hueCursor.Position = UDim2.new(0, 0, hue, -2)
            updateColor()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            local posY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
            hue = posY
            hueCursor.Position = UDim2.new(0, 0, hue, -2)
            updateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingHue = false
        end
    end)
    
    local rgbFrame = Instance.new("Frame", pickerFrame)
    rgbFrame.Size = UDim2.new(1, -20, 0, 30)
    rgbFrame.Position = UDim2.new(0, 10, 0, 200)
    rgbFrame.BackgroundTransparency = 1
    
    local function createRGBBox(parent, x, colorName)
        local box = Instance.new("TextBox", parent)
        box.Size = UDim2.new(0, 60, 1, 0)
        box.Position = UDim2.new(x, 0, 0, 0)
        box.PlaceholderText = colorName
        box.Text = "0"
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Font = Enum.Font.GothamMedium
        box.TextSize = 12
        box.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        return box
    end
    
    rBox = createRGBBox(rgbFrame, 0, "R")
    gBox = createRGBBox(rgbFrame, 65, "G")
    bBox = createRGBBox(rgbFrame, 130, "B")
    
    local function updateFromRGB()
        local r = math.clamp(tonumber(rBox.Text) or 0, 0, 255) / 255
        local g = math.clamp(tonumber(gBox.Text) or 0, 0, 255) / 255
        local b = math.clamp(tonumber(bBox.Text) or 0, 0, 255) / 255
        local newH, newS, newV = rgbToHsv(Color3.new(r, g, b))
        hue = newH
        sat = newS
        val = newV
        svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
        hueCursor.Position = UDim2.new(0, 0, hue, -2)
        updateColor()
    end
    
    rBox.FocusLost:Connect(updateFromRGB)
    gBox.FocusLost:Connect(updateFromRGB)
    bBox.FocusLost:Connect(updateFromRGB)
    
    local totalHeight = 240
    pickerFrame.Size = UDim2.new(1, -20, 0, totalHeight)
    
    local button = Instance.new("TextButton", cf)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    
    button.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            pickerFrame.Visible = true
            cf.Size = UDim2.new(1, 0, 0, 45 + totalHeight + 10)
            TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(pickerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            task.wait(0.25)
            pickerFrame.Visible = false
            cf.Size = UDim2.new(1, 0, 0, 45)
        end
    end)
    
    local function setValue(color)
        currentColor = color
        hue, sat, val = rgbToHsv(color)
        colorPreview.BackgroundColor3 = color
        svCursor.Position = UDim2.new(sat, -5, 1 - val, -5)
        hueCursor.Position = UDim2.new(0, 0, hue, -2)
        updateColor()
    end
    
    if flag then
        self:RegisterFlag(flag, {SetValue = setValue, Type = "ColorPicker"}, currentColor)
    end
    
    updateColor()
    return self:AddComponent(cf)
end

-- Backward compatibility
function NomNom.new(config)
    local window = Window.new(config)
    
    window.CreateButton = function(_, name, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateButton({Name = name, Callback = callback})
    end
    
    window.CreateToggle = function(_, name, default, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateToggle({Name = name, Default = default, Callback = callback})
    end
    
    window.CreateSlider = function(_, name, min, max, default, callback)
        local tab = window:CreateTab("Main")
        local section = tab:CreateSection("Components")
        return section:CreateSlider({Name = name, Min = min, Max = max, Default = default, Callback = callback})
    end
    
    window.ChangeTheme = function(self, newColor)
        return window:ChangeTheme(newColor)
    end
    
    window.Notify = function(self, data)
        return window:Notify(data)
    end
    
    window.SaveConfig = function(self, name)
        return window:SaveConfig(name)
    end
    
    window.LoadConfig = function(self, name)
        return window:LoadConfig(name)
    end
    
    return window
end

return NomNom
