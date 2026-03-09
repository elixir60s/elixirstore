-- ELIXIRSTORE AUTO MARSHMALLOW FINAL (FULL COMPLETE)

local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")

repeat task.wait() until player.Character
local playerGui = player:WaitForChild("PlayerGui")

local running = false
local autoSellEnabled = false

local buyAmount = 1
local buyRemote = game:GetService("ReplicatedStorage").RemoteEvents.StorePurchase

local npcPos = CFrame.new(510.762817,3.58721066,600.791504)
local tierPos = CFrame.new(1110.18726,4.28433371,117.139168)

-- ANTI AFK

player.Idled:Connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

-- FUNCTIONS

local function holdE(t)

vim:SendKeyEvent(true,"E",false,game)
task.wait(t)
vim:SendKeyEvent(false,"E",false,game)

end

local function equip(name)

local char = player.Character or player.CharacterAdded:Wait()
local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)

if tool then

char.Humanoid:EquipTool(tool)
task.wait(.3)

return true

end

end

local function countItem(name)

local total = 0

for _,v in pairs(player.Backpack:GetChildren()) do

if v.Name == name then

total += 1

end

end

for _,v in pairs(player.Character:GetChildren()) do

if v:IsA("Tool") and v.Name == name then

total += 1

end

end

return total

end

-- VEHICLE TELEPORT (ANTI ROLLBACK)

local function vehicleTeleport(cf)

local char = player.Character
if not char then return end

local humanoid = char:FindFirstChild("Humanoid")
if not humanoid then return end

local seat = humanoid.SeatPart

if not seat then

statusLabel.Text = "⚠ Sit on vehicle"

return

end

local vehicle = seat:FindFirstAncestorOfClass("Model")

if not vehicle then return end

if not vehicle.PrimaryPart then

vehicle.PrimaryPart = seat

end

statusLabel.Text = "Sync vehicle..."

-- gerak sedikit supaya server update posisi

seat.Throttle = 1
task.wait(0.45)
seat.Throttle = 0

task.wait(0.3)

statusLabel.Text = "Teleporting..."

vehicle:SetPrimaryPartCFrame(cf * CFrame.new(0,6,15))

task.wait(0.7)

-- dorong lagi supaya server sinkron

seat.Throttle = 1
task.wait(0.8)
seat.Throttle = 0

end

-- TELEPORT NPC

local function teleportNPC()

statusLabel.Text = "🏍 Teleport NPC..."

vehicleTeleport(npcPos)

statusLabel.Text = "✔ Arrived NPC"

end

-- TELEPORT TIER

local function teleportTier()

statusLabel.Text = "🚗 Teleport Tier..."

vehicleTeleport(tierPos)

statusLabel.Text = "✔ Arrived Tier"

end

-- AUTO BUY

local function autoBuy()

statusLabel.Text = "Buying "..buyAmount

for i = 1, buyAmount do

buyRemote:FireServer("Water")
task.wait(.35)

buyRemote:FireServer("Sugar Block Bag")
task.wait(.35)

buyRemote:FireServer("Gelatin")
task.wait(.35)

buyRemote:FireServer("Empty Bag")
task.wait(.45)

end

statusLabel.Text = "Bought "..buyAmount

end

-- AUTO SELL

local function autoSell()

local bags = {

"Small Marshmallow Bag",
"Medium Marshmallow Bag",
"Large Marshmallow Bag"

}

for _,bag in pairs(bags) do

while countItem(bag) > 0 and autoSellEnabled do

if equip(bag) then

statusLabel.Text = "💰 Selling "..bag

holdE(.7)

task.wait(1)

else

break

end

end

end

statusLabel.Text = "Sell Finished"

end

-- GUI

local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIRSTORE"
gui.Parent = playerGui

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,310,0,360)
frame.Position = UDim2.new(.5,0,.5,0)
frame.AnchorPoint = Vector2.new(.5,.5)

frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(170,0,255)
stroke.Thickness = 2

-- TITLE

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,26)
title.BackgroundTransparency = 1
title.Text = "ELIXIRSTORE"
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(230,200,255)

-- CLOSE

local close = Instance.new("TextButton",frame)
close.Position = UDim2.new(1,-22,0,2)
close.Size = UDim2.new(0,20,0,20)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 11

Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
running=false
gui:Destroy()
end)

-- TAB

local tabFrame = Instance.new("Frame",frame)
tabFrame.Position = UDim2.new(0,0,0,26)
tabFrame.Size = UDim2.new(1,0,0,24)
tabFrame.BackgroundTransparency = 1

