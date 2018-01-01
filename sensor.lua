local OUTPUT_TEMPERATURE_SENSOR_PIN = 5
local INPUT_TEMPERATURE_SENSOR_PIN = 2

sensor = {}

sensor.readOutputTemperature = function(callback)
    ds18b20.setup(OUTPUT_TEMPERATURE_SENSOR_PIN)

    ds18b20.read(
        function(index, rom, resolution, temperature)
            callback(temperature)
        end,
        {}
    )
end

sensor.readInputTemperature = function(callback)
    ds18b20.setup(INPUT_TEMPERATURE_SENSOR_PIN)

    ds18b20.read(
        function(index, rom, resolution, temperature)
            callback(temperature)
        end,
        {}
    )
end

return sensor
