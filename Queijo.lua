local love = require("love")

--properties of the collectible that is a slice of cheese, starts at the edge of the screen opposite the player
function Queijo(level)
    local _radius = 40
    local _x = love.graphics.getWidth() + _radius * 0.5
    local _y = love.graphics.getHeight() - _radius * 5.5
    local _sprite = love.graphics.newImage("Cheese_King/queijo_fatia.png")
    --speed is equivalent to difficulty, the more difficult it is, the faster it will be
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
        circle_x = _x + _radius * 4,
        circle_y = _y + _radius * 3.8,
        radius = _radius,
        sprite = _sprite,
        lvl = level,
        --draws it and its hitbox, leaving the hitbox hidden
        draw = function(self)
            love.graphics.draw(self.sprite, self.x, self.y)
            love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
        end,
        --movement towards the player where if the player jumps and is at level 1 the stone moves a little faster, due to the size of the stone being greater than the length of the jump at level 1
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

return Queijo