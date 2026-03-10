-- ELIXIRSTORE V3

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

-- HOLD E

local function holdE(t)

vim:SendKeyEvent(true,"E",false,game)
task.wait(t)
vim:SendKeyEvent(false,"E",false,game)

end

-- EQUIP

local function equip(name)

local char = player.Character
local tool = player.Backpack:FindFirstChild(name) or char:FindFirstChild(name)

if tool then
char.Humanoid:EquipTool(tool)
task.wait(.3)
return true
end

end

-- COUNT ITEM

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

-- VEHICLE TELEPORT (SAMA SEPERTI TESTER)

local function vehicleTeleport(cf)

local char = player.Character
if not char then return end

local humanoid = char:FindFirstChild("Humanoid")
if not humanoid then return end

local seat = humanoid.SeatPart
if not seat then return end

local vehicle = seat:FindFirstAncestorOfClass("Model")
if not vehicle then return end

if not vehicle.PrimaryPart then
vehicle.PrimaryPart = seat
end

vehicle:SetPrimaryPartCFrame(cf)

task.wait(1)

seat.Throttle = 1
task.wait(0.5)
seat.Throttle = 0

end


-- TELEPORT NPC

local function teleportNPC()

if statusLabel then
statusLabel.Text = "Teleport NPC..."
end

vehicleTeleport(npcPos)

if statusLabel then
statusLabel.Text = "Arrived NPC"
end

end


-- TELEPORT TIER

local function teleportTier()

if statusLabel then
statusLabel.Text = "Teleport Tier..."
end

vehicleTeleport(tierPos)

if statusLabel then
statusLabel.Text = "Arrived Tier"
end

end


-- AUTO BUY

local function autoBuy()

if statusLabel then
statusLabel.Text = "Buying "..buyAmount
end

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

if statusLabel then
statusLabel.Text = "Bought "..buyAmount
end

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

if statusLabel then
statusLabel.Text = "Selling "..bag
end

holdE(.7)
task.wait(1)

else
break
end

end

end

if statusLabel then
statusLabel.Text = "Sell Finished"
end

end

-- GUI

local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIRSTORE_V3"
gui.Parent = playerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,360,0,420)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)

frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(120,60,255)
stroke.Thickness = 2


-- TITLE

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ELIXIRSTORE V3"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(230,200,255)


-- CLOSE BUTTON

local close = Instance.new("TextButton",frame)
close.Position = UDim2.new(1,-22,0,4)
close.Size = UDim2.new(0,20,0,20)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 11

Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
running = false
gui:Destroy()
end)


-- HIDE BUTTON

local hide = Instance.new("TextButton",frame)
hide.Position = UDim2.new(1,-48,0,4)
hide.Size = UDim2.new(0,20,0,20)
hide.Text = "-"
hide.BackgroundColor3 = Color3.fromRGB(70,70,90)
hide.TextColor3 = Color3.new(1,1,1)
hide.Font = Enum.Font.GothamBold
hide.TextSize = 12

Instance.new("UICorner",hide)


local hidden = false

hide.MouseButton1Click:Connect(function()

hidden = not hidden

if hidden then

for _,v in pairs(frame:GetChildren()) do
if v ~= title and v ~= close and v ~= hide then
v.Visible = false
end
end

frame.Size = UDim2.new(0,360,0,34)

else

for _,v in pairs(frame:GetChildren()) do
v.Visible = true
end

frame.Size = UDim2.new(0,360,0,420)

end

end)

-- TAB BAR

local tabFrame = Instance.new("Frame",frame)
tabFrame.Position = UDim2.new(0,0,0,32)
tabFrame.Size = UDim2.new(1,0,0,28)
tabFrame.BackgroundTransparency = 1


local function createTab(name,x)

local btn = Instance.new("TextButton",tabFrame)
btn.Size = UDim2.new(0,110,0,24)
btn.Position = UDim2.new(0,x,0,2)

btn.Text = name
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.fromRGB(220,220,220)

btn.BackgroundColor3 = Color3.fromRGB(50,50,65)

Instance.new("UICorner",btn)

return btn

end


local farmTab = createTab("FARM",10)
local statusTab = createTab("STATUS",125)
local teleportTab = createTab("TELEPORT",240)



