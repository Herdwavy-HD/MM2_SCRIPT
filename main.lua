print("--- HERDWAVY'S GAG2 SEED SHOP LAUNCHED ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Очистка старых интерфейсов, если они висели в памяти Solara
if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end
if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

_G.TargetSeed = "Apple Seed"
_G.BuyAmount = 10
_G.IsBuying = false

-- Поиск сетевого триггера игры Grow a Garden 2
local buyRemote = ReplicatedStorage:FindFirstChild("BuyItem", true) 
               or ReplicatedStorage:FindFirstChild("BuySeed", true)
               or ReplicatedStorage:FindFirstChild("BuyEvent", true)

local function startBuying()
    if not buyRemote then 
        print("Ошибка: Сетевой триггер покупки не найден!")
        return 
    end
    task.spawn(function()
        for i = 1, _G.BuyAmount do
            if not _G.IsBuying then break end
            pcall(function() 
                buyRemote:FireServer(_G.TargetSeed, 1) 
            end)
            task.wait(0.05) -- Пауза против кика за спам
        end
        _G.IsBuying = false
        print("Покупка завершена!")
    end)
end

-- ==========================================================
--               ИНТЕРФЕЙС МАГАЗИНА СЕМЯН (КРАСНЫЙ НЕОН)
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 30, 30) -- Твой красный неон
stroke.Thickness = 2

local Logo = Instance.new("TextLabel", MainFrame)
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.Text = "Herdwavy's Seed Shop"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.BackgroundTransparency = 1

-- Ввод названия семечка (например, Golden Seed)
local SeedInput = Instance.new("TextBox", MainFrame)
SeedInput.Size = UDim2.new(1, -40, 0, 35)
SeedInput.Position = UDim2.new(0, 20, 0, 45)
SeedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SeedInput.Text = "Apple Seed"
SeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SeedInput.Font = Enum.Font.GothamMedium
SeedInput.TextSize = 13
Instance.new("UICorner", SeedInput).CornerRadius = UDim.new(0, 6)

-- Ввод нужного количества
local AmountInput = Instance.new("TextBox", MainFrame)
AmountInput.Size = UDim2.new(1, -40, 0, 35)
AmountInput.Position = UDim2.new(0, 20, 0, 90)
AmountInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AmountInput.Text = "10"
AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountInput.Font = Enum.Font.GothamMedium
AmountInput.TextSize = 13
Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

-- Кнопка старта закупки
local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(1, -40, 0, 40)
BuyBtn.Position = UDim2.new(0, 20, 0, 140)
BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
BuyBtn.Text = "КУПИТЬ СЕМЕНА"
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 14
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.TargetSeed = SeedInput.Text
        _G.BuyAmount = tonumber(AmountInput.Text) or 10
        _G.IsBuying = true
        startBuying()
    end
end)
