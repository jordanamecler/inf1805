function drawAbout(score)
  local screenWidth, screenHeight = love.graphics.getDimensions()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.printf("Jogo desenvolvido para aula de Sistemas Reativos", 0, love.graphics.getWidth() / 4, love.graphics.getWidth(), "center")
  love.graphics.printf("INF1805 - PUC-Rio", 0, love.graphics.getWidth() / 3.5, love.graphics.getWidth(), "center")
  love.graphics.printf("Desenvolvido por Leonardo Wajnsztok e Jordana Mecler", 0, love.graphics.getWidth() / 2, love.graphics.getWidth(), "center")
end

return {
	new = function ()
		local quit = false
		return {
			update = function (self, dt)
			  return quit
			end,
			draw = function (self)
				drawAbout()
			end,
			keypressed = function (self, key)
				quit = true
			end
		}
	end
}