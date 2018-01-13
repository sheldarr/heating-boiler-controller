dofile('config.lua');
settings = config.load();

dofile('led.lua');
dofile('buzzer.lua');
dofile('fan.lua');
dofile('sensor.lua');
dofile('engine.lua');
dofile('server.lua');

engine.start(3000);
server.start();

led.blink();
buzzer.success();

print(wifi.sta.getip())
