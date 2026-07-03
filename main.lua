print("--- HERDWAVY'S REAL CLICKER LAUNCHED ---")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

_G.BuyAmount = 10
_G.IsBuying = false

-- Функция симуляции клика по кнопкам в PlayerGui, который ты нашел в Дексе!
local function doRealClick()
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local normalShop = playerGui and playerGui:FindFirstChild("SeedShop") 
                   and playerGui.SeedShop:FindFirstChild("Frame") 
                   and playerGui.SeedShop.Frame:FindFirstChild("NormalShop")
                   
    if normalShop then
        -- Скрипт сам находит ВСЕ кнопки покупки внутри твоего NormalShop
        for _, btn in pairs(normalShop:GetDescendants()) do
            if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                pcall(function()
                    -- Имитируем реальный клик мышки прямо по координатам кнопки на экране!
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(btn.AbsolutePosition.X + (btn.AbsoluteSize.X/2), btn.AbsolutePosition.Y + (btn.AbsoluteSize.Y/2)))
                end)
                task.wait(0.02)
            end
        end
    end
end

local function startAutoBuying()
    task.spawn(function()
        -- Открываем магазин на экране перед закупкой
        local stand = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Stands") and workspace.Map.Stands:FindFirstChild("Shop")
        local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if root and stand then
            local oldCF = root.CFrame
            root.CFrame = stand:GetModelCFrame() or stand.CFrame -- Встаем к прилавку
            task.wait(0.1)
            
            for i = 1, _G.BuyAmount do
                if not _G.IsBuying then break end
                doRealClick()
                task.wait(0.05)
            end
            
            root.CFrame = oldCF -- Возвращаемся на грядку
        end
        _G.IsBuying = false
    end)
end

-- ==========================================================
--               ИНТЕРФЕЙС GUI (БЕЗ ФИЛЬТРОВ И БАГОВ)
-- ==========================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 150)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Active = true MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", MainFrame) stroke.Color = Color3.fromRGB(255, 30, 30) stroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35) Title.Text = "Herdwavy's Click Shop" Title.TextColor3 = Color3.fromRGB(255, 255, 255) Title.Font = Enum.Font.GothamBold Title.TextSize = 13 Title.BackgroundTransparency = 1

local AmountInput = Instance.new("TextBox", MainFrame)
AmountInput.Size = UDim2.new(1, -40, 0, 35) AmountInput.Position = UDim2.new(0, 20, 0, 45) AmountInput.BackgroundColor3 = Color3.fromRGB(22, 22, 26) AmountInput.Text = "5" AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255) AmountInput.Font = Enum.Font.GothamMedium AmountInput.TextSize = 13
Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(1, -40, 0, 40) BuyBtn.Position = UDim2.new(0, 20, 0, 95) BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30) BuyBtn.Text = "ЗАПУСТИТЬ АВТОКЛИКЕР МАГАЗИНА" BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) BuyBtn.Font = Enum.Font.GothamBold BuyBtn.TextSize = 12
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.BuyAmount = tonumber(AmountInput.Text) or 5
        _G.IsBuying = true
        startAutoBuying()
    end
end)
