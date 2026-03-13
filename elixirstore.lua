-- ELIXIR 3.1 FINAL
local Players = game:GetService("Players")
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

-- VEHICLE TELEPORT

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


-- COOK LOOP

local function cook()

while running do

if equip("Water") then
if statusLabel then
statusLabel.Text = "Cooking Water..."
end

if waterBar then
fill(waterBar,20)
end

holdE(.7)
task.wait(20)

end


if equip("Sugar Block Bag") then

if statusLabel then
statusLabel.Text = "Cooking Sugar..."
end

if sugarBar then
fill(sugarBar,1)
end

holdE(.7)
task.wait(1)

end


if equip("Gelatin") then

if statusLabel then
statusLabel.Text = "Cooking Gelatin..."
end

if gelatinBar then
fill(gelatinBar,1)
end

holdE(.7)
task.wait(1)

end


if statusLabel then
statusLabel.Text = "Waiting..."
end

if bagBar then
fill(bagBar,45)
end

task.wait(45)


if equip("Empty Bag") then

if statusLabel then
statusLabel.Text = "Collecting..."
end

holdE(.7)
task.wait(1)

end

end

end

-- AUTO BUY

local buying = false

local function autoBuy()

if buying then return end
buying = true

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

buying = false

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

-- STATUS LABEL CREATOR
local function createStatus(text)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1,0,0,24)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Color3.new(1,1,1)
label.TextXAlignment = Enum.TextXAlignment.Left

return label

end


-- CARD CREATOR
local function createCard(title)

local card = Instance.new("Frame")
card.Size = UDim2.new(0.48,0,0,60)
card.BackgroundColor3 = Color3.fromRGB(28,28,36)

Instance.new("UICorner",card)

local name = Instance.new("TextLabel",card)
name.Size = UDim2.new(1,0,0,20)
name.BackgroundTransparency = 1
name.Text = title
name.Font = Enum.Font.GothamSemibold
name.TextSize = 13
name.TextColor3 = Color3.fromRGB(210,210,210)

local value = Instance.new("TextLabel",card)
value.Position = UDim2.new(0,0,0,22)
value.Size = UDim2.new(1,0,1,-22)
value.BackgroundTransparency = 1
value.Text = "0"
value.Font = Enum.Font.GothamBold
value.TextSize = 20
value.TextColor3 = Color3.fromRGB(170,90,255)

return value,card

end

-- STATUS LABEL VARIABLES

local smallLabel
local mediumLabel
local largeLabel
local totalLabel

local waterStatus
local sugarStatus
local gelatinStatus
local bagStatus



-- STATUS UPDATE LOOP

local function startStatusLoop()

task.spawn(function()

while gui and gui.Parent do

local small = countItem("Small Marshmallow Bag")
local medium = countItem("Medium Marshmallow Bag")
local large = countItem("Large Marshmallow Bag")

local total = small + medium + large

if smallLabel then
smallLabel.Text = "Small Marshmallow: "..small
end

if mediumLabel then
mediumLabel.Text = "Medium Marshmallow: "..medium
end

if largeLabel then
largeLabel.Text = "Large Marshmallow: "..large
end

if totalLabel then
totalLabel.Text = "Total: "..total
end


if waterStatus then
waterStatus.Text = "Water: "..countItem("Water")
end

if sugarStatus then
sugarStatus.Text = "Sugar: "..countItem("Sugar Block Bag")
end

if gelatinStatus then
gelatinStatus.Text = "Gelatin: "..countItem("Gelatin")
end

if bagStatus then
bagStatus.Text = "Bag: "..countItem("Empty Bag")
end

task.wait(.5)

end

end)

end


-- TELEPORT BUTTON CREATOR

local function createTeleport(text,callback)

local btn = Instance.new("TextButton")

btn.Size = UDim2.new(1,0,0,28)
btn.Text = text
btn.BackgroundColor3 = Color3.fromRGB(45,45,55)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14

Instance.new("UICorner",btn)

btn.MouseButton1Click:Connect(callback)

return btn

end



-- TELEPORT FUNCTIONS

local function teleportNPC()

if statusLabel then
statusLabel.Text = "Teleport NPC..."
end

