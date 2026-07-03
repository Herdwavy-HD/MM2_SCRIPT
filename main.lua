print("--- Herdwavy's Hub Auto-Enable Edition Loaded ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- ВЕРНУЛИ НАСТРОЙКИ: ТЕПЕРЬ ВСЁ ВКЛЮЧЕНО ПО УМОЛЧАНИЮ НА СТАРТЕ!
local espEnabled = true
local gunEspEnabled = true
local heartbeatConnection = nil

-- ЛОГИКА ESP (ИГРОКИ)
local function removeOldESP(character)
    local oldHighlight = character:FindFirstChild("PlayerChams")
    if oldHighlight then oldHighlight:Destroy() end
end

local function applyCustomESP(player)
    if not espEnabled or player == localPlayer then return end
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local espColor = Color3.fromRGB(0, 255, 0)
    local backpack = player:FindFirstChild("Backpack")
    local hasKnife = character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
    local hasGun = character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
    
    if hasKnife then espColor = Color3.fromRGB(255, 0, 0)
    elseif hasGun then espColor = Color3.fromRGB(0, 0, 255) end
    
    local currentHighlight = character:FindFirstChild("PlayerChams")
    if not currentHighlight or currentHighlight.FillColor ~= espColor then
        removeOldESP(character)
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerChams"
        highlight.FillColor = espColor
        highlight.FillTransparency = 0.75
        highlight.OutlineColor = espColor
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
    end
end

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                for _, p in pairs(Players:GetPlayers()) do pcall(applyCustomESP, p) end
            end)
        end
    else
        if heartbeatConnection then 
            heartbeatConnection:Disconnect() 
            heartbeatConnection = nil
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then removeOldESP(p.Character) end
        end
    end
end

-- АВТО-СТАРТ ПОТОКА ДЛЯ ИГРОКОВ ПРИ ЗАПУСКЕ
toggleESP(true)

-- ЛОГИКА ESP (ПИСТОЛЕТ)
task.spawn(function()
    while true do
        task.wait(0.5)
        local droppedGun = workspace:FindFirstChild("GunDrop", true)
        if gunEspEnabled and droppedGun then
            if not droppedGun:FindFirstChild("GunHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GunHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 255)
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = droppedGun
            end
        elseif not gunEspEnabled and droppedGun then
            local oldGunHigh = droppedGun:FindFirstChild("GunHighlight")
            if oldGunHigh then oldGunHigh:Destroy() end
        end
    end
end)

-- ==========================================================
--               ТВОЯ СТАРАЯ ПРОСТОРНАЯ МЕНЮШКА
-- ==========================================================

if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavysHubGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 30, 30)
stroke.Thickness = 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 6

local Logo = Instance.new("TextLabel", TopBar)
Logo.Size = UDim2.new(0, 200, 1, 0)
Logo.Position = UDim2.new(0, 20, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "Herdwavy's Hub"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 16
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.ZIndex = 7

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 5)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.ZIndex = 10

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -40, 1, -60)
Content.Position = UDim2.new(0, 20, 0, 50)
Content.BackgroundTransparency = 1
Content.ZIndex = 6

local function createToggle(name, yPos, startActive, callback)
    local Card = Instance.new("Frame", Content)
    Card.Size = UDim2.new(1, 0, 0, 55)
    Card.Position = UDim2.new(0, 0, 0, yPos)
    Card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Card.BorderSizePixel = 0
    Card.ZIndex = 7
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

    local Lbl = Instance.new("TextLabel", Card)
    Lbl.Size = UDim2.new(0, 300, 1, 0)
    Lbl.Position = UDim2.new(0, 15, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextSize = 14
    Lbl.ZIndex = 8
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Card)
    Switch.Size = UDim2.new(0, 48, 0, 26)
    Switch.Position = UDim2.new(1, -65, 0.5, -13)
    Switch.Text = ""
    Switch.ZIndex = 15
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame", Switch)
    Dot.Size = Vector2.new(20, 20)
    Dot.BorderSizePixel = 0
    Dot.ZIndex = 16
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    -- Настраиваем визуальное положение тумблера в зависимости от дефолтного статуса (ВКЛ)
    local active = startActive
    if active then
        Switch.BackgroundColor3 = Color3.fromRGB(255, 30, 30) -- Красный неон (ВКЛ)
        Dot.Position = UDim2.new(1, -23, 0.5, -10)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    else
        Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Dot.Position = UDim2.new(0, 3, 0.5, -10)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end

    Switch.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        if active then
            Switch.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
            Dot:TweenPosition(UDim2.new(1, -23, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Dot:TweenPosition(UDim2.new(0, 3, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12)
        end
    end)
end

-- Спавним тумблеры и передаем им статус true (включено по умолчанию)
createToggle("Player ESP (Chams)", 5, true, function(s) toggleESP(s) end)
createToggle("Dropped Gun ESP", 70, true, function(s) gunEspEnabled = s end)

local TglBtn = Instance.new("TextButton", ScreenGui)
TglBtn.Size = UDim2.new(0, 45, 0, 45)
TglBtn.Position = UDim2.new(0, 15, 0, 15)
TglBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
TglBtn.Text = "H"
TglBtn.TextColor3 = Color3.fromRGB(255, 30, 30)
TglBtn.Font = Enum.Font.GothamBold
TglBtn.TextSize = 22
TglBtn.ZIndex = 100

local tStroke = Instance.new("UIStroke", TglBtn)
tStroke.Color = Color3.fromRGB(255, 30, 30)
tStroke.Thickness = 2
Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)

local function tVis()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        TglBtn.TextColor3 = Color3.fromRGB(255, 30, 30)
        tStroke.Color = Color3.fromRGB(255, 30, 30)
    else
        TglBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
        tStroke.Color = Color3.fromRGB(50, 50, 50)
    end
end

TglBtn.MouseButton1Click:Connect(tVis)
MinimizeBtn.MouseButton1Click:Connect(tVis)
