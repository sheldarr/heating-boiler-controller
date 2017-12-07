DS18B20_PIN = 5

ds18b20.setup(DS18B20_PIN)

sensor = {}

sensor.read = function(callback)
    ds18b20.read(
        function(index, rom, resolution, temperature)
            callback(temperature)
        end,
        {}
    )
end

return sensor
