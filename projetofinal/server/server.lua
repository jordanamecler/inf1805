main_topic = "audio"
broker = "test.mosquitto.org"
port = 1883

function connectedToWifi()
  print('Connected to wifi. IP: '..wifi.sta.getip())
  m:connect(MQTT_SERVER, 1883, 0, 
            connectedToMqtt,
            function(c, reason) print('failed reason: '..reason) end)
end

function connected_callback(c)
  -- subscribes to topics
  print('Connected to MQTT server\n broker: '..broker)
  c:subscribe(main_topic..'/someone_is_around', 0)

  c:on('message', messageHandler)
  publish('requestRegistration', '{"id":"'..id..'"}')

  local timer = tmr.create()
  timer:register(1000, tmr.ALARM_AUTO, publishTemperature)
  timer:start()

  newButton(1, DEBOUNCE_TIME, changePosition(1))
  newButton(2, DEBOUNCE_TIME, changePosition(-1))
end 



-- connects to mqqt server
m:connect(broker, port, 0, 
             connected_callback,
             function(client, reason) print("failed reason: "..reason) end)
