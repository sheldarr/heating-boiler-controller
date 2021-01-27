local t = require("ds18b20")
local SENSORS_PIN = 5

local OUTPUT_TEMP_SENSOR_ADDRESS = "28:D1:C4:77:0B:00:00:3F"
local INPUT_TEMP_SENSOR_ADDRESS = "28:D1:C4:77:0B:00:00:3F"

local sensors = {}

sensors.read = function(callback)
    t:read_temp(function(temp)
        local measurement = {}

        for addr, temp in pairs(temp) do
            local address = ('%02X:%02X:%02X:%02X:%02X:%02X:%02X:%02X'):format(
                                addr:byte(1, 8));

            if (address == OUTPUT_TEMP_SENSOR_ADDRESS) then
                measurement.output = temp
            end

            if (address == INPUT_TEMP_SENSOR_ADDRESS) then
                measurement.input = temp
            end
        end

        callback(measurement)
    end, SENSORS_PIN, t.C)
end

return sensors
