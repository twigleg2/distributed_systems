ruleset wovyn_base {

    meta {
        use module twilio_keys
        use module twilio_v2
            with account_sid = keys:twilio{"account_sid"}
                 auth_token = keys:twilio{"auth_token"}
    }

    rule initialization {
        select when wrangler ruleset_added where event:attrs("rids") >< meta:rid
        fired{
            ent:temperature_threshold := 80
            ent:phone_number_to := "+18017934946"
            ent:phone_number_from := "+12256865973"
        }
    }

    rule process_hearbeat {
        select when wovyn heartbeat where event:attr("genericThing")
        pre{
            eventattrs = event:attrs.klog("eventattrs:")
            genericThing = eventattrs{"genericThing"}.klog("genericThing:")
            decoded = genericThing.decode().klog("decoded:") //TODO: I might not need to decode when I use the real event
            data = decoded{"data"}.klog("data:")
            temperature = data{"temperature"}.klog("temperature:")
            timestamp = "a timestamp goes here"
        }
        fired{
        raise wovyn event "new_temperature_reading"
            attributes {"temperature": temperature, "timestamp": timestamp}
        }
    }

    rule find_high_temps {
        select when wovyn new_temperature_reading
        pre {
            eventattrs = event:attrs.klog("eventattrs:")
            temperature = eventattrs{"temperature"}.klog("temperature:")
            temperatureF = temperature[0]{"temperatureF"}.klog("temperatureF:")
            above_threshold = temperatureF > ent:temperature_threshold
        }
        // choose above_threshold{
        //     true => send_directive("Temperature Violation!")
        //     false => send_directive("No Temperature Violation.")
        // }
        fired {
            raise wovyn event "threshold_violation" 
                attributes event:attrs if above_threshold
        }
    }

    rule threshold_notification {
        select when wovyn threshold_violation
        pre {
            eventattrs = event:attrs.klog("eventattrs:")
            temperature = eventattrs{"temperature"}.klog("temperature:")
            temperatureF = temperature[0]{"temperatureF"}.klog("temperatureF:")
            message = "Temperature sensor threshold violation!\nCurrent temperature: " + temperatureF

        }
        twilio_v2:send_sms(
            ent:phone_number,
            ent:phone_number_from,
            message
        )
    }
}