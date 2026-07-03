print("--- HERDWAVY'S Hub GAG2 Edition LOADED ---")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end

-- Твой идеальный и полный список семян из игры
local seedList = {
    "Carrot", "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple", "Corn", 
    "Bamboo", "Cactus", "Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", 
    "Coconut", "Mango", "Dragon Fruit", "Acorn", "Cherry", "Sunflower", "Briar Rose",
    "Venus Fly Trap", "Pomegranate", "Poison Apple", "Venom Spitter", 
    "Moon Bloom", "Hypno Bloom", "Dragon's Breath"
}

local selectedSeeds = {}
_G.BuyAmount = 10
_G.IsBuying = false

-- Функция автокликера по скрытым UI кнопкам игры (срабатывает со 100% гарантией)
local function clickUiButton(seedName)
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local normalShop = playerGui and playerGui:FindFirstChild("SeedShop") 
                   and playerGui.SeedShop:FindFirstChild("Frame") 
                   and playerGui.SeedShop.Frame:FindFirstChild("NormalShop")
                   
    if normalShop then
        for _, child in pairs(normalShop:GetDescendants()) do
            if (child:IsA("TextButton") or child:IsA("ImageButton")) and string.find(string.lower(child.Name), string.lower(seedName)) then
                pcall(function()
                    child:Activate() -- Кликает по невидимым кнопкам интерфейса без телепортов!
                end)
                break
            end
        end
    end
end

local function startMultiBuying()
    task.spawn(function()
        for i = 1, _G.BuyAmount do
            if not _G.IsBuying then break end
            for _, seedName in pairs(seedList) do
                if selectedSeeds[seedName] then
                    clickUiButton(seedName)
                end
            end
            task.wait(0.05)
        end
        _G.IsBuying = false
    end)
end

-- ==========================================================
--               ЭЛИТНЫЙ ИНТЕРФЕЙС HERDWAVY'S HUB (GARDEN)
-- ==========================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "HerdwavysHubGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.Active = true MainFrame.Draggable = true MainFrame.ZIndex = 5
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
local MainStroke = Instance.new("UIStroke", MainFrame) MainStroke.Color = Color3.fromRGB(255, 30, 30) MainStroke.Thickness = 2

local SidePanel = Instance.new("Frame", MainFrame)
SidePanel.Size = UDim2.new(0, 160, 1, 0) SidePanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22) SidePanel.ZIndex = 6
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 14)

local LogoText = Instance.new("TextLabel", SidePanel)
LogoText.Size = UDim2.new(1, 0, 0, 50) LogoText.Position = UDim2.new(0, 0, 0, 15) LogoText.BackgroundTransparency = 1 LogoText.Text = "Herdwavy's Hub" LogoText.TextColor3 = Color3.fromRGB(255, 255, 255) LogoText.Font = Enum.Font.GothamBold LogoText.TextSize = 16 LogoText.ZIndex = 7

local TabFrame = Instance.new("Frame", SidePanel)
TabFrame.Size = UDim2.new(0, 140, 0, 35) TabFrame.Position = UDim2.new(0, 10, 0, 80) TabFrame.BackgroundColor3 = Color3.fromRGB(35, 15, 15) TabFrame.ZIndex = 7
Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TabFrame).Color = Color3.fromRGB(255, 30, 30)

local TabText = Instance.new("TextLabel", TabFrame)
TabText.Size = UDim2.new(1, 0, 1, 0) TabText.BackgroundTransparency = 1 TabText.Text = "Garden Shop" TabText.TextColor3 = Color3.fromRGB(255, 50, 50) TabText.Font = Enum.Font.GothamBold TabText.TextSize = 13 TabText.ZIndex = 8

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(0, 370, 0, 320) Container.Position = UDim2.new(0, 175, 0, 20) Container.BackgroundTransparency = 1 Container.ZIndex = 6

