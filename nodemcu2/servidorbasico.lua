led1 = 3
led2 = 6
sw1 = 1
sw2 = 2
button1 = 1
button2 = 2

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.mode(sw1, gpio.INPUT)
gpio.mode(sw2, gpio.INPUT)
gpio.mode(button1, gpio.INT, gpio.PULLUP)
gpio.mode(button2, gpio.INT, gpio.PULLUP)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

speed = 1000
tempo1 = -1
tempo2 = -1
parou = false

temp = tmr.create()
temp:register(speed, tmr.ALARM_AUTO,
			function (t)
			  if (gpio.read(led1) == gpio.HIGH) then gpio.write(led1, gpio.LOW)
			  else gpio.write(led1, gpio.HIGH)
			  end
			end)
temp:start()

gpio.trig(button1, "down", function(level)
			 if (parou == false) then
				 if (tempo1 ~= -1 and tmr.now() - tempo2 < 1000) then
				    temp:stop()
				    print("dois botoes ao mesmo tempo")
				    parou = true
				 else
				    tempo1 = tmr.now()
				    speed = speed*1.1
				    temp:interval(speed)
				 end
			 end
			end)
			 
gpio.trig(button2, "down", function(level)
			 if (parou == false) then
				 if (tempo2 ~= -1 and tmr.now() - tempo1 < 1000) then
				    temp:stop()
				    print("dois botoes ao mesmo tempo")
				    parou = true
				 else
				    tempo2 = tmr.now()
				    speed = speed/1.1
				    temp:interval(speed)
				 end
			 end
			end)
			 

local led={}
led[0]="OFF"
led[1]="ON_"

local sw={}
sw[1]="OFF"
sw[0]="ON_"

local lasttemp = 0

function LedObj (num)
  local num = num
  local function turnOn ()
    gpio.write(num, gpio.HIGH)
    print("on")
        end
  local function turnOff ()
    gpio.write(num, gpio.LOW)
    print("off")
        end
  local temp = tmr.create()
  temp:register(1000, tmr.ALARM_AUTO,
			function (t)
			  if (gpio.read(num) == gpio.HIGH) then turnOff()
			  else turnOn()
			  end
			end)

  return {
    blink =
      function ()
	temp:start()
      end,
    stop =
      function ()
	temp:stop()
      end
  }
end

local ledsArray = {LedObj(led1), LedObj(led2)}

local function readtemp()
  lasttemp = adc.read(0)*(3.3/10.24)
end

local actions = {
  --LERTEMP = readtemp,
  --LIGA1 = ledsArray[1].blink,
  --DESLIGA1 = ledsArray[1].stop,
  --LIGA2 = ledsArray[2].blink,
  --DESLIGA2 = ledsArray[2].stop,
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


  local action = actions[_GET.pin]
  if action then action() end

  local vals = {
    --TEMP = string.format("%2.1f",adc.read(0)*(3.3/10.24)),
    TEMP =  string.format("%2.1f", lasttemp),
    CHV1 = gpio.LOW,
    CHV2 = gpio.LOW,
    LED1 = led[gpio.read(led1)],
    LED2 = led[gpio.read(led2)],
  }

  local buf = [[
<h1><u>PUC Rio - Sistemas Reativos</u></h1>
<h2><i>ESP8266 Web Server</i></h2>
        <p>Temperatura: $TEMP oC <a href="?pin=LERTEMP"><button><b>REFRESH</b></button></a>
        <p>LED 1: $LED1  :  <a href="?pin=LIGA1"><button><b>ON</b></button></a>
                            <a href="?pin=DESLIGA1"><button><b>OFF</b></button></a></p>
        <p>LED 2: $LED2  :  <a href="?pin=LIGA2"><button><b>ON</b></button></a>
                            <a href="?pin=DESLIGA2"><button><b>OFF</b></button></a></p>
]]

  buf = string.gsub(buf, "$(%w+)", vals)
  sck:send(buf, function() print("respondeu") sck:close() end)
end

if srv then
  srv:listen(80,"192.168.0.66", function(conn)
      print("estabeleceu conexÃ£o")
      conn:on("receive", receiver)
    end)
end

addr, port = srv:getaddr()
print(addr, port)
print("servidor inicializado.")
