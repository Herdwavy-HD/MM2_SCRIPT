print("--- Herdwavy's Hub Premium Voidware Fixed ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

local espEnabled = true
local gunEspEnabled = true
local heartbeatConnection = nil

local function removeOldESP(character)
    local oldHighlight = character:FindFirstChild("PlayerChams")
    if oldHighlight then oldHighlight:Destroy() end
end

local function applyCustomESP(player)
    if not espEnabled or player == localPlayer then return end
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
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                for _, p in pairs(Players:GetPlayers()) do pcall(applyCustomESP, p) end
            end)
        end
    else
        if heartbeatConnection then heartbeatConnection:Disconnect() heartbeatConnection = nil end
        for _, p in pairs(Players:GetPlayers()) do if p.Character then removeOldESP(p.Character) end end
    end
end

toggleESP(true)

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

if CoreGui:FindFirstChild("HerdwavysHubGui") then CoreGui.HerdwavysHubGui:Destroy() end
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
TabText.Size = UDim2.new(1, 0, 1, 0) TabText.BackgroundTransparency = 1 TabText.Text = "Visuals" TabText.TextColor3 = Color3.fromRGB(255, 50, 50) TabText.Font = Enum.Font.GothamBold TabText.TextSize = 13 TabText.ZIndex = 8

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(0, 370, 0, 320) Container.Position = UDim2.new(0, 175, 0, 20) Container.BackgroundTransparency = 1 Container.ZIndex = 6

local function createToggle(name, yPos, startActive, callback)
    local f = Instance.new("Frame", Container) f.Size = UDim2.new(1, 0, 0, 50) f.Position = UDim2.new(0, 0, 0, yPos) f.BackgroundColor3 = Color3.fromRGB(22, 22, 26) f.ZIndex = 10 Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local l = Instance.new("TextLabel", f) l.Size = UDim2.new(0, 250, 1, 0) l.Position = UDim2.new(0, 15, 0, 0) l.BackgroundTransparency = 1 l.Text = name l.TextColor3 = Color3.fromRGB(230, 230, 235) l.Font = Enum.Font.GothamMedium l.TextSize = 13 l.TextXAlignment = Enum.TextXAlignment.Left l.ZIndex = 11
    local b = Instance.new("TextButton", f) b.Size = UDim2.new(0, 45, 0, 24) b.Position = UDim2.new(1, -60, 0.5, -12) b.Text = "" b.ZIndex = 15 Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local c = Instance.new("Frame", b) c.Size = Vector2.new(18, 18) c.ZIndex = 16 Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
    local act = startActive
    if act then b.BackgroundColor3 = Color3.fromRGB(255, 30, 30) c.Position = UDim2.new(1, -21, 0.5, -9) else b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) c.Position = UDim2.new(0, 3, 0.5, -9) end
    c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.MouseButton1Click:Connect(function()
        act = not act callback(act)
        if act then b.BackgroundColor3 = Color3.fromRGB(255, 30, 30) c:TweenPosition(UDim2.new(1, -21, 0.5, -9), 0, 0, 0.12) else b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) c:TweenPosition(UDim2.new(0, 3, 0.5, -9), 0, 0, 0.12) end
    end)
end

createToggle("Player ESP (Chams)", 0, true, function(s) toggleESP(s) end)
createToggle("Dropped Gun ESP", 60, true, function(s) gunEspEnabled = s end)

local Tgl = Instance.new("TextButton", ScreenGui)
Tgl.Size = UDim2.new(0, 45, 0, 45) Tgl.Position = UDim2.new(0, 15, 0, 15) Tgl.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Tgl.Text = "H" Tgl.TextColor3 = Color3.fromRGB(255, 30, 30) Tgl.Font = Enum.Font.GothamBold Tgl.TextSize = 22 Tgl.ZIndex = 100
local tSt = Instance.new("UIStroke", Tgl) tSt.Color = Color3.fromRGB(255, 30, 30) tSt.Thickness = 2 Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)

Tgl.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then Tgl.TextColor3 = Color3.fromRGB(255, 30, 30) tSt.Color = Color3.fromRGB(255, 30, 30) else Tgl.TextColor3 = Color3.fromRGB(120, 120, 120) tSt.Color = Color3.fromRGB(50, 50, 50) end
end)
