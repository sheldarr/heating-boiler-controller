local state = {}

local DEFAULT_MODE = 'NORMAL'
local DEFAULT_HYSTERESIS = 0.5
local ERROR_SETPOINT = -1
local NO_MEASUREMENT = 0

local getState = function()
    local freshState = {}

    local files = file.list()

    if not files['state'] then
        print('Creating new config file...')

        if file.open('state', 'w+') then
            file.writeline(DEFAULT_MODE)
            file.writeline(DEFAULT_HYSTERESIS)
            file.writeline(ERROR_SETPOINT)
            file.writeline(NO_MEASUREMENT)
            file.writeline(NO_MEASUREMENT)

            file.close()
        end
    end

    if file.open('state') then
        freshState.mode = file.readline():gsub("%s+", "")
        freshState.hysteresis = tonumber(file.readline())
        freshState.setpoint = tonumber(file.readline())
        freshState.outputTemperature = tonumber(file.readline())
        freshState.inputTemperature = tonumber(file.readline())

        file.close()
    end

    return freshState
end

local setState = function(newState)
    local previousState = getState()

    newState.mode = newState.mode or previousState.mode
    newState.hysteresis = newState.hysteresis or previousState.hysteresis
    newState.setpoint = newState.setpoint or previousState.setpoint
    newState.outputTemperature = newState.outputTemperature or
                                     previousState.outputTemperature
    newState.inputTemperature = newState.inputTemperature or
                                    previousState.inputTemperature

    if file.open('state', 'w+') then
        file.writeline(newState.mode)
        file.writeline(newState.hysteresis)
        file.writeline(newState.setpoint)
        file.writeline(newState.outputTemperature)
        file.writeline(newState.inputTemperature)
        file.close()
    end
end

state.getState = getState
state.setState = setState

return state
