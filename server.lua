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
        print(data)
    
        ds18b20.read(
            function(index, rom, resolution, temperature)
                beep()
                local message = string.format(
                    "Index: %d Resolution: %d Temperature: %f °C",
                    index,
                    resolution,
                    temperature
                )
                
                print(message)
                
                fixedTemperature = string.format(
                    "%.4f",
                    temperature
                );
    
                socket:send("HTTP/1.1 200 OK\n")
                socket:send("Server: ESP8266 (nodemcu)\n")
                socket:send(string.format(
                    "Content-Length: %i\n\n",
                    fixedTemperature:len())
                )
                socket:send(fixedTemperature)
            end,
            {}
        )
    end
    
    if server then
        server:listen(80, function(socket)
            socket:on("receive", onReceive)
        end)
    end
end

return server
