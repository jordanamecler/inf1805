wificonf = {
  -- verificar ssid e senha
  ssid = "terra_iot",
  pwd = "projeto_iot",
  save = false
}


wifi.sta.config(wificonf)
print("modo: ".. wifi.setmode(wifi.STATION))
print(wifi.sta.getip())

