wificonf = {
  -- verificar ssid e senha
  ssid = "terra_iot",
  pwd = "projeto_iot",
  save = false
}


wifi.sta.config(wificonf)
print("modo: ".. wifi.setmode(wifi.STATION))
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function (T) print(wifi.sta.getip()) end)