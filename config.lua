local config = {}

local DEFAULT_SETPOINT = 30
local DEFAULT_HYSTERESIS = 0.5
local DEFAULT_MODE = 'NORMAL'

config.load = function()
    local settings = {}

    if file.open('data') then
        settings.setpoint = tonumber(file.readline())

        file.close()
    end

    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS
    settings.mode = settings.mode or DEFAULT_MODE

    return settings
end

config.save = function(settings)
    settings = settings or {}
    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS
    settings.mode = settings.mode or DEFAULT_MODE

    if file.open('data', 'w+') then
        file.writeline(settings.setpoint)
        file.close()
    end
end

files = file.list()
if not files['data'] then
    if file.open('data', 'w') then file.close() end

    config.save()

    print('Default config created')
end

return config
