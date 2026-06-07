# VitaLib Enhanced — Documentation
**Demo V3 Before Rework**

---

## Table of Contents
1. [Installation](#installation)
2. [Library:Window](#librarywindow)
3. [Window:NewPage](#windownewpage)
4. [Page Elements](#page-elements)
   - [Page:Section](#pagesection)
   - [Page:Paragraph](#pageparagraph)
   - [Page:RightLabel](#pagerightlabel)
   - [Page:Button](#pagebutton)
   - [Page:Toggle](#pagetoggle)
   - [Page:Slider](#pageslider)
   - [Page:Input](#pageinput)
   - [Page:Dropdown](#pagedropdown)
   - [Page:Keybind](#pagekeybind)
   - [Page:Banner](#pagebanner)
   - [Page:Discord](#pagediscord)
5. [Library Methods](#library-methods)
   - [Library:Notification](#librarynotification)
   - [Library:SetTimeValue](#librarysetimevalue)
   - [Library:AddSizeSlider](#libraryaddsizeslider)
   - [Library:SetTheme](#librarysettheme)
   - [Library:SetPillIcon](#librarysetpillicon)
   - [Library:SetExecutorIdentity](#librarysetexecutoridentity)
   - [Library:Destroy](#librarydestroy)
6. [Library:KeySystem](#librarykeysystem)
   - [Mode: Keyless](#mode-keyless)
   - [Mode: Manual](#mode-manual)
   - [Mode: Jnkie](#mode-jnkie)
7. [Theme Reference](#theme-reference)
8. [Icon Reference](#icon-reference)
9. [Changelog](#changelog)

---

## Installation

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/JScripter-Lua/XovaModedLib/refs/heads/main/VitaLib_Enhanced.lua"
))()
```

> **Note:** `Library:KeySystem()` must be called **before** `Library:Window()` if you use one. It yields the thread until validated.

---

## Library:Window

Creates the main UI window. Returns a `Window` object.

```lua
local Window = Library:Window({
    Title             = "My UI",
    SubTitle          = "v1.0",
    Size              = UDim2.new(0, 550, 0, 400),
    ToggleKey         = Enum.KeyCode.RightControl,
    BbIcon            = "settings",
    AutoScale         = true,
    Scale             = 1.45,
    ExecIdentifyShown = true,
    CornerGlow        = "#FF007F",
    Theme             = { ... },
})
```

### Args

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | `"Vita UI"` | Main title shown in the header |
| `SubTitle` | string | `"Made by vita6it"` | Subtitle shown below the title |
| `Size` | UDim2 | auto | Custom window size |
| `ToggleKey` | KeyCode | `LeftControl` | Keyboard key that toggles the window |
| `BbIcon` | string / number | settings icon | Icon shown on the toggle pill button |
| `AutoScale` | bool | `true` | Auto-scales based on screen resolution |
| `Scale` | number | `1.45` | Base scale factor used by AutoScale |
| `ExecIdentifyShown` | bool | `true` | Shows executor name in bottom-right corner |
| `CornerGlow` | string / Color3 | `nil` | Adds a glow from all 4 corners. Any hex string or Color3. Set `nil` to disable |
| `Theme` | table | see [Theme Reference](#theme-reference) | Full theme table |

> **Shorthand theme args** (`BG`, `Tab`, `TabImage`, `TabStroke`) are also accepted but mutate the `Theme` table. Use one or the other — never both at once.

### Returns
`Window` — use `Window:NewPage()` to add pages.

---

## Window:NewPage

Adds a new tab and page to the window. Returns a `Page` object.

```lua
local Page = Window:NewPage({
    Title    = "Main",
    Desc     = "Core controls",
    Icon     = "home",
    TabImage = "#FF007F",
})
```

### Args

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | `"Page"` | Tab title |
| `Desc` | string | `"Description"` | Tab subtitle (shown below title on the tab) |
| `Icon` | string / number | default icon | Tab icon — see [Icon Reference](#icon-reference) |
| `TabImage` | string / Color3 | theme accent | Banner colour for this specific tab. Overrides `Theme.TabImage` for this tab only |

### Returns
`Page` — use `Page:*` methods to add elements.

---

## Page Elements

---

### Page:Section

Adds a section header label. No return value.

```lua
Page:Section("Section Title")
```

| Arg | Type | Description |
|-----|------|-------------|
| text | string | Section label text |

---

### Page:Paragraph

Displays a read-only row with a title, description, and icon. Row height **auto-expands** based on description length — no manual `\n` needed.

```lua
local Para = Page:Paragraph({
    Title = "Info",
    Desc  = "Some description text here.",
    Icon  = "info",   -- also accepts: Image = "info"
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Desc` | string | — | Row description (wraps automatically) |
| `Icon` / `Image` | string / number | — | Row icon — see [Icon Reference](#icon-reference) |

**Returns** — metatable with writable fields:

| Field | Type | Effect on write |
|-------|------|-----------------|
| `Title` | string | Updates title text live |
| `Desc` | string | Updates description text live |
| `Icon` | ImageLabel | The icon instance (read) |
| `Instance` | Frame | The row frame (read) |

```lua
Para.Desc = "Updated description!"
```

---

### Page:RightLabel

Displays a row with a value aligned to the right side. Useful for live stats.

```lua
local Lbl = Page:RightLabel({
    Title = "Ping",
    Desc  = "Server latency",
    Right = "-- ms",
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Desc` | string | — | Row description |
| `Right` | string | `"None"` | Text shown on the right side |

**Returns** — the right-side `TextLabel` directly. Update via `.Text`:

```lua
Lbl.Text = "42 ms"
```

---

### Page:Button

Displays a row with a clickable button on the right.

```lua
Page:Button({
    Title    = "Reset",
    Desc     = "Resets the character",
    Text     = "Click",
    Callback = function()
        -- fires on click
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Desc` | string | — | Row description |
| `Text` | string | `"Click"` | Button label text |
| `Callback` | function | — | Called when button is clicked. No arguments passed |

**Returns** — the inner `TextButton` (Click).

---

### Page:Toggle

Displays a row with an on/off toggle checkbox.

```lua
local T = Page:Toggle({
    Title    = "Speed Boost",
    Desc     = "Doubles walk speed",
    Value    = false,
    Callback = function(value)
        -- value = true | false
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Desc` | string | — | Row description |
| `Value` | bool | `false` | Initial state |
| `Callback` | function | — | Called with `(bool)` on every state change |

**Returns** — metatable with writable fields:

| Field | Type | Effect on write |
|-------|------|-----------------|
| `Value` | bool | Flips the toggle and fires `Callback` |
| `Title` | string | Updates title text live |
| `Desc` | string | Updates description text live |

```lua
T.Value = true   -- turns toggle on, fires Callback(true)
```

---

### Page:Slider

Displays a draggable slider. **Fixed for both PC mouse drag and mobile touch drag in v3.0.**

```lua
local S = Page:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 300,
    Rounding = 0,
    Value    = 16,
    Callback = function(value)
        -- value = number between Min and Max
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Min` | number | — | Minimum value |
| `Max` | number | — | Maximum value |
| `Rounding` | number | `0` | Decimal places to round to. `0` = integer, `2` = two decimals |
| `Value` | number | `Min` | Initial value |
| `Callback` | function | — | Called with `(number)` on every drag update |

**Returns** — metatable with writable fields:

| Field | Type | Effect on write |
|-------|------|-----------------|
| `Value` | number | Moves the slider bar and fires `Callback` |
| `Title` | string | Updates title text live |

```lua
S.Value = 100   -- moves slider to 100, fires Callback(100)
```

---

### Page:Input

Displays a text input box with a copy button.

```lua
local Box = Page:Input({
    Title    = "Search",
    Desc     = "Press Enter to confirm",
    Value    = "",
    Callback = function(text)
        -- fires on FocusLost when Enter is pressed
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Placeholder prefix shown in the box |
| `Desc` | string | — | Appended to placeholder after an em-dash |
| `Value` | string | `""` | Initial text |
| `Callback` | function | — | Called with `(string)` when Enter is pressed |

> The accent-colored button on the right copies the current text to clipboard via `setclipboard`.

**Returns** — the `TextBox` directly.

```lua
print(Box.Text)   -- read current value
Box.Text = "hi"   -- set value (does NOT fire Callback)
```

---

### Page:Dropdown

Displays a searchable dropdown. Supports both single-select and multi-select.

```lua
-- Single select (string Value)
local D = Page:Dropdown({
    Title    = "Mode",
    List     = { "Normal", "Hard", "Extreme" },
    Value    = "Normal",
    Callback = function(selected)
        -- selected = string
    end,
})

-- Multi select (table Value)
local D = Page:Dropdown({
    Title    = "Mods",
    List     = { "ESP", "Aimbot", "NoClip" },
    Value    = { "ESP" },   -- pre-selected
    Callback = function(selected)
        -- selected = { string, ... }
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `List` | `{string}` | — | Array of option strings |
| `Value` | string OR `{string}` | — | **string** = single-select mode. **table** = multi-select mode |
| `Callback` | function | — | Single: called with `(string)`. Multi: called with `({string})` |

**Returns** — `Setting` table with methods:

| Method | Description |
|--------|-------------|
| `Setting:AddList(name)` | Adds a new item to the dropdown list at runtime |
| `Setting:Clear(name?)` | Removes one item by name, or clears all items if `name` is nil |

---

### Page:Keybind

Displays a rebindable key binding box.

```lua
local K = Page:Keybind({
    Title    = "Toggle Fly",
    Desc     = "Click to rebind",
    Value    = Enum.KeyCode.F,
    Callback = function(key)
        -- fires every time the bound key is pressed in-game
        -- key = Enum.KeyCode
    end,
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | — | Row title |
| `Desc` | string | — | Row description |
| `Value` | KeyCode | `Unknown` | Initial key binding |
| `Callback` | function | — | Called with `(KeyCode)` every time the key is pressed |

> Click the box in-game, then press any keyboard key to rebind it interactively.

**Returns** — metatable with writable fields:

| Field | Type | Effect on write |
|-------|------|-----------------|
| `Value` | KeyCode | Rebinds programmatically, updates label |
| `Title` | string | Updates title text live |
| `Desc` | string | Updates description text live |

```lua
K.Value = Enum.KeyCode.G   -- rebinds to G
```

---

### Page:Banner

Displays a full-width image banner on the page.

```lua
local Banner = Page:Banner("rbxassetid://125411502674016")
-- or
local Banner = Page:Banner(125411502674016)
```

| Arg | Type | Description |
|-----|------|-------------|
| asset | string / number | Asset ID in any format |

**Returns** — the `ImageLabel`.

---

### Page:Discord

Displays a live Discord server info card. Fetches data from Discord's invite API via `game:HttpGet` and auto-refreshes every 60 seconds.

```lua
Page:Discord({
    Invite = "discord.gg/yourcode",
})
```

| Arg | Type | Description |
|-----|------|-------------|
| `Invite` | string | Invite in any format: `"https://discord.gg/code"`, `"discord.gg/code"`, or just `"code"` |

**Displays:**
- Server banner image (if set on the server)
- Circular server icon
- Server name
- Total member count (`approximate_member_count`)
- Online member count (`approximate_presence_count`)
- Copy Invite Link button (uses `setclipboard`)

**Returns** — the card `Frame`.

> If the fetch fails or `game:HttpGet` is unavailable, the card falls back to showing the invite code and `N/A` for member counts.

---

## Library Methods

These are called directly on `Library`, not on `Window` or `Page`.

---

### Library:Notification

Shows a toast notification in the bottom-right corner with an auto-dismissing progress bar.

```lua
Library:Notification({
    Title    = "Success!",
    Desc     = "Operation completed.",
    Duration = 3,
    Type     = "Success",
})
```

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | `"Notification"` | Bold notification title |
| `Desc` | string | `""` | Description body |
| `Duration` | number | `3` | Seconds before auto-dismiss |
| `Type` | string | `"Info"` | Accent color style. One of: `"Info"` `"Success"` `"Warning"` `"Error"` |

| Type | Color |
|------|-------|
| `Info` | Cornflower blue |
| `Success` | Green |
| `Warning` | Orange |
| `Error` | Red |

**Returns** — the notification `Frame`.

---

### Library:SetTimeValue

Overrides the UI Uptime display text in the header.

```lua
Library:SetTimeValue("Custom Text")
```

> By default, the header shows **UI Uptime** counting up from `00:00:00` automatically (max 999 hours). Call this only if you want to override it manually.

---

### Library:AddSizeSlider

Adds a pre-built UI scale slider to a page. Lets the user resize the entire UI at runtime.

```lua
Library:AddSizeSlider(Page)
```

| Arg | Type | Description |
|-----|------|-------------|
| `Page` | Page | The page to add the slider to |

---

### Library:SetTheme

Updates theme colors at runtime. Only supply keys you want to change — all others stay as-is.

```lua
Library:SetTheme({
    Accent    = "#0066FF",
    TabImage  = "#0066FF",
    TabStroke = "#002B4B",
})
```

Accepts any key from the [Theme Reference](#theme-reference) table. Values can be hex strings or `Color3`.

---

### Library:SetPillIcon

Changes the icon shown on the toggle pill button.

```lua
Library:SetPillIcon("star")
```

| Arg | Type | Description |
|-----|------|-------------|
| icon | string / number | Any icon format — see [Icon Reference](#icon-reference) |

---

### Library:SetExecutorIdentity

Shows or hides the executor name label in the bottom-right corner.

```lua
Library:SetExecutorIdentity(true)   -- show
Library:SetExecutorIdentity(false)  -- hide
```

---

### Library:Destroy

Completely removes the UI, toggle pill, and notification GUI from the game.

```lua
Library:Destroy()
```

---

## Library:KeySystem

Displays a full-screen key validation UI before the main window. **Yields** the calling thread until the user submits a valid key or closes the UI.

> Must be called **before** `Library:Window()`.

```lua
local Result = Library:KeySystem({ ... })

if not Result.Validated then
    return   -- stop script if key rejected / UI closed
end

local Window = Library:Window({ ... })
```

**Returns** — `{ Validated = bool, Key = string | nil }`

### Shared Args (all modes)

| Arg | Type | Default | Description |
|-----|------|---------|-------------|
| `KeysysText` | string | `"Key System"` | Title shown on the key UI card |
| `KeysysSubText` | string | `"Enter your key to continue."` | Subtitle / instruction text |
| `KeysysMode` | string | `"Manual"` | Mode: `"Keyless"` \| `"Manual"` \| `"Jnkie"` |
| `Discord` | string | `""` | Discord invite for the info tab. Same formats as `Page:Discord` |
| `DiscordKeysysGet` | string | `"false"` | `"true"` to show a **Copy Discord Invite** button |
| `DiscordPfp` | string | `""` | Direct image URL for the server icon shown in the card |
| `DiscordBanner` | string | `""` | Direct image URL for the banner behind the card header |
| `DiscordTabShow` | string | `"true"` | `"false"` to hide the Discord section entirely |

---

### Mode: Keyless

No key required. Shows a brief success message for ~1.2 seconds then auto-closes. Key input and buttons are hidden.

```lua
local Result = Library:KeySystem({
    KeysysText    = "Welcome",
    KeysysSubText = "This script is free. Loading...",
    KeysysMode    = "Keyless",

    Discord          = "discord.gg/yourcode",
    DiscordKeysysGet = "true",
    DiscordPfp       = "https://example.com/icon.png",
    DiscordBanner    = "https://example.com/banner.png",
    DiscordTabShow   = "true",
})

if not Result.Validated then return end
```

Always returns `{ Validated = true, Key = "keyless" }`.

---

### Mode: Manual

User enters a key from a comma-separated list you define. Includes a **Get Key** button that copies a URL to clipboard.

```lua
local Result = Library:KeySystem({
    KeysysText    = "My Script Key",
    KeysysSubText = "Get your key at the link below, then paste it here.",
    KeysysMode    = "Manual",

    GetKey = "https://example.com/get-key",
    Key    = "key1, key2, key3",

    Discord          = "discord.gg/yourcode",
    DiscordKeysysGet = "true",
    DiscordPfp       = "https://example.com/icon.png",
    DiscordBanner    = "https://example.com/banner.png",
    DiscordTabShow   = "true",
})

if not Result.Validated then return end
```

| Arg | Type | Description |
|-----|------|-------------|
| `GetKey` | string | URL that the **Get Key** button copies to clipboard |
| `Key` | string | Comma-separated list of valid keys. Spaces around commas are trimmed automatically |

**UI behavior:**
- User types or pastes a key and clicks **Submit Key** or presses Enter
- If the key matches any entry in `Key` → success, UI closes
- If not → red error status, user can try again

---

### Mode: Jnkie

Integrates with the [Jnkie](https://jnkie.com) external key system provider. Keys and validation are managed entirely by Jnkie — you do not define keys yourself.

```lua
local Result = Library:KeySystem({
    KeysysText    = "Premium Hub",
    KeysysSubText = "Click 'Get Link', complete the steps, then paste your key.",
    KeysysMode    = "Jnkie",

    JnkieService    = "Premium Hub",
    JnkieIdentifier = "12345",
    JnkieProvider   = "Mixed",
    JnkieScript     = "https://api.jnkie.com/api/v1/luascripts/YOUR_ID/download",

    Discord          = "discord.gg/yourcode",
    DiscordKeysysGet = "true",
    DiscordPfp       = "https://example.com/icon.png",
    DiscordBanner    = "https://example.com/banner.png",
    DiscordTabShow   = "true",
})

if not Result.Validated then return end
```

| Arg | Type | Description |
|-----|------|-------------|
| `JnkieService` | string | Your Jnkie service name |
| `JnkieIdentifier` | string | Your Jnkie identifier (numeric string) |
| `JnkieProvider` | string | `"Mixed"` \| `"Linkvertise"` \| etc. |
| `JnkieScript` | string | Optional. Full URL to load via `loadstring` after successful validation |

**UI behavior:**
1. **Get Link** — loads the Jnkie SDK (once, cached), calls `sdk.get_key_link()`
   - Returns URL → copies to clipboard, shows `"✔ Copied!"`
   - Returns nil → cooldown active, shows `"Wait 5 min"`
2. **Submit Key** — calls `sdk.check_key(entered)`
   - `validation.valid = true` → sets `getgenv().SCRIPT_KEY`, optionally loads `JnkieScript`, closes UI
   - Failure → shows error from `validation.message`:

| `validation.message` | UI message |
|----------------------|------------|
| `KEY_EXPIRED` | Key expired — get a new one |
| `HWID_BANNED` | Hardware banned → kicks the player after 1.5s |
| `SERVICE_MISMATCH` | Key is for a different service |
| `HWID_MISMATCH` | HWID limit reached |
| anything else | Shows the raw message |

- Max **5 attempts** — locked out after 5 wrong keys (matches official Jnkie example)
- Attempt counter shown live in the UI: `Attempts: 2 / 5`

---

## Theme Reference

Full default theme values:

| Key | Default | Description |
|-----|---------|-------------|
| `Accent` | `#FF007F` | Primary accent color (buttons, icons, active elements) |
| `Background` | `#0D0D0D` | Main window background |
| `Row` | `#0F0F0F` | Element row background |
| `RowAlt` | `#0A0A0A` | Alternate / toggle-off row background |
| `Stroke` | `#191919` | Border / stroke color |
| `Text` | `#FFFFFF` | Primary text color |
| `SubText` | `#A3A3A3` | Secondary / description text color |
| `TabBg` | `#0A0A0A` | Tab button background |
| `TabStroke` | `#4B0026` | Tab button border color |
| `TabImage` | `#FF007F` | Tab banner image tint (default = Accent) |
| `DropBg` | `#121212` | Dropdown list background |
| `DropStroke` | `#1E1E1E` | Dropdown list border |
| `PillBg` | `#0B0B0B` | Toggle pill button background |

All values accept **hex strings** (`"#FF007F"`) or **Color3** values.

```lua
-- Full theme example
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
}
```

---

## Icon Reference

Icons are sourced from the **Lucide** icon set (via Roblox asset IDs). Three formats are accepted identically everywhere an icon is used (`BbIcon`, `Icon`, `SetPillIcon`):

| Format | Example | Notes |
|--------|---------|-------|
| Short name | `"star"` | Auto-prefixes `lucide-` |
| Full lucide name | `"lucide-star"` | Direct lookup |
| Raw asset ID (number) | `10734966248` | Uses as-is |
| Full rbxassetid string | `"rbxassetid://10734966248"` | Uses as-is |

**Common icons:**

| Name | Name | Name | Name |
|------|------|------|------|
| `home` | `settings` | `info` | `star` |
| `eye` | `bell` | `keyboard` | `list` |
| `sliders` | `heart` | `zap` | `shield` |
| `user` | `message-circle` | `refresh-cw` | `wifi` |
| `server` | `smartphone` | `clock` | `align-left` |
| `help-circle` | `shield-check` | `file-text` | `search` |

> For a full list, search [lucide.dev](https://lucide.dev) — any icon name there should work.

---

## Changelog

### v3.0
- **`Library:KeySystem`** — full keysystem UI with Keyless, Manual, and Jnkie modes
- **`Page:Discord`** — live Discord server info card (name, icon, banner, members, online, copy button). Auto-refreshes every 60 seconds via `game:HttpGet`
- **`Library:Create` fix** — changed `for k, v in Props do` (Luau) to `for k, v in pairs(Props) do` (Lua 5.1 executor compatible). Wrapped each property assignment in `pcall` to prevent crashes on unsupported properties
- **`ZIndex = 0` fix** — shadow and corner glow frames now use `ZIndex = 1` (Roblox minimum)
- **`delay()` fix** — replaced legacy `delay(0, ...)` in Dropdown with `task.delay(0, ...)`
- **`Page:Slider` return** — now returns a metatable so `.Value = x` works programmatically
- **Tab centering** — tabs are now centered in the tab bar (`HorizontalAlignment.Center`)
- **Paragraph auto-expand** — `Page:Paragraph` rows now use `AutomaticSize.Y` to grow with content
- **Slider drag fix** — added `ClickBtn.InputChanged` and `UserInputService.InputEnded` global fallback so sliders work on both PC and mobile
- **UI Uptime** — header now counts up from `00:00:00` via `RunService.Heartbeat`. Replaces static "Expires at" display
- **Corner Glow** — `CornerGlow = "#color"` in `Library:Window` adds glow frames to all 4 corners
- **Discord real-time fetch** — uses `game:HttpGet` directly to `discord.com/api/v9/invites`
