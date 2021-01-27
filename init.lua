local led = require('led');

local engine = require('engine');
local server = require('server');

engine.start(5000);
server.start();

led.blink();

print(wifi.sta.getip())
