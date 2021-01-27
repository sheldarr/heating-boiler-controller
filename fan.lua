local FAN_RELAY_PIN = 3

local fan = {}

fan.enabled = false

gpio.mode(FAN_RELAY_PIN, gpio.OUTPUT)
gpio.write(FAN_RELAY_PIN, gpio.HIGH)

fan.on = function()
    fan.enabled = true
    gpio.write(FAN_RELAY_PIN, gpio.LOW)
end

fan.off = function()
    fan.enabled = false
    gpio.write(FAN_RELAY_PIN, gpio.HIGH)
end

return fan
