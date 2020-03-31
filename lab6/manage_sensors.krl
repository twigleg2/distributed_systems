ruleset manage_sensors_practice {

    global {
        nameFromID = function(sensor_number) {
            "Sensor #" + sensor_number
        }
    }

    rule new_sensor {
        select when sensor new_sensor
        pre {
            sensor_number = event:attr("sensor_number") //TODO: from the tutorial, names need to be changed
            exists = ent:sensors >< sensor_number
            eci = meta:eci
        }
        if exists then
            send_directive("sensor ready", {"sensor_number": sensor_number})
        notfired {
            ent:sensors := ent:sensors.defaultsTo([]).union([sensor_number])
            raise wrangler event "child_creation"
                attributes {"name": nameFromID(sensor_number), "color": "#e68181"}
        }
    }
}