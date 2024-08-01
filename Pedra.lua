function Pedra(level)
    local _radius = 50
    local _x = love.graphics.getWidth() + _radius 
    local _y = love.graphics.getHeight() - _radius * 3.5
    local sprite = love.graphics.newImage("Cheese_King/pedrinha.png")
    local _speed = 0
    if level < 8 then
        _speed = 20 * level
    else
        _speed = 20 * 8
    end
    return {
        x = _x,
        y = _y,
        speed = _speed,
        circle_x = _x + _radius * 2.5,
        circle_y = _y + _radius * 2.5,
        radius = _radius,
        sprite = sprite,
        lvl = level,
        draw = function(self)
            love.graphics.draw(self.sprite, self.x, self.y)
            love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
        end,
        move = function(self, dt, pulo)
            if pulo and self.lvl < 2 then
                self.x = self.x - self.speed * (dt * 25) - self.lvl
                self.circle_x = self.circle_x - self.speed * (dt * 25) - self.lvl
            else
                self.x = self.x - self.speed * (dt * 10) - self.lvl
                self.circle_x = self.circle_x - self.speed * (dt * 10) - self.lvl
            end
        end
    }
end

return Pedra