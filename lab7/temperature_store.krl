ruleset temperature_store {

    meta {
        provides temperatures, threshold_violations, inrange_temperatures
        shares temperatures, threshold_violations, inrange_temperatures
    }

    global {
        //these functions should return an array of temperatures, where each temperature is a timestamp and a temperature value
        temperatures = function() {
            //return the contents of the temperature entity variable
            ent:temperatures.klog("temperatures")
        }

        threshold_violations = function() {
            //return the contents of the threshold_violation entity variable
            ent:threshold_violations.klog("threshold_violatios: ")
        }

        inrange_temperatures = function() {
            //return all the temperatures from ent:temperatures that are NOT in ent:threshold_violations
            ent:temperatures.difference(ent:threshold_violations)
        }
    }

    rule initialization { //I might not need this
        select when wrangler ruleset_added where event:attr("rids") >< meta:rid
        fired{
            ent:temperatures := []
            ent:threshold_violations := []
        }
    }
    
    rule collect_temperatures {
        select when wovyn new_temperature_reading
        //store the temperature and timestamp event attributes in an entity variable
        //this entity variable should contain ALL the temeratures that have been processed
        fired {
            ent:temperatures := ent:temperatures.append(event:attrs)
        }
    }

    rule collect_threshold_violations {
        select when wovyn threshold_violation
        //store the violation temperature and timestamp event attributes in an entity variable
        //this entity variable should contain ALL violations that have been processed
        fired {
            ent:threshold_violations := ent:threshold_violations.append(event:attrs)
        }
    }

    rule clear_temperatures {
        select when sensor reading_reset
        pre {
            message = "All temperatures have been cleared."
        }
        send_directive(message)
        fired{
            ent:temperatures := []
            ent:threshold_violations := []
        }
    }
}