print("--- PRO ESP BY ARSLAN ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- 🎯 СОВРЕМЕННЫЙ ПОИСК ПИСТОЛЕТА НА ПОЛУ
task.spawn(function()
    while true do
        task.wait(1)
        -- Находим объект GunDrop на любой глубине карты через FindFirstChild с параметром true
        local droppedGun = workspace:FindFirstChild("GunDrop", true)
        if droppedGun and not droppedGun:FindFirstChild("GunHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "GunHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 255) -- Фиолетовое неоновое сияние
            highlight.FillTransparency = 0.3
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка по контуру песта
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видно сквозь любые стены
            highlight.Parent = droppedGun
        end
    end
end)

-- 🎯 УЛЬТРА ESP ДЛЯ ИГРОКОВ (ПОЛУПРОЗРАЧНЫЙ CHAMS)
local function applyESP(player)
    if player == localPlayer then return end
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local espColor = Color3.fromRGB(0, 255, 0) -- Зеленый (Мирный) по умолчанию
        
        -- Проверка инвентаря на роли
        local backpack = player:FindFirstChild("Backpack")
        if character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
            espColor = Color3.fromRGB(255, 0, 0) -- Красный (Мардер)
        elseif character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
            espColor = Color3.fromRGB(0, 0, 255) -- Синий (Шериф)
        end
        
        local currentHighlight = character:FindFirstChild("PlayerChams")
        if not currentHighlight or currentHighlight.FillColor ~= espColor then
            if currentHighlight then currentHighlight:Destroy() end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "PlayerChams"
            highlight.FillColor = espColor
            highlight.FillTransparency = 0.75 -- Скин игрока отлично просматривается
            highlight.OutlineColor = espColor
            highlight.OutlineTransparency = 0.2 -- Четкий яркий силуэт за стеной
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
        end
    end
end

-- Обновление персонажей каждый кадр игры
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        pcall(applyESP, p)
    end
end)

-- Ускорение на левый Shift для быстрого бега за пушкой
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
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