-- CONTAINERS

local farmContainer = Instance.new("ScrollingFrame",frame)
farmContainer.Position = UDim2.new(0,10,0,65)
farmContainer.Size = UDim2.new(1,-20,1,-75)
farmContainer.BackgroundTransparency = 1
farmContainer.ScrollBarThickness = 4


local statusContainer = Instance.new("ScrollingFrame",frame)
statusContainer.Position = farmContainer.Position
statusContainer.Size = farmContainer.Size
statusContainer.BackgroundTransparency = 1
statusContainer.ScrollBarThickness = 4
statusContainer.Visible = false


local teleportContainer = Instance.new("ScrollingFrame",frame)
teleportContainer.Position = farmContainer.Position
teleportContainer.Size = farmContainer.Size
teleportContainer.BackgroundTransparency = 1
teleportContainer.ScrollBarThickness = 4
teleportContainer.Visible = false



-- LAYOUT

local farmLayout = Instance.new("UIListLayout",farmContainer)
farmLayout.Padding = UDim.new(0,8)

local statusLayout = Instance.new("UIListLayout",statusContainer)
statusLayout.Padding = UDim.new(0,8)

local teleportLayout = Instance.new("UIListLayout",teleportContainer)
teleportLayout.Padding = UDim.new(0,8)



farmContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
teleportContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y



-- TAB SWITCH

farmTab.MouseButton1Click:Connect(function()

farmContainer.Visible = true
statusContainer.Visible = false
teleportContainer.Visible = false

end)


statusTab.MouseButton1Click:Connect(function()

farmContainer.Visible = false
statusContainer.Visible = true
teleportContainer.Visible = false

end)


teleportTab.MouseButton1Click:Connect(function()

farmContainer.Visible = false
statusContainer.Visible = false
teleportContainer.Visible = true

end)

-- STATUS LABEL

statusLabel = Instance.new("TextLabel",farmContainer)
statusLabel.Size = UDim2.new(1,0,0,24)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: STOPPED"

statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(220,220,220)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left



-- PROGRESS ROW

local function createRow(text)

local row = Instance.new("Frame",farmContainer)
row.Size = UDim2.new(1,0,0,26)
row.BackgroundTransparency = 1

local label = Instance.new("TextLabel",row)
label.Size = UDim2.new(0.45,0,1,0)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.GothamMedium
label.TextSize = 14
label.TextColor3 = Color3.fromRGB(210,210,210)
label.TextXAlignment = Enum.TextXAlignment.Left

local bg = Instance.new("Frame",row)
bg.Position = UDim2.new(0.52,0,0.5,-4)
bg.Size = UDim2.new(0.46,0,0,8)
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



-- BUY SLIDER

local buyLabel = Instance.new("TextLabel",farmContainer)
buyLabel.Size = UDim2.new(1,0,0,22)
buyLabel.BackgroundTransparency = 1
buyLabel.Text = "BUY AMOUNT : 1"
buyLabel.Font = Enum.Font.Gotham
buyLabel.TextSize = 14
buyLabel.TextColor3 = Color3.fromRGB(210,210,210)



local slider = Instance.new("Frame",farmContainer)
slider.Size = UDim2.new(1,0,0,8)
slider.BackgroundColor3 = Color3.fromRGB(45,45,45)

Instance.new("UICorner",slider)



local knob = Instance.new("Frame",slider)
knob.Size = UDim2.new(0,14,0,14)
knob.Position = UDim2.new(0,-7,0.5,-7)
knob.BackgroundColor3 = Color3.fromRGB(180,0,255)

Instance.new("UICorner",knob)



local dragging = false


local function updateSlider(x)

local pos = math.clamp((x-slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)

knob.Position = UDim2.new(pos,-7,0.5,-7)

buyAmount = math.floor(1 + pos * 24)

buyLabel.Text = "BUY AMOUNT : "..buyAmount

end



slider.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 
or input.UserInputType == Enum.UserInputType.Touch then

dragging = true
updateSlider(input.Position.X)

end

end)



UIS.InputChanged:Connect(function(input)

if dragging and (
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
) then

updateSlider(input.Position.X)

end

end)



