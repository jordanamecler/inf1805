local m = mqtt.Client("j-l", 120)

temp = tmr.create()
temp:register(10000, tmr.ALARM_AUTO,
			function (t)
			  publica(m, "timer")
			end)

gpio.mode(1, gpio.INT, gpio.PULLUP)
gpio.trig(1, "down", function(level)
			 publica(m, "botao")
			 end)

function readTemp()
  return adc.read(0)*(3.3/10.24)
end

function publica(c, origin)
  c:publish("temperatura", "jo e leo " .. origin .. string.format(" %f", readTemp()),0,0, 
            function(client) print("mandou!") end)
end

function novaInscricao (c)
  function novoIntervalo (c, t, interval)
    print ("intervalo: " .. interval)
    temp:interval(tonumber(interval)*1000)
  end
  c:on("message", novoIntervalo)
end

function conectado (client)
  temp:start()
  client:subscribe("controle", 0, novaInscricao)
end

m:connect("192.168.43.136", 1883, 0, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)
