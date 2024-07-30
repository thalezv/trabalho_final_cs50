function Lunna()
    local _x = -320  -- -120 max, -320 inicio, -660 esconde
    local _y = -50
    local _sprite = love.graphics.newImage("Cheese_King/luna_sheet.png")
    local _sprite_width = 2676
    local _sprite_heigth = 569
    local _one_width = 669
    local _one_heigth = 569
    local _quads = {}
    for i = 1, _sprite_width / _one_width do
        _quads[i] = love.graphics.newQuad(_one_width * (i - 1), 0, _one_width, _one_heigth, _sprite_width, _sprite_heigth)
    end
    return {
        x = _x,
        y = _y,
        sprite= _sprite,
        quads = _quads,
        move = function(self, hit, dt, cb)
            if self.x == - 120 then
                self.x = self.x
            else
                if not hit then
                    if self.x > -660 and cb == 0 then
                        self.x = self.x - dt * 200
                    else
                        self.x = self.x
                    end
                else
                    if self.x <= -120 then
                        self.x = self.x + dt * 200
                    end
                end
            end 
        end,

        kill = function (self)
            if self.x > -120 then
                return true
            else
                return false
            end
        end,

        draw = function (self, _frames)
            love.graphics.draw(self.sprite, self.quads[_frames], self.x, self.y)
        end
    }
end

return Lunna