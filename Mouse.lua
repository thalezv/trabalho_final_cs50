local love = require("love")

--put a cheese skin on the mouse
function Mouse()
    local _radius = 2
    local _sprite = love.graphics.newImage("Cheese_King/queijo_fatia_mouse-.png")
    return{
        radius = _radius,
        sprite = _sprite,
        --drawing the skin at the mouse location and its hitbox since the tip of the skin is larger than the mouse tip
        draw = function(self, mouse_x, mouse_y)
            love.graphics.circle("fill", mouse_x, mouse_y, self.radius)
            love.graphics.draw(self.sprite, mouse_x - 50, mouse_y - 48)
        end
    }
end

return Mouse