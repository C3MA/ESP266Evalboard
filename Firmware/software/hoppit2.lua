-- Konfiguration
WLAN_SSID="WLAN1"
WLAN_PASSWORT="c3ma_123"

wifi.setmode(wifi.STATION)
wifi.sta.config(WLAN_SSID, WLAN_PASSWORT)

-- HoppIT Test
gpio.mode(2, gpio.OUTPUT,gpio.PULLUP) -- GPIO4
gpio.mode(6, gpio.OUTPUT, gpio.PULLUP) -- GPIO12
gpio.mode(5, gpio.OUTPUT, gpio.PULLUP) -- GPIO14
gpio.write(2, gpio.LOW)
gpio.write(6, gpio.LOW)
gpio.write(5, gpio.LOW)

gpio.write(2, gpio.HIGH)
gpio.write(6, gpio.HIGH)
gpio.write(5, gpio.HIGH)
print("LED test done")
gpio.write(5, gpio.LOW)

gpio.mode(0, gpio.INPUT)
gpio.mode(3, gpio.INPUT)

-- Mqtt
m = mqtt.Client("Client" .. node.chipid(), 120, "user", "pass")

m:on("connect", function()
    m:publish("/test/" .. node.chipid() .. "/ip",wifi.sta.getip(),0,0)
    print("Connected to Wifi")
    m:subscribe("/test/all/led1",0)
    ws2812.write(string.char(32, 0, 0) .. string.char(0, 0, 32) .. string.char(0, 0, 0))
end)

m:on("message", function(conn, topic, data)
   -- skip emtpy messages
   if (data == nil) then
    return
   end
   if (data == "ON") then
      gpio.write(2, gpio.HIGH)
   elseif (data == "OFF") then
      gpio.write(2, gpio.LOW)
   end
end)

local mytimer1 = tmr.create()

tmr.alarm(0, 500, tmr.ALARM_AUTO, function()
    if wifi.sta.status() ~= 5 then
         print("Connecting to AP...")
         gpio.write(2, (gpio.read(2) + 1) % 2)
      else
        ws2812.write(string.char(32, 0, 0) .. string.char(0, 32, 0) .. string.char(0, 0, 32))
        m:connect("192.168.1.1",1883,0)
        tmr.stop(0)
        gpio.write(2, gpio.LOW)
        mytimer1:start()
        ws2812.write(string.char(32, 0, 0) .. string.char(0, 0, 0) .. string.char(0, 0, 0))
    end
end)

mytimer1:register( 500, tmr.ALARM_AUTO, function()
    
    rgbTemp=0
    rgbHumi=0
    -- Read Temperature and Humidity
    status, temp, humi, temp_dec, humi_dec = dht.read(7) -- GPIO13
    if status == dht.OK then
        -- Float firmware using this example
        rgbTemp=math.floor((temp-25)*15) -- Start with 20 degree
        rgbTemp=math.min(255, math.max(rgbTemp, 0))
        rgbHumi=math.min(255, math.max(math.floor((humi)/5), 0))
        
        m:publish("/test/" .. node.chipid() .. "/hmi",humi,0,0)
        m:publish("/test/" .. node.chipid() .. "/temp",temp,0,0)
        
    elseif status == dht.ERROR_CHECKSUM then
        m:publish("/test/" .. node.chipid() .. "/debug","DHT Checksum error.",0,0)
    elseif status == dht.ERROR_TIMEOUT then
        m:publish("/test/" .. node.chipid() .. "/debug","DHT timed out.",0,0)
    end
end)
ws2812.init()
ws2812.write(string.char(0, 0, 0):rep(3))