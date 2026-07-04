-- ==========================================================
-- HERDWAVY'S MM2 FIXED SCRIPT (SOLARA 2026)
-- ==========================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local function getRoleColor(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return Color3.fromRGB(255, 0, 0)
    elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return Color3.fromRGB(0, 0, 255)
    end
    return Color3.fromRGB(0, 255, 0)
end

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
                hl.DepthMode = 0 -- Фикс: цифровой AlwaysOnTop для Solara
            else
                p.Character.RoleHighlight.FillColor = color
                p.Character.RoleHighlight.OutlineColor = color
            end
        end
    end
end)

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

print("--- MM2 MOD SCRIPT WORKING ---")