local function createTab(name,x)

local btn = Instance.new("TextButton",tabFrame)
btn.Size = UDim2.new(0,90,0,20)
btn.Position = UDim2.new(0,x,0,2)

btn.Text = name
btn.Font = Enum.Font.GothamBold
btn.TextSize = 11
btn.TextColor3 = Color3.fromRGB(220,220,220)

btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",btn)

return btn

end

local farmTab = createTab("FARM",20)
local statusTab = createTab("STATUS",120)

-- CONTAINERS

local farmContainer = Instance.new("Frame",frame)
farmContainer.Position = UDim2.new(0,10,0,55)
farmContainer.Size = UDim2.new(1,-20,1,-65)
farmContainer.BackgroundTransparency = 1

local statusContainer = Instance.new("Frame",frame)
statusContainer.Position = farmContainer.Position
statusContainer.Size = farmContainer.Size
statusContainer.BackgroundTransparency = 1
statusContainer.Visible = false

local farmLayout = Instance.new("UIListLayout",farmContainer)
farmLayout.Padding = UDim.new(0,6)

local statusLayout = Instance.new("UIListLayout",statusContainer)
statusLayout.Padding = UDim.new(0,6)

farmTab.MouseButton1Click:Connect(function()
farmContainer.Visible=true
statusContainer.Visible=false
end)

statusTab.MouseButton1Click:Connect(function()
farmContainer.Visible=false
statusContainer.Visible=true
end)

-- STATUS LABEL

statusLabel = Instance.new("TextLabel",farmContainer)
statusLabel.Size = UDim2.new(1,0,0,18)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: STOPPED"

statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(220,220,220)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- PROGRESS ROW

local function createRow(text)

local row = Instance.new("Frame",farmContainer)
row.Size = UDim2.new(1,0,0,18)
row.BackgroundTransparency = 1

local label = Instance.new("TextLabel",row)
label.Size = UDim2.new(0.45,0,1,0)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.GothamMedium
label.TextSize = 11
label.TextColor3 = Color3.fromRGB(210,210,210)
label.TextXAlignment = Enum.TextXAlignment.Left

local bg = Instance.new("Frame",row)
bg.Position = UDim2.new(0.52,0,0.5,-3)
bg.Size = UDim2.new(0.46,0,0,6)
bg.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner",bg)

local bar = Instance.new("Frame",bg)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(180,0,255)
Instance.new("UICorner",bar)

return label,bar

end

waterLabel,waterBar = createRow("💧 Water: 0")
sugarLabel,sugarBar = createRow("🍬 Sugar: 0")
gelatinLabel,gelatinBar = createRow("🍮 Gelatin: 0")
bagLabel,bagBar = createRow("👜 Bag: 0")

-- STATUS TAB CONTENT

local function createStatus(text)

local label = Instance.new("TextLabel",statusContainer)
label.Size = UDim2.new(1,0,0,18)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 12
label.TextColor3 = Color3.new(1,1,1)
label.TextXAlignment = Enum.TextXAlignment.Left

return label

end

local smallLabel = createStatus("Small Marshmallow: 0")
local mediumLabel = createStatus("Medium Marshmallow: 0")
local largeLabel = createStatus("Large Marshmallow: 0")
local totalLabel = createStatus("Total: 0")

-- BUY SLIDER

local buyLabel = Instance.new("TextLabel",farmContainer)
buyLabel.Size = UDim2.new(1,0,0,18)
buyLabel.BackgroundTransparency = 1
buyLabel.Text = "BUY AMOUNT : 1"
buyLabel.Font = Enum.Font.Gotham
buyLabel.TextSize = 11
buyLabel.TextColor3 = Color3.fromRGB(210,210,210)

local slider = Instance.new("Frame",farmContainer)
slider.Size = UDim2.new(1,0,0,6)
slider.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner",slider)

local knob = Instance.new("Frame",slider)
knob.Size = UDim2.new(0,12,0,12)
knob.Position = UDim2.new(0,-6,0.5,-6)
knob.BackgroundColor3 = Color3.fromRGB(180,0,255)
Instance.new("UICorner",knob)

local dragging = false

local function updateSlider(x)

local pos = math.clamp((x-slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)

knob.Position = UDim2.new(pos,-6,0.5,-6)

buyAmount = math.floor(1 + pos * 24)

buyLabel.Text = "BUY AMOUNT : "..buyAmount

end

slider.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
updateSlider(input.Position.X)
end
end)

