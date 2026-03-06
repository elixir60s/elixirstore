-- ELIXIRSTORE - Compact Auto Marshmallow GUI
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

local running = false

-- FUNCTIONS
local function holdE(t)
    vim:SendKeyEvent(true,"E",false,game)
    task.wait(t)
    vim:SendKeyEvent(false,"E",false,game)
end

local function equip(name)
    local tool = player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name)
    if tool then player.Character.Humanoid:EquipTool(tool) task.wait(0.5) return true end
end

local function countItem(name)
    local total = 0
    for _,v in pairs(player.Backpack:GetChildren()) do if v.Name==name then total+=1 end end
    for _,v in pairs(player.Character:GetChildren()) do if v:IsA("Tool") and v.Name==name then total+=1 end end
    return total
end

-- GUI HELPERS
local function createLabel(parent,text,y)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.Size = UDim2.new(1,-20,0,18)
    lbl.Position = UDim2.new(0,10,0,y)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(255,220,255)
    lbl.Text = text
    return lbl
end

local function createBar(parent,y)
    local bg = Instance.new("Frame",parent)
    bg.Size = UDim2.new(.9,0,0,6)
    bg.Position = UDim2.new(.05,0,0,y)
    bg.BackgroundColor3 = Color3.fromRGB(40,0,80)
    bg.BorderSizePixel = 0
    Instance.new("UICorner",bg)
    local bar = Instance.new("Frame",bg)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BorderSizePixel = 0
    Instance.new("UICorner",bar)
    local grad = Instance.new("UIGradient",bar)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,120,255)), ColorSequenceKeypoint.new(.5,Color3.fromRGB(180,50,230)), ColorSequenceKeypoint.new(1,Color3.fromRGB(255,120,255))})
    return bar
end

local function fill(bar,time)
    bar:TweenSize(UDim2.new(1,0,1,0),"InOut","Linear",time,true)
    task.delay(time,function() if bar then bar.Size=UDim2.new(0,0,1,0) end end)
end

-- GUI
local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.Name = "ELIXIRSTORE"
local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,360,0,300)
frame.Position = UDim2.new(.5,0,.5,0)
frame.AnchorPoint = Vector2.new(.5,.5)
frame.BackgroundColor3 = Color3.fromRGB(25,0,55)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency=1
title.Text="ELIXIRSTORE"
title.Font=Enum.Font.GothamBold
title.TextSize=20
title.TextColor3=Color3.fromRGB(255,255,255)

-- CLOSE
local close = Instance.new("TextButton",frame)
close.Size=UDim2.new(0,25,0,25)
close.Position=UDim2.new(1,-30,0,3)
close.Text="×"
close.Font=Enum.Font.GothamBold
close.TextSize=18
close.BackgroundColor3=Color3.fromRGB(120,0,180)
close.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",close)
close.MouseButton1Click:Connect(function() running=false gui:Destroy() end)

-- TABS
local tabFrame = Instance.new("Frame",frame)
tabFrame.Size=UDim2.new(1,0,0,30)
tabFrame.Position=UDim2.new(0,0,0,35)
tabFrame.BackgroundTransparency=1

local function createTab(name,x)
    local btn = Instance.new("TextButton",tabFrame)
    btn.Size=UDim2.new(0,100,1,0)
    btn.Position=UDim2.new(0,x,0,0)
    btn.Text=name
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=14
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.BackgroundColor3=Color3.fromRGB(50,0,100)
    btn.BorderSizePixel=0
    return btn
end

local farmTab = createTab("FARM",10)
local statusTab = createTab("STATUS",120)

-- CONTAINERS
local farmContainer = Instance.new("Frame",frame)
farmContainer.Size=UDim2.new(1,-20,1,-70)
farmContainer.Position=UDim2.new(0,10,0,70)
farmContainer.BackgroundTransparency=1

local statusContainer = Instance.new("Frame",frame)
statusContainer.Size=UDim2.new(1,-20,1,-70)
statusContainer.Position=UDim2.new(0,10,0,70)
statusContainer.BackgroundTransparency=1
statusContainer.Visible=false

local function switchTab(tab)
    if tab=="FARM" then farmContainer.Visible=true statusContainer.Visible=false
    elseif tab=="STATUS" then farmContainer.Visible=false statusContainer.Visible=true end
end
farmTab.MouseButton1Click:Connect(function() switchTab("FARM") end)
statusTab.MouseButton1Click:Connect(function() switchTab("STATUS") end)

-- FARM GUI
local statusLabel = createLabel(farmContainer,"Status: STOPPED",0)
local items = {"Water","Sugar Block Bag","Gelatin","Empty Bag"}
local emojis = {"💧","🍬","🍮","👜"}
local labels, bars = {}, {}
for i,name in ipairs(items) do
    labels[name]=createLabel(farmContainer,emojis[i].." "..name..": 0",30+(i-1)*25)
    bars[name]=createBar(farmContainer,48+(i-1)*25)
end

local toggle = Instance.new("TextButton",farmContainer)
toggle.Size=UDim2.new(0,70,0,26)
toggle.Position=UDim2.new(.5,-35,1,-50)
toggle.Text="AUTO"
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=14
toggle.BackgroundColor3=Color3.fromRGB(80,0,150)
toggle.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",toggle)

toggle.MouseButton1Click:Connect(function()
    running = not running
    toggle.BackgroundColor3 = running and Color3.fromRGB(0,200,120) or Color3.fromRGB(80,0,150)
    statusLabel.Text = running and "Status: RUNNING" or "Status: STOPPED"
    if running then task.spawn(function()
        while running do
            for _,name in ipairs(items) do
                if equip(name) then
                    statusLabel.Text="Cooking "..name
                    fill(bars[name],name=="Water" and 20 or 1)
                    holdE(.7)
                    task.wait(name=="Water" and 20 or 1)
                end
            end
            fill(bars["Empty Bag"],45)
            statusLabel.Text="Waiting Marshmallow"
            task.wait(45)
            if equip("Empty Bag") then
                statusLabel.Text="Collecting"
                holdE(.7)
                task.wait(1)
            end
            statusLabel.Text="Idle"
            task.wait(.5)
        end
    end) end
end)

-- UPDATE COUNTERS
task.spawn(function()
    while gui.Parent do
        for i,name in ipairs(items) do
            labels[name].Text=emojis[i].." "..name..": "..countItem(name)
        end
        task.wait(.5)
    end
end)

-- STATUS TAB CONTENT
createLabel(statusContainer,"Player: "..player.Name,0)
local sItems = {"Marshmallow","Water","Sugar","Gelatin","AutoFarm"}
for i,name in ipairs(sItems) do
    createLabel(statusContainer,name..": 0",30+(i-1)*25)
end

-- HIDE/SHOW GUI (P)
ContextActionService:BindAction("toggleUI",function(_,state)
    if state==Enum.UserInputState.Begin then frame.Visible=not frame.Visible end
end,false,Enum.KeyCode.P)
