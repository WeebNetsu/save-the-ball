local button = require "Button"
local enemy = require "Enemy"

math.randomseed(os.time())

local game = {
    difficulty = 1, -- the higher the number, the more difficult
    state = {
        menu = false,
        paused = false,
        running = false,
        ended = true
    },
    points = 0
}

local player = {
    radius = 20,
    x = 30,
    y = 30
}

local buttons = {
    colors = {
        red = 0.6,
        green = 0.6,
        blue = 0.6
    }
}

local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    massive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}

local enemies = {}

local function startGame()
    -- if game.state["menu"] then
    game.state["menu"] = false
    game.state["running"] = true
    game.points = 0

    table.insert(enemies, 1, enemy(game.difficulty * 1)) -- * 1 since it's only the first enemy
    -- end
end

function love.load()
    -- love.window.setFullscreen(true, "desktop")
    -- local mouse_x, mouse_y = love.mouse.getPosition()
    love.mouse.setVisible(false) -- makes mouse invisible
    love.window.setTitle("Save the Ball!")

    buttons.play_game = button(startGame, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 120, 40)
    buttons.replay_game = button(startGame, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 100, 50)
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)

                game.points = game.points + dt
            else
                game.state["ended"] = true
                game.state["running"] = false
            end
        end
    elseif game.state["menu"] then
    elseif game.state["ended"] then
    end
end
-- 
function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                buttons.play_game:checkPressed(x, y, player.radius)
            elseif game.state["ended"] then
                for index in pairs (enemies) do -- remove all enemies from the game
                    enemies[index] = nil
                end

                buttons.replay_game:checkPressed(x, y, player.radius)
            end
        end
    end
end

function love.draw()
    love.graphics.setFont(fonts.medium.font)

    if game.state["running"] then
        love.graphics.printf(math.floor(game.points), fonts.large.font, 0, 10, love.graphics.getWidth(), "center")

        for i = 1, #enemies do
            enemies[i]:draw()
        end

        love.graphics.circle("fill", player.x, player.y, player.radius)
    elseif game.state["menu"] then
        buttons.play_game:draw("Play Game", 10, 20, 17, 10)
        -- love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    elseif game.state["ended"] then
        -- love.event.quit() -- quits love
        love.graphics.setFont(fonts.large.font)
        buttons.replay_game:draw("Replay", love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.8, 10, 10)
        love.graphics.setFont(fonts.medium.font)
        love.graphics.printf(math.floor(game.points), fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), "center")
    end

   if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
   end
end