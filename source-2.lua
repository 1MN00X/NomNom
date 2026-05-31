-- [[ NomNom UI Library V2.5: Ultra Premium Edition ]]
-- Fitur Ditambahkan: Tabs, Sections, Labels, Textbox, Dropdown, Keybind, Notifications, Shadows

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

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
    
    self.Title = config.Title or "NomNom Premium"
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.ThemeObjects = {}
    self.Tabs = {}
    self.FirstTab = true
    
    local sgui = Instance.new("ScreenGui")
    sgui.Name = "NomNom_V2_Premium"
    sgui.ResetOnSpawn = false
    sgui.Parent = CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui = sgui
    
    -- Notification Container
    self.NotifContainer = Instance.new("Frame", sgui)
    self.NotifContainer.Size = UDim2.new(0, 300, 1, -20)
    self.NotifContainer.Position = UDim2.new(1, -320, 0, 10)
    self.NotifContainer.BackgroundTransparency = 1
    local notifLayout = Instance.new("UIListLayout", self.NotifContainer)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 10)

    -- Loading Screen (Simplified for space)
    local loadingFrame = Instance.new("Frame", sgui)
    loadingFrame.Size = UDim2.new(0, 320, 0, 100)
    loadingFrame.Position = UDim2.new(0.5, -160, 0.5, -50)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 14)
    local lStroke = Instance.new("UIStroke", loadingFrame)
    lStroke.Color = self.CurrentThemeColor
    
    local loadTitle = Instance.new("TextLabel", loadingFrame)
    loadTitle.Size = UDim2.new(1, 0, 1, 0)
    loadTitle.Text = "Loading " .. self.Title .. "..."
    loadTitle.Font = Enum.Font.GothamBlack
    loadTitle.TextSize = 18
    loadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadTitle.BackgroundTransparency = 1
    
    task.wait(1)
    loadingFrame:Destroy()

    -- MAIN FRAME
    local mainFrame = Instance.new("Frame", sgui)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    mainFrame.ClipsDescendants = true
    self.MainFrame = mainFrame
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(40, 40, 45)
    mainStroke.Thickness = 1.5

    -- Drop Shadow
    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015536839"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 450),
        Position = UDim2.new(0.5, -300, 0.5, -225)
    }):Play()
    
    -- Dynamic Island
    local island = Instance.new("TextButton", sgui)
    island.Size = UDim2.new(0, 200, 0, 35)
    island.Position = UDim2.new(0.5, -100, 0, 20)
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    island.Visible = false
    island.Text = "  " .. self.Title
    island.TextColor3 = Color3.fromRGB(255, 255, 255)
    island.Font = Enum.Font.GothamBold
    island.TextSize = 13
    island.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)
    
    local islandStroke = Instance.new("UIStroke", island)
    islandStroke.Color = self.CurrentThemeColor
    islandStroke.Thickness = 1.5
    table.insert(self.ThemeObjects, {Obj = islandStroke, Prop = "Color"})
    self.Island = island
    self.IsOpen = true
    
    -- Header UI
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
    
    -- Tab Container
    self.TabHolder = Instance.new("ScrollingFrame", mainFrame)
    self.TabHolder.Size = UDim2.new(0, 140, 1, -60)
    self.TabHolder.Position = UDim2.new(0, 10, 0, 50)
    self.TabHolder.BackgroundTransparency = 1
    self.TabHolder.ScrollBarThickness = 0
    local tabLayout = Instance.new("UIListLayout", self.TabHolder)
    tabLayout.Padding = UDim.new(0, 5)
    
    -- Pages Container
    self.Pages = Instance.new("Frame", mainFrame)
    self.Pages.Size = UDim2.new(1, -170, 1, -70)
    self.Pages.Position = UDim2.new(0, 160, 0, 60)
    self.Pages.BackgroundTransparency = 1

    local function toggleUI()
        self.IsOpen = not self.IsOpen
        if not self.IsOpen then
            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 35), Position = UDim2.new(0.5, -100, 0, 20)}):Play()
            for _, v in pairs(mainFrame:GetChildren()) do if v:IsA("GuiObject") then v.Visible = false end end
            task.wait(0.3)
            mainFrame.Visible = false
            island.Visible = true
            island.Size = UDim2.new(0, 150, 0, 25)
            island.Position = UDim2.new(0.5, -75, 0, 25)
            TweenService:Create(island, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 35), Position = UDim2.new(0.5, -100, 0, 20)}):Play()
        else
            island.Visible = false
            mainFrame.Visible = true
            for _, v in pairs(mainFrame:GetChildren()) do if v:IsA("GuiObject") and v ~= shadow then v.Visible = true end end
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 450), Position = UDim2.new(0.5, -300, 0.5, -225)}):Play()
        end
    end
    closeBtn.MouseButton1Click:Connect(toggleUI)
    island.MouseButton1Click:Connect(toggleUI)
    
    return self
end

