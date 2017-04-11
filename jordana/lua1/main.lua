-- renomear para main.lua

function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
     draw =
	function ()
	   love.graphics.rectangle("line", rx, ry, rw, rh)
	end,
     keypressed =
	function (key)
	   local mx, my = love.mouse.getPosition()
	   if key == 'b' and naimagem (mx,my, x, y, rw, rh) then
     		ry = originalx
     		rx = originaly
  	   elseif key == "down" and naimagem(mx, my, x, y, rw, rh)  then
     		ry = ry + 10
  	   elseif key == "right" and naimagem(mx, my, x, y, rw, rh) then
     		rx = rx + 10
  	   end
	end,
     update =
	function ()
	   local mx, my = love.mouse.getPosition()
	end
  }
end
      
function love.load()
  ret1 = retangulo (50, 200, 200, 150)
  ret2 = retangulo (300, 200, 200, 150)
end

function naimagem (mx, my, x, y, rw, rh) 
  return (mx>x) and (mx<x+rw) and (my>y) and (my<y+rh)
end

function love.keypressed(key)
  ret1.keypressed(key)
  ret2.keypressed(key)
end

function love.update ()
  ret1.update()
  ret2.update()
end

function love.draw ()
  ret1.draw()
  ret2.draw()
end