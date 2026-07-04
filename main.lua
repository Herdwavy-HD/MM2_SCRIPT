local P = game:GetService("Players")
local R = game:GetService("RunService")
local lP = P.LocalPlayer

local function gC(p)
    if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then 
        return Color3.fromRGB(255, 0, 0)
    elseif p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then 
        return Color3.fromRGB(0, 0, 255)
    end 
    return Color3.fromRGB(0, 255, 0)
end

R.Heartbeat:Connect(function()
    for _, p in pairs(P:GetPlayers()) do 
        if p ~= lP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then 
            local c = gC(p)
            if not p.Character:FindFirstChild("RoleHighlight") then 
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "RoleHighlight" 
                hl.FillColor = c 
                hl.FillTransparency = 0.5 
                hl.OutlineColor = c 
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            else 
                p.Character.RoleHighlight.FillColor = c 
                p.Character.RoleHighlight.OutlineColor = c 
            end 
        end 
    end 
end)

task.spawn(function()
    while task.wait(0.2) do 
        pcall(function()
            if lP.Character and lP.Character:FindFirstChild("HumanoidRootPart") then 
                for _, c in pairs(workspace:GetDescendants()) do 
                    if c.Name == "Coin_C" and c:IsA("BasePart") then 
                        lP.Character.HumanoidRootPart.CFrame = c.CFrame 
                        task.wait(0.05)
                    end 
                end 
            end 
        end)
    end 
end)

print("--- MM2 MOD RUNNING ---")
