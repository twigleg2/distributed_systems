ruleset manage_sensors {

    meta {
        use module io.picolabs.wrangler alias Wrangler
        use module io.picolabs.subscription alias Subscriptions
        use module temperature_store
        shares sensors, recent_reports
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
            Subscriptions:established("Tx_role","sensor")
        }

        recent_reports = function(wanted=5) {
            len = ent:reports.length()
            most_recent = ent:reports.slice(len-wanted, len-1)
            most_recent
        }

        find_report_index = function(cid) {
            cids = ent:reports.map(function(x){x.keys().head()})
            i = cids.index(cid)
            i.klog("index: ")
        }
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:sensors := {}
            ent:threshold := 80
            ent:SMS_number := "18017934946"
            ent:report_number := 0
            ent:reports := []
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
                    "rids": ["temperature_store","wovyn_base","sensor_profile", "sensor_subscriber"],
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
            raise sensor event "subscribe"
                attributes{"sensor_name": sensor_name, "eci": event:attr("eci")}
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
            raise wrangler event "subscription_cancellation"
                attributes {"Tx": get_eci(sensor_name)}
            ent:sensors := ent:sensors.delete(sensor_name)
        }
    }

    rule subscribe_sensor {
        select when sensor subscribe
        fired {
            raise wrangler event "subscription" attributes
                {
                    "name": event:attr("sensor_name"),
                    "Rx_role": "manager",
                    "Tx_role": "sensor",
                    "channel_type": "subscription",
                    "wellKnown_Tx": event:attr("eci")
                }
        }
    }

    rule subcribe_non_child {
        select when sensor subscribe_non_child
        fired {
            raise sensor event "subscribe"
                attributes{"sensor_name": event:attr("sensor_name"), "eci": event:attr("eci")} 
        }
    }

    rule generate_report {
        select when manager generate_report
        foreach Subscriptions:established("Tx_role", "sensor") setting(subscription)
        pre {
            cid = "report number: " + ent:report_number.as("String")
            number_of_sensors = Subscriptions:established("Tx_role", "sensor").length()
            pre_report_object = {}.put(
                cid, 
                {
                    "temperature_sensors": number_of_sensors,
                    "responses": 0,
                    "temperatures": []
                }
            )
        }
        event:send (
            {
                "eci": subscription{"Tx"},
                "eid": "report",
                "domain": "sensor",
                "type": "report",
                "attrs": {
                    "cid": cid
                }
            }
        )
        fired {
            ent:reports := ent:reports.append(pre_report_object) on final
            ent:report_number := ent:report_number + 1 on final
        }
    }

    rule receive_report {
        select when manager receive_report
        pre {
            eventattrs = event:attrs.klog("eventattrs: ")
            rx = eventattrs{"Rx"}.klog("Rx: ")
            cid = eventattrs{"cid"}.klog("cid: ")
            reported_temperatures = eventattrs{"temperatures"}.klog("reported_temperatures: ")
            reported_temps_obj = {}.put(rx, reported_temperatures)
            report_index = find_report_index(cid).klog("report_index: ")
            report = ent:reports[report_index].klog("report: ")
            temps_array = report{[cid, "temperatures"]}.klog("temps_array: ")
            num_responses = report{[cid, "responses"]}.klog("num_responses: ")
            new_num_responses = num_responses + 1 .klog("new_num_responses: ")
            new_temps_array = temps_array.append(reported_temps_obj).klog("new_temps_array")
            new_report = report.set([cid, "temperatures"], new_temps_array).set([cid, "responses"], new_num_responses).klog()
        }
        fired {
            ent:reports := ent:reports.splice(report_index, 1, new_report)
        }
    }
}