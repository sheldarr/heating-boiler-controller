local fan = require('fan');
local led = require('led');
local state = require('state');

local startServer = function()
    wifi.setmode(wifi.STATION)

    local ipConfig = {
        ip = '192.168.1.7',
        netmask = '255.255.255.0',
        gateway = '192.168.1.1'
    }

    wifi.sta.setip(ipConfig)

    local stationConfig = {ssid = '', pwd = ''}

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

                local newState = {}

                if (setpointText) then
                    local setpoint = tonumber(setpointText)

                    newState.setpoint = setpoint
                end

                local hysteresisText = iterator()

                if (hysteresisText) then
                    local hysteresis = tonumber(hysteresisText)

                    newState.hysteresis = hysteresis
                end

                local mode = iterator()

                if (mode == 'NORMAL' or mode == 'FORCED_FAN_ON' or mode ==
                    'FORCED_FAN_OFF') then newState.mode = mode end

                state.setState(newState);

                local message = string.format(
                                    '{"setpoint": %.4f, "hysteresis": %.4f, "mode": "%s"}',
                                    newState.setpoint, newState.hysteresis,
                                    newState.mode)

                socket:send('HTTP/1.1 200 OK\n')
                socket:send('Server: ESP8266 (nodemcu)\n')
                socket:send('Content-Type: application/json\n')
                socket:send(string.format('Content-Length: %i\n\n',
                                          message:len()))
                socket:send(message)

                return
            end

            socket:send('HTTP/1.1 400 Bad Request\n')
            socket:send('Server: ESP8266 (nodemcu)\n')
            socket:send('Content-Length: 0\n\n')

            return
        end

        local freshState = state.getState()

        local message = string.format(
                            '{"outputTemperature": %.4f, "inputTemperature": %.4f, "setpoint": %.4f, "hysteresis": %.4f, "mode": "%s", "fanOn": %s, "heap": %d}',
                            freshState.outputTemperature,
                            freshState.inputTemperature, freshState.setpoint,
                            freshState.hysteresis, freshState.mode,
                            fan.enabled and 'true' or 'false', node.heap())

        socket:send('HTTP/1.1 200 OK\n')
        socket:send('Server: ESP8266 (nodemcu)\n')
        socket:send('Content-Type: application/json\n')
        socket:send(string.format('Content-Length: %i\n\n', message:len()))
        socket:send(message)
    end

    if server then
        server:listen(80, function(socket)
            socket:on('receive', onReceive)
        end)
    end
end

startServer()

print(wifi.sta.getip())
