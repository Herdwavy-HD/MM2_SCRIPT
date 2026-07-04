local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = game:GetService("CoreGui")
local U = game:GetService("UserInputService")
local T = game:GetService("TeleportService")
local H = game:GetService("HttpService")
local lP = P.LocalPlayer
local mE, gE, aA, iJ, nc, flyE = false, false, false, false, false, false
local fSpd = 50

local function ch(t, n, f, tl)
    if t and not t:FindFirstChild(n) then
        local h = Instance.new("Highlight", t) h.Name = n
        h.FillColor = f h.FillTransparency = tl h.OutlineColor = f h.DepthMode = 0
    end
end
-- ИДЕАЛЬНАЯ ПРОВЕРКА РОЛЕЙ (ИЩЕТ ОРУЖИЕ В РУКАХ И В РЮКЗАКЕ)
local function gC(p)
    local c = p.Character
    if p.Backpack:FindFirstChild("Knife") or (c and c:FindFirstChild("Knife")) then 
        return Color3.fromRGB(255, 0, 0) -- УБИЙЦА
    elseif p.Backpack:FindFirstChild("Gun") or (c and c:FindFirstChild("Gun")) then 
        return Color3.fromRGB(0, 0, 255) -- ШЕРИФ
    end
    return Color3.fromRGB(0, 255, 0) -- МИРНЫЙ
end

