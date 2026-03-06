-- ELIXSTORE LOADER OFFLINE PRO (WORKS)

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local HWID = tostring(player.UserId)

-- Raw keys.json
local KEYS_URL = "https://raw.githubusercontent.com/elixir60s/elixirstore/main/keys.json"
local success, keyData = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(KEYS_URL))
end)
if not success then warn("Gagal fetch keys.json") return end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 170)
frame.Position = UDim2.new(.5, -150, .5, -85)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 70)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ELIXSTORE KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(.8,0,0,30)
box.Position = UDim2.new(.1,0,.35,0)
box.PlaceholderText = "Enter Key"
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.BackgroundColor3 = Color3.fromRGB(40,0,80)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", box)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(.5,0,0,30)
button.Position = UDim2.new(.25,0,.7,0)
button.Text = "UNLOCK"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BackgroundColor3 = Color3.fromRGB(120,0,200)
button.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", button)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,1,-20)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Font = Enum.Font.Gotham
status.TextSize = 12

-- Simpan start time per HWID di memory
local keyUsed = {}

button.MouseButton1Click:Connect(function()
    local key = box.Text
    local data = keyData[key]

    if not data then
        status.Text = "Invalid Key"
        return
    end

    local now = os.time()
    if not keyUsed[HWID] then
        keyUsed[HWID] = {key = key, start = now}
    end

    -- Lifetime
    if data.duration == 0 then
        status.Text = "Key Accepted!"
        wait(1)
        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/script.lua"))()
        return
    end

    -- Cek expire
    if now - keyUsed[HWID].start > data.duration then
        status.Text = "Key Expired"
        return
    end

    status.Text = "Key Accepted!"
    wait(1)
    gui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/script.lua"))()
end)

