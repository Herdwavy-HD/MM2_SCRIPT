print("--- ТОТАЛЬНЫЙ СЕТЕВОЙ ШПИОН HERDWAVY ЗАПУЩЕН ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для тотальной слежки за событиями и функциями
local function monitorRemote(remote)
    -- 1. Шпионим за RemoteEvent (FireServer)
    if remote:IsA("RemoteEvent") then
        local oldFireServer
        pcall(function()
            oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                print("====================================")
                print("🚀 [EVENT] НАЙДЕН ПАКЕТ ИГРЫ!")
                print("Путь: game." .. self:GetFullName())
                for i, v in pairs(args) do print("   [" .. i .. "] -> " .. tostring(v)) end
                print("====================================")
                return oldFireServer(self, ...)
            end
        end)
    
    -- 2. Шпионим за RemoteFunction (InvokeServer) — САМОЕ ВАЖНОЕ ДЛЯ САДА!
    elseif remote:IsA("RemoteFunction") then
        local oldInvokeServer
        pcall(function()
            oldInvokeServer = remote.InvokeServer
            remote.InvokeServer = function(self, ...)
                local args = {...}
                print("====================================")
                print("🔮 [FUNCTION] ПЕРЕХВАЧЕН ЗАПРОС МАГАЗИНА!")
                print("Точный путь: game." .. self:GetFullName())
                print("Что отправлено внутри (Аргументы):")
                for i, v in pairs(args) do 
                    print("   [" .. i .. "] Тип: (" .. type(v) .. ") -> Значение: " .. tostring(v)) 
                end
                print("====================================")
                return oldInvokeServer(self, ...)
            end
        end)
    end
end

-- Внедряемся во все скрытые папки игры
for _, obj in pairs(game:GetDescendants()) do
    pcall(monitorRemote, obj)
end

game.DescendantAdded:Connect(function(obj)
    pcall(monitorRemote, obj)
end)
print("Тотальный шпион в памяти. Открывай F9 и купи ОДНО семечко!")
