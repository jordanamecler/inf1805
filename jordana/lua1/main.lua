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
     		rx = originalx
     		ry = originaly
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
  retangulos = {}
  local x = 50
  for i = 1, 2 do
     retangulos[i] = retangulo (x, 200, 200, 150)
     x = x + 300
  end
end

function naimagem (mx, my, x, y, rw, rh) 
  return (mx>x) and (mx<x+rw) and (my>y) and (my<y+rh)
end

function love.keypressed(key)
  for i = 1, #retangulos do
     retangulos[i].keypressed(key)
  end
end

function love.update ()
  for i = 1, #retangulos do
     retangulos[i].update()
  end
end

function love.draw ()
  for i = 1, #retangulos do
     retangulos[i].draw()
  end
end