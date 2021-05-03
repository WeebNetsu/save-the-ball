function Enemy(level, color, radius)
    local dice = math.random(1, 4)
    local _x, _y
    radius = radius or 20

    if dice == 1 then -- come from above
        _x = math.random(radius, love.graphics.getWidth())
        _y = -radius * 4
    elseif dice == 2 then -- come from the left
        _x = -radius * 4
        _y = math.random(radius, love.graphics.getHeight())
    elseif dice == 3 then -- come from the bottom
        _x = math.random(radius, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (radius * 4)
    else -- come from the right
        _x = love.graphics.getWidth() + (radius * 4)
        _y = math.random(radius, love.graphics.getHeight())
    end

    return {
        level = level,
        color = color or { r = 1, g = 1, b = 1 },
        radius = radius,
        x = _x,
        y = _y,

        checkTouched = function (self, player_x, player_y, cursor_radius)
            return math.sqrt(math.pow(self.x - player_x, 2) + math.pow(self.y - player_y, 2)) <= cursor_radius * 2
        end,

        move = function (self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
            end
         
            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,

        draw = function (self)
            love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"])
            love.graphics.circle("fill", self.x, self.y, self.radius)

            love.graphics.setColor(1, 1, 1)
        end,

        getPos = function (self)
            return self.x, self.y
        end
    }
end

return Enemy