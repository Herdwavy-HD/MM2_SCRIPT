print("--- ЧИСТЫЙ СЕТЕВОЙ ШПИОН HERDWAVY ЗАПУЩЕН ---")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция сканирования всех сетевых каналов игры
local function monitorRemote(remote)
    if remote:IsA("RemoteEvent") then
        -- Подключаемся к скрытому триггеру отправки данных на сервер
        local oldFireServer
        pcall(function()
            oldFireServer = remote.FireServer
            remote.FireServer = function(self, ...)
                local args = {...}
                -- Выводим жирные логи прямо в твою консоль F9!
                print("====================================")
                print("🚀 НАЙДЕНО СЕТЕВОЕ СОБЫТИЕ ИГРЫ!")
                print("Точный путь в ReplicatedStorage: game." .. self:GetFullName())
                print("Что отправляет игра (Аргументы пакета):")
                for i, v in pairs(args) do
                    print("   [" .. i .. "] Тип данных: (" .. type(v) .. ") -> Значение: " .. tostring(v))
                end
                print("====================================")
                return oldFireServer(self, ...)
            end
        end)
    end
end

-- Включаем шпионаж для всех текущих и будущих объектов в игре
for _, obj in pairs(game:GetDescendants()) do
    pcall(monitorRemote, obj)
end

game.DescendantAdded:Connect(function(obj)
    pcall(monitorRemote, obj)
end)
print("Шпион успешно внедрился в память. Открой F9 и купи семечко!")
