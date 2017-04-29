local Menu = require("menu")
local Game = require("game")

gameState = "menu"
-- menu - singleplayer - multiplayer - gameover

local screenWidth, screenHeight = love.graphics.getDimensions()

function drawTitle( ... )
  love.graphics.printf("Snake Online\nThe game", 0, love.graphics.getHeight() / 4 , love.graphics.getWidth() , "center")
end

function love.keypressed(key)
  if gameState == "menu" then
    menu:keypressed(key)
  elseif gameState == "game" then
    if game then
      game:keypressed(key)
    end
  end
end

function love.load()
  
  menu = Menu.new()
  menu:addItem{
    name = 'Single player',
    action = function()
      game = Game.new()
      gameState = "game"
    end
  }
  menu:addItem{
    name = 'Multiplayer',
    action = function()
      -- do something
    end
  }
  menu:addItem{
    name = 'Quit',
    action = function()
      -- love.event.push('q')
    end
  }

end

function love.draw()
  if gameState == "menu" then
    drawTitle()
    menu:draw(screenWidth / 2 - 150, screenHeight / 2 - 20)
  elseif gameState == "game" then
    if game then
        game:draw()
    end
  end
end

function love.update(dt)

  if gameState == "menu" then
    menu:update(dt)
  elseif gameState == "game" then
    if game then
      restart = game:update(dt)
      if restart == true then
        game = Game.new()
      end
    end
  end

end
