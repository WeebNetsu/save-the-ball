function Button(func, func_param, text_color, button_color, width, height)
    return {
        text_color = text_color or { r = 0, g = 0, b = 0 }, -- black
        button_color = button_color or { r = 1, g = 1, b = 1 }, -- white
        width = width or 100,
        height = height or 100,
        func = func or function() print("This button has no function attached") end,
        func_param = func_param,
        text = "No Text",
        button_x = 0, 
        button_y = 0,
        text_x = 0, 
        text_y = 0,

        setButtonColor = function (self, red, green, blue)
            self.button_color = { r = red, g = green, b = blue}
        end,

        checkPressed = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
                if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
                    if self.func_param then
                        self.func(self.func_param)
                    else
                        self.func()
                    end
                end
            end
        end,

        draw = function (self, text, button_x, button_y, text_x, text_y)
            self.text = text or self.text
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y
        
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
        end,

        getPos = function (self)
            return self.button_x, self.button_y
        end,

        getTextPos = function (self)
            return self.text_x, self.text_y
        end
    }
end

return Button