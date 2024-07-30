-- requires framework and anothers .lua archives assistents

 _G.love = require("love")
local Steve = require("Steve")
local Lunna = require("Lunna")
local Mouse = require("Mouse")
local Button = require("Button")
local SFX = require("SFX")
local Pedra = require("Pedra")
local Queijo = require("Queijo")
local BackGround = require("BackGround")
require("Globals")

-- characters
local file_data = read("save")
local high_score_value = file_data.pontuacao[1].high_score
local nome = ""
local time_init
local time_space = 7.5
local intros = {
    title = "Cheese King",
    logo = love.graphics.newImage("Cheese_King/queijo_real.png"),
    creator = "Thales Tenorio de Medeiros",
    space = "Press space to Jump",
    pause = "S to Pause"
}
local game = {
    state = {
        intro1 = true,
        intro2 = false,
        menu = false,
        configurations = false,
        paused = false,
        running = false,
        pontuacao = false,
        ended = false
    },
    points = 0,
    level_change = {50, 200, 500, 1000, 3000},
    difficult = 1,
    high_score = 0,
    randominit_r = 0,
    randomend_r = 0,
    randomrock = 0,
    randominit_c = 0,
    randomend_c = 0,
    randomcheese = 0,
    cheeses = {},
    cheese_space = 6,
    cheese_icon = love.graphics.newImage("Cheese_King/queijo_fatia.png"),
    cheese_round = 0
}     
_G.background = BackGround()
_G.audio = SFX()
local buttons = {
    menu_state = {},
    ended_state = {},
    pontuacao_state = {},
    paused_state = {},
    configurations_state = {}
}
_G.mouse = {
    mouse_x = 0,
    mouse_y = 0,
    Mouse()
}
_G.player = {
    Steve(),
    animation = {
        idle = true,
        jump = false,
        hit = false,
        frame = 1,
        max_frames = 8,
        timer = 0.1,
        jump_timer = 0.1,
        hit_timer = 0.1
    }
}
_G.enemy = {
    Lunna(),
    callback = 0,
    animation_e = {
        idle = true,
        frame = 1,
        max_frames = 4,
        timer = 0.1
    }
}
_G.stone = { }
_G.coletavel = { }
-- assistent functions
local function changeGameState(state)
    game.state["intro1"] = state == "intro1"
    game.state["intro2"] = state == "intro2"
    game.state["menu"] = state == "menu"
    game.state["running"] = state == "running"
    game.state["paused"] = state == "paused"
    game.state["ended"] = state == "ended"
    game.state["pontuacao"] = state =="pontuacao"
    game.state["configurations"] = state == "configurations"
end
local function changeVolume(volume)
    audio:volume(volume)
end
local function changeAudio()
    audio:PandS_BGM()
end
local function startNewGame()
    nome = ""
    enemy.callback = 0
    for i = #stone, 1, -1 do 
        table.remove(stone, i)
    end
    for j = #coletavel, 1, -1 do
        table.remove(coletavel, j)
    end
    for l = #game.cheeses, 1, -1 do
        table.remove(game.cheeses, l)
    end
    game.level_change[1] = 50
    game.difficult = 1
    table.insert(stone, Pedra(game.difficult))
    table.insert(coletavel, Queijo(game.difficult))
    changeGameState("running")
    game.cheese_space = 6
    player[1]:reset()
    player.animation.jump = false
    player.animation.hit = false
    enemy.animation_e.frame = 1
    player.animation.frame = 1
    player.animation.jump_timer = 0.1
    player.animation.hit_timer = 0.1
    player.animation.timer = 0.1
    enemy.animation_e.timer = 0.1
    game.points = 0
    enemy[1].x = -320
    high_score_value = file_data.pontuacao[1].high_score
    game.cheese_round = 0
    game.high_score = 0
    game.randominit_r = 10
    game.randomend_r = game.level_change[1]
    game.randomrock = math.random(game.randominit_r, game.randomend_r)
    game.randominit_c = 10
    game.randomend_c = game.level_change[2]
    game.randomcheese = math.random(game.randominit_c, game.randomend_c)
    for i = 1, 5 do
        table.insert(game.cheeses, game.randomcheese + (game.cheese_space * (i - 1)))
    end
