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
        led.blink()
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

                local mode = iterator()

                if (mode == 'NORMAL' or mode == 'FORCED_FAN_ON' or mode == 'FORCED_FAN_OFF') then
                    print('mode ', mode)
                    newSettings.mode = mode
                end

                config.save(newSettings)
                settings = newSettings

                local message = string.format(
                    '{"setpoint": %.4f, "hysteresis": %.4f, "mode": "%s"}',
                    settings.setpoint,
                    settings.hysteresis,
                    settings.mode
                )

                socket:send('HTTP/1.1 200 OK\n')
                socket:send('Server: ESP8266 (nodemcu)\n')
                socket:send('Content-Type: application/json\n')
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
            '{"outputTemperature": %.4f, "inputTemperature": %.4f, "setpoint": %.4f, "hysteresis": %.4f, "mode": "%s", "fanOn": %s}',
            outputTemperature,
            inputTemperature,
            settings.setpoint,
            settings.hysteresis,
            settings.mode,
            FAN_ON and 'true' or 'false'
        )

        socket:send('HTTP/1.1 200 OK\n')
        socket:send('Server: ESP8266 (nodemcu)\n')
        socket:send('Content-Type: application/json\n')
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
