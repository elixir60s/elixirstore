-- ELIXSTORE LOADER FIX LIFETIME

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local KEY_URL = "https://raw.githubusercontent.com/elixir60s/elixirstore/main/keys.json"

local keyData = HttpService:JSONDecode(game:HttpGet(KEY_URL))

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,300,0,160)
frame.Position = UDim2.new(.5,-150,.5,-80)
frame.BackgroundColor3 = Color3.fromRGB(30,0,70)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ELIXSTORE KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Text = "ELIXSTORE KEY SYSTEM"

local box = Instance.new("TextBox",frame)
box.Size = UDim2.new(.8,0,0,30)
box.Position = UDim2.new(.1,0,.4,0)
box.PlaceholderText = "Enter Key"
box.Text = ""

local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.new(.5,0,0,30)
btn.Position = UDim2.new(.25,0,.7,0)
btn.Text = "UNLOCK"

local status = Instance.new("TextLabel",frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,1,-20)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
 local key = box.Text
 local duration = keyData[key]

 if duration then
    -- Jika duration = 0 → lifetime
    if duration > 0 then
        local now = os.time()
        -- disini bisa tambahkan logika start_time jika mau expire per user
        -- untuk sementara kita anggap user baru mulai → expire masih berlaku
    end
    status.Text = "Key Accepted!"
    wait(1)
    gui:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/script.lua"))()
 else
    status.Text = "Invalid Key"
 end
end)
