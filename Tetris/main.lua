local Rect = require("rect")
local Block = require("block")

local rects = {}
local fallingBlock = nil
local blocks = {}

local currentScore = 0
local waitingForStart = true

local function throwRandomBlock()
    local i = math.random(#blocks)
    local rr = {}
    for _, rect in ipairs(blocks[i].rects) do
        local r = Rect.new(rect.x, rect.y)
        table.insert(rr, r)
    end
    fallingBlock = Block.new(rr)
end

local function checkLine()
    for y = 19, 0, -1 do
        local lineRects = {}
        local yy = y * Rect.size
        for x = 0, 9 do
            local xx = x * Rect.size
            for _, rect in ipairs(rects) do
                if rect.x == xx and rect.y == yy then
                    table.insert(lineRects, rect)
                end
            end
        end
        -- if there is a line
        if #lineRects == 10 then
            -- removing line rects from global rects
            for i = #rects, 1, -1 do
                local r = rects[i]
                for _, lineRect in ipairs(lineRects) do
                    if lineRect.x == r.x and lineRect.y == r.y then
                        table.remove(rects, i)
                    end
                end
            end
            -- moving above rects down a line
            for _, rect in ipairs(rects) do
                if rect.y < lineRects[1].y then
                    rect.y = rect.y + rect.size
                end
            end

            currentScore = currentScore + 1
            love.window.setTitle("Current score: " .. currentScore)
        end
    end
end

local function checkEndGame()
    for _, rect in ipairs(rects) do
        if rect.y < rect.size * 5 then
            love.window.setTitle("Game is ended with score: " .. currentScore)
            waitingForStart = true
            break
        end
    end
end

function love.load()
    local block1 = Block.new({
        Rect.new(0, 0),
        Rect.new(Rect.size, 0),
        Rect.new(Rect.size * 2, 0),
        Rect.new(Rect.size * 3, 0)
    })
    table.insert(blocks, block1)

    local block2 = Block.new({
        Rect.new(0, 0),
        Rect.new(0, Rect.size),
        Rect.new(0, Rect.size * 2)
    })
    table.insert(blocks, block2)

    local block3 = Block.new({
        Rect.new(0, 0),
        Rect.new(0, Rect.size),
        Rect.new(Rect.size, 0)
    })
    table.insert(blocks, block3)

    local block4 = Block.new({
        Rect.new(0, Rect.size),
        Rect.new(Rect.size, Rect.size),
        Rect.new(Rect.size * 2, Rect.size),
        Rect.new(Rect.size * 2, 0)
    })
    table.insert(blocks, block4)
end

local updateTime = 0.1
local globalDt = 0
function love.update(dt)
    globalDt = globalDt + dt
    if globalDt < updateTime then
        return
    end
    globalDt = globalDt - updateTime

    if fallingBlock == nil then
        return
    end

    fallingBlock:update(rects)
    if fallingBlock.hasFallen then
        for i = 1, #fallingBlock.rects do
            table.insert(rects, fallingBlock.rects[i])
        end
        fallingBlock = nil
        checkLine()
        -- checking if the game has ended
        checkEndGame()
        if waitingForStart == false then
            throwRandomBlock()
        end
    end
end

function love.draw()
    for _, rect in ipairs(rects) do
        love.graphics.setColor(rect.color)
        love.graphics.rectangle(
            "fill",
            rect.x, rect.y,
            rect.size, rect.size
        )
    end

    if fallingBlock ~= nil then
        fallingBlock:draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and waitingForStart then
        waitingForStart = false
        love.window.setTitle("Current score: 0")
        rects = {}
        throwRandomBlock()
    elseif (key == "left" or key == "right") and fallingBlock ~= nil then
        fallingBlock:move(key, rects)
    end
end