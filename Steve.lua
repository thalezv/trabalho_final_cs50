function Steve()
    local _x = 180
    local _y = 200
    local radius = 60
    local _sprite = love.graphics.newImage("Cheese_King/steve_sheet.png")
    local _sprite_width = 2681
    local _sprite_heigth = 285
    local _sprite2 = love.graphics.newImage("Cheese_King/steve_pulo.png")
    local _sprite2_width = 1340
    local _sprite2_heigth = 285
    local _sprite3 = love.graphics.newImage("Cheese_King/steve_pedrinha.png")
    local _one_width = 335
    local _one_heigth = 285
    local _quads = {}
    local _quads2 = {}
    for i = 1, _sprite_width / _one_width do
        _quads[i] = love.graphics.newQuad(_one_width * (i - 1), 0, _one_width, _one_heigth, _sprite_width, _sprite_heigth)
    end
    for j = 1, _sprite2_width / _one_width do
        _quads2[j] = love.graphics.newQuad(_one_width * (j - 1), 0, _one_width, _one_heigth, _sprite2_width, _sprite2_heigth)
    end
    return {
        x = _x,
        y = _y,
        radius = radius,
        circle_x = _x + radius * 3.5,
        circle_y =_y + radius * 2.7,
        sprite= _sprite,
        sprite2 = _sprite2,
        sprite3 = _sprite3,
        quads = _quads,
        quads2 = _quads2,
        draw = function (self, _frames, move, status, hit)
            if move == true then
                 if (_frames == 1 or _frames == 2) and status == false then
                    self.y = self.y - 10
                    self.circle_y = self.circle_y - 10
                 elseif (_frames == 3  or _frames == 4) and status== false then
                    self.y = self.y + 10
                    self.circle_y = self.circle_y + 10
                end
                love.graphics.draw(self.sprite2, self.quads2[_frames], self.x, self.y)  
                love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
            elseif move == false and hit == true then
                self.y = 200
                love.graphics.draw(self.sprite3, self.x, self.y)
            else
                self.y = 200
                love.graphics.draw(self.sprite, self.quads[_frames], self.x, self.y)
                love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
                self.circle_y = self.y + self.radius * 2.7
            end
        end,
        reset = function (self)
            self.x = 180
            self.y = 200
            self.circle_x = self.x + self.radius * 3.5
            self.circle_y =self.y + self.radius * 2.7
        end
    }
end

return Steve