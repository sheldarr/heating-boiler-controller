engine = {}

fallingTime = 0
previousTemperature = 0

thresholds = {
    setpoint = 30.00
}

function printTemperature(temperature)
    print(temperature)

    if temperature <= previousTemperature then
        print("Temperature falling down")
        fallingTime = fallingTime + 1
        print(fallingTime)
    else
        print("Temperature rising up")
        fallingTime = 0
        print(fallingTime)
    end

    if fallingTime > 10 then
        fan.off()
    elseif temperature < thresholds.setpoint then
        fan.on()
    else
        fan.off()
    end

    previousTemperature = temperature
end

function loop()
    sensor.read(printTemperature)
end

engine.start = function(interval)
    result = tmr.create():alarm(interval, tmr.ALARM_AUTO, loop)

    if result then
        print("Engine started")
    else
        print("Engine error")
    end
end

return engine
