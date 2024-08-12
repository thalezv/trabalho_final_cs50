local love = require("love")

--properties of the enemy, which is called lunna
function Lunna()
    local _x = -320  -- -120 max, -320 begin, -660 screen off
    local _y = -50
    local _sprite = love.graphics.newImage("Cheese_King/luna_sheet.png")
    local _sprite_width = 2676
    local _sprite_heigth = 569
    local _one_width = 669
    local _one_heigth = 569
    local _quads = {}
    --create new images using frames from the sheet
    for i = 1, _sprite_width / _one_width do
        _quads[i] = love.graphics.newQuad(_one_width * (i - 1), 0, _one_width, _one_heigth, _sprite_width, _sprite_heigth)
    end
    return {
        x = _x,
        y = _y,
        sprite= _sprite,
        quads = _quads,
        --movement of the enemy towards the player, depending on whether he was hit
        move = function(self, hit, dt, cb)
            --kill the player
            if self.x >= - 120 then
                self.x = -120
                self.x = self.x
            else
                --while the player is walking
                if not hit then
                    --cb refers to the jagador having been hit in recent times
                    --if zero the enemy retreats, if more than 0 the enemy stays in position waiting for the player to 'move away'
                    if self.x > -660 and cb == 0 then
                        self.x = self.x - dt * 200
                    else
                        self.x = self.x
                    end
                else
                    --if the player was hit, lunna advances at a speed of three advances = total value (kill)
                    if self.x < -120 then
                        self.x = self.x + dt * 200
                    end
                end
            end 
        end,
        --the enemy does not have a hitbox as the condition for it to hit the player is only to reach -120
        kill = function (self)
            if self.x == -120 then
                return true
            else
                return false
            end
        end,
        --draw lunna's frame depending on main's request
        draw = function (self, _frames)
            love.graphics.draw(self.sprite, self.quads[_frames], self.x, self.y)
        end
    }
end

return Lunna