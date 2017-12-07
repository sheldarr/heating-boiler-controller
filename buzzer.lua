BUZZER_PIN = 6
BUZZER_LENGTH = 500000

gpio.mode(BUZZER_PIN, gpio.OUTPUT)

buzzer = {}

buzzer.beep = function(length)
    buzzLength = length or BUZZER_LENGTH
    gpio.serout(BUZZER_PIN, gpio.LOW, {BUZZER_LENGTH, BUZZER_LENGTH})
end

return buzzer
