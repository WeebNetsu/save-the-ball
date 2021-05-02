local Button = {}

function Button:new(func, text_color, button_color, width, height)
    setmetatable({}, Button)
    
    self.text_color = text_color or { r = 0, g = 0, b = 0 } -- black
    self.button_color = button_color or { r = 1, g = 1, b = 1 } -- white
    self.width = width or 100
    self.height = height or 100
    self.func = func or function() print("This button has not function attached") end
    self.text = "No Text"
    self.button_x, self.button_y = 0, 0
    self.text_x, self.text_y = 0, 0

    return self
end

function Button:setButtonColor(red, green, blue)
    self.button_color = { r = red, g = green, b = blue}
end

function Button:checkPressed(mouse_x, mouse_y, cursor_radius)
    if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
        if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
            self.func()
        end
    end
end

-- NOTE: Hovering can make the game crash if not slowed down!
function Button:checkHovered(mouse_x, mouse_y, cursor_radius)
    if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
        if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
            return true
        end
    end

    return false
end

function Button:draw(text, button_x, button_y, text_x, text_y)
    self.text = text or self.text
    self.button_x = button_x or self.button_x
    self.button_y = button_y or self.button_y

    --[[ if text_x < rect_x or text_x > rect_x then
        print("Warning!\tText x position is less or more than button x position!")
    elseif text_y < rect_y or text_y > rect_y then
        print("Warning!\tText y position is less or more than button y position!")
    end ]]

    if text_x then
        self.text_x = text_x + self.button_x
    else
        self.text_x = self.button_x
    end

    if text_y then
        self.text_y = text_y + self.button_y
    else
        self.text_y = self.button_y
    end

    love.graphics.setColor(self.button_color["r"], self.button_color["g"], self.button_color["b"])
    love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)

    love.graphics.setColor(self.text_color["r"], self.text_color["g"], self.text_color["b"])
    love.graphics.print(self.text, self.text_x, self.text_y)

    love.graphics.setColor(1, 1, 1)
end

function Button:getButtonPos()
    return self.button_x, self.button_y
end

function Button:getTextPos()
    return self.text_x, self.text_y
end

return Button