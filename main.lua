-- ==========================================================
-- ЧАСТЬ 1: СЕРВИСЫ, НАСТРОЙКИ И ЛОГИКА СИЛУЭТОВ (ESP)
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

if game.PlaceId == 14237195049 then
local selfEsp, playerEsp = false, false
local selfHb, playerHb = nil, nil
local infJump, noclip, antiAfkEnabled = false, false, false

local function drawHighlight(target, name, color, fillTrans)
    if target and not target:FindFirstChild(name) then
        local hl = Instance.new("Highlight", target)
        hl.Name = name
        hl.FillColor = color
        hl.FillTransparency = fillTrans
        hl.OutlineColor = color
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function toggleSelfESP(state)
    selfEsp = state
    if selfEsp then
        selfHb = RunService.Heartbeat:Connect(function()
            pcall(drawHighlight, localPlayer.Character, "SelfChams", Color3.new(1,1,1), 0.4)
        end)
    else
        if selfHb then selfHb:Disconnect() selfHb = nil end
        if localPlayer.Character and localPlayer.Character:FindFirstChild("SelfChams") then
            localPlayer.Character.SelfChams:Destroy()
        end
    end
end

local function togglePlayerESP(state)
    playerEsp = state
    if playerEsp then
        playerHb = RunService.Heartbeat:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    pcall(drawHighlight, p.Character, "PlayerChams", Color3.new(1,0,0), 0.6)
                end
            end
        end)
    else
        if playerHb then playerHb:Disconnect() playerHb = nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlayerChams") then
                p.Character.PlayerChams:Destroy()
            end
        end
    end
end
-- ==========================================================
-- ЧАСТЬ 2: ХАКИ ДВИЖЕНИЯ И УЗКИЕ ПРЯМОУГОЛЬНЫЕ КНОПКИ В УГЛУ
-- ==========================================================
UserInputService.JumpRequest:Connect(function()
    if infJump and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

RunService.Stepped:Connect(function()
    if noclip and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "HerdwavysHubGui"

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Active = true MainFrame.Draggable = true MainFrame.ZIndex = 5

local mCorner = Instance.new("UICorner", MainFrame)
mCorner.CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 30, 30)

local SidePanel = Instance.new("Frame", MainFrame)
SidePanel.Size = UDim2.new(0, 170, 1, 0)
SidePanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SidePanel.ZIndex = 10
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 14)

local Logo = Instance.new("TextLabel", SidePanel)
Logo.Size = UDim2.new(1, 0, 0, 50) Logo.Position = UDim2.new(0, 0, 0, 15) Logo.BackgroundTransparency = 1
Logo.Text = "Herdwavy's Hub" Logo.TextColor3 = Color3.new(1, 1, 1) Logo.Font = Enum.Font.GothamBold Logo.TextSize = 16 Logo.ZIndex = 11

-- Идеальные виндовс-прямоугольники (низкие и широкие) строго в верхний правый край рамки
local ControlBox = Instance.new("Frame", MainFrame)
ControlBox.Size = UDim2.new(0, 150, 0, 20) 
ControlBox.Position = UDim2.new(1, -165, 0, 4) 
ControlBox.BackgroundTransparency = 1 ControlBox.ZIndex = 30

local function createWinButton(text, offset, color, callback)
    local btn = Instance.new("TextButton", ControlBox)
    btn.Size = UDim2.new(0, 44, 0, 16) 
    btn.Position = UDim2.new(0, offset, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30) btn.Text = text btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold btn.TextSize = 10 btn.ZIndex = 31
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Down:Connect(callback)
end

createWinButton("—", 0, Color3.new(0.8, 0.8, 0.8), function() MainFrame.Visible = false end)
local isMaximized = false
createWinButton("🗖", 48, Color3.new(0.8, 0.8, 0.8), function()
    isMaximized = not isMaximized
    if isMaximized then
        MainFrame.Size = UDim2.new(1, 0, 1, 0) MainFrame.Position = UDim2.new(0, 0, 0, 0) mCorner.CornerRadius = UDim.new(0, 0)
    else
        MainFrame.Size = UDim2.new(0, 640, 0, 420) MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210) mCorner.CornerRadius = UDim.new(0, 14)
    end
