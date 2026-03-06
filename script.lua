-- ELIXIRSTORE AUTO MARSHMALLOW (FULL RAPIH)

local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local running = false

-- ===== Fungsi helper =====
local function holdE(t)
    vim:SendKeyEvent(true,"E",false,game)
    task.wait(t)
    vim:SendKeyEvent(false,"E",false,game)
end

local function equip(name)
    local tool = player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)
    if tool then
        player.Character.Humanoid:EquipTool(tool)
        task.wait(0.5)
        return true
    end
end

local function countItem(name)
    local total = 0
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name == name then total += 1 end
    end
    for _,v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") and v.Name == name then total += 1 end
    end
    return total
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "ELIXIRSTORE"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,380,0,320)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(30,0,60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,36)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "ELIXIRSTORE"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-32,0,4)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(120,0,180)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",closeBtn)
closeBtn.MouseButton1Click:Connect(function()
    running = false
    gui:Destroy()
end)

-- TAB BUTTONS
local tabFrame = Instance.new("Frame")
tabFrame.Parent = frame
tabFrame.Size = UDim2.new(1,0,0,36)
tabFrame.Position = UDim2.new(0,0,0,36)
tabFrame.BackgroundTransparency = 1

local function createTab(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Parent = tabFrame
    btn.Size = UDim2.new(0,120,1,0)
    btn.Position = UDim2.new(0,xPos,0,0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,0,100)
    Instance.new("UICorner",btn)
    return btn
end

local farmTabBtn = createTab("FARM",10)
local statusTabBtn = createTab("STATUS",140)

-- TAB CONTAINERS
local farmContainer = Instance.new("Frame")
farmContainer.Parent = frame
farmContainer.Size = UDim2.new(1,-20,1,-80)
farmContainer.Position = UDim2.new(0,10,0,72)
farmContainer.BackgroundTransparency = 1

local statusContainer = Instance.new("Frame")
statusContainer.Parent = frame
statusContainer.Size = UDim2.new(1,-20,1,-80)
statusContainer.Position = UDim2.new(0,10,0,72)
statusContainer.BackgroundTransparency = 1
statusContainer.Visible = false

-- SWITCH TAB
local function switchTab(tab)
    farmContainer.Visible = (tab=="FARM")
    statusContainer.Visible = (tab=="STATUS")
end

farmTabBtn.MouseButton1Click:Connect(function() switchTab("FARM") end)
statusTabBtn.MouseButton1Click:Connect(function() switchTab("STATUS") end)

-- ===== FARM TAB =====
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = farmContainer
statusLabel.Size = UDim2.new(1,0,0,22)
statusLabel.Position = UDim2.new(0,0,0,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Text = "Status: STOPPED"
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextColor3 = Color3.fromRGB(220,200,255)

local function makeLabel(y,text,parent)
    local l = Instance.new("TextLabel")
    l.Parent = parent
    l.Size = UDim2.new(1,0,0,18)
    l.Position = UDim2.new(0,0,0,y)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextColor3 = Color3.fromRGB(255,220,255)
    l.Text = text
    return l
end

local waterLabel = makeLabel(40,"💧 Water: 0",farmContainer)
local sugarLabel = makeLabel(65,"🍬 Sugar: 0",farmContainer)
local gelatinLabel = makeLabel(90,"🍮 Gelatin: 0",farmContainer)
local bagLabel = makeLabel(115,"👜 Empty Bag: 0",farmContainer)

-- Progress bar gradient
local function makeBar(y,parent)
    local bg = Instance.new("Frame")
    bg.Parent = parent
    bg.Size = UDim2.new(.95,0,0,6)
    bg.Position = UDim2.new(.025,0,0,y)
    bg.BackgroundColor3 = Color3.fromRGB(40,0,80)
    bg.BorderSizePixel = 0
    Instance.new("UICorner",bg)

    local bar = Instance.new("Frame")
    bar.Parent = bg
    bar.Size = UDim2.new(0,0,1,0)
    bar.BorderSizePixel = 0
    Instance.new("UICorner",bar)

    local grad = Instance.new("UIGradient")
    grad.Parent = bar
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(255,120,255)),
        ColorSequenceKeypoint.new(.5,Color3.fromRGB(180,50,230)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(255,120,255))
    }
    return bar
