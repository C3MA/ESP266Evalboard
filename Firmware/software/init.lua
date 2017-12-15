-- Init file
print("Autostart in 5 Seconds")
ws2812.init() --bunten LED Modul
-- Neuen Puffer fuer die LEDs erzeugen:
buffer = ws2812.newBuffer(3, 3) -- drei LEDs, GRB .. nicht rgb
-- alles aus
buffer:fill(0, 0, 0)
ws2812.write(buffer)
i=0
-- alle 200ms wird die funktion neu aufgerufen.
-- (Wir nehmen Nr. 6, ist der letzte (0...6))
tmr.alarm(6, 200, tmr.ALARM_AUTO, function()
    -- 
    i = i + 1
    -- schiebt die LED nach rechts
    buffer:set(i % buffer:size() + 1, 25, 0, 0)
    -- Loescht die letzte LED
    buffer:set((i - 1) % buffer:size() + 1, 0, 0, 0)

    ws2812.write(buffer)
    -- nach 5s ist der zauber vorbei
    if( (tmr.now() / 1000) > 5000) then
        tmr.stop(6)
        if (file.open("hoppit1.lua")) then
            print("Start Hardware Test...")
            dofile("hoppit1.lua")
        elseif (file.open("hoppit2.lua")) then
            print("Start Communication test...")
            dofile("hoppit2.lxua")
        else
            print("No file to start found")
            -- set everything to red
            ws2812.write(string.char(0, 30, 0):rep(3))
        end
    end
end)
