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
tmr.alarm(0, 500, tmr.ALARM_AUTO, function()
    print("Button: at GPIO0  " .. gpio.read(3))
    print("Switch: at GPIO16 " .. gpio.read(0))
    print("Analog: at ADC    " .. adc.read(0) )
    -- Button to LED
    gpio.write(2, gpio.read(3))
    -- Switch to relais
    gpio.write(6, gpio.read(0))
    gpio.write(5, gpio.read(0))

    rgbTemp=0
    rgbHumi=0
    -- Read Temperature and Humidity
    status, temp, humi, temp_dec, humi_dec = dht.read(7) -- GPIO13
    if status == dht.OK then
        -- Integer firmware using this example
        print(string.format("DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
              math.floor(temp),
              temp_dec,
              math.floor(humi),
              humi_dec
        ))
    
        -- Float firmware using this example
        rgbTemp=math.floor((temp-25)*15) -- Start with 20 degree
        rgbTemp=math.min(255, math.max(rgbTemp, 0))
        rgbHumi=math.min(255, math.max(math.floor((humi)/5), 0))

        
        print("DHT Temperature:"..temp..";".."Humidity:"..humi .." RGB Temp value: " .. rgbTemp .. " RGB Hmidity: " .. rgbHumi)
        
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
    -- Set the color LEDs
    
    ws2812.write(string.char(adc.read(0)/10, 0, 0) .. string.char(0, rgbTemp, 0) .. string.char(0, 0, rgbHumi))
end)
ws2812.init()
ws2812.write(string.char(32, 0, 0) .. string.char(0, 32, 0) .. string.char(0, 0, 32))
