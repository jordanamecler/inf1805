function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

directions = Set{"up", "down", "right", "left"}
time = 0
gameover = false
lastKeyPressed = "right"

function newblip ()
  local width, height = love.graphics.getDimensions( )
  local x, y = love.math.random(width /10 - 1) * 10, love.math.random(height/10 - 1) * 10
  local x, y = love.math.random(width/10 - 1) * 10, love.math.random(height/10 - 1) * 10
  return {
    getPosition = function ()
      return x, y
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 10, 10)
    end
  }
end

function snake(x, y)
  local blocks = { block(x, y) }
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local lastUpdate = 0
  return {
    getScore = function ()
      return #blocks
    end,
    getPosition = function()
      return blocks[1].x, blocks[1].y
    end,
    validatePosition = function ()
      local b = blocks[1]
      for i in ipairs(blocks) do
        if i ~= 1 then
          if b.x >= blocks[i].x and b.y >= blocks[i].y and b.x < blocks[i].x + 10 and b.y < blocks[i].y + 10  then
            return false
          end
        end
      end
      return true
    end,
    update = function(self, time)
      local b = blocks[1]
      if time < lastUpdate + 0.05 then
        return true
      elseif b.x + 10 >= screenWidth or b.x -10 <= 0 or b.y + 10 >= screenHeight or b.y -10 <= 0 then
        return false
      end

      lastUpdate = time
      for i in ipairs(blocks) do
        i = #blocks - i + 1
        if i ~= 1 then
          local b = blocks[i]
          b:update(blocks[i - 1])
        end
      end

      if b.direction == "right" then
        b.x = b.x + 10
      elseif b.direction == "left" then
        b.x = b.x - 10
      elseif b.direction == "up" then  
        b.y = b.y - 10
      elseif b.direction == "down" then
        b.y = b.y + 10
      end

      return self.validatePosition()
    end,
    draw = function ()
      for i in ipairs(blocks) do
        local b = blocks[i]
        b:draw()
      end
    end,
    insertBlock = function ()
      local lastBlock = blocks[#blocks]
      
      if lastBlock.direction == "right" then
        table.insert(blocks, block(lastBlock.x - 10, lastBlock.y))
      elseif lastBlock.direction == "left" then
        table.insert(blocks, block(lastBlock.x + 10, lastBlock.y))
      elseif lastBlock.direction == "up" then  
        table.insert(blocks, block(lastBlock.x, lastBlock.y + 10))
      elseif lastBlock.direction == "down" then
        table.insert(blocks, block(lastBlock.x, lastBlock.y - 10))
      end
    end,
    keypressed = function (key)
      blocks[1].direction = key
  end
  } 
end

function block(x, y)
  local width, height = 10, 10
  local screenWidth, screenHeight = love.graphics.getDimensions()

  return {
    direction = "right",
    x = x,
    y = y,
    update = function(self, nextBlock)     
      self.x = nextBlock.x
      self.y = nextBlock.y
      self.direction = nextBlock.direction
    end,
    draw = function (self)
      love.graphics.rectangle("line", self.x, self.y, width, height)
    end
  }
end

function testSnakeEatBlip()
  snakeX, snakeY = snake.getPosition()
  blsX, blsY = bls.getPosition()
  
  if snakeX >= blsX and snakeY >= blsY and snakeX < blsX + 10 and snakeY < blsY + 10  then
    snake.insertBlock()
    bls = newblip()
  end
  
end

function gameoverScreen( ... )
  love.graphics.printf("Game over!", 0, love.graphics.getHeight() / 2 , love.graphics.getWidth(), "center")
  love.graphics.printf("Score: " .. (snake.getScore() -2) * 10, 0, love.graphics.getHeight() / 2 + 30 , love.graphics.getWidth(), "center")
end

function drawPoints()
  local screenWidth, screenHeight = love.graphics.getDimensions()
  love.graphics.printf("Score: " .. (snake.getScore() -2) * 10, 0, 10 , love.graphics.getWidth(), "center")
end

function love.keypressed(key)
  if key == "down" or key == "up" then
    if lastKeyPressed == "down" or lastKeyPressed == "up" then
      lastKeyPressed = key
      return
    end
  elseif key == "right" or key == "left" then
    if lastKeyPressed == "right" or lastKeyPressed == "left" then
      lastKeyPressed = key
      return  
    end
  end
  lastKeyPressed = key
  if directions[key] then
    snake.keypressed(key)
  end
end

function love.load()

  bls = newblip()
  snake = snake(200, 200)
  snake.insertBlock()

end

function love.draw()
  if gameover == false then
    bls.draw()
    snake.draw()
    drawPoints()
  else
    gameoverScreen()
  end
end

function love.update(dt)
  
  if gameover == false then
    time = time + dt
    if snake:update(time) == false then
      gameover = true
    end
    testSnakeEatBlip(bls, snake)
  end  
end
