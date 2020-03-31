ruleset manage_sensors {

    global {
        nameFromID = function(sensor_number) {
            "Sensor #" + sensor_number
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:sensors := {}
        }
    }

    rule sensor_exists {
        select when sensor new_sensor
        pre {
            sensor_number = event:attr("sensor_number")
            exists = ent:sensors >< sensor_number
        }
        if exists then
            send_directive("sensor ready", {"sensor_number": sensor_number})
    }

    rule new_sensor {
        select when sensor new_sensor
        pre {
            sensor_number = event:attr("sensor_number")
            exists = ent:sensors >< sensor_number
        }
        if not exists then
            noop()
        fired {
            raise wrangler event "child_creation"
                attributes {
                    "name": nameFromID(sensor_number),
                    "color": "#e68181",
                    "sensor_number": sensor_number
                }
        }
    }

    rule store_new_sensor {
        select when wrangler child_initialized
        pre {
            the_sensor = {"id": event:attr("id"), "eci": event:attr("eci")}
            sensor_number = event:attr("sensor_number")
        }
        if sensor_number.klog("found sensor_number")
        then noop()
        fired {
            ent:sensors{[sensor_number]} := the_sensor
        }
    }
}