UIS.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 
or input.UserInputType == Enum.UserInputType.Touch then

dragging = false

end

end)

-- BUTTONS

local toggleBtn = Instance.new("TextButton",farmContainer)
toggleBtn.Size = UDim2.new(1,0,0,28)
toggleBtn.Text = "AUTO FARM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner",toggleBtn)


local sellBtn = Instance.new("TextButton",farmContainer)
sellBtn.Size = UDim2.new(1,0,0,28)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
sellBtn.TextColor3 = Color3.fromRGB(255,255,255)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 14
Instance.new("UICorner",sellBtn)


local buyBtn = Instance.new("TextButton",farmContainer)
buyBtn.Size = UDim2.new(1,0,0,28)
buyBtn.Text = "AUTO BUY"
buyBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
buyBtn.TextColor3 = Color3.fromRGB(255,255,255)
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 14
Instance.new("UICorner",buyBtn)



-- BUTTON EVENTS

buyBtn.MouseButton1Click:Connect(function()
task.spawn(autoBuy)
end)


sellBtn.MouseButton1Click:Connect(function()

autoSellEnabled = not autoSellEnabled

if autoSellEnabled then
sellBtn.Text = "AUTO SELL : ON"
task.spawn(autoSell)
else
sellBtn.Text = "AUTO SELL : OFF"
end

end)



-- PROGRESS BAR FILL

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



-- FARM LOOP

local function cook()

while running do

if equip("Water") then
statusLabel.Text = "💧 Cooking Water..."
fill(waterBar,20)
holdE(.7)
task.wait(20)
end


if equip("Sugar Block Bag") then
statusLabel.Text = "🍬 Cooking Sugar..."
fill(sugarBar,1)
holdE(.7)
task.wait(1)
end


if equip("Gelatin") then
statusLabel.Text = "🍮 Cooking Gelatin..."
fill(gelatinBar,1)
holdE(.7)
task.wait(1)
end


statusLabel.Text = "⏳ Waiting..."
fill(bagBar,45)
task.wait(45)


if equip("Empty Bag") then
statusLabel.Text = "👜 Collecting..."
holdE(.7)
task.wait(1)
end

end

end



toggleBtn.MouseButton1Click:Connect(function()

running = not running

if running then
statusLabel.Text = "Status: RUNNING"
toggleBtn.Text = "STOP"
task.spawn(cook)
else
statusLabel.Text = "Status: STOPPED"
toggleBtn.Text = "AUTO FARM"
end

end)

for _,v in pairs(farmContainer:GetChildren()) do
if v:IsA("TextButton") then
v:Destroy()
end
end

-- BUTTONS

local toggleBtn = Instance.new("TextButton",farmContainer)
toggleBtn.Size = UDim2.new(1,0,0,28)
toggleBtn.Text = "AUTO FARM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner",toggleBtn)


local sellBtn = Instance.new("TextButton",farmContainer)
sellBtn.Size = UDim2.new(1,0,0,28)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
sellBtn.TextColor3 = Color3.fromRGB(255,255,255)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 14
Instance.new("UICorner",sellBtn)


local buyBtn = Instance.new("TextButton",farmContainer)
buyBtn.Size = UDim2.new(1,0,0,28)
buyBtn.Text = "AUTO BUY"
buyBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
buyBtn.TextColor3 = Color3.fromRGB(255,255,255)
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 14
Instance.new("UICorner",buyBtn)



-- BUTTON EVENTS

buyBtn.MouseButton1Click:Connect(function()
task.spawn(autoBuy)
end)


sellBtn.MouseButton1Click:Connect(function()

autoSellEnabled = not autoSellEnabled

if autoSellEnabled then
sellBtn.Text = "AUTO SELL : ON"
task.spawn(autoSell)
else
sellBtn.Text = "AUTO SELL : OFF"
end

end)



-- PROGRESS BAR FILL

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



-- FARM LOOP

local function cook()

while running do

if equip("Water") then
statusLabel.Text = "💧 Cooking Water..."
fill(waterBar,20)
holdE(.7)
task.wait(20)
end


if equip("Sugar Block Bag") then
statusLabel.Text = "🍬 Cooking Sugar..."
fill(sugarBar,1)
holdE(.7)
task.wait(1)
end


