--[[
    VitaLib Enhanced v3.0 — Example.lua
    
    KeySystem must be called BEFORE Library:Window()
    It yields until the user submits a valid key or the UI is destroyed.
    If validation fails / UI closed → Validated = false → script stops.
--]]

-- ── CONFIGURATION ──────────────────────────────────────────────────────────
local DISCORD_INVITE = "discord.gg/4ymgWqkJe"
-- ───────────────────────────────────────────────────────────────────────────

local Library = loadstring(game:HttpGet'https://raw.githubusercontent.com/ITSMINECRAFTERTIME/VitaLib-XovaLib-Demo-V3-/refs/heads/main/VitaLib.lua')()

-- ══════════════════════════════════════════════════════════════════════════
-- KEY SYSTEM — call before Window, yields until validated
-- ══════════════════════════════════════════════════════════════════════════

-- ── METHOD 1: Keyless ─────────────────────────────────────────────────────
-- No key needed. Shows a brief "No key required. Loading..." card for ~1.2s
-- then auto-closes and returns Validated = true. Key input row is hidden.
--[[
local KeyResult = Library:KeySystem({
    KeysysText    = "Vita Example",
    KeysysSubText = "This script is free to use. Loading...",
    KeysysMode    = "Keyless",

    -- Discord tab still shown if you want (optional)
    Discord          = DISCORD_INVITE,
    DiscordKeysysGet = "true",
    DiscordPfp       = "https://example.com/server-icon.png",
    DiscordBanner    = "https://example.com/server-banner.png",
    DiscordTabShow   = "true",
})

if not KeyResult.Validated then return end
--]]

-- ── METHOD 2: Manual (ACTIVE) ─────────────────────────────────────────────
local KeyResult = Library:KeySystem({
    KeysysText    = "Vita Example Keysystem",
    KeysysSubText = "Enter your key to access the script. Get a key by clicking the button below.",
    KeysysMode    = "Manual",

    -- "Get Key" button copies this URL to clipboard
    GetKey = "https://example.com/your-key-link",

    -- Valid keys — comma separated, spaces around commas are trimmed automatically
    Key = "HelloThisManual, Hey, Hi, Manual",

    -- Discord tab
    Discord          = DISCORD_INVITE,
    DiscordKeysysGet = "true",
    DiscordPfp       = "https://example.com/server-icon.png",
    DiscordBanner    = "https://example.com/server-banner.png",
    DiscordTabShow   = "true",
})

if not KeyResult.Validated then
    return
end

-- ── METHOD 3: Jnkie ────────────────────────────────────────────────────────
-- SDK is loaded ONCE on first "Get Link" click, reused for every Submit.
--
-- "Get Link" flow:
--   1. Loads jnkie.com/sdk/library.lua (once, cached)
--   2. Calls sdk.get_key_link()
--      → returns URL  → setclipboard + shows "✔ Copied!"
--      → returns nil  → cooldown active, shows "Wait 5 min"
--
-- "Submit Key" flow:
--   1. Reuses cached SDK (no re-load)
--   2. Increments attempt counter (max 5, matches official Jnkie example)
--   3. Calls sdk.check_key(entered)
--      → validation.valid = true  → sets getgenv().SCRIPT_KEY, loads JnkieScript
--      → validation.message errors handled:
--           KEY_EXPIRED      → "Key expired — get a new one"
--           HWID_BANNED      → shows error + kicks player after 1.5s
--           SERVICE_MISMATCH → "Key is for a different service"
--           HWID_MISMATCH    → "HWID limit reached"
--           anything else    → shows raw message
--   4. After 5 failed attempts → locked out

--[[
local KeyResult = Library:KeySystem({
    KeysysText    = "Premium Hub",
    KeysysSubText = "Click 'Get Link', complete the steps, then paste your key below.",
    KeysysMode    = "Jnkie",

    -- Jnkie SDK config — matches: Junkie.service / .identifier / .provider
    JnkieService    = "Premium Hub",
    JnkieIdentifier = "12345",
    JnkieProvider   = "Mixed",

    -- Auto-loads this script after successful validation
    -- Remove or leave empty if you load your script manually after KeySystem returns
    JnkieScript = "https://api.jnkie.com/api/v1/luascripts/YOUR_SCRIPT_ID/download",

    -- Discord tab shown on the keysystem screen
    Discord          = DISCORD_INVITE,
    DiscordKeysysGet = "true",                             -- show Copy Invite button
    DiscordPfp       = "https://example.com/icon.png",    -- direct image URL
    DiscordBanner    = "https://example.com/banner.png",  -- direct image URL
    DiscordTabShow   = "true",                             -- "false" hides it
})

if not KeyResult.Validated then
    return  -- HWID_BANNED, too many attempts, or user closed
end
--]]

-- ══════════════════════════════════════════════════════════════════════════
-- MAIN UI — only reached after key is validated
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 1 — Main Controls
-- ─────────────────────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 2 — Sliders & Input
-- ─────────────────────────────────────────────────────────────────────────
local P2 = Window:NewPage({
    Title    = "Controls",
    Desc     = "Sliders & inputs",
    Icon     = "sliders",
    TabImage = "#00BFFF",
})

P2:Section("Sliders")

local WalkSlider = P2:Slider({
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

local JumpSlider = P2:Slider({
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 3 — Dropdowns
-- ─────────────────────────────────────────────────────────────────────────
local P3 = Window:NewPage({
    Title    = "Dropdowns",
    Desc     = "Select options",
    Icon     = "list",
    TabImage = "#9945FF",
})

P3:Section("Single Select")

local ModeDropdown = P3:Dropdown({
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 4 — Keybinds
-- ─────────────────────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 5 — Info
-- ─────────────────────────────────────────────────────────────────────────
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
    Desc  = "VitaLib Enhanced v3.0 — keysystem, toggles, sliders, dropdowns, keybinds, inputs, paragraphs, banners, real-time Discord card. All elements return metatables for programmatic updates.",
    Icon  = "info",
})

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 6 — Theme
-- ─────────────────────────────────────────────────────────────────────────
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

-- ─────────────────────────────────────────────────────────────────────────
-- PAGE 7 — Discord
-- ─────────────────────────────────────────────────────────────────────────
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

P7:Section("Info")

P7:RightLabel({
    Title = "Refresh Rate",
    Desc  = "How often data updates",
    Right = "60 seconds",
})

P7:Paragraph({
    Title = "Auto-Refresh",
    Desc  = "Calls game:HttpGet to discord.com/api/v9/invites directly. Re-fetches every 60 seconds. Falls back to N/A if unreachable.",
    Icon  = "refresh-cw",
})

-- ─────────────────────────────────────────────────────────────────────────
-- STARTUP
-- ─────────────────────────────────────────────────────────────────────────
task.delay(0.5, function()
    Library:Notification({
        Title    = "Loaded",
        Desc     = "VitaLib Enhanced v3.0 — Press RCtrl to toggle.",
        Duration = 4,
        Type     = "Success",
    })
end)
