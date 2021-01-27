local config = {}

local DEFAULT_SETPOINT = 30
local DEFAULT_HYSTERESIS = 2
local DEFAULT_MODE = 'NORMAL'

config.load = function()
    print('Loading config...')

    local settings = {}

    if file.open('data') then
        settings.setpoint = tonumber(file.readline())

        file.close()
    end

    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS
    settings.mode = settings.mode or DEFAULT_MODE

    print(string.format(
              'Config loaded...\nSetpoint: %s\nHysteresis: %s\n Mode: %s',
              settings.setpoint, settings.hysteresis, settings.mode))

    return settings
end

config.save = function(settings)
    print('Writing config...')

    settings = settings or {}
    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS
    settings.mode = settings.mode or DEFAULT_MODE

    if file.open('data', 'w+') then
        file.writeline(settings.setpoint)
        file.close()
    end

    print(string.format(
              'Config writed...\nSetpoint: %s\nHysteresis: %s\n Mode: %s',
              settings.setpoint, settings.hysteresis, settings.mode))
end

files = file.list()
if not files['data'] then
    print('Config file does not exist!')
    print('Creating new config file...')
    if file.open('data', 'w') then file.close() end
    config.save()
end

return config