end)
createWinButton("X", 96, Color3.new(1, 0.2, 0.2), function() Gui:Destroy() end)
-- ==========================================================
-- ЧАСТЬ 3: ГЕНЕРАЦИЯ 6 ВКЛАДОК И СПИСКОВ МАГАЗИНОВ
-- ==========================================================
local pages, tabs = {}, {}

local function createPage(name, order)
    local p = Instance.new("Frame", MainFrame)
    p.Size = UDim2.new(1, -195, 1, -40) p.Position = UDim2.new(0, 185, 0, 20)
    p.BackgroundTransparency = 1 p.ZIndex = 10 p.Visible = (order == 1)
    pages[order] = p

    local t = Instance.new("TextButton", SidePanel)
    t.Size = UDim2.new(0, 150, 0, 30) t.Position = UDim2.new(0, 10, 0, 55 + (order * 34))
    t.BackgroundColor3 = (order == 1) and Color3.fromRGB(35, 15, 15) or Color3.new(0, 0, 0)
    t.BackgroundTransparency = (order == 1) and 0 or 1
    t.Text = name 
    t.TextColor3 = Color3.fromRGB(255, 255, 255) -- ТЕКСТ ВСЕГДА БЕЛЫЙ И ЧИТАЕМЫЙ
    t.Font = Enum.Font.GothamBold t.TextSize = 11 t.ZIndex = 20
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", t)
    stroke.Color = (order == 1) and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(40, 40, 45)
    stroke.Thickness = (order == 1) and 1.5 or 1
    tabs[order] = {btn = t, st = stroke}

    t.MouseButton1Down:Connect(function()
        for i, pg in pairs(pages) do
            pg.Visible = (i == order)
            tabs[i].btn.BackgroundColor3 = (i == order) and Color3.fromRGB(35, 15, 15) or Color3.new(0, 0, 0)
            tabs[i].btn.BackgroundTransparency = (i == order) and 0 or 1
            tabs[i].st.Color = (i == order) and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(40, 40, 45)
            tabs[i].st.Thickness = (i == order) and 1.5 or 1
        end
    end)
    return p
end

local pSeeds = createPage("Seeds Shop", 1)
local pCrates = createPage("Crates Shop", 2)
local pGear = createPage("Gear Shop", 3)
local pVis = createPage("Visuals ESP", 4)
local pTweaks = createPage("Player Tweaks", 5)
local pFun = createPage("Server Fun", 6)

local function fillList(p, list, infoText)
    local SL = Instance.new("ScrollingFrame", p)
    SL.Size = UDim2.new(1, 0, 1, -65) SL.Position = UDim2.new(0, 0, 0, 5)
    SL.BackgroundColor3 = Color3.fromRGB(18, 18, 22) SL.BorderSizePixel = 0
    SL.CanvasSize = UDim2.new(0, 0, 0, #list * 32) SL.ScrollBarThickness = 4
    SL.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30) SL.ZIndex = 15
    Instance.new("UICorner", SL).CornerRadius = UDim.new(0, 8)
    Instance.new("UIListLayout", SL).SortOrder = Enum.SortOrder.LayoutOrder

    for _, itemName in pairs(list) do
        local row = Instance.new("Frame", SL)
        row.Size = UDim2.new(1, -10, 0, 30) row.BackgroundTransparency = 1 row.ZIndex = 16

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -50, 1, 0) lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1 lbl.Text = itemName lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
        lbl.Font = Enum.Font.GothamMedium lbl.TextSize = 11 lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 17

        local cb = Instance.new("TextButton", row)
        cb.Size = UDim2.new(0, 44, 0, 22) cb.Position = UDim2.new(1, -60, 0.5, -11)
        cb.BackgroundColor3 = Color3.fromRGB(45, 45, 50) cb.Text = "" cb.ZIndex = 50
        Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame", cb)
        dot.Size = UDim2.new(0, 14, 0, 14) dot.Position = UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.new(1, 1, 1) dot.ZIndex = 51
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local active = false
        cb.MouseButton1Down:Connect(function()
            active = not active
            cb.BackgroundColor3 = active and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(45, 45, 50)
            dot:TweenPosition(UDim2.new(0, active and 27 or 3, 0.5, -7), 0, 0, 0.12)
        end)
    end

    local Inp = Instance.new("TextBox", p)
    Inp.Size = UDim2.new(0, 70, 0, 30) Inp.Position = UDim2.new(0, 0, 1, -32)
    Inp.BackgroundColor3 = Color3.fromRGB(22, 22, 26) Inp.Text = "10" Inp.TextColor3 = Color3.new(1, 1, 1)
    Inp.Font = Enum.Font.GothamMedium Inp.TextSize = 12 Inp.ZIndex = 25
    Instance.new("UICorner", Inp).CornerRadius = UDim.new(0, 6)

    local ActionBtn = Instance.new("TextButton", p)
    ActionBtn.Size = UDim2.new(1, -80, 0, 30) ActionBtn.Position = UDim2.new(0, 80, 1, -32)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) ActionBtn.Text = infoText
    ActionBtn.TextColor3 = Color3.fromRGB(150, 150, 150) ActionBtn.Font = Enum.Font.GothamBold ActionBtn.TextSize = 10 ActionBtn.ZIndex = 25
    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)
