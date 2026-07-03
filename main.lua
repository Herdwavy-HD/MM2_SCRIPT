print("--- HERDWAVY'S EXPERT DEX EXPLORER LAUNCHED ---")
local C = game:GetService("CoreGui")
if C:FindFirstChild("Dex") then C.SimpleDex:Destroy() end
local S = Instance.new("ScreenGui", C) S.Name = "HerdwavyDex"
local M = Instance.new("Frame", S) M.Size = UDim2.new(0, 300, 0, 400) M.Position = UDim2.new(1, -310, 0.5, -200) M.BackgroundColor3 = Color3.fromRGB(20,20,25) M.Active = true M.Draggable = true
Instance.new("UICorner", M).CornerRadius = UDim.new(0, 8)
local St = Instance.new("UIStroke", M) St.Color = Color3.fromRGB(255,30,30) St.Thickness = 2
local T = Instance.new("TextLabel", M) T.Size = UDim2.new(1, 0, 0, 30) T.Text = "Herdwavy's Game Explorer" T.TextColor3 = Color3.fromRGB(255,255,255) T.Font = Enum.Font.GothamBold T.TextSize = 13 T.BackgroundTransparency = 1
local Sc = Instance.new("ScrollingFrame", M) Sc.Size = UDim2.new(1, -20, 1, -40) Sc.Position = UDim2.new(0, 10, 0, 35) Sc.BackgroundColor3 = Color3.fromRGB(15,15,18) Sc.BorderSizePixel = 0 ScrollBarThickness = 4
local L = Instance.new("UIListLayout", Sc) L.SortOrder = Enum.SortOrder.LayoutOrder L.Padding = UDim.new(0, 2)
local function cItem(name, isFolder, parent, depth)
    local b = Instance.new("TextButton", parent) b.Size = UDim2.new(1, 0, 0, 24) b.BackgroundTransparency = 1 b.Text = string.rep("  ", depth) .. (isFolder and "📁 " or "⚡ ") .. name b.TextColor3 = isFolder and Color3.fromRGB(255,230,100) or Color3.fromRGB(100,200,255) b.Font = Enum.Font.SourceSansBold b.TextSize = 14 b.TextXAlignment = Enum.TextXAlignment.Left
    return b
end
local function scan(folder, parent, depth)
    for _, obj in pairs(folder:GetChildren()) do
        local isF = #obj:GetChildren() > 0 or obj:IsA("Folder") or obj:IsA("Configuration")
        local btn = cItem(obj.Name, isF, parent, depth)
        if isF then
            local open = false
            local childContainer = Instance.new("Frame", parent) childContainer.Size = UDim2.new(1, 0, 0, 0) childContainer.BackgroundTransparency = 1 childContainer.Visible = false
            local cL = Instance.new("UIListLayout", childContainer) cL.SortOrder = Enum.SortOrder.LayoutOrder cL.Padding = UDim.new(0, 2)
            btn.MouseButton1Click:Connect(function()
                open = not open
                childContainer.Visible = open
                if open and #childContainer:GetChildren() == 1 then scan(obj, childContainer, depth + 1) end
                local tH = 0 for _, c in pairs(parent:GetChildren()) do if c:IsA("TextButton") then tH = tH + 26 elseif c:IsA("Frame") and c.Visible then tH = tH + c.UIListLayout.AbsoluteContentSize.Y end endparent.Parent.CanvasSize = UDim2.new(0,0,0,tH)
            end)
        else
            btn.MouseButton1Click:Connect(function()
                print("--- ИНФО ОБ ОБЪЕКТЕ ---")
                print("Полный путь: game." .. obj:GetFullName())
                print("Класс: " .. obj.ClassName)
            end)
        end
    end
    local tH = 0 for _, c in pairs(parent:GetChildren()) do if c:IsA("TextButton") then tH = tH + 26 elseif c:IsA("Frame") and c.Visible then tH = tH + c.UIListLayout.AbsoluteContentSize.Y end end parent.Parent.CanvasSize = UDim2.new(0,0,0,tH)
end
local rBtn = cItem("ReplicatedStorage", true, Sc, 0)
local rContainer = Instance.new("Frame", Sc) rContainer.Size = UDim2.new(1,0,0,0) rContainer.BackgroundTransparency = 1 rContainer.Visible = false
local rL = Instance.new("UIListLayout", rContainer) rL.SortOrder = Enum.SortOrder.LayoutOrder
rBtn.MouseButton1Click:Connect(function()
    rContainer.Visible = not rContainer.Visible
    if rContainer.Visible and #rContainer:GetChildren() == 1 then scan(game:GetService("ReplicatedStorage"), rContainer, 1) end
end)
