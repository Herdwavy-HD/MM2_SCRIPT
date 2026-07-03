print("--- HERDWAVY'S BACKGROUND AUTO-BUY LAUNCHED ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

-- Переменные управления (всё закупается в фоне, пока включен тумблер)
_G.AutoBamboo = false
_G.AutoRose = false

local secretRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("PleaseDontMakeMeUseBytenet")

-- 🔄 ФОНОВЫЙ ПОТОК ЗАКУПКИ (РАБОТАЕТ ВСЕГДА И НЕ ТЕПОРТИРУЕТ)
task.spawn(function()
    while true do
        task.wait(0.5) -- Проверка и закупка каждые полсекунды, чтобы не лагало
        if secretRemote then
            -- Если включен бамбук
            if _G.AutoBamboo then
                pcall(function()
                    secretRemote:InvokeServer("BuyItem", "SeedShop", "Bamboo")
                end)
            end
            -- Если включена роза
            if _G.AutoRose then
                pcall(function()
                    secretRemote:InvokeServer("BuyItem", "SeedShop", "Briar Rose")
                end)
            end
        end
    end
end)

-- ==========================================================
--               ИНТЕРФЕЙС GUI (ФОНОВЫЙ АВТОФАРМ)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Active = true MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", MainFrame) stroke.Color = Color3.fromRGB(255, 30, 30) stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35) Title.Text = "Herdwavy's Background Farm" Title.TextColor3 = Color3.fromRGB(255, 255, 255) Title.Font = Enum.Font.GothamBold Title.TextSize = 13 Title.BackgroundTransparency = 1

-- КНОПКА 1: ТУМБЛЕР БАМБУКА
local BambooBtn = Instance.new("TextButton", MainFrame)
BambooBtn.Size = UDim2.new(1, -40, 0, 40) BambooBtn.Position = UDim2.new(0, 20, 0, 45) BambooBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) BambooBtn.Text = "Авто-покупка Bamboo: ВЫКЛ" BambooBtn.TextColor3 = Color3.fromRGB(255, 255, 255) BambooBtn.Font = Enum.Font.GothamBold BambooBtn.TextSize = 12
Instance.new("UICorner", BambooBtn).CornerRadius = UDim.new(0, 6)

BambooBtn.MouseButton1Click:Connect(function()
    _G.AutoBamboo = not _G.AutoBamboo
    if _G.AutoBamboo then
        BambooBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
        BambooBtn.Text = "Авто-покупка Bamboo: ВКЛ"
    else
        BambooBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        BambooBtn.Text = "Авто-покупка Bamboo: ВЫКЛ"
    end
end)

-- КНОПКА 2: ТУМБЛЕР РОЗЫ
local RoseBtn = Instance.new("TextButton", MainFrame)
RoseBtn.Size = UDim2.new(1, -40, 0, 40) RoseBtn.Position = UDim2.new(0, 20, 0, 100) RoseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) RoseBtn.Text = "Авто-покупка Briar Rose: ВЫКЛ" RoseBtn.TextColor3 = Color3.fromRGB(255, 255, 255) RoseBtn.Font = Enum.Font.GothamBold RoseBtn.TextSize = 12
Instance.new("UICorner", RoseBtn).CornerRadius = UDim.new(0, 6)

RoseBtn.MouseButton1Click:Connect(function()
    _G.AutoRose = not _G.AutoRose
    if _G.AutoRose then
        RoseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
        RoseBtn.Text = "Авто-покупка Briar Rose: ВКЛ"
    else
        RoseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        RoseBtn.Text = "Авто-покупка Briar Rose: ВЫКЛ"
    end
end)
