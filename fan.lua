local PIN = 3

gpio.mode(PIN, gpio.OUTPUT)
gpio.write(PIN, gpio.HIGH)

fan = {}

fan.on = function()
    print('FAN ON')
    gpio.write(PIN, gpio.LOW)
end

fan.off = function()
    print('FAN OFF')
    gpio.write(PIN, gpio.HIGH)
end

return fan
