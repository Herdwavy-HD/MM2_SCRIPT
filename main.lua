print("--- Herdwavy's Hub Voidware-Style FIXED ---")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer

local espEnabled = false
local gunEspEnabled = false
local heartbeatConnection = nil

local function removeOldESP(character)
    local oldHighlight = character:FindFirstChild("PlayerChams")
    if oldHighlight then oldHighlight:Destroy() end
end

local function applyCustomESP(player)
    if not espEnabled then return end
    if player == localPlayer then return end
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
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do pcall(applyCustomESP, p) end
        end)
    else
        if heartbeatConnection then heartbeatConnection:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then removeOldESP(p.Character) end
        end
    end
end

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
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HerdwavysHubGui"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 30, 30)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 160, 1, 0)
SidePanel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
SidePanel.BorderSizePixel = 0
SidePanel.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 14)
SideCorner.Parent = SidePanel

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0, 50)
LogoText.Position = UDim2.new(0, 0, 0, 15)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Herdwavy's Hub"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 16
LogoText.Parent = SidePanel

local VisualsTabButton = Instance.new("Frame")
VisualsTabButton.Size = UDim2.new(0, 140, 0, 35)
VisualsTabButton.Position = UDim2.new(0, 10, 0, 80)
VisualsTabButton.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
VisualsTabButton.BorderSizePixel = 0
VisualsTabButton.Parent = SidePanel

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = VisualsTabButton

local TabStroke = Instance.new("UIStroke")
TabStroke.Color = Color3.fromRGB(255, 30, 30)
TabStroke.Thickness = 1
TabStroke.Parent = VisualsTabButton

local VisualsTabText = Instance.new("TextLabel")
VisualsTabText.Size = UDim2.new(1, 0, 1, 0)
VisualsTabText.BackgroundTransparency = 1
VisualsTabText.Text = "👁 Visuals"
VisualsTabText.TextColor3 = Color3.fromRGB(255, 50, 50)
VisualsTabText.Font = Enum.Font.GothamBold
VisualsTabText.TextSize = 13
VisualsTabText.Parent = VisualsTabButton

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 370, 0, 320)
Container.Position = UDim2.new(0, 175, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local function createToggle(name, yPos, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = Container

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 250, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local SwitchBG = Instance.new("TextButton")
    SwitchBG.Size = UDim2.new(0, 45, 0, 24)
    SwitchBG.Position = UDim2.new(1, -60, 0.5, -12)
    SwitchBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SwitchBG.Text = ""
    SwitchBG.Parent = ToggleFrame

    local BGCorner = Instance.new("UICorner")
    BGCorner.CornerRadius = UDim.new(1, 0)
    BGCorner.Parent = SwitchBG

    local Circle = Instance.new("Frame")
    Circle.Size = Vector2.new(18, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = SwitchBG

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local active = false
    SwitchBG.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        if active then
            SwitchBG.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
            Circle:TweenPosition(UDim2.new(1, -21, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
        else
            SwitchBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Circle:TweenPosition(UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15)
        end
    end)
end

createToggle("Player ESP (Chams)", 0, function(state) toggleESP(state) end)
createToggle("Dropped Gun ESP", 60, function(state) gunEspEnabled = state end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ToggleButton.Text = "H"
ToggleButton.TextColor3 = Color3.fromRGB(255, 30, 30)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 30, 30)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.TextColor3 = Color3.fromRGB(255, 30, 30)
        ToggleStroke.Color = Color3.fromRGB(255, 30, 30)
    else
        ToggleButton.TextColor3 = Color3.fromRGB(120, 120, 120)
        ToggleStroke.Color = Color3.fromRGB(50, 50, 50)
    end
end)
