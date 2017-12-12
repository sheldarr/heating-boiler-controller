engine = {}

hysteresis = 2
time = 0
previousTemperature = 0
rising = false;

thresholds = {
    falling = 3600
}

function loop()
    sensor.read(
        function(temperature)
            time = time + 1

            if rising then
                if temperature < previousTemperature then
                    time = 0
                    rising = false
                end

                if temperature < settings.setpoint then
                    fan.on()
                else
                    fan.off()
                end
            end

            if not rising then
                if temperature > previousTemperature then
                    time = 0
                    rising = true
                end

                if temperature < settings.setpoint - hysteresis then
                    fan.on()
                else
                    fan.off()
                end

                previousTemperature = temperature
            end

            print(string.format('%.4f %s %is', temperature, rising and '↑' or '↓', time))
            previousTemperature = temperature
        end
    )
end

engine.start = function(interval)
    result = tmr.create():alarm(interval, tmr.ALARM_AUTO, loop)

    if result then
        print('Engine started!')
    else
        print('Engine error!')
    end
end

return engine
