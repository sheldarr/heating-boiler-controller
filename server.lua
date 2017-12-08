server = {}

server.start = function()
    wifi.setmode(wifi.STATION)
    
    ipConfig = {
        ip = "192.168.0.164",
        netmask = "255.255.255.0",
        gateway = "192.168.0.1"
    }
    
    wifi.sta.setip(ipConfig)
    
    stationConfig = {
        ssid = "",
        pwd = ""
    }
    
    wifi.sta.config(stationConfig)
    
    server = net.createServer(net.TCP, 30)
    
    function onReceive(socket, data)
        buzzer.beep()
        print(data)

        print('RES HTTP/1.1 200 OK')
        print(string.format(
            "Temperature: %f °C",
            previousTemperature
        ))

        fixedTemperature = string.format(
            "%.4f",
            previousTemperature
        );

        socket:send("HTTP/1.1 200 OK\n")
        socket:send("Server: ESP8266 (nodemcu)\n")
        socket:send(string.format(
            "Content-Length: %i\n\n",
            fixedTemperature:len())
        )
        socket:send(fixedTemperature)
    end
    
    if server then
        server:listen(80, function(socket)
            socket:on("receive", onReceive)
        end)
    end
end

return server
