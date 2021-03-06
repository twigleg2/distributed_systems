ruleset manage_sensors {

    meta {
        use module io.picolabs.wrangler alias Wrangler
        use module temperature_store
        shares sensors, collect_all_temps
    }

    global {
        get_eci = function(sensor_name) {
            sensor = ent:sensors{[sensor_name]}
            sensor{"eci"}
        }

        build_attrs_obj = function(name) {
            {
                "name": name,
                "SMS_number": ent:SMS_number,
                "threshold": ent:threshold
            }
        }

        sensors = function() {
            ent:sensors
        }

        collect_all_temps = function() {
            ent:sensors.map(function(k,v) {
                Wrangler:skyQuery(get_eci(v), "temperature_store", "temperatures", {}) // {} needed? idk.
            })
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:sensors := {}
            ent:threshold := 80
            ent:SMS_number := "18017934946"
        }
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
                    "rids": ["temperature_store","wovyn_base","sensor_profile"],
                    "sensor_name": sensor_name // This looks like a duplicate, but apparently the "name" isn't passed back from the wrangler:child_initialized event, but this is.
                }
        }
    }

    rule sensor_exists {
        select when sensor new_sensor
        pre {
            sensor_name = event:attr("sensor_name")
            exists = ent:sensors >< sensor_name
        }
        if exists then
            send_directive("sensor ready", {"sensor_name": sensor_name})
    }

    rule store_new_sensor {
        select when wrangler child_initialized
        pre {
            the_sensor = {"id": event:attr("id"), "eci": event:attr("eci")}
            sensor_name = event:attr("sensor_name")
        }
        if sensor_name.klog("found sensor_name: ") then
            noop()
        fired {
            ent:sensors{[sensor_name]} := the_sensor
            raise sensor event "update_new_sensor"
                attributes{"sensor_name": sensor_name}
        }
    }

    rule update_new_sensor {
        select when sensor update_new_sensor
        pre {
            sensor_name = event:attr("sensor_name")
            eci = get_eci(sensor_name)
            obj = build_attrs_obj(sensor_name).klog("obj: ")
        }
        event:send({"eci":eci, "domain":"sensor", "type":"profile_updated", "attrs":obj})
    }

    rule delete_sensor {
        select when sensor unneeded_sensor
        pre {
            sensor_name = event:attr("sensor_name")
            exists = ent:sensors >< sensor_name
        }
        if exists then
            send_directive("sensor deleted", {"sensor_name": sensor_name})
        fired {
            raise wrangler event "child_deletion"
                attributes {"name": sensor_name}
            ent:sensors := ent:sensors.delete(sensor_name)
        }
    }
}