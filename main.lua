print("--- HERDWAVY'S AUTONOMOUS SEED SHOP LAUNCHED ---")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("HerdwavyGardenGui") then CoreGui.HerdwavyGardenGui:Destroy() end

-- Твой идеальный список семян из игры
local seedList = {
    "Carrot", "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple", "Corn", 
    "Bamboo", "Cactus", "Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", 
    "Coconut", "Mango", "Dragon Fruit", "Acorn", "Cherry", "Sunflower", 
    "Venus Fly Trap", "Pomegranate", "Poison Apple", "Venom Spitter", 
    "Moon Bloom", "Hypno Bloom", "Dragon's Breath"
}

local selectedSeeds = {}
_G.BuyAmount = 10
_G.IsBuying = false

-- Профессиональный метод виртуального клика по объектам карты
local function smartClickBuy(targetName)
    -- Ищем палатки по всей карте (в workspace)
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Проверяем, ProximityPrompt это или ClickDetector
        if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.ObjectText or ""), string.lower(targetName)) or string.find(string.lower(obj.ActionText or ""), string.lower(targetName))) then
            pcall(function()
                obj:InputHoldBegin()
                task.wait(0.01)
                obj:InputHoldEnd()
            end)
        elseif obj:IsA("ClickDetector") and (string.find(string.lower(obj.Parent.Name or ""), string.lower(targetName))) then
            pcall(function()
                fireclickdetector(obj) -- Встроенная функция Solara для кликов издалека
            end)
        end
    end
end

local function startMultiBuying()
    task.spawn(function()
        for i = 1, _G.BuyAmount do
            if not _G.IsBuying then break end
            for _, seedName in pairs(seedList) do
                if selectedSeeds[seedName] then
                    smartClickBuy(seedName)
                end
            end
            task.wait(0.05) -- Безопасный тайминг
        end
        _G.IsBuying = false
        print("Herdwavy's Hub: Локальный закуп завершен!")
    end)
end

-- ==========================================================
--                    ИНТЕРФЕЙС GUI
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavyGardenGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 160)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5
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
Logo.ZIndex = 6

local ListToggleBtn = Instance.new("TextButton", MainFrame)
ListToggleBtn.Size = UDim2.new(1, -40, 0, 32)
ListToggleBtn.Position = UDim2.new(0, 20, 0, 40)
ListToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ListToggleBtn.Text = "▼ ВЫБРАТЬ СЕМЕНА (0 выбрано) ▼"
ListToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
ListToggleBtn.Font = Enum.Font.GothamMedium
ListToggleBtn.TextSize = 12
ListToggleBtn.ZIndex = 6
Instance.new("UICorner", ListToggleBtn).CornerRadius = UDim.new(0, 6)

local ScrollList = Instance.new("ScrollingFrame", MainFrame)
ScrollList.Size = UDim2.new(1, -40, 0, 140)
ScrollList.Position = UDim2.new(0, 20, 0, 77)
ScrollList.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ScrollList.BorderSizePixel = 0
ScrollList.CanvasSize = UDim2.new(0, 0, 0, #seedList * 34)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
ScrollList.Visible = false
ScrollList.ZIndex = 10
Instance.new("UICorner", ScrollList).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local SafeLabel = Instance.new("TextLabel", MainFrame)
SafeLabel.Size = UDim2.new(1, -40, 0, 30)
SafeLabel.Position = UDim2.new(0, 20, 1, -95)
SafeLabel.BackgroundTransparency = 1
SafeLabel.Text = "Ничего не выбрано"
SafeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SafeLabel.Font = Enum.Font.SourceSansItalic
SafeLabel.TextSize = 13
SafeLabel.TextXAlignment = Enum.TextXAlignment.Left
SafeLabel.Visible = false
SafeLabel.ZIndex = 6

local function updateCountText()
    local c = 0
    local names = {}
    for _, name in pairs(seedList) do 
        if selectedSeeds[name] then 
            c = c + 1 
            table.insert(names, name) 
        end 
    end
    ListToggleBtn.Text = "▼ ВЫБРАТЬ СЕМЕНА ("..c.." выбрано) ▼"
    
    if c > 0 then
        SafeLabel.Text = "Будет куплено: " .. table.concat(names, ", ")
        SafeLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    else
        SafeLabel.Text = "Ничего не выбрано"
        SafeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

for _, seedName in pairs(seedList) do
    selectedSeeds[seedName] = false
    
    local SeedRow = Instance.new("Frame", ScrollList)
    SeedRow.Size = UDim2.new(1, -10, 0, 30)
    SeedRow.BackgroundTransparency = 1
    SeedRow.ZIndex = 11
    
    local SeedNameLabel = Instance.new("TextLabel", SeedRow)
    SeedNameLabel.Size = UDim2.new(1, -50, 1, 0)
    SeedNameLabel.Position = UDim2.new(0, 10, 0, 0)
    SeedNameLabel.BackgroundTransparency = 1
    SeedNameLabel.Text = seedName
    SeedNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SeedNameLabel.Font = Enum.Font.GothamMedium
    SeedNameLabel.TextSize = 12
    SeedNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    SeedNameLabel.ZIndex = 12
    
    local CheckBox = Instance.new("TextButton", SeedRow)
    CheckBox.Size = UDim2.new(0, 20, 0, 20)
    CheckBox.Position = UDim2.new(1, -30, 0.5, -10)
    CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    CheckBox.Text = ""
    CheckBox.ZIndex = 12
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

ListToggleBtn.MouseButton1Click:Connect(function()
    ScrollList.Visible = not ScrollList.Visible
    if ScrollList.Visible then
        MainFrame.Size = UDim2.new(0, 320, 0, 340)
        SafeLabel.Visible = true
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 160)
        SafeLabel.Visible = false
    end
end)

local AmountInput = Instance.new("TextBox", MainFrame)
AmountInput.Size = UDim2.new(0, 60, 0, 35)
AmountInput.Position = UDim2.new(0, 20, 1, -55)
AmountInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AmountInput.Text = "10"
AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AmountInput.Font = Enum.Font.GothamMedium
AmountInput.TextSize = 13
AmountInput.ZIndex = 6
Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(1, -110, 0, 35)
BuyBtn.Position = UDim2.new(0, 90, 1, -55)
BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
BuyBtn.Text = "КУПИТЬ СЕМЕНА"
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 13
BuyBtn.ZIndex = 6
Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.BuyAmount = tonumber(AmountInput.Text) or 10
        _G.IsBuying = true
        startMultiBuying()
    end
end)
