local FAN_RELAY_PIN = 3
local FAN_POWER_SERVO_PIN = 7
local FAN_POWER_SERVO_CLOCK_HZ = 50
local FAN_POWER_SERVO_DUTY_MIN = 43
local FAN_POWER_SERVO_DUTY_MAX = 127.5

fan = {}

fan.enabled = false
fan.power = 50
fan.enabled = false

function calculateFanDuty(power)
    return 0.845 * power + FAN_POWER_SERVO_DUTY_MIN
end

gpio.mode(FAN_RELAY_PIN, gpio.OUTPUT)
gpio.write(FAN_RELAY_PIN, gpio.HIGH)
pwm.setup(FAN_POWER_SERVO_PIN, FAN_POWER_SERVO_CLOCK_HZ, calculateFanDuty(fan.power))
pwm.start(FAN_POWER_SERVO_PIN)

fan.on = function()
    fan.enabled = true
    gpio.write(FAN_RELAY_PIN, gpio.LOW)
end

fan.off = function()
    fan.enabled = false
    gpio.write(FAN_RELAY_PIN, gpio.HIGH)
end

fan.setPower = function(power)
    power = power > 100 and 100 or power
    power = power < 0 and 0 or power

    fan.power = power
    pwm.setduty(FAN_POWER_SERVO_PIN, calculateFanDuty(fan.power))
end

return fan
