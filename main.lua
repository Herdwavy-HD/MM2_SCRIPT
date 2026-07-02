print("--- ★ ARSLAN HUB WITH UI v2 LOADED ★ ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- ПЕРЕМЕННЫЕ УПРАВЛЕНИЯ
local espEnabled = false
local gunEspEnabled = false
local speedEnabled = false
local heartbeatConnection = nil

-- ФУНКЦИИ ЧИТА (ИГРОКИ)
local function removeOldESP(character)
    local oldHighlight = character:FindFirstChild("PlayerChams")
    if oldHighlight then oldHighlight:Destroy() end
end

local function applyCustomESP(player)
    if not espEnabled then return end
    if player == localPlayer then return end
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
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do pcall(applyCustomESP, p) end
        end)
    else
        if heartbeatConnection then heartbeatConnection:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then removeOldESP(p.Character) end
        end
    end
end

-- ПОТОК ДЛЯ ПОДВЕТКИ ПИСТОЛЕТА (ПРИВЯЗАН К КНОПКЕ МЕНЮ)
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
--                  СОЗДАНИЕ ИНТЕРФЕЙСА (UI)
-- ==========================================================

if CoreGui:FindFirstChild("ArslanHubGui") then CoreGui.ArslanHubGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArslanHubGui"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 235) -- Чуть увеличили высоту под 3 кнопки
MainFrame.Position = UDim2.new(0, 50, 0, 200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(114, 137, 218)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
Title.Text = "★ ARSLAN MM2 HUB ★"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- КНОПКА 1: ESP ИГРОКОВ
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0, 180, 0, 40)
EspButton.Position = UDim2.new(0, 20, 0, 50)
EspButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
EspButton.Text = "ESP Players: OFF"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 15
EspButton.Parent = MainFrame

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 6)
EspCorner.Parent = EspButton

EspButton.MouseButton1Click:Connect(function()
    if not espEnabled then
        toggleESP(true)
        EspButton.BackgroundColor3 = Color3.fromRGB(75, 180, 75)
        EspButton.Text = "ESP Players: ON"
    else
        toggleESP(false)
        EspButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
        EspButton.Text = "ESP Players: OFF"
    end
end)

-- КНОПКА 2: ESP ПИСТОЛЕТА НА ЗЕМЛЕ
local GunButton = Instance.new("TextButton")
GunButton.Size = UDim2.new(0, 180, 0, 40)
GunButton.Position = UDim2.new(0, 20, 0, 105)
GunButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
GunButton.Text = "ESP Dropped Gun: OFF"
GunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GunButton.Font = Enum.Font.SourceSansBold
GunButton.TextSize = 15
GunButton.Parent = MainFrame

local GunCorner = Instance.new("UICorner")
GunCorner.CornerRadius = UDim.new(0, 6)
GunCorner.Parent = GunButton

GunButton.MouseButton1Click:Connect(function()
    gunEspEnabled = not gunEspEnabled
    if gunEspEnabled then
        GunButton.BackgroundColor3 = Color3.fromRGB(75, 180, 75)
        GunButton.Text = "ESP Dropped Gun: ON"
    else
        GunButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
        GunButton.Text = "ESP Dropped Gun: OFF"
    end
end)

-- КНОПКА 3: СКОРОСТЬ SHIFT
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0, 180, 0, 40)
SpeedButton.Position = UDim2.new(0, 20, 0, 160)
SpeedButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
SpeedButton.Text = "Speed Hack (Shift): OFF"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.TextSize = 15
SpeedButton.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedButton

SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.BackgroundColor3 = Color3.fromRGB(75, 180, 75)
        SpeedButton.Text = "Speed Hack (Shift): ON"
    else
        SpeedButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
        SpeedButton.Text = "Speed Hack (Shift): OFF"
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not speedEnabled then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.WalkSpeed = 45 end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)
