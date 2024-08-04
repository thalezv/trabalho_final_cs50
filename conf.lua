local love = require("love")

--settings, 1500x444 screen, icon and window name
function love.conf(t)
    t.window.title = "Cheese King"
    t.window.icon = "Cheese_King/queijo_real.png"
    t.window.resizable = false
    t.window.width = 1500
    t.window.height = 444
    t.window.display = 1
end