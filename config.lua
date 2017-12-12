config = {}

local DEFAULT_SETPOINT = 30
local DEFAULT_HYSTERESIS = 2

files = file.list()
if not files['data'] then
    print('Config file does not exist!')
    print('Creating new config file...')
    if file.open('data', 'w') then
        file.close()
    end
end

config.load = function()
    print('Loading config...')

    local settings = {}

    if file.open('data') then
        settings.setpoint = tonumber(file.readline())

        file.close()
    end

    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS

    print(
        string.format(
            'Config loaded...\nSetpoint: %s\nHysteresis: %s',
            settings.setpoint,
            settings.hysteresis
        )
    )
    
    return settings
end

config.save = function(settings)
    print('Writing config...')
    
    settings = settings or {}
    settings.setpoint = settings.setpoint or DEFAULT_SETPOINT
    settings.hysteresis = settings.hysteresis or DEFAULT_HYSTERESIS

    if file.open('data', 'w+') then
        file.writeline(settings.setpoint)
        file.close()
    end

    print(
        string.format(
            'Config writed...\nSetpoint: %s\nHysteresis: %s',
            settings.setpoint,
            settings.hysteresis
        )
    )
end

return config
