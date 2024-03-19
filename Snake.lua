--[[
     _                _    _                         
 ___| |__   ___   ___| | _| | ___  ___ ___   ___ ___ 
/ __| '_ \ / _ \ / __| |/ / |/ _ \/ __/ __| / __/ __|
\__ \ | | | (_) | (__|   <| |  __/\__ \__ \| (_| (__ 
|___/_| |_|\___/ \___|_|\_\_|\___||___/___(_)___\___|
                                                     
-]]

-- Snake game
local SnakeGame = {
    -- properties
    width = 20,     -- width of the game area
    height = 10,    -- height of the game area
    snake = {},     -- snake segments
    food = {},      -- food position
    direction = "right", -- initial direction
    running = false,    -- game state
    score = 0       -- player score
}

-- function to start the game
function SnakeGame:start()
    -- init the snake at the center of the game area
    self.snake = {{x = math.floor(self.width / 2), y = math.floor(self.height / 2)}}
    
    -- place the initial food randomly
    self:placeFood()

    -- set game state to running
    self.running = true

    -- reset score
    self.score = 0
end

-- function to place food randomly
function SnakeGame:placeFood()
    -- place food at a random position within the game area
    self.food = {
        x = math.random(1, self.width),
        y = math.random(1, self.height)
    }
end

-- function to move the snake
function SnakeGame:move()
    -- determine the next position of the head based on the current direction
    local head = self.snake[1]
    local nextX, nextY

    if self.direction == "up" then
        nextX, nextY = head.x, head.y - 1
    elseif self.direction == "down" then
        nextX, nextY = head.x, head.y + 1
    elseif self.direction == "left" then
        nextX, nextY = head.x - 1, head.y
    elseif self.direction == "right" then
        nextX, nextY = head.x + 1, head.y
    end

    -- check if the snake collides with the game boundaries or itself
    if nextX < 1 or nextX > self.width or nextY < 1 or nextY > self.height or self:isCollidingWithSnake(nextX, nextY) then
        -- game over
        self.running = false
        print("Game Over! Score:", self.score)
        return
    end

    -- move the snake
    table.insert(self.snake, 1, {x = nextX, y = nextY})

    -- check if the snake eats the food
    if nextX == self.food.x and nextY == self.food.y then
        -- increase score
        self.score = self.score + 1
        -- place new food
        self:placeFood()
    else
        -- remove the tail segment if not eating food
        table.remove(self.snake)
    end
end

-- function to check if the snake collides with itself
function SnakeGame:isCollidingWithSnake(x, y)
    for i, segment in ipairs(self.snake) do
        if segment.x == x and segment.y == y then
            return true
        end
    end
    return false
end

-- function to draw the game on the console
function SnakeGame:draw()
    -- clear the console in cs2
    os.execute("clear")

    -- draw the game area
    for y = 1, self.height do
        for x = 1, self.width do
            -- draw snake body
            local isSnake = false
            for i, segment in ipairs(self.snake) do
                if segment.x == x and segment.y == y then
                    isSnake = true
                    break
                end
            end
            if isSnake then
                io.write("#")
            -- draw food
            elseif x == self.food.x and y == self.food.y then
                io.write("F")
            else
                io.write(".")
            end
        end
        io.write("\n")
    end
end

-- example usage:
math.randomseed(os.time()) -- seed random number generator
SnakeGame:start()
while SnakeGame.running do
    SnakeGame:draw()
    SnakeGame:move()
    -- simulate game speed
    os.execute("sleep 0.2")
end
