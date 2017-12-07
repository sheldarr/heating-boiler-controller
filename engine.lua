engine = {}

thresholds = {
    setpoint = 24.00
}

function printTemperature(temperature)
    print(temperature)

    if temperature < thresholds.setpoint
    then
        print('TURN ON')
    else
        print('TURN OFF')
    end
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
