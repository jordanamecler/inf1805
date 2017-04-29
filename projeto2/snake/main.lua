local Menu = require("menu")
local Game = require("game")
local MultiplayerGame = require("multiplayer_game")
local About = require("about")

gameState = "menu"
-- menu - singleplayer - multiplayer - about

local screenWidth, screenHeight = love.graphics.getDimensions()

function drawTitle( ... )
  love.graphics.printf("Snake Online\nThe game", 0, love.graphics.getHeight() / 4 , love.graphics.getWidth() , "center")
end

function love.keypressed(key)
  if gameState == "menu" then
    menu:keypressed(key)
  elseif gameState == "game" or gameState == "multiplayer" then
    if game then
      game:keypressed(key)
    end
  elseif gameState == "about" then
    if about then
      about:keypressed(key)
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
      game = MultiplayerGame.new()
      gameState = "multiplayer"
    end
  }
  menu:addItem{
    name = 'About',
    action = function()
      about = About.new()
      gameState = "about"
    end
  }

end

function love.draw()
  if gameState == "menu" then
    drawTitle()
    menu:draw(screenWidth / 2 - 150, screenHeight / 2 - 20)
  elseif gameState == "game" or gameState == "multiplayer" then
    if game then
        game:draw()
    end
  elseif gameState == "about" then
    if about then
      about:draw()
    end
  end
end

function love.update(dt)

  if gameState == "menu" then
    menu:update(dt)
  elseif gameState == "game" or gameState == "multiplayer" then
    if game then
      restart = game:update(dt)
      if restart then
        game = nil
        gameState = "menu"
      end
    end
  elseif gameState == "about" then
    if about then
      goback = about:update(dt)
      if goback then
        about = nil
        gameState = "menu"
      end
    end  
  end

end
