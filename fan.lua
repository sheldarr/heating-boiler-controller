local PIN = 3

gpio.mode(PIN, gpio.OUTPUT)
gpio.write(PIN, gpio.HIGH)

FAN_ON = false

fan = {}

fan.on = function()
    FAN_ON = true
    gpio.write(PIN, gpio.LOW)
end

fan.off = function()
    FAN_ON = false
    gpio.write(PIN, gpio.HIGH)
end

return fan
