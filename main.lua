local button = require "Button"
local enemy = require "Enemy"

math.randomseed(os.time())

local game = {
    difficulty = 1, -- the higher the number, the more difficult
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
}

local player = {
    radius = 20,
    x = 30,
    y = 30
}

local buttons = {
    red = 0.6,
    green = 0.6,
    blue = 0.6
}

local fonts = {
    medium = love.graphics.newFont(16)
}

local enemies = {}

local function startGame()
    if game.state["menu"] then
        game.state["menu"] = false
        game.state["running"] = true

        table.insert(enemies, 1, enemy:new(game.difficulty * 1)) -- * 1 since it's only the first enemy
    end
end

function love.load()
    -- love.window.setFullscreen(true, "desktop")
    -- local mouse_x, mouse_y = love.mouse.getPosition()
    love.mouse.setVisible(false) -- makes mouse invisible
    
    play_button = button:new(startGame, nil, {r = buttons["red"], g = buttons["green"], b = buttons["blue"]}, 120, 40)
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)
            end
        end
    elseif game.state["menu"] then
        -- if play_button:checkHovered(player.x, player.y, player.radius) then
        --     play_button:setButtonColor(0.7, 0.7, 0.7)
        -- else
        --     play_button:setButtonColor(buttons.red, buttons.green, buttons.blue)
        -- end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                play_button:checkPressed(x, y, player.radius)
            end
        end 
    end
end

function love.draw()
    love.graphics.setFont(fonts.medium)

    if game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius)

        for i = 1, #enemies do
            enemies[i]:draw()
        end
    elseif game.state["menu"] then
        -- love.graphics.setColor(1, 1, 1)
        -- love.graphics.rectangle("fill", 20, 20, 100, 50)
        -- love.graphics.setColor(0, 0, 0)
        -- love.graphics.print("Hello", 60, 45)
        play_button:draw("Play Game", 10, 20, 17, 10)
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end