function NomNom:Notify(title, text, duration)
    duration = duration or 3
    local notif = Instance.new("Frame", self.NotifContainer)
    notif.Size = UDim2.new(1, 0, 0, 60)
    notif.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    notif.BackgroundTransparency = 1
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = self.CurrentThemeColor
    stroke.Thickness = 1.5
    stroke.Transparency = 1
    table.insert(self.ThemeObjects, {Obj = stroke, Prop = "Color"})
    
    local titleLbl = Instance.new("TextLabel", notif)
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 5)
    titleLbl.Text = title
    titleLbl.TextColor3 = self.CurrentThemeColor
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextTransparency = 1
    table.insert(self.ThemeObjects, {Obj = titleLbl, Prop = "TextColor3"})
    
    local descLbl = Instance.new("TextLabel", notif)
    descLbl.Size = UDim2.new(1, -20, 0, 25)
    descLbl.Position = UDim2.new(0, 10, 0, 25)
    descLbl.Text = text
    descLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 12
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextWrapped = true
    descLbl.BackgroundTransparency = 1
    descLbl.TextTransparency = 1

    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(descLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(descLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

function NomNom:CreateTab(name)
    local tab = {}
    local tabBtn = Instance.new("TextButton", self.TabHolder)
    tabBtn.Size = UDim2.new(1, 0, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    tabBtn.Text = "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local page = Instance.new("ScrollingFrame", self.Pages)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = self.CurrentThemeColor
    page.Visible = self.FirstTab
    table.insert(self.ThemeObjects, {Obj = page, Prop = "ScrollBarImageColor3"})
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)
    
    if self.FirstTab then
        tabBtn.BackgroundColor3 = self.CurrentThemeColor
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.FirstTab = false
    end
    
    table.insert(self.Tabs, {Btn = tabBtn, Page = page})
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 25), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        page.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = self.CurrentThemeColor, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    -- TAB COMPONENTS
    function tab:CreateSection(title)
        local sec = Instance.new("TextLabel", page)
        sec.Size = UDim2.new(1, 0, 0, 25)
        sec.Text = " " .. title
        sec.TextColor3 = self.CurrentThemeColor
        sec.Font = Enum.Font.GothamBold
        sec.TextSize = 12
        sec.TextXAlignment = Enum.TextXAlignment.Left
        sec.BackgroundTransparency = 1
        return sec
    end

    function tab:CreateLabel(text)
        local lbl = Instance.new("TextLabel", page)
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
    end

    function tab:CreateButton(name, callback)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Text = "   " .. name
        btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -14, 0, 36)}):Play()
            task.wait(0.1)
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 40)}):Play()
            if callback then callback() end
        end)
    end

    function tab:CreateToggle(name, default, callback)
        local state = default or false
        local tf = Instance.new("Frame", page)
        tf.Size = UDim2.new(1, -10, 0, 40)
        tf.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 6)
        
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
        switchBG.BackgroundColor3 = state and self.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
        switchBG.Text = ""
        switchBG.AutoButtonColor = false
        Instance.new("UICorner", switchBG).CornerRadius = UDim.new(1, 0)
        
        local circle = Instance.new("Frame", switchBG)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        switchBG.MouseButton1Click:Connect(function()
            state = not state
            local targetColor = state and self.CurrentThemeColor or Color3.fromRGB(50, 50, 55)
            local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            TweenService:Create(switchBG, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
            if callback then callback(state) end
        end)
    end

    function tab:CreateTextbox(name, placeholder, callback)
        local tf = Instance.new("Frame", page)
        tf.Size = UDim2.new(1, -10, 0, 40)
        tf.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", tf).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", tf)
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local box = Instance.new("TextBox", tf)
        box.Size = UDim2.new(0.4, 0, 0, 26)
        box.Position = UDim2.new(0.6, -15, 0.5, -13)
        box.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        box.Text = ""
        box.PlaceholderText = placeholder or "Input..."
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 12
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

        box.FocusLost:Connect(function(enterPressed)
            if callback then callback(box.Text) end
        end)
    end

    function tab:CreateKeybind(name, defaultKey, callback)
        local key = defaultKey or Enum.KeyCode.E
        local kf = Instance.new("Frame", page)
        kf.Size = UDim2.new(1, -10, 0, 40)
        kf.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Instance.new("UICorner", kf).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel", kf)
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(240, 240, 240)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local bindBtn = Instance.new("TextButton", kf)
        bindBtn.Size = UDim2.new(0, 60, 0, 26)
        bindBtn.Position = UDim2.new(1, -75, 0.5, -13)
        bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        bindBtn.Text = key.Name
        bindBtn.TextColor3 = self.CurrentThemeColor
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 12
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)

        local listening = false
        bindBtn.MouseButton1Click:Connect(function()
            listening = true
            bindBtn.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    bindBtn.Text = key.Name
                    listening = false
                elseif not listening and input.KeyCode == key then
                    if callback then callback(key) end
                end
            end
        end)
    end

    function tab:CreateDropdown(name, options, callback)
        local drop = Instance.new("Frame", page)
        drop.Size = UDim2.new(1, -10, 0, 40)
        drop.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        drop.ClipsDescendants = true
        Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)
        
        local dropBtn = Instance.new("TextButton", drop)
        dropBtn.Size = UDim2.new(1, 0, 0, 40)
        dropBtn.BackgroundTransparency = 1
        dropBtn.Text = "   " .. name .. " : None"
        dropBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        dropBtn.Font = Enum.Font.GothamMedium
        dropBtn.TextSize = 13
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local isDropped = false
        local container = Instance.new("ScrollingFrame", drop)
        container.Size = UDim2.new(1, 0, 1, -40)
        container.Position = UDim2.new(0, 0, 0, 40)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 2
        local listLayout = Instance.new("UIListLayout", container)
        
        for _, opt in pairs(options) do
            local optBtn = Instance.new("TextButton", container)
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 23)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 12
            
            optBtn.MouseButton1Click:Connect(function()
                dropBtn.Text = "   " .. name .. " : " .. opt
                isDropped = false
                TweenService:Create(drop, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                if callback then callback(opt) end
            end)
        end
        
        dropBtn.MouseButton1Click:Connect(function()
            isDropped = not isDropped
            local targetHeight = isDropped and math.clamp(40 + (#options * 30), 40, 150) or 40
            TweenService:Create(drop, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
        end)
    end

    -- Update Size Page Canvas dynamically
    page.ChildAdded:Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    return tab
end

return NomNom