R.Heartbeat:Connect(function()
    if mE then
        for _, p in pairs(P:GetPlayers()) do
            if p ~= lP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local color = gC(p) pcall(ch, p.Character, "RoleHighlight", color, 0.5)
            end
        end
    else
        for _, p in pairs(P:GetPlayers()) do if p.Character and p.Character:FindFirstChild("RoleHighlight") then p.Character.RoleHighlight:Destroy() end end
    end
    -- СТАРЫЙ РАБОЧИЙ ПОИСК ПИСТОЛЕТА ЧЕРЕЗ ВСЕ ОБЪЕКТЫ КАРТЫ
    if gE then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "GunDrop" and v:IsA("BasePart") then
                pcall(ch, v, "GunESP", Color3.fromRGB(255, 215, 0), 0.2)
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "GunDrop" and v:FindFirstChild("GunESP") then v.GunESP:Destroy() end
        end
    end
end)
U.JumpRequest:Connect(function() if iJ and lP.Character and lP.Character:FindFirstChildOfClass("Humanoid") then lP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
R.Stepped:Connect(function() if nc and lP.Character then for _, v in pairs(lP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

task.spawn(function()
    R.RenderStepped:Connect(function()
        if flyE and lP.Character and lP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lP.Character.HumanoidRootPart local hum = lP.Character:FindFirstChildOfClass("Humanoid")
            local move = Vector3.new()
            if U:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if U:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if U:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            hrp.Velocity = move.Unit * fSpd hum.PlatformStand = true
        elseif lP.Character and lP.Character:FindFirstChildOfClass("Humanoid") then
            lP.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
    end)
end)
if C:FindFirstChild("HerdwavysHubGui") then C:FindFirstChild("HerdwavysHubGui"):Destroy() end
local Gui = Instance.new("ScreenGui", C) Gui.Name = "HerdwavysHubGui"
local MF = Instance.new("Frame", Gui) MF.Size = UDim2.new(0, 640, 0, 420) MF.Position = UDim2.new(0.5, -310, 0.5, -210) MF.BackgroundColor3 = Color3.fromRGB(12, 12, 14) MF.Active = true MF.Draggable = true MF.ZIndex = 5
local mC = Instance.new("UICorner", MF) mC.CornerRadius = UDim.new(0, 14) Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 30, 30)
local SP = Instance.new("Frame", MF) SP.Size = UDim2.new(0, 170, 1, 0) SP.BackgroundColor3 = Color3.fromRGB(18, 18, 22) SP.ZIndex = 10 Instance.new("UICorner", SP).CornerRadius = UDim.new(0, 14)
local LT = Instance.new("TextLabel", SP) LT.Size = UDim2.new(1, 0, 0, 50) LT.Position = UDim2.new(0, 0, 0, 15) LT.BackgroundTransparency = 1 LT.Text = "Herdwavy's Hub" LT.TextColor3 = Color3.new(1, 1, 1) LT.Font = Enum.Font.GothamBold LT.TextSize = 16 LT.ZIndex = 11

local CBF = Instance.new("Frame", MF) CBF.Size = UDim2.new(0, 150, 0, 20) CBF.Position = UDim2.new(1, -165, 0, 4) CBF.BackgroundTransparency = 1 CBF.ZIndex = 30
local function wB(t, x, cl, cb)
    local b = Instance.new("TextButton", CBF) b.Size = UDim2.new(0, 44, 0, 16) b.Position = UDim2.new(0, x, 0, 0) b.BackgroundColor3 = Color3.fromRGB(25, 25, 30) b.Text = t b.TextColor3 = cl b.Font = Enum.Font.GothamBold b.TextSize = 10 b.ZIndex = 31
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4) b.MouseButton1Down:Connect(cb)
end
wB("—", 0, Color3.new(0.8, 0.8, 0.8), function() MF.Visible = false end)
local isMax = false wB("🗖", 48, Color3.new(0.8, 0.8, 0.8), function() isMax = not isMax if isMax then MF.Size = UDim2.new(1, 0, 1, 0) MF.Position = UDim2.new(0, 0, 0, 0) mC.CornerRadius = UDim.new(0, 0) else MF.Size = UDim2.new(0, 640, 0, 420) MF.Position = UDim2.new(0.5, -310, 0.5, -210) mC.CornerRadius = UDim.new(0, 14) end end)
wB("X", 96, Color3.new(1, 0.2, 0.2), function() Gui:Destroy() end)
local pages, tabs = {}, {}
local function cP(name, order)
    local p = Instance.new("Frame", MF) p.Size = UDim2.new(1, -195, 1, -40) p.Position = UDim2.new(0, 185, 0, 20) p.BackgroundTransparency = 1 p.ZIndex = 10 p.Visible = (order == 1) pages[order] = p
    local t = Instance.new("TextButton", SP) t.Size = UDim2.new(0, 150, 0, 30) t.Position = UDim2.new(0, 10, 0, 55 + (order * 34)) t.BackgroundColor3 = (order == 1) and Color3.fromRGB(35, 15, 15) or Color3.new(0, 0, 0) t.BackgroundTransparency = (order == 1) and 0 or 1
    t.Text = name t.TextColor3 = Color3.new(1, 1, 1) t.Font = Enum.Font.GothamBold t.TextSize = 11 t.ZIndex = 20 Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", t) s.Color = (order == 1) and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(40, 40, 45) s.Thickness = (order == 1) and 1.5 or 1 tabs[order] = {btn = t, st = s}
    t.MouseButton1Down:Connect(function() for i, pg in pairs(pages) do pg.Visible = (i == order) tabs[i].btn.BackgroundColor3 = (i == order) and Color3.fromRGB(35, 15, 15) or Color3.new(0, 0, 0) tabs[i].btn.BackgroundTransparency = (i == order) and 0 or 1 tabs[i].st.Color = (i == order) and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(40, 40, 45) tabs[i].st.Thickness = (i == order) and 1.5 or 1 end end) return p
end
local pMain, pTweaks, pFun = cP("Main Cheats", 1), cP("Player Tweaks", 2), cP("Server Fun", 3)

local function cT(page, title, y, callback)
    local card = Instance.new("Frame", page) card.Size = UDim2.new(1, 0, 0, 45) card.Position = UDim2.new(0, 0, 0, y) card.BackgroundColor3 = Color3.fromRGB(22, 22, 26) card.ZIndex = 15 Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", card) label.Size = UDim2.new(0, 230, 1, 0) label.Position = UDim2.new(0, 15, 0, 0) label.BackgroundTransparency = 1 label.Text = title label.TextColor3 = Color3.fromRGB(240, 240, 245) label.Font = Enum.Font.GothamBold label.TextSize = 12 label.TextXAlignment = 0 label.ZIndex = 16
    local btn = Instance.new("TextButton", card) btn.Size = UDim2.new(0, 44, 0, 22) btn.Position = UDim2.new(1, -60, 0.5, -11) btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) btn.Text = "" btn.ZIndex = 100 Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn) dot.Size = UDim2.new(0, 14, 0, 14) dot.Position = UDim2.new(0, 3, 0.5, -7) dot.BackgroundColor3 = Color3.new(1, 1, 1) dot.ZIndex = 101 Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local togg = false btn.MouseButton1Down:Connect(function() togg = not togg callback(togg) btn.BackgroundColor3 = togg and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(45, 45, 50) dot:TweenPosition(UDim2.new(0, togg and 27 or 3, 0.5, -7), 0, 0, 0.12) end)
end
cT(pMain, "Player ESP (Подсветка ролей)", 5, function(s) mE = s end) cT(pMain, "Gun Drop ESP (Подсветка пистолета)", 55, function(s) gE = s end)
cT(pTweaks, "Anti-AFK (Защита от афк киков)", 5, function(s) aA = s end) cT(pTweaks, "Fly (Режим полета на W,A,S,D)", 55, function(s) flyE = s end) cT(pTweaks, "Infinite Jump (Бесконечный прыжок)", 105, function(s) iJ = s end) cT(pTweaks, "Noclip (Хождение сквозь стены)", 155, function(s) nc = s end)

