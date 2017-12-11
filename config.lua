config = {}

DEFAULT_SETPOINT = 40

files = file.list()
if not files['data'] then
    print('Config file does not exist!')
    print('Creating new config file...')
    if file.open('data', 'w') then
        file.close()
    end
end

config.load = function()
    print('Loading config')
    data = {}

    if file.open('config') then
        data.setpoint = tonumber(file.readline())

        file.close()
    end

    return data
end

config.save = function(data)
    data = data or {}
    data.setpoint = data.setpoint or DEFAULT_SETPOINT

    print('Writing config...')
    print(string.format('setpoint: %s', data.setpoint))
    
    if file.open('data', 'w+') then
        file.writeline(data.setpoint)
        file.close()
    end
end

return config
