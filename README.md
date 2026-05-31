
# 🫪 NomNom UI Library V3.1 

An ultra-sleek, modern, and highly responsive **Roblox UI Library** meticulously crafted for developers who demand high performance and aesthetics. **Titanium Edition** introduces an improved fluid kinematic intro sequence and a zero-lag lagless real-time color customizer.

---

## ✨ Features At A Glance

* 🎬 **Cinematic Intro Sequence** — Immersive fade animations that scale properly across devices without breaking layout flows.
* 🚀 **Zero-Lag Color Picker** — Immediate runtime theme shifting using dynamic structural rendering (no thread-clogging Tweens).
* 📱 **Dynamic Island Minimization** — Clean, modern, interactive pill container tracking script states when the dashboard is minimized.
* 🔎 **Instant Tab Search Engine** — High-speed localized text querying to filter interaction elements seamlessly.
* 🌪️ **Fluid Dragging Physics** — Easing-driven panel positioning making movement naturally smooth.

---

## 🚀 Getting Started

To initialize the interface inside your execution script, paste the following boilerplate inside your exploit or environment:

```lua
local NomNom = loadstring(game:HttpGet("[https://raw.githubusercontent.com/1MN00X/NomNom/refs/heads/main/source-2.lua](https://raw.githubusercontent.com/1MN00X/NomNom/refs/heads/main/source-2.lua)"))()

local UI = NomNom.new({
    Title = "NomNom Premium",          -- Main Window Header Title
    ThemeColor = Color3.fromRGB(150, 100, 255), -- Default Accent Color
    LogoId = "rbxassetid://16020556213"  -- Custom Logo Asset ID (Leave "" for Text-Only)
})

```

---

## 🛠️ Complete API Documentation

### 🗂️ 1. Creating Navigation Tabs

Tabs automatically calculate dimensions based on string lengths and accept emojis or Roblox Asset IDs as icons.

```lua
local MainTab = UI:CreateTab("Dashboard", "🏠")
local SettingsTab = UI:CreateTab("Settings", "rbxassetid://16020556213")

```

### 🧱 2. Adding Interactive Elements

#### 🔘 Buttons

```lua
MainTab:CreateButton("Execute Script", function()
    print("Action fired!")
end, "⚡")

```

#### 🎚️ Toggles

```lua
MainTab:CreateToggle("Auto-Farm", false, function(state)
    print("Toggle State: ", state) -- Returns true or false
end, "🌾")

```

#### 🎛️ Sliders

```lua
MainTab:CreateSlider("WalkSpeed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end, "🏃‍♂️")

```

#### 📝 TextBoxes

```lua
MainTab:CreateTextBox("Teleport Player", "Enter username...", function(input)
    print("Target player: " .. input)
end, "👤")

```

#### 🎨 Color Pickers (Dynamic Theme Engine)

```lua
SettingsTab:CreateColorPicker("Menu Theme Color", function(selectedColor)
    -- Updates menu skin dynamically with zero overhead performance loss
end, "🎨")

```

### 📊 3. Status Utilities & Progress Displays

#### 🔔 Toast Notifications

```lua
UI:Notify({
    Title = "Security Breach",
    Text = "A moderator has joined your server instance!",
    Duration = 5
})

```

#### 🔄 Progress Bars

```lua
local ProgressBar = MainTab:CreateProgressBar("Downloading Configs", 0, 100, "💾")
ProgressBar:Update(45) -- Dynamically updates the bar size smoothly

```

#### 🟢 Status Indicators

```lua
local Status = MainTab:CreateStatusIndicator("Anti-Cheat Bypass", "Injecting...", Color3.fromRGB(255, 165, 0), "🛡️")
-- Update the state later on:
Status:Update("Fully Bypassed", Color3.fromRGB(0, 255, 128))

```

---

## 🔍 Structural Layout Preview

| Component | Purpose | Input Type |
| --- | --- | --- |
| **Search Bar** | Filters all UI elements inside its respective tab | String Input |
| **Dynamic Island** | Collapses the main frame into a minimalist notifications widget | Click Toggle |
| **Intro Layer** | Prevents visual clipping before elements fully draw | UI Sequence |