UIS.InputChanged:Connect(function(input)
if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
updateSlider(input.Position.X)
end
end)

UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = false
end
end)

-- PROGRESS FUNCTION

local function fill(bar,time)

bar.Size = UDim2.new(0,0,1,0)

bar:TweenSize(
UDim2.new(1,0,1,0),
Enum.EasingDirection.InOut,
Enum.EasingStyle.Linear,
time,
true
)

task.delay(time,function()
bar.Size = UDim2.new(0,0,1,0)
end)

end

-- BUTTONS

local toggleBtn = Instance.new("TextButton",farmContainer)
toggleBtn.Size = UDim2.new(1,0,0,22)
toggleBtn.Text = "AUTO FARM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
Instance.new("UICorner",toggleBtn)

local sellBtn = Instance.new("TextButton",farmContainer)
sellBtn.Size = UDim2.new(1,0,0,22)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
sellBtn.TextColor3 = Color3.fromRGB(255,255,255)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 12
Instance.new("UICorner",sellBtn)

local tpBtn = Instance.new("TextButton",farmContainer)
tpBtn.Size = UDim2.new(1,0,0,22)
tpBtn.Text = "TELEPORT NPC"
tpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",tpBtn)

local tierBtn = Instance.new("TextButton",farmContainer)
tierBtn.Size = UDim2.new(1,0,0,22)
tierBtn.Text = "TELEPORT TIER"
tierBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
tierBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",tierBtn)

local buyBtn = Instance.new("TextButton",farmContainer)
buyBtn.Size = UDim2.new(1,0,0,22)
buyBtn.Text = "AUTO BUY"
buyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
buyBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",buyBtn)

-- BUTTON EVENTS

buyBtn.MouseButton1Click:Connect(function()
task.spawn(autoBuy)
end)

tpBtn.MouseButton1Click:Connect(function()
teleportNPC()
end)

tierBtn.MouseButton1Click:Connect(function()
teleportTier()
end)

sellBtn.MouseButton1Click:Connect(function()

autoSellEnabled = not autoSellEnabled

if autoSellEnabled then
sellBtn.Text="AUTO SELL : ON"
task.spawn(autoSell)
else
sellBtn.Text="AUTO SELL : OFF"
end

end)

-- FARM LOOP

local function cook()

while running do

if equip("Water") then
statusLabel.Text="💧 Cooking Water..."
fill(waterBar,20)
holdE(.7)
task.wait(20)
end

if equip("Sugar Block Bag") then
statusLabel.Text="🍬 Cooking Sugar..."
fill(sugarBar,1)
holdE(.7)
task.wait(1)
end

if equip("Gelatin") then
statusLabel.Text="🍮 Cooking Gelatin..."
fill(gelatinBar,1)
holdE(.7)
task.wait(1)
end

statusLabel.Text="⏳ Waiting..."
fill(bagBar,45)
task.wait(45)

if equip("Empty Bag") then
statusLabel.Text="👜 Collecting..."
holdE(.7)
task.wait(1)
end

end

end

toggleBtn.MouseButton1Click:Connect(function()

running = not running

if running then
statusLabel.Text="Status: RUNNING"
toggleBtn.Text="STOP"
task.spawn(cook)
else
statusLabel.Text="Status: STOPPED"
toggleBtn.Text="AUTO FARM"
end

end)

-- COUNTER LOOP

task.spawn(function()

while gui.Parent do

local small = countItem("Small Marshmallow Bag")
local medium = countItem("Medium Marshmallow Bag")
local large = countItem("Large Marshmallow Bag")

local total = small + medium + large

smallLabel.Text = "Small Marshmallow: "..small
mediumLabel.Text = "Medium Marshmallow: "..medium
largeLabel.Text = "Large Marshmallow: "..large
totalLabel.Text = "Total: "..total

waterLabel.Text = "💧 Water: "..countItem("Water")
sugarLabel.Text = "🍬 Sugar: "..countItem("Sugar Block Bag")
gelatinLabel.Text = "🍮 Gelatin: "..countItem("Gelatin")
bagLabel.Text = "👜 Bag: "..countItem("Empty Bag")

task.wait(.5)

end

end)

-- KEYBIND

ContextActionService:BindAction(
"toggleUI",
function(_,state)
if state == Enum.UserInputState.Begin then
frame.Visible = not frame.Visible
end
end,
false,
Enum.KeyCode.P
)