-- 📜 СПИСОК СЕМЯН С ПРОКРУТКОЙ ВНУТРИ ОКНА VOIDWARE
local ScrollList = Instance.new("ScrollingFrame", Container)
ScrollList.Size = UDim2.new(1, 0, 0, 210)
ScrollList.Position = UDim2.new(0, 0, 0, 5)
ScrollList.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ScrollList.BorderSizePixel = 0
ScrollList.CanvasSize = UDim2.new(0, 0, 0, #seedList * 36)
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
ScrollList.ZIndex = 10
Instance.new("UICorner", ScrollList).CornerRadius = UDim.new(0, 8)

local UIListLayout = Instance.new("UIListLayout", ScrollList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

for _, seedName in pairs(seedList) do
    selectedSeeds[seedName] = false
    
    local SeedRow = Instance.new("Frame", ScrollList) SeedRow.Size = UDim2.new(1, -10, 0, 32) SeedRow.BackgroundTransparency = 1 SeedRow.ZIndex = 11
    local SeedNameLabel = Instance.new("TextLabel", SeedRow) SeedNameLabel.Size = UDim2.new(1, -50, 1, 0) SeedNameLabel.Position = UDim2.new(0, 10, 0, 0) SeedNameLabel.BackgroundTransparency = 1 SeedNameLabel.Text = seedName SeedNameLabel.TextColor3 = Color3.fromRGB(230, 230, 235) SeedNameLabel.Font = Enum.Font.GothamMedium SeedNameLabel.TextSize = 12 SeedNameLabel.TextXAlignment = Enum.TextXAlignment.Left SeedNameLabel.ZIndex = 12
    local CheckBox = Instance.new("TextButton", SeedRow) CheckBox.Size = UDim2.new(0, 20, 0, 20) CheckBox.Position = UDim2.new(1, -30, 0.5, -10) CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50) CheckBox.Text = "" CheckBox.ZIndex = 12 Instance.new("UICorner", CheckBox).CornerRadius = UDim.new(0, 4)
    
    CheckBox.MouseButton1Click:Connect(function()
        selectedSeeds[seedName] = not selectedSeeds[seedName]
        if selectedSeeds[seedName] then CheckBox.BackgroundColor3 = Color3.fromRGB(255, 30, 30) CheckBox.Text = "✓" CheckBox.TextColor3 = Color3.fromRGB(255, 255, 255) else CheckBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50) CheckBox.Text = "" end
    end)
end

-- ВВОД КОЛИЧЕСТВА И КНОПКА ПОКУПКИ СНИЗУ
local AmountInput = Instance.new("TextBox", Container)
AmountInput.Size = UDim2.new(0, 70, 0, 35) AmountInput.Position = UDim2.new(0, 0, 0, 230) AmountInput.BackgroundColor3 = Color3.fromRGB(22, 22, 26) AmountInput.Text = "10" AmountInput.TextColor3 = Color3.fromRGB(255, 255, 255) AmountInput.Font = Enum.Font.GothamMedium AmountInput.TextSize = 13 AmountInput.ZIndex = 15 Instance.new("UICorner", AmountInput).CornerRadius = UDim.new(0, 6)

local BuyBtn = Instance.new("TextButton", Container)
BuyBtn.Size = UDim2.new(1, -85, 0, 35) BuyBtn.Position = UDim2.new(0, 85, 0, 230) BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30) BuyBtn.Text = "ЗАПУСТИТЬ ЗАКУПКУ СЕМЕНА" BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) BuyBtn.Font = Enum.Font.GothamBold BuyBtn.TextSize = 13 BuyBtn.ZIndex = 15 Instance.new("UICorner", BuyBtn).CornerRadius = UDim.new(0, 6)

BuyBtn.MouseButton1Click:Connect(function()
    if not _G.IsBuying then
        _G.BuyAmount = tonumber(AmountInput.Text) or 10
        _G.IsBuying = true
        startMultiBuying()
    end
end)

local Tgl = Instance.new("TextButton", ScreenGui)
Tgl.Size = UDim2.new(0, 45, 0, 45) Tgl.Position = UDim2.new(0, 15, 0, 15) Tgl.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Tgl.Text = "H" Tgl.TextColor3 = Color3.fromRGB(255, 30, 30) Tgl.Font = Enum.Font.GothamBold Tgl.TextSize = 22 Tgl.ZIndex = 100
local tSt = Instance.new("UIStroke", Tgl) tSt.Color = Color3.fromRGB(255, 30, 30) tSt.Thickness = 2 Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)

Tgl.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then Tgl.TextColor3 = Color3.fromRGB(255, 30, 30) tSt.Color = Color3.fromRGB(255, 30, 30) else Tgl.TextColor3 = Color3.fromRGB(120, 120, 120) tSt.Color = Color3.fromRGB(50, 50, 50) end
end)
