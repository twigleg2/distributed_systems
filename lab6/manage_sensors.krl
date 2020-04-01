ruleset manage_sensors {

    meta {
        shares sensors
    }

    global {
        build_url = function(sensor_name) {
            sensor_eci = sensor_name{"eci"}
            url = <<http://localhost:8080/sky/event/#{sensor_eci}/1/sensor/profile_updated>>
            url
        }

        build_params_obj = function(name) {
            {
                "name": name,
                "SMS_number": ent:SMS_number,
                "threshold": ent:threshold
            }
        }

        sensors = function() {
            ent:sensors
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:sensors := {}
            ent:threshold := 80
            ent:SMS_number := "+18017934946"
        }
    }

    rule sensor_exists {
        select when sensor new_sensor
        pre {
            sensor_name = event:attr("sensor_name")
            exists = ent:sensors >< sensor_name
            url = build_url(sensor_name);
            obj = build_params_obj(sensor_name)
        }
        if exists then
            http:post(url, form = obj) // TODO: no idea what I'm doing here
    }

    rule new_sensor {
        select when sensor new_sensor
        pre {
            sensor_name = event:attr("sensor_name")
            exists = ent:sensors >< sensor_name
        }
        if not exists then
            noop()
        fired {
            raise wrangler event "child_creation"
                attributes {
                    "name": sensor_name,
                    "color": "#e68181",
                    "rids": ["temperature_store","wovyn_base","sensor_profile"]
                }
        }
    }

    rule store_new_sensor {
        select when wrangler child_initialized
        pre {
            the_sensor = {"id": event:attr("id"), "eci": event:attr("eci")}
            sensor_name = event:attr("sensor_name")
        }
        if sensor_name.klog("found sensor_name")
        then noop()
        fired {
            ent:sensors{[sensor_name]} := the_sensor
        }
    }
}