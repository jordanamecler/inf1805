wificonf = {
  -- verificar ssid e senha
  ssid = "Nem Tenta 2",
  pwd = "ns0tcqdn!@#",
  save = false
}


wifi.sta.config(wificonf)
print("modo: ".. wifi.setmode(wifi.STATION))
print(wifi.sta.getip())

