local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- DEVICE HWID
local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- ambil key database
local keys = HttpService:JSONDecode(game:HttpGet(
"https://raw.githubusercontent.com/elixir60s/elixirstore/main/keys.json"
))

-- GUI
local gui = Instance.new("ScreenGui",player.PlayerGui)

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,300,0,150)
frame.Position = UDim2.new(.5,-150,.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(40,0,80)
frame.Active=true
frame.Draggable=true
Instance.new("UICorner",frame)

local box = Instance.new("TextBox",frame)
box.Size = UDim2.new(.8,0,0,30)
box.Position = UDim2.new(.1,0,.3,0)
box.PlaceholderText="Enter Key"

local button = Instance.new("TextButton",frame)
button.Size = UDim2.new(.5,0,0,30)
button.Position = UDim2.new(.25,0,.6,0)
button.Text="LOGIN"

local status = Instance.new("TextLabel",frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,1,-20)
status.BackgroundTransparency=1

button.MouseButton1Click:Connect(function()

    local key = box.Text
    local data = keys[key]

    if not data then
        status.Text="INVALID KEY"
        return
    end

    -- kalau belum dipakai
    if data.hwid == nil then
        data.hwid = HWID
    end

    -- kalau device beda
    if data.hwid ~= HWID then
        status.Text="KEY USED ON OTHER DEVICE"
        return
    end

    status.Text="ACCESS GRANTED"
    gui:Destroy()

    loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/elixir60s/elixirstore/main/script.lua"
    ))()

end)
