print("--- Herdwavy's Premium UI Hub Loaded ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Авто-поиск триггера покупки в игре Grow a Garden 2
local buyRemote = ReplicatedStorage:FindFirstChild("Remote") and ReplicatedStorage.Remote:FindFirstChild("BuyItem") 
               or ReplicatedStorage:FindFirstChild("BuyItem", true)

-- 1. СКАЧИВАЕМ ПРОФЕССИОНАЛЬНУЮ БИБЛИОТЕКУ ИНТЕРФЕЙСА
local KavoUi = loadstring(game:HttpGet("https://githubusercontent.com"))()

-- 2. СОЗДАЕМ ГЛАВНОЕ ОКНО (В стиле темного неона, цвета настроим под тебя)
local Window = KavoUi.CreateLib("Herdwavy's Hub", "BloodTheme") -- Красно-черная премиум тема

-- 3. СОЗДАЕМ ВКЛАДКУ СЛЕВА
local MainTab = Window:NewTab("Garden Shop")
local Section = MainTab:NewSection("Seed Auto-Buy")

-- Переменные для закупки
local selectedSeedName = "Basic Seed"
local buyQuantity = 10

-- 4. СОЗДАЕМ СОВРЕМЕННЫЙ ВЫПАДАЮЩИЙ СПИСОК (DROPDOWN) КАК В ТОП ХАБАХ
Section:NewDropdown("Select Seed Type", "Choose which seed you want to buy", {
    "Basic Seed", "Bamboo Seed", "Rose Seed", "Tulip Seed", 
    "Sunflower Seed", "Cactus Seed", "Lily Seed", "Lotus Seed"
}, function(selected)
    selectedSeedName = selected
    print("Выбрано семя для покупки: " .. selectedSeedName)
end)

-- 5. ТЕКСТОВОЕ ПОЛЕ ДЛЯ КОЛИЧЕСТВА
Section:NewTextBox("Amount", "How many seeds to buy", function(text)
    buyQuantity = tonumber(text) or 10
end)

-- 6. КРАСИВАЯ ИНТЕРАКТИВНАЯ КНОПКА ЗАПУСКА С АНИМАЦИЕЙ КЛИКА
Section:NewButton("Execute Purchase", "Click to buy selected seeds", function()
    if not buyRemote then 
        print("Ошибка: Сетевой триггер не найден!")
        return 
    end
    
    task.spawn(function()
        print("Herdwavy's Hub: Покупаю " .. selectedSeedName .. " в количестве " .. buyQuantity .. " шт.")
        for i = 1, buyQuantity do
            pcall(function() 
                buyRemote:FireServer(selectedSeedName, 1) 
            end)
            task.wait(0.05) -- Пауза против античита
        end
        print("Herdwavy's Hub: Закупка завершена!")
    end)
end)
