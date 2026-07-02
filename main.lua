print("--- Herdwavy's Hub LOADED ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

-- ПЕРЕМЕННЫЕ УПРАВЛЕНИЯ
local espEnabled = false
local gunEspEnabled = false
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

-- ПОДВЕТКА ПИСТОЛЕТА НА ЗЕМЛЕ
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
--               МИНИМАЛИСТИЧНЫЙ ИНТЕРФЕЙС (UI)
-- ==========================================================

if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HerdwavysHubGui"
ScreenGui.Parent = CoreGui

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 320) -- Немного уменьшили высоту, так как убрали лишний текст
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(114, 137, 218)
MainStroke.Thickness = 2.5
MainStroke.Parent = MainFrame

-- БОКОВАЯ ПАНЕЛЬ
local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 140, 1, 0)
SidePanel.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
SidePanel.BorderSizePixel = 0
SidePanel.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SidePanel

-- ЛОГОТИП С ТВОИМ ИМЕНЕМ (БЕЗ ВЕРСИЙ)
local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0, 60)
LogoText.Position = UDim2.new(0, 0, 0, 20)
LogoText.BackgroundTransparency = 1
LogoText.Text = "HERDWAVY'S\nHUB"
LogoText.TextColor3 = Color3.fromRGB(114, 137, 218)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 18
LogoText.Parent = SidePanel

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(0, 380, 0, 40)
MainTitle.Position = UDim2.new(0, 155, 0, 20)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "MURDER MYSTERY 2"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextSize = 16
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.Parent = MainFrame

-- КНОПКА 1: ESP ИГРОКОВ
local EspButton = Instance.new("TextButton")
EspButton.Size = UDim2.new(0, 360, 0, 55)
EspButton.Position = UDim2.new(0, 155, 0, 80)
EspButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
EspButton.Text = "ПОДСВЕТКА ИГРОКОВ (CHAMS): ВЫКЛ"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.GothamBold
EspButton.TextSize = 14
EspButton.Parent = MainFrame

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 8)
EspCorner.Parent = EspButton

EspButton.MouseButton1Click:Connect(function()
    if not espEnabled then
        toggleESP(true)
        EspButton.BackgroundColor3 = Color3.fromRGB(75, 180, 75)
        EspButton.Text = "ПОДСВЕТКА ИГРОКОВ (CHAMS): ВКЛ"
    else
        toggleESP(false)
        EspButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
        EspButton.Text = "ПОДСВЕТКА ИГРОКОВ (CHAMS): ВЫКЛ"
    end
end)

-- КНОПКА 2: ESP ПИСТОЛЕТА
local GunButton = Instance.new("TextButton")
GunButton.Size = UDim2.new(0, 360, 0, 55)
GunButton.Position = UDim2.new(0, 155, 0, 155)
GunButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
GunButton.Text = "ПОДСВЕТКА ПИСТОЛЕТА НА ПОЛУ: ВЫКЛ"
GunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GunButton.Font = Enum.Font.GothamBold
GunButton.TextSize = 14
GunButton.Parent = MainFrame

local GunCorner = Instance.new("UICorner")
GunCorner.CornerRadius = UDim.new(0, 8)
GunCorner.Parent = GunButton

GunButton.MouseButton1Click:Connect(function()
    gunEspEnabled = not gunEspEnabled
    if gunEspEnabled then
        GunButton.BackgroundColor3 = Color3.fromRGB(75, 180, 75)
        GunButton.Text = "ПОДСВЕТКА ПИСТОЛЕТА НА ПОЛУ: ВКЛ"
    else
        GunButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
        GunButton.Text = "ПОДСВЕТКА ПИСТОЛЕТА НА ПОЛУ: ВЫКЛ"
    end
end)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0, 360, 0, 40)
InfoLabel.Position = UDim2.new(0, 155, 0, 230)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Нажимай на кнопку 'H' в углу экрана, чтобы скрыть панель."
InfoLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
InfoLabel.Font = Enum.Font.SourceSansItalic
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

-- ==========================================================
--            КРУГЛАЯ КНОПКА «H» ДЛЯ СКРЫТИЯ МЕНЮ
-- ==========================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ToggleButton.Text = "H"
ToggleButton.TextColor3 = Color3.fromRGB(114, 137, 218)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(114, 137, 218)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.TextColor3 = Color3.fromRGB(114, 137, 218)
        ToggleStroke.Color = Color3.fromRGB(114, 137, 218)
    else
        ToggleButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        ToggleStroke.Color = Color3.fromRGB(60, 60, 65)
    end
end)
