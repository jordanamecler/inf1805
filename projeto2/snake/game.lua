local Snake = require("snake")

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

return {
	new = function ()

		local directions = Set{"up", "down", "right", "left"}
		
		local drawScore = function (score)
		  local screenWidth, screenHeight = love.graphics.getDimensions()
		  love.graphics.setColor(255, 255, 255, 255)
		  love.graphics.printf("Score: " .. (score -2) * 10, 0, 10 , love.graphics.getWidth(), "center")
		end

		local gameoverScreen = function (score)
		  love.graphics.printf("Game over!", 0, love.graphics.getHeight() / 2 , love.graphics.getWidth(), "center")
		  love.graphics.printf("Score: " .. (score -2) * 10, 0, love.graphics.getHeight() / 2 + 30 , love.graphics.getWidth(), "center")
		  love.graphics.printf("Press any key to restart...", 0, love.graphics.getHeight() / 1.3 + 30 , love.graphics.getWidth(), "center")
		end

		local testSnakeEatBlip = function (bls, snake)
		  snakeX, snakeY = snake.getPosition()
		  blsX, blsY = bls.getPosition()
		  
		  if snakeX >= blsX and snakeY >= blsY and snakeX < blsX + 10 and snakeY < blsY + 10  then
		    snake.insertBlock(bls)
		    bls.changeBlip()
			return true
		  end
		  return false
		end

		local time = 0
		local gameover = false
		local lastKeyPressed = "right"
		local blipUpdate = 0
		local bls = Snake.newblip()
		local snake = Snake.snake(200, 200)

		snake.insertBlock(bls)

		return {

			update = function (self, dt)
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
			  else
			  	return restart
			  end  
			  return false
			end,
			draw = function (self)
				if gameover == false then
				  bls.draw()
				  snake.draw()
				  drawScore(snake.getScore())
				else
				  gameoverScreen(snake.getScore())
				end
			end,
			keypressed = function (self, key)
				if gameover == false then
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
				else
					restart = true
				end
			end
		}
	end
}