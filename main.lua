print("--- HERDWAVY'S ADVANCED MULTI-SEED SHOP LAUNCHED ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

-- ТАБЛИЦА ВСЕХ ИГРОВЫХ СЕМЯН (С точными ID из кода игры)
local seedList = {
    "Basic Seed", "Tomato Seed", "Apple Seed", "Carrot Seed", 
    "Bamboo Seed", "Golden Seed", "Diamond Seed", "Magic Seed"
}

local selectedSeeds = {} -- Здесь хранятся выбранные галочками семена
_G.BuyAmount = 10
_G.IsBuying = false

-- Глобальный агрессивный поиск сетевого триггера покупки
local buyRemote = nil
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") and (string.find(string.lower(obj.Name), "buy") or string.find(string.lower(obj.Name), "shop")) then
        buyRemote = obj
        break
    end
end

local function startMultiBuying()
    if not buyRemote then 
        print("Ошибка: Сетевой триггер покупки не обнаружен!")
        return 
    end
    
    task.spawn(function()
        -- Цикл по количеству закупщика
        for i = 1, _G.BuyAmount do
            if not _G.IsBuying then break end
            
            -- Скупаем ВСЕ семена, которые пользователь отметил галочкой
            for seedName, isSelected in pairs(selectedSeeds) do
                if isSelected then
                    pcall(function() 
                        buyRemote:FireServer(seedName, 1) 
                    end)
                end
            end
            task.wait(0.05) -- Защита от кика за спам пакетами
        end
        _G.IsBuying = false
        print("Мульти-покупка успешно завершена!")
    end)
end

-- ==========================================================
--               ИНТЕРФЕЙС GUI (КРАСНЫЙ НЕОН С ПРОКРУТКОЙ)
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 340, 0, 340) -- Увеличили размер под список
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 30, 30)
stroke.Thickness = 2

local Logo = Instance.new("TextLabel", MainFrame)
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.Text = "Herdwavy's Multi-Seed Shop"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.BackgroundTransparency = 1

-- 📜 ОКНО ПРОКРУТКИ ДЛЯ ВЫБОРА СЕМЯН (ScrollingFrame)
local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -40, 0, 150)
ScrollList.Position = UDim2.new(0, 20, 0, 45)
ScrollList.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ScrollList.BorderSizePixel = 0
ScrollList.CanvasSize = UDim2.new(0, 0, 0, #seedList * 35) -- Авто-размер под количество семян
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
Instance.new("UICorner", ScrollList).CornerRadius = UDim.new(0, 6)

-- Авто-выравнивание элементов в списке
local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Генерируем строчки семян с кнопками-галочками
for _, seedName in pairs(seedList) do
    selectedSeeds[seedName] = false -- Изначально семя не выбрано
    
    local SeedRow = Instance.new("Frame", ScrollList)
    SeedRow.Size = UDim2.new(1, -10, 0, 30)
    SeedRow.BackgroundTransparency = 1
    
    local SeedNameLabel = Instance.new("TextLabel", SeedRow)
    SeedNameLabel.Size = UDim2.new(1, -50, 1, 0)
    SeedNameLabel.Position = UDim2.new(0, 10, 0, 0)
    SeedNameLabel.BackgroundTransparency = 1
    SeedNameLabel.Text = seedName
    SeedNameLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
    SeedNameLabel.Font = Enum.Font.GothamMedium
    SeedNameLabel.TextSize = 12
    SeedNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Маленькая квадратная кнопка-чекбокс
    local CheckBox = Instance.new("TextButton", SeedRow)
    CheckBox.Size = UDim2.new(0, 20, 0, 20)
    CheckBox.Position = UDim2.new(1, -30, 0.5, -10)
    CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    CheckBox.Text = ""
    Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 4)
    
    CheckBox.MouseButton1Click:Connect(function()
        selectedSeeds[seedName] = not selectedSeeds[seedName]
        if selectedSeeds[seedName] then
            CheckBox.BackgroundColor3 = Color3.fromRGB(255, 30, 30) -- Загорается красным при выборе
            CheckBox.Text = "✓"
            CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            CheckBox.Text = ""
        end
    end)
end

-- ПОЛЕ ВВОДА: Количество закупки
local AmountInput = Instance.new("TextBox", MainFrame)
AmountInput.Size = UDim2.new(1, -40, 0, 35)
AmountInput.Position = UDim2.new(0, 20, 0, 215)
AmountInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AmountInput.Text = "10"
AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountInput.Font = Enum.Font.GothamMedium
AmountInput.TextSize = 13
Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

-- КНОПКА СТАРТА МУЛЬТИ-ЗАКУПКИ
local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(1, -40, 0, 45)
BuyBtn.Position = UDim2.new(0, 20, 0, 265)
BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
BuyBtn.Text = "ЗАПУСТИТЬ МУЛЬТИ-ПОКУПКУ"
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 14
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.BuyAmount = tonumber(AmountInput.Text) or 10
        _G.IsBuying = true
        startMultiBuying()
    end
end)