end

fillList(pSeeds, {"Carrot","Strawberry","Blueberry","Tulip","Tomato","Apple","Corn","Bamboo","Cactus","Baby Cactus","Pineapple","Mushroom","Green Bean","Banana","Grape","Coconut","Mango","Dragon Fruit","Acorn","Cherry","Sunflower","Briar Rose","Venus Fly Trap","Pomegranate","Poison Apple","Venom Spitter","Moon Bloom","Hypno Bloom","Dragon's Breath"}, "ОЖИДАНИЕ ОБНОВЛЕНИЯ РОНИКСА/СОЛАРЫ (SEEDS)")
fillList(pCrates, {"Common Crate","Uncommon Crate","Rare Crate","Epic Crate","Legendary Crate","Exclusive Seed Pack"}, "ОЖИДАНИЕ ОБНОВЛЕНИЯ РОНИКСА/СОЛАРЫ (CRATES)")
fillList(pGear, {"Basic Watering Can","Golden Watering Can","Diamond Watering Can","Basic Shovel","Titanium Shovel","Pro Harvester","Auto-Waterer Node"}, "ОЖИДАНИЕ ОБНОВЛЕНИЯ РОНИКСА/СОЛАРЫ (GEAR)")
-- ==========================================================
-- ЧАСТЬ 4: КОНСТРУКТОРЫ ТУМБЛЕРОВ, СЛАЙДЕРОВ, REJOIN И HOP
-- ==========================================================
local function createToggleRow(page, title, yOffset, callback)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 45) card.Position = UDim2.new(0, 0, 0, yOffset)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26) card.ZIndex = 15
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 230, 1, 0) label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1 label.Text = title label.TextColor3 = Color3.fromRGB(230, 230, 235)
    label.Font = Enum.Font.GothamMedium label.TextSize = 11 label.TextXAlignment = Enum.TextXAlignment.Left label.ZIndex = 16

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(0, 44, 0, 22) btn.Position = UDim2.new(1, -60, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) btn.Text = "" btn.ZIndex = 100
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 14, 0, 14) dot.Position = UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1) dot.ZIndex = 101
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local isToggled = false
    btn.MouseButton1Down:Connect(function()
        isToggled = not isToggled
        callback(isToggled)
        btn.BackgroundColor3 = isToggled and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(45, 45, 50)
        dot:TweenPosition(UDim2.new(0, isToggled and 27 or 3, 0.5, -7), 0, 0, 0.12)
    end)
end

createToggleRow(pVis, "Self ESP (White Chams)", 5, toggleSelfESP)
createToggleRow(pVis, "Player ESP (Red Chams)", 55, togglePlayerESP)

-- АНТИ-AFK НА ПЕРВОМ МЕСТЕ В PLAYER TWEAKS!
createToggleRow(pTweaks, "Anti-AFK (Защита от афк киков)", 5, function(s) antiAfkEnabled = s end)
createToggleRow(pTweaks, "Infinite Jump (Бесконечный прыжок)", 55, function(s) infJump = s end)
createToggleRow(pTweaks, "Noclip (Хождение сквозь стены)", 105, function(s) noclip = s end)

