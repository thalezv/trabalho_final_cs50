local lunajson = require("lunajson")

function _G.calculateDistance(x1, y1, x2, y2)
    local dist_x = (x2 - x1) ^ 2
    local dist_y = (y2 - y1) ^ 2
    return math.sqrt(dist_x + dist_y)
end

function _G.read(file_n)
    local file = io.open(file_n .. ".json", "r")
    local data = file:read("*all")
    file:close()

    return lunajson.decode(data);
end

function _G.write(file_n, data)
    local file = io.open(file_n .. ".json", "w")
    if file ~= nil then
        file:write(lunajson.encode(data))
        file:close()  
    end
end
