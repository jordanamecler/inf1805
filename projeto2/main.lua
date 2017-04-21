function newblip (vel)
  local width, height = love.graphics.getDimensions( )
  local x, y = love.math.random(width), love.math.random(height)
  return {
    timeInactive = 0,
    update = function (self)
		end,
    affected = function (pos)
      if pos>x and pos<x+10 then
      -- "pegou" o blip
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
  local playerWidth = x + 30
  local playerHeight = y
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
    return x
  end,
  update = function (dt)
    if lastPos == "right" then
      x = x + 0.5
      if x > width then
        x = 0
      end
      playerWidth = x + 30
      playerHeight = y
    elseif lastPos == "left" then
      x = x - 0.5
      if x < 0 then
        x = width
      end
      playerWidth = x + 30
      playerHeight = y
    elseif lastPos == "up" then
      y = y - 0.5
      if y > height then
        y = 0
      end
      playerWidth = x
      playerHeight = y + 30
    elseif lastPos == "down" then
      y = y + 0.5
      if y < 0 then
        y = height
      end
      playerWidth = x
      playerHeight = y + 30
    end
  end,
  draw = function ()
    love.graphics.line(x, y, playerWidth, playerHeight)
  end,
  keypressed = function (key)
    if key == "down" then
      if lastPos == "down" or lastPos == "up" then
        return
      else
        lastPos = "down"
      end
    elseif key == "up" then
      if lastPos == "down" or lastPos == "up" then
        return
      else
        lastPos = "up"
      end
    elseif key == "right" then
      if lastPos == "right" or lastPos == "left" then
        return
      else
        lastPos = "right"
      end
    elseif key == "left" then
      if lastPos == "right" or lastPos == "left" then
        return
      else
        lastPos = "left"
      end
    end
  end
  }
end

function love.keypressed(key)
  player.keypressed (key)
  if key == 'a' then
    pos = player.try()
    for i in ipairs(listabls) do
      local hit = listabls[i].affected(pos)
      if hit then
        table.remove(listabls, i) -- esse blip "morre"
        listabls[1] = newblip(1)
        return -- assumo que só vai pegar um blip
      end
    end
  end
end

function love.load()
  tempo = 0
  player =  newplayer()
  listabls = {}
  listabls[1] = newblip(1)
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
end

function love.update(dt)
  tempo = tempo + dt
  player.update(dt)
  for i = 1,#listabls do
    if listabls[i].timeInactive == 0 then
       listabls[i]:update()
    elseif tempo > listabls[i].timeInactive then
       listabls[i].timeInactive = 0
    end
  end
end
