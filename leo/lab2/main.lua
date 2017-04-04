-- renomear para main.lua

function love.load()
  x = 50 y = 200
  w = 200 h = 150

  ret1 = retangulo(50, 100, 200, 150);
  ret2 = retangulo(50, 300, 200, 150);
end

function naimagem (mx, my, x, y)
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function love.keypressed(key)
  local mx, my = love.mouse.getPosition()
  ret1.keypressed(key)
  ret2.keypressed(key)

end

function love.update (dt)
	ret1.update()
	ret2.update()
end

function love.draw ()
  ret1.draw()
  ret2.draw()
end

function retangulo (x, y, w, h)
	local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h

	return {
		draw =
		function()
			love.graphics.rectangle("line", rx, ry, rw, rh)
		end,

		keypressed =
		function(key)
			if key == 'b' and naimagem (mx,my, x, y) then
				ry = 200
			elseif key == "down" and naimagem(mx, my, rx, ry)  then
				ry = ry + 10
			elseif key == "right" and naimagem(mx,my,rx,ry) then
				rx = rx + 10
			end
		end,

		update =
		function()
			local mx, my = love.mouse.getPosition()
		end
	}
end