end
local function save()
    table.insert(file_data.pontuacao, {name = nome, high_score = game.high_score})
    table.sort(file_data.pontuacao, function(a, b) return a.high_score > b.high_score end)
    if #file_data.pontuacao == 4 then
        table.remove(file_data.pontuacao, 4)
    end
    file_data.queijo = file_data.queijo + game.cheese_round
    write("save", file_data)
    file_data = read("save")
    changeGameState("ended")
end
local function credit()
    time_init = love.timer.getTime()
    changeGameState("intro1")
end
function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, mouse[1].radius)
                end
            elseif game.state["ended"] then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y, mouse[1].radius)
                end
            elseif game.state["paused"] then
                for index in pairs(buttons.paused_state) do
                    buttons.paused_state[index]:checkPressed(x, y, mouse[1].radius)
                end
            elseif game.state["configurations"] then
                for index in pairs(buttons.configurations_state) do
                    buttons.configurations_state[index]:checkPressed(x, y, mouse[1].radius)
                end
            elseif game.state["pontuacao"] then
                for index in pairs(buttons.pontuacao_state) do
                    buttons.pontuacao_state[index]:checkPressed(x, y, mouse[1].radius)
                end
            end
        end
    end
end

-- load,update and draw love
function love.load()
    time_init = love.timer.getTime()
    love.mouse.setVisible(false)
    buttons.menu_state.play_game = Button("play game", startNewGame, nil)
    buttons.menu_state.settings = Button("settings", changeGameState, "configurations")
    buttons.menu_state.creditos = Button("credits", credit, nil)
    buttons.menu_state.exit_game = Button("exit game", love.event.quit, nil)
    buttons.pontuacao_state.name = Button("name: ", nil, nil)
    buttons.pontuacao_state.nameinput = Button(nome, nil, nil)
    buttons.pontuacao_state.confirm = Button("confirm", nil, nil)
    buttons.ended_state.replay_game = Button("replay game", startNewGame, nil)
    buttons.ended_state.menu = Button("menu", changeGameState, "menu")
    buttons.ended_state.exit_game = Button("exit game", love.event.quit, nil)
    buttons.paused_state.resume_game = Button("resume", changeGameState, "running")
    buttons.paused_state.replay_game = Button("replay game", startNewGame, nil)
    buttons.paused_state.menu = Button("menu", changeGameState, "menu")
    buttons.paused_state.exit_game = Button("exit game", love.event.quit, nil)
    buttons.configurations_state.play_Stop_audio = Button("", nil, nil)
    buttons.configurations_state.audio = Button("Audio: ", nil, nil)
    buttons.configurations_state.one = Button("1", changeVolume, 0.1)
    buttons.configurations_state.two = Button("2", changeVolume, 0.2)
    buttons.configurations_state.three = Button("3", changeVolume, 0.3)
    buttons.configurations_state.four = Button("4", changeVolume, 0.4)
    buttons.configurations_state.five = Button("5", changeVolume, 0.5)
    buttons.configurations_state.back = Button("Back", changeGameState, "menu")

end

