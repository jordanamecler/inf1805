function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

directions = Set{"up", "down", "right", "left"}
time = 0
blipUpdate = 0
gameover = false
lastKeyPressed = "right"

function newblip ()
  local width, height = love.graphics.getDimensions( )
  local x, y = love.math.random(width /10 - 1) * 10, love.math.random(height/10 - 1) * 10
  local r, g, b = love.math.random(255), love.math.random(255), love.math.random(255)
  
  return {
    getPosition = function ()
      return x, y
    end,
    getRGB = function ()
      return r, g, b
    end,
	changeBlip = function ()
		x, y = love.math.random(width /10 - 1) * 10, love.math.random(height/10 - 1) * 10
		r, g, b = love.math.random(255), love.math.random(255), love.math.random(255)
	end,
	update = coroutine.wrap ( function (self)
		while true 	do
		  self.changeBlip()
		  coroutine.yield()
		end
	end),
    draw = function ()
      love.graphics.setColor(r, g, b, 255)
      love.graphics.rectangle("fill", x, y, 10, 10)
    end
  }
end

function snake(x, y)
  local blocks = { block(x, y, love.math.random(255), love.math.random(255), love.math.random(255)) }
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local lastUpdate = 0
  return {
    getScore = function ()
      return #blocks
    end,
    getPosition = function()
      return blocks[1].x, blocks[1].y
    end,
    validatePosition = function (x, y, i)
      if x >= blocks[i].x and y >= blocks[i].y and x < blocks[i].x + 10 and y < blocks[i].y + 10  then
		return false
      end
      return true
    end,
    update = function(self, time)
      local b = blocks[1]
	  local x, y = blocks[1].x, blocks[1].y
      if time < lastUpdate + 0.05 then
        return true
      elseif b.x + 10 > screenWidth or b.x < 0 or b.y + 10 > screenHeight or b.y < 0 then
        return false
      end

      lastUpdate = time
	  
	  if b.direction == "right" then
        x = x + 10
      elseif b.direction == "left" then
		x = x - 10
      elseif b.direction == "up" then  
        y = y - 10
      elseif b.direction == "down" then
        y = y + 10
      end
	  
      for i in ipairs(blocks) do
        i = #blocks - i + 1
        if i ~= 1 then
          local b = blocks[i]
          b:update(blocks[i - 1])
		  if self.validatePosition(x, y, i) == false then
			return false
		  end
        end
      end
	  
	  b.x = x
	  b.y = y
	  
	  return true
    end,
    draw = function ()
      for i in ipairs(blocks) do
        local b = blocks[i]
        b:draw()
      end
    end,
    insertBlock = function ()
      local lastBlock = blocks[#blocks]
      local r, g, b = bls.getRGB()

      if #blocks == 1 then
        r, g, b = love.math.random(255), love.math.random(255), love.math.random(255)
      end

      if lastBlock.direction == "right" then
        table.insert(blocks, block(lastBlock.x - 10, lastBlock.y, r, g, b))
      elseif lastBlock.direction == "left" then
        table.insert(blocks, block(lastBlock.x + 10, lastBlock.y, r, g, b))
      elseif lastBlock.direction == "up" then  
        table.insert(blocks, block(lastBlock.x, lastBlock.y + 10, r, g, b))
      elseif lastBlock.direction == "down" then
        table.insert(blocks, block(lastBlock.x, lastBlock.y - 10, r, g, b))
      end
    end,
    keypressed = function (key)
      blocks[1].direction = key
  end
  } 
end

function block(x, y, r, g, b)
  local width, height = 10, 10
  local screenWidth, screenHeight = love.graphics.getDimensions()
  local r, g, b = r, g, b
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
      love.graphics.setColor(r, g, b, 255)
      love.graphics.rectangle("fill", self.x, self.y, width, height)
    end
  }
end

function testSnakeEatBlip()
  snakeX, snakeY = snake.getPosition()
  blsX, blsY = bls.getPosition()
  
  if snakeX >= blsX and snakeY >= blsY and snakeX < blsX + 10 and snakeY < blsY + 10  then
    snake.insertBlock()
    bls.changeBlip()
	return true
  end
  return false
end

function gameoverScreen( ... )
  love.graphics.printf("Game over!", 0, love.graphics.getHeight() / 2 , love.graphics.getWidth(), "center")
  love.graphics.printf("Score: " .. (snake.getScore() -2) * 10, 0, love.graphics.getHeight() / 2 + 30 , love.graphics.getWidth(), "center")
end

function drawPoints()
  local screenWidth, screenHeight = love.graphics.getDimensions()
  love.graphics.setColor(255, 255, 255, 255)
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
	if time > blipUpdate + 10 then
	  bls:update()
	  blipUpdate = time
	end	
    if snake:update(time) == false then
      gameover = true
    end
    if testSnakeEatBlip(bls, snake) then
		blipUpdate = time
	end
  end  
end
