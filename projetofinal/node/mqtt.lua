function connect_node(c)
  c:publish("node/connect", '{ "number": '..NODE_ID'..', "name": "" }',0,0, 
            function(client) 
                print("Connected node to server!") 
            end)
end

function publish_sensor_date(c, origin)
    -- TODO: publicar informacao do sensor PIR para o servidor determinar que vizinhos avisar
end

function printContent(c)
    print (c)
end

function conectado(client)
  connect_node(client)
  
  -- TODO: tratar cada um dos topicos recebidos do servidor
  
  -- client:subscribe("song/info", 0, printContent)
  -- client:subscribe("song/stream", 0, printContent)
  -- client:subscribe("node/neighbours", 0, printContent)
  
end

hostname = "192.168.20.11" -- ip local do computador
port = 1883
NODE_ID = 1 -- deve variar de node pra node

local m = mqtt.Client("no1", 120)

m:connect(hostname, port, 0, conectado, 
    function(client, reason) 
        print("failed reason: "..reason) 
    end
)