function love.update(dt)
    mouse.mouse_x, mouse.mouse_y = love.mouse.getPosition()
    if game.state["intro1"] then
        local time_count = love.timer.getTime()
        if time_count - time_init >= time_space then
            time_init = time_count
            changeGameState("intro2")
        end
    end
    if game.state["intro2"] then
        local time_count = love.timer.getTime()
        if time_count - time_init >= time_space then
            changeGameState("menu")
        end
    end
    if game.state["running"] then
        player.animation.idle = false
        enemy.animation_e.idle = false
        game.points = game.points + (dt * 8)
        if enemy[1]:kill() then
            if game.high_score > high_score_value or #file_data.pontuacao < 3 then
                changeGameState("pontuacao")
            elseif file_data.pontuacao[2] ~= nil then
                if game.high_score > file_data.pontuacao[2].high_score then
                    changeGameState("pontuacao")
                end
            elseif file_data.pontuacao[3] ~= nil then
                if game.high_score > file_data.pontuacao[3].high_score then
                    changeGameState("pontuacao")
                end
            else
                changeGameState("ended")
                file_data.queijo = file_data.queijo + game.cheese_round
                write("save", file_data)
                file_data = read("save")
            end
        else
            enemy[1]:move(player.animation.hit, dt, enemy.callback)
        end
        for i = 1, #coletavel do 
            coletavel[i]:move(dt, player.animation.jump)
            for j = 1, #stone do
                if calculateDistance(stone[j].circle_x, stone[j].circle_y, coletavel[i].circle_x, coletavel[i].circle_y) <= coletavel[i].radius * 2 then
                    coletavel[i].y = coletavel[i].y - 10
                    coletavel[i].circle_y = coletavel[i].circle_y - 10
                end
            end
        end
        for i = 1, #stone do 
            stone[i]:move(dt, player.animation.jump)
        end
        if math.floor(game.points) > game.high_score and game.high_score then
            game.high_score = math.floor(game.points)
            if math.floor(game.points) % game.level_change[2] == 0 and math.floor(game.points) > 0 and math.floor(game.points) <= game.level_change[4] then
                game.level_change[1] = game.level_change[1] - 5
                game.difficult = game.difficult + 1
                game.cheese_space = game.cheese_space - 1
                for i = 1, #game.cheeses do
                    game.cheeses[i] = game.cheeses[i] - 1
                end
                for j = 1, #stone do
                    stone[j].speed = stone[j].speed + 20
                    stone[j].lvl = stone[j].lvl + 1
                end
            end
            if math.floor(game.points) % game.level_change[3] == 0 and math.floor(game.points) > game.level_change[4] then
                game.level_change[1] = game.level_change[1] - 1
                game.difficult = game.difficult + 1    
                for j = 1, #stone do
                    stone[j].speed = stone[j].speed + 20
                    stone[j].lvl = stone[j].lvl + 1
                end     
            end
            if math.floor(game.points) % game.level_change[4] == 0 and math.floor(game.points) >= game.level_change[5] and game.level_change[1] >= 11 then
                game.level_change[1] = game.level_change[1] - 1
                game.difficult = game.difficult + 1
                if game.difficult < 8 then
                    for j = 1, #stone do
                        stone[j].speed = stone[j].speed + 20
                        stone[j].lvl = stone[j].lvl + 1
                    end
                end
            end
            if math.floor(game.points) == game.randomrock  and math.floor(game.points) > 0 then
                game.randominit_r = math.floor(game.points)
                game.randomend_r = game.randominit_r + game.level_change[1]
                game.randomrock = math.random(game.randominit_r, game.randomend_r)
                while game.randomrock - game.randominit_r <= 10 do
                    game.randomrock = math.random(game.randominit_r, game.randomend_r)
                end
                table.insert(stone, Pedra(game.difficult))
            end
            if math.floor(game.points) == game.randomcheese  and math.floor(game.points) > 0 then
                game.randominit_c = math.floor(game.points)
                game.randomend_c = game.randominit_c + game.level_change[2]
                game.randomcheese = math.random(game.randominit_c, game.randomend_c)
                while game.randomcheese - game.randominit_c <= 50 do
                    game.randomcheese = math.random(game.randominit_c, game.randomend_c)
                end
                for i = 1, 5 do
                    table.insert(game.cheeses, game.randomcheese + (game.cheese_space * (i - 1)))
                end
            end
            for i = 1, #game.cheeses do
                if math.floor(game.points) == game.cheeses[i] then
                    table.remove(game.cheeses, game.cheeses[i])
                    table.insert(coletavel, Queijo(game.difficult))
                end
            end
        end
        if love.keyboard.isDown("s") then
            changeGameState("paused")
        end
        function love.keyreleased(key)
            if key == "space" and player.animation.jump == false and player.animation.hit == false and game.state["running"] then
                player.animation.frame = 1
                player.animation.idle = true
                player.animation.jump = true
             end
             if key == "backspace" and game.state["pontuacao"] then
                nome = string.sub(nome, 1, -2)
             end
        end
        for i = #stone, 1, -1 do 
            if calculateDistance(player[1].circle_x, player[1].circle_y, stone[i].circle_x, stone[i].circle_y) <= stone[i].radius * 2 then
                table.remove(stone, i)
                player.animation.frame = 1
                player.animation.idle =true
                player.animation.jump = false
                player.animation.hit = true
                enemy.callback = 1
            elseif stone[i].x <= 0 - stone[i].radius * 3 then
                enemy.callback = 0
                table.remove(stone, i)
            end
        end
        for i = #coletavel, 1, -1 do 
            if calculateDistance(player[1].circle_x, player[1].circle_y, coletavel[i].circle_x, coletavel[i].circle_y) <= coletavel[i].radius * 2 and not player.animation.hit then
                table.remove(coletavel, i)
                game.cheese_round = game.cheese_round + 1
            elseif coletavel[i].x <= 0 - coletavel[i].radius * 3 then
                table.remove(coletavel, i)
            end
        end
         if player.animation.hit then
            player.animation.hit_timer = player.animation.hit_timer + dt
            if player.animation.hit_timer > 0.4 then
                player.animation.hit_timer = 0.1
                player.animation.frame = player.animation.frame + 1
                if player.animation.frame >= player.animation.max_frames then
                    player.animation.jump_timer = 0.1
                    player.animation.hit = false
                    player.animation.idle = false
                    player.animation.frame = 7
                end
            end
         end

        if player.animation.jump then
        player.animation.jump_timer = player.animation.jump_timer + dt
            if player.animation.jump_timer > 0.4 then
                player.animation.jump_timer = 0.1
                player.animation.frame = player.animation.frame + 1
                if player.animation.frame >= player.animation.max_frames / 2 then
                    player.animation.idle = false
                    player.animation.jump = false   
                    player.animation.frame = 6       
                end
            end
        end
    elseif game.state["pontuacao"] then
        function love.textinput(t)
            if #nome < 6 then
                nome = nome .. t
            end
        end
        buttons.pontuacao_state.nameinput = Button(nome, nil, nil)
        if #nome > 0 then
            buttons.pontuacao_state.confirm = Button("confirm", save, nil)
        else
            buttons.pontuacao_state.confirm = Button("confirm", nil, nil)
        end
    else
        if not audio:playing_BGM() then
            buttons.configurations_state.play_Stop_audio = Button("Play", changeAudio, nil)
        else
            buttons.configurations_state.play_Stop_audio = Button("Stop", changeAudio, nil)
        end
        game.points = game.points
        game.high_score = game.high_score
        player.animation.idle = true
        enemy.animation_e.idle = true

    end
    if not player.animation.idle then
        player.animation.timer = player.animation.timer + dt
        if player.animation.timer > 0.4 then
            player.animation.timer = 0.1
            player.animation.frame = player.animation.frame + 1
            if player.animation.frame > player.animation.max_frames then
                player.animation.frame = 4
            end
        end
    end
    if not enemy.animation_e.idle then
        enemy.animation_e.timer = enemy.animation_e.timer + dt
        if enemy.animation_e.timer > 0.25 then
            enemy.animation_e.timer = 0.1
            enemy.animation_e.frame = enemy.animation_e.frame + 1
            if enemy.animation_e.frame > enemy.animation_e.max_frames then
                enemy.animation_e.frame = 1
            end
        end
    end