vehicleTeleport(npcPos)

if statusLabel then
statusLabel.Text = "Arrived NPC"
end

end


local function teleportTier()

if statusLabel then
statusLabel.Text = "Teleport Tier..."
end

vehicleTeleport(tierPos)

if statusLabel then
statusLabel.Text = "Arrived Tier"
end

end



-- APART POSITIONS

local apart1 = CFrame.new(1140.319091796875,10.105062484741211,450.2520446777344)*CFrame.new(0,2,0)
local apart2 = CFrame.new(1141.39099,10.1050625,422.805542)*CFrame.new(0,2,0)
local apart3 = CFrame.new(986.987305,10.1050644,248.435837)*CFrame.new(0,2,0)
local apart4 = CFrame.new(986.299194,10.1050644,219.940186)*CFrame.new(0,2,0)
local apart5 = CFrame.new(924.781006,10.1050644,41.1367264)*CFrame.Angles(0,math.rad(90),0)
local apart6 = CFrame.new(896.671997,10.1050644,40.6403999)*CFrame.Angles(0,math.rad(90),0)



-- CSN POSITIONS

local csn1 = CFrame.new(1178.8331298828125,3.95,-227.3722381591797)
local csn2 = CFrame.new(1205.0880126953125,3.95,-220.54200744628906)
local csn3 = CFrame.new(1204.281005859375,3.7122225761413574,-182.851318359375)
local csn4 = CFrame.new(1178.5850830078125,3.712223529815674,-189.7107696533203)

-- GUI PREMIUM BASE

local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIR_3_1"
gui.Parent = playerGui
gui.ResetOnSpawn = false

local accent = Color3.fromRGB(170,90,255)

-- MAIN WINDOW

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,720,0,430)
main.Position = UDim2.new(0.5,-360,0.5,-215)
main.BackgroundColor3 = Color3.fromRGB(14,14,18)
main.Active = true
main.Draggable = true

Instance.new("UICorner",main)
local stroke = Instance.new("UIStroke",main)
stroke.Color = accent
stroke.Thickness = 2

-- TOP BAR

local top = Instance.new("Frame",main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(18,18,24)

local title = Instance.new("TextLabel",top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "ELIXIR 3.1"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = accent
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0,10,0,0)

-- CLOSE BUTTON

local close = Instance.new("TextButton",top)
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-34,0,6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(60,20,20)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14

Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
running = false
autoSellEnabled = false
gui:Destroy()
end)

-- SIDEBAR

local sidebar = Instance.new("Frame",main)
sidebar.Size = UDim2.new(0,180,1,-40)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.BackgroundColor3 = Color3.fromRGB(22,18,30)

-- CONTENT

local content = Instance.new("Frame",main)
content.Size = UDim2.new(1,-180,1,-40)
content.Position = UDim2.new(0,180,0,40)
content.BackgroundColor3 = Color3.fromRGB(20,20,28)

-- TAB SYSTEM

local pages = {}

local function createTab(name,y)

local btn = Instance.new("TextButton",sidebar)
btn.Size = UDim2.new(1,-20,0,36)
btn.Position = UDim2.new(0,10,0,y)

btn.Text = name
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BackgroundColor3 = Color3.fromRGB(32,24,45)
btn.TextColor3 = Color3.fromRGB(230,230,230)

Instance.new("UICorner",btn)

local page = Instance.new("ScrollingFrame",content)
page.Size = UDim2.new(1,0,1,0)
page.BackgroundTransparency = 1
page.ScrollBarThickness = 4
page.Visible = false

local layout = Instance.new("UIListLayout",page)
layout.Padding = UDim.new(0,8)

local padding = Instance.new("UIPadding",page)
padding.PaddingTop = UDim.new(0,10)
padding.PaddingLeft = UDim.new(0,10)
padding.PaddingRight = UDim.new(0,10)

pages[name] = page

btn.MouseButton1Click:Connect(function()

for _,p in pairs(pages) do
p.Visible = false
end

page.Visible = true

end)

return page

end

-- CREATE PAGES

local farmPage = createTab("FARM",20)
local statusPage = createTab("STATUS",70)
local teleportPage = createTab("TELEPORT",120)
local espPage = createTab("ESP",170)