end

local waterBar = makeBar(58,farmContainer)
local sugarBar = makeBar(83,farmContainer)
local gelatinBar = makeBar(108,farmContainer)
local bagBar = makeBar(133,farmContainer)

local function fill(bar,time)
    bar:TweenSize(UDim2.new(1,0,1,0),"InOut","Linear",time,true)
    task.delay(time,function()
        if bar then bar.Size=UDim2.new(0,0,1,0) end
    end)
end

-- Toggle Auto
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = farmContainer
toggleBtn.Size = UDim2.new(0,70,0,26)
toggleBtn.Position = UDim2.new(.5,-35,0,160)
toggleBtn.Text = "AUTO"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(80,0,150)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,120)
        statusLabel.Text = "Status: RUNNING"
        task.spawn(cook)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80,0,150)
        statusLabel.Text = "Status: STOPPED"
    end
end)

-- Update counter realtime
task.spawn(function()
    while gui.Parent do
        waterLabel.Text = "💧 Water: "..countItem("Water")
        sugarLabel.Text = "🍬 Sugar: "..countItem("Sugar Block Bag")
        gelatinLabel.Text = "🍮 Gelatin: "..countItem("Gelatin")
        bagLabel.Text = "👜 Empty Bag: "..countItem("Empty Bag")
        task.wait(0.5)
    end
end)

-- Cook function
function cook()
    while running do
        if equip("Water") then
            statusLabel.Text="Cooking Water"
            fill(waterBar,20)
            holdE(0.7)
            task.wait(20)
        end
        if equip("Sugar Block Bag") then
            statusLabel.Text="Cooking Sugar"
            fill(sugarBar,1)
            holdE(0.7)
            task.wait(1)
        end
        if equip("Gelatin") then
            statusLabel.Text="Cooking Gelatin"
            fill(gelatinBar,1)
            holdE(0.7)
            task.wait(1)
        end
        fill(bagBar,45)
        statusLabel.Text="Waiting Marshmallow"
        task.wait(45)
        if equip("Empty Bag") then
            statusLabel.Text="Collecting Marshmallow"
            holdE(0.7)
            task.wait(1)
        end
        statusLabel.Text="Idle"
        task.wait(0.5)
    end
end

-- ===== STATUS TAB =====
local statusTitle = Instance.new("TextLabel")
statusTitle.Parent = statusContainer
statusTitle.Size = UDim2.new(1,0,0,24)
statusTitle.Position = UDim2.new(0,0,0,0)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "Player STATUS"
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 16
statusTitle.TextColor3 = Color3.fromRGB(220,200,255)
statusTitle.TextXAlignment = Enum.TextXAlignment.Center

local function makeStatusLabel(y,text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = statusContainer
    lbl.Size = UDim2.new(1,0,0,18)
    lbl.Position = UDim2.new(0,0,0,y)
    lbl.BackgroundTransparency = 0.5
    lbl.BackgroundColor3 = Color3.fromRGB(50,0,90)
    lbl.TextColor3 = Color3.fromRGB(220,200,255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 14
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner",lbl)
    return lbl
end

local playerLabel = makeStatusLabel(30,"Player: "..player.Name)
local marshLabel = makeStatusLabel(55,"Marshmallow: 0")
local waterLabel2 = makeStatusLabel(80,"Water: 0")
local sugarLabel2 = makeStatusLabel(105,"Sugar: 0")
local gelatinLabel2 = makeStatusLabel(130,"Gelatin: 0")
local toggleStatusLabel = makeStatusLabel(155,"AutoFarm: OFF")

-- Update STATUS tab realtime
task.spawn(function()
    while gui.Parent do
        marshLabel.Text = "Marshmallow: "..countItem("Empty Bag")
        waterLabel2.Text = "Water: "..countItem("Water")
        sugarLabel2.Text = "Sugar: "..countItem("Sugar Block Bag")
        gelatinLabel2.Text = "Gelatin: "..countItem("Gelatin")
        toggleStatusLabel.Text = "AutoFarm: "..(running and "ON" or "OFF")
        task.wait(0.5)
    end
end)

-- HIDE GUI (P)
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