local function createSliderRow(page, title, yOffset, min, max, default, callback)
    local card = Instance.new("Frame", page)
    card.Size = UDim2.new(1, 0, 0, 45) card.Position = UDim2.new(0, 0, 0, yOffset)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 26) card.ZIndex = 15
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", card)
    label.Size = UDim2.new(0, 180, 1, 0) label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1 label.Text = title .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(230, 230, 235) label.Font = Enum.Font.GothamMedium label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left label.ZIndex = 16

    local bar = Instance.new("TextButton", card)
    bar.Size = UDim2.new(1, -240, 0, 6) bar.Position = UDim2.new(0, 200, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50) bar.Text = "" bar.ZIndex = 16
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 30, 30) fill.BorderSizePixel = 0 fill.ZIndex = 17
    Instance.new("UICorner", fill)

    local sliding = false
    local function updateSlider()
        local mouseX = math.clamp((localPlayer:GetMouse().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(mouseX, 0, 1, 0)
        local value = math.floor(min + (mouseX * (max - min)))
        label.Text = title .. ": " .. tostring(value)
        callback(value)
    end

    bar.MouseButton1Down:Connect(function() sliding = true updateSlider() end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    RunService.Heartbeat:Connect(function() if sliding then pcall(updateSlider) end end)
end

createSliderRow(pTweaks, "WalkSpeed (Скорость)", 155, 16, 250, 16, function(v)
    if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)

createSliderRow(pTweaks, "JumpPower (Прыжок)", 205, 50, 350, 50, function(v)
    if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        localPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
        localPlayer.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true
    end
end)

local function createActionButton(page, title, yOffset, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 40) btn.Position = UDim2.new(0, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26) btn.Text = title btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold btn.TextSize = 11 btn.ZIndex = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(45, 45, 50)
    btn.MouseButton1Down:Connect(callback)
end

createActionButton(pFun, "Rejoin (Быстрый перезаход на сервер)", 5, function()
    if #game:GetService("Players"):GetPlayers() <= 1 then
        game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
    else
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
    end
end)

createActionButton(pFun, "Server Hop (Прыгнуть на другой сервер)", 50, function()
    local sf = {}
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=20"))
    for _, s in pairs(x.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(sf, s.id) end
    end
    if #sf > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, sf[math.random(1, #sf)], localPlayer)
    else
        game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
    end
end)

pcall(function()
    localPlayer.Idled:Connect(function()
        if antiAfkEnabled then
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end)
end)

local Tgl = Instance.new("TextButton", Gui)
Tgl.Size = UDim2.new(0, 45, 0, 45) Tgl.Position = UDim2.new(0, 15, 0, 15)
Tgl.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Tgl.Text = "H" Tgl.TextColor3 = Color3.fromRGB(255, 30, 30)
Tgl.Font = Enum.Font.GothamBold Tgl.TextSize = 22 Tgl.ZIndex = 100

local tSt = Instance.new("UIStroke", Tgl) tSt.Color = Color3.fromRGB(255, 30, 30) tSt.Thickness = 2
Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)

Tgl.MouseButton1Down:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    Tgl.TextColor3 = MainFrame.Visible and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(120, 120, 120)
    tSt.Color = MainFrame.Visible and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(50, 50, 50)
end)
elseif game.PlaceId == 142823291 or game.PlaceId == 66654135 or game.PlaceId == 11217730461 then
-- ==========================================================
--             ЗАПУСК ХАБА ДЛЯ MURDER MYSTERY 2
-- ==========================================================
print("--- ММ2 МОД ЗАПУЩЕН ---")
local function gC(p)
    if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then 
        return Color3.new(1,0,0)
    elseif p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then 
        return Color3.new(0,0,1)
    end 
    return Color3.new(0,1,0)
end

RunService.Heartbeat:Connect(function()
    for _,p in pairs(Players:GetPlayers()) do 
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            local c = gC(p)
            if not p.Character:FindFirstChild("RoleHighlight") then 
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "RoleHighlight" hl.FillColor = c hl.FillTransparency = 0.5 hl.OutlineColor = c hl.DepthMode = 0 
            else 
                p.Character.RoleHighlight.FillColor = c p.Character.RoleHighlight.OutlineColor = c 
            end 
        end 
    end 
end)

task.spawn(function()
    while task.wait(0.2) do 
        pcall(function()
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                for _,c in pairs(workspace:GetDescendants()) do 
                    if c.Name == "Coin_C" and c:IsA("BasePart") then 
                        localPlayer.Character.HumanoidRootPart.CFrame = c.CFrame task.wait(0.05)
                    end 
                end 
            end 
        end)
    end 
end)
end
