-- ==========================================================
-- HERDWAVY'S PREMIUM HUB: MURDER MYSTERY 2 (ЧАСТЬ 1)
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Функция точного определения роли и цвета игрока
local function getRoleColor(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return Color3.fromRGB(255, 0, 0) -- Убийца (Красный)
    elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return Color3.fromRGB(0, 0, 255) -- Шериф (Синий)
    end
    return Color3.fromRGB(0, 255, 0) -- Мирный (Зеленый)
end
-- Постоянная подсветка всех игроков на карте (ESP Chams)
RunService.Heartbeat:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local color = getRoleColor(p)
            if not p.Character:FindFirstChild("RoleHighlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "RoleHighlight"
                hl.FillColor = color
                hl.FillTransparency = 0.5
                hl.OutlineColor = color
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else
                p.Character.RoleHighlight.FillColor = color
                p.Character.RoleHighlight.OutlineColor = color
            end
        end
    end
end)

-- Ультра-быстрый автосбор падающих золотых монет
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, c in pairs(workspace:GetDescendants()) do
                    if c.Name == "Coin_C" and c:IsA("BasePart") then
                        localPlayer.Character.HumanoidRootPart.CFrame = c.CFrame
                        task.wait(0.05)
                    end
                end
            end
        end)
    end
end)

print("--- HERDWAVY'S MM2 SCRIPT SUCCESSFULY LOADED ---")
