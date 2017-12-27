dofile('led.lua');
dofile('buzzer.lua');
dofile('config.lua');
dofile('fan.lua');
dofile('sensor.lua');
dofile('engine.lua');
dofile('server.lua');

settings = config.load();
engine.start(1000);
server.start();

led.blink();
buzzer.success();

print(wifi.sta.getip())