local MaxDistance = 500

local distLabel = Instance.new("TextLabel",espPage)
distLabel.Size = UDim2.new(1,0,0,20)
distLabel.BackgroundTransparency = 1
distLabel.Text = "ESP DISTANCE : "..MaxDistance
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 14
distLabel.TextColor3 = Color3.fromRGB(210,210,210)

local distSlider = Instance.new("Frame",espPage)
distSlider.Size = UDim2.new(1,0,0,8)
distSlider.BackgroundColor3 = Color3.fromRGB(45,45,45)

Instance.new("UICorner",distSlider)

local distKnob = Instance.new("Frame",distSlider)
distKnob.Size = UDim2.new(0,14,0,14)
distKnob.Position = UDim2.new(1,-7,0.5,-7)
distKnob.BackgroundColor3 = accent

Instance.new("UICorner",distKnob)

local draggingDist = false

local function updateDistSlider(x)

local pos = math.clamp((x-distSlider.AbsolutePosition.X)/distSlider.AbsoluteSize.X,0,1)

distKnob.Position = UDim2.new(pos,-7,0.5,-7)

MaxDistance = math.floor(50 + pos * 7950)

distLabel.Text = "ESP DISTANCE : "..MaxDistance

end

distSlider.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingDist = true
updateDistSlider(input.Position.X)
end

end)

UIS.InputChanged:Connect(function(input)

if draggingDist and input.UserInputType == Enum.UserInputType.MouseMovement then
updateDistSlider(input.Position.X)
end

end)

UIS.InputEnded:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then
draggingDist = false
end

end)

local espBtn = Instance.new("TextButton",espPage)

-- NAME TOGGLE

local nameBtn = Instance.new("TextButton",espPage)
nameBtn.Size = UDim2.new(1,0,0,32)
nameBtn.Text = "NAME : ON"
nameBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
nameBtn.TextColor3 = Color3.new(1,1,1)
nameBtn.Font = Enum.Font.GothamBold
nameBtn.TextSize = 14
Instance.new("UICorner",nameBtn)

nameBtn.MouseButton1Click:Connect(function()

ShowName = not ShowName

if ShowName then
nameBtn.Text = "NAME : ON"
else
nameBtn.Text = "NAME : OFF"
end

end)



-- HEALTH TOGGLE

local healthBtn = Instance.new("TextButton",espPage)
healthBtn.Size = UDim2.new(1,0,0,32)
healthBtn.Text = "HEALTH BAR : ON"
healthBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
healthBtn.TextColor3 = Color3.new(1,1,1)
healthBtn.Font = Enum.Font.GothamBold
healthBtn.TextSize = 14
Instance.new("UICorner",healthBtn)

healthBtn.MouseButton1Click:Connect(function()

ShowHealth = not ShowHealth

if ShowHealth then
healthBtn.Text = "HEALTH BAR : ON"
else
healthBtn.Text = "HEALTH BAR : OFF"
end

end)



-- DISTANCE TOGGLE

local distBtn = Instance.new("TextButton",espPage)
distBtn.Size = UDim2.new(1,0,0,32)
distBtn.Text = "DISTANCE : ON"
distBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
distBtn.TextColor3 = Color3.new(1,1,1)
distBtn.Font = Enum.Font.GothamBold
distBtn.TextSize = 14
Instance.new("UICorner",distBtn)

distBtn.MouseButton1Click:Connect(function()

ShowDistance = not ShowDistance

if ShowDistance then
distBtn.Text = "DISTANCE : ON"
else
distBtn.Text = "DISTANCE : OFF"
end

end)

espBtn.Size = UDim2.new(1,0,0,32)
espBtn.Text = "ESP : OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14

Instance.new("UICorner",espBtn)

espBtn.MouseButton1Click:Connect(function()

Enabled = not Enabled

if Enabled then
espBtn.Text = "ESP : ON"
else
espBtn.Text = "ESP : OFF"
end

end)
farmPage.Visible = true

-- FARM STATUS LABEL

statusLabel = Instance.new("TextLabel",farmPage)
statusLabel.Size = UDim2.new(1,0,0,24)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status : STOPPED"
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(220,220,220)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left



