local Snake = require("snake")

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

directions1 = Set{"up", "down", "right", "left"}
directions2 = Set{"a", "w", "s", "d"}
directionsMap = {
	a = "left",
	s = "down",
	w = "up",
	d = "right"
}

function drawScore(score)
  local screenWidth, screenHeight = love.graphics.getDimensions()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Score: " .. (score -2) * 10, 0, 10 , love.graphics.getWidth(), "center")
end

function gameoverScreen(score)
  love.graphics.printf("Game over!", 0, love.graphics.getHeight() / 2 , love.graphics.getWidth(), "center")
  love.graphics.printf("Score: " .. (score -2) * 10, 0, love.graphics.getHeight() / 2 + 30 , love.graphics.getWidth(), "center")
  love.graphics.printf("Press any key to restart...", 0, love.graphics.getHeight() / 1.3 + 30 , love.graphics.getWidth(), "center")
end

function testSnakeEatBlip(bls, snake)
  snakeX, snakeY = snake.getPosition()
  blsX, blsY = bls.getPosition()
  
  if snakeX >= blsX and snakeY >= blsY and snakeX < blsX + 10 and snakeY < blsY + 10  then
    snake.insertBlock(bls)
    bls.changeBlip()
	return true
  end
  return false
end

return {
	new = function ()

		local time = 0
		local gameover = false
		local lastKeyPressed1 = "right"
		local lastKeyPressed2 = "right"
		local blipUpdate = 0
		local bls = Snake.newblip()
		local snake1 = Snake.snake(200, 200)
		local snake2 = Snake.snake(200, 300)

		snake1.insertBlock(bls)
		snake2.insertBlock(bls)

		return {

			update = function (self, dt)
			  if gameover == false then
			    time = time + dt
				if time > blipUpdate + 10 then
				  bls:update()
				  blipUpdate = time
				end	
			    if snake1:update(time) == false then
			      gameover = true
			    end
			    if testSnakeEatBlip(bls, snake1) then
					blipUpdate = time
				end
				if snake2:update(time) == false then
			      gameover = true
			    end
			    if testSnakeEatBlip(bls, snake2) then
					blipUpdate = time
				end
			  else
			  	return restart
			  end  
			  return false
			end,
			draw = function (self)
				if gameover == false then
				  bls.draw()
				  snake1.draw()
				  snake2.draw()
				  drawScore(snake1.getScore() + snake2.getScore())
				else
				  gameoverScreen(snake1.getScore() + snake2.getScore())
				end
			end,
			keypressed = function (self, key)
				if gameover == false then
					if directions1[key] then
						if key == "down" or key == "up" then
						  if lastKeyPressed1 == "down" or lastKeyPressed1 == "up" then
						    lastKeyPressed1 = key
						    return
						  end
						elseif key == "right" or key == "left" then
						  if lastKeyPressed1 == "right" or lastKeyPressed1 == "left" then
						    lastKeyPressed1 = key
						    return  
						  end
						end
						lastKeyPressed1 = key
						if directions1[key] then
						  snake1.keypressed(key)
						end
					elseif directions2[key] then
						if key == "s" or key == "w" then
						  if lastKeyPressed2 == "s" or lastKeyPressed2 == "w" then
						    lastKeyPressed2 = key
						    return
						  end
						elseif key == "d" or key == "a" then
						  if lastKeyPressed2 == "d" or lastKeyPressed2 == "a" then
						    lastKeyPressed2 = key
						    return  
						  end
						end
						lastKeyPressed2 = key
						if directions2[key] then
						  snake2.keypressed(directionsMap[key])
						end
					end
				else
					restart = true
				end
			end
		}
	end
}