function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

directions = Set{"up", "down", "right", "left"}

function newblip ()
  local width, height = love.graphics.getDimensions( )
  local x, y = love.math.random(width - 10), love.math.random(height - 10)
  return {
    update = function (dt)
		end,
    affected = function (playerWidth, playerHeight)
      if playerWidth>x and playerWidth<x+10 and playerHeight>y and playerHeight<y+10 then
        return true
      else
        return false
      end
    end,
    draw = function ()
      love.graphics.rectangle("line", x, y, 10, 10)
    end
  }
end

function snake(x, y)
  local blocks = { block(x, y) }
  local screenWidth, screenHeight = love.graphics.getDimensions()
  return {
    update = function()
      for i in ipairs(blocks) do
        i = #blocks - i + 1
        if i ~= 1 then
          print (i)
          local b = blocks[i]
          print (b.x)
          print (blocks[i - 1].x)
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
      print("tcay")
     
      self.x = nextBlock.x
      self.y = nextBlock.y
      self.direction = nextBlock.direction
    end,
    draw = function (self)
      love.graphics.rectangle("line", self.x, self.y, width, height)
    end
  }
end

function newplayer ()
  local lastPos = "right"
  local x, y = 0, 200
  local tail = 0
  local playerWidth = x + 30
  local playerHeight = y
  local width, height = love.graphics.getDimensions( )
  return {
  update = function (dt)
    local hit = bls.affected(playerWidth, playerHeight)
    if hit then
      tail = tail + 10
      bls = newblip()
    elseif lastPos == "right" then
      x = x + 0.5
      playerWidth = x + 30 + tail
      playerHeight = y
      if playerWidth > width then
        lastPos = "lost"
      end
    elseif lastPos == "left" then
      x = x - 0.5
      playerWidth = x - 30 - tail
      playerHeight = y
      if playerWidth < 0 then
        lastPos = "lost"
      end
    elseif lastPos == "up" then
      y = y - 0.5
      playerWidth = x
      playerHeight = y - 30 - tail
      if playerHeight < 0 then
        lastPos = "lost"
      end
    elseif lastPos == "down" then
      y = y + 0.5
      playerWidth = x
      playerHeight = y + 30 + tail
      if playerHeight > height then
        lastPos = "lost"
      end
    end
  end,
  draw = function ()
    love.graphics.line(x, y, playerWidth, playerHeight)
  end,
  keypressed = function (key)
    if key == "down" then
      if lastPos == "down" or lastPos == "up" then
        return
      elseif lastPos == "right" or lastPos == "left" then
        lastPos = "down"
      end
    elseif key == "up" then
      if lastPos == "down" or lastPos == "up" then
        return
      elseif lastPos == "right" or lastPos == "left" then
        lastPos = "up"
      end
    elseif key == "right" then
      if lastPos == "right" or lastPos == "left" then
        return
      elseif lastPos == "down" or lastPos == "up" then
        lastPos = "right"
      end
    elseif key == "left" then
      if lastPos == "right" or lastPos == "left" then
        return
      elseif lastPos == "down" or lastPos == "up" then
        lastPos = "left"
      end
    end
  end
  }
end

function love.keypressed(key)
  -- player.keypressed (key)
  if directions[key] then
    snake.keypressed(key)
  end
end

function love.load()
  -- player =  newplayer()
  -- bls = newblip()
  snake = snake(200, 200)
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()
  snake.insertBlock()

end

function love.draw()
  -- player.draw()
  -- bls.draw()
  snake.draw()
end
time = 0
function love.update(dt)
  -- player.update(dt)
  -- bls.update(dt)
  time = time + dt
  if time > 0.1 then
    snake.update()  
    time = 0
  end
  
end
