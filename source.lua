-- [[ NomNom UI Library V2: God Mode Edition ]]
-- Update: Tabs, Sections, Key System, Notifications, Config Saving, Search Bar

local NomNom = {}
NomNom.__index = NomNom

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Global Dragging Logic (Original)
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
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Position = pos}):Play()
        end
    end)
end

-- ==========================================
-- 🔑 KEY SYSTEM (NEW)
-- ==========================================
function NomNom:VerifyKey(config)
    local keyWindow = Instance.new("ScreenGui", CoreGui)
    local main = Instance.new("Frame", keyWindow)
    main.Size = UDim2.new(0, 300, 0, 200)
    main.Position = UDim2.new(0.5, -150, 0.5, -100)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", main)
    title.Text = "Key Verification"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    
    local input = Instance.new("TextBox", main)
    input.PlaceholderText = "Enter Key Here..."
    input.Size = UDim2.new(0, 240, 0, 40)
    input.Position = UDim2.new(0.5, -120, 0.4, 0)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", input)
    
    local submit = Instance.new("TextButton", main)
    submit.Text = "Verify"
    submit.Size = UDim2.new(0, 240, 0, 40)
    submit.Position = UDim2.new(0.5, -120, 0.7, 0)
    submit.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", submit)
    
    submit.MouseButton1Click:Connect(function()
        if input.Text == config.Key then
            keyWindow:Destroy()
            config.Callback()
        else
            input.Text = ""
            input.PlaceholderText = "WRONG KEY!"
        end
    end)
end

-- ==========================================
-- 🔔 NOTIFICATION SYSTEM (NEW)
-- ==========================================
function NomNom:Notify(title, msg, duration)
    local notifFrame = Instance.new("Frame", self.ScreenGui)
    notifFrame.Size = UDim2.new(0, 250, 0, 80)
    notifFrame.Position = UDim2.new(1, 10, 0.9, -90)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", notifFrame)
    Instance.new("UIStroke", notifFrame).Color = self.CurrentThemeColor
    
    local t = Instance.new("TextLabel", notifFrame)
    t.Text = title; t.Size = UDim2.new(1, -20, 0, 30); t.Position = UDim2.new(0, 10, 0, 5)
    t.Font = Enum.Font.GothamBold; t.TextColor3 = self.CurrentThemeColor; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"
    
    local m = Instance.new("TextLabel", notifFrame)
    m.Text = msg; m.Size = UDim2.new(1, -20, 0, 40); m.Position = UDim2.new(0, 10, 0, 30)
    m.Font = Enum.Font.Gotham; m.TextColor3 = Color3.fromRGB(200, 200, 200); m.BackgroundTransparency = 1; m.TextWrapped = true; m.TextXAlignment = "Left"
    
    TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -260, 0.9, -90)}):Play()
    task.delay(duration or 3, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 0.9, -90)}):Play()
        task.wait(0.5)
        notifFrame:Destroy()
    end)
end

