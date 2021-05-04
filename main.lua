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
    },
    menu_state = {},
    ended_state = {}
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

local function startNewGame()
    -- if game.state["menu"] then
    game.state["menu"] = false
    game.state["running"] = true
    game.points = 0

    table.insert(enemies, 1, enemy(game.difficulty * 1)) -- * 1 since it's only the first enemy
    -- end
end

local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end

function love.load()
    -- love.window.setFullscreen(true, "desktop")
    -- local mouse_x, mouse_y = love.mouse.getPosition()
    love.mouse.setVisible(false) -- makes mouse invisible
    love.window.setTitle("Save the Ball!")

    buttons.menu_state.play_game = button(startNewGame, nil, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 120, 40)
    buttons.menu_state.settings = button(nil, nil, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 120, 40)
    buttons.menu_state.exit_game = button(love.event.quit, nil, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 120, 40)

    buttons.ended_state.replay_game = button(startNewGame, nil, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 100, 50)
    buttons.ended_state.menu = button(changeGameState, "menu", nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 100, 50)
    buttons.ended_state.exit_game = button(love.event.quit, nil, nil, {r = buttons.colors["red"], g = buttons.colors["green"], b = buttons.colors["blue"]}, 100, 50)
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                enemies[i]:move(player.x, player.y)

                if math.floor(game.points) == 10 then
                    table.insert(enemies, 1, enemy(game.difficulty * 2))
                    game.points = game.points + 1
                end
            else
                game.state["ended"] = true
                game.state["running"] = false
            end
        end
        
        game.points = game.points + dt
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do -- checj if one of the buttons were pressed
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            elseif game.state["ended"] then
                for index in pairs(enemies) do -- remove all enemies from the game
                    enemies[index] = nil
                end

                for index in pairs(buttons.ended_state) do -- checj if one of the buttons were pressed
                    buttons.ended_state[index]:checkPressed(x, y, player.radius)
                end
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
        buttons.menu_state.play_game:draw("Play Game", 10, 20, 17, 10)
        buttons.menu_state.settings:draw("Settings", 10, 70, 17, 10)
        buttons.menu_state.exit_game:draw("Exit Game", 10, 120, 17, 10)
        -- love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    elseif game.state["ended"] then
        -- love.event.quit() -- quits love
        love.graphics.setFont(fonts.large.font)
        buttons.ended_state.replay_game:draw("Replay", love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.8, 10, 10)
        buttons.ended_state.menu:draw("Menu", love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.53, 17, 10)
        buttons.ended_state.exit_game:draw("Quit", love.graphics.getWidth() / 2.25, love.graphics.getHeight() / 1.33, 22, 10)

        love.graphics.setFont(fonts.medium.font)
        love.graphics.printf(math.floor(game.points), fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), "center")
    end

   if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
   end
end