-- PROGRESS BAR CREATOR

local function createRow(text)

local row = Instance.new("Frame",farmPage)
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
bar.BackgroundColor3 = accent

Instance.new("UICorner",bar)

return label,bar

end



-- PROGRESS BARS

waterLabel,waterBar = createRow("💧 Water : 0")
sugarLabel,sugarBar = createRow("🧊 Sugar : 0")
gelatinLabel,gelatinBar = createRow("🧪 Gelatin : 0")
bagLabel,bagBar = createRow("📦 Bag : 0")



-- BUY SLIDER

local buyLabel = Instance.new("TextLabel",farmPage)
buyLabel.Size = UDim2.new(1,0,0,22)
buyLabel.BackgroundTransparency = 1
buyLabel.Text = "BUY AMOUNT : 1"
buyLabel.Font = Enum.Font.Gotham
buyLabel.TextSize = 14
buyLabel.TextColor3 = Color3.fromRGB(210,210,210)

local slider = Instance.new("Frame",farmPage)
slider.Size = UDim2.new(1,0,0,8)
slider.BackgroundColor3 = Color3.fromRGB(45,45,45)

Instance.new("UICorner",slider)

local knob = Instance.new("Frame",slider)
knob.Size = UDim2.new(0,14,0,14)
knob.Position = UDim2.new(0,-7,0.5,-7)
knob.BackgroundColor3 = accent

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

local toggleBtn = Instance.new("TextButton",farmPage)
toggleBtn.Size = UDim2.new(1,0,0,32)
toggleBtn.Text = "AUTO FARM"
toggleBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner",toggleBtn)


local sellBtn = Instance.new("TextButton",farmPage)
sellBtn.Size = UDim2.new(1,0,0,32)
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
sellBtn.TextColor3 = Color3.new(1,1,1)
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 14
Instance.new("UICorner",sellBtn)


local buyBtn = Instance.new("TextButton",farmPage)
buyBtn.Size = UDim2.new(1,0,0,32)
buyBtn.Text = "AUTO BUY"
buyBtn.BackgroundColor3 = Color3.fromRGB(55,35,85)
buyBtn.TextColor3 = Color3.new(1,1,1)
buyBtn.Font = Enum.Font.GothamBold
buyBtn.TextSize = 14
Instance.new("UICorner",buyBtn)



-- BUTTON EVENTS

toggleBtn.MouseButton1Click:Connect(function()

running = not running

if running then
statusLabel.Text = "Status : RUNNING"
toggleBtn.Text = "STOP"
task.spawn(cook)
else
statusLabel.Text = "Status : STOPPED"
toggleBtn.Text = "AUTO FARM"
end

end)


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

-- STATUS LABEL CREATOR
local function createStatus(text)

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1,0,0,24)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Color3.new(1,1,1)
label.TextXAlignment = Enum.TextXAlignment.Left

return label

end

-- GRID LAYOUT

local grid = Instance.new("UIGridLayout",statusPage)

grid.CellSize = UDim2.new(0.48,0,0,60)
grid.CellPadding = UDim2.new(0.04,0,0,8)

-- STATUS TAB UI

smallLabel,smallCard = createCard("🍬 Small")
mediumLabel,mediumCard = createCard("🍬 Medium")
largeLabel,largeCard = createCard("🍬 Large")

waterStatus,waterCard = createCard("💧 Water")
sugarStatus,sugarCard = createCard("🧊 Sugar")
gelatinStatus,gelatinCard = createCard("🧪 Gelatin")
bagStatus,bagCard = createCard("📦 Bag")

smallCard.Parent = statusPage
mediumCard.Parent = statusPage
largeCard.Parent = statusPage

waterCard.Parent = statusPage
sugarCard.Parent = statusPage
gelatinCard.Parent = statusPage
bagCard.Parent = statusPage

-- PLAYER AVATAR

local avatarFrame = Instance.new("Frame")
avatarFrame.Parent = statusPage
avatarFrame.Size = UDim2.new(1,0,0,70)
avatarFrame.BackgroundTransparency = 1

