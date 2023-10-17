local fan = require('fan');
local sensors = require('sensors');
local state = require('state');

local engine = {}

local previousOutputTemperature = 0
local rising = false;
local time = 0

local SECOND = 1000
local INTERVAL = 5 * SECOND

local readTemperaturesTimer = tmr.create()

readTemperaturesTimer:register(5000, tmr.ALARM_SEMI, function()
    sensors.read(function(measurement)
        local previousState = state.getState();

        previousOutputTemperature = previousState.outputTemperature

        state.setState({
            inputTemperature = measurement.input,
            outputTemperature = measurement.output
        })

        readTemperaturesTimer:start()
    end)
end)

readTemperaturesTimer:start()

function loop()
    local state = state.getState();

    time = time + 1

    if (state.mode == "NORMAL") then
        if rising then
            if state.outputTemperature < previousOutputTemperature then
                time = 0
                rising = false
            end

            if state.outputTemperature < state.setpoint then
                fan.on()
            else
                fan.off()
            end
        end

        if not rising then
            if state.outputTemperature > previousOutputTemperature then
                time = 0
                rising = true
            end

            if state.outputTemperature < state.setpoint - state.hysteresis then
                fan.on()
            else
                fan.off()
            end
        end
    end

    if (state.mode == "FORCED_FAN_ON") then fan.on() end

    if (state.mode == "FORCED_FAN_OFF") then fan.off() end

    print(string.format(
              '%s | %s | Output %.4f°C %s %is | Input %.4f°C | ⎎ %s°C | ◉ %s | H %s',
              state.mode, fan.enabled and 'FAN ON' or 'FAN OFF',
              state.outputTemperature, rising and '↑' or '↓', time * 5,
              state.inputTemperature, state.hysteresis, state.setpoint,
              node.heap()))
end

tmr.create():alarm(INTERVAL, tmr.ALARM_AUTO, loop)
