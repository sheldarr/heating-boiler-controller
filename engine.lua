engine = {}

outputTemperature = 0
previousOutputTemperature = 0
inputTemperature = 0
previousInputTemperature = 0
local rising = false;
local time = 0
local lastSensor = 'input'

function loop()
    if (lastSensor == 'input') then
        sensor.readOutputTemperature(
            function(temperature)
                previousOutputTemperature = outputTemperature
                outputTemperature = temperature
                lastSensor = 'output'
            end
        )
    end
    if (lastSensor == 'output') then
        sensor.readInputTemperature(
            function(temperature)
                previousInputTemperature = inputTemperature
                inputTemperature = temperature
                lastSensor = 'input'
            end
        )
    end

    time = time + 1

    if (settings.mode == "NORMAL") then
        if rising then
            if outputTemperature < previousOutputTemperature then
                time = 0
                rising = false
            end

            if outputTemperature < settings.setpoint then
                fan.on()
            else
                fan.off()
            end
        end

        if not rising then
            if outputTemperature > previousOutputTemperature then
                time = 0
                rising = true
            end

            if outputTemperature < settings.setpoint - settings.hysteresis then
                fan.on()
            else
                fan.off()
            end

            previousOutputTemperature = outputTemperature
        end
    end
    
    if(settings.mode == "FORCED_FAN_ON") then
        fan.on()
    end

    if(settings.mode == "FORCED_FAN_OFF") then
        fan.off()
    end

    print(string.format(
        '%s | %s | Output %.4f°C %s %is | Input %.4f°C | ⎎ %s°C',
        settings.mode,
        fan.enabled and 'FAN ON' or 'FAN OFF',
        outputTemperature,
        rising and '↑' or '↓',
        time,
        inputTemperature,
        settings.hysteresis
    ))

    previousOutputTemperature = outputTemperature
    previousInputTemperature = inputTemperature
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
