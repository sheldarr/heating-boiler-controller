engine = {}

hysteresis = 2
fallingTime = 0
previousTemperature = 0

thresholds = {
    setpoint = 30.00,
    falling = 3600
}

function loop()
    sensor.read(
        function(temperature)
            print(temperature)

            if temperature <= previousTemperature then
                print('Temperature falling down')
                fallingTime = fallingTime + 1
                print(fallingTime)
            else
                print('Temperature rising up')
                fallingTime = 0
                print(fallingTime)
            end

            if fallingTime > thresholds.falling then
                fan.off()
            elseif temperature < thresholds.setpoint - hysteresis then
                fan.on()
            else
                fan.off()
            end

            previousTemperature = temperature
        end
    )
end

engine.start = function(interval)
    result = tmr.create():alarm(interval, tmr.ALARM_AUTO, loop)

    if result then
        print('Engine started')
    else
        print('Engine error')
    end
end

return engine
