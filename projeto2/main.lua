function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

directions = Set{"up", "down", "right", "left"}
time = 0

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
    getPosition = function()
      return blocks[1].x, blocks[1].y
    end,
    update = function(time)
      if time < lastUpdate + 0.05 then
        return
      end
      lastUpdate = time
      for i in ipairs(blocks) do
        i = #blocks - i + 1
        if i ~= 1 then
          local b = blocks[i]
          b:update(blocks[i - 1])
        end
      end

      local b = blocks[1]
      if b.direction == "right" then
        b.x = b.x + 10
      elseif b.direction == "left" then
        b.x = b.x - 10
      elseif b.direction == "up" then  
        b.y = b.y - 10
      elseif b.direction == "down" then
        b.y = b.y + 10
      end

    end,
    draw = function ()
      for i in ipairs(blocks) do
        local b = blocks[i]
        b:draw()
      end
    end,
    insertBlock = function ()
      print(#blocks)
      local lastBlock = blocks[#blocks]
      print(lastBlock.direction)
      
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

function testCollision()
  snakeX, snakeY = snake.getPosition()
  blsX, blsY = bls.getPosition()
  
  if snakeX >= blsX and snakeY >= blsY and snakeX < blsX + 10 and snakeY < blsY + 10  then
    snake.insertBlock()
    return true
  end
  return false
end

function love.keypressed(key)
  
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
  bls.draw()
  snake.draw()
end

function love.update(dt)
  
  time = time + dt
  snake.update(time)  
  if testCollision(bls, snake) then
    bls = newblip()
  end
end
