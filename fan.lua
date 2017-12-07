FAN_PIN = 3

gpio.mode(FAN_PIN, gpio.OUTPUT);

fan = {}

fan.on = function()
    print('FAN ON')
    gpio.write(FAN_PIN, gpio.LOW);
end

fan.off = function()
    print('FAN OFF')
    gpio.write(FAN_PIN, gpio.HIGH);
end

return fan
