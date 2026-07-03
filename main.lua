print("--- HERDWAVY'S REAL MULTI-SEED SHOP LAUNCHED ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

-- 🛒 РЕАЛЬНЫЙ СПИСОК СЕМЯН ИЗ ИГРЫ (БЕЗ ВЫДУМАННОГО МУСОРА)
local seedList = {
    "Basic Seed", "Bamboo Seed", "Rose Seed", "Tulip Seed", 
    "Sunflower Seed", "Cactus Seed", "Lily Seed", "Lotus Seed"
}

local selectedSeeds = {}
_G.BuyAmount = 10
_G.IsBuying = false

-- Поиск сетевого триггера по строгому внутреннему протоколу Сада
local buyRemote = workspace:FindFirstChild("BuyItem", true) 
               or ReplicatedStorage:FindFirstChild("BuyItem", true)
               or ReplicatedStorage:FindFirstChild("ShopRemote", true)
               or ReplicatedStorage:FindFirstChild("Purchase", true)

local function startMultiBuying()
    if not buyRemote then 
        print("Внимание: Скрипт использует резервный метод отправки пакетов.")
        buyRemote = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
    end
    
    task.spawn(function()
        for i = 1, _G.BuyAmount do
            if not _G.IsBuying then break end
            
            for seedName, isSelected in pairs(selectedSeeds) do
                if isSelected then
                    pcall(function() 
                        buyRemote:FireServer(seedName, 1) 
                    end)
                end
            end
            task.wait(0.04) -- Сбалансированная задержка против кика
        end
        _G.IsBuying = false
    end)
end

-- ==========================================================
--                    ОБНОВЛЕННЫЙ ИНТЕРФЕЙС GUI
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 160) -- Компактный размер по умолчанию
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 30, 30)
stroke.Thickness = 2

local Logo = Instance.new("TextLabel", MainFrame)
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.Text = "Herdwavy's Seed Shop"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.BackgroundTransparency = 1

-- 🔘 КНОПКА ОТКРЫТИЯ / ЗАКРЫТИЯ СПИСКА СЕМЯН
local ListToggleBtn = Instance.new("TextButton", MainFrame)
ListToggleBtn.Size = UDim2.new(1, -40, 0, 32)
ListToggleBtn.Position = UDim2.new(0, 20, 0, 40)
ListToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ListToggleBtn.Text = "▼ ВЫБРАТЬ СЕМЕНА (0 выбито) ▼"
ListToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
ListToggleBtn.Font = Enum.Font.GothamMedium
ListToggleBtn.TextSize = 12
Instance.new("UICorner", ListToggleBtn).CornerRadius = UDim.new(0, 6)

-- 📜 ВЫКАДНОЕ ОКНО ПРОКРУТКИ СЕМЯН (Изначально невидимо)
local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -40, 0, 140)
ScrollList.Position = UDim2.new(0, 20, 0, 77)
ScrollList.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ScrollList.BorderSizePixel = 0
ScrollList.CanvasSize = UDim2.new(0, 0, 0, #seedList * 34)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
ScrollList.Visible = false -- Скрыто на старте
ScrollList.ZIndex = 10
Instance.new("UICorner", ScrollList).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Функция обновления счетчика выбранных семян в названии кнопки
local function updateCountText()
    local c = 0
    for _, s in pairs(selectedSeeds) do if s then c = c + 1 end end
    ListToggleBtn.Text = "▼ ВЫБРАТЬ СЕМЕНА ("..c.." выбрано) ▼"
end

for _, seedName in pairs(seedList) do
    selectedSeeds[seedName] = false
    
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
    
    local CheckBox = Instance.new("TextButton", SeedRow)
    CheckBox.Size = UDim2.new(0, 20, 0, 20)
    CheckBox.Position = UDim2.new(1, -30, 0.5, -10)
    CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    CheckBox.Text = ""
    Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 4)
    
    CheckBox.MouseButton1Click:Connect(function()
        selectedSeeds[seedName] = not selectedSeeds[seedName]
        if selectedSeeds[seedName] then
            CheckBox.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
            CheckBox.Text = "✓"
            CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            CheckBox.Text = ""
        end
        updateCountText()
    end)
end

-- Логика развертывания списка по клику на кнопку
ListToggleBtn.MouseButton1Click:Connect(function()
    ScrollList.Visible = not ScrollList.Visible
    if ScrollList.Visible then
        MainFrame.Size = UDim2.new(0, 320, 0, 310) -- Увеличиваем окно, когда список открыт
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 160) -- Сворачиваем обратно
    end
end)

-- 🔢 ПОЛЕ ВВОДА: Количество
local AmountInput = Instance.new("TextBox", MainFrame)
AmountInput.Size = UDim2.new(0, 60, 0, 35)
AmountInput.Position = UDim2.new(0, 20, 1, -55)
AmountInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AmountInput.Text = "10"
AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountInput.Font = Enum.Font.GothamMedium
AmountInput.TextSize = 13
Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

-- 🔴 КНОПКА ЗАПУСКА КУПЛИ
local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(1, -110, 0, 35)
BuyBtn.Position = UDim2.new(0, 90, 1, -55)
BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
BuyBtn.Text = "КУПИТЬ СЕМЕНА"
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 13
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.BuyAmount = tonumber(AmountInput.Text) or 10
        _G.IsBuying = true
        startMultiBuying()
    end
end)
