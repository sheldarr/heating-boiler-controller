local config = require('config');
local fan = require('fan');
local sensors = require('sensors');

local engine = {}

inputTemperature = 0
outputTemperature = 0

local previousInputTemperature = 0
local previousOutputTemperature = 0
local rising = false;
local time = 0

function loop()
    local settings = config.load();

    sensors.read(function(measurement)
        previousOutputTemperature = outputTemperature
        outputTemperature = measurement.output

        previousInputTemperature = inputTemperature
        inputTemperature = measurement.input
    end)

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

    if (settings.mode == "FORCED_FAN_ON") then fan.on() end

    if (settings.mode == "FORCED_FAN_OFF") then fan.off() end

    print(string.format(
              '%s | %s | Output %.4f°C %s %is | Input %.4f°C | ⎎ %s°C | ◉ %s | H %s',
              settings.mode, fan.enabled and 'FAN ON' or 'FAN OFF',
              outputTemperature, rising and '↑' or '↓', time,
              inputTemperature, settings.hysteresis, settings.setpoint,
              node.heap()))

    previousOutputTemperature = outputTemperature
    previousInputTemperature = inputTemperature
end

engine.start = function(interval)
    tmr.create():alarm(interval, tmr.ALARM_AUTO, loop)
end

return engine
