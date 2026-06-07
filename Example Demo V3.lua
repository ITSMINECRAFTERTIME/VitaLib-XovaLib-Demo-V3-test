--[[
    VitaLib Enhanced v3.0 — Example.lua
    Keyland key system integration (uses executor request() function)
--]]

local DISCORD_INVITE = "discord.gg/ZKvgjBm4YE"
local KEYLAND_URL    = "https://keyland.onrender.com"

local Library = loadstring(game:HttpGet'https://raw.githubusercontent.com/ITSMINECRAFTERTIME/VitaLib-XovaLib-Demo-V3-test/refs/heads/main/VitaLib.lua')()

-- ══════════════════════════════════════════════════════════════════════════
-- KEYLAND KEY SYSTEM
-- ══════════════════════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")
local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
local verified = false

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeylandGui"
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
keyGui.ResetOnSpawn = false
keyGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", keyGui)
frame.Size = UDim2.new(0, 320, 0, 140)
frame.Position = UDim2.new(0.5, -160, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(255, 0, 127)

local title = Instance.new("TextLabel", frame)
title.Text = "🔑 Keyland"
title.TextColor3 = Color3.fromRGB(255, 0, 127)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1

local sub = Instance.new("TextLabel", frame)
sub.Text = "Enter your key below"
sub.TextColor3 = Color3.fromRGB(163, 163, 163)
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.Size = UDim2.new(1, 0, 0, 16)
sub.Position = UDim2.new(0, 0, 0, 34)
sub.BackgroundTransparency = 1

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.88, 0, 0, 30)
input.Position = UDim2.new(0.06, 0, 0, 56)
input.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.PlaceholderText = "KL-XXXXXXXXXXXXXXXX..."
input.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
input.Font = Enum.Font.Gotham
input.TextSize = 12
input.ClearTextOnFocus = false
input.BorderSizePixel = 0
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 5)

local status = Instance.new("TextLabel", frame)
status.Text = ""
status.TextColor3 = Color3.fromRGB(220, 50, 50)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Size = UDim2.new(1, 0, 0, 14)
status.Position = UDim2.new(0, 0, 0, 90)
status.BackgroundTransparency = 1

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.88, 0, 0, 26)
btn.Position = UDim2.new(0.06, 0, 0, 106)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "Submit"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 13
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

btn.MouseButton1Click:Connect(function()
    local enteredKey = input.Text
    if enteredKey == "" then
        status.Text = "Please enter a key."
        return
    end
    btn.Text = "Checking..."
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    status.Text = ""

    local ok, response = pcall(function()
        return request({
            Url = KEYLAND_URL .. "/api/keys/verify",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ key = enteredKey, hwid = hwid })
        })
    end)

    if not ok or not response then
        status.Text = "Server unreachable."
        btn.Text = "Submit"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
        return
    end

    local parsed, data = pcall(HttpService.JSONDecode, HttpService, response.Body)
    if not parsed then
        status.Text = "Bad response from server."
        btn.Text = "Submit"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
        return
    end

    if data.valid then
        verified = true
        keyGui:Destroy()
    else
        status.Text = data.error or "Invalid key."
        btn.Text = "Submit"
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
    end
end)

repeat task.wait(0.1) until verified

-- ══════════════════════════════════════════════════════════════════════════
-- MAIN UI
-- ══════════════════════════════════════════════════════════════════════════
local Window = Library:Window({
    Title             = "VitaLib Demo",
    SubTitle          = "Enhanced v3.0",
    Size              = UDim2.new(0, 550, 0, 400),
    ToggleKey         = Enum.KeyCode.RightControl,
    BbIcon            = "settings",
    AutoScale         = true,
    Scale             = 1.45,
    ExecIdentifyShown = true,
    CornerGlow        = "#FF007F",
    Theme = {
        Accent     = "#FF007F",
        Background = "#0D0D0D",
        Row        = "#0F0F0F",
        RowAlt     = "#0A0A0A",
        Stroke     = "#191919",
        Text       = "#FFFFFF",
        SubText    = "#A3A3A3",
        TabBg      = "#0A0A0A",
        TabStroke  = "#4B0026",
        TabImage   = "#FF007F",
        DropBg     = "#121212",
        DropStroke = "#1E1E1E",
        PillBg     = "#0B0B0B",
    },
})

-- PAGE 1 — Main Controls
local P1 = Window:NewPage({
    Title    = "Main",
    Desc     = "Core controls",
    Icon     = "home",
    TabImage = "#FF007F",
})

P1:Section("Toggles")

local SpeedToggle = P1:Toggle({
    Title    = "Speed Boost",
    Desc     = "Doubles walk speed",
    Value    = false,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v and 32 or 16
        end
    end,
})

local FlyToggle = P1:Toggle({
    Title    = "Fly",
    Desc     = "Enable fly mode",
    Value    = false,
    Callback = function(v)
        print("Fly:", v)
    end,
})

P1:Section("Buttons")

P1:Button({
    Title    = "Reset Character",
    Desc     = "Kills the humanoid",
    Text     = "Reset",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end,
})

P1:Button({
    Title    = "Notification Test",
    Desc     = "Fire all four alert types",
    Text     = "Fire All",
    Callback = function()
        for i, t in ipairs({ "Info", "Success", "Warning", "Error" }) do
            task.delay(i * 0.5, function()
                Library:Notification({
                    Title    = t,
                    Desc     = "This is a " .. t .. " notification.",
                    Duration = 3,
                    Type     = t,
                })
            end)
        end
    end,
})

