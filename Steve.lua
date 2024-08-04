local love = require("love")

--properties of the main character, named Steve, location fixed by the x and y axis near the left side of the screen
function Steve()
    local _x = 180
    local _y = 200
    local _radius = 60
    --first sheet, walking movements
    local _sprite = love.graphics.newImage("Cheese_King/steve_sheet.png")
    local _sprite_width = 2681
    local _sprite_heigth = 285
    --second sheet, jumping movement
    local _sprite2 = love.graphics.newImage("Cheese_King/steve_pulo.png")
    local _sprite2_width = 1340
    local _sprite2_heigth = 285
    --last image, single frame, struck character, how is single image given the single image property of the other sheets
    local _sprite3 = love.graphics.newImage("Cheese_King/steve_pedrinha.png")
    local _one_width = 335
    local _one_heigth = 285
    local _quads = {}
    local _quads2 = {}
    --splitting the motion sprite
    for i = 1, _sprite_width / _one_width do
        _quads[i] = love.graphics.newQuad(_one_width * (i - 1), 0, _one_width, _one_heigth, _sprite_width, _sprite_heigth)
    end
    --splitting the jumping sprite
    for j = 1, _sprite2_width / _one_width do
        _quads2[j] = love.graphics.newQuad(_one_width * (j - 1), 0, _one_width, _one_heigth, _sprite2_width, _sprite2_heigth)
    end
    return {
        x = _x,
        y = _y,
        radius = _radius,
        circle_x = _x + _radius * 3.5,
        circle_y =_y + _radius * 2.7,
        sprite= _sprite,
        sprite2 = _sprite2,
        sprite3 = _sprite3,
        quads = _quads,
        quads2 = _quads2,
        --[[as the doll doesn't leave the place, and only goes up on the y axis, on the same shelf going down too, after all the 'mobility' is through the sprite frames,
        and since moving has 8 frames and jumping 4, you can identify by status = jump, 2 to go up and 2 to go down, draw sprite2(jump)
        both to walk and to be hit, I bring the player to the fixed y axis to prevent bugs from being hit in mid-air or jumping quickly.
        hit true, use sprite3(hit), and not status(jump) and not hit, use sprite(running)
        ]]
        draw = function (self, frames, move, status, hit)
            if move == true then
                 if (frames == 1 or frames == 2) and status == false then
                    self.y = self.y - 10
                    self.circle_y = self.circle_y - 10
                 elseif (frames == 3  or frames == 4) and status== false then
                    self.y = self.y + 10
                    self.circle_y = self.circle_y + 10
                end
                love.graphics.draw(self.sprite2, self.quads2[frames], self.x, self.y)  
                love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
            elseif move == false and hit == true then
                self.y = 200
                love.graphics.draw(self.sprite3, self.x, self.y)
            else
                self.y = 200
                love.graphics.draw(self.sprite, self.quads[frames], self.x, self.y)
                love.graphics.circle("line", self.circle_x, self.circle_y, self.radius, 0)
                self.circle_y = self.y + self.radius * 2.7
            end
        end,
        --mainly resets the character's jump
        reset = function (self)
            self.x = 180
            self.y = 200
            self.circle_x = self.x + self.radius * 3.5
            self.circle_y =self.y + self.radius * 2.7
        end
    }
end

return Steve