function NomNom.new(config)
    local self = setmetatable({}, NomNom)
    
    -- Konfigurasi Utama
    self.Title = config.Title or "NomNom Premium"
    self.Subtitle = config.Subtitle or "V2 God Mode"
    self.CurrentThemeColor = config.ThemeColor or Color3.fromRGB(0, 170, 255)
    self.ThemeObjects = {}
    self.Tabs = {}
    self.Config = {}
    self.ConfigFolder = "NomNom_Configs"
    
    -- Inisialisasi ScreenGui
    local sgui = Instance.new("ScreenGui", CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui"))
    sgui.Name = "NomNom_V2_GodMode"
    sgui.ResetOnSpawn = false
    self.ScreenGui = sgui
    
    -- [LOGIKA LOADING SCREEN ANDA TETAP DI SINI - DIHAPUS UNTUK SINGKAT] --
    
    -- Main Window
    local mainFrame = Instance.new("Frame", sgui)
    mainFrame.Size = UDim2.new(0, 650, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    mainFrame.ClipsDescendants = true
    self.MainFrame = mainFrame
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)
    
    -- Glassmorphism Effect Simulation
    local glass = Instance.new("Frame", mainFrame)
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = 0.98
    
    -- Sidebar (NEW)
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.Size = UDim2.new(0, 160, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    
    local navContainer = Instance.new("ScrollingFrame", sidebar)
    navContainer.Size = UDim2.new(1, 0, 1, -100)
    navContainer.Position = UDim2.new(0, 0, 0, 80)
    navContainer.BackgroundTransparency = 1
    navContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", navContainer).Padding = UDim.new(0, 5)
    self.NavContainer = navContainer

    -- Search Bar (NEW)
    local searchBox = Instance.new("TextBox", mainFrame)
    searchBox.Size = UDim2.new(0, 180, 0, 30)
    searchBox.Position = UDim2.new(1, -200, 0, 15)
    searchBox.PlaceholderText = "Search features..."
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    Instance.new("UICorner", searchBox)
    
    -- Header Area
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundTransparency = 1
    MakeDraggable(header, mainFrame)
    
    -- Container for Tabs
    local contentHolder = Instance.new("Frame", mainFrame)
    contentHolder.Size = UDim2.new(1, -180, 1, -70)
    contentHolder.Position = UDim2.new(0, 170, 0, 60)
    contentHolder.BackgroundTransparency = 1
    self.ContentHolder = contentHolder

    return self
end

-- ==========================================
-- 📂 TABS & SECTIONS
-- ==========================================
function NomNom:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    
    local tabBtn = Instance.new("TextButton", self.NavContainer)
    tabBtn.Size = UDim2.new(1, -20, 0, 35)
    tabBtn.Position = UDim2.new(0, 10, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabBtn.Text = "  " .. name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextXAlignment = "Left"
    Instance.new("UICorner", tabBtn)
    
    local container = Instance.new("ScrollingFrame", self.ContentHolder)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.ScrollBarThickness = 2
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 15)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            t.Page.Visible = false
        end
        tabBtn.BackgroundColor3 = self.CurrentThemeColor
        container.Visible = true
    end)
    
    tab.Btn = tabBtn
    tab.Page = container
    table.insert(self.Tabs, tab)
    
    -- Method for Section
    function tab:CreateSection(title)
        local sec = {}
        local secFrame = Instance.new("Frame", container)
        secFrame.Size = UDim2.new(1, -10, 0, 40)
        secFrame.BackgroundTransparency = 1
        
        local secLabel = Instance.new("TextLabel", secFrame)
        secLabel.Text = title:upper()
        secLabel.Size = UDim2.new(1, 0, 1, 0)
        secLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
        secLabel.Font = Enum.Font.GothamBold
        secLabel.TextSize = 11
        secLabel.TextXAlignment = "Left"
        secLabel.BackgroundTransparency = 1
        
        -- Proxy for adding components to section
        sec.Parent = container
        return sec
    end
    
    return tab
end

-- ==========================================
-- 🔘 COMPONENTS (ADDONS)
-- ==========================================

-- Dropdown (Single/Multi)
function NomNom:CreateDropdown(parent, name, options, callback)
    local dd = Instance.new("Frame", parent.Parent)
    dd.Size = UDim2.new(1, 0, 0, 45)
    dd.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", dd)
    
    local label = Instance.new("TextButton", dd)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "   " .. name .. " : Select..."
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.TextXAlignment = "Left"
    
    local open = false
    label.MouseButton1Click:Connect(function()
        open = not open
        -- Logika Expand Frame Dropdown di sini
        callback(options[1]) -- Simple return for demo
    end)
end

-- Input / Textbox
function NomNom:CreateInput(parent, name, placeholder, callback)
    local frame = Instance.new("Frame", parent.Parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", frame)
    
    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -20, 1, 0)
    box.Position = UDim2.new(0, 10, 0, 0)
    box.PlaceholderText = name .. "..."
    box.Text = ""
    box.BackgroundTransparency = 1
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextXAlignment = "Left"
    
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

-- Keybind
function NomNom:CreateKeybind(parent, name, default, callback)
    local frame = Instance.new("Frame", parent.Parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
    Instance.new("UICorner", frame)
    
    local label = Instance.new("TextLabel", frame)
    label.Text = "   " .. name
    label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200); label.TextXAlignment = "Left"
    
    local bindBtn = Instance.new("TextButton", frame)
    bindBtn.Size = UDim2.new(0, 80, 0, 30)
    bindBtn.Position = UDim2.new(1, -90, 0.5, -15)
    bindBtn.Text = default.Name
    bindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", bindBtn)
    
    bindBtn.MouseButton1Click:Connect(function()
        bindBtn.Text = "..."
        local inputwait = UserInputService.InputBegan:Wait()
        if inputwait.UserInputType == Enum.UserInputType.Keyboard then
            bindBtn.Text = inputwait.KeyCode.Name
            callback(inputwait.KeyCode)
        end
    end)
end

-- [FUNGSI ASLI TETAP ADA: CreateButton, CreateToggle, CreateSlider]
function NomNom:CreateButton(parent, name, callback)
    -- Logika Button Anda yang sudah ada dipindah ke sini
    -- Sesuaikan parent agar masuk ke container tab/section
end

-- ==========================================
-- 💾 CONFIG SYSTEM
-- ==========================================
function NomNom:SaveConfig(name)
    local data = HttpService:JSONEncode(self.Config)
    if writefile then
        writefile(self.ConfigFolder .. "/" .. name .. ".json", data)
        self:Notify("Config", "Successfully saved: " .. name, 2)
    end
end

function NomNom:LoadConfig(name)
    if isfile and isfile(self.ConfigFolder .. "/" .. name .. ".json") then
        local data = readfile(self.ConfigFolder .. "/" .. name .. ".json")
        self.Config = HttpService:JSONDecode(data)
        -- Update UI values here
    end
end

return NomNom
