function BackGround(X)
    local _x = X
    local _y = 0
    local _width = 888
    local _sprite = love.graphics.newImage("Cheese_King/background.jpg")
    local _totalwidth = love.graphics.getWidth()
    local _speed = 20
    return {
        x = _x, 
        y = _y,
        width = _width,
        totalwidth = _totalwidth,
        sprite = _sprite,
        speed = _speed,
        var = math.ceil(_totalwidth / _width),
        move = function(self, dt)
            self.x = self.x - self.speed * (dt * 10)
        end,
        draw = function (self)
            for i = 1, self.var do
                love.graphics.draw(self.sprite, self.x + (self.width * (i - 1)), self.y)
            end
        end
    }
end

return BackGround