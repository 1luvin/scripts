local Rect = {
    x = 0,
    y = 0,
    size = 50,
    color = {1, 1, 1}
}

function Rect.new(x, y)
    local self = setmetatable({}, Rect)
    self.x = x or 0
    self.y = y or 0
    self.size = 50
    self.color = {1, 1, 1}

    function self:isColliding(rect, xOff, yOff)
        local xOff = xOff or 0
        local yOff = yOff or 0
        return self.x + xOff < rect.x + rect.size and
           self.x + xOff + self.size > rect.x and
           self.y + yOff < rect.y + rect.size and
           self.y + yOff + self.size > rect.y
    end

    return self
end



return Rect