local PIN = 6
local LENGTH = 500000

gpio.mode(PIN, gpio.OUTPUT)

buzzer = {}

buzzer.beep = function(length)
    length = length or LENGTH
    gpio.serout(PIN, gpio.LOW, {length, length})
end

buzzer.error = function()
    gpio.serout(PIN, gpio.LOW, {LENGTH, LENGTH, LENGTH, LENGTH})
end

buzzer.success = function()
    gpio.serout(PIN, gpio.LOW, {LENGTH, LENGTH})
end

return buzzer
