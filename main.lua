print("--- СЕТЕВОЙ ШПИОН HERDWAVY ЗАПУЩЕН ---")
local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция, которая перехватывает ЛЮБОЙ вызов сетевых событий в игре
local function hookRemotes(object)
    if object:IsA("RemoteEvent") then
        object.OnClientEvent:Connect(function(...)
            print("[Сеть] Обнаружен входящий триггер: " .. object:GetFullName())
        end)
        
        -- Шпионим за тем, что отправляет твой персонаж серверу
        local oldFireServer = object.FireServer
        object.FireServer = function(self, ...)
            local args = {...}
            print("🚀 ПЕРЕХВАЧЕН СИГНАЛ ПОКУПКИ/ДЕЙСТВИЯ!")
            print("Точный путь к кнопке: game." .. self:GetFullName())
            print("Что отправлено внутри пакета (Аргументы):")
            for i, v in pairs(args) do
                print("   Параметр [" .. i .. "]: " .. tostring(v))
            end
            return oldFireServer(self, ...)
        end
    end
end

-- Включаем слежку по всей игре
for _, obj in pairs(game:GetDescendants()) do
    pcall(hookRemotes, obj)
end

game.DescendantAdded:Connect(function(obj)
    pcall(hookRemotes, obj)
end)
