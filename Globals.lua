--luarocks module that allows lua to use json
local lunajson = require("lunajson")

--Mathematical formula to find out the rest of the background image off-screen after all 1500 - 888 x 2 remains somewhat off-screen
function _G.CalculateComplement(total, one)
    local result = total % one
    return result - one
end

--Mathematical formula to see when the hitboxes touch
function _G.calculateDistance(x1, y1, x2, y2)
    local dist_x = (x2 - x1) ^ 2
    local dist_y = (y2 - y1) ^ 2
    return math.sqrt(dist_x + dist_y)
end

--open the file, read the data and close
function _G.read(file_n)
    local file = io.open(file_n .. ".json", "r")
    local data
    if file ~= nil then
        data = file:read("*all")
        file:close()
    end
    return lunajson.decode(data);
end

--open the file, write the new data and close
function _G.write(file_n, data)
    local file = io.open(file_n .. ".json", "w")
    if file ~= nil then
        file:write(lunajson.encode(data))
        file:close()  
    end
end
