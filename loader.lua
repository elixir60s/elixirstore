-- ELIXSTORE LOADER PRO + HWID + EXPIRE

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- URL JSON key data di GitHub
local KEY_DATA_URL = "https://raw.githubusercontent.com/elixir60s/elixirstore/main/keys.json"

-- Ambil data key dari GitHub
local keyData
local success, err = pcall(function()
    keyData = HttpService:JSONDecode(game:HttpGet(KEY_DATA_URL))
end)

if not success then
    warn("Gagal fetch key data: "..tostring(err))
    return
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXSTORE_KEY"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,300,0,170)
frame.Position = UDim2.new(0.5,-150,0.5,-85)
frame.BackgroundColor3 = Color3.fromRGB(25,0,55)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ELIXSTORE KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0.8,0,0,30)
box.Position = UDim2.new(0.1,0,0.35,0)
box.PlaceholderText = "Enter Key..."
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.BackgroundColor3 = Color3.fromRGB(40,0,80)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",box)

local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(0.5,0,0,30)
button.Position = UDim2.new(0.25,0,0.65,0)
button.Text = "UNLOCK"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BackgroundColor3 = Color3.fromRGB(120,0,200)
button.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",button)

local status = Instance.new("TextLabel")
status.Parent = frame
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,1,-20)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(255,200,255)

-- ===== CHECK KEY =====
button.MouseButton1Click:Connect(function()
    local inputKey = box.Text
    local hwid = tostring(player.UserId)

    local data = keyData[inputKey]
    if not data then
        status.Text = "Invalid Key"
        return
    end

    -- Lock HWID
    if not data.hwid then
        data.hwid = hwid
        data.start = os.time()
        -- NOTE: untuk permanen, update JSON di GitHub server-side
    end

    if data.hwid ~= hwid then
        status.Text = "HWID Locked"
        return
    end

    -- Cek expire
    if data.expire then
        local now = os.time()
        if (now - data.start) > data.expire then
            status.Text = "Key Expired"
            return
        end
    end

    status.Text = "Key Accepted!"
    task.wait(1)
    gui:Destroy()

    -- LOAD SCRIPT UTAMA
    loadstring(game:HttpGet("https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/script.lua"))()
end)