local avatar = Instance.new("ImageLabel",avatarFrame)
avatar.Size = UDim2.new(0,60,0,60)
avatar.Position = UDim2.new(0,0,0,0)
avatar.BackgroundTransparency = 1

local username = Instance.new("TextLabel",avatarFrame)
username.Position = UDim2.new(0,70,0,20)
username.Size = UDim2.new(1,-70,0,20)
username.BackgroundTransparency = 1
username.Font = Enum.Font.GothamBold
username.TextSize = 16
username.TextColor3 = Color3.new(1,1,1)
username.TextXAlignment = Enum.TextXAlignment.Left

username.Text = player.Name

local content, ready = Players:GetUserThumbnailAsync(
player.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size100x100
)

avatar.Image = content

local function startStatusLoop()

task.spawn(function()

while gui and gui.Parent do

-- UPDATE FARM TAB COUNTER (emoji clean)

if waterLabel then
    waterLabel.Text = "💧 Water : "..countItem("Water")
end

if sugarLabel then
    sugarLabel.Text = "🧊 Sugar : "..countItem("Sugar Block Bag")
end

if gelatinLabel then
    gelatinLabel.Text = "🧪 Gelatin : "..countItem("Gelatin")
end

if bagLabel then
    bagLabel.Text = "📦 Bag : "..countItem("Empty Bag")
end

local small = countItem("Small Marshmallow Bag")
local medium = countItem("Medium Marshmallow Bag")
local large = countItem("Large Marshmallow Bag")

local total = small + medium + large

-- STATUS TAB

if smallLabel then
smallLabel.Text = small
end

if mediumLabel then
mediumLabel.Text = medium
end

if largeLabel then
largeLabel.Text = large
end

if totalLabel then
totalLabel.Text = "Total : "..total
end


if waterStatus then
waterStatus.Text = countItem("Water")
end

if sugarStatus then
sugarStatus.Text = countItem("Sugar Block Bag")
end

if gelatinStatus then
gelatinStatus.Text = countItem("Gelatin")
end

if bagStatus then
bagStatus.Text = countItem("Empty Bag")
end
task.wait(.5)

end

end)

end

-- START STATUS LOOP

startStatusLoop()

-- TELEPORT BUTTONS

local function addTeleportButton(text,callback)

local btn = Instance.new("TextButton",teleportPage)

btn.Size = UDim2.new(1,0,0,32)
btn.Text = text
btn.BackgroundColor3 = Color3.fromRGB(55,35,85)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14

Instance.new("UICorner",btn)

btn.MouseButton1Click:Connect(callback)

end



-- TELEPORT NPC

addTeleportButton("Teleport NPC",function()
teleportNPC()
end)



-- TELEPORT TIER

addTeleportButton("Teleport Tier",function()
teleportTier()
end)



-- APARTMENTS

addTeleportButton("Apart 1",function()
vehicleTeleport(apart1)
end)

addTeleportButton("Apart 2",function()
vehicleTeleport(apart2)
end)

addTeleportButton("Apart 3",function()
vehicleTeleport(apart3)
end)

addTeleportButton("Apart 4",function()
vehicleTeleport(apart4)
end)

addTeleportButton("Apart 5",function()
vehicleTeleport(apart5)
end)

addTeleportButton("Apart 6",function()
vehicleTeleport(apart6)
end)



-- CSN

addTeleportButton("CSN 1",function()
vehicleTeleport(csn1)
end)

addTeleportButton("CSN 2",function()
vehicleTeleport(csn2)
end)

addTeleportButton("CSN 3",function()
vehicleTeleport(csn3)
end)

addTeleportButton("CSN 4",function()
vehicleTeleport(csn4)
end)



-- MOBILE HIDE BUTTON

local hideBtn = Instance.new("TextButton",gui)

hideBtn.Size = UDim2.new(0,50,0,50)
hideBtn.Position = UDim2.new(1,-60,0.5,-25)

hideBtn.Text = "UI"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextSize = 14

hideBtn.BackgroundColor3 = accent
hideBtn.TextColor3 = Color3.new(1,1,1)

hideBtn.Active = true
hideBtn.Draggable = true

Instance.new("UICorner",hideBtn)

