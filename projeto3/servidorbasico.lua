stopLed = 3
startLed = 6

startButton = 1
stopButton = 2

gpio.mode(startLed, gpio.OUTPUT)
gpio.mode(stopLed, gpio.OUTPUT)
gpio.mode(startButton, gpio.INT, gpio.PULLUP)
gpio.mode(stopButton, gpio.INT, gpio.PULLUP)

gpio.write(startLed, gpio.LOW);
gpio.write(stopLed, gpio.LOW);


-- temp = tmr.create()
-- temp:register(speed, tmr.ALARM_AUTO,
-- 			function (t)
-- 			  
-- 			end)
-- temp:start()

gpio.trig(button1, "down", function(level)

end)
			 
gpio.trig(button2, "down", function(level)

end)
			 
local status={}
sw[1]="Comecou"
sw[0]="Terminou"

function home_view()

local urls = {
  home = nil,
  start = nil,
  finished = nil,
  stop = nil,
  score = nil,
}

srv = net.createServer(net.TCP)

function receiver(sck, request)

  -- analisa pedido para encontrar valores enviados
  local _, _, method, path, vars = string.find(request, "([A-Z]+) ([^?]+)%?([^ ]+) HTTP");
  -- se nÃ£o conseguiu casar, tenta sem variÃ¡veis
  if(method == nil)then
    _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
  end
  
  local _GET = {}
  
  if (vars ~= nil)then
    for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
      _GET[k] = v
    end
  end


  local action = urls[_GET.action]
  if action then action() end

  local vals = {
    CHV1 = gpio.LOW,
    CHV2 = gpio.LOW,
    LED1 = led[gpio.read(led1)],
    LED2 = led[gpio.read(led2)],
  }

  local buf = [[
<h1><u>Kahoot soh que melhor</u></h1>
<p><a href="?pin=LERTEMP"><button><b>REFRESH</b></button></a>
<p>
LED 1: $LED1  :  
	<a href="?pin=LIGA1"><button><b>ON</b></button></a>
	<a href="?pin=DESLIGA1"><button><b>OFF</b></button></a>
</p>
<p>LED 2: $LED2  :  
	<a href="?pin=LIGA2"><button><b>ON</b></button></a>
	<a href="?pin=DESLIGA2"><button><b>OFF</b></button></a>
</p>
]]

  buf = string.gsub(buf, "$(%w+)", vals)
  sck:send(buf, function() print("respondeu") sck:close() end)
end

if srv then
  srv:listen(80,"192.168.0.66", function(conn)
      print("estabeleceu conexao")
      conn:on("receive", receiver)
    end)
end

addr, port = srv:getaddr()
print(addr, port)
print("servidor inicializado.")
