require("conf")

function BackGround(_x)
    local x = _x or 0
    local y = 0
    local width = 888
    local out = false
    local sprite = love.graphics.newImage("Cheese_King/background.jpg")
    local totalwidth = love.graphics.getWidth()
    return {
        x = x, 
        y = y,
        out = out,
        width = width,
        sprite = sprite,
        var = math.ceil(totalwidth / width),
        draw = function (self)
            for i = 1, self.var do
                love.graphics.draw(self.sprite, self.x + (self.width * (i - 1)), self.y)
            end
        end

    }


end

return BackGround