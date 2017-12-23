server = {}

server.start = function()
    wifi.setmode(wifi.STATION)
    
    local ipConfig = {
        ip = '192.168.0.164',
        netmask = '255.255.255.0',
        gateway = '192.168.0.1'
    }
    
    wifi.sta.setip(ipConfig)
    
    local stationConfig = {
        ssid = '',
        pwd = ''
    }
    
    wifi.sta.config(stationConfig)
    
    local server = net.createServer(net.TCP, 30)
    
    function onReceive(socket, data)
        buzzer.success()
        print(data)

        local method = string.gmatch(data, '%S+')()

        if (method == 'POST') then
            local bodyIndex = data:find('\n\r\n')

            if (bodyIndex) then
                local bodyContent = data:sub(bodyIndex)

                local iterator = string.gmatch(bodyContent, '%S+')

                local setpointText = iterator()

                local newSettings = {}

                if (setpointText) then
                    local setpoint = tonumber(setpointText)

                    print('setpoint ', setpoint)
                    newSettings.setpoint = setpoint
                end

            
                local hysteresisText = iterator()

                if (hysteresisText) then
                    local hysteresis = tonumber(hysteresisText)

                    print('hysteresis ', hysteresis)
                    newSettings.hysteresis = hysteresis
                end

                config.save(newSettings)
                settings = newSettings

                local message = string.format(
                    'Setpoint: %s°C\nHysteresis: %s°C\n',
                    settings.setpoint,
                    settings.hysteresis
                )

                socket:send('HTTP/1.1 200 OK\n')
                socket:send('Server: ESP8266 (nodemcu)\n')
                socket:send(string.format(
                    'Content-Length: %i\n\n',
                    message:len())
                )
                socket:send(message)

                return
            end

            socket:send('HTTP/1.1 400 Bad Request\n')
            socket:send('Server: ESP8266 (nodemcu)\n')
            socket:send('Content-Length: 0\n\n')

            return
        end

        local message = string.format(
            'Temperature %s°C\nSetpoint: %s°C\nHysteresis: %s°C\n',
            previousTemperature,
            settings.setpoint,
            settings.hysteresis
        )

        socket:send('HTTP/1.1 200 OK\n')
        socket:send('Server: ESP8266 (nodemcu)\n')
        socket:send(string.format(
            'Content-Length: %i\n\n',
            message:len())
        )
        socket:send(message)
    end
    
    if server then
        server:listen(80, function(socket)
            socket:on('receive', onReceive)
        end)
    end
end

return server