-- PAGE 2 — Sliders & Input
local P2 = Window:NewPage({
    Title    = "Controls",
    Desc     = "Sliders & inputs",
    Icon     = "sliders",
    TabImage = "#00BFFF",
})

P2:Section("Sliders")

P2:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 300,
    Rounding = 0,
    Value    = 16,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})

P2:Slider({
    Title    = "Jump Power",
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Value    = 50,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end,
})

Library:AddSizeSlider(P2)

P2:Section("Text Input")

P2:Input({
    Title    = "Search Player",
    Desc     = "Press Enter to confirm",
    Value    = "",
    Callback = function(text)
        print("Input:", text)
    end,
})

-- PAGE 3 — Dropdowns
local P3 = Window:NewPage({
    Title    = "Dropdowns",
    Desc     = "Select options",
    Icon     = "list",
    TabImage = "#9945FF",
})

P3:Section("Single Select")

P3:Dropdown({
    Title    = "Game Mode",
    List     = { "Normal", "Hard", "Extreme", "Custom" },
    Value    = "Normal",
    Callback = function(v) print("Mode:", v) end,
})

P3:Section("Multi Select")

P3:Dropdown({
    Title    = "Active Mods",
    List     = { "NoClip", "ESP", "Aimbot", "AutoFarm", "GodMode" },
    Value    = { "ESP" },
    Callback = function(v)
        print("Mods:", table.concat(v, ", "))
    end,
})

-- PAGE 4 — Keybinds
local P4 = Window:NewPage({
    Title    = "Keybinds",
    Desc     = "Key bindings",
    Icon     = "keyboard",
    TabImage = "#FFD700",
})

P4:Section("Bindings")

P4:Keybind({
    Title    = "Toggle Fly",
    Desc     = "Click to rebind",
    Value    = Enum.KeyCode.F,
    Callback = function()
        FlyToggle.Value = not FlyToggle.Value
    end,
})

P4:Keybind({
    Title    = "Toggle Speed",
    Desc     = "Click to rebind",
    Value    = Enum.KeyCode.G,
    Callback = function()
        SpeedToggle.Value = not SpeedToggle.Value
    end,
})

-- PAGE 5 — Info
local P5 = Window:NewPage({
    Title    = "Info",
    Desc     = "Labels & text",
    Icon     = "info",
    TabImage = "#32CD32",
})

P5:Banner("rbxassetid://125411502674016")

P5:Section("Right Labels")

local PingLabel = P5:RightLabel({
    Title = "Ping",
    Desc  = "Server latency",
    Right = "-- ms",
})

P5:RightLabel({
    Title = "Place ID",
    Desc  = "Current game",
    Right = tostring(game.PlaceId),
})

task.spawn(function()
    while task.wait(2) do
        local ok, ping = pcall(function()
            return math.round(
                game:GetService("Stats").Network
                    .ServerStatsItem["Data Ping"]:GetValue()
            )
        end)
        if ok then PingLabel.Text = tostring(ping) .. " ms" end
    end
end)

P5:Section("Paragraphs")

P5:Paragraph({
    Title = "About VitaLib",
    Desc  = "VitaLib Enhanced v3.0 — keysystem, toggles, sliders, dropdowns, keybinds, inputs, paragraphs, banners, real-time Discord card.",
    Icon  = "info",
})

-- PAGE 6 — Theme
local P6 = Window:NewPage({
    Title    = "Theme",
    Desc     = "Visuals & theme",
    Icon     = "eye",
    TabImage = "#FF6347",
})

P6:Section("Presets")

for _, t in ipairs({
    { label = "Pink (Default)", accent = "#FF007F", stroke = "#4B0026" },
    { label = "Blue",           accent = "#0066FF", stroke = "#002B4B" },
    { label = "Green",          accent = "#00CC66", stroke = "#004B26" },
    { label = "Purple",         accent = "#9945FF", stroke = "#3D0099" },
}) do
    P6:Button({
        Title    = t.label,
        Desc     = "Apply accent colour",
        Text     = "Apply",
        Callback = function()
            Library:SetTheme({ Accent = t.accent, TabImage = t.accent, TabStroke = t.stroke })
            Library:Notification({ Title = "Theme", Desc = t.label .. " applied", Duration = 2, Type = "Success" })
        end,
    })
end

P6:Section("Pill Icon")

local pillIcons = { "star", "zap", "heart", "shield", "settings" }
local pillIdx = 1
P6:Button({
    Title    = "Cycle Pill Icon",
    Desc     = "Changes the toggle button icon",
    Text     = "Cycle",
    Callback = function()
        pillIdx = (pillIdx % #pillIcons) + 1
        Library:SetPillIcon(pillIcons[pillIdx])
    end,
})

P6:Toggle({
    Title    = "Show Executor Name",
    Desc     = "Bottom-right corner label",
    Value    = true,
    Callback = function(v)
        Library:SetExecutorIdentity(v)
    end,
})

-- PAGE 7 — Discord
local P7 = Window:NewPage({
    Title    = "Discord",
    Desc     = "Live server info",
    Icon     = "message-circle",
    TabImage = "#5865F2",
})

P7:Section("Server")

P7:Discord({
    Invite = DISCORD_INVITE,
})

P7:RightLabel({
    Title = "Refresh Rate",
    Desc  = "How often data updates",
    Right = "60 seconds",
})

-- STARTUP
task.delay(0.5, function()
    Library:Notification({
        Title    = "Keyland",
        Desc     = "Loaded successfully. Press RCtrl to toggle.",
        Duration = 4,
        Type     = "Success",
    })
end)
