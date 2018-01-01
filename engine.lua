engine = {}

previousTemperature = 0
local rising = false;
local time = 0

function loop()
    sensor.read(
        function(temperature)
            time = time + 1

            if(settings.mode == "NORMAL") then
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

                    if temperature < settings.setpoint - settings.hysteresis then
                        fan.on()
                    else
                        fan.off()
                    end

                    previousTemperature = temperature
                end
            end
            
            if(settings.mode == "FORCED_FAN_ON") then
                fan.on()
            end

            if(settings.mode == "FORCED_FAN_OFF") then
                fan.off()
            end

            print(string.format('%s %s %.4f°C %s %is', settings.mode, FAN_ON and 'FAN ON' or 'FAN OFF', temperature, rising and '↑' or '↓', time))
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
