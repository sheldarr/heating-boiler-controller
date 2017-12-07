engine = {}

function loop()
    print("Loop")
end

engine.start = function(interval)
    result = tmr.create():alarm(interval, tmr.ALARM_SINGLE, loop)

    if result then
        print("Engine started")
    else
        print("Engine error")
    end
end

return engine
