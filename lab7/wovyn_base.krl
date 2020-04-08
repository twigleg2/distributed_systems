ruleset wovyn_base {
    meta {
        use module io.picolabs.subscription alias Subscriptions
    }

    rule initialization {
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:temperature_threshold := 80
            ent:phone_number_to := "+18017934946"
            ent:phone_number_from := "+12256865973"
        }
    }

    rule process_hearbeat {
        select when wovyn heartbeat where event:attr("genericThing")
        pre{
            eventattrs = event:attrs
            genericThing = eventattrs{"genericThing"}
            data = genericThing{"data"}
            temperature = data{"temperature"}
        }
        fired{
        raise wovyn event "new_temperature_reading"
            attributes {"temperatureF": temperature[0]{"temperatureF"},
                        "temperatureC":temperature[0]{"temperatureC"},
                        "timestamp": time:now()}
        }
    }

    rule find_high_temps {
        select when wovyn new_temperature_reading
        pre {
            eventattrs = event:attrs
            temperatureF = eventattrs{"temperatureF"}
            above_threshold = temperatureF.klog("temperatureF: ") > ent:temperature_threshold.klog("ent: ")
            message = above_threshold => "Temperature Violation!"| "No Temperature Violation."
        }
        send_directive(message)
        fired {
            raise wovyn event "threshold_violation" 
                attributes event:attrs if above_threshold
        }
    }

    rule threshold_notification {
        select when wovyn threshold_violation
        foreach Subscriptions:established("Tx_role", "manager") setting(subscription)
        event:send(
            {
                "eci": subscription{"Tx"},
                "eid": "threshold-violation", //event id.  so far, mostly useless
                "domain": "threshold",
                "type": "violation",
                "temperatureF": event:attr{"temperatureF"}
            }
        )
    }

    rule profile_update {
        select when profile updated
        pre {
            eventattrs = event:attrs
            threshold = eventattrs{"threshold"}
            SMS_number = eventattrs{"SMS_number"}
        }
        fired {
            ent:temperature_threshold := threshold
            ent:phone_number_to := SMS_number
        }
    }
}