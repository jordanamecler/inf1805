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
  player.keypressed (key)
end

function love.load()
  player =  newplayer()
  bls = newblip()
end

function love.draw()
  player.draw()
  bls.draw()
end

function love.update(dt)
  player.update(dt)
  bls.update(dt)
end
