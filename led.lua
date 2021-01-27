local PIN = 4
local LENGTH = 500000

gpio.mode(PIN, gpio.OUTPUT)

local led = {}

led.blink = function(length)
    length = length or LENGTH
    gpio.serout(PIN, gpio.LOW, {length, length})
end

return led