local function cS(page, title, y, min, max, default, callback)
    local card = Instance.new("Frame", page) card.Size = UDim2.new(1, 0, 0, 45) card.Position = UDim2.new(0, 0, 0, y) card.BackgroundColor3 = Color3.fromRGB(22, 22, 26) card.ZIndex = 15 Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", card) label.Size = UDim2.new(0, 180, 1, 0) label.Position = UDim2.new(0, 15, 0, 0) label.BackgroundTransparency = 1 label.Text = title..": "..tostring(default) label.TextColor3 = Color3.fromRGB(240, 240, 245) label.Font = Enum.Font.GothamBold label.TextSize = 11 label.TextXAlignment = 0 label.ZIndex = 16
    local bar = Instance.new("TextButton", card) bar.Size = UDim2.new(1,-240, 0, 6) bar.Position = UDim2.new(0, 200, 0.5, -3) bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50) bar.Text = "" bar.ZIndex = 16 Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar) fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0) fill.BackgroundColor3 = Color3.fromRGB(255, 30, 30) fill.BorderSizePixel = 0 fill.ZIndex = 17 Instance.new("UICorner", fill)
    local sliding = false local function update() local mouseX = math.clamp((lP:GetMouse().X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1) fill.Size = UDim2.new(mouseX, 0, 1, 0) local value = math.floor(min+(mouseX*(max-min))) label.Text = title..": "..tostring(value) callback(value) end bar.MouseButton1Down:Connect(function() sliding = true update() end) U.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end) R.Heartbeat:Connect(function() if sliding then pcall(update) end end)
end
cS(pTweaks, "WalkSpeed (Скорость бега)", 205, 16, 250, 16, function(v) if lP.Character and lP.Character:FindFirstChildOfClass("Humanoid") then lP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v end end) cS(pTweaks, "JumpPower (Высота прыжка)", 255, 50, 350, 50, function(v) if lP.Character and lP.Character:FindFirstChildOfClass("Humanoid") then lP.Character:FindFirstChildOfClass("Humanoid").JumpPower = v lP.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true end end)

local function cA(page, title, y, callback)
    local btn = Instance.new("TextButton", page) btn.Size = UDim2.new(1, 0, 0, 40) btn.Position = UDim2.new(0, 0, 0, y) btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26) btn.Text = title btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.GothamBold btn.TextSize = 11 btn.ZIndex = 15 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", btn).Color = Color3.fromRGB(45, 45, 50) btn.MouseButton1Down:Connect(callback)
end
cA(pFun, "Rejoin (Быстрый перезаход на сервер)", 5, function() if #P:GetPlayers() <= 1 then T:Teleport(game.PlaceId, lP) else T:TeleportToPlaceInstance(game.PlaceId, game.JobId, lP) end end)
cA(pFun, "Server Hop (Прыгнуть на другой сервер)", 50, function() local sf = {} local x = H:JSONDecode(game:HttpGet("https://roblox.com"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=20")) for _, s in pairs(x.data) do if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(sf, s.id) end end if #sf > 0 then T:TeleportToPlaceInstance(game.PlaceId, sf[math.random(1, #sf)], lP) else T:Teleport(game.PlaceId, lP) end end)
cA(pFun, "FPS Booster (Максимальная оптимизация)", 95, function() pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = 1 for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.CastShadow = false end if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end end) end)
cA(pFun, "Invisible (Полная невидимость персонажа)", 140, function() pcall(function() local char = lP.Character if char then local hrp = char:FindFirstChild("HumanoidRootPart") if hrp then local clone = hrp:Clone() clone.Parent = char char.PrimaryPart = clone hrp:Destroy() end end end) end)

pcall(function() lP.Idled:Connect(function() if aA then game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end end) end)
local Tgl = Instance.new("TextButton", Gui) Tgl.Size = UDim2.new(0, 45, 0, 45) Tgl.Position = UDim2.new(0, 15, 0, 15) Tgl.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Tgl.Text = "H" Tgl.TextColor3 = Color3.fromRGB(255, 30, 30) Tgl.Font = Enum.Font.GothamBold Tgl.TextSize = 22 Tgl.ZIndex = 100 local tSt = Instance.new("UIStroke", Tgl) tSt.Color = Color3.fromRGB(255, 30, 30) tSt.Thickness = 2 Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1, 0)
Tgl.MouseButton1Down:Connect(function() MF.Visible = not MF.Visible Tgl.TextColor3 = MF.Visible and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(120, 120, 120) tSt.Color = MF.Visible and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(50, 50, 50) end)