hideBtn.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
end)



-- KEYBIND PC

ContextActionService:BindAction(
"toggleUI",
function(_,state)

if state == Enum.UserInputState.Begin then
main.Visible = not main.Visible
end

end,
false,
Enum.KeyCode.P
)

repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {}
Enabled = false
ShowName = true
ShowHealth = true
ShowDistance = true

local PURPLE = Color3.fromRGB(170,90,255)

local function createESP(player)

    local box = {}

    for i = 1,8 do
        local line = Drawing.new("Line")
        line.Thickness = 3
        line.Color = PURPLE
        line.Visible = false
        table.insert(box,line)
    end

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Color3.new(1,1,1)
    name.Visible = false

    local health = Drawing.new("Line")
    health.Thickness = 4
    health.Visible = false

    ESP[player] = {
        box = box,
        name = name,
        health = health
    }

end


local function removeESP(player)

    if ESP[player] then

        for _,l in pairs(ESP[player].box) do
            l:Remove()
        end

        ESP[player].name:Remove()
        ESP[player].health:Remove()

        ESP[player] = nil

    end

end


for _,p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESP(p)
    end
end


Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        createESP(p)
    end
end)

Players.PlayerRemoving:Connect(removeESP)


RunService.RenderStepped:Connect(function()

    for player,data in pairs(ESP) do

        if not Enabled then

            for _,l in pairs(data.box) do
                l.Visible = false
            end

            data.name.Visible = false
            data.health.Visible = false

            continue

        end

        local char = player.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")

        if not hrp or not hum then continue end

        local pos,visible = Camera:WorldToViewportPoint(hrp.Position)

        if visible then

            local scale =
                Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0)).Y -
                Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0)).Y

            local width = scale*0.6
            local height = scale*1.2

            local x = pos.X
            local y = pos.Y

            local left = x - width/2
            local right = x + width/2
            local top = y - height/2
            local bottom = y + height/2

            local corner = width/4

            local function draw(lines)

                lines[1].From = Vector2.new(left,top)
                lines[1].To = Vector2.new(left+corner,top)

                lines[2].From = Vector2.new(left,top)
                lines[2].To = Vector2.new(left,top+corner)

                lines[3].From = Vector2.new(right,top)
                lines[3].To = Vector2.new(right-corner,top)

                lines[4].From = Vector2.new(right,top)
                lines[4].To = Vector2.new(right,top+corner)

                lines[5].From = Vector2.new(left,bottom)
                lines[5].To = Vector2.new(left+corner,bottom)

                lines[6].From = Vector2.new(left,bottom)
                lines[6].To = Vector2.new(left,bottom-corner)

                lines[7].From = Vector2.new(right,bottom)
                lines[7].To = Vector2.new(right-corner,bottom)

                lines[8].From = Vector2.new(right,bottom)
                lines[8].To = Vector2.new(right,bottom-corner)

                for _,l in pairs(lines) do
                    l.Visible = true
                end

            end

            draw(data.box)

            local distance = math.floor(
(LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
)

if distance > MaxDistance then

for _,l in pairs(data.box) do
    l.Visible = false
end

data.name.Visible = false
data.health.Visible = false

continue

end
if ShowName then

if ShowDistance then
data.name.Text = player.Name.." ["..distance.."]"
else
data.name.Text = player.Name
end

data.name.Position = Vector2.new(x,top-16)
data.name.Visible = true

else
data.name.Visible = false
end


            local hpPercent = 0
            if hum.MaxHealth > 0 then
                hpPercent = math.clamp(hum.Health / hum.MaxHealth,0,1)
            end

            local barWidth = width - 4
            local barY = bottom - 3

            data.health.From = Vector2.new(left + 2,barY)
            data.health.To = Vector2.new(left + 2 + (barWidth * hpPercent),barY)

            data.health.Color = Color3.fromRGB(
                255*(1-hpPercent),
                255*hpPercent,
                0
            )

           if ShowHealth then
data.health.Visible = true
else
data.health.Visible = false
end

        else

            for _,l in pairs(data.box) do
                l.Visible = false
            end

            data.name.Visible = false
            data.health.Visible = false

        end

    end

end)
