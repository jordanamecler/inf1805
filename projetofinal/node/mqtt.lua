gpio.trig(1, "both", function(level) print(level) end)

function connect_node(c)
  c:publish("node/connect", '{ "number": '..NODE_ID..', "name": "" }',0,0, 
            function(client) 
                print("Connected node to server!") 
            end)
end

function publish_sensor_date(c, origin)
    -- TODO: publicar informacao do sensor PIR para o servidor determinar que vizinhos avisar
end

function conectado(client)
  print("conectado")
  connect_node(client)
  
  -- TODO: tratar cada um dos topicos recebidos do servidor
  
  client:subscribe({["song/stream"]=0,["song/info"]=1}, function(conn) print("subscribe ok") end)
  
  -- client:subscribe("node/neighbours", 0, printContent)
  
end

hostname = "192.168.43.125" -- ip local do computador
port = 1883
NODE_ID = 1 -- deve variar de node pra node

local m = mqtt.Client("no1", 120)

m:connect(hostname, port, 0, conectado, 
    function(client, reason) 
        print("failed reason: "..reason) 
    end
)

function handlePIR(presence)
  if sensedPresence == false and presence == 1 then
    volume = 1
    sensedPresence = true
    m:publish("node/sensor", 
      "{ 'node': "..NODE_ID..", 'sensedPresence': 'YES' }")
  elseif sensedPresence == true and presence == 0 then
    volume = 0
    sensedPresence = false
    m:publish("node/sensor", 
      "{ 'node': "..NODE_ID..", 'sensedPresence': 'NO' }")
  end
end

chunkList = {}
volume = 0
sensedPresence = false

m:on("message", function(client, topic, data)
  if topic == "song/stream" then
    print("tocando musica")
    -- print(data)
    table.insert(chunkList, data)
  elseif topic == "song/info" then
    print(data)
  elseif topic == "node/neighbours"

  end
end)

-- ****************************************************************************
-- Play file with pcm module.
--
-- Upload jump_8k.u8 to spiffs before running this script.
--
-- ****************************************************************************


function cb_drained(d)
  print("drained "..node.heap())

  file.seek("set", 0)
  -- uncomment the following line for continuous playback
  --d:play(pcm.RATE_8K)
end

function cb_stopped(d)
  print("playback stopped")
  file.seek("set", 0)
end

function cb_paused(d)
  print("playback paused")
end

file.open("jump_1.u8", "r")

drv = pcm.new(pcm.SD, 1)

-- fetch data in chunks of FILE_READ_CHUNK (1024) from file
drv:on("data", function(drv) return file.read() end)

-- get called back when all samples were read from the file
drv:on("drained", cb_drained)

drv:on("stopped", cb_stopped)
drv:on("paused", cb_paused)

-- start playback
drv:play(pcm.RATE_8K)
