local Enemy = {}

function Enemy:new(level, color, radius)
    setmetatable({}, Enemy)
    
    self.level = level
    self.color = color or { r = 1, g = 1, b = 1 }
    self.radius = radius or 20
    self.x = math.random(self.radius, love.graphics.getWidth() - self.radius)
    self.y = math.random(self.radius, love.graphics.getHeight() - self.radius)

    return self
end

function Enemy:checkTouched(player_x, player_y, cursor_radius)
    return math.sqrt(math.pow(self.x - player_x, 2) + math.pow(self.y - player_y, 2)) <= cursor_radius * 2
end

function Enemy:move(player_x, player_y)
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
end

function Enemy:draw()
    love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"])
    love.graphics.circle("fill", self.x, self.y, self.radius)

    love.graphics.setColor(1, 1, 1)
end

function Enemy:getEnemyPos()
    return self.x, self.y
end

return Enemy