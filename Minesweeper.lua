--[[
This has been wroten for Shockless
It is a simple Minesweeper rendered game using the Love2D game framework.
-]]

-- constants
local GRID_WIDTH = 10
local GRID_HEIGHT = 10
local CELL_SIZE = 40

-- function to initialize the minesweeper grid
local function initialize_grid(width, height)
    local grid = {}
    for i = 1, height do
        grid[i] = {}
        for j = 1, width do
            grid[i][j] = {
                is_bomb = false,
                is_revealed = false,
                adjacent_bombs = 0
            }
        end
    end
    return grid
end

-- function to randomly place bombs on the grid
local function place_bombs(grid, num_bombs)
    local width = #grid[1]
    local height = #grid

    for _ = 1, num_bombs do
        local x, y
        repeat
            x = math.random(1, width)
            y = math.random(1, height)
        until not grid[y][x].is_bomb
        grid[y][x].is_bomb = true
    end
end

-- function to count adjacent bombs for each cell
local function count_adjacent_bombs(grid)
    local width = #grid[1]
    local height = #grid

    for i = 1, height do
        for j = 1, width do
            if not grid[i][j].is_bomb then
                local count = 0
                for dx = -1, 1 do
                    for dy = -1, 1 do
                        local nx, ny = j + dx, i + dy
                        if nx >= 1 and nx <= width and ny >= 1 and ny <= height and grid[ny][nx].is_bomb then
                            count = count + 1
                        end
                    end
                end
                grid[i][j].adjacent_bombs = count
            end
        end
    end
end

-- function to render the Minesweeper grid
local function render_grid(grid)
    for i, row in ipairs(grid) do
        for j, cell in ipairs(row) do
            local x = (j - 1) * CELL_SIZE
            local y = (i - 1) * CELL_SIZE

            -- render background
            love.graphics.setColor(128, 128, 128)
            love.graphics.rectangle("fill", x, y, CELL_SIZE, CELL_SIZE)

            -- Render cell contents
            if cell.is_revealed then
                if cell.is_bomb then
                    love.graphics.setColor(255, 0, 0)
                    love.graphics.print("*", x + CELL_SIZE / 2 - 5, y + CELL_SIZE / 2 - 10)
                elseif cell.adjacent_bombs > 0 then
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.print(tostring(cell.adjacent_bombs), x + CELL_SIZE / 2 - 5, y + CELL_SIZE / 2 - 10)
                end
            end
        end
    end
end

-- main function to run the game
local function main()
    love.window.setMode(GRID_WIDTH * CELL_SIZE, GRID_HEIGHT * CELL_SIZE)
    love.window.setTitle("Minesweeper") -- initialize GUI and set it's title

    -- init grid
    local grid = initialize_grid(GRID_WIDTH, GRID_HEIGHT)

    -- place bombs randomly
    place_bombs(grid, math.floor(GRID_WIDTH * GRID_HEIGHT * 0.15))

    -- count adjacent bombs
    count_adjacent_bombs(grid)

    -- rendergrid
    love.graphics.setColor(255, 255, 255)
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.clear()
    render_grid(grid)
    love.graphics.present()
end

-- run the game
main()
