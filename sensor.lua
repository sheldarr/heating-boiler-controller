DS18B20_PIN = 5

ds18b20.setup(DS18B20_PIN)

sensor = {};

sensor.read = function (interval)
    ds18b20.read(
        function(index, rom, resolution, temperature)
            return temperature;
        end,
        {}
    )
end

return sensor;
