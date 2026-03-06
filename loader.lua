-- ELIXSTORE LOADER + KEY SYSTEM

local player = game.Players.LocalPlayer

-- LIST KEY
local Keys = {
    ["ELIX-7DAY"] = true,
    ["ELIX-14DAY"] = true,
    ["ELIX-30DAY"] = true,
    ["ELIX-LIFETIME"] = true
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXSTORE_KEY"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,300,0,160)
frame.Position = UDim2.new(0.5,-150,0.5,-80)
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
box.Position = UDim2.new(0.1,0,0.4,0)
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
button.Position = UDim2.new(0.25,0,0.7,0)
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

-- BUTTON
button.MouseButton1Click:Connect(function()

    local key = box.Text

    if Keys[key] then
        
        status.Text = "Key Accepted!"

        gui:Destroy()

        -- LOAD SCRIPT UTAMA
        loadstring(game:HttpGet("https://raw.githubusercontent.com/elixir60s/elixirstore/refs/heads/main/script.lua"))()

    else

        status.Text = "Invalid Key"

    end

end)
