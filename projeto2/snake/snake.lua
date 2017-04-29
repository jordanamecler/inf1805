local snake = {}

function snake.snake(x, y)
  local blocks = { snake.block(x, y, love.math.random(255), love.math.random(255), love.math.random(255)) }
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
    insertBlock = function (bls)
      local lastBlock = blocks[#blocks]
      local r, g, b = bls.getRGB()

      if #blocks == 1 then
        r, g, b = love.math.random(255), love.math.random(255), love.math.random(255)
      end

      if lastBlock.direction == "right" then
        table.insert(blocks, snake.block(lastBlock.x - 10, lastBlock.y, r, g, b))
      elseif lastBlock.direction == "left" then
        table.insert(blocks, snake.block(lastBlock.x + 10, lastBlock.y, r, g, b))
      elseif lastBlock.direction == "up" then  
        table.insert(blocks, snake.block(lastBlock.x, lastBlock.y + 10, r, g, b))
      elseif lastBlock.direction == "down" then
        table.insert(blocks, snake.block(lastBlock.x, lastBlock.y - 10, r, g, b))
      end
    end,
    keypressed = function (key)
      blocks[1].direction = key
  end
  } 
end

function snake.block(x, y, r, g, b)
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

function snake.newblip ()
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
    while true  do
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


return snake
