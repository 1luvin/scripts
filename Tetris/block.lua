local Rect = require("rect")

local Block = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    rects = {},
    hasFallen = false
}

function Block.new(rects)
    local self = setmetatable({}, Block)
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.rects = rects
    self.hasFallen = false

    -- settings random color for rects
    local blockColor = {math.random(), math.random(), math.random()}
    for _, rect in ipairs(self.rects) do
        rect.color = blockColor
    end

    -- Calculating width and height
    local maxX = -math.huge
    local maxY = -math.huge
    for _, rect in ipairs(self.rects) do
        if rect.x > maxX then
            maxX = rect.x
        end
        if rect.y > maxY then
            maxY = rect.y
        end
    end
    self.width = maxX + Rect.size
    self.height = maxY + Rect.size

    function self:setX(x)
        local diff = x - self.x
        self.x = x
        for _, rect in ipairs(self.rects) do
            rect.x = rect.x + diff
        end
    end

    function self:setY(y)
        local diff = y - self.y
        self.y = y
        for _, rect in ipairs(self.rects) do
            rect.y = rect.y + diff
        end
    end

    local function isColliding(globalRects, xOff, yOff)
        local xOff = xOff or 0
        local yOff = yOff or 0

        -- with the global rects
        for _, rect in ipairs(self.rects) do
            for _, globalRect in ipairs(globalRects) do
                if rect:isColliding(globalRect, xOff, yOff) then
                    return true
                end
            end
        end
        
        -- with the walls
        if self.x + xOff < 0 or self.x + xOff > love.graphics.getWidth() - self.width then
            return true
        end

        -- with the floor
        if self.y + yOff > love.graphics.getHeight() - self.height then
            return true
        end

        return false
    end

    function self:update(globalRects)
        if isColliding(globalRects, 0, Rect.size) then
            self.hasFallen = true
            return
        end

        self:setY(self.y + Rect.size)
    end

    function self:draw()
        for _, rect in ipairs(self.rects) do
            love.graphics.setColor(rect.color)
            love.graphics.rectangle(
                "fill",
                rect.x, rect.y,
                rect.size, rect.size
            )
        end
    end

    function self:move(key, globalRects)
        if key == "left" and isColliding(globalRects, -Rect.size, 0) == false then
            self:setX(self.x - Rect.size)
        elseif key == "right" and isColliding(globalRects, Rect.size, 0) == false then
            self:setX(self.x + Rect.size)
        end
    end

    return self
end

return Block