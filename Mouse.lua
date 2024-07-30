function Mouse()
    local radius = 2
    local sprite = love.graphics.newImage("Cheese_King/queijo_fatia_mouse-.png")
    return{
        radius = radius,
        sprite = sprite,
        draw = function(self, mouse_x, mouse_y)
            love.graphics.circle("fill", mouse_x, mouse_y, self.radius)
            love.graphics.draw(self.sprite, mouse_x - 50, mouse_y - 48)
        end
    }
end

return Mouse