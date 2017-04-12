-- renomear para main.lua

function love.load()

  vect = {retangulo(50, 100, 200, 150), retangulo(50, 300, 200, 150), retangulo(10, 10, 300, 300)};

end

function naimagem (mx, my, x, y, rw, rh)
	print(mx, my, x, y, rw, rh)
  return (mx>x) and (mx<x+rw) and (my>y) and (my<y+rh)
end

function love.keypressed(key)
  for i = 1, #vect do
	vect[i].keypressed(key)
  end

end

function love.update (dt)
	for i = 1, #vect do
		vect[i].update()
	end
end

function love.draw ()
  for i = 1, #vect do
	vect[i].draw()
  end
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
			mx, my = love.mouse.getPosition()
			if key == 'b' and naimagem (mx,my, x, y, rw, rh) then
				ry = originaly
				rx = originalx
			elseif key == "down" and naimagem(mx, my, rx, ry, rw, rh)  then
				ry = ry + 10
			elseif key == "right" and naimagem(mx,my,rx,ry, rw, rh) then
				rx = rx + 10
			end
		end,

		update =
		function()
			mx, my = love.mouse.getPosition()
		end
	}
end