if equip("Gelatin") then
statusLabel.Text = "🍮 Cooking Gelatin..."
fill(gelatinBar,1)
holdE(.7)
task.wait(1)
end


statusLabel.Text = "⏳ Waiting..."
fill(bagBar,45)
task.wait(45)


if equip("Empty Bag") then
statusLabel.Text = "👜 Collecting..."
holdE(.7)
task.wait(1)
end

end

end



toggleBtn.MouseButton1Click:Connect(function()

running = not running

if running then
statusLabel.Text = "Status: RUNNING"
toggleBtn.Text = "STOP"
task.spawn(cook)
else
statusLabel.Text = "Status: STOPPED"
toggleBtn.Text = "AUTO FARM"
end

end)

-- STATUS TAB

local function createStatus(text)

local label = Instance.new("TextLabel",statusContainer)
label.Size = UDim2.new(1,0,0,24)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Color3.new(1,1,1)
label.TextXAlignment = Enum.TextXAlignment.Left

return label

end


local smallLabel = createStatus("Small Marshmallow: 0")
local mediumLabel = createStatus("Medium Marshmallow: 0")
local largeLabel = createStatus("Large Marshmallow: 0")
local totalLabel = createStatus("Total: 0")

local waterStatus = createStatus("Water: 0")
local sugarStatus = createStatus("Sugar: 0")
local gelatinStatus = createStatus("Gelatin: 0")
local bagStatus = createStatus("Bag: 0")



-- STATUS UPDATE LOOP

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

waterStatus.Text = "Water: "..countItem("Water")
sugarStatus.Text = "Sugar: "..countItem("Sugar Block Bag")
gelatinStatus.Text = "Gelatin: "..countItem("Gelatin")
bagStatus.Text = "Bag: "..countItem("Empty Bag")

task.wait(.5)

end

end)



-- TELEPORT BUTTON CREATOR

local function createTeleport(text,callback)

local btn = Instance.new("TextButton",teleportContainer)
btn.Size = UDim2.new(1,0,0,28)

btn.Text = text
btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14

Instance.new("UICorner",btn)

btn.MouseButton1Click:Connect(callback)

end



-- TELEPORT NPC

createTeleport("TELEPORT NPC",function()
vehicleTeleport(npcPos)
end)



-- TELEPORT TIER

createTeleport("TELEPORT TIER",function()
vehicleTeleport(tierPos)
end)



-- APARTEMENTS

createTeleport("Apart 1",function()
vehicleTeleport(CFrame.new(1140.319091796875,10.105062484741211,450.2520446777344)*CFrame.new(0,2,0))
end)

createTeleport("Apart 2",function()
vehicleTeleport(CFrame.new(1141.39099,10.1050625,422.805542)*CFrame.new(0,2,0))
end)

createTeleport("Apart 3",function()
vehicleTeleport(CFrame.new(986.987305,10.1050644,248.435837)*CFrame.new(0,2,0))
end)

createTeleport("Apart 4",function()
vehicleTeleport(CFrame.new(986.299194,10.1050644,219.940186)*CFrame.new(0,2,0))
end)

createTeleport("Apart 5",function()
vehicleTeleport(CFrame.new(924.781006,10.1050644,41.1367264)*CFrame.Angles(0,math.rad(90),0))
end)

createTeleport("Apart 6",function()
vehicleTeleport(CFrame.new(896.671997,10.1050644,40.6403999)*CFrame.Angles(0,math.rad(90),0))
end)



-- CSN

createTeleport("CSN 1",function()
vehicleTeleport(CFrame.new(1178.8331298828125,3.95,-227.3722381591797))
end)

createTeleport("CSN 2",function()
vehicleTeleport(CFrame.new(1205.0880126953125,3.95,-220.54200744628906))
end)

createTeleport("CSN 3",function()
vehicleTeleport(CFrame.new(1204.281005859375,3.7122225761413574,-182.851318359375))
end)

createTeleport("CSN 4",function()
vehicleTeleport(CFrame.new(1178.5850830078125,3.712223529815674,-189.7107696533203))
end)



-- KEYBIND HIDE SHOW

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