end

function love.draw()
    background:draw()
    love.graphics.printf("FPS:." .. love.timer.getFPS(), love.graphics.newFont(16), 10, 10, love.graphics.getWidth())
    if game.state["intro1"] then
        love.graphics.draw(intros.logo, love.graphics.getWidth() / 3, -100)
        love.graphics.printf(intros.title, love.graphics.newFont(50), love.graphics.getWidth() / 2.7, 250, love.graphics.getWidth())
    end
    if game.state["intro2"] then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("creator:     " .. intros.creator, love.graphics.newFont(30), love.graphics.getWidth() / 3.5, 50, love.graphics.getWidth())
        love.graphics.printf("In Game", love.graphics.newFont(30), love.graphics.getWidth() / 2.5, 110, love.graphics.getWidth())
        love.graphics.printf(intros.space, love.graphics.newFont(30), love.graphics.getWidth() / 3.8, 200, love.graphics.getWidth())
        love.graphics.printf(intros.pause, love.graphics.newFont(30), love.graphics.getWidth() / 1.8, 200, love.graphics.getWidth())
        love.graphics.setColor(1, 1, 1)
    end
    if game.state["running"] then
        love.graphics.printf(math.floor(game.points), love.graphics.newFont(24), 0, 10, love.graphics.getWidth(), "center")
        love.graphics.push()
        love.graphics.scale(0.5, 0.5)
        love.graphics.draw(game.cheese_icon, love.graphics.getWidth() * 1.7, -90)
        love.graphics.pop()
        love.graphics.printf(":" .. " " .. game.cheese_round, love.graphics.newFont(16), love.graphics.getWidth() - 120, 20, love.graphics.getWidth())
        for i = 1, #stone do 
            stone[i]:draw()
        end
        for i = 1, #coletavel do 
            coletavel[i]:draw()
        end
        player[1]:draw(player.animation.frame, player.animation.jump, game.state["paused"], player.animation.hit)
        enemy[1]:draw(enemy.animation_e.frame)
    end
    if game.state["menu"] then    
        buttons.menu_state.play_game:draw(20, 40, 45, 15)
        buttons.menu_state.settings:draw(20, 100, 45, 15)
        buttons.menu_state.creditos:draw(20, 160, 45, 15)
        buttons.menu_state.exit_game:draw(20, 220, 45, 15)
        love.graphics.push()
        love.graphics.scale(0.5, 0.5)
        love.graphics.draw(game.cheese_icon, love.graphics.getWidth() * 1.7, -90)
        love.graphics.pop()
        love.graphics.printf(":" .. " " .. file_data.queijo, love.graphics.newFont(16), love.graphics.getWidth() - 120, 20, love.graphics.getWidth())
        mouse[1]:draw(mouse.mouse_x, mouse.mouse_y)
    end
    if game.state["configurations"] then
        buttons.configurations_state.play_Stop_audio:draw(20, 40, 45, 15)
        buttons.configurations_state.audio:draw(20, 100, 45, 15)
        buttons.configurations_state.one:draw(120, 100, 45, 15)
        buttons.configurations_state.two:draw(220, 100, 45, 15)
        buttons.configurations_state.three:draw(320, 100, 45, 15)
        buttons.configurations_state.four:draw(420, 100, 45, 15)
        buttons.configurations_state.five:draw(520, 100, 45, 15)
        buttons.configurations_state.back:draw(20, 160, 45, 15)
        mouse[1]:draw(mouse.mouse_x, mouse.mouse_y)
    end
    if game.state["pontuacao"] then
        enemy[1]:draw(enemy.animation_e.frame)
        for i = 1, #stone do 
            stone[i]:draw()
        end
        for i = 1, #coletavel do 
            coletavel[i]:draw()
        end
        buttons.pontuacao_state.name:draw(love.graphics.getWidth() / 2.3, 80, 45, 15)
        buttons.pontuacao_state.nameinput:draw(love.graphics.getWidth() / 2.0, 80, 45, 15)
        buttons.pontuacao_state.confirm:draw(love.graphics.getWidth() / 2.3, 140, 45, 15)
        love.graphics.printf("points: " .. math.floor(game.points), love.graphics.newFont(24), 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        love.graphics.printf("name: " .. file_data.pontuacao[1].name .. "  ".. "highscore: " .. high_score_value, love.graphics.newFont(24), 0, love.graphics.getHeight() / 1.5, love.graphics.getWidth(), "center") 
        mouse[1]:draw(mouse.mouse_x, mouse.mouse_y)
    end
    if game.state["ended"] then
        buttons.ended_state.replay_game:draw(love.graphics.getWidth() / 2.3, 20, 45, 15)
        buttons.ended_state.menu:draw(love.graphics.getWidth() / 2.3, 80, 45, 15)
        buttons.ended_state.exit_game:draw(love.graphics.getWidth() / 2.3, 140, 45, 15)
        for i = 1, #file_data.pontuacao do
            local alinhamento = string.rep(" ", 10 - #file_data.pontuacao[i].name)
            love.graphics.printf(i .. "° " .. file_data.pontuacao[i].name .. alinhamento .. file_data.pontuacao[i].high_score .. " points", love.graphics.newFont(24), 0, love.graphics.getHeight() / (2.5 - (0.3 * i)), love.graphics.getWidth(), "center")
        end
        love.graphics.push()
        love.graphics.scale(0.5, 0.5)
        love.graphics.draw(game.cheese_icon, love.graphics.getWidth() * 1.7, -90)
        love.graphics.pop()
        love.graphics.printf(":" .. " " .. file_data.queijo, love.graphics.newFont(16), love.graphics.getWidth() - 120, 20, love.graphics.getWidth())
        mouse[1]:draw(mouse.mouse_x, mouse.mouse_y)
    end
    if game.state["paused"] then
        if game.high_score >= high_score_value then
            love.graphics.printf("High Score:. " .. game.high_score, love.graphics.newFont(24), 0, 10, love.graphics.getWidth(), "right")
        else
            love.graphics.printf("High Score:. " .. high_score_value, love.graphics.newFont(24), 0, 10, love.graphics.getWidth(), "right")
        end
        love.graphics.printf(math.floor(game.points), love.graphics.newFont(24), 0, 10, love.graphics.getWidth(), "center")
        player[1]:draw(player.animation.frame,player.animation.jump, game.state["paused"], player.animation.hit)
        enemy[1]:draw(enemy.animation_e.frame)
        for i = 1, #stone do 
            stone[i]:draw()
        end
        for i = 1, #coletavel do 
            coletavel[i]:draw()
        end
        buttons.paused_state.resume_game:draw(love.graphics.getWidth() / 2.3, 50, 45, 15)
        buttons.paused_state.replay_game:draw(love.graphics.getWidth() / 2.3, 110, 45, 15)
        buttons.paused_state.menu:draw(love.graphics.getWidth() / 2.3, 170, 45, 15)
        buttons.paused_state.exit_game:draw(love.graphics.getWidth() / 2.3, 230, 45, 15)
        love.graphics.push()
        love.graphics.scale(0.5, 0.5)
        love.graphics.draw(game.cheese_icon, love.graphics.getWidth() * 1.7, -10)
        love.graphics.pop()
        love.graphics.printf(":" .. " " .. game.cheese_round, love.graphics.newFont(16), love.graphics.getWidth() - 120, 60, love.graphics.getWidth())
        mouse[1]:draw(mouse.mouse_x, mouse.mouse_y)
    end
end
