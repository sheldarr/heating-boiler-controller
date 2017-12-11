DS18B20_PIN = 5
BUZZER_PIN = 6
BUZZER_LENGTH = 500000

gpio.mode(BUZZER_PIN, gpio.OUTPUT)
ds18b20.setup(DS18B20_PIN)

dofile('buzzer.lua');
dofile('config.lua');
dofile('fan.lua');
dofile('sensor.lua');
dofile('engine.lua');
dofile('server.lua');

engine.start(1000);
server.start();

buzzer.beep();

print(wifi.sta.getip())
