function publica(c, origin)
  c:publish("temperatura", "jo e leo " .. origin .. string.format(" %f", readTemp()),0,0, 
            function(client) print("mandou!") end)
end

function printContent(c)
    print (c)
end

function conectado(client)
  client:subscribe("song/info", 0, printContent)
  -- client:subscribe("song/stream", 0, printContent)
  client:subscribe("node/neighbours", 0, printContent)
end

hostname = "192.168.20.11"
port = 1883

local m = mqtt.Client("no1", 120)

m:connect(hostname, port, 0, conectado, 
    function(client, reason) 
        print("failed reason: "..reason) 
    end
)

